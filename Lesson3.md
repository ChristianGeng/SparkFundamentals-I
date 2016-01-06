docker start  bdu_spark 
docker attach bdu_spark
start spark:
$SPARK_HOME/bin/spark-shell


# Scala


1. Open up a docker terminal.

2. Create a new subdirectory /home/virtuser/SparkPi:

mkdir -p /home/virtuser/SparkPi

3. Under the SparkPi directory, set up the typical directory structure for your application. Once that is in place and you have your application code written, you can package it up into a JAR using sbt and run it using spark-submit. 

mkdir -p /home/virtuser/SparkPi/src/main/scala



4. The SparkPi.scala file will be under src/main/scala/ directory.
Change to the scala directory and create this file:

cat > SparkPi.scala

5. At this point, copy and paste the contents here into the newly created file:

see src


6. To quit out of the file, type CTRL + D

7. Remember, you can have any business logic you need for your application in your scala class.
This is just a sample class. Let's spend a few moments analyzing the content of SparkPi.scala.
Type in the following to view the content:

more SparkPi.scala


8.- 14.  siehe  src code


15. At this point, you have completed the SparkPi.scala class. The application depends on the Spark
API, so you will also include a sbt configuration file, SparkPi.sbt. This file adds a repository that
Spark depends on. Change to the home directory of the SparkPi folder:
cd ../../..

16. and create this file.

cat > sparkpi.sbt

17. Copy and paste this into the sparkpi.sbt file:

name := "SparkPi Project"
version := "1.0"
scalaVersion := "2.10.4"
libraryDependencies += "org.apache.spark" %% "spark-core" % "1.3.1"


NOTE: This is the result of which spark: 
which  spark-shell                                                                                                                                       /opt/ibm/spark-1.4.0-bin-hadoop2.6/bin/spark-shell
so I will try with  that
Scala version is   2.10.4 

name := "SparkPi Project"
version := "1.0"
scalaVersion := "2.10.4"
libraryDependencies += "org.apache.spark" %% "spark-core" % "1.4.0"





18. Now your folder structure under SparkPi should look like this:

./sparkpi.sbt
./src
./src/main
./src/main/scala
./src/main/scala/SparkPi.scala

19. While in the top directory of the SparkPi application, run the sbt tool to create the JAR file:



sbt package

It will take a long time to create the package initially because of all the dependencies. Step out for a cup of coffee or tea or grab a snack.

Note: You may need to return back into the bash and start the Hadoop service. Use these
commands
docker start bdu_spark
docker attach bdu_spark
/etc/bootstrap.sh

20. Make sure you are in your SparkPi directory. 

cd /home/virtuser/SparkPi


## 1.3 Creating a Spark application using Python



21. submit: Does not work

$SPARK_HOME/bin/spark-submit \
--class "SparkPi" \
--master local[4] \
target/scala-2.10/sparkpi-project_2.10-1.0.jar



For the Python example, you are going to create Python application to calculate Pi. Running
Python application is actually quite simple. For applications that use custom classes or thirdparty
libraries, you would add the dependencies to the spark-submit through its –py=files
argument by packing them in a .zip file.

23. Create a PythonPi directory under /home/virtuser.

mkdir /home/virtuser/PythonPi

24. Change into the new PythonPi directory,

25. Create a Python file. Type in:
cat > PythonPi.py

26. In PythonPi.py, paste these lines of code:

