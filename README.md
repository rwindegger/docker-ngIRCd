# docker-ngIRCd
This repository contains everything needed to get your ngIRCd up and running in your docker environment.

# ngIRCd
For [more information about ngIRCd](https://ngircd.barton.de/) see the project website.

# Usage
```docker run -e DOMAIN=coffeeshop.tours -e NETWORK=coffeeshop.tours -v /var/run/docker.sock:/tmp/docker.sock -v /home/reeen/data/conf.d:/opt/ngircd/etc/conf.d -p 6667:6667 rwindegger/ngircd:latest```