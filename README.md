# Heroku R Docker Image

[![Build Status](https://travis-ci.org/virtualstaticvoid/heroku-docker-r.svg?branch=master)](https://travis-ci.org/virtualstaticvoid/heroku-docker-r)
[![](https://images.microbadger.com/badges/version/virtualstaticvoid/heroku-docker-r.svg)](https://microbadger.com/images/virtualstaticvoid/heroku-docker-r)
[![](https://images.microbadger.com/badges/image/virtualstaticvoid/heroku-docker-r.svg)](https://microbadger.com/images/virtualstaticvoid/heroku-docker-r)

This is the docker image for applications which use [R][2] for statistical computing and [CRAN][3] for R packages, running on [Heroku][4].

This project is compatible with the [heroku-buildpack-r][5] so that it is possible to migrate your existing Heroku R applications and deploy them using the new Heroku [`container`][7] stack, however there are some caveats if multiple buildpacks were used together with [heroku-buildpack-r][5].

The new stack alleviates many of the complexities and issues with the R buildpack.

Pre-built docker images are published to [DockerHub][13], and are based off the [heroku/heroku][15] docker image to ensure compatibility for existing R applications.

Support has been added for the [packrat][8] package dependency manager.

**NOTE**: Docker *is not required* to be installed on your machine, unless you need to build and run the images locally. For the most common use cases, you will probably use the default setup, so it won't be necessary to have docker installed.

## Usage

### Shiny Applications

These steps are for [Shiny][14] applications.

In your Shiny application source's root directory:

* Create a `Dockerfile` file and insert the following content.

  ```
  FROM virtualstaticvoid/heroku-docker-r:shiny
  ENV PORT=8080
  CMD ["/usr/bin/R", "--no-save", "--gui-none", "-f /app/run.R"]
  ```

* Create a `heroku.yml` file and insert the following content.

  ```yaml
  build:
    docker:
      web: Dockerfile
  ```

* Commit the changes, using `git` as per usual.

  ```bash
  git add Dockerfile heroku.yml
  git commit -m "Using heroku-docker-r FTW"
  ```

* Deploy your application to Heroku, replacing `<branch>` with your branch. E.g. `master`.

  ```bash
  git push heroku <branch>
  ```

See [heroku-docker-r-shiny-app][18] for an example application.

### Plumber Applications

These steps are for [Plumber][17] applications.

In your Plumber application source's root directory:

* Create a `Dockerfile` file and insert the following content.

  ```
  FROM virtualstaticvoid/heroku-docker-r:plumber
  ENV PORT=8080
  CMD ["/usr/bin/R", "--no-save", "--gui-none", "-f /app/app.R"]
  ```

* Create a `heroku.yml` file and insert the following content.

  ```yaml
  build:
    docker:
      web: Dockerfile
  ```

* Commit the changes, using `git` as per usual.

  ```bash
  git add Dockerfile heroku.yml
  git commit -m "Using heroku-docker-r FTW"
  ```

* Deploy your application to Heroku, replacing `<branch>` with your branch. E.g. `master`.

  ```bash
  git push heroku <branch>
  ```

See [heroku-docker-r-plumber-app][19] for an example application.

### Other R Applications

These steps are for console and other types of R applications.

In your R application source's root directory:

* Create a `Dockerfile` file and insert the following content.

  ```
  FROM virtualstaticvoid/heroku-docker-r:build
  CMD ["/usr/bin/R", "--no-save", "-f /app/<R-program>"]
  ```

  Change `<R-program>` to the main R program you want to have executed. E.g. `app.R`.

* Create a `heroku.yml` file and insert the following content.

  ```yaml
  build:
    docker:
      service: Dockerfile
  ```

* Commit the changes, using `git` as per usual.

  ```bash
  git add Dockerfile heroku.yml
  git commit -m "Using heroku-docker-r FTW"
  ```

* Deploy your application to Heroku, replacing `<branch>` with your branch. E.g. `master`.

  ```bash
  git push heroku <branch>
  ```

### Applications with Additional Dependencies

For R applications which have additional dependencies, the `container` stack gives you much more flexibility with the [`Dockerfile`][10] than was previously available in the R buildpack;
such as for installing dependencies from other sources, from `deb` files or by compiling libraries from scratch, or using docker's [multi-stage builds][20].
It also provides greater control over the runtime directory layout and execution environment.

To make it easier for project authors to manage dependencies and provide backward compatibility with the [heroku-buildpack-r][5] without the need for Docker to be installed, the following functionality is provided:

* `init.R`

  Maintaining compatibility with the [heroku-buildpack-r][5], the `init.R` file is still supported and is used to install any R packages or config R as necessary.

  In addition, an R helper function, called `helper.installPackages` is provided to simplify installing R packages. The function takes a list of R package names to install.

  During the deployment process, the existence of the `./init.R` file will cause the script to be executed in R.

  E.g. This example installs the `gmp` R package.

  ```R
  # install additional packages, using helper function
  helpers.installPackages("gmp")
  ```

* `Aptfile`

  Create a text file, called `Aptfile` in your project's root directory, which contains the Ubuntu package names to install.

  During the deployment process, the existence of the `./Aptfile` file will cause the packages to be installed using `apt-get install ...`.

  E.g. This example `Aptfile` installs the GNU Multiple Precision Arithmetic library and supporting libraries.

  ```
  libgmp10
  libgmp3-dev
  libmpfr4
  libmpfr-dev
  ```

  This is based on the same technique as used by the [heroku-buildpack-apt][22] buildpack.

* `onbuild`

  Create a Bash script file, called `onbuild` in your project's root directory, containing the commands you need to install any dependencies, language runtimes and perform configuration tasks as needed.

  During the deployment process, the existence of the `./onbuild` file will cause it to be executed in Bash.

  E.g. This example `onbuild` file installs Ubuntu packages.

  ```bash
  #!/bin/bash
  set -e # fail fast

  # refresh package index
  apt-get update -q

  # install "packages"
  apt-get install -qy packages-names

  # reduce the image size by removing unnecessary Apt files
  apt-get autoclean
  ```

  NOTE: Change "packages-names" to the list of packages you wish to install.

  See [Java][examples-java], [Python][examples-python] and [Ruby][examples-ruby] for examples of using the `onbuild` Bash script.

* `packrat`

  If you want to install and manage R packages more reliably, you can use `packrat` to manage them. This is the recommended way to manage your R packages. Please see the [packrat][8] documentation for further details.

  During the deployment process, the existence of the `./packrat/init.R` file will cause Packrat to be bootstraped and the referenced packages installed.

  It is recommended to include a `.dockerignore` file in your project's root directory, in order to exclude unnecessary directories/files being included from the `packrat` subdirectory.

  E.g. Example `.dockerignore`

  ```
  packrat/lib*/
  ```

In each of the above mentioned examples, Docker's [`ONBUILD`][21] method is used to execute the step when the respective file is detected.

### Multi-Language Applications

For applications which use another language, such as Java, Python or Ruby to interface with R, the `container` stack gives you much more flexibility and control over the environment, however the onus is on the developer to configure the language stack within the docker container instead of with mulitple buildpacks.

In each example, the language runtime can be installed via the use of an `onbuild` Bash script, which must be in the root of the project directory, and which is invoked during the deployment process.

This shell script can run installations such as using `apt-get` for example, or any other commands to setup language support and perform configuration as needed.

There are of course many permutations possible, so some [examples][examples] are provided to help you get the idea:

* [Java][examples-java]

  The Java example installs the OpenJDK, configures R accordingly and compiles the project's Java source files.

* [Python][examples-python]

  In the Python example, the `onbuild` installs the Python runtime and installs the project dependenecies using `pip`.

* [Ruby][examples-ruby]

  The Ruby example installs the runtime and then installs the project dependencies using `bundler`.

## Existing R Applications

For R applications which use the [heroku-buildpack-r][5], this project provides backward compatibility so that you can continue to enjoy the benefit of using Heroku to deploy and run your application, without much change.

The process continues to use your `init.R` file in order to install any packages your application requires. Furthermore, the `Aptfile` continues to be supported in order to install additional binary dependencies.

It is worth nothing that use of [multiple buildpacks][12] is not supported _nor needed_ on the `container` stack, so you may have some rework to do if you made use of this feature.

Please see the [MIGRATING][9] guide for details on how to migrate your existing R application.

## Speeding Up Deploys

Since the container stack makes use of docker together with a [`Dockerfile`][10] to define the image, it is possible to speed up deployments by pre-building them.

**NOTE:** This requires having docker installed and an account on [Docker Hub][11] or other Heroku accessible container registry.

An example of how this is done can be found in the ["speedy"][examples-speedy] example application.

## Versions

The name for images published to DockerHub is [`virtualstaticvoid/heroku-docker-r`][16].

The following table lists the image tags for each Heroku stack and R version combination:

| Heroku Stack | R Version | Base Tag      | Build Tag     | Shiny Tag     | Plumber Tag     |
|--------------|-----------|---------------|---------------|---------------|-----------------|
| `heroku-18`  | 3.6.3     | `latest`      |`build`        | `shiny`       | `plumber`       |
| `heroku-18`  | 3.6.3     |               |`3.6.3-build`  | `3.6.3-shiny` | `3.6.3-plumber` |
| `heroku-18`  | 3.6.2     |               |`3.6.2-build`  | `3.6.2-shiny` |                 |
| `heroku-18`  | 3.5.2     |               |`3.5.2-build`  | `3.5.2-shiny` |                 |
| `heroku-16`  | 3.4.4     |               |`3.4.4-build`  | `3.4.4-shiny` |                 |

## Examples

The [examples][examples] repository contains various R applications which can be used as templates.

They illustrate usage of the docker image and the configuration necessary to deploy to Heroku.

* [Shiny][examples-shiny] - An example Shiny application
* [Plumber][examples-plumber] - An example Plumber application
* [Packrat][examples-packrat] - Illustrates using packrat
* [Python][examples-python] - Shows interoperability between Python and R
* [Java][examples-java] - Shows interoperability between Java and R
* [Ruby][examples-ruby] - Shows interoperability between Ruby and R

## License

MIT License. Copyright (c) 2018 Chris Stefano. See [MIT_LICENSE](MIT_LICENSE) for details.

## Additional Information

R is "GNU S", a freely available language and environment for statistical computing and graphics which provides a wide variety of statistical and graphical techniques: linear and nonlinear modelling, statistical tests, time series analysis, classification, clustering, etc. Please consult the [R project homepage][2] for further information.

[CRAN][3] is a network of FTP and Web Servers around the world that store identical, up-to-date, versions of code and documentation for R.

[1]: https://github.com/virtualstaticvoid/heroku-docker-r
[2]: http://www.r-project.org
[3]: http://cran.r-project.org
[4]: https://heroku.com
[5]: https://github.com/virtualstaticvoid/heroku-buildpack-r
[6]: https://devcenter.heroku.com/articles/heroku-yml-build-manifest
[7]: https://devcenter.heroku.com/articles/container-registry-and-runtime
[8]: http://rstudio.github.io/packrat
[9]: https://github.com/virtualstaticvoid/heroku-docker-r/blob/master/MIGRATING.md
[10]: https://docs.docker.com/engine/reference/builder
[11]: https://hub.docker.com
[12]: https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app
[13]: https://hub.docker.com/repository/docker/virtualstaticvoid/heroku-docker-r
[14]: https://shiny.rstudio.com
[15]: https://hub.docker.com/repository/heroku/heroku
[16]: https://hub.docker.com/repository/docker/virtualstaticvoid/heroku-docker-r/tags
[17]: https://www.rplumber.io
[18]: https://github.com/virtualstaticvoid/heroku-docker-r-shiny-app
[19]: https://github.com/virtualstaticvoid/heroku-docker-r-plumber-app
[20]: https://docs.docker.com/develop/develop-images/multistage-build
[21]: https://docs.docker.com/engine/reference/builder/#onbuild
[22]: https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-apt

[examples]: https://github.com/virtualstaticvoid/heroku-docker-r-examples
[examples-console]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/console
[examples-packrat]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/packrat
[examples-shiny]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/shiny
[examples-plumber]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/plumber
[examples-python]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/python
[examples-java]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/java
[examples-ruby]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/ruby
[examples-speedy]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/speedy
