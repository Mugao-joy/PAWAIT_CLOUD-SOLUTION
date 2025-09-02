FROM python:3.11-slim

# Create non-root user
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --shell /bin/bash --create-home appuser

WORKDIR /app

# Install build dependencies for C extensions and Python headers
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        libyaml-dev \
        libffi-dev \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libreadline-dev \
        curl \
        wget \
        git \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency manifest first for caching
COPY requirements.txt /requirements.txt

# Upgrade pip, setuptools, wheel and install Python dependencies
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r /requirements.txt

# Copy app code
COPY . /app

# Fix permissions
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

ENV PORT=8080
EXPOSE 8080

# Run the app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
