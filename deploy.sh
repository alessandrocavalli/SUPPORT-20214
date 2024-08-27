#!/bin/bash
for filename in *.bpmn; do
   model=$(cat $filename |grep '  <bpmn:process id="' | cut -d'"' -f 2)
   upload='upload=@"./'$filename'"'
   deployname='deployment-name='$model
   curl -k -H "Content-Type: multipart/form-data" -X POST -F $upload -F $deployname -F 'deploy-changed-only=true' \
      http://localhost:8080/engine-rest/deployment/create
done
