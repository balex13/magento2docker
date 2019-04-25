#!/bin/bash

set -- "${1:-$(</dev/stdin)}" "${@:2}"

for tag in $@
do
    echo -e "$tag"
    cd /var/www/ee
    mkdir ${tag//./}
    cd ${tag//./}
    m2install.sh --force --ee --source composer --sample-data yes --version $tag
    chmod -R 777 ./var ./pub/media ./pub/static ./app/etc
    curl http://web2.sparta.corp.magento.com/dev/support/tools/configuration/m2configuration | n98-magerun2 script
    php bin/magento setup:store-config:set --base-url="http://ee.${tag//./}.127.0.0.1.xip.io/"
done

