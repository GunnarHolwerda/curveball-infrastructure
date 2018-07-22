'use strict';

var dbm;
var type;
var seed;

/**
  * We receive the dbmigrate dependency from dbmigrate initially.
  * This enables us to not have to rely on NODE_PATH.
  */
exports.setup = function (options, seedLink) {
  dbm = options.dbmigrate;
  type = dbm.dataType;
  seed = seedLink;
};

exports.up = function (db) {
  return db.addColumn('questions', 'ticker', {
    type: 'string',
    notNull: true,
    length: 64,
    default: 'empty'
  }).then((result) => {
    return db.addColumn('questions', 'sport', {
      type: 'string',
      notNull: true,
      length: 64,
      default: 'MLB'
    });
  }, (err) => {
    return err;
  });
};

exports.down = function (db) {
  return db.removeColumn('questions', 'ticker').then(() => {
    return db.removeColumn('questions', 'sport');
  });
};

exports._meta = {
  "version": 1
};
