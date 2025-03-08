FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y \
    pkg-config \
    libmariadb-dev \
    libmariadb-dev-compat \
    build-essential \
    python3-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY /website ./website
COPY /secrets.json .
COPY /main.py .

EXPOSE 5000

CMD sleep 10 && python main.py
