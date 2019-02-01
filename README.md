# Minutes Maid

Collects data from meeting minutes allowing you-specific filters.

Currently only works for Saint Paul meeting data from https://stpaul.legistar.com/Calendar.aspx, but the aim of the project is to make it easily adaptable for other entities.

## Populate data
```bash
bundle exec rake scrape_saint_paul
```

## Development
### Unit tests
```bash
bin/rails test
```

### System tests
```bash
bin/rails test:system
```
