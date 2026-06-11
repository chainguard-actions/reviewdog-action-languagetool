FROM erikvl87/languagetool:6.4
# https://github.com/Erikvl87/docker-languagetool

ENV REVIEWDOG_VERSION=v0.20.2
ENV TMPL_VERSION=v1.2.0
ENV OFFSET_VERSION=v1.0.6
ENV LANGUAGETOOL_VERSION=5.2
ENV GHGLOB_VERSION=v2.0.2

USER root

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git curl

RUN wget -O /tmp/install-reviewdog.sh -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh && \
  sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION} && \
  rm /tmp/install-reviewdog.sh && \
  wget -O /tmp/install-tmpl.sh -q https://raw.githubusercontent.com/haya14busa/tmpl/master/install.sh && \
  sh /tmp/install-tmpl.sh -b /usr/local/bin/ ${TMPL_VERSION} && \
  rm /tmp/install-tmpl.sh && \
  wget -O /tmp/install-offset.sh -q https://raw.githubusercontent.com/haya14busa/offset/master/install.sh && \
  sh /tmp/install-offset.sh -b /usr/local/bin/ ${OFFSET_VERSION} && \
  rm /tmp/install-offset.sh && \
  wget -O /tmp/install-ghglob.sh -q https://raw.githubusercontent.com/haya14busa/ghglob/master/install.sh && \
  sh /tmp/install-ghglob.sh -b /usr/local/bin/ ${GHGLOB_VERSION} && \
  rm /tmp/install-ghglob.sh

COPY entrypoint.sh /entrypoint.sh
COPY langtool.tmpl /langtool.tmpl

ENTRYPOINT ["/entrypoint.sh"]
