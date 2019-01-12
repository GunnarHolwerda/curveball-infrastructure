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
  await db.renameColumn('sport_team', 'reference_id', 'subject_id');
  await db.renameColumn('sport_game', 'reference_id', 'subject_id');
  await db.renameColumn('sport_player', 'reference_id', 'subject_id');
};

exports.down = async function (db) {
  await db.renameColumn('sport_team', 'subject_id', 'reference_id');
  await db.renameColumn('sport_game', 'subject_id', 'reference_id');
  await db.renameColumn('sport_player', 'subject_id', 'reference_id');
};

exports._meta = {
  "version": 9
};
