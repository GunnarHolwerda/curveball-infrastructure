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
    'INSERT INTO question_type (title, description, generic, machine_name) VALUES (?, ?, ?, ?);',
    ['Spread', 'Pick the team you think will win based on the spread you set', false, 'spread']);
  await db.runSql(
    `INSERT INTO question_calculator (type_id, function_name, topic) 
      SELECT t.id as type_id, ? as function_name, ? as topic FROM question_type t WHERE t.machine_name = ?;
    `,
    ['nflSpreadCalculator', 2, 'spread']);
};

exports.down = async function (db) {
  await db.runSql('DELETE FROM question_calculator WHERE function_name = ?;', ['nflSpreadCalculator']);
  await db.runSql('DELETE FROM question_type WHERE machine_name = ?;', ['spread']);
};

exports._meta = {
  "version": 11
};
