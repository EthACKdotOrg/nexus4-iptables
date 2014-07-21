# nexus4-iptables

Small iptables script/rules for nexus4

## Usage
Put the content in /data/local/ directory. Reboot your phone. Enjoy.

Via adb, this may be done like that:
```Bash
for i in firewall-torify.sh applist userinit.sh; do
  adb push $i /data/local/
done
adb reboot
```

You may want to edit the "applist" file in order to allow your favorit apps.

## Requirement
You need to have root on your phone. You also need to have a working Orbot installed,
and *deactivate* its transparent proxy thing.

## Why a flat script instead of AFWall/Orbot rules?
I tried. Really. But it seems there are "some" conflicts when you try to have both AFWall
and Orbot managing your firewall… The latter flushes all the rules you may have set in AFWall.
This, of course, is bad ;).

## What does this bundle?
First, it will ensure your phone doesn't have any network at boot time. This is the part in "userinit.sh",
setting INPUT, OUTPUT and FORWARD chains policy to "DROP", and flushing all what may have been added.

Once it's done, it will fork a second script. This one will wait 30 seconds before being really called.
It will then do some magic with NAT table, forcing requests for each app you defined in "applist" file
to go through Orbot TransProxy (default port: 9040).
It will also force DNS queries through Orbot DNS Listened (default: 5400)

All other connections will hit a wall and be dropped in order to ensure only the app YOU want are the only ones
having some network connection.

Small not though: for now, LAN is allowed. You may want to drop this as well, just feel free to remove the blocks.

Currently, the following applications are authorized:
  * org.torproject.android
  * org.thialfihar.android.apg
  * com.qubling.sidekick
  * com.csipsimple
  * info.guardianproject.otr.app.im
  * org.connectbot
  * at.bitfire.davdroid
  * com.android.documentsui
  * com.android.providers.downloads.ui
  * com.android.providers.downloads
  * com.duckduckgo.mobile.android
  * org.fdroid.fdroid
  * fr.gaulupeau.apps.InThePoche
  * com.fsck.k9
  * acr.browser.lightning
  * ch.fixme.status
  * net.osmand.plus
  * org.thoughtcrime.redphone
  * com.seafile.seadroid2
  * org.telegram.messenger
  * jackpal.androidterm
  * org.thoughtcrime.securesms
  * ch.threema.app
  * org.mariotaku.twidere
  * szelok.app.twister
  * de.robv.android.xposed.installer

## Why are you routing all through Orbot?
Because I'm a Torrorist.

Seriously: I was abroad, on some hotel, open wifi… And I wasn't that happy knowing anyone could follow me. Nothing to hide, sure,
but I'm not naked in the street (plus it's illegal in many places ;) ).

I wasn't that happy knowing apps may connect to the Net and do stuff without my consent. OK, I'm running a non-stock Android. OK,
I'm running only opensource apps. OK, I also have XPrivacy. But hey, we're never sure. This stuff isn't in conflict with any
of my other usages. And it works.

## Nexus4 only?
I'm pretty sure it will work on any rooted android. But for now, I have tested only on my own nexus4, running SlimKat ROM…

If you test it on some other system, please let me know, I'll update the README in order to list working stuff :).

### Supported devices
  * Samsung S3 (thanks Alexis R)

## I have some modification to propose
Feel free to fork it, create pull requests and spread the love :)

## I want an app!
Well… this part will be the harder for me. In my head, the app must do the following:
  * allow to check apps allowed to connect to Orbot (and the net)
  * activate or deactivate LAN authorization
  * update iptables when we update the list of authorized apps
  * refuse to set up iptables rules if no orbot is present
  * propose to download orbot from f-droid if not installed

If you have the necessary knowledge for such an app, please feel free to create it. Really.
On my side, I don't think I'll be able to produce one before many weeks/months, most probably with a poor quality…

Know what? [We do have one now!](https://github.com/EthACKdotOrg/Torrific)
