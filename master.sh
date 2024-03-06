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

#install hadoop
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz 
tar -xvzf hadoop-3.3.6.tar.gz 

# add #JAVA-HOME# to bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.bashrc
source ~/.bashrc
echo "export SPARK_HOME=/usr/local/spark" >> ~/.bashrc
source ~/.bashrc
cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh 


echo "export HADOOP_HOME=/home/ubuntu/hadoop-3.3.6" >> ~/.bashrc
source ~/.bashrc
echo "export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin" >> ~/.bashrc
source ~/.bashrc


# set the parameters for spark. Replace 192.168.2.172 with the IP address of Spark master
echo "export SPARK_MASTER_HOST='192.168.2.247'" >> $SPARK_HOME/conf/spark-env.sh
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> $SPARK_HOME/conf/spark-env.sh
$SPARK_HOME/sbin/start-master.sh

#Configure java for hadoop
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh


echo "export HADOOP_HOME=/home/ubuntu/hadoop-3.3.6" >> ~/.bashrc
echo "export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin" >> ~/.bashrc


#Create hadoop data directory
mkdir -p ~/hadoopdata/hdfs/namenode 
mkdir -p ~/hadoopdata/hdfs/datanode 

##Configure hdfs:
#core-site.xml
sed '/^<configuration>$/r'<(
    echo "<property>"
    echo "<name>fs.defaultFS</name>"
    echo "<value>hdfs://192.168.2.247:9000</value>"
    echo "</property>"
) -i -- $HADOOP_HOME/etc/hadoop/core-site.xml

#hdfs-site.xml
sed '/^<configuration>$/r'<(
    echo "<property>"
    echo "<name>dfs.replication</name>"
    echo "<value>1</value>"
    echo "</property>"
    echo "<property>"
    echo "<name>dfs.name.dir</name>"
    echo "<value>file:///home/ubuntu/hadoopdata/hdfs/namenode</value>"
    echo "</property>"
    echo "<property>"
    echo "<name>dfs.data.dir</name>"
    echo "<value>file:///home/ubuntu/hadoopdata/hdfs/datanode</value>"
    echo "</property>"
) -i -- $HADOOP_HOME/etc/hadoop/hdfs-site.xml

## Initiate JDFS
#Format namenode
hdfs namenode -format

#Start hdfs
start-dfs.sh

#HDFS server now can be used, the GUI can be accessed via port 9870 of the server.
