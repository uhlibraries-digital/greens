# Greens

Greens is a rails application that is used as a ARK minter and resolver

## Installation

Install Ruby 2.1 or higher and Rails 4.2 or higher

Copy the appropriate `database.yml` file for your setup. For SQLite3, `cp config/database.yml.sqlite3 config/database.yml`. For MySQL, `cp config/database.yml.mysql config/database.yml`. Update the file to match your configuation.

Copy the `app.yml` file, `cp config/app.yml.sample config/app.yml`. Update the file with your configuration setup.

Install gems and build the app

```bash
gem install bundler
bundle install
rake db:migrate
```

Once setup you can continue to run the rails server according to your system environment.