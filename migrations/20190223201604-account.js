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
  await db.createTable('network', {
    columns: {
      id: { type: 'int', autoIncrement: true, primaryKey: true },
      name: { type: 'string', notNull: true },
      photo: { type: 'string' }
    }
  });
  await db.createTable('account', {
    columns: {
      id: { type: 'int', autoIncrement: true, primaryKey: true },
      email: { type: 'string', notNull: true },
      password: { type: 'string', notNull: true },
      first_name: { type: 'string', notNull: true },
      last_name: { type: 'string', notNull: true },
      network_id: {
        type: 'int',
        notNull: true,
        foreignKey: {
          name: 'account_network_id_fk',
          table: 'network',
          notNull: true,
          rules: {
            onDelete: 'CASCADE',
            onUpdate: 'RESTRICT'
          },
          mapping: 'id'
        }
      }
    }
  });
  await db.addColumn('quizzes', 'network_id', {
    type: 'int',
    foreignKey: {
      name: 'quiz_account_fk',
      table: 'network',
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
  await db.removeColumn('quizzes', 'network_id');
  await db.dropTable('account');
  await db.dropTable('network');
};

exports._meta = {
  "version": 22
};
