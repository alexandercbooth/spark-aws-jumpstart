echo "Launching cluster"
export clusterId=`aws emr create-cluster --name "Spock" --release-label emr-5.4.0 --applications Name=Spark \
	--ec2-attributes SubnetId=$subnetId,KeyName=$keyName --instance-type m3.xlarge --instance-count 2 --use-default-roles`
echo -e "Check the status of cluster with \n\naws emr describe-cluster --cluster-id $clusterId"
