#!/bin/bash

#Written by kiran to check ns exist or not

kubectl get ns | grep com-att-oce-test 

if [ $? = 0 ];then
echo "ns already present..deleteing it"
kubectl delete ns com-att-oce-test
else
echo "ansible is creating namspace com-att-oce-test.."
fi
