FROM alpine:latest

RUN apk --no-cache add nfs-utils
RUN echo "/var/nfs *(rw,sync,no_subtree_check,no_root_squash,fsid=0)" >> /etc/exports
RUN echo "/var/nfs *(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports


COPY exports /etc/exports

CMD ["/bin/sh", "-c", "echo '/var/nfs *(rw,no_subtree_check,sync)' >> /etc/exports && rpcbind -w && rpc.nfsd -G 10 -N 2 -V 3 4 -N 4 -N 4.1 -N 4.2 -N 4.3 -N 4.4 -N 4.5 -N 4.6 -N 4.7 -N 4.8 -N 4.9 -N 4.10 && rpc.mountd -N 2 -V 3 -N 4 -N 4.1 -N 4.2 -N 4.3 -N 4.4 -N 4.5 -N 4.6 -N 4.7 -N 4.8 -N 4.9 -N 4.10 -N 4.11 && rpc.statd -N 2 -V 3 -N 4 -N 4.1 -N 4.2 -N 4.3 -N 4.4 -N 4.5 -N 4.6 -N 4.7 -N 4.8 -N 4.9 -N 4.10 -N 4.11 && rpc.idmapd"]
