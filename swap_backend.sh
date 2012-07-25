#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <devrel root> <bitcask|eleveldb>"
    exit 1;
fi

case $2 in
    bitcask)
        current='riak_kv_eleveldb_backend'
        new='riak_kv_bitcask_backend'
        ;;
    eleveldb)
        current='riak_kv_bitcask_backend'
        new='riak_kv_eleveldb_backend'
        ;;
    *)
        echo "Only eleveldb or bitcask are valid"
        exit 1;
        ;;
esac

find $1 -name 'riak' -exec ./{} stop \;
find $1 -name 'app.config' -exec perl -pi -e "s/$current/$new/" {} \;
find $1 -name 'riak' -exec ./{} start \;
