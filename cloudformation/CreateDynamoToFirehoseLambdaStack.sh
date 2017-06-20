#/bin/sh
set -e
echo "Deploying dynamo-firehose stack"

# Create Template
#python create_cloudformation_template.py


# deploy the newly created CF template
TEMPLATE_NAME='DynamoToFirehoseLambda-cf.yaml'
STACK_NAME="dynamo-to-firehose-lambda"
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


echo "Complete"
