#/bin/sh
set -e
echo "Deploying dynamo-table-with-stream stack"

# Create Template
# No op

# deploy the newly created CF template
TEMPLATE_NAME='DynamoDb-cf.yaml'
STACK_NAME="dynamo-table-with-stream"
echo "StackName: $STACK_NAME"
aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_NAME \
    --capabilities CAPABILITY_NAMED_IAM \
    --profile vgwcorpdev \
    --region us-east-1 \
    --tags Key=Owner,Value=RhysC Key=Env,Value=Dev

aws cloudformation wait stack-create-complete \
    --stack-name $STACK_NAME \
    --profile vgwcorpdev \
    --region us-east-1

echo "TableName:"
aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --profile vgwcorpdev \
    --region us-east-1 \
    --query 'Stacks[0].Outputs[?OutputKey==`TableName`].OutputValue'


echo "Complete"
