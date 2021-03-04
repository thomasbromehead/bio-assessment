## Simple app to shorten URLs

## Uses docker and can be run in the two following ways:
-`docker-compose up -d`\
-`docker-compose run --service-ports app`: for debugging, add your pries or binding.irb where needed

**URL formats are checked before they are shortened**
You can pass URLS in the following formats:
1. `http(s)://(www.)google.com`
2. `google.co.uk`
3. `www.google.com`

Keys can be created by submitting JSON to the `/shorten` endpoint:
`docker-compose exec app curl - XPOST localhost:3000 -d '{"uri":"http://bionic.co.uk"}' -H "Content-Type: application/json" -H "Accept: application/json"`

If the key passes validations it will be persisted in a Redis Hash called at key `shortened_urls`
You can visit `/index` to see the keys
If you want to check what's in Redis you can:
`docker-compose exec redis redis-cli`

## Run the test
`docker-compose exec app bundle exec rspec -fd`
