# CHANGELOG

## 3.0.1

* Uplift for Ruby 2.7 support.
* Add double splat to method_missing so that explicit hash is passed.

## 3.0.0

* Require 'body' and 'headers' keyword arguments when they should be provided to any request type.
* Add support for custom headers.
* Update Logging framework.

## 2.3.0

* Adding patch method to client.

## 2.1.2

* Making retries an optional parameter.
* Adding automatic retries when the API returns an XML response.
* Adding an optional parameter to allow a user to sleep after each call.
* Adding bare bones logging to the client.
* Adding option to pass timeout.
