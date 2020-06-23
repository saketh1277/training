#!/bin/bash
# This script is meant to be run in the Custom Data of each Azure Instance while it's booting. The script uses the
# run-consul script to configure and start Consul in server mode. Note that this script assumes it's running in an Image
# built from the Packer template in examples/consul-image/consul.json.

set -e

# Send the log output from this script to custom-data.log, syslog, and the console
exec > >(tee /var/log/custom-data.log|logger -t custom-data -s 2>/dev/console) 2>&1

#Info: https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver15
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update 
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev
sudo apt-get install mysql-client-5.7 -y
sudo apt-get install -y nginx && apt-get install -y nginx && systemctl enable nginx && systemctl start nginx
cp ~/.bashrc ~/.bashrc.bak
#Restore: 
#cp -i ~/.bashrc.bak ~/.bashrc
#To reload 
#source .bashrc
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
#sudo apt-get remove mssql-toolsr
### For Cosmos DB
wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update
sudo apt-get install -y mongodb-org-shell