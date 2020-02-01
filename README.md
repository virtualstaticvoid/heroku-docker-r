# Heroku R Docker Image

[![Build Status](https://travis-ci.org/virtualstaticvoid/heroku-docker-r.svg?branch=master)](https://travis-ci.org/virtualstaticvoid/heroku-docker-r)
[![](https://images.microbadger.com/badges/version/virtualstaticvoid/heroku-docker-r.svg)](https://microbadger.com/images/virtualstaticvoid/heroku-docker-r)
[![](https://images.microbadger.com/badges/image/virtualstaticvoid/heroku-docker-r.svg)](https://microbadger.com/images/virtualstaticvoid/heroku-docker-r)

This is the docker image for applications which use [R][2] for statistical computing and [CRAN][3] for R packages, running on [Heroku][4].

This project is compatible with the [heroku-buildpack-r][5] so that it is possible to migrate your existing Heroku R applications and deploy them using the new Heroku [`container`][7] stack, however there are some caveats if multiple buildpacks were used together with [heroku-buildpack-r][5].

The new stack alleviates many of the complexities and issues with the R buildpack.

Support has been added for [packrat][8], which is a package dependency manager.

Pre-built docker images are published to [DockerHub][13], and are based off the [heroku/heroku:16][15] docker image to ensure compatibility for existing R applications which run on the `heroku-16` stack.

**NOTE**: Docker *is not required* to be installed on your machine, unless you need to build and run the images locally. For the most common use cases, you will probably use the default setup, so it won't be necessary to have docker installed.

## Usage

### New R Applications

Run `heroku create --stack=container` from your R application source's root directory to create a [container based][7] application on Heroku.

#### Shiny Applications

These steps are for [Shiny][14] applications.

In your R application source's root directory:

* Create a `Dockerfile` file and insert the following content.

  ```
  FROM virtualstaticvoid/heroku-docker-r:shiny
  ENV PORT=8080
  CMD "/usr/bin/R --no-save -f /app/run.R"
  ```

* Create a `heroku.yml` file and insert the following content.

  ```yaml
  build:
    docker:
      web: Dockerfile
  ```

* Optionally, if you need to install additional R packages, you can use `packrat` to manage them.

  This is the recommended way to manage your R packages. Please see the [packrat][8] documentation for details.

* Commit the changes, using `git` as per usual.

  ```bash
  git add Dockerfile heroku.yml
  git commit -m "Using heroku-docker-r FTW"
  ```

* Deploy your application to Heroku, replacing `<branch>` with your branch. E.g. `master`.

  ```bash
  git push heroku <branch>
  ```

#### Other R Applications

These steps are for console and other types of R applications.

In your R application source's root directory:

* Create a `Dockerfile` file and insert the following content.

  ```
  FROM virtualstaticvoid/heroku-docker-r:build
  CMD "/usr/bin/R --no-save -f /app/<R-program>"
  ```

  Change `<R-program>` to the main R program you want to have executed. E.g. `app.R`.

* Create a `heroku.yml` file and insert the following content.

  ```yaml
  build:
    docker:
      service: Dockerfile
  ```

* Optionally, if you need to install additional R packages, you can use `packrat` to manage them.

  This is the recommended way to manage your R packages. Please see the [packrat][8] documentation for details.

* Commit the changes, using `git` as per usual.

  ```bash
  git add Dockerfile heroku.yml
  git commit -m "Using heroku-docker-r FTW"
  ```

* Deploy your application to Heroku, replacing `<branch>` with your branch. E.g. `master`.

  ```bash
  git push heroku <branch>
  ```

#### Applications with Additional Dependencies

For R applications which have additional dependencies, the `container` stack gives you much more flexibility with the [`Dockerfile`][10] than was previously available in the R buildpack; such as for installing dependencies from other sources, from `deb` files or by compiling libraries from scratch. It also provides greater control over the runtime directory layout and execution environment.

_TO BE COMPLETED_

#### Multi-Language Applications

For applications which use another language, such as Python or Java, to interface with R, the `container` stack gives you much more flexibility and control over the environment, however the onus is now on the developer to configure the language stack within the docker container instead of with mulitple buildpacks.

This is out of the scope for this document, since there are too many permutations possible, however some [examples][examples] are provided to help you get the idea.

### Existing R Applications

For R applications which use the [heroku-buildpack-r][5], this project provides backward compatibility so that you can continue to enjoy the benefit of using Heroku to deploy and run your application, without much change.

The process continues to use your `init.R` file in order to install any packages your application requires. Furthermore, the `Aptfile` continues to be supported in order to install additional binary dependencies.

It is worth nothing that use of [multiple buildpacks][12] is not supported _nor needed_ on the `container` stack, so you may have some rework to do if you made use of this feature.

Please see the [MIGRATING][9] guide for details on how to migrate your existing R application.

### Speeding Up Deploys

Since the container stack makes use of docker together with a [`Dockerfile`][10] to define the image, it is possible to speed up deployments by pre-building them. This requires having docker installed and an account on [Docker Hub][11] or other Heroku accessible container registry.

An example of how this is done can be found in the [virtualstaticvoid/heroku-docker-r-examples][examples-speedy] repository.

## Versions

The following table lists the docker image tags for each Heroku stack and R version combination:

| Heroku Stack | R Version | Build Tag                                     | Shiny Tag                                     |
|--------------|-----------|-----------------------------------------------|-----------------------------------------------|
| `heroku-16`  | 3.4.4     | virtualstaticvoid/heroku-docker-r:3.4.4-build | virtualstaticvoid/heroku-docker-r:3.4.4-shiny |
| `heroku-18`  | 3.5.2     | virtualstaticvoid/heroku-docker-r:3.5.2-build | virtualstaticvoid/heroku-docker-r:3.5.2-shiny |
| `heroku-18`  | 3.5.2     | virtualstaticvoid/heroku-docker-r:build       | virtualstaticvoid/heroku-docker-r:shiny       |

## Examples

The [examples][examples] repository contains various R applications which can be used as templates. They illustrate usage of the docker image and the configuration necessary to deploy to Heroku.

* [Shiny][examples-shiny] - An example Shiny application
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

[examples]: https://github.com/virtualstaticvoid/heroku-docker-r-examples
[examples-console]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/console
[examples-packrat]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/packrat
[examples-shiny]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/shiny
[examples-python]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/python
[examples-java]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/java
[examples-ruby]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/ruby
[examples-speedy]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/tree/master/speedy
