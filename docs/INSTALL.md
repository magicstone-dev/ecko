# Setup Ecko

There are currently a few ways to install Ecko for a production environment.

1. [YunoHost](https://install-app.yunohost.org/?app=ecko) - easiest, recommended for beginners and small instances

2. Docker-compose - medium-difficulty, for those familiar with docker - [doc](./INSTALL_DOCKER_COMPOSE.md)

3. Installing from Source - larger or customized instances, see below

## Installing from Source

Tested on Debian 11 Bullseye

### Install Node and Yarn

    curl -sL https://deb.nodesource.com/setup_12.x | bash -

And as suggested by the above script

    sudo apt-get install -y nodejs
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update && sudo apt-get install yarn

### Install system dependencies
    apt install -y \
      imagemagick ffmpeg libpq-dev libxml2-dev libxslt1-dev file git-core \
      g++ libprotobuf-dev protobuf-compiler pkg-config nodejs gcc autoconf \
      bison build-essential libssl-dev libyaml-dev libreadline6-dev \
      zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev \
      nginx redis-server redis-tools postgresql postgresql-contrib \
      certbot python3-certbot-nginx yarn libidn11-dev libicu-dev libjemalloc-dev

### Setup user
    adduser --disabled-login mastodon
    su - mastodon

### Install Ruby and bundler via rbenv

    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    cd ~/.rbenv && src/configure && make -C src
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    exec bash

    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

    rbenv install will take a few minutes so grab water, coffee, snacks, or stressball
    RUBY_CONFIGURE_OPTS=--with-jemalloc rbenv install `cat .ruby-version`
	rbenv global `cat .ruby-version`

    gem install bundler --no-document
    exit

### Create Postgresql user and database
    sudo -u postgres psql
    CREATE USER ecko CREATEDB;
    \q

### Set up Ecko
    su - mastodon
	git clone https://github.com/magicstone-dev/ecko.git live && cd live

    bundle config deployment 'true'
	bundle config without 'development test'

Due to a potential segfault issue [documented here](https://github.com/mastodon/mastodon/issues/17017#issuecomment-975268694) we need to export the location of libjemalloc
	export LD_PRELOAD=/lib/x86_64-linux-gnu/libjemalloc.so.2
	bundle install -j$(getconf _NPROCESSORS_ONLN)

    yarn install --pure-lockfile
    RAILS_ENV=production bundle exec rake mastodon:setup

Enter the domain name carefully, say no on docker but the other defaults are fine for a small instance. 

### Nginx setup with SSL
    cp /home/ecko/live/dist/nginx.conf /etc/nginx/sites-available/ecko
    ln -s /etc/nginx/sites-available/ecko /etc/nginx/sites-enabled/ecko

Replace example.com references in that file with the full domain name of your instance.

    systemctl reload nginx

Remove `ssl` from the two lines of the server section with listen 443 so that nginx wlll be ok for the run of the next command.

    certbot --nginx -d example.com

After certbot is finished, comment out the lines certbot added to the first server section and also the entire final server section which is certbot boilerplate. Finally add `ssl` back to those two `listen 443` lines.

### Set up systemd services
cp /home/mastodon/live/dist/mastodon-*.service /etc/systemd/system/

Go into the service files we just copied and make sure the paths are correct. Modify the LD_PRELOAD line with the librjemalloc path where there was an LD_PRELOAD for jemalloc already (in `sidekiq` and `web` service files).

Finally, reload the daemon and enable the services. 
    systemctl daemon-reload
    systemctl enable --now mastodon-web mastodon-sidekiq mastodon-streaming

Sources: [https://docs.joinmastodon.org/admin/install](https://docs.joinmastodon.org/admin/install)

