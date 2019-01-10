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
  await db.addColumn('question_type', 'generic', {
    type: 'bool',
    defaultValue: false,
    notNull: true
  });
};

exports.down = async function (db) {
  await db.removeColumn('question_type', 'generic');
};

exports._meta = {
  "version": 8
};
