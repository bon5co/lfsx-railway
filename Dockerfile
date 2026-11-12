# LFSX for Railway.
#
# LFSX is a Git LFS server (one static Rust binary on a distroless base, no database) whose permission model is
# "whatever the forge says": a client sends the token it would use to clone, and the server asks GitHub, GitLab or
# Gitea what that token may do. Three stock defaults need changing for a public Railway domain.
#
# 1. With no LFSX_ALLOWED the server serves EVERY repository on the forge, so anyone holding a token for a
#    repository of their own can store objects on the deployer's volume (upstream docs/allowed-namespaces.md says
#    to set it on any server the internet can reach). The template makes LFSX_ALLOWED a deploy-time field and this
#    image sets no default for it, because a literal default would be wrong for every deployer.
# 2. /metrics is served unauthenticated on the main listener, so on a public domain it is world readable.
#    LFSX_METRICS_BIND moves it to a second port that has no public domain; the main listener then answers 404.
# 3. The image runs as root, because Railway mounts the volume owned by uid 0 and the upstream `nonroot` user
#    could not write to it.
#
# The binary and its behaviour are otherwise untouched.
FROM ghcr.io/ferrlabs/lfsx:1.26.54@sha256:0e4066149eca8a53674575d412424f20bb086d0af9c1a761e87612e8e902515a

USER 0:0
ENV LFSX_AUTH=github \
    LFSX_STORAGE_ROOT=/var/lib/lfsx \
    LFSX_METRICS_BIND=0.0.0.0:9090

EXPOSE 8080
