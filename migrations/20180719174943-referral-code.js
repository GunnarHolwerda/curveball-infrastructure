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
  await db.removeColumn('users', 'referred');
  await db.createTable('referrals', {
    referrer: {
      type: 'uuid',
      primaryKey: true,
      foreignKey: {
        name: 'referrals_users_referrer_fk',
        table: 'users',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'CASCADE'
        },
        mapping: {
          referrer: 'user_id'
        }
      }
    },
    referred_user: {
      primaryKey: true,
      unique: true,
      type: 'uuid',
      foreignKey: {
        name: 'referrals_users_referred_user_fk',
        table: 'users',
        rules: {
          onDelete: 'RESTRICT',
          onUpdate: 'CASCADE'
        },
        mapping: {
          referred_user: 'user_id'
        }
      }
    }
  });

  await db.addColumn('users', 'referral_code', {
    type: 'string',
    length: 12,
    defaultValue: 'invalid',
    notNull: true
  });

  await db.runSql(`
  Create or replace function random_string(length integer) returns text as
  $$
  declare
    chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
    result text := '';
    i integer := 0;
  begin
    if length < 0 then
      raise exception 'Given length cannot be less than 0';
    end if;
    for i in 1..length loop
      result := result || chars[1+random()*(array_length(chars, 1)-1)];
    end loop;
    return result;
  end;
  $$ language plpgsql;`)

  await db.runSql('UPDATE users SET referral_code = random_string(12) WHERE referral_code = \'invalid\'');
};

exports.down = async function (db) {
  await db.addColumn('users', 'referred', {
    type: 'bool',
    defaultValue: false,
    notNull: true
  });
  await db.dropTable('referrals');
  await db.removeColumn('users', 'referral_code');
  await db.runSql('DROP FUNCTION IF EXISTS random_string');
};

exports._meta = {
  "version": 2
};
