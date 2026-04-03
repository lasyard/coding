from collections import Counter

import socket
import time

import ray

ray.init()

print('''This cluster consists of
    {} nodes in total
    {} CPU resources in total
'''.format(len(ray.nodes()), ray.cluster_resources()['CPU']))

@ray.remote(num_cpus=1)
def f():
    time.sleep(1)
    # return hostname
    return socket.gethostname()

object_ids = [f.remote() for _ in range(48)]
hostnames = ray.get(object_ids)

print('Tasks executed')
for hostname, num_tasks in Counter(hostnames).items():
    print('    {} tasks on {}'.format(num_tasks, hostname))
