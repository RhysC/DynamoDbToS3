import time
from decimal import Decimal
import boto3
from faker import Factory

# look at http://boto3.readthedocs.io/en/latest/guide/dynamodb.html for getting started
dynamodb = boto3.resource('dynamodb',
                          region_name='us-west-2',
                          endpoint_url="http://localhost:8000")
fake = Factory.create()


def load_data(table):
    for outer_loop in range(0, 100):
        with table.batch_writer() as batch:
            for inner_loop in range(0, 25):  # max 25 items per batch write
                record = {
                    'id': fake.uuid4(),
                    'timestamp': Decimal(time.time()),
                    'username': fake.user_name(),
                    'first_name': fake.first_name(),
                    'last_name': fake.last_name(),
                    'date_of_birth': fake.date_time_between(
                      start_date="-99y",
                      end_date="-18y").strftime("%Y%m%d"),
                    'address': {
                        'road': fake.street_address(),
                        'city': fake.city(),
                        'state': fake.state_abbr(),
                        'zipcode': fake.postcode()
                    }
                }
                # print(record)
                batch.put_item(Item=record)


def ensure_table_created(table_name):
    # probably should be table.meta.client.get_waiter('table_exists').wait(TableName='users')
    try:
        response = dynamodb.meta.client.describe_table(
            TableName=table_name
        )
        current_status = response['Table']['TableStatus']
        while current_status != 'ACTIVE':
            time.sleep(2)  # 2 seconds
            print current_status
            response = dynamodb.meta.client.describe_table(
                TableName=table_name
            )
            current_status = response['Table']['TableStatus']
        print table_name + " ready"
        return dynamodb.Table(table_name)
    except Exception:
        create_table(table_name)
        return ensure_table_created(table_name)  # recursion - lucky this is a poc


def create_table(table_name):
    dynamodb.create_table(
        TableName=table_name,
        AttributeDefinitions=[
            {
                'AttributeName': 'id',
                'AttributeType': 'S'
            },
            {
                'AttributeName': 'timestamp',
                'AttributeType': 'N'
            },
        ],
        KeySchema=[
            {
                'AttributeName': 'id',
                'KeyType': 'HASH'
            },
            {
                'AttributeName': 'timestamp',
                'KeyType': 'RANGE'
            },
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        },
        StreamSpecification={
            'StreamEnabled': True,
            'StreamViewType': 'NEW_IMAGE'
        }
    )


if __name__ == "__main__":
    table_name = 'sampleData'
    table = ensure_table_created(table_name)
    load_data(table)
