# Ruby Short

A URL Shortener written using ruby from starch including the TCP server.

This was mostly to learn ruby and well, learning to make a HTTP server from a TCP Server.

The only gem this uses is `sqlite3` for libsqlite support.

## Routes

1. `GET /`: Just prints hello
2. `POST /insert`: Accepts JSON in the form `{"url": URL, "id": id}` to make a URL entry. The id is optional and will be auto generated.
3. `GET /<id>`: Redirects to the URL based on the `id`

## License

The above project is licensed under the MIT License. Refer to the [LICENSE] file for more details.

