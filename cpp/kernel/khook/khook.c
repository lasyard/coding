#include <linux/kallsyms.h>
#include <linux/kernel.h>
#include <linux/kprobes.h>
#include <linux/module.h>
#include <linux/syscalls.h>

#ifndef __x86_64__
#error "only x86-64 arch is supported"
#endif

#define MOD_NAME "khook"

typedef unsigned long f_kallsyms_lookup_name_t(const char *name);

static f_kallsyms_lookup_name_t *f_kallsyms_lookup_name;

typedef long hook_fun(struct pt_regs *regs);

static hook_fun *g_sys_read;

static struct ftrace_ops ops;

static bool is_task(const char *name)
{
    char task_comm[TASK_COMM_LEN];
    get_task_comm(task_comm, current);
    if (strncmp(task_comm, name, TASK_COMM_LEN)) {
        return false;
    }
    return true;
}

static bool is_file(int fd, const char *name)
{
    struct file *file = NULL;
    char *buf;
    char *pathname;
    struct path *path;
    file = fget(fd);
    path = &file->f_path;
    path_get(path);
    buf = (char *)kmalloc(PAGE_SIZE, GFP_KERNEL);
    if (!buf) {
        path_put(path);
        return false;
    }
    pathname = d_path(path, buf, PAGE_SIZE);
    path_put(path);
    if (IS_ERR(pathname)) {
        kfree(buf);
        return false;
    }
    pr_info(MOD_NAME ": check file \"%s\"\n", pathname);
    if (strncmp(pathname, name, PAGE_SIZE)) {
        kfree(buf);
        return false;
    }
    kfree(buf);
    return true;
}

static asmlinkage long m_read(struct ftrace_regs *regs)
{
    struct pt_regs *r = arch_ftrace_get_regs(regs);
    int fd = r->di;                          // 1st para
    char __user *buf = (char __user *)r->si; // 2nd para
    size_t len = r->dx;                      // 3rd para
    pr_info(MOD_NAME ": call %s\n", __func__);
    pr_info(MOD_NAME ": (fd = %x, buf = %px, len = %ld)\n", fd, buf, len);
    if (is_file(fd, "/dev/null")) {
        pr_info(MOD_NAME ": read /dev/null\n");
        if (len > 6) {
            len = 6;
        }
        if (!copy_to_user(buf, "Hello\n", len)) {
            return len;
        };
        return -1;
    }
    return ((hook_fun *)g_sys_read)(r);
}

static void notrace
f_callback(unsigned long ip, unsigned long parent_ip, struct ftrace_ops *op, struct ftrace_regs *regs)
{
    // if called in this module, do nothing or crash
    if (within_module(parent_ip, THIS_MODULE)) {
        return;
    }
    // in this function regs is not populated to the paras of syscall
    if (is_task("cat")) {
        pr_info("ip = %pS, parent-ip = %pS, address = %pS\n", (void *)ip, (void *)parent_ip, g_sys_read);
        ftrace_instruction_pointer_set(regs, (unsigned long)m_read);
    }
}

static void install_hook(void *address, struct ftrace_ops *ops)
{
    int err;
    ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY;
    if ((err = ftrace_set_filter_ip(ops, (unsigned long)address, 0, 0))) {
        pr_err(MOD_NAME ": ftrace_set_filter_ip() failed: %d\n", err);
        return;
    }
    if ((err = register_ftrace_function(ops))) {
        pr_err(MOD_NAME ": register_ftrace_function() failed: %d\n", err);
        ftrace_set_filter_ip(ops, (unsigned long)address, 1, 0);
        return;
    }
    return;
}

static void uninstall_hook(void *address, struct ftrace_ops *ops)
{
    int err;
    if ((err = unregister_ftrace_function(ops))) {
        pr_err(MOD_NAME ": unregister_ftrace_function() failed: %d\n", err);
    }
    if ((err = ftrace_set_filter_ip(ops, (unsigned long)address, 1, 0))) {
        pr_err(MOD_NAME ": ftrace_set_filter_ip() failed: %d\n", err);
    }
}

static int __init khook_init(void)
{
    struct kprobe kp = {
        .symbol_name = "kallsyms_lookup_name",
    };
    const char *name = "__x64_sys_read";
    ops.func = f_callback;
    pr_info(MOD_NAME ": call %s\n", __func__);
    register_kprobe(&kp);
    f_kallsyms_lookup_name = (f_kallsyms_lookup_name_t *)kp.addr;
    unregister_kprobe(&kp);
    if (!f_kallsyms_lookup_name) {
        pr_err(MOD_NAME ": probe symbol \"kallsyms_lookup_name\" failed\n");
        return -1;
    }
    g_sys_read = (void *)f_kallsyms_lookup_name(name);
    if (!g_sys_read) {
        pr_err(MOD_NAME ": cannot get address of \"%s\"\n", name);
        return -1;
    }
    install_hook(g_sys_read, &ops);
    return 0;
}

static void __exit khook_exit(void)
{
    pr_info(MOD_NAME ": call %s\n", __func__);
    uninstall_hook(g_sys_read, &ops);
}

module_init(khook_init);
module_exit(khook_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Kernel function hook");
MODULE_AUTHOR("Yueguang Jiao");
