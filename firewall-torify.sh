. /data/local/iptables

# redirect traffic for our friendly apps to polipo
for uid in $ALL_UIDS; do
  $IPTABLES -t nat -A OUTPUT ! -o lo -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m owner --uid-owner $uid -j REDIRECT --to-ports 9040
done
# drop all unwanted output. because we can and we care :).
$IPTABLES -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# allow orbot output â €”€yes, that's what we really want :).
$IPTABLES -A OUTPUT -m owner --uid-owner $ORBOT_UID -j ACCEPT

# Accept DNS requests to the Tor DNSPort.
$IPTABLES -A OUTPUT -d 127.0.0.1/32 -p udp -m udp --dport 5400 -j ACCEPT

# allow local traffic to Polipo
$IPTABLES -A OUTPUT -d 127.0.0.1/32 -p tcp -m tcp --dport 8118 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT

# allow local traffic to TransPort
$IPTABLES -A OUTPUT -d 127.0.0.1/32 -p tcp -m tcp --dport 9040 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT

# Accept outgoing traffic to the local Tor SOCKSPorts.
$IPTABLES -A OUTPUT -d 127.0.0.1/32 -p tcp -m tcp --dport 9050 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT
