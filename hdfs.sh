#!/bin/bash
### Group 2 - group project #
### Setup commands for HDFS Single-mode as a solution for data storage
### These commands are built upon the default settings of SNIC cloud's ubuntu 20.04 image
### with out HDFS-namenode IP address in the cloud is 192.168.2.8

# Update package
sudo apt update


# Install java 11
sudo apt install -y openjdk-11-jdk

#Download Hadoop 3.3.0
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz 
tar -xvzf hadoop-3.3.6.tar.gz 

#Configure path variables
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.bashrc
source ~/.bashrc

echo "export HADOOP_HOME=/home/ubuntu/hadoop-3.3.6" >> ~/.bashrc
source ~/.bashrc

echo "export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin" >> ~/.bashrc

source ~/.bashrc

#Configure java for hadoop
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

#Create hadoop data directory
mkdir -p ~/hadoopdata/hdfs/namenode 
mkdir -p ~/hadoopdata/hdfs/datanode 

##Configure hdfs:
#core-site.xml
sed '/^<configuration>$/r'<(
    echo "<property>"
    echo "<name>fs.defaultFS</name>"
    echo "<value>hdfs://192.168.2.8:9000</value>"
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
