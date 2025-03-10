#!/bin/bash

# Make sure errors (like curl failing, or unzip failing, or anything failing) fails the build
set -ex

if [ -z "$COMMANDBOX_VERSION" ]; then
  echo "CommandBox Version not supplied via variable COMMANDBOX_VERSION"
  exit 1
fi

# Installs the latest CommandBox Binary
mkdir -p /tmp
curl -k  -o /tmp/box.zip -location "https://downloads.ortussolutions.com/ortussolutions/commandbox/${COMMANDBOX_VERSION}/commandbox-bin-${COMMANDBOX_VERSION}.zip"
unzip /tmp/box.zip -d ${BIN_DIR} && chmod 755 ${BIN_DIR}/box && rm -f /tmp/box.zip
echo "commandbox_home=${COMMANDBOX_HOME}" > ${BIN_DIR}/commandbox.properties

echo "$(box version) successfully installed"

# Set container in to single server mode
box config set server.singleServerMode=true

for mod in "${MODULE_EXCLUDES[@]}"
do
	rm -rf ${COMMANDBOX_HOME}/cfml/modules/${mod}
done

$BUILD_DIR/util/optimize.sh
