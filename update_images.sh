#!/bin/bash

echo "Updating images with newer versions..."

# Convert non-PNG images to PNG format
if [ -f "images/centos.jpeg" ]; then
  echo "Converting centos.jpeg to centos.png..."
  convert images/centos.jpeg images/centos.png
fi

if [ -f "images/kvm.jpg" ]; then
  echo "Converting kvm.jpg to kvm.png..."
  convert images/kvm.jpg images/kvm.png
fi

if [ -f "images/qemu.jpg" ]; then
  echo "Converting qemu.jpg to qemu.png..."
  convert images/qemu.jpg images/qemu.png
fi

if [ -f "images/ansible.jpg" ]; then
  echo "Converting ansible.jpg to ansible.png..."
  convert images/ansible.jpg images/ansible.png
fi

if [ -f "images/docker.jpg" ]; then
  echo "Converting docker.jpg to docker.png..."
  convert images/docker.jpg images/docker.png
fi

if [ -f "images/alibaba_cloud.webp" ]; then
  echo "Converting alibaba_cloud.webp to alibaba.png..."
  convert images/alibaba_cloud.webp images/alibaba.png
fi

# Check for 'convert' command
if ! command -v convert &> /dev/null; then
  echo "Warning: 'convert' command not found. This script requires ImageMagick to convert images."
  echo "As an alternative, we'll try using sips (macOS built-in tool)."
  
  # Try using sips (macOS built-in) as an alternative
  if command -v sips &> /dev/null; then
    if [ -f "images/centos.jpeg" ]; then
      echo "Converting centos.jpeg to centos.png using sips..."
      sips -s format png images/centos.jpeg --out images/centos.png
    fi
    
    if [ -f "images/kvm.jpg" ]; then
      echo "Converting kvm.jpg to kvm.png using sips..."
      sips -s format png images/kvm.jpg --out images/kvm.png
    fi
    
    if [ -f "images/qemu.jpg" ]; then
      echo "Converting qemu.jpg to qemu.png using sips..."
      sips -s format png images/qemu.jpg --out images/qemu.png
    fi
    
    if [ -f "images/ansible.jpg" ]; then
      echo "Converting ansible.jpg to ansible.png using sips..."
      sips -s format png images/ansible.jpg --out images/ansible.png
    fi
    
    if [ -f "images/docker.jpg" ]; then
      echo "Converting docker.jpg to docker.png using sips..."
      sips -s format png images/docker.jpg --out images/docker.png
    fi
    
    if [ -f "images/alibaba_cloud.webp" ]; then
      echo "Warning: sips may not support webp to png conversion."
      echo "You may need to manually convert alibaba_cloud.webp to alibaba.png."
    fi
  else
    echo "Neither convert nor sips were found. Please install ImageMagick or manually convert the images."
  fi
fi

echo "Update complete! Check images directory for any issues." 