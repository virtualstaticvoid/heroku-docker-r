ARG BASE_IMAGE

FROM ${BASE_IMAGE}-build

# ONBUILD will copy application files into the container
#  and execute onbuild, Aptfile, init.R and restore packrat packages (if they are provided)

# override the base image CMD
CMD ["/usr/bin/R", "--no-save", "-f /app/app.R"]
