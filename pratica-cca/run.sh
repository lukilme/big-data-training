#!/bin/bash

docker run -v ./shared:/shared -it -p 3306:3306 -p 7180:7180 -p 8888:8888 -p 4040:4040 -p 8080:8080 -p 9000:9000 -p 44444:44444 bigdata-lab
