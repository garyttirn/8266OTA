# ESP8266 Arduino OTA Server in Docker container

Simple PHP based OTA server for ESP8266 in Docker container 

Based on example found in https://arduino-esp8266.readthedocs.io/en/latest/ota_updates/readme.html#http-server

## Build the container ##

```
docker build -t <builder>/8266ota .
```

## Run the container ##

```
docker run -d -p 4080:80 --dns=<serverip> --restart always --mount type=bind,source=<local firmware directory>,target=/var/www/html/bin,readonly --name 8266ota <builder>/8266ota
```

## ESP Integration ##

### ESP Image Version ###

The ESP images need to provide simple DDMMYYYY-timestamp when requesting new firmware.
This can be done by following code :

```
    const char* FWVersion = "29112020";

    t_httpUpdate_return ret = ESPhttpUpdate.update(client,"http://<server IP>:4080",String(FWVersion));

```

### ESP Image Building ###

Build firmware images as usual, but instead of uploading export compiled binaries to file by selecting

```
Sketch->Export compiled binary
```

### Store images ###

Images are stored on the Docker host in the local firmware directory defined in the Docker run command to be bound to /var/www/html/bin

The filename must be the "ESP MAC Address".bin. All letters must be upper case.

eg. 

```
CC50E3CBAFEC.bin
```

The server compares file modification timestamp (DDMMYYYY) to the version provided by the ESP and the MD5 checksums of current image and local image offering new image to the ESP8266.

The timestamp of the image can be changed using eg. touch :
```
touch -t MMDDhhmm <image.bin>
```

## Caveats ##

The server doesn't check if the image will actually fit to the ESP memory, it will happily serve oversized images.
This version has no security implemented, upgrades should only be done in a trusted network environment.

## Other Information ##

Big thanks to Erik H. Bakke for excellent blogs on the subject.
https://www.bakke.online/index.php/2017/06/02/self-updating-ota-firmware-for-esp8266/
