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
cd app
docker context use default
docker build -t spigrig/hello-spyros:latest .
docker push spigrig/hello-spyros:latest
```

---

## 📦 Helm Chart Setup

If not already created:

```bash
cd /webapp
helm create chart
```

Customize these files:

- `chart/values.yaml`:

```yaml
image:
  repository: spigrig/hello-spyros
  tag: latest
  pullPolicy: IfNotPresent

env:
  name: Spyros
```

- `chart/templates/deployment.yaml`: Add environment variable inside the container spec:

```yaml
        env:
        - name: NAME
          value: "{{ .Values.env.name }}"
```

---

## 🚀 Deploy with Helm

```bash
helm install hello-spyros ./chart
```

Or upgrade if already installed:

```bash
helm upgrade hello-spyros ./chart
```

---

## 🧹 Clean Up

```bash
helm uninstall hello-spyros
```

---