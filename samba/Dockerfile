ARG SAMBA_VERSION=4.21.4-r4
ARG BUILD_DIR=/build
ARG BUILD_TAG
FROM alpine:3 AS base


FROM base AS build
ARG BUILD_DIR

WORKDIR "$BUILD_DIR"

COPY rootfs .
RUN find . -type f -not -perm 755 | while read -r f; do  \
      (head -n 1 "$f" 2>/dev/null | grep -q '^#!' && chmod -v 755 "$f") || true; done


FROM base AS final

ENV SAMBA_HOME=/opt/samba \
    SAMBA_CONF_FILE=/etc/samba/smb.conf

# Install samba
ARG SAMBA_VERSION
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash "samba=$SAMBA_VERSION" shadow tzdata && \
    addgroup -S smb && \
    adduser -S -D -H -h /tmp -s /sbin/nologin -G smb -g 'Samba User' smbuser &&\
    file="$SAMBA_CONF_FILE" && \
    sed -i 's|^;* *\(log file = \).*|   \1/dev/stdout|' $file && \
    sed -i 's|^;* *\(load printers = \).*|   \1no|' $file && \
    sed -i 's|^;* *\(printcap name = \).*|   \1/dev/null|' $file && \
    sed -i 's|^;* *\(printing = \).*|   \1bsd|' $file && \
    sed -i 's|^;* *\(unix password sync = \).*|   \1no|' $file && \
    sed -i 's|^;* *\(preserve case = \).*|   \1yes|' $file && \
    sed -i 's|^;* *\(short preserve case = \).*|   \1yes|' $file && \
    sed -i 's|^;* *\(default case = \).*|   \1lower|' $file && \
    sed -i '/Share Definitions/,$d' $file && \
    echo '   pam password change = yes' >>$file && \
    echo '   map to guest = bad user' >>$file && \
    echo '   usershare allow guests = yes' >>$file && \
    echo '   create mask = 0664' >>$file && \
    echo '   force create mode = 0664' >>$file && \
    echo '   directory mask = 0775' >>$file && \
    echo '   force directory mode = 0775' >>$file && \
    echo '   force user = smbuser' >>$file && \
    echo '   force group = smb' >>$file && \
    echo '   follow symlinks = yes' >>$file && \
    echo '   load printers = no' >>$file && \
    echo '   printing = bsd' >>$file && \
    echo '   printcap name = /dev/null' >>$file && \
    echo '   disable spoolss = yes' >>$file && \
    echo '   strict locking = no' >>$file && \
    echo '   aio read size = 0' >>$file && \
    echo '   aio write size = 0' >>$file && \
    echo '   vfs objects = catia fruit recycle streams_xattr' >>$file && \
    echo '   recycle:keeptree = yes' >>$file && \
    echo '   recycle:maxsize = 0' >>$file && \
    echo '   recycle:repository = .deleted' >>$file && \
    echo '   recycle:versions = yes' >>$file && \
    echo '' >>$file && \
    echo '   # Security' >>$file && \
    echo '   client ipc max protocol = SMB3' >>$file && \
    echo '   client ipc min protocol = SMB2_10' >>$file && \
    echo '   client max protocol = SMB3' >>$file && \
    echo '   client min protocol = SMB2_10' >>$file && \
    echo '   server max protocol = SMB3' >>$file && \
    echo '   server min protocol = SMB2_10' >>$file && \
    echo '' >>$file && \
    echo '   # Time Machine' >>$file && \
    echo '   fruit:delete_empty_adfiles = yes' >>$file && \
    echo '   fruit:time machine = yes' >>$file && \
    echo '   fruit:veto_appledouble = no' >>$file && \
    echo '   fruit:wipe_intentionally_left_blank_rfork = yes' >>$file && \
    echo '' >>$file && \
    rm -rf /tmp/*

ARG BUILD_DIR
COPY --from=build "$BUILD_DIR" /

EXPOSE 137/udp 138/udp 139 445

HEALTHCHECK --start-period=1m --start-interval=10s --interval=1m --timeout=15s --retries=3 \
            CMD health-check

VOLUME ["/etc", "/var/cache/samba", "/var/lib/samba", "/var/log/samba",\
            "/run/samba"]

ARG BUILD_TAG
ENV SAMBA_VERSION="$SAMBA_VERSION" \
    BUILD_TAG="$BUILD_TAG"

ENTRYPOINT ["/entrypoint.sh"]
