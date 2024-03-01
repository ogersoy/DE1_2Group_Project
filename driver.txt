### Group 2 
### Setup commands for Spark Masternode
### These commands are built upon the default settings of SNIC cloud's ubuntu 20.04 image

## update all packages to latest
sudo apt update

# install necessary software and packages
sudo apt install -y openjdk-11-jdk
sudo apt-get install -y python3-pip
python3 -m pip install pyspark==3.0.3 --user
python3 -m pip install pandas --user
python3 -m pip install numpy --user
python3 -m pip install matplotlib --user
python3 -m pip install tabulate --user
python3 -m pip install jupyterlab

#hostname-IPs mapping
for i in {1..255}; do echo "192.168.1.$i host-192-168-1-$i-de1"| sudo tee -a /etc/hosts; done
for i in {1..255}; do echo "192.168.2.$i host-192-168-2-$i-de1"| sudo tee -a /etc/hosts; done
# set the hostname
sudo hostname host-$(hostname -I | awk '{$1=$1};1' | sed 's/\./-/'g)-de1 ; hostname
