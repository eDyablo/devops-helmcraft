# Helmcraft

## Prerequisites

#### Docker + docker compose

##### Rancher Desktop

Kubernetes and container management on the desktop.

###### On Mac with Homebrew

```sh
brew install rancher-desktop
```

#### Kind

Run local Kubernetes cluster in Docker.

###### On Mac with Homebrew

```sh
brew install kind
```

## Getting started

### Prepare environment

##### Create local Kubernetes clusters

Create two local clusters named `dev` and `stage`.

```sh
kind create cluster --name=dev
kind create cluster --name=stage
```

##### **.env** file

The following is an example of .env file.

```env
KUBE_CLUSTER_SERVER_MAP='kind-dev https://dev-control-plane:6443;kind-stage https://stage-control-plane:6443'
KUBE_CONTEXT_LOCAL_DEVELOP=kind-dev
KUBE_CONTEXT_LOCAL_STAGING=kind-stage
```

###### Configure AWS and Kubectl

Additionaly define paths for AWS CLI and Kubectl configurations. The following are default and do not needed to be redefined if the same.

```env
HOST_AWS_PATH=~/.aws
HOST_KUBE_CONFIG_PATH=-~/.kube/config
```

###### Configure container image registry

```env
GLOBAL_CONTAINER_IMAGE_REGISTRY=acme.docker.io
```

### Usage

#### Run terminal

Run autodisposable interactive container
```sh
docker compose run --build --rm terminal
```

#### Check environment

```sh
kubectl --context=$KUBE_CONTEXT_LOCAL_DEVELOP cluster-info
```
```sh
kubectl --context=$KUBE_CONTEXT_LOCAL_STAGE cluster-info
```

#### Tools

##### K9s

Kubernetes CLI To Manage Your Clusters In Style!

```sh
k9s
```

```sh
k9s --context $KUBE_CONTEXT_LOCAL_DEVELOP
```

##### Screen

A command-line utility for creating and managing multiple terminal sessions.

Start a session.
```sh
screen
```

To create a new window press `Ctrl+a` then `c`.

To switch to next existing window press `Ctrl+a` then `n`.

To switch to previous existing window press `Ctrl+a` then `p`.

To switch to specific window press `Ctrl+a` then a number `(0–9)`.

To detach from screen press `Ctrl+a` then `d`.

Reattach to the screen via command.
```sh
screen -r
```

#### Basic actions

```sh
helmfile -lcontext=$KUBE_CONTEXT_LOCAL_DEVELOP list
```

```sh
helmfile -lcontext=$KUBE_CONTEXT_LOCAL_DEVELOP fetch
```

```sh
helmfile -lcontext=$KUBE_CONTEXT_LOCAL_DEVELOP --skip-deps diff --context=1
```

```sh
helmfile -lcontext=$KUBE_CONTEXT_LOCAL_DEVELOP --skip-deps apply --skip-diff-on-install
```
