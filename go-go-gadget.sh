#!/bin/bash

mkdir -p ~/.aws/
echo "[default]" >> ~/.aws/credentials
echo "aws_access_key_id = $S3_BUCKET_KEY" >> ~/.aws/credentials
echo "aws_secret_access_key = $S3_BUCKET_SECRET" >> ~/.aws/credentials

echo "[default]" >> ~/.aws/config
echo "region = $AWS_REGION" >> ~/.aws/config

UUID=$(cat /proc/sys/kernel/random/uuid)

if [ ! -z "$BINARYEDGE_API_KEY" ]
then
    sed -i "s/binaryedge: \[\]/binaryedge: \\n- $BINARYEDGE_API_KEY/g" config.yaml
fi

if [ ! -z "$CENSYS_USERNAME" ]
then
    if [ ! -z "$CENSYS_SECRET" ]
    then
        sed -i "s/censys: \[\]/censys: \\n- $CENSYS_USERNAME:$CENSYS_SECRET/g" config.yaml
    fi
fi

if [ ! -z "$CERTSPOTTER_API_KEY" ]
then
    sed -i "s/certspotter: \[\]/certspotter: \\n- $CERTSPOTTER_API_KEY/g" config.yaml
fi

if [ ! -z "$PASSIVETOTAL_USERNAME" ]
then
    if [ ! -z "$PASSIVETOTAL_KEY" ]
    then
        sed -i "s/passivetotal: \[\]/passivetotal: \\n- $PASSIVETOTAL_USERNAME:$PASSIVETOTAL_KEY/g" config.yaml
    fi
fi

if [ ! -z "$SECURITYTRAILS_KEY" ]
then
    sed -i "s/securitytrails: \[\]/securitytrails: \\n- $SECURITYTRAILS_KEY/g" config.yaml
fi

if [ ! -z "$SHODAN_API_KEY" ]
then
    sed -i "s/shodan: \[\]/shodan: \\n- $SHODAN_API_KEY/g" config.yaml
fi

if [ ! -z "$URLSCAN_API_KEY" ]
then
    sed -i "s/urlscan: \[\]/urlscan: \\n- $URLSCAN_API_KEY/g" config.yaml
fi

if [ ! -z "$VIRUSTOTAL_API_KEY" ]
then
    sed -i "s/virustotal: \[\]/virustotal: \\n- $VIRUSTOTAL_API_KEY/g" config.yaml
fi

echo "" >> config.yaml

./subfinder -t 100 -nC --config /tmp/config.yaml -v --timeout 10 -d $SCAN_ME -o /tmp/subdomains.txt

if [ -r /tmp/subdomains.txt ]
then
    if [ -s /tmp/subdomains.txt ]
    then
        aws s3 mv /tmp/subdomains.txt s3://$S3_BUCKET_NAME/tmp/$UUID
        echo '{"task_type":"'$NEXT_STEP'","tld":"'$SCAN_ME'","domains_file":"'$UUID'","port_size":"'$PORT_SIZE'"}' > /tmp/$UUID
        aws sqs send-message --queue-url $SQS_URL --message-body $(cat /tmp/$UUID)
    fi
fi
