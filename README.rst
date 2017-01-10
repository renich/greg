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

If you're to deploy this for production, just configure `thin` so it uses sockets and consume the socket via `tengine`. We will arange
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

Also, you need:

* git
* ruby (whatever sinatra supports)
* bundler

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
.. code:: bash

    cat << 'EOF' > /etc/systemd/system/greg-myagregatorwebsite.tld.service
    [Unit]
    After=network.target
    Before=tengine.service
    Description=grep: default
    Documentation=https://github.com/renich/greg/
    Requires=tengine.service

    # tests
    AssertPathExists=/srv/www/greg/myagregatorwebsite.tld/default
    AssertPathExists=/var/log/greg
    AssertPathExists=/run/greg

    [Service]
    Restart=always
    ExecStart=/usr/bin/bundler exec thin -C config/thin.yml start
    ExecStop=/usr/bin/bundler exec thin -C config/thin.yml stop
    PIDFile=/run/greg/myagregatorwebsite.tld.pid
    PrivateTmp=yes
    Type=forking
    User=greg
    WorkingDirectory=/srv/www/greg/myagregatorwebsite.tld/default

    [Install]
    WantedBy=multi-user.target
    Also=tengine.service

    EOF

tengine
-------
Insert the following wherever possible. I have my own configuration setup here:
https://github.com/renich/fedora-configs/tree/nginx/etc/nginx

So, if you decide to go my way, just put it in `/etc/nginx/server.d/myagregatorwebsite.tld.conf`.

.. code:: nginx

    upstream myagregatorwebsite.tld {
        server unix:///run/greg/myagregatorwebsite.tld.sock;
    }

    server {
        listen 80;
        server_name .myagregatorwebsite.tld;

        location / {
            try_files $uri @myagregatorwebsite.tld;
        }

        location @myagregatorwebsite.tld {
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_pass http://myagregatorwebsite.tld;
        }

        error_log /var/log/tengine/myagregatorwebsite-error.log;
    }


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

For now, it just sucks. It outlines a great way of how to deploy a Sinatra/Padrino/Hanami ruby app; with thin and tengine/nginx, though.

Ah!! Do what you want!


License
=======
GPLv3 or >
