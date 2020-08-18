FROM debian:buster-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y pmacct && mkdir /run/pmacct

ENTRYPOINT ["/usr/sbin/pmacctd"]
CMD ["-f", "/etc/pmacct/entropy.conf"]
