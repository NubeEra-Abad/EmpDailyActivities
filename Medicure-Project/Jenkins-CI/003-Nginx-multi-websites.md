# Nginx for hosting multiple website using one IP address and sub-domains
## AWS configuration
```
1. First we need to create ubuntu instance.
2. Open port no "443" and "80".
3. Get inside the intance and install nginx using the following command

sudo apt update
sudo apt install nginx
```
## Nginx configuration
1. navigate to `/vat/www/`
```
cd /var/www
```
2. Now we will create two directories for two html project.
```
sudo mkdir example.com
```
```
sudo mkdir test.com
```
3. Create `index.html` file inside the `example.com` and paste the following code
```html
<html>
    <head>
        <title>Welcome to example.com!</title>
    </head>
    <body>
        <h1>Success! The example.com server block is working!</h1>
        <h1>example.com!</h1>
        <h1>The example.com!</h1>
        <h1>The example.com!</h1>    
    </body>
</html>
```
4. Repeat step 3 and create `index.html` file inside `test.com` directory and paste the following code
```html
<html>
    <head>
        <title>Welcome to test.com!</title>
    </head>
    <body>
        <h1>Success! The example.com server block is working!</h1>
        <h1>The test.com!</h1>
        <h1>The test.com!</h1>    
    </body>
</html>
```
5. Now we have `3 projects` in `/var/www/`
```
1. default
2. example.com	
3. test.com
```
6. For running the three project with separate `domain name` or `sub-domain name` we need to configure everyone separatly.
7. Navigate to `/etc/nginx/sites-available/` you will file the `default` file for the Nginx, open it
```
sudo nano /etc/nginx/sites-available/default
```
8. After neglect the comment lines the code will look like this
```
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;
	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		try_files $uri $uri/ =404;
	}
}
```
9. let's consider that we have domain name called `domain.com`
10. Modify the file to look like this 
```
server {
        listen 80;       // remove default_server;
        listen [::]:80;  // remove default_server;

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name www.domain.com;  // modify here

        location / {
                try_files $uri $uri/ =404;
        }
}
```
11. Make a copy of this file for the two remaining project
```
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/example.com
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/test.com
```
12. Open the `example.com` and `test.com` and give this configuration
```
sudo nano /etc/nginx/sites-available/example.com 
```
example.com
```
server {
        listen 80;       
        listen [::]:80;  

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name example.domain.com;  // change www.domain.com to example.domain.com

        location / {
                try_files $uri $uri/ =404;
        }
}
```
test.com
```
server {
        listen 80;       
        listen [::]:80;  

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name test.domain.com;  // change www.domain.com to test.domain.com

        location / {
                try_files $uri $uri/ =404;
        }
}
```
13. Copy the files to `/etc/nginx/sites-enabled/` directory
```
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com
sudo ln -s /etc/nginx/sites-available/test.com /etc/nginx/sites-enabled/test.com
```
14. Verify if the configruation will run successfully by running the following command
```
sudo nginx -t
```
you should see output like the following
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

17. Restart the Nginx server to apply the new configuration
```
sudo systemctl restart nginx
```
## AWS ACM configuration
1. In aws go to `ACM` or `AWS Certificate Manager`
2. I will consider that my domain name is `domain.com`
   - Request certificate --> Request a public certificate --> next
   - In Fully qualified domain name type your domain name like this `*.domain.com`
   - DNS validation --> RSA 2048
   - Tag --> Name --> tag value `domain.com` --> request
3. Now for validate that this domain is belong to us we need to copy the `CNAME name` and `CNAME value` for this certificate to domain name provider
4. Click on the certificate Id and you will see the `CNAME name` and `CNAME value`
5. Go to your domain name provider website and create new DNS record type `CNAME`
6. In name field paste the `CNAME name` value without the domain name in the end
ex:
```
_2cae033805ff34be2fc797245b1dc292.domain.com.  
```
It should paste like this
```
_2cae033805ff34be2fc797245b1dc292.
```
7. In value field paste the `CNAME value` value as it is without changes
8. save the record and go to the AWS ACM and refresh the ACM page.
9. The validation it will take time to show the certificate status as `issued` so wait it take between 30 minute to 24 hours. 
## Load Balancers configuration
1. First create `Target Group`
   - create target group --> Choose a target type as instance --> give name ex:`nginx-TG` --> next
   - Select the instance where the nginx server is running --> click on `include as pending below` --> create
2. Create Load Balancer
   - create load balancer --> Application Load Balancer --> give name ex: `nginx-LB`
   - In `Mappings` select all the existing `subnet`
   - Select Security groups with port no `443` and `80` open
   - In Listener select the protocol `https` and forword to the target group `nginx-TG`
   - Create load balancer
3. Copy the load balancer `DNS name` and go to your domain name provider
4. In your domain name provider create new DNS record with type `CNAME`
5. In the name section type `example` and the value your load balancer `DNS name` 
6. Create another recode for `test.com` project
7. name `test` value your load balancer `DNS name`
8. Now you can use the domain `example.domain.com` to access `example.com` website  
and `test.domain.com` to access `test.com` website
