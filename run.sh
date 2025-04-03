#!/bin/bash
rm -f /opt/spark-notebook/RUNNING_PID  # Remove stale PID file
exec /opt/spark-notebook/bin/spark-notebook -Dconfig.file=/opt/spark-notebook/conf/application.conf
