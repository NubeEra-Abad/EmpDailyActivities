FROM ubuntu:20.04

# Install required packages
RUN apt-get update && \
    apt-get install -y sudo && \
    apt-get install -y nfs-kernel-server && \
    apt-get install -y nano && \
    apt-get install -y rpcbind && \
    apt-get install -y ufw

# Configure NFS exports
RUN mkdir -p /data/nfs && \
    echo "/data/nfs *(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports

# Configure firewall rules
RUN ufw enable && \
    ufw allow from 192.168.0.0/16 to any port nfs

# Set permissions and ownership for NFS directory
RUN chmod 777 /data/nfs/ && \
    chown nobody:nogroup /data/nfs/

# Expose NFS ports
EXPOSE 111/udp 2049/tcp

# Start services
CMD service rpcbind start && \
    service nfs-kernel-server start && \
    bash
