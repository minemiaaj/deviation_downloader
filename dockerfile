FROM python:3.10-slim

# Install semua dependensi sistem yang dibutuhkan Chrome + Chromedriver
RUN apt-get update && apt-get install -y \
    wget gnupg2 ca-certificates unzip \
    fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
    libatk1.0-0 libcups2 libdrm2 libgbm1 libgtk-3-0 libnspr4 libnss3 \
    libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 xdg-utils \
    libxkbcommon0 libxshmfence1 libu2f-udev \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome stabil
RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update && apt-get install -y /tmp/chrome.deb \
    && rm /tmp/chrome.deb

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

# Jalankan aplikasi
CMD ["python", "app.py"]
