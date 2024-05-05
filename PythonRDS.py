import boto3
import mysql.connector

# AWS credentials and region
aws_access_key_id = 'i remove this'
aws_secret_access_key = 'wKn8rcSfRPKCoyNXE/N/7KmqAC33WUZgYoCME+fC'
aws_region = 'us-east-1'

# Connect to AWS S3
s3_client = boto3.client('s3', region_name=aws_region,
                         aws_access_key_id=aws_access_key_id,
                         aws_secret_access_key=aws_secret_access_key)

# S3 bucket and object details
bucket_name = 'godigital'
object_key = 'shubhamtest.html'

# Connect to RDS MySQL database
db_host = 'my-db.cf0gwmuk8dkf.us-east-1.rds.amazonaws.com'
db_user = 'admin'
db_password = 'shubham123'
db_name = 'my-db'  # Specify the identifier name of your RDS instance

# Function to read file content from S3
def read_file_from_s3(bucket_name, object_key):
    try:
    response = s3_client.get_object(Bucket=bucket_name, Key=object_key)
    file_content = response['Body'].read().decode('utf-8')
    return file_content
    except Exception as e:
        print("Error reading file from S3:", e)
        return None


# Function to insert file content into MySQL database
def insert_into_mysql(file_content):

  try:
    connection = mysql.connector.connect(host=db_host, user=db_user,
                                         password=db_password, database=db_name)
    cursor = connection.cursor()
    sql_query = "INSERT INTO file_contents (content) VALUES (%s)"
    cursor.execute(sql_query, (file_content,))
    connection.commit()
    cursor.close()
    connection.close()
   print("File content inserted into MySQL successfully.")
    except Exception as e:
        print("Error inserting file content into MySQL:", e)


# Main function
def main():
    # Read file content from S3
    file_content = read_file_from_s3(bucket_name, object_key)
    
    # Insert file content into MySQL
    insert_into_mysql(file_content)
    
    print("File content inserted into MySQL successfully.")

if __name__ == "__main__":
    main()
