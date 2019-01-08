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
  await db.createTable('subject', {
    subject_id: { type: 'int', primaryKey: true, autoIncrement: true },
    subject_type: { type: 'string', notNull: true }
  })
  await db.addIndex('subject', 'subject_type_idx', ['subject_id', 'subject_type']);
  await db.addColumn('questions_choices', 'subject_id', {
    type: 'int', foreignKey: {
      name: 'choice_subject_reference_id_fk',
      table: 'subject',
      rules: {
        onDelete: 'RESTRICT',
        onUpdate: 'RESTRICT'
      },
      mapping: 'subject_id'
    }
  });
  await db.addColumn('questions', 'subject_id', {
    type: 'int', foreignKey: {
      name: 'question_subject_reference_id_fk',
      table: 'subject',
      rules: {
        onDelete: 'RESTRICT',
        onUpdate: 'RESTRICT'
      },
      mapping: 'subject_id'
    }
  });
  await db.createTable('sport_season', {
    id: { type: 'string', primaryKey: true, unique: true },
    sport: { type: 'string', primaryKey: true },
    created: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    updated: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    deleted: { type: 'boolean', defaultValue: false },
    json: { type: 'json', notNull: true }
  });
  await db.createTable('sport_team', {
    reference_id: {
      notNull: true,
      type: 'int',
      foreignKey: {
        name: 'sport_team_subject_id_fk',
        table: 'subject',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'subject_id'
      }
    },
    id: { type: 'string', primaryKey: true, unique: true },
    sport: { type: 'string', primaryKey: true },
    season: {
      notNull: true,
      type: 'string',
      foreignKey: {
        name: 'sport_team_season_fk',
        table: 'sport_season',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'id'
      }
    },
    created: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    updated: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    deleted: { type: 'boolean', defaultValue: false },
    json: { type: 'json', notNull: true }
  });
  await db.createTable('sport_player', {
    reference_id: {
      notNull: true,
      type: 'int',
      foreignKey: {
        name: 'sport_player_subject_id_fk',
        table: 'subject',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'subject_id'
      }
    },
    id: { type: 'string', primaryKey: true, unique: true },
    sport: { type: 'string', primaryKey: true },
    team: {
      type: 'string',
      foreignKey: {
        name: 'sport_player_team_fk',
        table: 'sport_team',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'id'
      }
    },
    created: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    updated: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    deleted: { type: 'boolean', defaultValue: false },
    json: { type: 'json', notNull: true }
  });
  await db.createTable('sport_game', {
    reference_id: {
      notNull: true,
      type: 'int',
      foreignKey: {
        name: 'sport_game_subject_id_fk',
        table: 'subject',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'subject_id'
      }
    },
    id: { type: 'string', primaryKey: true, unique: true },
    sport: { type: 'string', primaryKey: true },
    season: {
      type: 'string',
      notNull: true,
      foreignKey: {
        name: 'sport_team_season_fk',
        table: 'sport_season',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'id'
      }
    },
    created: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    updated: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    deleted: { type: 'boolean', defaultValue: false },
    json: { type: 'json', notNull: true }
  });
};

exports.down = async function (db) {
  await db.dropTable('sport_game');
  await db.dropTable('sport_player');
  await db.dropTable('sport_team');
  await db.dropTable('sport_season');
  await db.removeColumn('questions_choices', 'subject_id');
  await db.removeColumn('questions', 'subject_id');
  await db.removeIndex('subject_type_idx');
  await db.dropTable('subject');
};

exports._meta = {
  "version": 4
};
