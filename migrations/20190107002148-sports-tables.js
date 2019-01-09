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

const topics = [
  { value: 'any', label: 'Any' },
  { value: 'nfl', label: 'NFL' },
  { value: 'nba', label: 'NBA' },
]

async function createTopics(db) {
  return db.runSql(`
    INSERT INTO topic (label, machine_name) VALUES ${topics.map(t => `('${t.label}', '${t.value}')`).join(',')};
  `);
}

exports.up = async function (db) {
  await db.createTable('topic', {
    topic_id: { type: 'int', primaryKey: true, autoIncrement: true },
    label: { type: 'string', notNull: true },
    machine_name: { type: 'string', notNull: true }
  });
  await createTopics(db);
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
    topic: {
      type: 'int', foreignKey: {
        name: 'sport_season_topic_fk',
        table: 'topic',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'topic_id'
      }
    },
    created: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    updated: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    deleted: { type: 'boolean', defaultValue: false },
    json: { type: 'json', notNull: true }
  });
  await db.addIndex('sport_season', 'sport_season_topic_idx', ['topic']);
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
    topic: {
      type: 'int', foreignKey: {
        name: 'sport_season_topic_fk',
        table: 'topic',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'topic_id'
      }
    },
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
  await db.addIndex('sport_team', 'sport_team_topic_idx', ['topic']);
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
    topic: {
      type: 'int', foreignKey: {
        name: 'sport_season_topic_fk',
        table: 'topic',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'topic_id'
      }
    },
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
  await db.addIndex('sport_player', 'sport_player_topic_idx', ['topic']);
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
    topic: {
      type: 'int', foreignKey: {
        name: 'sport_season_topic_fk',
        table: 'topic',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'topic_id'
      }
    },
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
  await db.addIndex('sport_game', 'sport_game_topic_idx', ['topic']);
};

exports.down = async function (db) {
  await db.removeIndex('sport_game_topic_idx');
  await db.dropTable('sport_game');
  await db.removeIndex('sport_player_topic_idx');
  await db.dropTable('sport_player');
  await db.removeIndex('sport_team_topic_idx');
  await db.dropTable('sport_team');
  await db.removeIndex('sport_season_topic_idx');
  await db.dropTable('sport_season');
  await db.removeColumn('questions_choices', 'subject_id');
  await db.removeColumn('questions', 'subject_id');
  await db.removeIndex('subject_type_idx');
  await db.dropTable('topic');
  await db.dropTable('subject');
};

exports._meta = {
  "version": 4
};
