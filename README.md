# crux-ports
Some ports for the [CRUX operating system](http://crux.nu/). This README was modified from [CRUX MATE's](https://github.com/KrugerHeavyIndustries/crux-mate/).

## Quickstart ##

This git repository is also a ports collection. You can enable it like so:

On your CRUX Linux target installation download the file `/etc/ports/baguette.httpup`:


```
curl https://raw.githubusercontent.com/baguette/crux-ports/master/baguette.httpup -o /etc/ports/baguette.httpup
```

Enable the contrib ports collection file in `/etc/ports` if it's not already enabled:

```
mv contrib.rsync.inactive contrib.rsync
```

Edit the file `/etc/prt-get.conf`:

1. enable the contrib collection if it's not already (it is needed for some dependencies), and
2. enable this collection by adding a new line:

```
prtdir /usr/ports/baguette 
```

Finally, issue

```
ports -u
```

at the command line to get the ports collection (and any updates to other port collections).

## Installing the awesome window manager

Issue:

```
prt-get depinst awesome
```

at the command line to fetch, build, and install awesome and the necessary dependencies.

When this completes (it will take some time), assuming there are no problems or conflicts, enable the dbus daemon at startup in your `/etc/rc.conf` file (example below)

```
SERVICES=(dbus net crond) 
```

If using `startx` configure your `~/.xinitrc` with something like:

```
##  if there is no existing consolekit session, try to create a new one
##  running awesome;  otherwise, just start awesome without consolekit:
#
if [ -z "$XDG_SESSION_COOKIE" -a -x /usr/bin/ck-launch-session ]; then
  exec ck-launch-session dbus-launch --exit-with-session awesome
else
  exec dbus-launch --exit-with-session awesome
fi
```

Then issue '**startx**' at the command line. Assuming kernel compile options are correct you should find yourself with a working awesome desktop (basic).

## Issues

If anything doesn't work as described in this README, please [report your issues](https://github.com/baguette/crux-ports/issues).

