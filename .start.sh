#!/bin/bash

mkdir -p ~/.aws/
echo "[default]" >> ~/.aws/credentials
echo "aws_access_key_id = $S3_BUCKET_KEY" >> ~/.aws/credentials
echo "aws_secret_access_key = $S3_BUCKET_SECRET" >> ~/.aws/credentials

UUID=$(cat /proc/sys/kernel/random/uuid)

subfinder --set-config VirustotalAPIKey=$VIRUSTOTAL_API_KEY > /dev/null 2>&1
subfinder --set-config PassivetotalUsername=$PASSIVETOTAL_USERNAME > /dev/null 2>&1
subfinder --set-config PassivetotalKey=$PASSIVETOTAL_KEY > /dev/null 2>&1
subfinder --set-config SecurityTrailsKey=$SECURITYTRAILS_KEY > /dev/null 2>&1
subfinder --set-config RiddlerEmail=$RIDDLER_EMAIL > /dev/null 2>&1
subfinder --set-config RiddlerPassword=$RIDDLER_PASSWORD > /dev/null 2>&1
subfinder --set-config CensysUsername=$CENSYS_USERNAME > /dev/null 2>&1
subfinder --set-config CensysSecret=$CENSYS_SECRET > /dev/null 2>&1
subfinder --set-config ShodanAPIKey=$SHODAN_API_KEY > /dev/null 2>&1

# been having issues with dnsdb and Baidu
subfinder -v --timeout 10 --exclude-sources dnsdb,Baidu -d $SCAN_ME -o /tmp/subdomains.txt

if [ -r /tmp/subdomains.txt ]
then
    if [ -s /tmp/subdomains.txt ]
    then
        aws s3 mv /tmp/subdomains.txt s3://$S3_BUCKET_NAME/tmp/$UUID

        echo '{"task_type":"screenshots","tld":"'$SCAN_ME'","domains_file":"'$UUID'"}' > /tmp/$UUID
        aws s3 mv /tmp/$UUID s3://$S3_BUCKET_NAME/tasks/

    fi
fi
