app = require './server'
chai = require 'chai'
request = require 'supertest'

chai.should()

describe 'Rampart Middleware', ->
  describe 'logged in', ->
    it 'should return 200', (done) ->
      request(app).get('/1').expect 200, done

    it 'should return 401', (done) ->
      request(app).get('/2').expect 401, done
