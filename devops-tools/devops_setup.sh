#!/bin/bash

####################
# Author: Alexandre St-fort
# Last modified: 11/11/25
#
# This script install Docker, Terraform, AWS CLI, Kubernetes. Compatible with Debian/Ubuntu
####################


set -e

install_docker() {
  echo "--- Installing Docker ---"
  sudo apt install ca-certificates curl gnupg -y


  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update

  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  echo "--- Docker installed successfully! ---"
}


install_terraform() {
  echo "--- Installing Terraform ---"
  wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

  gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

  sudo apt update
  sudo apt-get install terraform -y
  echo "--- Terraform installed successfully! ---"
}

install_awscli() {
  echo "--- Installing AWS CLI ---"
  sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  sudo unzip awscliv2.zip
  sudo ./aws/install --update
  sudo rm -rf awscliv2.zip ./aws
  echo "--- AWS CLI installed successfully! ---"
}

install_kubernetes() {
  echo "--- Installing Kubernetes (kubectl) and Minikube ---"

  # Install Kubectl via the official Kubernetes repository
  sudo apt-get update
  sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo rm /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
  sudo curl -Lo minikube https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
  sudo install minikube /usr/local/bin/

  echo "--- Kubernetes and Minikube installed successfully! ---"
}

main() {
  echo "--- Starting system update and upgrade ---"
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt install unzip
  echo "--- System update and upgrade completed ---"
  install_docker
  install_terraform
  install_awscli
  install_kubernetes

  echo "--- All installations completed successfully! ---"
}

main "$@"
