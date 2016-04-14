FROM jmcarbo/webhook

MAINTAINER mickael.canevet@camptocamp.com

EXPOSE 9000

ENV IRC_NOTIFY_BRANCHES master

COPY notify-irc.json /etc/webhook/notify-irc.json
COPY notify-irc.sh /notify-irc.sh

COPY /docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
ENTRYPOINT ["/docker-entrypoint.sh"]
