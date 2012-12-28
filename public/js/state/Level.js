(function() {
  var StateLevel,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  BowShock.StateLevel = StateLevel = (function(_super) {

    __extends(StateLevel, _super);

    function StateLevel() {
      return StateLevel.__super__.constructor.apply(this, arguments);
    }

    StateLevel.prototype.load = function() {
      this.addEntitie('player', new BowShock.PlayerEntity());
      StateLevel.__super__.load.call(this);
      return this;
    };

    return StateLevel;

  })(BowShock.State);

}).call(this);
