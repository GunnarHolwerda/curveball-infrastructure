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
    `INSERT INTO question_type (title, description, generic, machine_name) VALUES (?, ?, ?);`,
    [
      'Manual',
      'A question with manual point calculation. You will need to select which answers are correct on your own',
      true,
      'manual'
    ]
  );
};

exports.down = async function (db) {
  await db.runSql(`DELETE FROM question_type where title = ?;`, ['Manual']);
};

exports._meta = {
  "version": 7
};
