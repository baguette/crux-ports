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

## Adwaita

The Adwaita GTK+ theme is included in the gnome-themes-standard package.  The Adwaita icon theme is included in the adwaita-icon-theme package. To use them with GTK+2, add the following lines to /usr/etc/gtk-2.0/gtkrc

```
gtk-icon-theme-name = "Adwaita"
gtk-theme-name = "Adwaita"
```

## Haskell Platform

The haskell-platform-bin port provides the Haskell Platform. It installs into the non-standard location /usr/local/haskell. This is normally a big no-no for CRUX, but I could not figure out how to get it to install in any other location and still work properly.

Once the package is installed, you need to add /usr/local/haskell/ghc-7.10.3-x86\_64/bin to your PATH to use it.

## Issues

If anything doesn't work as described in this README, please [report your issues](https://github.com/baguette/crux-ports/issues).
