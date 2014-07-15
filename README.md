nexus4-iptables
===============

Small iptables script/rules for nexus4

Usage
-----
Put the content in /dat/local/ directory. Reboot your phone. Enjoy.

You may want to edit the "iptables" file in order to allow your favorit apps

Requirement
-----------
You need to have root on your phone. You also need to have a working Orbot installed,
and *deactivate* its transparent proxy thing.

Why a flat script instead of AFWall/Orbot rules?
------------------------------------------------
I tried. Really. But it seems there are "some" conflicts when you try to have both AFWall
and Orbot managing your firewall… The latter flushes all the rules you may have set in AFWall.
This, of course, is bad ;).

What does this bundle?
----------------------
First, it will ensure your phone doesn't have any network at boot time. This is the part in "userinit.sh",
setting INPUT, OUTPUT and FORWARD chains policy to "DROP", and flushing all what may have been added.

Once it's done, it will fork a second script. This one will wait 30 seconds before being really called.
It will then do some magic with NAT table, forcing requests for each app you defined in "iptables" file
to go through Orbot TransProxy (default port: 9040).
It will also force DNS queries through Orbot DNS Listened (default: 5400)

All other connections will hit a wall and be dropped in order to ensure only the app YOU want are the only ones
having some network connection.

Small not though: for now, LAN is allowed. You may want to drop this as well, just feel free to remove the blocks.
