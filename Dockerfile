FROM ubuntu:18.04
MAINTAINER Eduard Istvan Sas <eduard.istvan.sas@gmail.com>

RUN apt-get update \
&& apt-get -y -q install curl gnupg lsb-release \
&& curl -s --remote-name http://packages.ntop.org/apt/18.04/all/apt-ntop.deb \
&& dpkg -i apt-ntop.deb \
&& rm -rf apt-ntop.deb \
&& apt-get update \
&& apt-get -y -q install ntopng redis-server libpcap* libmysqlclient* \
&& sed s/bind\ 127.0.0.1\ \:\:1/bind\ 127.0.0.1/g -i /etc/redis/redis.conf \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3000

RUN echo '#!/bin/bash\n/etc/init.d/redis-server start\nntopng "$@"' > /tmp/run.sh && chmod +x /tmp/run.sh

ENTRYPOINT ["/tmp/run.sh"]
