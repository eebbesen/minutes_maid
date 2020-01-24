# Minutes Maid
[![CircleCI](https://circleci.com/gh/eebbesen/minutes_maid.svg?style=svg)](https://circleci.com/gh/eebbesen/minutes_maid) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/c23d9d0e05314d6ab9982f6d63073b46)](https://www.codacy.com/manual/eebbesen/minutes_maid?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=eebbesen/minutes_maid&amp;utm_campaign=Badge_Grade)

Collects data from meeting minutes allowing you-specific filters.

Currently only works for Saint Paul meeting data from https://stpaul.legistar.com/Calendar.aspx, but the aim of the project is to make it easily adaptable for other entities.

## Development setup
### Database
By default development and test will use PostgreSQL. See config/database.yml for commented-out SQLite configuration.

### Install
```bash
bundle install
RAILS_ENV=development bin/rails db:migrate
```

### Get a Google Maps API key
You need the [Google Places API](https://developers.google.com/places/web-service/intro) enabled for your key.

*   Initialize `MM_GOOGLE_API_KEY` value as an environment variable set to your API key
*   OR copy .env.template to .env and put your API key in .env (don't commit to the repo!)

### Get a reCAPTCHA API key
See https://github.com/ambethia/recaptcha for instructions. Use reCAPTCHA v2, and add `localhost` as one of the domains if you plan to use reCAPTCHA when developing on your local machine (or create a separate key for local development).

Initialize `RECAPTCHA_SITE_KEY` and `RECAPTCHA_SECRET_KEY` as environment variables on your computer.

### Run the app locally
You will need to populate your local data in order to see anything in the app, see the "Populate Data" instructions below.
```bash
bin/rails s
```

### Tests
Minutes Maid uses [dotenv-rails](https://github.com/bkeepers/dotenv) to provide a dummy API key for unit testing (see .env.test) in conjunction with [vcr](https://github.com/vcr/vcr).

#### Unit tests
```bash
bin/rails test
```

Run one test:
```bash
bin/rails test test/services/processor/saint_paul_test.rb:27
```

#### System tests
These require the CHROMEDRIVER_VERSION environment variable to be set at test runtime. You'll need a [Chromedriver version](https://chromedriver.chromium.org/downloads) in your path, and set CHROMEDRIVER_VERSION to match that.
```bash
bin/rails test:system
```

### Architectural notes
#### dropdowns
Both the item and meeting dropdown filters are based on the `hclass` function in the `Item` and `Meeting` classes. Please override this for the level of detail that you require in your dropdowns. Note that Zurb Foundation allows you to have nested dropdowns should that seem attractive to you.

#### unfiltered pages
The items index takes a fairly long amount of time to load with a relatively small number of items. You may find it judicious to set initial filter state, pagination and/or disallow display of all items (especially on one page).

#### location mapping
`MM_GOOGLE_API_KEY` represents a Google Maps API key with the Places API enabled. Google currently offers up to 150,000 calls per day to this API for free, but does require you to have a credit card on file with Google.

https://console.cloud.google.com/google/maps-apis/api-list

## Populate data
### Locally
```bash
bin/rake scrape_saint_paul
```

### Heroku deployment
Add `MM_GOOGLE_API_KEY` value to settings.
```bash
heroku run rake scrape_saint_paul
heroku run rake fix_utf8
```
I've got this scheduled on Heroku: https://devcenter.heroku.com/articles/scheduler#installing-the-add-on.


## Fix data
You may find that some Microsoft apostrophes cause odd display characters. You can fix this data by running
```bash
bin/rake fix_utf8
```

## Heroku tools
### Database record count
Heroku Postgres hobby-dev plan allows you 10,000 records free of charge. To see how close you are use

```bash
heroku pg:info
```
Here's an example result:
```
$ heroku pg:info
=== DATABASE_URL
Plan:                  Hobby-dev
Status:                Available
Connections:           0/20
PG Version:            10.7
Created:               2019-02-02 16:08 UTC
Data Size:             9.9 MB
Tables:                6
Rows:                  2050/10000 (In compliance)
Fork/Follow:           Unsupported
Rollback:              Unsupported
Continuous Protection: Off
Add-on:                postgresql-colorful-57037
```

### Database access via CLI
```bash
 heroku pg:psql
 ```

## Docker
### Setup
You'll only need to do this once per container creation. This will download all of the Docker components you need for the web app and database, then create the dev and tests database instances.
```bash
docker-compose up
docker-compose run web bin/rake db:create
```

### Tests
#### Test Prepare
```bash
docker-compose run web bin/rake db:test:prepare
```

#### Unit Tests
```bash
docker-compose run web bin/rails test
```

#### System Tests
I haven't figured this out yet -- issues with Chrome running on the Docker image.

### Seed development database
Run this whenever you want to seed/re-seed the development database. This will erase whatever you may already have in there so be careful!
```bash
docker-compose run web bin/rake db:migrate
```

### Run Application
```bash
docker-compose run web bin/rake scrape_saint_paul
```

### ssh to Container
```bash
docker exec -it minutes_maid_web_1 /bin/bash
```

### Deployment of the container to Heroku
#### Setup
It is recommended to push to a test Heroku application before going to production. To do this, provision a new Heroku application and add the PostgreSQL dyno to it. I created `minutes-maid-test` -- you'll need a different app name :).

#### Deployment
1. `heroku container:push web -a minutes-maid-test`
1. `heroku container:release web -a minutes-maid-test`
1. If this is your first deployment to the Heroku app you'll need to run migrations `heroku run bin/rails db:migrate RAILS_ENV=production -a minutes-maid-test`
1. If you wish to populate/refresh meetings and items run `heroku run bin/rake scrape_saint_paul -a minutes-maid-test`