FROM python:3.9

# Установка Chrome и ChromeDriver
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    xvfb

# Установка Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Добавляем опции Chrome для работы в Docker
ENV CHROME_OPTIONS="--headless --no-sandbox --disable-dev-shm-usage"

CMD ["pytest", "--html=test_results/report.html", "--self-contained-html"]