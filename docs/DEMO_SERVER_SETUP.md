![ecko](/.github/branding/vectors/logo-full-monochrome.svg)
# Description
This document helps in deploying a demo server to a web server.
It will showcase a few things which are essential for the demo server.

1. User Signup should be disabled
2. Mails should not be triggered.
3. All data needs to be refreshed every 24 hours.

It's best to perform the following steps after installing from source. See [INSTALL.md](./INSTALL.md)

## Disable user signup

Here we need to comment a bit of code in the view section. Since we are not allowing any registration to happen we need 
to take two steps to stop users from registering.

1. First way is to disable the whole UI itself so that people cannot user the registration UI to register themselves.
2. Disable the API as it is possible to easily use Postman or curl based techniques to register themselves.

### 1. Disable Registration UI
Its as easy as commenting code in app/views/about/_registration.html.haml file. If we comment out all the code in this 
file, then we will not be able to register through UI.

### 2. Disabling the Registration
a. Go to app/controllers/auth/sessions_controller.rb file.
b. Change the code for registration and replace it with in line 26 method.

```ruby
def create
  render status: 422, json: 'Registration not allowed for this Instance'
end
```

Note: We could have written some environment dependant code to actually make this work rather than updating the code but
this is a one time process which we run and if its based on environment of the server, Production will also take this
configuration and will have extra bit of unnecessary latency.

## Stop all mails
This is a simple step to take. We can easily change the config file in production environment file.

Steps.
Go to config/environments/production.rb
line 115 and change from 

```ruby
config.action_mailer.delivery_method = ENV.fetch('SMTP_DELIVERY_METHOD', 'smtp').to_sym
to
config.action_mailer.delivery_method = :test
```

Why are we doing this? If we dont setup any smtp settings, the mail should not go to any recipients anyhow but due to
it, the process exits and might stop further logic's to proceed.
There are more options [here](https://stackoverflow.com/questions/3057593/how-do-i-configure-rails-to-disable-sending-real-emails-out-while-in-staging/3057654)

## Clear data every 24 hours
This configurations requires a bit of work where you need to work on two things. Since we dont have any way to register
users, we need to make sure that whenever all the data is cleared we have to seed some standard users which can use the
platform to test.

rails db:truncate_all actually removes all the data from the database but needs to perform by having access in server 
and executing command from the command line.

Our goal here is to remove data every 24 hours by itself. Mastadone already provides ways to schedule tasks through the
gem sidekiq-scheduler. In this step we need to configure the scheduler configurations and add our new worker which will
execute the required commands for us.

Our solution should run with
rails db:seed:replant --trace where we can easily truncate and seed all the necessary data as well.

While running this, one user and an account will be created. If we want to change the user account email and password we
need to update some data in the file "/db/seeds.rb"

Here now to cleanup we need to perform the following steps to 

1. Replace the file config/sidekiq.yml with demo/sidekiq.yml
2. Add file demo/data_cleanup_scheduler.rb to app/workers/scheduler folder.

By performing these two steps, while running sidekiq, the cleanup process will run every 24 hours.
