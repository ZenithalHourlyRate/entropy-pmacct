# Entropy pmacct configuration files

In this repo, several necessary configuration files are provided for those
hosts in `entropy/gravity` to support monitoring and collecting of the flows
in `entropy/gravity`.

These files are primarily configured for `entropy` now, but minor changes can
be done to transform them to satisfy the need of `gravity`.

## Install pmacct

Since hosts in `entropy/gravity` are mainly debian boxes, we suggest one 
command to rule them all.

```bash
$ sudo apt install pmacct
```

For Arch users, however, `pmacct` is not in the official repos, but only in
AUR, hence we recommend

```bash
$ [AUR helper] -S pmacct
```

For arch linux arm users, we can build the package from the PKGBUILD obtained
from x86_64 machines with proper changes and manual dependency check, and
`pmacct` can run smoothly.

For CentOS users, the commands are

```
yum install libpcap libpcap-devel mariadb-libs mariadb-devel
git clone https://github.com/pmacct/pmacct
cd pmacct
./autogen.sh
./configure --enable-mysql
make
sudo make install
```

## Proper placement of the files

The file `entropy.conf`, `entropy.network.lst`, `entropy.pretag.map` and
`entropy.interfaces.map` should be placed in `/etc/pmacct/` since we have
 fixed the path to them in `entropy.conf`.

## Necessary changes in the files

First we need to determine `entropy.pretag.map`, which is a unique id for 
you box in the final statistics.

For entropy hosts with the subnet `2001:470:4c22:ae86:babe:XXX0::/92` where
`XXX` is your unique id, we convert `(XXX)_16=(YYYY)_10`, namely decimal number.
For example, `(41)_16=(65)_10`. Then we fill the field as

```
set_tag = YYYY
```

Now consider the `[redacted]` field in `entropy.conf`, they can be accessed
via `i@zenithal.me` or `t.me/ZenithalH`, or you can hack into the database
to obtain them.

## Daemon on startup

First of all, check that in `/etc/pmacct/entropy.conf`, `daemonize` is set 
to be `true`!

### openrc

For `openrc` users, espcially those with debian, first we need to disable
the default daemon when installing `pmacct` by

```
rc-update del pmacctd default
rc-update del uacctd default
rc-update del nfacctd default
rc-update del sfacctd default
```

Then you should move `etc.init.d.pmacctd.entropy` to 
`/etc/init.d/pmacctd.entropy` and move `etc.default.pmacctd.entropy` to
`/etc/default/pmacctd.entropy`. Remember to check that 
`/etc/init.d/pmacctd.entropy` is eXecutable, namely `+x`.

Then by the following commands to start the
daemon (proper changes to the configuration file needed!)

```
rc-update add pmacctd.entropy default
rc-service pmacctd.entropy start
```

We use the following command to disable the service

```
rc-update del pmacctd.entropy default
```

### systemd

First move `lib.systemd.system.pmacctd.entropy.service` to 
`/lib/systemd/system/pmacctd.entropy.service`, then move 
`etc.default.pmacctd.entropy` to `/etc/default/pmacctd.entropy`. We use the
following command to enable and start the service

```
systemctl enable --now pmacctd.entropy.service
```

Use the following command to disable the service

```
systemctl disable --now pmacctd.entropy.service
```

## Comment on entropy.interfaces.map (disabled now)

In fact other interfaces like `divi`, `ivi` or `any` can also be added in this
file, and an `ifindex` can be given to them, which could be a key in the final
statistics. However, this is only considered for gravity now.

## Comment on entropy.network.lst

This list provides an ip-to-subnet mapping, which should be altered greatly
for gravity hosts.

Now this file is generated by a script in the `entropy.git` repo, but it 
can not change automatically, which may cause inconsistency. The issue should
be resolved latter by `sync etc` effort of other participants.
