#!/bin/bash
$SPARK_HOME/bin/spark-submit --class "SparkPi" --master local[4] target/scala-2.10/sparkpi-project_2.10-1.0.jar

