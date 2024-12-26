#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

# Docker

set -e  # Exit on any error
sudo dnf -y install dnf-plugins-core || { echo "Failed to install dnf plugins"; exit 1; }
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo || { echo "Failed to add Docker repo"; exit 1; }
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || { echo "Failed to install Docker"; exit 1; }
sudo systemctl start docker || { echo "Failed to start Docker service"; exit 1; }
sudo systemctl enable docker || { echo "Failed to enable Docker service"; exit 1; }
sudo usermod -aG docker ec2-user || { echo "Failed to add user to Docker group"; exit 1; }
echo "Docker installed and configured successfully!"


# lsblk
# sudo pvcreate /dev/xvdb
# sudo vgextend RootVG /dev/xvdb
# sudo lvextend -L +25G /dev/RootVG/varVol
# sudo lvextend -L +24G /dev/RootVG/rootVol
# sudo xfs_growfs /dev/RootVG/varVol
# sudo xfs_growfs /dev/RootVG/rootVol


#eksctl

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
VALIDATE $? "eksctl installation"

#kubectl

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
VALIDATE $? "kubectl installation"

#kubens

git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens
VALIDATE $? "kubens installation"

#k9s

curl -sS https://webinstall.dev/k9s | bash
VALIDATE $? "k9s installation"

#helm

curl -fsSL https://get.helm.sh/helm-v3.16.3-linux-amd64.tar.gz -o helm-v3.16.3-linux-amd64.tar.gz
tar -zxvf helm-v3.16.3-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm
echo 'Helm installation complete!'
export PATH=$PATH:/usr/local/bin  # Ensure /usr/local/bin is in the PATH
helm version  # Verify Helm is installed successfully

