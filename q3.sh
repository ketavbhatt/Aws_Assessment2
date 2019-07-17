#!/bin/bash

# Default region needs to be set using aws configure command to run this script

# Getting VPC ID
vpc_id=`aws ec2 create-vpc --cidr-block 10.0.1.0/24 | jq '.Vpc.VpcId'`

#Removing Quotes
vpc_id=`sed -e 's/^"//' -e 's/"$//' <<<"$vpc_id"`
echo $vpc_id

# Creating subnets in different availablity zones, both public subnets and private subnets
subnet_pvt_a=`aws ec2 create-subnet --availability-zone us-east-1a --vpc-id $vpc_id --cidr-block 10.0.1.0/28 | jq '.Subnet.SubnetId'`
subnet_pub_a=`aws ec2 create-subnet --availability-zone us-east-1a --vpc-id $vpc_id --cidr-block 10.0.1.16/28 | jq '.Subnet.SubnetId'`
subnet_pub_a=`sed -e 's/^"//' -e 's/"$//' <<<"$subnet_pub_a"`
subnet_pvt_a=`sed -e 's/^"//' -e 's/"$//' <<<"$subnet_pvt_a"`


subnet_pvt_b=`aws ec2 create-subnet --availability-zone us-east-1b --vpc-id $vpc_id --cidr-block 10.0.1.32/28 | jq '.Subnet.SubnetId'`
subnet_pub_b=`aws ec2 create-subnet --availability-zone us-east-1b --vpc-id $vpc_id --cidr-block 10.0.1.48/28 | jq '.Subnet.SubnetId'`
subnet_pub_b=`sed -e 's/^"//' -e 's/"$//' <<<"$subnet_pub_b"`
subnet_pvt_b=`sed -e 's/^"//' -e 's/"$//' <<<"$subnet_pvt_b"`


subnet_pvt_c=`aws ec2 create-subnet --availability-zone us-east-1c --vpc-id $vpc_id --cidr-block 10.0.1.64/28 | jq '.Subnet.SubnetId'`
subnet_pub_c=`aws ec2 create-subnet --availability-zone us-east-1c --vpc-id $vpc_id --cidr-block 10.0.1.80/28 | jq '.Subnet.SubnetId'`
subnet_pub_c=`sed -e 's/^"//' -e 's/"$//' <<<"$subnet_pub_c"`
subnet_pvt_c=`sed -e 's/^"//' -e 's/"$//' <<<"$subnet_pvt_c"`


# Creating Internet Gateway
igw_id=`aws ec2 create-internet-gateway | jq '.InternetGateway.InternetGatewayId'`
igw_id=`sed -e 's/^"//' -e 's/"$//' <<<"$igw_id"`


# Attaching Internet Gateway to the VPC
temp1=`aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $igw_id`

# Creating route table one for public and one for private
rtb_pub=`aws ec2 create-route-table --vpc-id $vpc_id | jq '.RouteTable.RouteTableId'`
rtb_pvt=`aws ec2 create-route-table --vpc-id $vpc_id | jq '.RouteTable.RouteTableId'`
rtb_pub=`sed -e 's/^"//' -e 's/"$//' <<<"$rtb_pub"`
rtb_pvt=`sed -e 's/^"//' -e 's/"$//' <<<"$rtb_pvt"`

# Attaching route table with the internet gateway
temp2=`aws ec2 create-route --route-table-id $rtb_pub --destination-cidr-block 0.0.0.0/0 --gateway-id $igw_id`


# Attaching public subnets to public route table and private subnet to private route table
assoc_id_pub_a=`aws ec2 associate-route-table  --subnet-id $subnet_pub_a --route-table-id $rtb_pub | jq '.AssociationId'`
assoc_id_pub_b=`aws ec2 associate-route-table  --subnet-id $subnet_pub_b --route-table-id $rtb_pub | jq '.AssociationId'`
assoc_id_pub_c=`aws ec2 associate-route-table  --subnet-id $subnet_pub_c --route-table-id $rtb_pub | jq '.AssociationId'`

assoc_id_pvt_a=`aws ec2 associate-route-table  --subnet-id $subnet_pvt_a --route-table-id $rtb_pvt | jq '.AssociationId'`
assoc_id_pvt_b=`aws ec2 associate-route-table  --subnet-id $subnet_pvt_b --route-table-id $rtb_pvt | jq '.AssociationId'`
assoc_id_pvt_c=`aws ec2 associate-route-table  --subnet-id $subnet_pvt_c --route-table-id $rtb_pvt | jq '.AssociationId'`
