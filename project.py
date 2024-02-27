from pyspark.sql import SparkSession

# Configure Spark for HDFS (replace with your actual configuration)
conf = SparkConf() \
    .setAppName("Reddit Data Analysis") \
    .set("spark.hadoop.dfs.namenode", "hdfs://namenode:9000") \
    .set("spark.sql.warehouse.dir", "hdfs://namenode/user/hive/warehouse")

# Create SparkSession with HDFS configuration
spark = SparkSession.builder.config(conf).getOrCreate()

# Read JSON data from HDFS path (replace with your HDFS path)
data = spark.read.json("hdfs://path/to/corpus-webis-tldr-17.json")

# Analyze content length distribution
content_length_stats = data.select("content_len").describe()
content_length_stats.show()

# Analyze summary length distribution
summary_length_stats = data.select("summary_len").describe()
summary_length_stats.show()

# Filter data by subreddit (example)
filtered_data = data.filter(data["subreddit"] == "funny")

# You can further analyze the filtered data here

# Stop SparkSession
spark.stop()

# Stop SparkSession
spark.stop()
