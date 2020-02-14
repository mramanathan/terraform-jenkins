#!/bin/bash

set -e
set -x

CONTAINER_HOSTNAME=`hostname`
APP_VERSION="${VERSION:-v0.1}"

cat > /usr/share/nginx/html/index.html <<EOF
	<HTML>
	<HEAD>
	<TITLE> Container, $CONTAINER_HOSTNAME, is serving this page! </TITLE>
	<HEAD>
	<BODY>
	<H1> App is running in the container, $CONTAINER_HOSTNAME </H1>
	<H2> Version of the app, $APP_VERSION </H2>
	</BODY>
	</HTML>
EOF

mkdir -p /usr/share/nginx/html/{hostname,version,health}

cat > /usr/share/nginx/html/hostname/index.html <<EOF
Container ID :: $CONTAINER_HOSTNAME 
APP version  :: $APP_VERSION
EOF

cat > /usr/share/nginx/html/version/index.html <<EOF
App version :: $APP_VERSION
EOF

cat > /usr/share/nginx/html/health/index.html <<EOF
Healthy!!!
EOF

nginx -g "daemon off;"