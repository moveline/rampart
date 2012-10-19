# Rampart [![Build Status](https://secure.travis-ci.org/Moveline/rampart.png)](http://travis-ci.org/Moveline/rampart)

Authorization module with Connect/Express support

## Installation

```bash
$ npm install rampart
```

## Usage

```coffee-script
Auth = require './auth'
Rampart = require 'rampart'
express = require 'express'

class Ability extends Rampart.Ability
  constructor: (user) ->
    user = user || new User

    if user.role is 'admin'
      @can 'manage', User

    else
      @can 'manage', User, {_id: user.id}

app = express()
app.use Auth.session()
app.use Rampart.express(Ability)

app.get '/', (req, res, next) ->
  res.send 401 unless req.user.isAllowed 'read', User

```

## Tests

```bash
$ npm test
```

## Authors [Christopher Garvis][0] & [Moveline][1]

[0]: http://christophergarvis.com
[1]: http://www.moveline.com

## License

MIT
