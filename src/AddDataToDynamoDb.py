import time
import datetime
from decimal import Decimal
import boto3
from faker import Factory

# look at http://boto3.readthedocs.io/en/latest/guide/dynamodb.html for getting started
session = boto3.Session(profile_name='vgwcorpdev')
dynamodb = session.resource('dynamodb')
fake = Factory.create()


def load_data(table):
    for outer_loop in range(0, 100):
        print("Batch: {} - {}".format(outer_loop, datetime.datetime.now()))
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


if __name__ == "__main__":
    table_name = 'rhystest2'
    table = dynamodb.Table(table_name)
    load_data(table)
    print("records loaded.")
