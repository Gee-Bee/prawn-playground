# Prawn Playground

contains code examples from official [Prawn manual](http://prawnpdf.org/manual.pdf) which you can play around with.

## Running

Bundle all the gems in volume
`docker-compose run --rm server bundle`

Run `server` service and then issue request in format `localhost:2000/< module_name >/< example_name >`, for example:
- `http://localhost:2000/basic_concepts/adding_pages`
- `http://localhost:2000/graphics/lines_and_curves`

After changing examples in `lib/prawn_examples` there is no need to restart the server, thanks to `listen` and `zeitwerk` gems. Just refresh the browser.
