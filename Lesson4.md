## 1.1 Creating a Spark application using Spark SQL
Spark SQL provides the ability to write relational queries to be run on Spark. There is the abstraction SchemaRDD which is to create an RDD in which you can run SQL, HiveQL, and Scala. In this lab section, you will use SQL to find out the average weather and precipitation for a given time period in New York. The purpose is to demonstrate how to use the Spark SQL libraries on Spark.

1. The nycweather data is already on the HDFS under input/tmp/labdata/sparkdata/.

2. Take a look at the nycweather data. Type in:

hdfs dfs -cat input/tmp/labdata/sparkdata/nycweather.csv


There are three columns in the dataset, the date, the mean temperature in Celsius, and the precipitation for the day. Since we already know the schema, we will infer the schema using reflection.


3. Launch the Scala shell:

$SPARK_HOME/bin/spark-shell

4. The sqlContext is created automatically from the sc (Spark Context). You can invoke it right from the docker image.

5. Import the following class to implicit convert an RDD to a DataFrame.

import sqlContext.implicits._

6. Create a case class in Scala that defines the schema of the table. Type in:

case class Weather(date: String, temp: Int, precipitation: Double)

7. Create the RDD of the Weather object:

val weather = sc.textFile("input/tmp/labdata/sparkdata/nycweather.csv").map(_.split(",")).map(w => Weather(w(0), w(1).trim.toInt,w(2).trim.toDouble)).toDF()


You first load in the file, and then you map it by splitting it up by the commas and then another mapping to get it into the Weather class.

8. Next you need to register the RDD as a table. Type in:

weather.registerTempTable("weather")

9. At the point, you are ready to create and run some queries on the RDD. You want to get a list of the hottest dates with some precipitation. Type in:

val hottest_with_precip = sqlContext.sql("SELECT * FROM weather WHERE precipitation > 0.0 ORDER BY temp DESC")


10. Normal RDD operations will work. Print the top hottest days with some precipitation out to the
console:

hottest_with_precip.map(x => ("Date: " + x(0), "Temp : " + x(1),"Precip: " + x(2))).top(10).foreach(println)







## 1.2 Creating a Spark application using MLlib

In this section, the Spark shell will be used to acquire the K-Means clustering for drop-off
latitudes and longitudes of taxis for 3 clusters. The sample data contains a subset of taxi trips
with hack license, medallion, pickup date/time, drop off date/time, pickup/drop off
latitude/longitude, passenger count, trip distance, trip time and other information. As such, this
may give a good indication of where to best to hail a cab.
The data file can be found on the HDFS under /tmp/labdata/sparkdata/nyctaxisub.csv.
Remember, this is only a subset of the file that you used a previous exercise. If you ran this
exercise on the full dataset, it would take a long time as we are only running on a test
environment with limited resources.

1. Start up the Spark shell.
2. Import the needed packages for K-Means algorithm and Vector packages:
import org.apache.spark.mllib.clustering.KMeans
import org.apache.spark.mllib.linalg.Vectors



3. Create an RDD from the HDFS data in 'input/tmp/labdata/sparkdata/nyctaxisub.csv'
val taxiFile = sc.textFile("input/tmp/labdata/sparkdata/nyctaxisub.csv")

4. Determine the number of rows in taxiFile.
taxiFile.count()


5. Cleanse the data.

val taxiData=taxiFile.filter(_.contains("2013")).filter(_.split(",")(3)!="").filter(_.split(",")(4)!="")

The first filter limits the rows to those that occurred in the year 2013. This will also remove any
header in the file. The third and fourth columns contain the drop off latitude and longitude. The
transformation will throw exceptions if these values are empty.

6. Do another count to see what was removed.

taxiFile.count()

In this case, if we had used the full set of data, it would have been filtered out.

7. To fence the area roughly to New York City, copy in this command:

val taxiFence=taxiData.filter(_.split(",")(3).toDouble>40.70).
filter(_.split(",")(3).toDouble<40.86).
filter(_.split(",")(4).toDouble>(-74.02)).
filter(_.split(",")(4).toDouble<(-73.93))


8. Determine how many are left in taxiFence:

taxiFence.count()

Approximately, 43,354 rows were dropped since these drop-off points are outside of New York
City.

9. Create Vectors with the latitudes and longitudes that will be used as input to the K-Means
algorithm.
val taxi=taxiFence.map{line=>Vectors.dense(line.split(',').slice(3,5).map(_.toDouble))}

10. Run the K-Means algorithm. To make sure it works properly, copy and paste one line at a time.

val iterationCount=10
val clusterCount=3
val model=KMeans.train(taxi,clusterCount,iterationCount)
val clusterCenters=model.clusterCenters.map(_.toArray)
val cost=model.computeCost(taxi)
clusterCenters.foreach(lines=>println(lines(0),lines(1)))


## 1.3 Creating a Spark application using Spark Streaming

This section focuses on Spark Streams, an easy to build, scalable, stateful (e.g. sliding windows) stream
processing library. Streaming jobs are written the same way Spark batch jobs are coded and support
Java, Scala and Python. In this exercise, taxi trip data will be streamed using a socket connection and
then analyzed to provide a summary of number of passengers by taxi vendor. This will be implemented
in the Spark shell using Scala.
There are two files under /home/virtuser/labdata/streams. The first one is the nyctaxi100.csv which will
serve as the source of the stream. The other file is a python file, taxistreams.py, which will feed the csv
file through a socket connection to simulate a stream.
Once started, the program will bind and listen to the localhost socket 7777. When a connection is made,
it will read ‘nyctaxi100.csv’ and send across the socket. The sleep is set such that one line will be sent
every 0.5 seconds, or 2 rows a second. This was intentionally set to a high value to make it easier to
view the data during execution.

1. Open a new terminal.
2. Create a new folder, PythonStreams under /home/virtuser.

mkdir -p /home/virtuser/PythonStreams

3. Copy the taxistream.py and the nyctaxi100.csv file.

cp /opt/ibm/labfiles/streams/nyctaxi100.csv /home/virtuser/PythonStreams
cp /opt/ibm/labfiles/streams/taxistreams.py /home/virtuser/PythonStreams

4. Update the contents of the /home/virtuser/taxistreams.py file to reflect the path of the
nyctaxi100.csv. The file current looks for the nyctaxi100.csv file under:


/home/biadmin/PythonStreams/. Change it to /home/virtuser/PythonStreams/.


5. Change directory into the PythonStreams folder.


6. To invoke the standalone Python program, issue the following command:

python taxistreams.py

The program has been started and is awaiting Spark Streams to connect and receive the data.

7. Start a new docker window.
docker exec -it bdu_spark bash

8. Start the spark-shell.
$SPARK_HOME/bin/spark-shell

9. Turn off logging for this shell so that you can see the output of the application:

import org.apache.log4j.Logger
import org.apache.log4j.Level
Logger.getLogger("org").setLevel(Level.OFF)
Logger.getLogger("akka").setLevel(Level.OFF)



10. Import the required libraries. Copy and paste this into the shell.
import org.apache.spark._
import org.apache.spark.streaming._
import org.apache.spark.streaming.StreamingContext._


11. Create the StreamingContext by using the existing SparkContext (sc). It will be using a 1 second window, which means the stream is divided to 1 second batches and each batch becomes a RDD. This is intentional to make it easier to read the data during execution.
val ssc = new StreamingContext(sc,Seconds(1))

12. Create the socket stream that connects to the localhost socket 7777. This matches the port that the Python script is listening. Each stream will be a lines RDD.

val lines = ssc.socketTextStream("localhost",7777)

13. Next, put in the business logic to split up the lines on each comma and mapping pass(15), which is the vendor, and pass(7), which is the passenger count. Then this is reduced by key resulting in a summary of number of passengers by vendor.

val pass = lines.map(_.split(",")).
map(pass=>(pass(15),pass(7).toInt)).
reduceByKey(_+_)

14. Print out to the console. This command tells Spark streaming to print, but it doesn't exactly print
it yet because our application hasn't started. The next step will start the application.
pass.print()


15. The next two lines starts the stream. Copy and paste both in at once.
ssc.start()
ssc.awaitTermination()


16. It will take a few cycles for the connection to be recognized, and then the data is sent. In this
case, 2 rows per second of taxi trip data is receive in a 1 second window.

17. In the Python terminal, the contents of the file are printed as they are streamed.



18. Use CTRL+C to get out of each terminal window to stop the programs.
This is just a simple example showing how you can take streaming data into Spark and do some
type of processing on it. In the case here, the taxi and the number of passengers was extracted
from the data stream.




## 1.4 Creating a Spark application using GraphX


1. For this exercise, you will need to copy users.txt and follwers.txt from the local image to the HDFS under your own user directory. Issue these commands:

hdfs dfs -put /opt/ibm/labfiles/users.txt input/tmp
hdfs dfs -put /opt/ibm/labfiles/followers.txt input/tmp


2. Users.txt is a set of users and followers is the relationship between the users. Take a look at the contents of these two files.

hdfs dfs -cat input/tmp/users.txt
hdfs dfs -cat input/tmp/followers.txt


3. Start up the spark-shell:

$SPARK_HOME/bin/spark-shell

4. Import the GraphX package:

import org.apache.spark.graphx._

5. Create the users RDD and parse into tuples of user id and attribute list:

val users = (sc.textFile("input/tmp/users.txt").map(line => line.split(",")).map(parts => (parts.head.toLong, parts.tail)))

6. Parse the edge data, which is already in userId -> userId format

val followerGraph = GraphLoader.edgeListFile(sc, "input/tmp/followers.txt")


7. Attach the user attributes

val graph = followerGraph.outerJoinVertices(users) {
 case (uid, deg, Some(attrList)) => attrList
 case (uid, deg, None) => Array.empty[String]
}

8. Restrict the graph to users with usernames and names:

val subgraph = graph.subgraph(vpred = (vid, attr) => attr.size == 2)



9. Compute the PageRank

val pagerankGraph = subgraph.pageRank(0.001)

10. Get the attributes of the top pagerank users

val userInfoWithPageRank = subgraph.outerJoinVertices(pagerankGraph.vertices) {
 case (uid, attrList, Some(pr)) => (pr, attrList.toList)
 case (uid, attrList, None) => (0.0, attrList.toList)
}


11. Print the line out:
println(userInfoWithPageRank.vertices.top(5)(Ordering.by(_._2._1)).mkString("\n"))


## Summary
Having completed this exercise, you should have some familiarity with using the Spark libraries. IN
particular, you use Spark SQL to effectively query data inside of Spark. You used Spark Streaming to
process incoming streams of batch data. You used Spark's MLlib to compute the K-Means algorithm to
find the best place to hail a cab. Finally, you used Spark's GraphX library to perform and parallel graph
calculations on a dataset to find the attributes of the top users.


