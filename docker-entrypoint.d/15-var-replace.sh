#!/bin/bash

DIR="/etc/webhooks/*.json /notify-irc.sh"

grep -hoR "%{[A-Za-z0-9_]\+}" $DIR | sort | uniq | while read k; do
  trim=${k%\}}
  n=${trim#%{}       # calm down, vim }
  v=$(eval "echo \$${n}")
  find -L $DIR -type f -exec sed -i "s/${k}/${v}/g" {} \;
done
