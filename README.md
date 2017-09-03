# WeatherApp

To start your Phoenix server for the first time:

  * Spin a local server `docker-compose up -d web`
  * Open a console in the server `docker-compose run web bash`
  * Install dependencies with `mix deps.get` in the console
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate` in the console
  * Install Node.js dependencies with `cd assets && npm install` in the console
  * Restart Phoenix endpoint with `docker-compose restart web`
  * Attach the log `docker attach weatherapp_web_1 `

If you have already setup your server:

  * Run `docker-compose up web`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
