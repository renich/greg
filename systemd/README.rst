Description
===========
tmpfiles-greg.conf:
    Put this file in `/etc/tmpfiles.d/greg.conf`. Change `nginx` to `tengine` if needed.

greg-myagregatorwebsite.tld.conf:
    Just rename it to watever you want and put it in `/etc/systemd/system/`. Read it and change whatever needs to be changed. Or,
    better yet, just override it using: https://www.freedesktop.org/software/systemd/man/systemd.unit.html; example 2's alternative
    suggestion. Much better if you ask me.
