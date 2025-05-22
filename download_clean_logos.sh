#!/bin/bash

# Create a directory for the clean logos
mkdir -p images/clean-logos

# Function to download a logo
download_logo() {
  local name="$1"
  local url="$2"
  local output_file="images/clean-logos/$name.png"
  
  echo "Downloading $name logo..."
  curl -s "$url" -o "$output_file"
  
  # Check if download was successful
  if [ -f "$output_file" ] && [ -s "$output_file" ]; then
    echo "✓ Successfully downloaded $name logo"
  else
    echo "✗ Failed to download $name logo"
    # Remove empty file if download failed
    rm -f "$output_file"
  fi
}

# Clean, high-quality technology logos (icon-only, no text)

# Programming Languages
download_logo "python" "https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg"
download_logo "bash" "https://raw.githubusercontent.com/devicons/devicon/master/icons/bash/bash-original.svg"
download_logo "yaml" "https://user-images.githubusercontent.com/7038831/48658871-d8d44980-ea5a-11e8-9f9c-1c068ec26db3.png"

# Unix/Virtualization
download_logo "centos" "https://raw.githubusercontent.com/devicons/devicon/master/icons/centos/centos-original.svg"
download_logo "kvm" "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Kvmbanner-logo2_1.png/250px-Kvmbanner-logo2_1.png"
download_logo "qemu" "https://raw.githubusercontent.com/gilbarbara/logos/master/logos/qemu.svg"

# Cloud Platforms
download_logo "aws" "https://raw.githubusercontent.com/devicons/devicon/master/icons/amazonwebservices/amazonwebservices-original-wordmark.svg"
download_logo "gcp" "https://www.vectorlogo.zone/logos/google_cloud/google_cloud-icon.svg"
download_logo "azure" "https://www.vectorlogo.zone/logos/microsoft_azure/microsoft_azure-icon.svg"
download_logo "alibaba" "https://www.vectorlogo.zone/logos/alibabacloud/alibabacloud-icon.svg"
download_logo "openstack" "https://www.vectorlogo.zone/logos/openstack/openstack-icon.svg"

# DevOps Tools
download_logo "kubernetes" "https://www.vectorlogo.zone/logos/kubernetes/kubernetes-icon.svg"
download_logo "docker" "https://www.vectorlogo.zone/logos/docker/docker-icon.svg"
download_logo "terraform" "https://www.vectorlogo.zone/logos/terraformio/terraformio-icon.svg"
download_logo "ansible" "https://www.vectorlogo.zone/logos/ansible/ansible-icon.svg"
download_logo "jenkins" "https://www.vectorlogo.zone/logos/jenkins/jenkins-icon.svg"
download_logo "saltstack" "https://www.vectorlogo.zone/logos/saltstack/saltstack-icon.svg"
download_logo "istio" "https://www.vectorlogo.zone/logos/istioio/istioio-icon.svg"
download_logo "argocd" "https://www.vectorlogo.zone/logos/argoprojio/argoprojio-icon.svg"

# Monitoring
download_logo "prometheus" "https://www.vectorlogo.zone/logos/prometheusio/prometheusio-icon.svg"
download_logo "grafana" "https://www.vectorlogo.zone/logos/grafana/grafana-icon.svg"
download_logo "elasticstack" "https://www.vectorlogo.zone/logos/elastic/elastic-icon.svg"
download_logo "zabbix" "https://www.vectorlogo.zone/logos/zabbix/zabbix-icon.svg"
download_logo "jaeger" "https://www.vectorlogo.zone/logos/jaegertracingio/jaegertracingio-icon.svg"

# Databases & Storage
download_logo "mysql" "https://www.vectorlogo.zone/logos/mysql/mysql-icon.svg"
download_logo "postgresql" "https://www.vectorlogo.zone/logos/postgresql/postgresql-icon.svg"
download_logo "redis" "https://www.vectorlogo.zone/logos/redis/redis-icon.svg"
download_logo "mongodb" "https://www.vectorlogo.zone/logos/mongodb/mongodb-icon.svg"
download_logo "kafka" "https://www.vectorlogo.zone/logos/apache_kafka/apache_kafka-icon.svg"
download_logo "glusterfs" "https://download.gluster.org/pub/gluster/glusterfs/logo/gluster-ant.svg"

# Security
download_logo "security" "https://www.vectorlogo.zone/logos/cncfio/cncfio-icon.svg"
download_logo "iam" "https://www.vectorlogo.zone/logos/auth0/auth0-icon.svg"
download_logo "vault" "https://www.vectorlogo.zone/logos/vaultproject/vaultproject-icon.svg"

# Other
download_logo "git" "https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg"
download_logo "airflow" "https://www.vectorlogo.zone/logos/apache_airflow/apache_airflow-icon.svg"

# Convert SVGs to PNGs
echo "Converting SVG files to PNG..."

# Check if we have ImageMagick or rsvg-convert
if command -v convert &> /dev/null; then
  # Using ImageMagick
  find images/clean-logos -name "*.svg" -exec sh -c 'convert -size 512x512 -background none "$0" "${0%.svg}.png" && rm "$0"' {} \;
elif command -v rsvg-convert &> /dev/null; then
  # Using rsvg-convert
  find images/clean-logos -name "*.svg" -exec sh -c 'rsvg-convert -w 512 -h 512 "$0" > "${0%.svg}.png" && rm "$0"' {} \;
elif command -v svgexport &> /dev/null; then
  # Using svgexport
  find images/clean-logos -name "*.svg" -exec sh -c 'svgexport "$0" "${0%.svg}.png" 512:512 && rm "$0"' {} \;
else
  echo "Warning: No SVG conversion tools found. SVG files will remain as-is."
  echo "To convert them to PNG, please install ImageMagick, librsvg, or svgexport."
fi

# Move to the main images directory
echo "Moving cleaned logos to main directory..."
for img in images/clean-logos/*.png; do
  filename=$(basename "$img")
  cp "$img" "images/${filename}"
done

echo "Download and conversion process complete!"
echo "High-quality logos are available in both images/ and images/clean-logos/" 