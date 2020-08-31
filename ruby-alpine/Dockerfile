ARG VARIANT=2.3.1-alpine
FROM ruby:${VARIANT}

RUN apk update \
 && apk upgrade

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

COPY library-scripts/*.sh /tmp/library-scripts/

RUN apk update \
 && ash /tmp/library-scripts/common-alpine.sh "${USERNAME}" "${USER_UID}" "${USER_GID}" \
 && rm -rf /tmp/library-scripts
