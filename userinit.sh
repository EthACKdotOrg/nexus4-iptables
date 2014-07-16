. /data/local/applist

$IPTABLES -F INPUT
$IPTABLES -F OUTPUT

$IPTABLES -t nat -F OUTPUT

$IPTABLES -P OUTPUT DROP
$IPTABLES -P INPUT DROP
$IPTABLES -P FORWARD ACCEPT

# allow local inputs
$IPTABLES -A INPUT -i lo -j ACCEPT
$IPTABLES -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

$IPTABLES -A INPUT -j bw_INPUT
$IPTABLES -A INPUT -j fw_INPUT

# redirect DNS queries to DNSListener if not for local interface
$IPTABLES -t nat -A OUTPUT ! -o lo -p udp -m udp --dport 53 -j REDIRECT --to-ports 5400

## LAN block - you may want to remove this until EOLAN
$IPTABLES -N LAN
$IPTABLES -F LAN
# Allow to bypass Tor for LAN
$IPTABLES -t nat -A OUTPUT -d 10.0.0.0/8 -j RETURN
$IPTABLES -t nat -A OUTPUT -d 172.16.0.0/12 -j RETURN
$IPTABLES -t nat -A OUTPUT -d 192.168.0.0/16 -j RETURN

# Accept connections to the LAN.
$IPTABLES -A OUTPUT -d 10.0.0.0/8 -j LAN
$IPTABLES -A OUTPUT -d 172.16.0.0/12 -j LAN
$IPTABLES -A OUTPUT -d 192.168.0.0/16 -j LAN

$IPTABLES -A LAN -p tcp -m tcp --dport 53 -j REJECT --reject-with icmp-port-unreachable
$IPTABLES -A LAN -p udp -m udp --dport 53 -j REJECT --reject-with icmp-port-unreachable
$IPTABLES -A LAN -j ACCEPT
## EOLAN

(sleep 30 && sh /data/local/firewall-torify.sh) &
