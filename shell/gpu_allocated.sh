#!/usr/bin/env bash
set -euo pipefail

# report per-node GPU capacity, allocatable and allocated (only count Running pods)
# prints OVERCOMMIT when allocated > allocatable

printf "%-16s %8s %12s %12s %s\n" "NODE" "GPU_CAP" "GPU_ALLOCATABLE" "GPU_ALLOCATED" "NOTE"

for node in $(kubectl get nodes -o name | sed 's|node/||'); do
    cap=$(kubectl get node "$node" -o jsonpath='{.status.capacity.nvidia\.com/gpu}' 2>/dev/null || echo 0)
    alloc=$(kubectl get node "$node" -o jsonpath='{.status.allocatable.nvidia\.com/gpu}' 2>/dev/null || echo 0)

    # sum GPU requests only for pods in Running phase on this node
    allocated=$(kubectl get pods --all-namespaces --field-selector spec.nodeName="$node",status.phase=Running \
        -o jsonpath='{range .items[*]}{range .spec.containers[*]}{.resources.requests.nvidia\.com/gpu}{"\n"}{end}{end}' |
        awk '{s+=($1==""?0:$1)} END{print s+0}')

    note=""
    # ensure numeric values for comparison
    alloc_n=${alloc:-0}
    allocated_n=${allocated:-0}
    if [ "$allocated_n" -gt "$alloc_n" ]; then
        note="OVERCOMMIT"
    fi

    printf "%-16s %8s %12s %12s %s\n" "$node" "${cap:-0}" "${alloc:-0}" "${allocated:-0}" "$note"
done

exit 0
