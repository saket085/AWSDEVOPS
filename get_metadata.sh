ssh -i path-to-privatekey.pem ec2-user@public-ip-of-the-ec2-instance "rm metadata.json;wget -q -O - http://169.254.169.254/latest/dynamic/instance-identity/document >> metadata.json;exit"
scp -i path-to-privatekey.pem ec2-user@public-ip-of-the-ec2-instance:metadata.json .
exit
