#Based on https://arduino-esp8266.readthedocs.io/en/latest/ota_updates/readme.html8266OTA

# Build with:
# docker build -t <builder>/8266ota .

# Run with:
# docker run -d -p 4080:80 --dns=<serverip> --restart always --mount type=bind,source=<local firmware directory>,target=/var/www/html/bin,readonly --name 8266OTA <builder>/8266ota

FROM php:7.4.6-apache
EXPOSE 80
WORKDIR /var/www/html/
COPY 8266OTA.php /var/www/html
CMD ["/usr/local/bin/apache2-foreground"]
