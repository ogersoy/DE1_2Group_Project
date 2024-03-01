### Group 2 
### Setup commands for Spark Masternode
### These commands are built upon the default settings of SNIC cloud's ubuntu 20.04 image

## update all packages to latest
sudo apt update

# install necessary software and packages
sudo apt install software-properties-common
sudo add-apt-repository ppa:webupd8team/java
sudo apt install openjdk-11-jdk
sudo apt install scala
sudo apt install openssh-server openssh-client
# generate ssh key for the master you should add the public key to authorized_keys in workers
ssh-keygen -t rsa -P ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
# install spark 
wget https://archive.apache.org/dist/spark/spark-3.0.3/spark-3.0.3-bin-hadoop2.7.tgz
tar xvf spark-3.0.3-bin-hadoop2.7.tgz
sudo mv spark-3.0.3-bin-hadoop2.7 /usr/local/spark

# add #JAVA-HOME# to bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.bashrc

source ~/.bashrc
cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh 
# set the parameters for spark. Replace 192.168.2.102 with the IP address of Spark master
echo "export SPARK_MASTER_HOST='192.168.2.191'" >> $SPARK_HOME/conf/spark-env.sh
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> $SPARK_HOME/conf/spark-env.sh
$SPARK_HOME/sbin/start-master.sh
