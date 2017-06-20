#/bin/sh
set -e
echo "Deploying firehose to s3 stack"

# Create Template
# No op

# deploy the newly created CF template
TEMPLATE_NAME='FirehoseToS3Bucket-cf.yaml'
STACK_NAME="firehose-to-s3"
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

echo "Firehose stream:"
aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --profile vgwcorpdev \
    --region us-east-1 \
    --query 'Stacks[0].Outputs[?OutputKey==`DataStreamFirehoseOutput`].OutputValue'

echo "S3 bucket:"
aws cloudformation describe-stacks \
        --stack-name $STACK_NAME \
        --profile vgwcorpdev \
        --region us-east-1 \
        --query 'Stacks[0].Outputs[?OutputKey==`EventS3BucketOutput`].OutputValue'

echo "Complete"
