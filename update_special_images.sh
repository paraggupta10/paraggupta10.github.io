#!/bin/bash

echo "Updating with user-provided images..."

# Keep track of success/failure
success=true

# Function to check if an image exists and log success/error
check_image() {
  local name="$1"
  if [ -f "images/${name}" ]; then
    echo "✓ Successfully using ${name}"
  else
    echo "✗ Error: ${name} not found"
    success=false
  fi
}

# Function to backup and restore an image
restore_original_image() {
  local project="$1"
  local original_file="$2"
  
  echo "Restoring original image for ${project}..."
  
  if [ -f "$original_file" ]; then
    cp "$original_file" "images/${project}.jpg"
    echo "✓ Successfully restored original image for ${project}"
    check_image "${project}.jpg"
  else
    echo "✗ Error: Original image for ${project} not found at ${original_file}"
    success=false
  fi
}

# Check if user-provided images exist
echo "Checking for user-provided images..."
for img in saltstack.png zabbix.png glusterfs.png azure.png; do
  # This will output a success/error message
  check_image "$img"
done

# Restore original Ansible Automation Assistant image
restore_original_image "ansible" "images/ansible.jpg"

echo "Image updates complete!"
if [ "$success" = true ]; then
  echo "All operations were successful."
else
  echo "Warning: Some operations failed. Check the logs above."
fi 