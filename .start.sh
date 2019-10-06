#!/bin/bash

export PATH=$PATH:/root/go/bin

mkdir -p ~/.aws/
echo "[default]" >> ~/.aws/credentials
echo "aws_access_key_id = $S3_BUCKET_KEY" >> ~/.aws/credentials
echo "aws_secret_access_key = $S3_BUCKET_SECRET" >> ~/.aws/credentials

current_time=$(date "+%Y.%m.%d.%H.%M.%S")

subfinder --set-config VirustotalAPIKey=$VIRUSTOTAL_API_KEY > /dev/null 2>&1
subfinder --set-config PassivetotalUsername=$PASSIVETOTAL_USERNAME > /dev/null 2>&1
subfinder --set-config PassivetotalKey=$PASSIVETOTAL_KEY > /dev/null 2>&1
subfinder --set-config SecurityTrailsKey=$SECURITYTRAILS_KEY > /dev/null 2>&1
subfinder --set-config RiddlerEmail=$RIDDLER_EMAIL > /dev/null 2>&1
subfinder --set-config RiddlerPassword=$RIDDLER_PASSWORD > /dev/null 2>&1
subfinder --set-config CensysUsername=$CENSYS_USERNAME > /dev/null 2>&1
subfinder --set-config CensysSecret=$CENSYS_SECRET > /dev/null 2>&1
subfinder --set-config ShodanAPIKey=$SHODAN_API_KEY > /dev/null 2>&1

subfinder -d $SCAN_ME -o /tmp/subomains.txt

if [ -r /tmp/subomains.txt ]
then
    if [ -s /tmp/subomains.txt ]
    then
        aws s3 mv /tmp/subomains.txt s3://$S3_BUCKET_NAME/subdomains/$SCAN_ME/$current_time.domains
    fi
fi
