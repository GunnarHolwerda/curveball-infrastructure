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
  await db.changeColumn('sport_game', 'json', { type: 'jsonb', notNull: true });
  await db.changeColumn('sport_season', 'json', { type: 'jsonb', notNull: true });
  await db.changeColumn('sport_player', 'json', { type: 'jsonb', notNull: true });
  await db.changeColumn('sport_team', 'json', { type: 'jsonb', notNull: true });
};

exports.down = async function (db) {
  await db.changeColumn('sport_game', 'json', { type: 'json', notNull: true });
  await db.changeColumn('sport_season', 'json', { type: 'json', notNull: true });
  await db.changeColumn('sport_player', 'json', { type: 'json', notNull: true });
  await db.changeColumn('sport_team', 'json', { type: 'json', notNull: true });
};

exports._meta = {
  "version": 16
};
