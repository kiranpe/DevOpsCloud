#!/bin/bash
#written by kiran to delete existing svc and deploy

kubectl get svc -n com-att-oce-test | grep my-service-node
if [ $? = 0 ];then
kubectl delete svc my-service-node -n com-att-oce-test
else
echo "Nothing to delete..."
fi

kubectl get deploy -n com-att-oce-test | grep casestudy
if [ $? = 0 ];then
kubectl delete deploy casestudy -n com-att-oce-test
else
echo "Nothing to delete..."
fi
