# Configuring and monitoring Spark applications
This lab exercise will show you where you can specify configurations for your Spark environment. It will introduce you to some monitoring tools and methods for tuning Spark applications.
After completing this hands-on lab, you should be able to:

* Understand how to configure, monitor and tune Spark applications.
g
## 1.1 Configuring Spark applications
Spark properties control most application settings and are configured separately for each
application. These properties can be set *directly on the SparkConf object and passed to your
SparkContext*. You can also set properties by providing it at runtime. For example, submitting a
job using the spark-submit command and passing in arguments to that command. In this section,
you will set some common properties.


1. REFERENCE ONLY: This doesn't work in the docker image, but is shown here for reference.
Change the logging from INFO to ERROR so that only the pertinent information shows up,
otherwise the console can be quite verbose. Open up and edit the

$SPARK_HOME/conf/log4j.properties


file. If that file does not exist, make a copy of the
log4j.properties.template one and rename it to log4j.properties.


Next, launch a Spark shell with two cores. You should notice that *you no longer see INFO
messages on the console*.


$SPARK_HOME/bin/spark-shell --master local[2]

This launches a shell that is only going to utilize two cores on the node, which is the minimum
number of cores needed for parallelism. Go ahead and quit out of the Spark shell.

2. The spark-submit command supports loading configurations dynamically. In fact, this is probably
the more common usage of loading configurations. You have seen this used in previous lab
exercises when you ran sample applications as well as the ones you developed.


3. Additionally, the spark-submit will also read configurations options from conf/spark-defaults.conf.

Let's look at it now:
cat $SPARK_HOME/conf/spark-defaults.conf.template



## 1.2 Monitoring Spark applications (REFERENCE for BigInsights v4 QSE only)

1. To view the history server, you can find the port by going to the Ambari console and accessing Spark on the Cluster Status tab:


2. To access the history server, click on the Quick Links:

The history server lists the applications that ran recently. Your screenshot will be different from
what you see here. The app will only show up after it has finished running.

3. Let's go through a simple example to see how caching affects the storage. Create a RDD from the README.md file.

val readme = sc.textFile("/tmp/README.md")

4. Cache the readme RDD.
readme.cache()

5. Print the information out onto the console. Remember that transformations do not get applied until some action takes place. This is why we're going printing it out to the console using the collect() action.

readme.collect()
6. Quit out of the Spark shell so the entry appears in the history server page.

7. CTRL + D

8. Refresh the history server page to see the new listing of the Spark shell that you just used to run
the simple example. Click on the link of that shell for more information.


9. Click the Stages link on the menu:

10. Click on the collect stage to view the details of that run:


11. There are four sections at the top: Click on the Storage section.

12. You can see that the README.MD file was cached along with the size in memory and the
number of cached partitions. f you click on the link, you can see in more detail which blocks and
executors that file is distributed:

A lot of the monitoring tools can be used to help to with tuning. For example, the previous task
that you just did to cache a RDD is actually a good method to use for figuring out how much
memory each partition is consuming.


Summary
Having completed this exercise, you should have a basic understanding of how to specify various Spark
configurations through the SparkConf object, as parameters through the spark-submit or spark-shell
commands, or by specifying defaults in the spark-defaults.conf file. You also launched the history server
Web UI to check out the Spark application that you ran. 
