#!/bin/bash

export PATH=$PATH:~/go/bin

echo "$S3_BUCKET_KEY:$S3_BUCKET_SECRET" > ~/.config/s3fs/passwd-s3fs
chmod 600 ~/.config/s3fs/passwd-s3fs
s3fs $S3_BUCKET_NAME ~/mahbucket -o passwd_file=~/.config/s3fs/passwd-s3fs

current_time=$(date "+%Y.%m.%d-%H.%M.%S")

mkdir -p ~/mahbucket/subdomains/

subfinder --set-config VirustotalAPIKey=$VIRUSTOTAL_API_KEY > /dev/null 2>&1
subfinder --set-config PassivetotalUsername=$PASSIVETOTAL_USERNAME > /dev/null 2>&1
subfinder --set-config PassivetotalKey=$PASSIVETOTAL_KEY > /dev/null 2>&1
subfinder --set-config SecurityTrailsKey=$SECURITYTRAILS_KEY > /dev/null 2>&1
subfinder --set-config RiddlerEmail=$RIDDLER_EMAIL > /dev/null 2>&1
subfinder --set-config RiddlerPassword=$RIDDLER_PASSWORD > /dev/null 2>&1
subfinder --set-config CensysUsername=$CENSY_SUSERNAME > /dev/null 2>&1
subfinder --set-config CensysSecret=$CENSYS_SECRET > /dev/null 2>&1
subfinder --set-config ShodanAPIKey=$SHODAN_API_KEY > /dev/null 2>&1

subfinder -d $SCAN_ME -o /tmp/subomains.txt

if [ -r /tmp/subomains.txt ]
then
    if [ -s /tmp/subomains.txt ]
    then
        mv /tmp/subomains.txt ~/mahbucket/subdomains/$SCAN_ME_$current_time.domains
    fi
fi
