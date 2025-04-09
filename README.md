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
docker-compose -f docker-compose-hive.yml up -d datanode hive-metastore
docker-compose -f docker-compose-hive.yml up -d hive-server
docker-compose -f docker-compose-hive.yml up -d spark-master spark-worker jupyter hue
```
# Web Interfaces

| Service         | URL                                  |
|----------------|--------------------------------------|
| Namenode       | http://localhost:9870 |
| Datanode1      | http://localhost:9864 |
| Datanode2      | http://localhost:9865 |
| Datanode3      | http://localhost:9866 |
| Ressource Manager | http://localhost:8089 |
| History Server | http://localhost:8188 |
| Node Manager   | http://localhost:8042 |
| Spark Master   | http://localhost:8080 |
| Spark Worker   | http://localhost:8081 |
| Jupyter Notebook | http://localhost:8888 |
| Hue (HDFS File Browser) | http://localhost:8088/home |

⚠️ Note: The ResourceManager normally uses port 8088, but we've mapped it to 8089 because Hue also uses port 8088 by default. This prevents a port conflict when both services are running simultaneously.

# Jupyter Notebook

💡 To access Jupyter Notebook, check the token with:
```bash
docker logs <container_name>
```

Or disable authentication with:
```bash
command: start-notebook.sh --NotebookApp.token='' --NotebookApp.password=''
```

⚠️ Security Warning: Do this only in a safe local environment.


# Running Spark in Jupyter

Example of running Spark in Jupyter Notebook:

```python
from pyspark.sql import SparkSession
 
spark = SparkSession.builder.appName("Example").getOrCreate()
 
df = spark.read.text("/data.csv")
df.count()
```
# Important Notes

🛑 Fixing `Namenode` and `Datanode` Port Issues:

By default, the image you are using for `Namenode` and `Datanodes` is configured with old ports (50010 for Namenode and 50075 for Datanodes), which may not work when accessing them through the web UI. the ports are updated in the `docker-compose.yml` file but we also need to modify the HDFS configuration (`hdfs-site.xml`) inside the containers.

👉Step-by-Step Guide to Fix Ports

1. Update Namenode Port 
   
To update the Namenode port (from the old default 50010), access the Namenode container by the following command:

```bash
docker exec -it namenode
```

Then, run this command to replace the default port in the hdfs-site.xml:

```bash
sed -i '/<property><name>dfs.namenode.http-address<\/name><value><\/value><\/property>/d; /<\/configuration>/i <property>\n  <name>dfs.namenode.http-address<\/name>\n  <value>0.0.0.0:9870<\/value>\n<\/property>' /opt/hadoop-2.8.0/etc/hadoop/hdfs-site.xml
```

This will remove the old port definition and add the new port (9870).

2. Update Datanode Port 
   
For Datanode1, follow the same steps:

```bash
docker exec -it datanode1 bash
```

Then run the following command to update the ports in hdfs-site.xml:

```bash
sed -i -e '/<property><name>dfs.namenode.http-address<\/name><value><\/value><\/property>/d' \
-e '/<\/configuration>/i\    <property><name>dfs.namenode.http-address</name><value>0.0.0.0:9870</value></property>' \
-e '/<\/configuration>/i\    <property><name>dfs.datanode.http.address</name><value>0.0.0.0:9864</value></property>' \
-e '/<\/configuration>/i\    <property><name>dfs.datanode.https.address</name><value>0.0.0.0:9865</value></property>' \
-e '/<\/configuration>/i\    <property><name>dfs.datanode.address</name><value>0.0.0.0:9866</value></property>' \
-e '/<\/configuration>/i\    <property><name>dfs.datanode.ipc.address</name><value>0.0.0.0:9867</value></property>' \
-e '/<\/configuration>/i\    <property><name>dfs.namenode.rpc-bind-host</name><value>0.0.0.0</value></property>' \
-e '/<\/configuration>/i\    <property><name>dfs.namenode.servicerpc-bind-host</name><value>0.0.0.0</value></property>' \
-e '/<\/configuration>/i\    <property><name>dfs.namenode.http-bind-host</name><value>0.0.0.0</value></property>' \
-e '/<\/configuration>/i\    <property><name>dfs.namenode.https-bind-host</name><value>0.0.0.0</value></property>' \
-e '/<\/configuration>/i\    <property><name>dfs.client.use.datanode.hostname</name><value>true</value></property>' \
-e '/<\/configuration>/i\    <property><name>dfs.datanode.use.datanode.hostname</name><value>true</value></property>' \
/opt/hadoop-2.8.0/etc/hadoop/hdfs-site.xml
```

This command will remove the old port definitions and add the new ones for the Datanode and Namenode.

👉Repeat the same steps for `datanote2` and `datanote3`

3. Restart the Hadoop containers
   
After modifying the `hdfs-site.xml` file, it is necessary to restart the Hadoop services (NameNode and DataNode) to apply the new configurations.

👉Restart the NameNode: 

```bash
docker restart namenode
```
👉Restart the DataNode: 

```bash
docker restart datanode
```

🛑 Fixing Hue Access Issues
If you encounter this error in Hue:

NoReverseMatch: u'about' is not a registered namespace

👉 Append `/home` to the URL:
👉 http://localhost:8088/home

# Documentation & Resources

- Original Repository (BDE2020): http://www.big-data-europe.eu/scalable-sparkhdfs-workbench-using-docker/


# Maintainer

* Forked & Customized by Ichraq HAMMIOUI
* Originally maintained by Ivan Ermilov (@earthquakesan)

ℹ️ This repository was originally part of the BDE H2020 EU project and is now customized for multi-datanode and Jupyter integration.

