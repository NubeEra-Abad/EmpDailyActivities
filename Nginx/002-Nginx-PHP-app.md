# How to Configure PHP with NGINX


## Step 1 - Install Nginx and PHP_FPM on Ubuntu
Nginx doesn’t know how to run a PHP script of its own. It needs a PHP module like PHP-FPM to efficiently manage PHP scripts. PHP-FPM, on the other hand, runs outside the NGINX environment by creating its own process. Therefore when a user requests a PHP page the nginx server will pass the request to PHP-FPM service using FastCGI.
```
sudo apt-get update -y
sudo apt-get install nginx -y
sudo apt-get install php8.1-fpm -y
```
Check if NGINX and PHP-FPM is running
```
sudo systemctl status nginx
sudo systemctl status php8.1-fpm
```

## Step 2 - Configure PHP-FPM
Edit the `default` file of NGINX or create a copy for your PHP project and give it name. if you will create a copy remove the `default_server` from the `default` file.
```
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/example.com
```
Open the `example.com` file and give this configuration
```
server {
  # Example PHP Nginx FPM config file
  listen 80;				// remove default_server
  listen [::]:80;
  root /var/www/example.com;		// give the path to your index.php

  # Add index.php to setup Nginx, PHP & PHP-FPM config
  index index.php index.html index.htm index.nginx-debian.html;   // add index.php

  server_name example.osamah.xyz;	// give your domain name

  location / {
    try_files $uri $uri/ =404;
  }

  # pass PHP scripts on Nginx to FastCGI (PHP-FPM) server
  location ~ \.php$ {				// uncomment here
    include snippets/fastcgi-php.conf;		// uncomment here

    # Nginx php-fpm sock config:
    fastcgi_pass unix:/run/php/php8.1-fpm.sock;	// uncoment here and change the php version to php8.1-fpm
    # Nginx php-cgi config :
    # Nginx PHP fastcgi_pass 127.0.0.1:9000;
  }						// uncomment here

  # deny access to Apache .htaccess on Nginx with PHP, 
  # if Apache and Nginx document roots concur
  location ~ /\.ht {				// uncomment here
    deny all;					// uncomment here
  }						// uncomment here
} # End of PHP FPM Nginx config example
```
Copy the `example.com` to `/etc/nginx/sites-enabled/`
```
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com
```
Verify if the configruation will run successfully by running the following command
```
sudo nginx -t
```
you should see output like the following
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```
Restart the Nginx server to apply the new configuration
```
sudo systemctl restart nginx
```
Now you can test your PHP application by runnig your domain name in the browser.
