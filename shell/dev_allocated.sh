#!/usr/bin/env bash
set -euo pipefail

DEVICE_NAME="${1:-nvidia.com/gpu}"

# report per-node DEV capacity, allocatable and allocated (only count Running pods)
# prints OVERCOMMIT when allocated > allocatable

FORMAT="%-24s %11s %11s %11s %s\n"

printf "$FORMAT" "NODE" "CAPACITY" "ALLOCATABLE" "ALLOCATED" "NOTE"

for node in $(kubectl get nodes -o name | sed 's|node/||'); do
    cap=$(kubectl get node "$node" -o go-template="{{with index .status.capacity \"$DEVICE_NAME\"}}{{.}}{{else}}0{{end}}" 2>/dev/null || echo 0)
    alloc=$(kubectl get node "$node" -o go-template="{{with index .status.allocatable \"$DEVICE_NAME\"}}{{.}}{{else}}0{{end}}" 2>/dev/null || echo 0)

    # sum DEV requests only for pods in Running phase on this node
    allocated=$(kubectl get pods --all-namespaces --field-selector spec.nodeName="$node",status.phase=Running \
        -o go-template="{{range .items}}{{range .spec.containers}}{{with .resources.requests}}{{with index . \"$DEVICE_NAME\"}}{{.}}{{\"\\n\"}}{{end}}{{end}}{{end}}{{end}}" |
        awk '{s+=($1==""?0:$1)} END{print s+0}')

    note=""
    # ensure numeric values for comparison
    alloc_n=${alloc:-0}
    allocated_n=${allocated:-0}
    if [ "$allocated_n" -gt "$alloc_n" ]; then
        note="OVERCOMMIT"
    fi

    printf "$FORMAT" "$node" "${cap:-0}" "${alloc_n}" "${allocated_n}" "${note}"
done

exit 0
