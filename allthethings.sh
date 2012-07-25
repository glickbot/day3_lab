#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <folder>
     <folder> the root riak folder you want to check"
    exit 1;
fi

base=$1

$base/bin/riak-admin ring_status
$base/bin/riak-admin member_status
echo "Ring Ready:"
$base/bin/riak-admin ringready

for dir in dev1 dev2 dev3 dev4; do
    backend=`grep -o 'riak_kv_[a-z]*_backend' $base/../$dir/etc/app.config | cut -d '_' -f 3`
    case $backend in
        eleveldb)
          data_dir="$base/../$dir/data/leveldb"
          ;;
        bitcask)
          data_dir="$base/../$dir/data/$backend"
          echo -n "vnode keycounts: "
          echo $($dir/../$dir/bin/riak-admin vnode-status|grep -o 'key_count,[0-9]*'|cut -d ',' -f 2)
          ;;
        *)
          data_dir="$base/../$dir/data/$backend"
          ;;
    esac
    du -sh $data_dir
done
