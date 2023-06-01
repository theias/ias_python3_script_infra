FROM debian:11

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -y \
        build-essential \
        fakeroot

CMD /ias_python3_script_infra/dist/Docker/debian/11/build-dist.sh
