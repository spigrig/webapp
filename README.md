# 🚀 Hello Web App

This repository contains a **simple customizable web application** that displays "Hello, <name>" where the name is configurable via Helm values.

---

## 🧱 Project Structure

```
.
├── app/                      # Python app and Dockerfile
│   ├── Dockerfile
│   └── app.py
└── chart/                    # Helm chart for deploying the app
```

---

## 🐳 Build and Push Docker Image

Ensure Docker is running and you're logged into DockerHub:

```bash
cd webapp/app
docker context use default
docker build -t spigrig/hello-spyros:latest .
docker push spigrig/hello-spyros:latest
```

---

## 📦 Helm Chart Setup

If not already created:

```bash
cd webapp
helm create chart
```

Customize these files:

- `chart/values.yaml`:


```yaml
replicaCount: 1

image:
  repository: spigrig/hello-spyros
  pullPolicy: IfNotPresent
  tag: latest

env:
  name: Spyros

service:
  type: NodePort
  port: 5000

serviceAccount:
  create: false
  name: ""

ingress:
  enabled: false

resources: {}

autoscaling:
  enabled: false

nodeSelector: {}
tolerations: []
affinity: []
```

- `chart/templates/deployment.yaml`: Add environment variable inside the container spec after ports section:

```yaml
          env:
            - name: NAME
              value: "{{ .Values.env.name }}"
```

---

## 🧹 Delete unnecessary files from the default chart

```bash
rm chart/templates/hpa.yaml chart/templates/ingress.yaml chart/templates/serviceaccount.yaml chart/templates/tests/test-connection.yaml
```
---
