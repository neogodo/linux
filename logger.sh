# Looger to text file using UDP

function logger.listener.start () {
    nohup socat -u UDP-RECV:12358 STDOUT >> /tmp/udp.log &
}

function logger.rotate.logfile () {
    mv -f /tmp/udp.log /tmp/udp.log.1
    ps -e -o pid,comm |grep socat |awk '{print $1}' |xargs kill -9
    logger.listener.start
}

function logger.message.broadcast () {
    which socat 2>&1 >/dev/null
    [[ $? -eq 0 ]] && {
        echo ${@} |socat - UDP-DATAGRAM:255.255.255.255:12358,broadcast
    } || {
        echo "failed: broadcast message needs socat binary program"
    }
}


echo "broadcast message2" |socat - UDP-DATAGRAM:255.255.255.255:12358,broadcast

