#!/bin/bash
set -e

### VARIABLES
TOMCAT_VERSION="10.1.20"
TOMCAT_USER="tomcat"
TOMCAT_DIR="/opt/tomcat"
JAVA_HOME="/usr/lib/jvm/java-17-amazon-corretto"

echo "===== Tomcat Installation Started ====="

### 1. Update system
echo "Updating system..."
yum update -y

### 2. Install Java & tools
echo "Installing Java 17 and utilities..."
yum install -y java-17-amazon-corretto-devel wget

### 3. Create tomcat user (non-login)
echo "Creating tomcat user..."
id tomcat &>/dev/null || useradd -r -m -d $TOMCAT_DIR -s /sbin/nologin tomcat

### 4. Download Tomcat (Apache ARCHIVE – stable)
echo "Downloading Tomcat..."
cd /tmp
wget -q https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

### 5. Install Tomcat
echo "Installing Tomcat..."
rm -rf $TOMCAT_DIR
mkdir -p $TOMCAT_DIR
tar -xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C $TOMCAT_DIR --strip-components=1

### 6. Set permissions
echo "Setting permissions..."
chown -R tomcat:tomcat $TOMCAT_DIR
chmod +x $TOMCAT_DIR/bin/*.sh

### 7. Create systemd service
echo "Creating Tomcat systemd service..."
cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

Environment="JAVA_HOME=${JAVA_HOME}"
Environment="CATALINA_HOME=${TOMCAT_DIR}"
Environment="CATALINA_BASE=${TOMCAT_DIR}"
Environment="CATALINA_PID=${TOMCAT_DIR}/temp/tomcat.pid"

ExecStart=${TOMCAT_DIR}/bin/startup.sh
ExecStop=${TOMCAT_DIR}/bin/shutdown.sh

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

### 8. Reload systemd & start Tomcat
echo "Starting Tomcat..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat

### 9. Verify
echo "Verifying Tomcat..."
systemctl status tomcat --no-pager

echo "===== Tomcat Installed Successfully ====="
echo "Access Tomcat at: http://<EC2-PUBLIC-IP>:8080"
