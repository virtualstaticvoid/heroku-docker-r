FROM heroku/heroku:16

ARG R_VERSION
ARG APT_VERSION
ARG GIT_BRANCH
ARG GIT_SHA
ARG GIT_DATE
ARG BUILD_DATE
ARG MAINTAINER
ARG MAINTAINER_URL

LABEL "r.version"="$R_VERSION" \
      "r.version.apt"="$APT_VERSION" \
      "git.branch"="$GIT_BRANCH" \
      "git.sha"="$GIT_SHA" \
      "git.date"="$GIT_DATE" \
      "build.date"="$BUILD_DATE" \
      "maintainer"="$MAINTAINER" \
      "maintainer.url"="$MAINTAINER_URL"

## Configure default locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.utf8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# install R & set default CRAN repo
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 \
  && echo 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial/' > /etc/apt/sources.list.d/cran.list \
  && apt-get update -q \
  && apt-get install -qy --no-install-recommends \
    libgsl0-dev \
    r-base=$APT_VERSION \
    r-recommended=$APT_VERSION \
  && echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
  && echo '.libPaths(c("/app/R/site-library", .libPaths()))' >> /etc/R/Rprofile.site \
  && rm -rf /var/lib/apt/lists/*

# setup app directory
RUN mkdir -p /app /app/R/site-library
WORKDIR /app

# run R console
CMD ["/usr/bin/R"]
