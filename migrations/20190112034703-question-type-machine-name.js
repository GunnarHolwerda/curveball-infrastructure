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
  await db.addColumn('question_type', 'machine_name', { type: 'string', notNull: true, unique: true, defaultValue: new String('random_string(10)') });
  await db.addIndex('question_type', 'question_type_machine_name_idx', ['machine_name']);
};

exports.down = async function (db) {
  await db.removeIndex('question_type', 'question_type_machine_name_idx');
  await db.removeColumn('question_type', 'machine_name');
};

exports._meta = {
  "version": 10
};
