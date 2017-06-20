set -e

wget -O ./lib/dynamodb_local_latest.tar.gz "https://s3-ap-southeast-1.amazonaws.com/dynamodb-local-singapore/dynamodb_local_latest.tar.gz"
pushd ./lib/
tar -xzvf dynamodb_local_latest.tar.gz
chmod +x DynamoDBLocal.jar
popd

# java -Djava.library.path=./lib/DynamoDBLocal_lib -jar ./lib/DynamoDBLocal.jar -sharedDb -dbPath ./db
