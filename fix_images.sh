#!/bin/bash

echo "Fixing Azure image and creating better project image..."

# 1. Fix Azure image - use azure.jpg instead of azure.png
if [ -f "images/azure.jpg" ]; then
  echo "Using azure.jpg for Azure logo..."
  # Copy it to azure.png to maintain references in HTML
  cp "images/azure.jpg" "images/azure.png"
  echo "✓ Successfully updated Azure image"
else
  echo "✗ Error: azure.jpg not found"
  # Download a simple high-quality Azure logo
  echo "Downloading Azure logo..."
  curl -s -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
    "https://cdn.simpleicons.org/microsoftazure" -o "images/azure-temp.svg"
  
  # Convert to PNG
  if command -v sips &> /dev/null; then
    sips -s format png "images/azure-temp.svg" --out "images/azure.png" &> /dev/null
    echo "✓ Successfully downloaded and converted Azure logo"
    rm "images/azure-temp.svg"
  else
    echo "✗ Error: Could not convert Azure logo"
  fi
fi

# 2. Create better project image for Ansible Automation Assistant
echo "Creating custom image for Ansible Automation Assistant project..."

# Download AI assistant image if we don't have one 
if [ ! -f "images/ai-assistant.jpg" ] && [ ! -f "images/ai-assistant.png" ]; then
  echo "Downloading AI assistant image..."
  # Use a placeholder AI-themed image
  curl -s -o "images/ai-assistant.jpg" "https://colorlib.com/wp/wp-content/uploads/sites/2/ai-generated-website-examples.jpg" || \
  curl -s -o "images/ai-assistant.jpg" "https://cdn.foleon.com/upload/18720/ai-generated-content.jpg"
  
  if [ -f "images/ai-assistant.jpg" ]; then
    echo "✓ Successfully downloaded AI assistant image"
  else
    echo "✗ Error: Could not download AI assistant image"
    # Create a fallback image with a gradient
    echo "Creating fallback image..."
    
    # Use ImageMagick if available
    if command -v convert &> /dev/null; then
      convert -size 800x600 gradient:#336699-#00CC99 "images/ai-assistant.jpg"
      echo "✓ Created fallback image with ImageMagick"
    else
      # Otherwise copy from an existing project image
      cp "images/terraform.jpg" "images/ai-assistant.jpg"
      echo "✓ Used terraform.jpg as fallback image"
    fi
  fi
fi

# Update HTML to use the new image for Ansible Automation Assistant
echo "Updating HTML to use new image for Ansible Automation Assistant..."
sed -i '' 's|images/ansible.jpg" alt="Ansible Automation|images/ai-assistant.jpg" alt="Ansible Automation|g' index.html
sed -i '' 's|images/ansible.jpg" alt="Ansible Automation Assistant|images/ai-assistant.jpg" alt="Ansible Automation Assistant|g' index.html

echo "Image fixes complete!" 