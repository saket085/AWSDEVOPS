# AWSDEVOPS
My AWS Test Repository
Please read this to understand the assumptions/working for the codes.

1. The cloudformation template has been written in YAML format. This creates an ALB, Auto Scaling Group, and a RDS database, essential for a 3 tier Web Architecture. 
   The EC2 instances will be spinnned up and auto registered under the ALB/ASG.

2. The shell script needs to be run as a bash, and that will get the instance metadata as individual Key-Value pairs and the output will be in a json format.

3. The python script simply splits the nested object by the symbol ':' and takes the last split to get the aplphabetic value out of it, ignorring the keys in the nested object.
