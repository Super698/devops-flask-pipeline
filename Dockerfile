# Stage 1: Build & Dependency Installation
FROM python:3.11-alpine AS builder

WORKDIR /app

RUN apk add --no-cache build-base

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Minimal Runtime Environment
FROM python:3.11-alpine

WORKDIR /app

# Copy installed dependencies from builder stage
COPY --from=builder /install /usr/local

# Copy application source code
COPY app.py .

# Create non-root security user
RUN adduser -D devopsuser && chown -R devopsuser:devopsuser /app
USER devopsuser

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]