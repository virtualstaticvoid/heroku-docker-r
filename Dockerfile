ARG UBUNTU_VERSION=latest
FROM ubuntu:$UBUNTU_VERSION

ARG R_VERSION
ARG CRAN_VERSION

# Set default locale
ENV LANG=C.UTF-8

# Set default timezone
ENV TZ=UTC

# copy over helpers script
COPY helpers.R /etc/R/helpers.R

ARG DEBIAN_FRONTEND=noninteractive

# prerequisites
RUN apt-get update -q \
 && apt-get install -qy --no-install-recommends \
      apt-transport-https \
      automake \
      ca-certificates \
      curl \
      file \
      fontconfig \
      gnupg2 \
      libbz2-dev \
      libcurl4-openssl-dev \
      libdeflate-dev \
      libicu-dev \
      liblzma-dev \
      libpcre2-dev \
      libpcre3-dev \
      libsodium-dev \
      libssl-dev \
      libxml2-dev \
      locales \
      lsb-release \
      pandoc \
      pandoc-citeproc \
      perl \
      software-properties-common \
      sudo \
      tzdata \
      wget \
      zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# add R package configurations
# https://cran.r-project.org/bin/linux/ubuntu/
RUN distro=$(lsb_release -c | awk '{print $2}') \
 && keyid=E298A3A825C0D65DFD57CBB651716619E084DAB9 \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --recv-keys --keyserver keyserver.ubuntu.com $keyid \
 && mkdir -p /etc/apt/keyrings \
 && gpg --export $keyid > /etc/apt/keyrings/cloud.r-project.org.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/cloud.r-project.org.gpg] https://cloud.r-project.org/bin/linux/ubuntu ${distro}-$CRAN_VERSION/" > /etc/apt/sources.list.d/cloud.r-project.org.list \
 && echo "deb-src [signed-by=/etc/apt/keyrings/cloud.r-project.org.gpg] https://cloud.r-project.org/bin/linux/ubuntu ${distro}-$CRAN_VERSION/" >> /etc/apt/sources.list.d/cloud.r-project.org.list \
 && rm -rf $GNUPGHOME

# add CRAN modules package configurations
# https://launchpad.net/~c2d4u.team/+archive/ubuntu/c2d4u4.0+
RUN distro=$(lsb_release -c | awk '{print $2}') \
 && keyid=6E12762B81063D17BDDD3142F142A4D99F16EB04 \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --recv-keys --keyserver keyserver.ubuntu.com $keyid \
 && mkdir -p /etc/apt/keyrings \
 && gpg --export $keyid > /etc/apt/keyrings/c2d4u.team.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/c2d4u.team.gpg] https://ppa.launchpadcontent.net/c2d4u.team/c2d4u4.0+/ubuntu/ ${distro} main" > /etc/apt/sources.list.d/c2d4u.team.list \
 && echo "deb-src [signed-by=/etc/apt/keyrings/c2d4u.team.gpg] https://ppa.launchpadcontent.net/c2d4u.team/c2d4u4.0+/ubuntu/ ${distro} main" >> /etc/apt/sources.list.d/c2d4u.team.list \
 && rm -rf $GNUPGHOME

# install TinyTeX
RUN curl -sSL "https://yihui.org/tinytex/install-bin-unix.sh" | sh \
 && /root/.TinyTeX/bin/*/tlmgr path remove \
 && mv /root/.TinyTeX/ /opt/TinyTeX \
 && /opt/TinyTeX/bin/*/tlmgr option sys_bin /usr/local/bin \
 && /opt/TinyTeX/bin/*/tlmgr path add

# install R
RUN apt-get update -q \
 && apt-get install -qy --no-install-recommends \
      r-base-dev=${R_VERSION}* \
      r-recommended=${R_VERSION}* \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# set default CRAN repo
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
 && echo '.libPaths(c("/app/R/site-library", .libPaths()))' >> /etc/R/Rprofile.site \
 && echo 'source("/etc/R/helpers.R")' >> /etc/R/Rprofile.site \
 && mkdir -p /app/R/site-library

# set /app as working directory
WORKDIR /app

# run R console
CMD ["/usr/bin/R", "--no-save"]
