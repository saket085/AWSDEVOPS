ssh -i forec2.pem ec2-user@35.177.222.184 "rm metadata.json;wget -q -O - http://169.254.169.254/latest/dynamic/instance-identity/document >> metadata.json;exit"
scp -i forec2.pem ec2-user@35.177.222.184:metadata.json .
exit