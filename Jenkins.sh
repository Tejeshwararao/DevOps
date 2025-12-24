#!/bin/bash

set -e

echo "🔹 Updating system..."
sudo apt update -y
sudo apt upgrade -y

echo "🔹 Installing Java (OpenJDK 17)..."
sudo apt install -y openjdk-17-jdk

echo "🔹 Verifying Java installation..."
java -version

echo "🔹 Adding Jenkins repository key..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "🔹 Adding Jenkins repository..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "🔹 Updating package list..."
sudo apt update -y

echo "🔹 Installing Jenkins..."
sudo apt install -y jenkins

echo "🔹 Starting Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "🔹 Checking Jenkins status..."
sudo systemctl status jenkins --no-pager

echo "✅ Jenkins installed successfully!"
echo "🌐 Access Jenkins at: http://<your-server-ip>:8080"
echo "🔐 Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
