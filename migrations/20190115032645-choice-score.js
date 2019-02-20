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
  await db.addIndex('sport_season', 'sport_season_external_id_idx', ['external_id']);
  await db.addIndex('sport_game', 'sport_game_external_id_idx', ['external_id']);
  await db.addIndex('sport_player', 'sport_player_external_id_idx', ['external_id']);
  await db.addIndex('sport_team', 'sport_team_external_id_idx', ['external_id']);

  await db.addIndex('sport_game', 'sport_game_parent_external_id_idx', ['parent_external_id']);
  await db.addIndex('sport_player', 'sport_player_parent_external_id_idx', ['parent_external_id']);
  await db.addIndex('sport_team', 'sport_team_parent_external_id_idx', ['parent_external_id']);

  await db.addColumn('questions_choices', 'score', { type: 'decimal' });
  await db.addIndex('questions_choices', 'choices_subject_idx', 'subject_id');
};

exports.down = async function (db) {
  await db.removeIndex('sport_season', 'sport_season_external_id_idx');
  await db.removeIndex('sport_game', 'sport_game_external_id_idx');
  await db.removeIndex('sport_player', 'sport_player_external_id_idx');
  await db.removeIndex('sport_team', 'sport_team_external_id_idx');
  await db.removeIndex('sport_game', 'sport_game_parent_external_id_idx');
  await db.removeIndex('sport_player', 'sport_player_parent_external_id_idx');
  await db.removeIndex('sport_team', 'sport_team_parent_external_id_idx');

  await db.removeColumn('questions_choices', 'score');
  await db.removeIndex('questions_choices', 'choices_subject_idx');
};

exports._meta = {
  "version": 12
};
