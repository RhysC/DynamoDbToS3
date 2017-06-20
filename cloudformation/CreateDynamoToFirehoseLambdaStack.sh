#/bin/sh
set -e
echo "Deploying dynamo-firehose stack"

# deploy the newly created CF template
TEMPLATE_NAME='DynamoFirehoseToS3-cf.yaml'
TABLE_NAME='rhystest2'
STACK_NAME="$TABLE_NAME-dynamo-firehose-to-s3-cfs"
echo "StackName: $STACK_NAME"
aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_NAME \
    --parameters ParameterKey=TableName,ParameterValue=$TABLE_NAME \
    --capabilities CAPABILITY_NAMED_IAM \
    --profile vgwcorpdev \
    --region us-east-1 \
    --tags Key=Owner,Value=RhysC Key=Env,Value=Dev

aws cloudformation wait stack-create-complete \
    --stack-name $STACK_NAME \
    --profile vgwcorpdev \
    --region us-east-1


echo "Complete"
