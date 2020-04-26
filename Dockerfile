ARG HEROKU_VERSION
FROM heroku/heroku:$HEROKU_VERSION

ARG R_VERSION

## Configure default locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.utf8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# copy over helpers script
COPY helpers.R /etc/R/helpers.R

# install R & set default CRAN repo
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
  && UBUNTU_VERSION=$(lsb_release -c | awk '{print $2}') \
  && echo "deb https://cloud.r-project.org/bin/linux/ubuntu $UBUNTU_VERSION-cran35/" > /etc/apt/sources.list.d/cran.list \
  && apt-get update -q \
  && apt-get install -qy --no-install-recommends \
    libgsl0-dev \
    r-base-dev=${R_VERSION}* \
    r-recommended=${R_VERSION}* \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/* \
  && echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
  && echo '.libPaths(c("/app/R/site-library", .libPaths()))' >> /etc/R/Rprofile.site \
  && echo 'source("/etc/R/helpers.R")' >> /etc/R/Rprofile.site \
  && mkdir -p /app/R/site-library

# set /app as working directory
WORKDIR /app

# run R console
CMD ["/usr/bin/R", "--no-save"]
