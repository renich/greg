====
greg
====
-------------------------
An app to agregate feeds.
-------------------------

Description
===========
Just a planet made in ruby.


Instructions
============
For a development tryout or local deployment:

.. code:: bash

    bundle
    bundle exec thin start

If you're to deploy this for production, just configure `thin` so it uses sockets and consume the socket via `nginx`. We will arange
for systemd to do this for us.

So, first things first. We configure thin for this:


Pre-requisites
--------------
I will make some assumptions:

domain:             myagregatorwebsite.tld
user:               greg
source code at:     /srv/www/greg/myagregatorwebsite.tld/default
thin logs:          /var/log/greg/myagregatorwebsite.tld.log
socket at:          /run/greg/myagregatorwebsite.tld.sock
PID file at:        /run/greg/myagregatorwebsite.tld.pid
webserver:          tengine (nginx fork)

Also, you need:

* git
* ruby (whatever sinatra supports)
* bundler
* tengine/nginx

User
----

.. code:: bash

    # become root
    su -

    # create the user
    useradd -b /srv/www -mr greg

Directories
-----------
.. code:: bash

    # log directory
    mkdir -m 2770 /var/log/greg

    # fix ownership
    chown greg:greg /var/log/greg/

    # runtime
    cat << 'EOF' > /etc/tmpfiles.d/greg.conf
    d /run/greg 0770 greg tengine
    EOF

    systemd-tmpfiles --create

systemd
-------
```systemd:/samples/systemd/service/greg-mywebsite.tld-tengine.service```

nginx
-----
Insert the following wherever possible. I have my own configuration setup here:
https://github.com/renich/fedora-configs/tree/nginx/etc/nginx

So, if you decide to go my way, just put it in `/etc/nginx/server.d/myagregatorwebsite.tld.conf`.

```nginx:/samples/tengine/myagregatorwebsite.tld.conf```

.. note::

    Actually, I use `tengine`; which is a fork of `nginx`; but with all the features the community version lacks. A much better
    option. Good thing is that you just need to exchange the term `nginx` for `tengine` in case you decide to go my way.

Source
------
.. code:: bash

    # become the user
    su - greg

    # set the proper umask
    umask 007

    # create
    mkdir -p /srv/www/greg/myagregatorwebsite.tld/default

    # go there
    cd /srv/www/greg/myagregatorwebsite.tld/default

    # clone
    git clone https://github.com/renich/greg.git .

    # install gems
    bundle install

thin
----
.. code:: bash

    # configure thin
    bundle exec thin \
        --config config/thin.yml \
        --daemonize \
        --environment production \
        --log /var/log/greg/myagregatorwebsite.tld.log \
        --pid /run/greg/myagregatorwebsite.tld.pid \
        --socket /run/greg/myagregatorwebsite.tld.sock \
        --threaded \
        config

services
--------
Now, as root:

.. code:: bash

    # enable services
    systemctl enable greg-myagregatorwebsite.tld.service

    # start
    systemctl start greg-myagregatorwebsite.tld.service

You're done!


Disclaimer
==========
This project is a piece of crap. I will try to find some time to work on it and make it respectable. At least as fast as it can be.
Maybe, even, async!

For now, it just sucks. It outlines a great way of how to deploy a Sinatra/Padrino/Hanami ruby app; with thin and nginx, though.

Ah!! Do what you want!


License
=======
GPLv3 or >
