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
  await db.createTable('friends', {
    id: { type: 'int', primaryKey: true, autoIncrement: true },
    created: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    deleted: { type: 'boolean', defaultValue: false },
    account_user_id: { type: 'uuid' },
    friend_user_id: {
      type: 'uuid',
      foreignKey: {
        name: 'friends_friend_user_id_fk',
        table: 'users',
        rules: {
          onDelete: 'CASCADE',
          onUpdate: 'RESTRICT'
        },
        mapping: 'user_id'
      }
    },

  })
};

exports.down = async function (db) {
  await db.removeTable('friends')
};

exports._meta = {
  "version": 2
};
