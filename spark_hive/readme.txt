run test_hs.py with:
/usr/iop/current/spark-client/bin/spark-submit --master yarn-cluster \
--jars /usr/iop/current/spark-client/lib/datanucleus-api-jdo-3.2.6.jar,\
/usr/iop/current/spark-client/lib/datanucleus-core-3.2.10.jar,\
/usr/iop/current/spark-client/lib/datanucleus-rdbms-3.2.9.jar \
--files /usr/iop/current/spark-client/conf/hive-site.xml test_hs.py
