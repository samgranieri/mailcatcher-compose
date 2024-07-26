FROM debian:bookworm

ENV MAILCATCHER_VERSION=0.8.2
ENV LANG="en_US.UTF-8" \
  LC_ALL="en_US.UTF-8" \
  LANGUAGE="en_US.UTF-8" \
  TIMEZONE="UTC"

WORKDIR /app

ENV BUNDLE_SILENCE_ROOT_WARNING=1
ARG ruby_minor_version_point_zero=3.1.0

COPY Gemfile Gemfile.lock ./
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y \
  autoconf \
  bison \
  build-essential \
  curl \
  libffi-dev \
  libgdbm-dev \
  libncurses5-dev \
  libreadline-dev \
  libssl-dev \
  libyaml-dev \
  ruby \
  ruby-dev \
  zlib1g-dev && \
  gem install bundler:2.4.13 && \
  bundle config set --local deployment 'true' && \
  bundle && \
  apt-get remove --purge -y \
  autoconf \
  bison \
  build-essential \
  curl \
  libffi-dev \
  libgdbm-dev  \
  libncurses5-dev \
  libreadline-dev \
  libssl-dev \
  libyaml-dev \
  ruby-dev \
  zlib1g-dev && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf vendor/bundle/ruby/$ruby_minor_version_point_zero/cache/*.gem && \
  find vendor/bundle/ruby/$ruby_minor_version_point_zero/gems/ -name "*.c" -delete && \
  find vendor/bundle/ruby/$ruby_minor_version_point_zero/gems/ -name "*.o" -delete

RUN chown -R nobody: /app
USER nobody

EXPOSE 1025 1080

CMD ["bundle", "exec", "mailcatcher",  "--messages-limit=100", "--smtp-ip=0.0.0.0", "--http-ip=0.0.0.0",  "--http-ip=0.0.0.0", "-f", "--no-quit" ]
