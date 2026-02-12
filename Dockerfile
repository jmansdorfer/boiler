FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Install uv using pip
RUN pip install uv

# Copy project files
COPY pyproject.toml .
COPY src/main.py .
COPY data/ .

# Install dependencies using uv
RUN uv pip install --system -r pyproject.toml && \
    apt-get update && apt-get install -y gifsicle && rm -rf /var/lib/apt/lists/* && \
    mkdir -p temp

# Run the bot
CMD ["python", "main.py"]