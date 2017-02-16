from pyspark.sql import HiveContext
from pyspark import SparkConf, SparkContext
conf = SparkConf().setAppName('SparkHiveTest')
sc = SparkContext(conf=conf)
hctx = HiveContext(sc)


#stmt_load = hctx.sql('load data INPATH "/tmp/ambari-qa/data.txt" INTO TABLE vero1')
stmt_select = hctx.sql('select * from vero1')
#write data as parquet files
stmt_select.select("c").write.save("/tmp/output_verox")
