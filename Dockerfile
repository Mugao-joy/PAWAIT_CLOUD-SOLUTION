FROM python:3.11-slim

#non-root user
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --shell /bin/bash --create-home appuser

WORKDIR /app

# Install build deps (removed later)
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/*

# Copy dependency manifests first for caching
COPY requirements.txt /requirements.txt

# Install python deps
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r /requirements.txt

# Copy app code
COPY . /app

# Fix permissions
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

ENV PORT=8080
EXPOSE 8080


CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
