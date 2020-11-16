FROM python:3.8-alpine

RUN pip install pipenv
RUN apk add tini openssl-dev libffi-dev build-base
COPY sh/* /usr/local/bin/

VOLUME [ "/api" ]

WORKDIR /api

ENTRYPOINT [ "tini", "-v", "--", "/usr/local/bin/entrypoint.sh" ]
