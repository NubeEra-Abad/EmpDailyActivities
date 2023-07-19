# How to host Django Application using gunicorn & Nginx


## Step 1 - Installing python and nginx
```
sudo apt update
sudo apt install python3-pip python3-dev nginx
```
This will install python, pip and nginx server

## Step 2 - Creating a python virtual environment 
```
sudo pip3 install virtualenv
```
This will install a virtual environment package in python. Let's create a project directory to host our Django application and create a virtual environment inside that directory.
```
mkdir ~/volt-project
cd ~/volt-project
```
```
virtualenv env
```
A virtual environment named env will be created. Let's activate this virtual environment:
```
source env/bin/activate
```
After activate the virtual enviroment, you will notice that the is new word `env` appear in the terminal before youe user name like the following:
```
(env)ubuntu@0.0.0.0
```
`(env)` means that the environment is activate.

## Step 3 - Installing Django and gunicorn
```
pip install django gunicorn
```
This installs Django and gunicorn in our virtual environment

## Step 4 - Setting up our Django project
At this point you can either clone project from GitHub or copy your existing Django project into the `volt-project` folder or create a fresh one as shown below:
```
django-admin startproject volt-core ~/volt-project
```
In my case I will clone Django project from the GitHub. this clone will create new directory called `django-volt-dashboard` make sure to move all files to the `~/volt-project`
```
git clone https://github.com/app-generator/django-volt-dashboard.git
```
Configuration the `IP-address` and the `Domain Name` to in the `settings.py` file of this project
```
nano ~/volt-project/volt-core/settings.py
```
Edit the `ALLOWED_HOSTS` and add `CSRF_TRUSTED_ORIGINS = ['https://volt.osamah.xyz']` after `ALLOWED_HOSTS`
```
ALLOWED_HOSTS = ['3.83.109.114', 'volt.osamah.xyz']
CSRF_TRUSTED_ORIGINS = ['https://volt.osamah.xyz']
```
In this project we have `requirements.txt` which contain all requirments to run this project, so to execute this file run this command
```
pip install -r requirements.txt
```

## Step 5 - Set Up Database
In file the project folder run this commands
```
python manage.py makemigrations
python manage.py migrate
```
start the app
```
python manage.py runserver 0.0.0.0:8000
```
Now you can test the application in the browser with instance Public IP and port no `8000`, make sure that port no is open in the securty group

## Step 6 - Configuring gunicorn
Lets test gunicorn's ability to serve our application by firing the following commands:
```
gunicorn --bind 0.0.0.0:8000 volt-core.wsgi
```
This should start gunicorn on port 8000. We can go back to the browser to test our application. Visiting http://<ip-address>:8000 shows a page like this:  
Deactivate the virtualenvironment by executing the command below:
```
deactivate
```
Let's create a system socket file for gunicorn now:
```
sudo nano /etc/systemd/system/gunicorn.socket
```
Paste the contents below and save the file
```
[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target
```
Next, we will create a service file for gunicorn
```
sudo nano /etc/systemd/system/gunicorn.service
```
Paste the contents below inside this file and change the data if some lines as the requrement for your project:
```
[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=ubuntu						// change the user if it's not ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/volt-project		// give path to your project location
ExecStart=/home/ubuntu/volt-project/env/bin/gunicorn \	// give path here as well
          --access-logfile - \
          --workers 3 \
          --bind unix:/run/gunicorn.sock \
          volt-core.wsgi:application		// name of the file where setteing.py is exist (volt-core) 

[Install]
WantedBy=multi-user.target
```
Lets now start and enable the gunicorn socket
```
sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket
```

## Step 7 - Configuring Nginx as a reverse proxy
Create a configuration file for Nginx using the following command
```
sudo nano /etc/nginx/sites-available/volt-project
```
Paste the below contents inside the file created
```
server {
    listen 80;
    server_name 3.83.109.114, volt.osamah.xyz; // change the IP and Domain Name

    location = /favicon.ico { access_log off; log_not_found off; }
    location /static/ {
        root /home/ubuntu/volt-project;		// give path
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}
```
If you do not have static folder in your project or the web is not display properly, comment the following lines
```
#    location /static/ {
#        root /home/ubuntu/volt-project;         
#    }
```
Activate the configuration using the following command:
```
sudo ln -s /etc/nginx/sites-available/volt-project /etc/nginx/sites-enabled/
```
Restart nginx and allow the changes to take place.
```
sudo systemctl restart nginx
```
Your Django website should now work fine!  
The only step is remaining is to configure `ACM` and `AWS Load Balancer` which I explain the steps in [001-Nginx-Multi-Websites.md](https://github.com/NubeEra-Abad/EmpDailyActivities/blob/Osamah999/Nginx/001-Nginx-Multi-Websites.md)
If you want to test the app without domain name, change the port no in `/etc/nginx/sites-available/volt-project` file then restart the Nginx server.
Remember if you change the configuration in `setting.py` or `nginx files` you need to restart the servers to apply the changes
```
sudo systemctl restart gunicorn
sudo systemctl restart nginx
```
## Done
