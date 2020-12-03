#!/bin/bash
#
# Example
#
# echo '{"profile":"ap","region":"ap-east-1","instance_id":"123"}' | bash disk_dimensions.sh
#


# Exit if any of the intermediate steps fail
set -e

eval "$(jq -r '@sh "PROFILE=\(.profile) REGION=\(.region) INSTANCE_ID=\(.instance_id)"')"


aws cloudwatch list-metrics \
    --namespace CWAgent \
    --metric-name disk_used_percent \
    --profile $PROFILE \
    --region $REGION \
    --dimensions Name=InstanceId,Value=$INSTANCE_ID --query "Metrics[0].Dimensions" \
    | jq 'from_entries'
