#!/bin/bash
SERVICE_NAME="jdbc"
PIDFILE="/var/run/${SERVICE_NAME}.pid"
case "$1" in
    up)
        if [ -f $PIDFILE ]; then
            PID=$(cat $PIDFILE)
            if ps -p $PID > /dev/null; then
                echo "$SERVICE_NAME is already running."
            else
                echo "PID file exists but $SERVICE_NAME not running. Starting $SERVICE_NAME..."
                java -cp '/opt/FileMaker/JDBC/java/lib/pjbridge.jar:/opt/FileMaker/JDBC/java/lib/commons-daemon-1.2.2.jar:/opt/FileMaker/JDBC/java/lib/fmjdbc.jar' Server com.filemaker.jdbc.Driver 4444 &
                echo $! > $PIDFILE
            fi
        else
            echo "Starting $SERVICE_NAME..."
            java -cp '/opt/FileMaker/JDBC/java/lib/pjbridge.jar:/opt/FileMaker/JDBC/java/lib/commons-daemon-1.2.2.jar:/opt/FileMaker/JDBC/java/lib/fmjdbc.jar' Server com.filemaker.jdbc.Driver 4444 &
            echo $! > $PIDFILE
        fi
        ;;
    down)
        if [ -f $PIDFILE ]; then
            PID=$(cat $PIDFILE)
            echo "Stopping $SERVICE_NAME..."
            kill $PID
            rm -f $PIDFILE
        else
            echo "$SERVICE_NAME is not running."
        fi
        ;;
    *)
        echo "Usage: $0 {up|down}"
        ;;
esac
