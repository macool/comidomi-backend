# porttare-backend

[![CircleCI](https://circleci.com/gh/vilcabamba/porttare-backend.svg?style=svg)](https://circleci.com/gh/vilcabamba/porttare-backend)
[![Code Climate](https://codeclimate.com/github/vilcabamba/porttare-backend/badges/gpa.svg)](https://codeclimate.com/github/vilcabamba/porttare-backend)
[![security](https://hakiri.io/github/vilcabamba/porttare-backend/master.svg)](https://hakiri.io/github/vilcabamba/porttare-backend/master)

## resources

- [wiki](http://nodriza.noggalito.com/projects/porttare/wiki) (private access)
- [api](https://porttare-backend.herokuapp.com/apipie)

## setting up

### requirements

- postgresql 9+
- ruby 2.6.3
- bundler

### running app

- bundle app

  ```
$ bundle
  ```

- create PostgreSQL DB & migrate

  ```
$ bundle exec rake db:create db:migrate
  ```

- launch rails server

  ```
$ bundle exec rails server
  ```
