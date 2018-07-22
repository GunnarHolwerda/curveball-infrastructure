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
  await db.runSql('ALTER TABLE answer_submission DROP CONSTRAINT answer_submission_pkey;')
  await db.runSql('ALTER TABLE answer_submission ADD PRIMARY KEY (user_id, question_id);')
};

exports.down = async function (db) {
  await db.runSql('ALTER TABLE answer_submission DROP CONSTRAINT answer_submission_pkey;')
  await db.runSql('ALTER TABLE answer_submission ADD PRIMARY KEY (user_id, question_id, choice_id);')
};

exports._meta = {
  "version": 3
};
