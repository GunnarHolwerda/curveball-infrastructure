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
  await db.createTable('friend_invites', {
    id: { type: 'int', primaryKey: true, autoIncrement: true },
    created: { type: 'datetime', defaultValue: new String('CURRENT_TIMESTAMP') },
    deleted: { type: 'boolean', defaultValue: false },
    accepted: { type: 'boolean', defaultValue: false },
    inviter_user_id: { type: 'uuid' },
    invite_phone: { type: 'string' }
  });
  await db.addIndex('friend_invites', 'friend_invites_inviter_user_id_idx', 'inviter_user_id');
  await db.addIndex('friend_invites', 'friend_invites_invite_phone_idx', 'invite_phone');
};

exports.down = async function (db) {
  await db.removeIndex('friend_invites', 'friend_invites_inviter_user_id_idx');
  await db.removeIndex('friend_invites', 'friend_invites_invite_phone_idx');
  await db.dropTable('friend_invites');
};

exports._meta = {
  "version": 3
};
