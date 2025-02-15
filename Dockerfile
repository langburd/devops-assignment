FROM python:3.13-alpine

LABEL maintainer="Avi Langburd <avi@langburd.com>"
LABEL org.opencontainers.image.source="https://github.com/langburd/devops-assignment"

WORKDIR /app

COPY /app/requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

COPY /app /app

EXPOSE 8080

CMD ["python3", "app.py"]
