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
  await db.runSql(
    `INSERT INTO question_calculator (type_id, function_name, topic) 
      SELECT t.id as type_id, ? as function_name, ? as topic FROM question_type t WHERE t.machine_name = ?;
    `,
    ['nbaSpreadCalculator', 3, 'spread']);
  await db.runSql(
    `INSERT INTO question_calculator (type_id, function_name, topic) 
      SELECT t.id as type_id, ? as function_name, ? as topic FROM question_type t WHERE t.machine_name = ?;
    `,
    ['nbaFantasyCalculator', 3, 'fantasy']);
};

exports.down = async function (db) {
  await db.runSql('DELETE FROM question_calculator where function_name IN (?, ?);',
    ['nbaSpreadCalculator', 'nbaFantasyCalculator'])
};

exports._meta = {
  "version": 17
};
