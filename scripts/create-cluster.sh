echo "Launching cluster"
export clusterId=`aws emr create-cluster --name "Spark Cluster of my Own" --release-label emr-5.4.0 --applications Name=Spark \
	--ec2-attributes SubnetId=$subnetId,KeyName=stella-key --instance-type m3.xlarge --instance-count 2 --use-default-roles`
echo "Check the status of cluster with aws emr describe-cluster --cluster-id $clusterId"
