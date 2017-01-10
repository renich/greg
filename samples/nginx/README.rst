It is simple enough to understand.

I really recommend following my setup here: https://github.com/renich/fedora-configs/tree/nginx/etc

It will save you time and ease configuration.

Besides:

* It uses nginx's terms; not Ubuntu's or any other distro's terms; which is much better
* It follows Fedora's convention for config inclusion. (something.d/my.conf)
* Stuff is separated and `nginx -t` will help debug.

This configuration applies to both: nginx and tengine. Please, just replace 'nginx' everywhere if using on tengine.
