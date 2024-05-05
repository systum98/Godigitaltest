
FROM python:3.8.10

WORKDIR /home/shubham/pythonRDS.py

COPY pythonRDS.py 
RUN pip install --no-cache-dir boto3 mysql-connector-python

RUN python -m pip install --upgrade pip
 
RUN pip install mysql-connector-python

CMD ["python", "pythonRDS.py"]
