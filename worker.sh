### Group 2 
### Setup commands for Spark worker nodes
### These commands are built upon the default settings of SNIC cloud's ubuntu 2$

## update all packages to latest
sudo apt update

## install necessary software and packages

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install openjdk-11-jdk
sudo apt-get install scala
## install spark

wget https://archive.apache.org/dist/spark/spark-3.0.3/spark-3.0.3-bin-hadoop2.7.tgz
tar xvf spark-3.0.3-bin-hadoop2.7.tgz
sudo mv spark-3.0.3-bin-hadoop2.7 /usr/local/spark

export SPARK_HOME=/usr/local/spark
for i in {1..255}; do echo "192.168.1.$i host-192-168-1-$i-de1"| sudo tee -a /etc/hosts; done
for i in {1..255}; do echo "192.168.2.$i host-192-168-2-$i-de1"| sudo tee -a /etc/hosts; done
## run worker
$SPARK_HOME/sbin/start-slave.sh -m 4g spark://192.168.2.191:7077
