#!/bin/bash 
# echo "testing run of a shell script
# http://localhost:8081/
#uploadPythonPi()



uploadSimpleApp()
{
    sudo docker cp SimpleApp/SimpleApp.scala bdu_spark:/home/virtuser/SimpleApp/src/main/scala/SimpleApp.scala
    sudo docker cp SimpleApp/simple.sbt bdu_spark:/home/virtuser/SimpleApp/simple.sbt

   # run with : $SPARK_HOME/bin/spark-submit --class "SimpleApp" --master local[4] target/scala-2.10/simple-project_2.10-1.0.jar

}


uploadSparkPi()
{
    sudo docker cp SparkPi/SparkPi.scala  bdu_spark:/home/virtuser/SparkPi/src/main/scala/SparkPi.scala   
    sudo docker cp SparkPi/sparkpi.bst  bdu_spark:/home/virtuser/SparkPi/sparkpi.bst
    sudo docker cp SparkPi/sparksubmit.sh  bdu_spark:/home/virtuser/SparkPi/sparksubmit.sh
}






uploadPythonPi()
{
    sudo docker cp PythonPi/PythonPi.py bdu_spark:/home/virtuser/PythonPi/PythonPi.py
    sudo docker cp PythonPi/PythonPi.py bdu_spark:/home/virtuser/PythonPi/sparksubmit.sh
}



dockerImage()
{
    sudo docker start  bdu_spark 
    sudo docker attach bdu_spark
}


