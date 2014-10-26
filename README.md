# Public Whip [![Stories in Ready](https://badge.waffle.io/openaustralia/publicwhip.png?label=ready)](https://waffle.io/openaustralia/publicwhip) [![Build Status](https://travis-ci.org/openaustralia/publicwhip.svg?branch=production)](https://travis-ci.org/openaustralia/publicwhip) [![Code Climate](https://codeclimate.com/github/openaustralia/publicwhip.png)](https://codeclimate.com/github/openaustralia/publicwhip)

## Introduction

In our democracy the definitive exercise of the power we give our politicians
when we vote them into office is how they vote in our parliaments on our behalf.
Yet you probably don't know how your MP votes. This isn't your fault.

Parliamentary voting information is notoriously difficult to find and analyse.
This project changes that by making it understandable and easy to use.

We stand on the shoulders of giants: this project is an Australian fork of the
UK [Public Whip](http://www.publicwhip.org.uk/) project.

### [This is how we do it](https://www.youtube.com/watch?v=0hiUuL5uTKc) - process overview

The [OpenAustralia.org](http://www.openaustralia.org) project
[parses](https://github.com/openaustralia/openaustralia-parser) the Australian
Federal Hansard into [ParlParse](http://parser.theyworkforyou.com/) format (this
due to it's history of being a fork of the UK
[TheyWorkForYou](http://www.theyworkforyou.com/) project - more shoulders,
giants). The debates XML files the parser creates, also available on
[data.openaustralia.org](http://data.openaustralia.org/), contain voting data
and we load this into a Rails application.

## Development

If your machine is already set up to develop Rails applications with MySQL just
carry out the following steps and you should be good to go. Developing with
[Vagrant](https://www.vagrantup.com/) is also possible (see below) but was
mainly useful with the retired PHP application.

Before beginning, install MySQL, HTMLTidy and Ruby:

```
# OS X ...
brew install homebrew/dupes/tidy mysql rbenv ruby-build
rbenv install $(cat .ruby-version)

# ... or Linux (Debian)
sudo apt-get install tidy mysql-server mysql-client libmysqlclient-dev
# then follow: https://github.com/sstephenson/rbenv#basic-github-checkout to get rbenv and ruby-build
```

Steps required to configure, install and start the Rails application:

```
# Copy the default config files over.
# (Edit config/database.yml and fill in your username, password and database settings.)
bundle exec rake application:config:dev
cp config/database.yml.example config/database.yml

# Copy secrets config
cp config/secrets.yml.example config/secrets.yml

# Install bundle
bundle install

# Set up your database (including seed data)
bundle exec rake db:setup

# Run tests
bundle exec rake

# Start the server
bundle exec rails server
```

### With Vagrant

Once you have [vagrant][1] and [virtualbox][2] installed and have cloned this
repository run `vagrant up`. This will download the base virtualbox image
and set up the development environment, be prepared for a bit of a wait.

Run the tests from inside the VM like this:

* `vagrant ssh`
* `cd /vagrant`
* `bundle exec rake`

Assuming they pass, you can start the rails server:

* `bundle exec rails server`

Once it is up you can browse to http://localhost:3000

When manually testing the site, the "sign up" confirmation emails will
automatically go to a dummy smtp server called [mailcatcher][3]. To check the
emails, browse to http://localhost:1080

If vagrant reports that it can't mount the `/vagrant` virtualbox shared folder,
it's becuase the VM has had it's kernel updated. Run
`vagrant provision && vagrant reload` and you should be back in business.

The original PHP app is also available at http://localhost:8080 but only if
you're running an older branch (out of scope for this guide).

[1]: http://www.vagrantup.com/
[2]: https://www.virtualbox.org/
[3]: http://mailcatcher.me/

## Production

### Extra Requirements

* Memcached

### Deployment

The code is deployed using Capistrano. To deploy to staging (the only stage
currently configured) run:

    bundle exec cap test deploy

You'll need a local copy of `config/newrelic.yml` that includes your licence
key to be able to record deployments to New Relic.

### Loading data

To load live data, ensure `config/settings.yml` is configured to point to the
server where your XML data is hosted and then you can run the appropriate Rake
task. Daily updates are carried out by the `application:load:daily` Rake task,
which is run daily at 09:45 by cron.

These are the tasks you need to know about:

* `application:load:members` loads members, offices and electorates. You always
need this to run the site. Stictly speaking it only needs to run when details
need updating but can be run as often as you like as it only updates data.
* `application:load:divisions[from_date,to_date]` load division[s]. `to_date` is
optional and if omitted, allows you to load a single date.
* `application:cache` this namespace contains cache updating tasks that are
necessary for the site to run. They should be self-explainatory.
