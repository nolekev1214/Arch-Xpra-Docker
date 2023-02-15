# Arch-Xpra-Docker
Dockerfile using Arch as base distribution with OpenGL support for use with Xpra

The make build command turns the Dockerfile into a dockerimage titled "xpra-html5" The make run command launches a detached Docker container with port 10000 exposed to port 80 locally. This allows for connection to the Xpra Webclient with the address using localhost.