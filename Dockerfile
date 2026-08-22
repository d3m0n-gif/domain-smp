FROM eclipse-temurin:8-jre

WORKDIR /app
COPY . /app

RUN chmod +x /app/render-start.sh

CMD ["sh", "/app/render-start.sh"]
