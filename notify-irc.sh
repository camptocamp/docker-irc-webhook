#!/bin/sh

oldrev=$1
newrev=$2
refname=$3
user=$4

branch=${refname##*/}
if echo "${IRC_NOTIFY_BRANCHES}" | grep -q $branch ; then
  if expr "$oldrev" : '0*$' >/dev/null; then
    exit 0
  elif expr "$newrev" : '0*$' >/dev/null; then
    exit 0
  else
    oldrevshort=$(expr substr $oldrev 0 7)
    newrevshort=$(expr substr $newrev 0 7)

    chan="${IRC_CHAN}"
    server="${IRC_SERVER}"

    echo "/j ${chan}" > /tmp/irc/$server/in
    sleep 1
    echo "${user} pushed in branch ${branch}" > "/tmp/irc/${server}/${chan}/in"
    echo "for details: git log -p ${oldrevshort}..${newrevshort}" > "/tmp/irc/${server}/${chan}/in"
  fi
fi
