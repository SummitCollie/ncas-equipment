# NCAS Equipment

## Database creation
Uses postgres locally and in production.

### Local DB
Locally, set postgres to listen on port 5432 and put credentials for a
superuser in rails credentials:

`EDITOR=nano rails credentials:edit`

```yml
postgres:
  username: username_here
  password: password_here
```

## Production DB
Just attach a postgres database on Heroku, the app will automatically use
Heroku's `DATABASE_URL` env var to connect rather than the stuff in rails
credentials.

## Database initialization
Run `rails db:migrate` once to set up tables.

Local test data can be seeded by running `rails db:seed`.

## Google Authentication
Make a project in the
[Google API Console](https://console.developers.google.com/apis/), hit
"Credentials" on the left, set up the Consent Screen, and then put your
CLIENT_ID and CLIENT_SECRET in rails credentials:

`EDITOR=nano rails credentials:edit`

```yml
google_oauth2:
  client_id: long_string_here
  client_secret: long_string_2_here
```

## Deployment
Just make sure you set the environment var `RAILS_MASTER_KEY` on Heroku with
the value of whatever's in config/master.key so the app can decrypt the stuff
in Rails credentials.

## How to run the test suite
