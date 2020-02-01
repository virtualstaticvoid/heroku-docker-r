FROM heroku/heroku:18-build

ARG R_VERSION
ARG APT_VERSION
ARG GIT_SHA
ARG GIT_DATE
ARG BUILD_DATE
ARG MAINTAINER
ARG MAINTAINER_URL
ARG BUILD_LOG_URL

LABEL "r.version"="$R_VERSION" \
      "r.version.apt"="$APT_VERSION" \
      "git.sha"="$GIT_SHA" \
      "git.date"="$GIT_DATE" \
      "build.date"="$BUILD_DATE" \
      "maintainer"="$MAINTAINER" \
      "maintainer.url"="$MAINTAINER_URL" \
      "build.log.url"="$BUILD_LOG_URL"

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
  && echo 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' > /etc/apt/sources.list.d/cran.list \
  && apt-get update -q \
  && apt-get install -qy --no-install-recommends \
    libgsl0-dev \
    r-base-dev=$APT_VERSION \
    r-recommended=$APT_VERSION \
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
