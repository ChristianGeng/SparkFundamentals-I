
# Accessing the docker container: 

## Start interactively 
docker run -it --hostname bigdatauniversitySpark --name bdu_spark -P -p 8080:8080 -p 8081:8081 bigdatauniversity/spark:latest /etc/bootstrap.sh -bash


## start as demon
docker run -d --hostname bigdatauniversitySpark --name bdu_spark -P -p 8080:8080 -p 8081:8081 bigdatauniversity/spark:latest /etc/bootstrap.sh -d



##### start and reatttach the session  #####

docker start  bdu_spark 
docker attach bdu_spark

## run commands on the image:
Start a new command in a running container
docker exec -it bdu_spark CMD
sudo docker exec -it bdu_spark ls
sudo docker exec -it bdu_spark spark-shell

# Exercise 1
run
/etc/bootstrap.sh

run 
hdfs dfs -mkdir input/tmp
hdfs dfs -put /opt/ibm/labfiles/README.md input/tmp


hdfs dfs -put /opt/ibm/labfiles/README.md /christian/

hdfs dfs -ls input/tmp

## in Scala 
$SPARK_HOME/bin/spark-shell

sc. tab-complete

val readme = sc.textFile("input/tmp/README.md")

Let’s perform some RDD actions on this text file. Count the number of items in the RDD using
this command:
readme.count()
readme.first()

filter transformation
val linesWithSpark = readme.filter(line => line.contains("Spark"))
this returned a pointer to a RDD with the results of the filter transformation.

how many lines contains the word “Spark”:
readme.filter(line => line.contains("Spark")).count()


There are two parts to this. The first maps a line to an integer value, the number of words in that
line. In the second part reduce is called to find the line with the most words in it. The arguments
to map and reduce are Scala function literals (closures), but you can use any language feature
or Scala/Java library.:

readme.map(line => line.split(" ").size).reduce((a, b) => if (a > b) a else b)

use a Java library instead:
import java.lang.Math
readme.map(line => line.split(" ").size).reduce((a, b) => Math.max(a, b))


a MapReduce data flow pattern:
val wordCounts = readme.flatMap(line => line.split(" ")).map(word => (word,1)).reduceByKey((a,b) => a + b)
Here we combined the flatMap, map, and the reduceByKey functions to do a word count of each
word in the readme file.

 You can quit out of the Scala shell, you have completed this section. To stop the spark
contenxtType in:
CTRL +D



## in python

$SPARK_HOME/bin/pyspark
readme = sc.textFile("input/tmp/README.md")
readme.count()
readme.first()
linesWithSpark = readme.filter(lambda line: "Spark" in line)
# how many lines contain the word spark
readme.filter(lambda line: "Spark" in line).count()

find the line from that readme file with the most words in it:

readme.map(lambda line: len(line.split())).reduce(lambda a, b: a if (a > b) else b)


def max(a, b):
    if a > b:
        return a
    else:
        return b

readme.map(lambda line: len(line.split())).reduce(max)


 MapReduce data flow pattern:
combine the flatMap, map, and the reduceByKey functions to do a word count of each
word in the readme file: 
wordCounts = readme.flatMap(lambda line: line.split()).map(lambda word: (word,1)).reduceByKey(lambda a, b: a+b) 

wordCounts.collect()



# spark caching 
pull data sets into a cluster-wide inmemory cache
example, let’s mark our linesWithSpark dataset to be cached and then invoke the first count operation to tell Spark to cache it:
Once you run the second count() operation, you should notice a small increase in speed.

