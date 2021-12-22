# Setup Ecko using Docker and Docker-compose

## Prerequisites

    * Recent release of GNU+Linux Debian or Ubuntu
    * docker
    * docker-compose

## Setting up

Clone the repository.
    
    # Clone Ecko to ~/ecko directory
    git clone https://github.com/magicstone-dev/ecko.git
    # Change directory to ~/ecko
    cd ~/ecko
    
Review the settings in `docker-compose.yml`.

## Getting the Ecko image

### Installing Docker containers

If you're not making any local code changes or customizations on your instance, you can use a prebuilt Docker image to avoid the time and resource consumption of a build.

1. Open `docker-compose.yml` in your text editor.
2. Add environment variables to the `db` section: 
    ```yaml
    environment:
      - POSTGRES_PASSWORD=xyz <-- choose a safe one, 20-30 chars
      - POSTGRES_DB=ecko_production
      - POSTGRES_USER=ecko
      - POSTGRES_HOST_AUTH_METHOD=trust
    ``` 
3. To use pre-built images comment out the `build: .` lines for the `web`, `streaming`, and `sidekiq` services.
4. Save the file and exit the text editor.
5. Run `docker-compose build` to either pull or build the necessary container images.
6. Create the public/system dir with `mkdir public/system`
7. Set correct file-owner with `sudo chown -R 991:991 public/system`

## Configuration

Next generate a configuration with:

    docker-compose run --rm web bundle exec rake mastodon:setup

This is an interactive wizard that will guide you through the options and generate app secrets. 

  1. Enter the Fully Qualified Domain Name (FQDN) of your Ecko instance.
  2. Select if you want a Single User instance (recommended only if you're running this for one person).
  3. Obviously, you are running Ecko in a docker instance, so type Y (or hit return, as it's the default)
  4. The PostgreSQL host is `db`, the port is `5432` (again, default), the database is `ecko_production`, the database user is `ecko` and the password is the one you chose and put into `docker-compose.yml`.
  5. The redis server is `redis`, the port is `6379` and the password is empty. 
  6. If you want to store uploaded files on the cloud, enter Y here and put in the necessary data.
  7. If you want to send emails from the local machine, enter `Y`. I chose `N` and was able to send email via a free mailgun account. Accept the default port then enter the user and password for the email sending account. Select the SMTP authentication type `plain` and OpenSSL verify mode `none`. Choose what sender address the emails will have like `ecko@example.com`. 

Now it will output your configuration. Copy and paste that into the file `.env.production`.

The wizard will setup the database schema and precompile assets. After it's done, you can launch Mastodon with:

    docker-compose up -d

## Reverse Proxy
You need a reverse proxy in front of your Ecko instance and for this setup we will use `nginx`.
In case you have an Apache running on port 80 anyway, you can also use that as a reverse proxy.

### nginx Configuration

Copy the example `nginx.conf` to a specific one for your domain:

`sudo cp dist/nginx.conf /etc/nginx/sites-available/example.com.conf`

Then edit the file to replace `example.com` with your domain, and adust the `root` lines so they point to your installation. In my case I had to change the username and remove `live/`

Activate the configuration you added:

`sudo ln -s ../sites-available/example.com.conf /etc/nginx/sites-enabled`

### SSL setup with Let's Encrypt

This depends on your host operating system. Search for DigitalOcean's setup documents which work well for multiple versions of Ubuntu and Debian.

### Restart Nginx

To finish up, restart nginx with `sudo systemctl reload nginx`
