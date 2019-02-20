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
  await db.addColumn('questions_choices', 'data', {
    type: 'json'
  });
};

exports.down = async function (db) {
  await db.removeColumn('questions_choices', 'data');
};

exports._meta = {
  "version": 20
};
