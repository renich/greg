Description
===========
service:
    Copy the relevant file to `/etc/systemd/system/`. Read it and change whatever needs to be changed. Or,
    better yet, just override it using: https://www.freedesktop.org/software/systemd/man/systemd.unit.html; example 2's alternative
    suggestion. Much better if you ask me.

    Change the name to something recognizable by you. For example: `greg-mywebsite.tld.service`. You could change the 'Description'
    within as well.

tmpfiles:
    Copy the relevant file to `/etc/tmpfiles.d/greg.conf`.

