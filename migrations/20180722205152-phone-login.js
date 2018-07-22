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

exports.up = async function (db) {
  await db.changeColumn('users', 'phone', {
    unique: true,
    notNull: true
  });
  await db.changeColumn('users', 'username', {
    notNull: false
  });
  await db.removeColumn('users', 'password');
  await db.removeColumn('users', 'referral_code');
};

exports.down = async function (db) {
  await db.changeColumn('users', 'phone', {
    unique: false,
    notNull: false
  });
  await db.addColumn('users', 'password', {
    type: 'string',
    length: 255,
    notNull: true
  });
  await db.addColumn('users', 'referral_code', {
    type: 'string',
    length: 12,
    defaultValue: 'invalid',
    notNull: true
  });
  await db.changeColumn('users', 'username', {
    notNull: true
  });
};

exports._meta = {
  "version": 4
};
