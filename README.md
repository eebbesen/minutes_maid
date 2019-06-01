# Minutes Maid

Collects data from meeting minutes allowing you-specific filters.

Currently only works for Saint Paul meeting data from https://stpaul.legistar.com/Calendar.aspx, but the aim of the project is to make it easily adaptable for other entities.

## Populate data
### Locally
```bash
bin/rake scrape_saint_paul
```

### Heroku deployment
Add `MM_GOOGLE_API_KEY` value to settings.
```bash
heroku run rake scrape_saint_paul
```
I've got this scheduled on Heroku: https://devcenter.heroku.com/articles/scheduler#installing-the-add-on.


## Fix data
You may find that some Microsoft apostrophes cause odd display characters. You can fix this data by running
```bash
bin/rake fix_utf8
```

## Development
Initialize `MM_GOOGLE_API_KEY` value as an environment variable.
### Unit tests
```bash
bin/rails test
```

### System tests
```bash
bin/rails test:system
```

### Architectural notes
#### dropdowns
Both the item and meeting dropdown filters are based on the `hclass` function in the `Item` and `Meeting` classes. Please override this for the level of detail that you require in your dropdowns. Note that Zurb Foundation allows you to have nested dropdowns should that seem attractive to you.

#### unfiltered pages
The items index takes a fairly long amount of time to load with a relatively small number of items. You may find it judicious to set initial filter state, pagination and/or disallow display of all items (especially on one page).

#### location mapping
MM_GOOGLE_API_KEY represents a Google Maps API key with the Places API enabled. Google currently offers up to 150,000 calls per day to this API for free, but does require you to have a credit card on file with Google.

https://console.cloud.google.com/google/maps-apis/api-list


## Heroku tools
### Database record count
Heroku Postgres hobby-dev plan allows you 10,000 records free of charge. To see how close you are use

```bash
heroku pg:info
```
Here's an example result:
```
~/minutes_maid$ heroku pg:info
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
