# Kubernetes + Istio Service Mesh + Ingress

---

# 🏗 1️⃣ Architecture Overview

```text
                        Internet
                           ↓
                   Istio Ingress Gateway
                           ↓
                       Frontend
                           ↓
                        Backend
                     (v1 / v2 split)
```

Detailed flow:

```text
Browser
   ↓
Istio Ingress (Envoy)
   ↓
Frontend Pod (Envoy Sidecar)
   ↓
Backend Service
   ↓
Backend v1 / v2 (Envoy Sidecars)
```

---

# 📦 2️⃣ Prerequisites

* Docker Desktop with Kubernetes enabled
* kubectl
* Helm
* Docker installed
* Go images built locally:

  * `go-mesh-demo:backend`
  * `go-mesh-demo:frontend`

---

# 🟢 3️⃣ Create Namespace

```bash
kubectl create namespace go-mesh
kubectl label namespace go-mesh istio-injection=enabled
```

Verify:

```bash
kubectl get ns go-mesh --show-labels
```

Must show:

```
istio-injection=enabled
```

---

# 🟢 4️⃣ Install Istio Using Helm

## Add Repo

```bash
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
```

---

## Create Istio Namespace

```bash
kubectl create namespace istio-system
```

---

## Install Base (CRDs)

```bash
helm install istio-base istio/base -n istio-system
```

---

## Install Control Plane

```bash
helm install istiod istio/istiod -n istio-system --set profile=demo
```

Verify:

```bash
kubectl get pods -n istio-system
```

---

## Install Ingress Gateway

```bash
helm install istio-ingress istio/gateway -n istio-system
```

Check service:

```bash
kubectl get svc -n istio-system
```

In Docker Desktop:

```
TYPE: LoadBalancer
EXTERNAL-IP: localhost
PORT: 80
```

---

# 🟢 5️⃣ Deploy Backend (v1 + v2)

## backend.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-v1
  namespace: go-mesh
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
      version: v1
  template:
    metadata:
      labels:
        app: backend
        version: v1
    spec:
      containers:
      - name: backend
        image: go-mesh-demo:backend
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
        env:
        - name: RESPONSE_MESSAGE
          value: "Hello from Backend V1 🚀"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-v2
  namespace: go-mesh
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
      version: v2
  template:
    metadata:
      labels:
        app: backend
        version: v2
    spec:
      containers:
      - name: backend
        image: go-mesh-demo:backend
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
        env:
        - name: RESPONSE_MESSAGE
          value: "Hello from Backend V2 🚀"
---
apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: go-mesh
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 8080
```

Apply:

```bash
kubectl apply -f backend.yaml
```

---

# 🟢 6️⃣ Deploy Frontend

## frontend.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: go-mesh
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: go-mesh-demo:frontend
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8081
        env:
        - name: BACKEND_URL
          value: "http://backend/hello"
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: go-mesh
spec:
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 8081
```

Apply:

```bash
kubectl apply -f frontend.yaml
```

Verify pods:

```bash
kubectl get pods -n go-mesh
```

All must show:

```
2/2 Running
```

Sidecar injected ✅

---

# 🟢 7️⃣ Create Istio Gateway

Important: match Helm label (`istio=ingress`).

## gateway.yaml

```yaml
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: go-gateway
  namespace: go-mesh
spec:
  selector:
    istio: ingress
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
```

Apply:

```bash
kubectl apply -f gateway.yaml
```

---

# 🟢 8️⃣ Expose Frontend via VirtualService

## frontend-virtualservice.yaml

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: frontend
  namespace: go-mesh
spec:
  hosts:
  - "*"
  gateways:
  - go-gateway
  http:
  - route:
    - destination:
        host: frontend
        port:
          number: 80
```

Apply:

```bash
kubectl apply -f frontend-virtualservice.yaml
```

---

# 🟢 9️⃣ Control Backend Traffic (Service Mesh Feature)

## DestinationRule

```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: backend
  namespace: go-mesh
spec:
  host: backend
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```

Apply:

```bash
kubectl apply -f destinationrule.yaml
```

---

## VirtualService for Backend Routing

### 100% to v1

```yaml
http:
- route:
  - destination:
      host: backend
      subset: v1
    weight: 100
```

### 50/50 Split

```yaml
http:
- route:
  - destination:
      host: backend
      subset: v1
    weight: 50
  - destination:
      host: backend
      subset: v2
    weight: 50
```

Apply each time to test.

---

# 🌐 10️⃣ Access Application

Open:

```
http://localhost
```

Refresh multiple times.

You will see traffic behavior based on weights.

---

# 🔐 11️⃣ Optional: Enable STRICT mTLS

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: go-mesh
spec:
  mtls:
    mode: STRICT
```

---

# 🧠 Final Architecture Summary

```text
Control Plane:
  istiod

Data Plane:
  Envoy Sidecars (frontend + backend)

Ingress:
  Istio Ingress Gateway

Traffic Control:
  VirtualService + DestinationRule

Security:
  mTLS
```

---

# 🚀 What This Setup Demonstrates

✔ Ingress routing
✔ Service mesh internal routing
✔ Version-based traffic splitting
✔ Canary deployment
✔ Sidecar injection
✔ Zero code change traffic control

---

