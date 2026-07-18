FROM almir/webhook:2.8.3

USER root
RUN apk add --no-cache git
COPY hooks.json.tmpl /usr/local/share/webhook/hooks.json.tmpl
COPY update.sh /usr/local/bin/update-glance
RUN chmod 0555 /usr/local/bin/update-glance
USER webhook

CMD ["-hooks=/usr/local/share/webhook/hooks.json.tmpl", "-template", "-http-methods=POST", "-verbose"]
