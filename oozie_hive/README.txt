Pre-req:
-------------
Edit job.properties to match your environment.
Edit workflow.xml to match your environment for beeline.

Copy to hdfs under /tmp/ambari-qa/ the following files:
	workflow.xml
	script.sql
	hive-site.xml

Note: For kerberised environments use workflow_kerberos.xml

Prepare HDFS dir:
hadoop fs -mkdir /tmp/ambari-qa
hadoop fs -chmod 777 /tmp/ambari-qa
hadoop fs -put /usr/iop/4.2.0.0/ /user/oozie/share/lib/lib_20170124133148/hive2/
hadoop fs -put /usr/iop/4.2.0.0/hive/lib/hive-exec-1.2.1-IBM-27.jar /user/oozie/share/lib/lib_20170124133148/hive2/
hadoop fs -chmod 777 /user/oozie/share/lib/lib_20170124133148/hive2/hive-common-1.2.1-IBM-27.jar
hadoop fs -chmod 777 /user/oozie/share/lib/lib_20170124133148/hive2/hive-exec-1.2.1-IBM-27.jar


Note: This line may be required in job.properties:
oozie.libpath=hdfs://vm24x50:/user/oozie/share/lib/lib_20161114105536/hive2

Note: In job.properties, jobTracker port might be 8032. Check your environment.
The jobTracker host is the node where Yarn Resource Manager runs
NameNode port can be checked from NameNode UI link in Ambari UI

Note: hive-site.xml can be found at: /etc/hive/4.2.0.0/0/hive-site.xml

Check hive-site.xml is under /tmp/ambari-qa/ dir in HDFS as per:
<job-xml>/tmp/ambari-qa/hive-site.xml</job-xml> from workflow.xml



Run this test with:
-----------------
oozie job --oozie http://vm24x52.barry.com:11000/oozie \
-config /home/ambari-qa/job.properties  \
-Doozie.wf.application.path=hdfs://vm24x50:/tmp/ambari-qa/workflow.xml -run

Note: replace oozie server name and hdfs node

Example for Kerberos environment:
----------------------------------------
oozie job --oozie https://ukpoc5x015.veronica.com:11443/oozie \
-config /ibm_stuff/oozie_hive/job.properties  
-Djavax.net.ssl.trustStore=//ibm_stuff/oozie_hive/oozie.truststore \
-auth kerberos \
-Doozie.wf.application.path=hdfs://ukpoc5x016:/tmp/ambari-qa/workflow.xml -run

where : 
ukpoc5x016 = active name node
ukpoc5x015 = oozie server 
OOZIE_HTTP_PORT=11000
Keystore path Default value ${HOME}/.keystore (i.e. the home dir of the Oozie user).


Check job progress at: https://vm24x50.barry.com:8443/gateway/oozieui/oozie/
---------------------

Expected result:
------------------
In HDFS:
drwxrwxrwx   - hive      hdfs          0 2017-02-15 04:32 /tmp/ambari-qa/ooziehive

In Hive:
Table ooziehive created.

Connect to hive using:
[ambari-qa@vm24x50 oozie_hive]$ beeline
beeline> !connect jdbc:hive2://vm24x52:10000/ambariqatest
Connecting to jdbc:hive2://vm24x52:10000/ambariqatest
Enter username for jdbc:hive2://vm24x52:10000/ambariqatest: ambari-qa
Enter password for jdbc:hive2://vm24x52:10000/ambariqatest: ***************
Connected to: Apache Hive (version 1.2.1-IBM-22)
Driver: Hive JDBC (version 1.2.1-IBM-22)
Transaction isolation: TRANSACTION_REPEATABLE_READ
0: jdbc:hive2://vm24x52:10000/ambariqatest> show tables;
+------------+--+
|  tab_name  |
+------------+--+
| ooziehive  |
+------------+--+
1 row selected (0.134 seconds)
0: jdbc:hive2://vm24x52:10000/ambariqatest>







-----------------------------------------------------------------
Example for Kerberos enabled environment:
------------------------------------------------------------------
job.properties:

nameNode=hdfs://ukpoc5x016:8020
jobTracker=ukpoc5x015:8050
jdbcURL=jdbc:hive2://ukpoc5x017.veronica.com:10000/default
jdbcPrincipal=hive/_HOST@VERONICA.COM
hivescript=${nameNode}/tmp/ambari-qa/script.sql
oozie.use.system.libpath=true



workflow.xml:

<?xml version="1.0" encoding="UTF-8"?>
<workflow-app xmlns="uri:oozie:workflow:0.4" name="simple-Workflow">
<global>
    <job-tracker>${jobTracker}</job-tracker>
    <name-node>${nameNode}</name-node>
</global>
 <credentials>
    <credential name="hs2-creds" type="hive2">
      <property>
        <name>hive2.server.principal</name>
        <value>${jdbcPrincipal}</value>
      </property>
      <property>
       <name>hive2.jdbc.url</name>
         <value>${jdbcURL}</value>
      </property>
    </credential>
  </credentials>

   <start to="Create_External_Table" />
   <action name="Create_External_Table" cred="hs2-creds">
   <hive2 xmlns="uri:oozie:hive2-action:0.1">
     <jdbc-url>${jdbcURL}</jdbc-url>
        <script>${hivescript}</script>
      </hive2>
      <ok to="end" />
      <error to="kill_job" />
   </action>
   <kill name="kill_job">
      <message>Job failed</message>
   </kill>
   <end name="end" />
</workflow-app>

