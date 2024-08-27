#!/bin/bash
for filename in *.bpmn; do
   model=$(cat $filename |grep '  <bpmn:process id="' | cut -d'"' -f 2)
   upload='upload=@"./'$filename'"'
   deployname='deployment-name='$model
   curl -k -H "Content-Type: multipart/form-data" -X POST -F $upload -F $deployname -F 'deploy-changed-only=true' \
      http://localhost:8080/engine-rest/deployment/create
done

for i in $(seq 1 1500);
do
    data="{ \"businessKey\": \"MYTEST-$i\" }"
    echo $data
    curl -d "$data" -H "Content-Type: application/json" -X POST http://localhost:8080/engine-rest/process-definition/key/myloadtestprocess/start
   
    echo
done
