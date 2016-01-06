http://localhost:8081/

# Resilient Distributed Datasets (RDD)
two types of RDD operations:

* transformations 
*  actions. 

Transformations return a pointer to the new RDD. Actions return the value
of the operation. RDD transformations are lazy evaluations. This means nothing is processed until an
action occurs. E


## Prepration 


docker start bdu_spark
docker attach bdu_spark
/etc/bootstrap.sh


Note: The Hadoop name node may be in safe mode. Exit the safe mode by entering in:
	hdfs dfsadmin -safemode leave


hdfs dfs –put /opt/ibm/labfiles/<log filename> input/tmp/sparkLog.out



hdfs dfs -put /opt/ibm/labfiles/spark-spark-org.apache.spark.sql.hive.thriftserver.HiveThriftServer2-1-rvm.svl.ibm.com.out.5  input/tmp/sparkLog.out


hdfs dfs -put /opt/ibm/labfiles/CHANGES.txt input/tmp
hdfs dfs -ls input/tmp/


## Scala


1. Start the Scala Spark shell:

$SPARK_HOME/bin/spark-shell

2. Create a RDD by loading in that log file:

val logFile = sc.textFile("input/tmp/sparkLog.out")



* 3. Filter out the lines that contains INFO (or ERROR, if the particular log has it)
val info = logFile.filter(line => line.contains("INFO"))



* 4. Count the lines:
info.count()

* 5. Count the lines with Spark in it by combining transformation and action.

info.filter(line => line.contains("spark")).count()

* 6. Fetch those lines as an array of Strings

info.filter(line => line.contains("spark")).collect()

7. Remember that we went over the DAG. It is what provides the fault tolerance in Spark. Nodes
can re-compute its state by borrowing the DAG from a neighboring node. You can view the
graph of an RDD using the toDebugString command.

info.toDebugString



8. Next, you are going to create RDDs for the README and the CHANGES file.


val readmeFile = sc.textFile("input/tmp/README.md")
val changesFile = sc.textFile("input/tmp/CHANGES.txt")


9. How many Spark keywords are in each file?

readmeFile.filter(line => line.contains("Spark")).count()
changesFile.filter(line => line.contains("Spark")).count()

__10. Now do a WordCount on each RDD so that the results are (K,V) pairs of (word,count)

val readmeCount = readmeFile.flatMap(line => line.split(" ")).map(word => (word, 1)).reduceByKey(_ + _)
val changesCount = changesFile.flatMap(line => line.split(" ")).map(word => (word, 1)).reduceByKey(_ + _)



11. To see the array for either of them, just call the collect function on it.

readmeCount.collect()
changesCount.collect()

12. Now let's join these two RDDs together to get a collective set. The join function combines the
two datasets (K,V) and (K,W) together and get (K, (V,W)). Let's join these two counts together

val joined = readmeCount.join(changesCount)


13. Cache the joined dataset.
joined.cache()



14. Print the value to the console:

joined.collect.foreach(println)


15. Let's combine the values together to get the total count. The operations in this command tells Spark to combine the go from (K,V) and (K,W) to (K, V+W). The ._ notation is a way to access
the value on that particular index of the key value pair.

val joinedSum = joined.map(k => (k._1, (k._2)._1 + (k._2)._2))
joinedSum.collect()

16. To check if it is correct, print the first five elements from the joined and the joinedSum RDD
joined.take(5).foreach(println)
joinedSum.take(5).foreach(println)


###  1.2.3 Shared variables


*Broadcast variables* are useful for when you have a large dataset that you want to use across all
the worker nodes. Instead of having to send out the entire dataset, only the variable is sent out.


__17. In the same shell from the last section, create a broadcast variable. Type in
val broadcastVar = sc.broadcast(Array(1,2,3))

__18. To get the value, type in:
broadcastVar.value

*Accumulators* are variables that can only be added through an associative operation. It is used to
implement counters and sum efficiently in parallel. Spark natively supports numeric type
accumulators and standard mutable collections. Programmers can extend these for new types.
Only the driver can read the values of the accumulators. The workers can only invoke it to
increment the value.



__19. Create the accumulator variable. Type in:

val accum = sc.accumulator(0)

__20. Next parallelize an array of four integers and run it through a loop to add each integer value to the accumulator variable. Type in:

sc.parallelize(Array(1,2,3,4)).foreach(x => accum += x)

__21. To get the current value of the accumulator variable, type in:

accum.value

You should get a value of 10. This command can only be invoked on the driver side.
The worker nodes can only increment the accumulator.





## 1.2.4 Key-value pairs

You have already seen a bit about key-value pairs in the Joining RDD section. Here is a brief
example of how to create a key-value pair and access its values. Remember that certain
operations such as map and reduce only works on key-value pairs.

__22. Create a key-value pair of two characters. Type in:

val pair = ('a', 'b')

__23. To access the value of the first index, type in:

pair._1

__24. To access the value of the second index, type in:

pair._2

__25. Quit the Scala shell by typing in



# 1.3 RDD operations using Python

1.3.1 Analyzing a log file
1. Start the Python Spark shell:

$SPARK_HOME/bin/pyspark

2. Create a RDD by loading in that log file:

logFile = sc.textFile("input/tmp/sparkLog.out")

3. Filter out the lines that contains INFO (or ERROR, if the particular log has it)

info = logFile.filter(lambda line: "INFO" in line)

4. Count the lines:

info.count()

5. Count the lines with Spark in it by combining transformation and action.

info.filter(lambda line: "spark" in line).count()

6. Fetch those lines as an array of Strings

info.filter(lambda line: "spark" in line).collect()

7. View the graph of an RDD using this command:
info.toDebugString


## 1.3.2 Joining RDDs


8. Next, you are going to create RDDs for the README and the CHANGES file.
readmeFile = sc.textFile("input/tmp/README.md")


changesFile = sc.textFile("input/tmp/CHANGES.txt")

9. How many Spark keywords are in each file?

readmeFile.filter(lambda line: "Spark" in line).count()
changesFile.filter(lambda line: "Spark" in line).count()

10. Now do a WordCount on each RDD so that the results are (K,V) pairs of (word,count)

readmeCount = readmeFile.flatMap(lambda line: line.split(" ")).map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b)
changesCount = changesFile.flatMap(lambda line: line.split(" ")).map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b)

11. To see the array for either of them, just call the collect function on it.

readmeCount.collect()
changesCount.collect()

12. The join function combines the two datasets (K,V) and (K,W) together and get (K, (V,W)). Let's

join these two counts together
joined = readmeCount.join(changesCount)

13. Cache the joined dataset.

joined.cache()

14. Print the value to the console
joined.collect()

15. Let's combine the values together to get the total count

joinedSum = joined.map(lambda k: (k[0], (k[1][0]+k[1][1])))

16. To check if it is correct, print the first five elements from the joined and the joinedSum RDD

joined.take(5)
joinedSum.take(5)



## 1.3.3 Shared variables

*Broadcast variables* are useful for when you have a large dataset that you want to use across all
the worker nodes. Instead of having to send out the entire dataset, only the variable is sent out.


17. In the same shell from the last section, create a broadcast variable. Type in

broadcastVar = sc.broadcast(list(range(1,4)))

18. To get the value, type in:

broadcastVar.value


*Accumulators*  are variables that can only be added through an associative operation. It is used to
implement counters and sum efficiently in parallel. Spark natively supports numeric type
accumulators and standard mutable collections. Programmers can extend these for new types.
Only the driver can read the values of the accumulators. The workers can only invoke it to
increment the value.

19. Create the accumulator variable. Type in:

accum = sc.accumulator(0)

20. Next parallelize an array of four integers and run it through a loop to add each integer value to the accumulator variable. Type in:

rdd = sc.parallelize([1,2,3,4])
def f(x):
	global accum
	accum += x

21. Next, iterate through each element of the rdd and apply the function f on it:

rdd.foreach(f)

22. To get the current value of the accumulator variable, type in:

accum.value

You should get a value of 10.
This command can only be invoked on the driver side. The worker nodes can only increment the accumulator.




1.3.4 Key-value pairs
You have already seen a bit about key-value pairs in the Joining RDD section. 

23. Create a key-value pair of two characters. Type in:

pair = ('a', 'b')

24. To access the value of the first index, type in:

pair[0]

25. To access the value of the second index, type in:

pair[1]

26. Quit the pyspark shell.
CTRL + D




# 1.4 Sample Application using Scala

In this section, you will be using a subset of a data for taxi trips that will determine the top 10 medallion
numbers based on the number of trips. You will be doing this using the Spark shell with Scala.

1. For this exercise, you will have to load additional taxi data into the HDFS. Under the input/tmp
directory, create two additional directories under it. input/tmp/labdata/sparkdata/

hdfs dfs -mkdir input/tmp/labdata/
hdfs dfs -mkdir input/tmp/labdata/sparkdata/

2. Next, upload three csv files under sparkdata: nyctaxi.csv, nyctaxisub.csv, and nycweather.csv.

hdfs dfs -put /opt/ibm/labfiles/nyctaxi/nyctaxi.csv  input/tmp/labdata/sparkdata/
hdfs dfs -put /opt/ibm/labfiles/nyctaxisub/nyctaxisub.csv input/tmp/labdata/sparkdata/
hdfs dfs -put /opt/ibm/labfiles/nycweather/nycweather.csv input/tmp/labdata/sparkdata/

It is going to take a while to upload the nyctaxi.csv data. It is a fairly large file. For this lab
exercise, you will only use the nyctaxi data. The others will be used at a later time.


3. Do a listing of the directory to make sure all three files were uploaded:

hdfs dfs -ls input/tmp/labdata/sparkdata/


4. Start up the spark shell
$SPARK_HOME/bin/spark-shell

5. Create an RDD from the HDFS data in 'input/tmp/labdata/sparkdata/nyctaxi.csv'

val taxi = sc.textFile("input/tmp/labdata/sparkdata/nyctaxi.csv")

6. To view the five rows of content, invoke the take function. Type in:

taxi.take(5).foreach(println)


Note that the first line is the headers. Normally, you would want to filter that out, but since it will
not affect our results, we can leave it in.


7. To parse out the values, including the medallion numbers, you need to first create a new RDD by
splitting the lines of the RDD using the comma as the delimiter. Type in:

val taxiParse = taxi.map(line=>line.split(","))




8. Now create the key-value pairs where the key is the medallion number and the value is 1. We
use this model to later sum up all the keys to find out the number of trips a particular taxi took
and in particular, will be able to see which taxi took the most trips. Map each of the medallions to
the value of one. Type in:

val taxiMedKey = taxiParse.map(vals=>(vals(6), 1))


vals(6) corresponds to the column where the medallion key is located

9. Next use the reduceByKey function to count the number of occurrence for each key.

val taxiMedCounts = taxiMedKey.reduceByKey((v1,v2)=>v1+v2)

10. Finally, the values are swapped so they can be ordered in descending order and the results are
presented correctly.

for (pair <-taxiMedCounts.map(_.swap).top(10)) println("Taxi Medallion %s had %s Trips".format(pair._2, pair._1))


11. While each step above was processed one line at a time, you can just as well process everything on one line:
val taxiMedCountsOneLine = taxi.map(line=>line.split(',')).map(vals=>(vals(6),1)).reduceByKey(_ + _)

12. Run the same line as above to print the taxiMedCountsOneLine RDD.

for (pair <-taxiMedCountsOneLine.map(_.swap).top(10)) println("Taxi Medallion %s had %s Trips".format(pair._2, pair._1))

13. Let's cache the taxiMedCountsOneLine to see the difference caching makes. Run it with the logs set to INFO and you can see the output
of the time it takes to execute each line. First, let's cache the RDD

taxiMedCountsOneLine.cache()

14. Next, you have to invoke an action for it to actually cache the RDD. Note the time it takes here (either empirically using the INFO log or just notice the time it takes)

taxiMedCountsOneLine.count()



15. Run it again to see the difference.

taxiMedCountsOneLine.count()

The bigger the dataset, the more noticeable the difference will be. In a sample file such as ours, the difference may be negligible.
