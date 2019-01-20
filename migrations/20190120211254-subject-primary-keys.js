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
  await db.addIndex('sport_game', 'sport_game_subject_idx', 'subject_id');
  await db.addIndex('sport_team', 'sport_team_subject_idx', 'subject_id');
  await db.addIndex('sport_player', 'sport_player_subject_idx', 'subject_id');
  await db.addIndex('sport_season', 'sport_season_subject_idx', 'subject_id');
};

exports.down = async function (db) {
  await db.removeIndex('sport_game', 'sport_game_subject_idx');
  await db.removeIndex('sport_team', 'sport_team_subject_idx');
  await db.removeIndex('sport_player', 'sport_player_subject_idx');
  await db.removeIndex('sport_season', 'sport_season_subject_idx');
};

exports._meta = {
  "version": 18
};
