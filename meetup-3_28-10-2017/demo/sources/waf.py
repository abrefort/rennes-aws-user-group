#!/usr/bin/env python3.6
import datetime
import os
import logging

import boto3
from boto3.dynamodb.conditions import Attr

# setup logging parameters
LOG_FORMAT = "%(levelname)-8s %(asctime)-15s %(message)s"
DATE_TIME_FORMAT = "%Y-%m-%d %H:%M"
DATE_FORMAT = "%Y-%m-%d"
logging.basicConfig(format=LOG_FORMAT)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def update_waf(event, context):
    # get parameters
    ip_set = os.environ['ip_set']

    waf = boto3.client('waf')

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('waf')

    logger.info('Getting IPs.')
    response = table.scan(
        FilterExpression=Attr('triggercount').gt(10) & Attr('blocked').not_exists()
    )
    items = response['Items']

    for item in items:
        ip = item['IP']
        if ':' in ip:
            ip_type = "IPV6"
            ip_cidr = "/128"
        else:
            ip_type = "IPV4"
            ip_cidr = "/32"

        change_token = waf.get_change_token()['ChangeToken']

        logger.info('Blocking {}'.format(ip + ip_cidr))
        waf.update_ip_set(
            IPSetId=ip_set,
            ChangeToken=change_token,
            Updates=[
                {
                    'Action': 'INSERT',
                    'IPSetDescriptor': {
                        'Type': ip_type,
                        'Value': ip + ip_cidr
                    }
                },
            ]
        )

        logger.info('Updating DynamoDB record for {}.'.format(ip + ip_cidr))
        table.update_item(
            Key={'IP': ip},
            UpdateExpression='SET blocked = :val1',
            ExpressionAttributeValues={
                ':val1': True
            }
        )
