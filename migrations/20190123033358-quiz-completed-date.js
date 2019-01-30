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
  await db.addColumn('quizzes', 'completed_date', { type: 'datetime' });
  await db.removeColumn('quizzes', 'completed');
};

exports.down = async function (db) {
  await db.addColumn('quizzes', 'completed', { type: 'bool', notNull: true, defaultValue: false });
  await db.removeColumn('quizzes', 'completed_date');
};

exports._meta = {
  "version": 20
};
