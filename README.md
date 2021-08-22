# NCAS Equipment

## How to run locally

1. Follow the below instructions to set up Postgres, rails credentials, Google auth, etc.
2. Run the server with `rails s`
3. Optionally, run `yarn start` in another process to start the webpack dev server.
   Enables hot-reloading, much faster builds, etc. for front-end code.

## Database creation

Uses postgres 12.6 locally and in production.

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

Run `rails db:setup` once to set up tables. Adds test data on local.

Local test data can be seeded by running `rails db:seed`.

Running `rails db:seed` on prod will just add a default admin account, as
specified in your rails credentials.

Default seeded users in development are:
| username | password | admin? |
|---------------|:--------:|:------:|
|dog@example.com| 123456 | ✔️ |
|cat@example.com| 123456 | |

(although now that Google auth is implemented, password auth is disabled so
there's no login page where you can enter these passwords.)

## Environment Variables

These are stored in rails credentials. Here's all necessary keys:

`EDITOR=nano rails credentials:edit`

```yml
# Local dev only: ngrok (or similar) base URL, used for
# generating links, webhook callback URLs, etc.
#
# Prod uses "#{ENV['HEROKU_APP_NAME']}.herokuapp.com"
dev_base_url: a062-83-132-198-232.ngrok.io

# Default admin (google account) account to add on prod if
# you run `rails db:seed` on your Heroku app
prod_default_admin: myAdmin@gmail.com

# Only used for local dev, app automatically overrides with
# Heroku DATABASE_URL in prod
postgres:
  username: username_here
  password: password_here

# Used in both dev and prod for google oauth
google_oauth2:
  client_id: long_string_here
  client_secret: long_string_2_here

# Used to control telegram bot for sending magic links, etc.
telegram:
  bot_name: NCAS_Equipment_Bot # without the @
  bot_token: paste_bot_token_here

# Used as the base secret for all MessageVerifiers in Rails,
# including the one protecting cookies.
secret_key_base: long_secure_string_here
```

Make sure you set the environment var `RAILS_MASTER_KEY` on Heroku with
the value of whatever's in config/master.key so the app can decrypt the stuff
in Rails credentials.

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

In the google console, also set up your Authorized Redirect URIs for both local
and any hosted environments. Examples:

Authorized Redirect URIs:

```
http://localhost:3000/users/auth/google_oauth2/callback
https://ncas.equipment/users/auth/google_oauth2/callback
https://ncas-equipment.herokuapp.com/users/auth/google_oauth2/callback
```

## Example barcodes

![Example Barcodes](./example-barcodes.png)
