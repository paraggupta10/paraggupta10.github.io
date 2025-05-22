#!/bin/bash

# Create a backup
cp index.html index.html.bak

# Function to simplify skill items
simplify_skill() {
    # Replace skill progress items pattern, using sed extended regex
    perl -0777 -i -pe 's/<div class="skill-progress-item" data-percentage="[0-9]+">[ \n]+<div class="skill-progress-details">[ \n]+<div class="skill-name">[ \n]+(.*?)[ \n]+<\/div>[ \n]+<div class="skill-percentage">[0-9]+%<\/div>[ \n]+<\/div>[ \n]+<div class="skill-progress-bar">[ \n]+<div class="skill-progress-fill" style="width: 0%"><\/div>[ \n]+<\/div>[ \n]+<\/div>/<div class="skill-progress-item" data-percentage="85">\n                <div class="skill-name">\n                  $1\n                <\/div>\n              <\/div>/gs' index.html
}

# Call the function
simplify_skill

echo "Skill items simplified successfully!" 