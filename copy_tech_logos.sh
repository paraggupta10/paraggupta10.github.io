#!/bin/bash

# Create destination directory if it doesn't exist
mkdir -p images/tech

# List of technology logos to copy
TECH_LOGOS=(
  "aws.png"
  "gcp.png"
  "azure.png"
  "alibaba-cloud.png"
  "openstack.png"
  "kubernetes.png"
  "docker.png"
  "terraform.png"
  "ansible.png"
  "jenkins.png"
  "salt.png"
  "istio.png"
  "kafka.png"
  "prometheus.png"
  "grafana.png"
  "elk.png"
  "zabbix.png"
  "jaeger.png"
  "mysql-logo-1.png"
  "postgresql.png"
  "redis.png"
  "airflow.png"
  "vault.png"
  "git.png"
  "python-logo-1.png"
  "shell-logo-1.png"
  "mongodb.png"
)

# Company logos to ensure we have
COMPANY_LOGOS=(
  "adobe-logo.png"
  "medianet-logo.png"
  "tokopedia-logo.png"
  "paytm-logo.png"
  "tothenew-logo.png"
)

# Source directory
SRC_DIR="../paraggupta10.github.io/assets/img"

# Copy each tech logo
for logo in "${TECH_LOGOS[@]}"; do
  if [ -f "$SRC_DIR/$logo" ]; then
    echo "Copying $logo..."
    cp "$SRC_DIR/$logo" "images/"
  else
    echo "Warning: $logo not found in source directory"
  fi
done

# Copy company logos
for logo in "${COMPANY_LOGOS[@]}"; do
  if [ -f "$SRC_DIR/$logo" ]; then
    echo "Copying company logo $logo..."
    cp "$SRC_DIR/$logo" "images/"
  else
    echo "Warning: Company logo $logo not found in source directory"
  fi
done

# Rename some files to match our HTML references
mv -f images/python-logo-1.png images/python.png 2>/dev/null
mv -f images/shell-logo-1.png images/bash.png 2>/dev/null
mv -f images/mysql-logo-1.png images/mysql.png 2>/dev/null
mv -f images/alibaba-cloud.png images/alibaba.png 2>/dev/null
mv -f images/salt.png images/saltstack.png 2>/dev/null

# Download missing icons
if [ ! -f "images/centos.png" ]; then
  echo "Downloading placeholder for centos.png..."
  curl -s "https://ui-avatars.com/api/?name=CentOS&background=0D8ABC&color=fff&size=128" -o "images/centos.png"
fi

if [ ! -f "images/kvm.png" ]; then
  echo "Downloading placeholder for kvm.png..."
  curl -s "https://ui-avatars.com/api/?name=KVM&background=0D8ABC&color=fff&size=128" -o "images/kvm.png"
fi

if [ ! -f "images/qemu.png" ]; then
  echo "Downloading placeholder for qemu.png..."
  curl -s "https://ui-avatars.com/api/?name=QEMU&background=0D8ABC&color=fff&size=128" -o "images/qemu.png"
fi

if [ ! -f "images/yaml.png" ]; then
  echo "Downloading placeholder for yaml.png..."
  curl -s "https://ui-avatars.com/api/?name=YAML&background=0D8ABC&color=fff&size=128" -o "images/yaml.png"
fi

if [ ! -f "images/argocd.png" ]; then
  echo "Downloading placeholder for argocd.png..."
  curl -s "https://ui-avatars.com/api/?name=ArgoCD&background=0D8ABC&color=fff&size=128" -o "images/argocd.png"
fi

if [ ! -f "images/security.png" ]; then
  echo "Downloading placeholder for security.png..."
  curl -s "https://ui-avatars.com/api/?name=Security&background=0D8ABC&color=fff&size=128" -o "images/security.png"
fi

if [ ! -f "images/iam.png" ]; then
  echo "Downloading placeholder for iam.png..."
  curl -s "https://ui-avatars.com/api/?name=IAM&background=0D8ABC&color=fff&size=128" -o "images/iam.png"
fi

if [ ! -f "images/vuln.png" ]; then
  echo "Downloading placeholder for vuln.png..."
  curl -s "https://ui-avatars.com/api/?name=VULN&background=0D8ABC&color=fff&size=128" -o "images/vuln.png"
fi

if [ ! -f "images/glusterfs.png" ]; then
  echo "Downloading placeholder for glusterfs.png..."
  curl -s "https://ui-avatars.com/api/?name=GlusterFS&background=0D8ABC&color=fff&size=128" -o "images/glusterfs.png"
fi

echo "Tech logos copied and missing images created successfully!" 