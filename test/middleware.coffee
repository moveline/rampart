app = require './server'
chai = require 'chai'
request = require 'supertest'

chai.should()

describe 'Rampart Middleware', ->
  describe 'logged in', ->
    describe 'authorized', ->
      it 'should return 200', (done) ->
        request(app).get('/1?login=true').expect 200, done

    describe 'unauthorized', ->
      it 'should return 401', (done) ->
        request(app).get('/2?login=true').expect 401, done

  describe 'not logged in', ->
    it 'should return 401', (done) ->
      request(app).get('/1').expect 401, done
