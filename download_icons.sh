#!/bin/bash

# Create tech folder if it doesn't exist
mkdir -p images/tech

# Download placeholder icons for technologies
TECHNOLOGIES=(
  "python" 
  "bash" 
  "yaml" 
  "centos" 
  "kvm" 
  "qemu" 
  "mysql" 
  "postgresql" 
  "redis" 
  "glusterfs" 
  "security" 
  "iam" 
  "vuln" 
  "saltstack" 
  "zabbix"
  "kafka"
  "istio"
  "argocd"
)

# Check each file and download if missing
for tech in "${TECHNOLOGIES[@]}"; do
  if [ ! -f "images/${tech}.png" ]; then
    echo "Downloading placeholder icon for ${tech}..."
    # Use a placeholder service to generate icons
    curl -s "https://ui-avatars.com/api/?name=${tech}&background=0D8ABC&color=fff&size=128" -o "images/${tech}.png"
  fi
done

echo "All placeholder icons downloaded successfully!" 