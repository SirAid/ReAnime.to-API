
FROM python:3.11-slim

WORKDIR /app

# Install Node.js 20 for the API's JavaScript component
RUN apt-get update && apt-get install -y \
    curl ca-certificates gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
       | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
       > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt package.json ./

RUN pip install --no-cache-dir -r requirements.txt

# Copy the API source code
COPY . .

# Start the API
CMD ["sh", "-c", "uvicorn reanime:app --host 0.0.0.0 --port ${PORT:-8000}"]
