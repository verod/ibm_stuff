#!/bin/bash
hadoop dfs -rm -r -skipTrash  /tmp/ambari-qa/yarntest/10gsort/input
hadoop dfs -rm -r -skipTrash  /tmp/ambari-qa/yarntest/10gsort/output
hadoop jar /usr/iop/4.2.0.0/hadoop-mapreduce/hadoop-mapreduce-examples.jar teragen 10000 /tmp/ambari-qa/yarntest/10gsort/input
hadoop jar /usr/iop/4.2.0.0/hadoop-mapreduce/hadoop-mapreduce-examples.jar  terasort /tmp/ambari-qa/yarntest/10gsort/input /tmp/ambari-qa/yarntest/10gsort/output
