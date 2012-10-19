_ = require('underscore');

var Ability = function Ability() {
  this.rules = [];
};

Ability.prototype.can = function can(action, subject, conditions) {
  this.rules.push(new Rule(true, action, subject, conditions));
};

Ability.prototype.cannot = function cannot(action, subject, conditions) {
  this.rules.push(new Rule(false, action, subject, conditions));
};

/**
  * @param {String}
  * @param {Object}
  * @returns boolean
  */
Ability.prototype.isAllowed = function isAllowed(action, subject) {
  var rules = this.relevantRules(action, subject);
  var match = _.detect(rules, function(rule) {
    return rule.matchesConditions(action, subject);
  });

  return match ? match.base_behavior : false;
};

/**
  * @see Ability::isAllowed
  */
Ability.prototype.isNotAllowed = function isNotAllowed() {
  return !this.isAllowed.apply(this, arguments);
};

Ability.prototype.relevantRules = function relevantRules(action, subject) {
  return this.rules.filter(function(rule) {
    return rule.isRelevant(action, subject);
  }, this);
};

var Rule = function(base_behavior, action, subject, conditions) {
  var flatten = function flatten(items) {
    if('array' === typeof items) {
      return items.reduce(function(a,b) { return a.concact(b); });
    }

    return [items];
  };

  this.base_behavior = base_behavior;
  this.actions = flatten(action);
  this.subjects = flatten(subject);
  this.conditions = conditions;
};

/**
 * @param {String}
 * @param {Object}
 * @returns boolean
 */
Rule.prototype.isRelevant = function isRelevant(action, subject) {
  return this.matchesAction(action) && this.matchesSubject(subject);
};

/**
 * @param {String}
 * @returns boolean
 */
Rule.prototype.matchesAction = function matchesAction(action) {
  return this.actions.indexOf('manage') !== -1 ||
    this.actions.indexOf(action) !== -1;
};

Rule.prototype.matchesConditions = function matchesConditions(action, subject) {
  if(_.isUndefined(this.conditions) || _.isNull(this.conditions)) {
    return true;
  }

  return _.reduce(this.conditions, function(memo, value, name) {
    return memo && (subject[name] === value);
  }, true);
};

/**
 * @param {Object}
 * @returns boolean
 */
Rule.prototype.matchesSubject = function matchesSubject(subject) {
  return _.contains(this.subjects, subject) ||
    this.subjects.some(function(value) { return subject instanceof value; });
};

var middleware = function(Ability) {
  return function(req, res, next) {
    var abilities = new Ability(req.user);

    req.user.isAllowed = function() { return abilities.isAllowed.apply(abilities, arguments); };
    req.user.isNotAllowed = function() { return abilities.isNotAllowed.apply(abilities, arguments); };
    req.abilities = abilities;

    next();
  };
};

module.exports = {
  Ability: Ability,
  connect: middleware,
  express: middleware
};
