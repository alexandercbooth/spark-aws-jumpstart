![](images/spark-logo-trademark.png)
## Getting Started
First, we are going to need to take care of some logistics. Don't panic.

## Installation
- if you have UNIX, you goood... otherwise, install [cygwin](https://www.cygwin.com/)
- [aws cli](https://github.com/aws/aws-cli)
```bash
pip install awscli
```

## Configure aws
- signing up for [aws](https://aws.amazon.com/)
__Note__: you will have to provide a credit card in order to use ec2
- create a user in IAM
- set user permissions to admin
- download user credentials
- run configuration for aws-cli
```bash
aws configure
```
```
And enter your:
key id
secret key
for region: us-west-2
text
```

## Create a key-pair for authentication
1. Open up ec2 from the aws console and click on `Key Pairs`.
2. Create a new key pair and keep note of it's name. This will automatically download the key to your computer.
3. Move the file to your home directory. If you named your key `stella-key`, it would look like this.
```bash
mv ~/Downloads/stella-key.pem
```
___N.B.___ If your computer auto downloads to another location, say the desktop, make sure to replace the `~/Downloads` with the appropriate path.

4. Store keyName in environment variable.
```bash
export keyName=stella-key
```
Where `stella-key` is what ever you have named your key.

### aws VPC or, your own private paradise
To setup a VPC on aws, we need to do the following things. To do them all at once, use the script I have provided [here](scripts/setup-vpc.sh).
- create VPC
```bash
export vpcId=`aws ec2 create-vpc --cidr-block 10.0.0.0/28 --query 'Vpc.VpcId' --output text`
```
- enable DNS
```bash
aws ec2 modify-vpc-attribute --vpc-id $vpcId --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --vpc-id $vpcId --enable-dns-hostnames "{\"Value\":true}"
```
- create subnet
```bash
export subnetId=`aws ec2 create-subnet --vpc-id $vpcId --cidr-block 10.0.0.0/28 --query 'Subnet.SubnetId' --output text`
```
- create route table
```bash
export routeTableId=`aws ec2 create-route-table --vpc-id $vpcId --query 'RouteTable.RouteTableId' --output text`
```
- create internet gateway
```bash
export internetGatewayId=`aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text`
```
- associate internet gateway
```bash
aws ec2 attach-internet-gateway --internet-gateway-id $internetGatewayId --vpc-id $vpcId
```
- associate route table
```bash
aws ec2 associate-route-table --route-table-id $routeTableId --subnet-id $subnetId
```
- Make internetGateway defualt route
```bash
aws ec2 create-route --route-table-id $routeTableId --destination-cidr-block 0.0.0.0/0 --gateway-id $internetGatewayId
```
- authorize ingress port 22 (you'll have to do this once the cluster is created)
- authorize Jupyter ports 8888-8898 (you'll have to do this once the cluster is created)
__Note: this will require going on the aws console and getting the securityGroupIds__

I'm kind, so I have provided a script for you to do this [here](scripts/setup-vpc.sh)
You can download a copy by,
```bash
wget https://raw.githubusercontent.com/alexandercbooth/spark-aws-jumpstart/master/scripts/setup-vpc.sh
```
```bash
. setup-vpc.sh
```

### creating a cluster
- first, we need to create default roles (one time only)
```bash
aws emr create-default-roles
```
- we can launch a cluster from the aws-cli, making sure to include our key.pem and subnetId (which will create it in our VPC)
```bash
. create-cluster.sh
```
Our cluster should be launched now and we can check its status with,

```bash
aws emr describe-cluster --cluster-id $clusterId
```
- finally, open up the ports on master,
```bash
. setup-ports.sh
```

## connect to the cluster
First, modify permissions file
```bash
chmod 400 ~/key.pem
```
Now we can ssh in,
ssh -i ~/aws-key.pem $clusterURL
:tada:

### Installing additional software
Once, ssh'ed in,
conda
```bash
wget https://raw.githubusercontent.com/alexandercbooth/spark-aws-jumpstart/master/scripts/installs.sh
. installs.sh
```

### Download the notebook
```bash
wget https://raw.githubusercontent.com/alexandercbooth/spark-aws-jumpstart/master/notebooks/01-Intro-to-Spark.ipynb
```

## :fire: Spark it: fire up a notebook server with the spark context :fire:
```bash
PYSPARK_DRIVER_PYTHON="jupyter" PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip=* --no-browser" pyspark
```

### Download copy of your files when done
```bash
scp -i ~/sparkles-key.pem hadoop@your-ec2-id.us-west-2.compute.amazonaws.com:spark1.ipynb .
```
## :rotating_light: SHUT IT DOWN :rotating_light:
___Remember to terminate your cluster, or you'll be paying amazon LOTS of money___
