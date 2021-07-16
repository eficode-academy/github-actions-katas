FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY test_app.py test_app.py

CMD [ "python", "./test_app.py" ]
