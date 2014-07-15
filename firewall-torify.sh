. /data/local/iptables

# redirect traffic for our friendly apps to TransPort
for uid in $ALL_UIDS; do
  uid=$(echo $app | cut -d '=' -f 2)
  name=$(echo $app | cut -d '=' -f 1)
  $IPTABLES -t nat -A OUTPUT ! -o lo -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m owner --uid-owner $uid -j REDIRECT --to-ports 9040 -m comment --comment "Force ${name} through TransPort"
done
# drop all unwanted output. because we can and we care :).
$IPTABLES -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# allow orbot output ? ???yes, that's what we really want :).
$IPTABLES -A OUTPUT -m owner --uid-owner $ORBOT_UID -j ACCEPT -m comment --comment "Allow Orbot output"

# Accept DNS requests to the Tor DNSPort.
$IPTABLES -A OUTPUT -d 127.0.0.1/32 -p udp -m udp --dport 5400 -j ACCEPT -m comment --comment "DNS Requests on Tor DNSPort"

# allow local traffic to Polipo
$IPTABLES -A OUTPUT -d 127.0.0.1/32 -p tcp -m tcp --dport 8118 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT -m comment --comment "Local traffic to Polipo"

# allow local traffic to TransPort
$IPTABLES -A OUTPUT -d 127.0.0.1/32 -p tcp -m tcp --dport 9040 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT -m comment --comment "Local traffic to TransPort"

# Accept outgoing traffic to the local Tor SOCKSPort.
$IPTABLES -A OUTPUT -d 127.0.0.1/32 -p tcp -m tcp --dport 9050 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT -m comment --comment "Local traffic to SOCKSPort"
