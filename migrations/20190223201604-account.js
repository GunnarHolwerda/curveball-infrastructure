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
  await db.createTable('account', {
    columns: {
      id: { type: 'int', autoIncrement: true, primaryKey: true },
      email: { type: 'string', notNull: true },
      password: { type: 'string', notNull: true },
      network_name: { type: 'string', notNull: true }
    }
  });
  await db.addColumn('quizzes', 'account_id', {
    type: 'int',
    foreignKey: {
      name: 'quiz_account_fk',
      table: 'account',
      notNull: true,
      rules: {
        onDelete: 'CASCADE',
        onUpdate: 'RESTRICT'
      },
      mapping: 'id'
    }
  })
};

exports.down = async function (db) {
  await db.removeColumn('quizzes', 'account_id');
  await db.dropTable('account');
};

exports._meta = {
  "version": 22
};
