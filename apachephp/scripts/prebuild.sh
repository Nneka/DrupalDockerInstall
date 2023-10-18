#!/bin/bash
# Update package repositories and install required packages
# Packages included are docker, pip, and python 2.7
sudo dnf update -y   

# Install Docker
sudo yum install -y docker

# Start and enable the Docker service
sudo systemctl start docker

# Add the current user to the docker group for Docker access
sudo usermod -a -G docker $USER

# Optional: Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker
sudo systemctl start docker

#  Install pip - prerequisite of Node.js which is needed for Cloud9 IDE
curl -O https://bootstrap.pypa.io/get-pip.py

python3 get-pip.py --user
# Install required dependencies
sudo dnf install gcc openssl-devel bzip2-devel libffi-devel

# Download Python 2.7 source code
wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz

# Extract the archive
tar -xf Python-2.7.18.tgz

# Navigate into the extracted directory
cd Python-2.7.18

# Configure the build
./configure --enable-optimizations

# Build and install Python 2.7
sudo make altinstall


