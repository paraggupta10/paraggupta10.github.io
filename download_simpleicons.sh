#!/bin/bash

# Create a directory for the high-quality logos
mkdir -p images/high-quality

# Function to download from Simple Icons (clean, icon-only logos)
download_simpleicon() {
  local name="$1"
  local slug="$2"
  local output_file="images/high-quality/${name}.svg"
  
  if [ -z "$slug" ]; then
    slug="$name"
  fi
  
  echo "Downloading ${name} logo..."
  curl -s -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
    "https://cdn.simpleicons.org/simpleicons" -o /dev/null
    
  # Now try the actual download
  curl -s -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
    "https://cdn.simpleicons.org/${slug}" -o "$output_file"
  
  # Check if download was successful
  if [ -f "$output_file" ] && [ -s "$output_file" ]; then
    echo "✓ Successfully downloaded ${name} logo"
    
    # Convert SVG to PNG with sips (macOS built-in)
    if command -v sips &> /dev/null; then
      sips -s format png "$output_file" --out "images/${name}.png" &> /dev/null
      if [ -f "images/${name}.png" ]; then
        echo "  ✓ Converted to PNG"
        rm "$output_file"
      else
        echo "  ✗ Failed to convert to PNG"
      fi
    else
      # If sips is not available, keep the SVG
      cp "$output_file" "images/${name}.svg"
      echo "  ✗ Sips not available, keeping SVG format"
    fi
  else
    echo "✗ Failed to download ${name} logo"
    rm -f "$output_file"
  fi
}

# Download popular technology logos
download_simpleicon "python" "python"
download_simpleicon "bash" "gnubash"
download_simpleicon "yaml" "yaml"
download_simpleicon "centos" "centos"
download_simpleicon "kvm" "kvm"
download_simpleicon "qemu" "qemu"
download_simpleicon "aws" "amazonaws"
download_simpleicon "gcp" "googlecloud"
download_simpleicon "azure" "microsoftazure"
download_simpleicon "alibaba" "alibabacloud"
download_simpleicon "openstack" "openstack"
download_simpleicon "kubernetes" "kubernetes"
download_simpleicon "docker" "docker"
download_simpleicon "terraform" "terraform"
download_simpleicon "ansible" "ansible"
download_simpleicon "jenkins" "jenkins"
download_simpleicon "saltstack" "saltstack"
download_simpleicon "istio" "istio"
download_simpleicon "argocd" "argo"
download_simpleicon "prometheus" "prometheus"
download_simpleicon "grafana" "grafana"
download_simpleicon "elasticsearch" "elasticsearch"
download_simpleicon "zabbix" "zabbix"
download_simpleicon "jaeger" "jaeger"
download_simpleicon "mysql" "mysql"
download_simpleicon "postgresql" "postgresql"
download_simpleicon "redis" "redis"
download_simpleicon "mongodb" "mongodb"
download_simpleicon "kafka" "apachekafka"
download_simpleicon "glusterfs" "gluster"
download_simpleicon "security" "letsencrypt"
download_simpleicon "iam" "auth0"
download_simpleicon "vault" "vault"
download_simpleicon "git" "git"
download_simpleicon "airflow" "apacheairflow"

echo "Download process complete!" 