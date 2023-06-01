FROM debian:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -y \
        build-essential \
        fakeroot

CMD /ias_python3_script_infra/dist/Docker/ubuntu/1804/build-dist.sh
