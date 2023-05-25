FROM alpine:latest

RUN apk --no-cache add nfs-utils
RUN rpcbind && rpc.statd -L

CMD ["/bin/sh", "-c", "rpcbind -w && rpc.statd && rpc.idmapd"]
