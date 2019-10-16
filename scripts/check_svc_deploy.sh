#!/bin/bash

kubectl get svc -n com-att-ecom | grep studentsinfo

if [ $? = 0 ];then
kubectl delete svc studentsinfo -n com-att-ecom
kubectl delete deploy studentsinfo -n com-att-ecom
else
echo "execute next steps"
fi
