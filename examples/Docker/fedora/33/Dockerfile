FROM fedora:33

RUN yum -y update && \
    yum -y install && \
        make \
        rpm-build \
        fakeroot

CMD /ias_python3_script_infra/dist/Docker/fedora/33/build-dist.sh
