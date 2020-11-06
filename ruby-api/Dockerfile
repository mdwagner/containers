FROM centos:7

ENV RUBY_VERSION=2.3.1
ENV POSTGRES_VERSION=9.6
ENV BUNDLER_VERSION=2.0.1

RUN yum -y update yum* \
  && yum install -y epel-release deltarpm yum-utils \
  && yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
  && yum -y makecache fast

RUN yum -y update \
  && yum -y install autoconf automake bison bzip2 gcc gcc-c++ gdbm-devel git gpg gpg2 iconv-devel ImageMagick java libffi-devel libtool libyaml-devel make openssl-devel patch postgresql96-contrib postgresql96-devel postgresql96-server postgresql96-client python-devel python-pip readline readline-devel redis sqlite-devel unzip wget which zlib zlib-devel

RUN pip install --upgrade pip \
  && pip install urllib3[secure]

COPY ./ruby.sh /etc/profile.d/ruby.sh

ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_BIN=$GEM_HOME/bin
SHELL ["/bin/bash", "-c"]

RUN gpg2 --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
  && echo "gpg2 --refresh-keys" > /etc/profile.d/gpg2.sh \
  && curl -sSL https://get.rvm.io | bash -s stable --ruby=ruby-${RUBY_VERSION}

RUN source /etc/profile.d/ruby.sh \
  && rvm use ruby-${RUBY_VERSION} --default \
  && cd / \
  && mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
  && chmod 777 "$GEM_HOME" "$BUNDLE_BIN" \
  && gem install bundler -v "$BUNDLER_VERSION" \
  && bundle config build.pg --with-pg-config=/usr/pgsql-${POSTGRES_VERSION}/bin/pg_config \
  && bundle config enterprise.contribsys.com bb614716:14b29ec1

RUN rm -rf /tmp/* \
  && yum clean all \
  && rm -rf /var/cache/yum
