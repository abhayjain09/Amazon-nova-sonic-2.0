#!/bin/bash

# Service Management Commands for Nova Sonic on EC2

case "$1" in
    start)
        echo "Starting services..."
        sudo systemctl start nova-sonic-websocket.service
        sudo systemctl start nova-sonic-react.service
        ;;
    stop)
        echo "Stopping services..."
        sudo systemctl stop nova-sonic-websocket.service
        sudo systemctl stop nova-sonic-react.service
        ;;
    restart)
        echo "Restarting services..."
        sudo systemctl restart nova-sonic-websocket.service
        sudo systemctl restart nova-sonic-react.service
        ;;
    status)
        echo "WebSocket Server Status:"
        sudo systemctl status nova-sonic-websocket.service --no-pager
        echo ""
        echo "React Application Status:"
        sudo systemctl status nova-sonic-react.service --no-pager
        ;;
    logs)
        if [ "$2" == "websocket" ]; then
            sudo journalctl -u nova-sonic-websocket.service -f
        elif [ "$2" == "react" ]; then
            sudo journalctl -u nova-sonic-react.service -f
        else
            echo "Usage: $0 logs [websocket|react]"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs [websocket|react]}"
        exit 1
        ;;
esac
