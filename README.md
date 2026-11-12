# lfsx-railway

Wrapper image for deploying [FerrLabs/LFSX](https://github.com/FerrLabs/LFSX) (Git LFS server, MPL-2.0) on Railway.
It pins the upstream image by digest, runs as root so the Railway volume is writable, and moves `/metrics` to a
private port. The upstream binary is unchanged. See the Dockerfile for the reasons.
