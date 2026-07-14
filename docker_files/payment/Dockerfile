FROM python:3.9.25-alpine3.22 AS builder
WORKDIR /app
COPY requirements.txt .
RUN apk add --no-cache --virtual .build-deps gcc musl-dev linux-headers python3-dev \
    && pip3 install --prefix=/install -r requirements.txt \
    && apk del .build-deps

FROM python:3.9.25-alpine3.22
WORKDIR /app
EXPOSE 8080
RUN addgroup -S flipkart && adduser -S -G flipkart flipkart && \
    chown -R flipkart:flipkart /app
COPY  --from=builder /install /usr/local
COPY --chown=flipkart:flipkart payment.ini *.py requirements.txt .
USER flipkart
CMD ["uwsgi", "--ini", "payment.ini"]


# FROM python:3.9
# WORKDIR /app
# COPY requirements.txt .
# COPY payment.ini .
# COPY *.py .
# RUN pip3 install -r requirements.txt
# EXPOSE 8080
# CMD ["uwsgi", "--ini", "payment.ini"]