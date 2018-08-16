#!/bin/sh
### BEGIN INIT INFO
# Provides:          curveball-realtime
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       OpenSesame Product Service
### END INIT INFO

SERVICE_NAME="curveball-realtime"
SCRIPT="/usr/bin/npm run start<%= ':dev' unless @is_live %> --prefix ~/realtime"
RUNAS=osproductservice

PIDFILE=/var/run/$SERVICE_NAME.pid
LOGFILE=/var/log/$SERVICE_NAME.log

start() {
  if [ -f $PIDFILE ] && [ -s $PIDFILE ] && kill -0 $(cat $PIDFILE); then
    echo 'Service already running' >&2
    return 1
  fi
  echo 'Starting service…' >&2
  local CMD="$SCRIPT > $LOGFILE 2>&1 & echo \$!"
  su -c "$CMD" $RUNAS > "$PIDFILE"

  if pgrep -u $RUNAS -F $PIDFILE > /dev/null
  then
    echo "$SERVICE_NAME started"
  else
    echo ''
    echo "Error! Could not start $SERVICE_NAME!"
  fi
}

stop() {
  if [ ! -f "$PIDFILE" ] || ! kill -0 $(cat "$PIDFILE"); then
    echo 'Service not running' >&2
    return 0
  fi
  echo 'Stopping service…' >&2
  kill -- -$(ps -o pgid $(cat "$PIDFILE") | grep -o [0-9]*) && rm -f "$PIDFILE"
  echo 'Service stopped' >&2
}

uninstall() {
  echo -n "Are you really sure you want to uninstall this service? This cannot be undone. [yes|no] "
  local SURE
  read SURE
  if [ "$SURE" = "yes" ]; then
    stop
    rm -f "$PIDFILE"
    echo "Notice: log file was not removed: $LOGFILE" >&2
    update-rc.d -f $SERVICE_NAME remove
    rm -fv "$0"
  else
    echo "Abort!"
  fi
}

status() {
  if [ -f $PIDFILE ] && [ -s $PIDFILE ]; then
    PID=$(cat $PIDFILE)
    if [ -z "$(ps axf | grep ${PID} | grep -v grep)" ]; then
      echo "$SERVICE_NAME process appears to be dead but pidfile still exists ($PIDFILE)"
      return 2
    else    
      echo "$SERVICE_NAME is running"
      return 0
    fi
  else
    echo "$SERVICE_NAME is not running"
    return 3
  fi
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    status
    ;;
  uninstall)
    uninstall
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|status|restart|uninstall}"
esac