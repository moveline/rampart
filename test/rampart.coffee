connect = require 'connect'
chai = require 'chai'

chai.should()

Rampart = require '../lib/rampart'
Ability = new Rampart.Ability()

class User

describe 'Rampart', ->
  afterEach ->
    Ability.rules = []

  describe 'can', ->
    it 'should create a rule', ->
      Ability.can 'read', User
      Ability.rules.should.have.length 1

  describe 'cannot', ->
    it 'should create a rule', ->
      Ability.cannot 'read', User
      Ability.rules.should.have.length 1

  describe 'isAllowed', ->
    describe 'class level', ->
      beforeEach ->
        Ability.can 'read', User

      it 'should be true on `read`', ->
        Ability.isAllowed('read', User).should.be.ok

      it 'should be false on `write`', ->
        Ability.isAllowed('write', User).should.not.be.ok

    describe 'instance level', ->
      beforeEach ->
        Ability.can 'read', User

      it 'should be true on `read`', ->
        Ability.isAllowed('read', new User).should.be.ok

      it 'should be true on `write`', ->
        Ability.isAllowed('write', new User).should.not.be.ok

    describe 'manage action', ->
      beforeEach ->
        Ability.can 'manage', User

      it 'should be true on `read`', ->
        Ability.isAllowed('read', User).should.be.ok

      it 'should be true on `write`', ->
        Ability.isAllowed('write', User).should.be.ok

      it 'should be true on `create`', ->
        Ability.isAllowed('create', User).should.be.ok

      it 'should be true on `destroy`', ->
        Ability.isAllowed('destory', User).should.be.ok

  describe 'isNotAllowed', ->
    describe 'class level', ->
      beforeEach ->
        Ability.can 'read', User

      it 'should be false on `read`', ->
        Ability.isNotAllowed('read', User).should.not.be.ok

      it 'should be true on `write`', ->
        Ability.isNotAllowed('write', User).should.be.ok

    describe 'instance level', ->
      beforeEach ->
        Ability.can 'read', User

      it 'should be false on `read`', ->
        Ability.isNotAllowed('read', new User).should.not.be.ok

      it 'should be true on `write`', ->
        Ability.isNotAllowed('write', new User).should.be.ok

    describe 'manage action', ->
      beforeEach ->
        Ability.can 'manage', User

      it 'should be false on `read`', ->
        Ability.isNotAllowed('read', User).should.not.be.ok

      it 'should be false on `write`', ->
        Ability.isNotAllowed('write', User).should.not.be.ok

      it 'should be false on `create`', ->
        Ability.isNotAllowed('create', User).should.not.be.ok

      it 'should be false on `destroy`', ->
        Ability.isNotAllowed('destory', User).should.not.be.ok

