### Hadoop-Spark Workbench with Jupyter & Multi-Datanode Setup

"""
🚀 A fully containerized Big Data environment with Hadoop, Spark, and Jupyter Notebook, enhanced with:
👉 3 Datanodes for improved HDFS scalability
👉 Jupyter Notebook (`jupyter/all-spark-notebook`) replacing Spark Notebook
👉 Pre-configured Spark, Hadoop, and Hue for a seamless experience
"""

# Getting Started

1️⃣ Start the Workbench
Run the following command to start the entire stack:
```bash
docker-compose up -d
```

ℹ️ `docker-compose` does not support scaling Spark workers. For a distributed setup, consider using Docker Swarm.

# Running the Workbench with Hive Support

To enable Hive Metastore & Hive Server, start services in this order:

```bash
docker-compose -f docker-compose-hive.yml up -d namenode hive-metastore-postgresql
# docker-compose -f docker-compose-hive.yml up -d datanode hive-metastore
# docker-compose -f docker-compose-hive.yml up -d hive-server
# docker-compose -f docker-compose-hive.yml up -d spark-master spark-worker jupyter hue

# Web Interfaces

"""
| Service         | URL                                  |
|----------------|--------------------------------------|
| Namenode       | http://localhost:9870 |
| Datanodes      | http://localhost:9864 |
| Spark Master   | http://localhost:8080 |
| Jupyter Notebook | http://localhost:8888 |
| Hue (HDFS File Browser) | http://localhost:8088/home |

💡 To access Jupyter Notebook, check the token with:
"""

# docker logs <container_name>

"""
Or disable authentication with:
"""

# command: start-notebook.sh --NotebookApp.token='' --NotebookApp.password=''

"""
⚠️ Security Warning: Do this only in a safe local environment.
"""

# Running Spark in Jupyter

"""
Example of running Spark in Jupyter Notebook:
"""

# from pyspark.sql import SparkSession
# 
# spark = SparkSession.builder.appName("Example").getOrCreate()
# 
# df = spark.read.text("/data.csv")
# df.count()

# Important Notes

"""
🛑 Fixing Hue Access Issues
If you encounter this error in Hue:

NoReverseMatch: u'about' is not a registered namespace

👉 Append `/home` to the URL:
👉 http://localhost:8088/home
"""

# Documentation & Resources

"""
- Original Repository (BDE2020): http://www.big-data-europe.eu/scalable-sparkhdfs-workbench-using-docker/
"""

# Maintainer

"""
* Forked & Customized by [Your Name]
* Originally maintained by Ivan Ermilov (@earthquakesan)

ℹ️ This repository was originally part of the BDE H2020 EU project and is now customized for multi-datanode and Jupyter integration.
"""
