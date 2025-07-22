# 🚀 Dockerizing Flask App and Pushing to AWS ECR

This guide explains how to build a Docker image from a simple Flask app and push it to AWS Elastic Container Registry (ECR).

---

## 📁 Project Structure


app/
├── app.py
├── requirements.txt
└── Dockerfile



---

## 🛠️ Steps to Build and Push

### 1️⃣ Authenticate Docker to AWS ECR

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 430658514390.dkr.ecr.us-east-1.amazonaws.com

2️⃣ Build the Docker Image
bash
Copy
Edit
docker build -t my-app .


3️⃣ Tag the Image
bash
Copy
Edit
docker tag my-app:latest 430658514390.dkr.ecr.us-east-1.amazonaws.com/my-app:latest



4️⃣ Push the Image to ECR
bash
Copy
Edit
docker push 430658514390.dkr.ecr.us-east-1.amazonaws.com/my-app:latest



Your Docker image is now available in AWS ECR and ready to be used in your Kubernetes deployment.

yaml
Copy
Edit

---


