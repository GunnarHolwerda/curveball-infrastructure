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
  await db.renameColumn('sport_team', 'id', 'external_id');
  await db.renameColumn('sport_season', 'id', 'external_id');
  await db.renameColumn('sport_game', 'id', 'external_id');
  await db.renameColumn('sport_player', 'id', 'external_id');

  await db.renameColumn('sport_team', 'season', 'parent_external_id');
  await db.renameColumn('sport_game', 'season', 'parent_external_id');
  await db.renameColumn('sport_player', 'team', 'parent_external_id');
};

exports.down = async function (db) {
  await db.renameColumn('sport_team', 'external_id', 'id');
  await db.renameColumn('sport_season', 'external_id', 'id');
  await db.renameColumn('sport_game', 'external_id', 'id');
  await db.renameColumn('sport_player', 'external_id', 'id');

  await db.renameColumn('sport_team', 'parent_external_id', 'season');
  await db.renameColumn('sport_game', 'parent_external_id', 'season');
  await db.renameColumn('sport_player', 'parent_external_id', 'team');
};

exports._meta = {
  "version": 11
};
