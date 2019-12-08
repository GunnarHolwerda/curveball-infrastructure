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
  await db.createTable('account_user_link', {
    columns: {
      account_id: { type: 'int', primaryKey: true, notNull: true },
      user_id: { type: 'uuid', primaryKey: true, notNull: true }
    }
  });
};

exports.down = async function (db) {
  await db.dropTable('account_user_link');
};

exports._meta = {
  "version": 23
};
