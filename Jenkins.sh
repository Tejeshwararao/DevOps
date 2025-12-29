#!/bin/bash

echo "=== Updating system ==="
sudo yum update -y

echo "=== Installing Java 17 (Amazon Corretto) ==="
sudo yum install -y java-17-amazon-corretto

echo "=== Verifying Java ==="
java -version

echo "=== Adding Jenkins repository ==="
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

echo "=== Importing Jenkins GPG key ==="
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "=== Installing Jenkins ==="
sudo yum install -y jenkins

echo "=== Starting Jenkins service ==="
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "=== Jenkins Status ==="
sudo systemctl status jenkins --no-pager

echo "=== Jenkins Installed Successfully ==="
echo "Access Jenkins at: http://<EC2-PUBLIC-IP>:8080"
