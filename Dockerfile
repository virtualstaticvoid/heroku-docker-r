ARG UBUNTU_VERSION
FROM ubuntu:$UBUNTU_VERSION

ARG R_VERSION
ARG CRAN_VERSION

# Set default locale
ENV LANG C.UTF-8

# Set default timezone
ENV TZ UTC

# copy over helpers script
COPY helpers.R /etc/R/helpers.R

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update -q \
  && apt-get upgrade -qy \
  && apt-get install -qy --no-install-recommends \
    ca-certificates \
    file \
    gnupg2 \
    lsb-release \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install R & set default CRAN repo
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
  && DISTRO=$(lsb_release -c | awk '{print $2}') \
  && echo "deb https://cloud.r-project.org/bin/linux/ubuntu $DISTRO-$CRAN_VERSION/" > /etc/apt/sources.list.d/cran.list \
  && apt-get update -q \
  && apt-get install -qy --no-install-recommends \
    apt-transport-https \
    automake \
    curl \
    fontconfig \
    libbz2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    liblzma-dev \
    libpcre2-dev \
    libpcre3-dev \
    locales \
    perl \
    sudo \
    tzdata \
    wget \
    zlib1g-dev \
    r-base-dev=${R_VERSION}* \
    r-recommended=${R_VERSION}* \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
  && echo '.libPaths(c("/app/R/site-library", .libPaths()))' >> /etc/R/Rprofile.site \
  && echo 'source("/etc/R/helpers.R")' >> /etc/R/Rprofile.site \
  && mkdir -p /app/R/site-library

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y software-properties-common \
  && add-apt-repository ppa:c2d4u.team/c2d4u4.0+
  && apt update -qq \
  && apt-get remove -y software-properties-common \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# set /app as working directory
WORKDIR /app

# run R console
CMD ["/usr/bin/R", "--no-save"]
