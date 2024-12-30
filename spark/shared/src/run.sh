/usr/local/spark/bin/spark-submit \
  --master yarn \
  --deploy-mode cluster \
  --num-executors 2 \
  --executor-cores 2 \
  --executor-memory 2G \
  --driver-memory 1G \
  main.py


    