1  Spark monitoring can only be done using tools that comes with Spark. True or false?

Answer:
True
** False

2. You must explicitly initialize the SparkContext when creating a Spark application. True or false?

Answer: True False#



3 Which of the following properties of accumulators are true?

Choose one answer.
	a. Used for only implementing counters	
	b. The worker node can access the value of the accumulator	
	c. Only support numeric types accumulators, but can be extended for new types	
	d. Read-only variables





4. Which of the following parameters of the spark_submit script indicates where your application will run?



Choose one answer.
	a. --class	
**	b. --master	
	c. --deploy-mode	
	d. --conf

Hint:
--class: The entry point for your application (e.g. org.apache.spark.examples.SparkPi)
--master: The master URL for the cluster (e.g. spark://23.195.26.187:7077)
--deploy-mode: Whether to deploy your driver on the worker nodes (cluster) or locally as an external client (client) (default: client)*
--conf: Arbitrary Spark configuration property in key=value format. For values that contain spaces wrap “key=value” in quotes (as shown).
application-jar: Path to a bundled jar including your application and all dependencies. The URL must be globally visible inside of your cluster, for instance, an hdfs:// path or a file:// path that is present on all nodes.
application-arguments: Arguments passed to the main method of your main class, if any


5. The "local" parameter can be used to specify the number of cores to use for the application. True or false?
Answer: **True False

$SPARK_HOME/bin/spark-shell --master local[2]


6. Which of the following is NOT supported as a cluster manager?

Choose one answer.
	a. Spark	
**	b. Helix	
	c. Mesos	
	d. YARN


7 You must use a specific build tool to package up your course files that will work with Spark? True or false?

Answer:
True
**False


8 Which of the following lists the correct order of precedence of Spark configurations?

Choose one answer.
	a. Values in the spark-defaults.conf , properties set on SparkConf, flags passed to spark-submit	
**	b. Flags passed to spark-submit, properties set on SparkConf, values in the spark-defaults.conf	
	c. Flags passed to spark-submit, values in the spark-defaults.conf, properties set on SparkConf	
	d. Properties set on SparkConf, flags passed to spark-submit, values in the spark-defaults.conf


9  Which of the following are properties of Spark's RDD?

Choose one answer.
	a. Fault tolerant	
	b. Mutable	
	c. Parallelizable	
	d. A and B	
	e. A and C

Hint: 
A Resilient Distributed Dataset (RDD), the basic abstraction in Spark. Represents an *immutable*, partitioned collection of elements that can be operated on in *parallel*. 
(https://spark.apache.org/docs/0.8.1/api/core/org/apache/spark/rdd/RDD.html)


10 Which of the following storage level does the cache() function use?

Choose one answer.
**	a. MEMORY_ONLY	
	b. MEMORY_AND_DISK	
	c. MEMORY_ONLY_SER	
	d. MEMORY_AND_DISK_SER

Hint:
http://sujee.net/2015/01/22/understanding-spark-caching/#.VoqrDd8zoWM



11 Which two types of serialization libraries are supported with Spark? (Choose two)

Choose at least one answer.
	a. Java serialization	
	b. Apache Avro	
	c. Protocol Buffers	
	d. Kyro serialization	
	e. tpl


12 Spark must be installed and run on top of a Hadoop cluster. True or false?

Answer:
**True
False

13 A transformation is evaluated immediately. True or false?

Answer:
True
**False


14  Which two of the following are types of Spark RDD operations? (Select two)

Choose at least one answer.
	a. Parallelization	
**	b. Action	
	c. Persistence	
**	d. Transformation	
	e. Evaluation

Hint:
https://spark.apache.org/docs/0.9.0/scala-programming-guide.html



15 Spark Streaming processes live streaming data in real-time. True or false?

Answer:
**True 
False


16  The MLlib library contains which of the following algorithms.

Choose one answer.
	a. Classification	
	b. Regression	
	c. Clustering	
**	d. All of the above


17 Spark supports which of the following programming languages?

Choose one answer.
	a. Java and Scala	
	b. C++ and Python,	
	c. Scala, Perl, Java	
**	d. Scala, Python, Java	
	e. Scala, Java, C++, Python, Perl


18 Spark supports which of the following libraries?

Choose one answer.
	a. Spark SQL	
	b. Spark Streaming	
	c. MLlib	
	d. GraphX	
**	e. All of the above

19 Spark SQL allows relational queries to be expressed in which of the following?

Choose one answer.
	a. SQL	
	b. HiveQL	
	c. Scala	
**	d. All of the above


