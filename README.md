## Simple app to shorten URLs
It is available on Docker Hub:
`docker pull tombrom/bionic:latest`
Although it has dependencies so please run it with `docker-compose` instead:
-`docker-compose up -d`\
-`docker-compose run --service-ports app`: for debugging, add your pries or binding.irb where needed

**URL formats are checked before they are shortened**
You can pass URLS in the following formats:
1. `http(s)://(www.)google.com`
2. `google.co.uk`
3. `www.google.com`

The keys are Base64 encoded and the first 3 characters are taken

Keys can be created by submitting JSON to the `/shorten` endpoint:
`docker-compose exec app curl -XPOST localhost:3000/shorten -d '{"uri":"http://bionic.co.uk"}' -H "Content-Type: application/json" -H "Accept: application/json"`

If the key passes validations it will be persisted in a Redis Hash at key `shortened_urls`
You can visit `/index` to see the keys

If you want to check what's in Redis you can:
`docker-compose exec redis redis-cli`

## Run the tests
`docker-compose exec app bundle exec rspec -fd`

