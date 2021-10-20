FROM python:3.8.3

ENV DEBIAN_FRONTEND noninteractive

EXPOSE 8000
  
RUN apt-get update \
  && apt-get --no-install-recommends install -y build-essential python-dev 
  
RUN pip install --no-cache-dir --upgrade pip pip-tools

COPY dev-requirements.txt requirements.txt /

RUN pip install --no-cache-dir -r requirements.txt -r /dev-requirements.txt

WORKDIR /src
COPY src /src

RUN cp app/.env.ci app/.env
RUN ./manage.py migrate

CMD uwsgi --master --http :8000 --module app.wsgi --workers 2 --threads 2 --max-requests 1000
