#!/usr/bin/env python3

import os
import sys
import requests
from io import BytesIO
from pathlib import Path
from PIL import Image

try:
    import cairosvg
    HAS_CAIROSVG = True
except ImportError:
    HAS_CAIROSVG = False
    print("CairoSVG not installed. Will fetch PNG versions directly.")

# Directory with SVG files
CLEAN_LOGOS_DIR = "images/clean-logos"

# High-quality PNG logo URLs for direct download
DIRECT_PNG_URLS = {
    "python": "https://www.python.org/static/community_logos/python-logo.png",
    "bash": "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Bash_Logo_Colored.svg/512px-Bash_Logo_Colored.svg.png",
    "yaml": "https://raw.githubusercontent.com/gilbarbara/logos/master/logos/yaml.png",
    "centos": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/CentOS_color_logo.svg/512px-CentOS_color_logo.svg.png",
    "kvm": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Sarovar_KVM_logo.svg/512px-Sarovar_KVM_logo.svg.png",
    "qemu": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/QEMU_Logo.svg/512px-QEMU_Logo.svg.png",
    "aws": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Amazon_Web_Services_Logo.svg/512px-Amazon_Web_Services_Logo.svg.png",
    "gcp": "https://www.gstatic.com/devrel-devsite/prod/v3e3388688be06bcd26c2589af27310558c483dd3c5da1a7c6be1cc160bf0e199/cloud/images/favicons/onecloud/super_cloud.png",
    "azure": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Microsoft_Azure.svg/512px-Microsoft_Azure.svg.png",
    "alibaba": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Alibaba_Cloud.svg/512px-Alibaba_Cloud.svg.png",
    "openstack": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/OpenStack%C2%AE_Logo_2016.svg/512px-OpenStack%C2%AE_Logo_2016.svg.png",
    "kubernetes": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/512px-Kubernetes_logo_without_workmark.svg.png",
    "docker": "https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png",
    "terraform": "https://raw.githubusercontent.com/terraform-docs/terraform-docs/master/images/terraform-docs-logo.png",
    "ansible": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Ansible_logo.svg/512px-Ansible_logo.svg.png",
    "jenkins": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Jenkins_logo.svg/512px-Jenkins_logo.svg.png",
    "saltstack": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Saltstack-Logo.svg/512px-Saltstack-Logo.svg.png",
    "istio": "https://github.com/istio/istio/raw/master/logo/istio-bluelogo-whitebackground-unframed.svg",
    "argocd": "https://argo-cd.readthedocs.io/en/stable/assets/logo.png",
    "prometheus": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Prometheus_software_logo.svg/512px-Prometheus_software_logo.svg.png",
    "grafana": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Grafana_logo.svg/512px-Grafana_logo.svg.png",
    "elasticstack": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Elasticsearch_logo.svg/512px-Elasticsearch_logo.svg.png",
    "zabbix": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Zabbix_logo.svg/512px-Zabbix_logo.svg.png",
    "jaeger": "https://www.jaegertracing.io/img/jaeger-icon-color.png",
    "mysql": "https://upload.wikimedia.org/wikipedia/en/thumb/b/b2/Database-mysql.svg/512px-Database-mysql.svg.png",
    "postgresql": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Postgresql_elephant.svg/512px-Postgresql_elephant.svg.png",
    "redis": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Redis_Logo.svg/512px-Redis_Logo.svg.png",
    "mongodb": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/MongoDB_Logo.svg/512px-MongoDB_Logo.svg.png",
    "kafka": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Apache_kafka.svg/512px-Apache_kafka.svg.png",
    "glusterfs": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/GlusterFS.svg/512px-GlusterFS.svg.png",
    "security": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/High-contrast-preferences-desktop-theme-security.svg/512px-High-contrast-preferences-desktop-theme-security.svg.png",
    "iam": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Google_IAM_logo.svg/512px-Google_IAM_logo.svg.png",
    "vault": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Vault_Hashicorp.svg/512px-Vault_Hashicorp.svg.png",
    "git": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Git-logo.svg/512px-Git-logo.svg.png",
    "airflow": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/AirflowLogo.png/512px-AirflowLogo.png",
}

def download_png(tech_name, output_path):
    """Download a logo directly as PNG"""
    if tech_name in DIRECT_PNG_URLS:
        url = DIRECT_PNG_URLS[tech_name]
        print(f"Downloading {tech_name} PNG logo from {url}")
        try:
            response = requests.get(url, stream=True)
            response.raise_for_status()
            
            img = Image.open(BytesIO(response.content))
            # Resize to 512px while preserving aspect ratio
            if max(img.size) > 512:
                img.thumbnail((512, 512), Image.LANCZOS)
            
            # Save with transparency if it has an alpha channel
            if img.mode == 'RGBA':
                img.save(output_path, 'PNG')
            else:
                img.convert('RGBA').save(output_path, 'PNG')
                
            print(f"✓ Successfully saved {tech_name} logo to {output_path}")
            return True
        except Exception as e:
            print(f"✗ Failed to download {tech_name} PNG logo: {e}")
            return False
    else:
        print(f"✗ No direct PNG URL defined for {tech_name}")
        return False

def main():
    """Convert or download high-quality logos"""
    # Create directories if they don't exist
    Path(CLEAN_LOGOS_DIR).mkdir(parents=True, exist_ok=True)
    
    # Get the list of existing files
    svg_files = list(Path(CLEAN_LOGOS_DIR).glob('*.svg'))
    
    if not svg_files and not DIRECT_PNG_URLS:
        print("No SVG files found and no direct PNG URLs provided.")
        return
    
    print(f"Found {len(svg_files)} SVG files to convert")
    
    if HAS_CAIROSVG:
        # Convert SVGs to PNGs using CairoSVG
        for svg_file in svg_files:
            tech_name = svg_file.stem
            png_path = svg_file.with_suffix('.png')
            try:
                print(f"Converting {svg_file} to PNG...")
                cairosvg.svg2png(url=str(svg_file), write_to=str(png_path), output_width=512, output_height=512)
                print(f"✓ Successfully converted {tech_name}")
            except Exception as e:
                print(f"✗ Failed to convert {tech_name}: {e}")
                # Try direct download as fallback
                download_png(tech_name, png_path)
    else:
        # Download PNGs directly
        for tech_name in DIRECT_PNG_URLS:
            png_path = Path(CLEAN_LOGOS_DIR) / f"{tech_name}.png"
            download_png(tech_name, png_path)
    
    # Copy files to main images directory
    print("\nCopying files to main images directory...")
    for png_file in Path(CLEAN_LOGOS_DIR).glob('*.png'):
        dest_path = Path('images') / png_file.name
        try:
            png_file.replace(dest_path)
            print(f"✓ Moved {png_file.name} to images directory")
        except Exception as e:
            try:
                # If replace fails, try copy
                import shutil
                shutil.copy2(png_file, dest_path)
                print(f"✓ Copied {png_file.name} to images directory")
            except Exception as e2:
                print(f"✗ Failed to copy {png_file.name}: {e2}")
    
    print("\nLogo conversion and download process complete!")

if __name__ == "__main__":
    main() 