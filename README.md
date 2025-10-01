# Helmcraf

```sh
brew install kind
```

```sh
kind create cluster --name=dev
kind create cluster --name=stage
```

```sh
kind get clusters
```

```env
KUBE_CLUSTER_SERVER_MAP='kind-dev https://dev-control-plane:6443;kind-stage https://stage-control-plane:6443'
KUBE_CONTEXT_LOCAL_DEVELOP=kind-dev
KUBE_CONTEXT_LOCAL_STAGING=kind-stage
```

```sh
docker compose run --build --rm terminal
```

```sh
helmfile list
helmfile etch
```

```sh
helmfile -lcontext=$KUBE_CONTEXT_LOCAL_DEVELOP --skip-deps diff --context=1
helmfile -lcontext=$KUBE_CONTEXT_LOCAL_DEVELOP --skip-deps apply
```
