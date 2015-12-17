# crux-ports
Some ports for the [CRUX operating system](http://crux.nu/). This README was modified from [CRUX MATE's](https://github.com/KrugerHeavyIndustries/crux-mate/).

## Quickstart ##

This git repository is also a ports collection. You can enable it like so:

On your CRUX Linux target installation download the file /etc/ports/baguette.httpup:


```
curl https://raw.githubusercontent.com/baguette/crux-ports/master/baguette.httpup -o /etc/ports/baguette.httpup
```

Enable the contrib ports collection rsync in /etc/ports if it's not already enabled:

```
mv contrib.rsync.inactive contrib.rsync
```

Edit the file /etc/prt-get.conf and enable the contrib collection (it is needed for some dependencies). Then in /etc/prt-get.conf put

```
prtdir /usr/ports/baguette 
```

Then issue

```
ports -u
```

at the command line to get the ports collection (and any updates to other port collections)

## Installing the awesome window manager

Issue the following command: 

```
prt-get depinst awesome
```

When this completes (it will take some time - assuming there are no problems or conflicts), enable the dbus daemon at startup in your /etc/rc.conf file (example below)

```
SERVICES=(dbus net crond) 
```

If using startx configure your .xinitrc with

```
exec awesome
```

Then issue '**startx**' at the command line. Assuming kernel compile options are correct you should find yourself with a working awesome desktop (basic).

If it doesn't work like this. Please [report your issues](https://github.com/baguette/crux-ports/issues).
