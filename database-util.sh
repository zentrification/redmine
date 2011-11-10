#!/bin/bash
# dirty script i wrote to help with trying out plugins that hose your db

if test -z "$1"
then
  echo "Usage: $0 {dump|load}"
  exit
fi

if [ ! -f config/database.yml ]
then
  echo "config/database.yml not found where expected, run from rails root"
  exit
fi

DB=`cat config/database.yml | grep -A 6 'production:' | grep database | awk -F ': ' '{print$2}'`
HOST=`cat config/database.yml | grep -A 6 'production:' | grep host | awk -F ': ' '{print$2}'`
USER=`cat config/database.yml | grep -A 6 'production:' | grep user | awk -F ': ' '{print$2}'`
PASS=`cat config/database.yml | grep -A 6 'production:' | grep pass | awk -F ': ' '{print$2}'`

case $1 in
  dump)
    `mysqldump -h $HOST -u $USER -p$PASS $DB > db/dump.sql`
    echo 'dumped database to db/dump.sql'
  ;;
  load)
    if [ ! -f db/dump.sql ]
    then
      echo "db/dump.sql does not exist, first execute $0 dump"
      exit
    fi
    `mysql -h $HOST -u $USER -p$PASS $DB < db/dump.sql`
    echo 'loaded db/dump.sql'
  ;;
esac
