#!/bin/sh

oldrev=$1
newrev=$2
refname=$3
user=$4

branch=$(git rev-parse --symbolic --abbrev-ref $refname)
if echo "%{IRC_NOTIFY_BRANCHES}" | grep -q $branch ; then
  if expr "$oldrev" : '0*$' >/dev/null; then
    exit 0
  elif expr "$newrev" : '0*$' >/dev/null; then
    exit 0
  else
    oldrev=$(git rev-parse $oldrev)
    oldrevshort=$(git log -1 --format="%h" $oldrev)
    newrev=$(git rev-parse $newrev)
    newrevshort=$(git log -1 --format="%h" $newrev)

    commitcount=$(git log --format="%h" ${oldrev}..${newrev} | wc -l)
    shortstats=$(git diff --shortstat ${oldrev}..${newrev})
    authors=$(git log --format="%aN" ${oldrev}..${newrev} | sort | uniq | sed ':a;N;$!ba;s/\n/, /g')

    maxcount=6

    chan="%{IRC_CHAN}"
    server="%{IRC_SERVER}"

    echo "/j ${chan}" > /tmp/irc/$server/in
    sleep 1
    if [ $commitcount -gt $maxcount ]; then
      echo "${user} pushed ${commitcount} commits from ${authors} to $(pwd) in branch ${branch}" > "/tmp/irc/${server}/${chan}/in"
      echo "${shortstats}" > "/tmp/irc/${server}/${chan}/in"
      echo "for details: git log -p ${oldrevshort}..${newrevshort}" > "/tmp/irc/${server}/${chan}/in"
    else
      echo "${user} pushed ${commitcount} commits to $(pwd) in branch ${branch} - ${oldrevshort}..${newrevshort}" > "/tmp/irc/${server}/${chan}/in"
      echo "${shortstats}" > "/tmp/irc/${server}/${chan}/in"
      for commit in $(git log --format="%h" ${oldrev}..${newrev}); do
        oneline=$(git log -1 --format="%h - %s (%an)" $commit)
        echo "${oneline}" > "/tmp/irc/${server}/${chan}/in"
      done
    fi
  fi
fi
