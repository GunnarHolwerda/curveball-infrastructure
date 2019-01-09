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
  await db.addForeignKey('questions', 'topic', 'question_topic_fk', { topic: 'topic_id' }, {
    onDelete: 'RESTRICT',
    onUpdate: 'RESTRICT'
  });
};

exports.down = async function (db) {
  await db.removeForeignKey('questions', 'question_topic_fk');
};

exports._meta = {
  "version": 6
};
