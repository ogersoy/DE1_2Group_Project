from pyspark.sql import SparkSession

# Configure Spark for HDFS (replace with your actual configuration)
conf = SparkConf() \
    .setAppName("Group1_2 Project") \
    .set("spark.hadoop.dfs.namenode", "hdfs://namenode:9000") \
    .set("spark.sql.warehouse.dir", "hdfs://namenode/user/hive/warehouse")

# Create SparkSession with HDFS configuration
spark = SparkSession.builder.config(conf).getOrCreate()

# Read JSON data from HDFS path (replace with your actual path)
data = spark.read.json("hdfs://path/to/corpus-webis-tldr-17.json")

# Get the number of executors in the cluster (replace with your preferred method)
print("Number of executors: ", spark._jsc.sc().getExecutorMemory())
num_executors = spark._jsc.sc().getExecutorMemory()  # Example method, replace if needed

# Calculate a base number of partitions based on executors
base_partitions = num_executors * 2

# Retrieve data size from configuration
data_size_gb = float(spark.conf.get("data.size.in.gb"))

# Calculate additional partitions based on data size (adjust multiplier)
additional_partitions = int(data_size_gb * 0.5)  # Adjust multiplier as needed

# Combine base and additional partitions, ensuring a minimum
num_partitions = max(base_partitions, additional_partitions)

# Repartition data with dynamically calculated number of partitions
preprocessed_data = preprocessed_data.repartition(num_partitions)

# Preprocess data for summarization
# 1. Lowercase: Convert text to lowercase for case-insensitive processing
preprocessed_data = data.withColumn("content_lower", lower(col("content"))) \
                             .withColumn("summary_lower", lower(col("summary")))

# 2. Remove leading/trailing whitespaces: Trim unnecessary spaces
preprocessed_data = preprocessed_data.withColumn("content_clean", trim(col("content_lower"))) \
                             .withColumn("summary_clean", trim(col("summary_lower")))

# ... further preprocessing steps if needed (e.g., removing punctuation, stop words)x"

# Stop SparkSession
spark.stop()