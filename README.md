# README

This is test repository of Rails for docker with vagrant on Mac.

# Screenshot

![image](https://user-images.githubusercontent.com/17272426/82747079-d75a5000-9dd0-11ea-904c-0532e11d84cd.png)
# Setup

## Common set up

```
docker-compose exec web build
docker-compose exec web up -d
docker-compose exec web bin/setup 
```

## With Docker on Mac
1. Set up
2. Following set up, access to `http://localhost:3000/`

## With Vagrant
TODO

# Measurement

* measurement of start up rails.

```SHELL
$ time docker-compose exec web rails runner "puts Rails.env"
development
docker-compose exec web rails runner "puts Rails.env"  0.44s user 0.21s system 3% cpu 16.383 total
```
