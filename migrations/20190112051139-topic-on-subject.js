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
  await db.removeColumn('sport_game', 'topic');
  await db.removeColumn('sport_player', 'topic');
  await db.removeColumn('sport_season', 'topic');
  await db.removeColumn('sport_team', 'topic');

  await db.addColumn('sport_season', 'subject_id', {
    type: 'int', notNull: true, foreignKey: {
      name: 'sport_season_subject_fk',
      table: 'subject',
      rules: {
        onDelete: 'RESTRICT',
        onUpdate: 'RESTRICT'
      },
      mapping: 'subject_id'
    }
  });

  await db.addColumn('subject', 'topic', {
    type: 'int', notNull: true, foreignKey: {
      name: 'subject_topic_fk',
      table: 'topic',
      rules: {
        onDelete: 'RESTRICT',
        onUpdate: 'RESTRICT'
      },
      mapping: 'topic_id'
    }
  });
};

exports.down = async function (db) {
  await db.addColumn('sport_game', 'topic', {
    type: 'int', foreignKey: {
      name: 'sport_game_topic_fk',
      table: 'topic',
      rules: {
        onDelete: 'RESTRICT',
        onUpdate: 'RESTRICT'
      },
      mapping: 'topic_id'
    }
  });
  await db.addColumn('sport_player', 'topic', {
    type: 'int', foreignKey: {
      name: 'sport_player_topic_fk',
      table: 'topic',
      rules: {
        onDelete: 'RESTRICT',
        onUpdate: 'RESTRICT'
      },
      mapping: 'topic_id'
    }
  });
  await db.addColumn('sport_season', 'topic', {
    type: 'int', foreignKey: {
      name: 'sport_season_topic_fk',
      table: 'topic',
      rules: {
        onDelete: 'RESTRICT',
        onUpdate: 'RESTRICT'
      },
      mapping: 'topic_id'
    }
  });
  await db.addColumn('sport_team', 'topic', {
    type: 'int',
    foreignKey: {
      name: 'sport_team_topic_fk',
      table: 'topic',
      rules: {
        onDelete: 'RESTRICT',
        onUpdate: 'RESTRICT'
      },
      mapping: 'topic_id'
    }
  });

  await db.removeColumn('sport_season', 'subject_id');
  await db.removeColumn('subject', 'topic');
};

exports._meta = {
  "version": 12
};
