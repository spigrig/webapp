# 🚀 Hello Web App

This repository contains a **simple customizable web application** that displays "Hello, <name>" where the name is configurable via Helm values.

---

## 🧱 Project Structure

```
.
├── app/                      # Python app and Dockerfile
│   ├── Dockerfile
│   └── app.py
├── chart/                    # Helm chart for deploying the app
│   ├── values.yaml
│   └── templates/
├── Makefile                  # Automates image build, push, and Helm value updates
└── README.md
```

---

## 🐳 Docker Image Build & Push (with Versioning)

To **build**, **tag**, and **push** a Docker image with a specific version, and also update the Helm chart:

Bump the VERSION in makefile

```bash
make deploy
```

This will:
1. Build the image: `docker build -t spigrig/hello-spyros:<VERSION>> app`
2. Push it to Docker Hub
3. Update `chart/values.yaml` to set the image tag to `<VERSION>`

Push the changes to the git repo

ArgoCD will automatically sync with the Git repo. However:
- It only detects **Git repo changes**, not new Docker images with the same tag.
- To deploy new images, update the tag in `values.yaml` with make deploy and push the changes to the git repo.
---

## 🔁 When to Update What

| **Change Type**         | **Requires New Image?** | **Requires Git Commit & Push?** | **ArgoCD Action**                  |
|-------------------------|--------------------------|----------------------------------|------------------------------------|
| Code change (e.g. `app.py`) | ✅ Yes                   | ✅ Yes                           | ArgoCD detects new chart tag and redeploys |
| Environment value change (`env.name` in `values.yaml`) | ❌ No                    | ✅ Yes                           | ArgoCD detects chart change and redeploys |
| Port/replica change     | ❌ No                    | ✅ Yes                           | ArgoCD redeploys with new values   |
| Docker base image or dependencies | ✅ Yes           | ✅ Yes                           | Requires image rebuild & chart update |
| Helm logic changes (e.g., new template logic) | ❌ Usually not            | ✅ Yes                           | ArgoCD redeploys chart              |

---

## 🧪 Access the Application

After deployment:

```bash
minikube service webapp --url
```

Open the URL in your browser to view your app.

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
  tag: v1.0.0

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

- `chart/templates/service.yaml`: Update servicename

```yaml
  name: {{ .Values.service.name }}
```
---

## 🧹 Delete unnecessary files from the default chart

```bash
rm chart/templates/hpa.yaml chart/templates/ingress.yaml chart/templates/serviceaccount.yaml chart/templates/tests/test-connection.yaml
```
---
