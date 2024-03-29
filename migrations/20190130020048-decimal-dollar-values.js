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
  await db.changeColumn('quizzes', 'pot_amount', {
    type: 'decimal'
  });

  await db.changeColumn('winners', 'amount_won', {
    type: 'decimal'
  });
};

exports.down = async function (db) {
  await db.changeColumn('quizzes', 'pot_amount', {
    type: 'integer'
  });

  await db.changeColumn('winners', 'amount_won', {
    type: 'integer'
  });
};

exports._meta = {
  "version": 19
};
