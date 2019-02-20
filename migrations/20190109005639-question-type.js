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
  await db.renameColumn('questions', 'sport', 'topic'); // May need to comment this out when migrating up
  await db.changeColumn('questions', 'topic', {
    type: 'int',
    notNull: true
  });
  await db.createTable('question_type', {
    id: { type: 'int', primaryKey: true, autoIncrement: true },
    title: { type: 'string', notNull: true },
    generic: { type: 'boolean', notNull: true, default: false },
    machine_name: { type: 'string', notNull: true },
    description: { type: 'string', notNull: true }
  });
  await db.addIndex('question_type', 'question_type_machine_name_idx', ['machine_name']);
  await db.createTable('question_calculator', {
    calculator_id: { type: 'int', primaryKey: true, autoIncrement: true },
    type_id: {
      type: 'int',
      notNull: true,
      foreignKey: {
        name: 'calculator_question_type_fk',
        table: 'question_type',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'id'
      }
    },
    function_name: { type: 'string', notNull: true },
    topic: {
      type: 'int', notNull: true, foreignKey: {
        name: 'question_calculator_topic_fk',
        table: 'topic',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'RESTRICT'
        },
        mapping: 'topic_id'
      }
    },
  });
  await db.addColumn('questions', 'type_id', {
    type: 'int',
    notNull: true,
    foreignKey: {
      name: 'question_type_fk',
      table: 'question_type',
      rules: {
        onDelete: 'RESTRICT',
        onUpdate: 'RESTRICT'
      },
      mapping: 'id'
    }
  });
};

exports.down = async function (db) {
  await db.removeColumn('questions', 'type_id');
  await db.dropTable('question_calculator');
  await db.dropTable('question_type');
  await db.changeColumn('questions', 'topic', { type: 'string', notNull: true });
  await db.renameColumn('questions', 'topic', 'sport'); // You may need to uncomment this if migrating down
};

exports._meta = {
  "version": 5
};
