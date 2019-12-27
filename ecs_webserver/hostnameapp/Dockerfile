FROM nginx:alpine

# Accept from command line or from build env
ARG VERSION

ENV VERSION=$VERSION

WORKDIR /opt/app/

COPY hostname.sh /opt/app/

EXPOSE 80

CMD ["/opt/app/hostname.sh"]
