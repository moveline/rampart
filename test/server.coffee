Rampart = require '../'
express = require 'express'

class User
  constructor: (id) ->
    @id = parseInt id

class Article
  constructor: (author) ->
    @author = parseInt author

class Ability extends Rampart.Ability
  constructor: (user) ->
    super
    @can 'read', Article, {author: user.id}

app = express()
app.use express.bodyParser()
app.use (req, res, next) ->
  if req.query.login is 'true'
    req.user = new User(1)
  next()

app.use Rampart.express(Ability)
app.get '/:id', (req, res, next) ->
  article = new Article(req.params.id)
  unless req.user.isAllowed 'read', article
    return res.send 401
  res.send article

module.exports = app
