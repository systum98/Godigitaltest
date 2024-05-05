# Use an official Python runtime as a parent image
FROM python:3.8.10

# Set the working directory in the container to the directory containing the Python script
WORKDIR /home/shubham/pythonRDS.py

# Copy the Python script into the container
COPY pythonRDS.py .

# Install any needed dependencies
RUN pip install --no-cache-dir boto3 mysql-connector-python

# Upgrade pip
RUN python -m pip install --upgrade pip
 
RUN pip install mysql-connector-python


# Run the Python script when the container launches
CMD ["python", "pythonRDS.py"]
