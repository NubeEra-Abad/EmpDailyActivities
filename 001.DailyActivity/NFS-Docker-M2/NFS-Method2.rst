###################
To Setup NFS with Docker Images
###################

Run the following commands to make nfs containers

.. code::

    docker network create nfs-net


* Run NFS Server Container:


.. code::

docker run -d --name nfs-server \
  --net nfs-net \
  -v /path/to/nfs/data:/var/nfs \
  --privileged \
  -e SHARED_DIRECTORY=/var/nfs \
  itsthenetwork/nfs-server-alpine:latest


*********************************
 Run the NFS client container:
*********************************

.. code::

docker run -it --name nfs-client \
  --net nfs-net \
  --mount type=volume,src=nfs-data,dst=/mnt/nfs \
  --privileged \
  -e NFS_SERVER=nfs-server \
  -e NFS_DIRECTORY=/var/nfs \
  alpine:latest /bin/sh


This will take you into client container

Here make Test file in the /mnt/nfs directory 

.. code::

    cd /mnt/nfs
    touch testfile.txt

This will create a file named `testfile.txt` in the shared directory, which can be accessed from the NFS server container or any other container connected to the nfs-net network.







**************************
 Error While Doing This:
**************************
The Error I am facing While Doing this all is that The NFS-Server container is not starting to check the connection between the containers.