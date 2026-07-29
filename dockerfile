FROM python:3.10-slim

# Install semua dependensi yang dibutuhkan Chrome dan chromedriver
RUN apt-get update && apt-get install -y \
    wget gnupg2 ca-certificates \
    unzip xvfb \
    libglib2.0-0 libnss3 libx11-6 libxcb1 libxcomposite1 \
    libxdamage1 libxrandr2 libgbm1 libpango-1.0-0 libcairo2 \
    libasound2 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
    libxshmfence1 libdbus-1-3 \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update && apt-get install -y /tmp/chrome.deb \
    && rm /tmp/chrome.deb

# Cari tahu versi Chrome yang terinstall
RUN google-chrome --version | awk '{print $3}' > /tmp/chrome_version.txt

# Download chromedriver dengan versi yang sama
RUN CHROME_VERSION=$(cat /tmp/chrome_version.txt) && \
    MAJOR_VERSION=$(echo $CHROME_VERSION | cut -d. -f1) && \
    wget -q -O /tmp/chromedriver.zip https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chromedriver-linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver-linux64/chromedriver && \
    ln -s /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
