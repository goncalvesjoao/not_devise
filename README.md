# README
Rails App with authenticaction (log in only) from scratch.

&nbsp;

# Dependencies required to be installed in the system
- ruby (ideally v2.7.4)
- node (ideally v16)
- bundler (ideally v2.1)
- postgres (v9 up)

&nbsp;

# Setup
Be sure you have your local postgres DB is installed and execute:
```shell
<rails app folder>$ bundle
```

Be sure you have your local postgres DB is running and execute:
```shell
<rails app folder>$ rake db:drop && rake db:create && rake db:migrate && rake db:seed
```

&nbsp;

# Boot up
Run rails app:
```shell
<rails app folder>$ rails s
```

And when by visiting ```http://localhost:3000``` you can log in, using the following list of users:
```json
[
  { username: "john_snow", password: "password_snow" },
  { username: "john_doe", password: "password_doe" },
]
```

&nbsp;

# Tests
Make sure test DB is updated, by executing:
```shell
<rails app folder>$ RAILS_ENV=test rake db:migrate
```

Then run the test suit:
```shell
<rails app folder>$ rspec
```
