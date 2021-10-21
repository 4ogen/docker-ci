FROM python:3.8.3-slim

ENV DEBIAN_FRONTEND noninteractive
  
RUN apt-get update \
  && apt-get --no-install-recommends install -y build-essential python-dev 
  
RUN pip install --no-cache-dir --upgrade pip pip-tools
COPY dev-requirements.txt requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt -r /dev-requirements.txt

WORKDIR /src
COPY src /src

RUN cp app/.env.ci app/.env
RUN ./manage.py migrate
RUN mkdir /src/static/
RUN ./manage.py collectstatic

CMD uwsgi --master --http :8000 --wsgi-file app/wsgi.py --process 4 --workers 2 --threads 2 
