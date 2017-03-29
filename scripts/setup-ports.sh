# Setup ingress port
aws ec2 authorize-security-group-ingress --group-id $securityGroupId --protocol tcp --port 22 --cidr 0.0.0.0/0

# Setup Jupyter ports
aws ec2 authorize-security-group-ingress --group-id $securityGroupId --protocol tcp --port 8888-8898 --cidr 0.0.0.0/0

# Setup Spark History port and yarn resource manager port
aws ec2 authorize-security-group-ingress --group-id $securityGroupId --protocol tcp --port 8088 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $securityGroupId --protocol tcp --port 18080 --cidr 0.0.0.0/0
