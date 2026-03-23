FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y \
    pkg-config \
    libmariadb-dev \
    libmariadb-dev-compat \
    build-essential \
    mariadb-client \
    python3-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY /website ./website
COPY /main.py .
COPY /config.py .  

EXPOSE 5000

#CMD ["python", "main.py"]
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "main:app"]