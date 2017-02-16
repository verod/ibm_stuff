hdfs dfs -rm -R  /test/10gsort/input
hdfs dfs -rm -R  /test/10gsort/output
hadoop jar /usr/iop/4.2.0.0/hadoop-mapreduce/hadoop-mapreduce-examples.jar teragen 10000000000 /test/10gsort/input
hadoop jar /usr/iop/4.2.0.0/hadoop-mapreduce/hadoop-mapreduce-examples.jar  terasort /test/10gsort/input /test/10gsort/output
