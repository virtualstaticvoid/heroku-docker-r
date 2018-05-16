# Heroku R Docker Image

This is the docker image for applications which use [R][2] for statistical computing and [CRAN][3] for R packages, running on [Heroku][4].

This project is compatible with the [heroku-buildpack-r][5] so that it is possible to migrate your existing Heroku R applications and deploy them using the new Heroku [`container`][7] stack.

This new stack alleviates the complexities and many of the issues with the R buildpack, so it is now the recommended way to deploy R applications to Heroku.

It also introduces support for [packrat][8], which is a package dependency manager.

The docker image source code can be found at [https://github.com/virtualstaticvoid/heroku-docker-r][1].

## Usage

### New R Applications

_TO BE COMPLETED_

### Existing R Applications

The process continues to use your `init.R` file in order to install any packages your application requires. Furthermore, the `Aptfile` continues to be supported in order to install additional binary dependencies.

It is worth nothing that use of [multiple buildpacks][12] is not supported _nor needed_ on the `container` stack, so you may have some rework to do if you made use of this feature.

See the [migrating][9] guide for details on how to migrate your existing R application.

## Examples

The [examples][examples] repository contains various R applications which can be used as templates. They illustrate usage of the docker image and the configuration necessary to deploy to Heroku.

* [Console][examples-console] - A simple console based R application
* [Packrat][examples-packrat] - Illustrates using packrat
* [Shiny][examples-shiny] - An example Shiny application
* [Python][examples-python] - Shows interoperability between Python and R
* [Java][examples-java] - Shows interoperability between Java and R
* [Ruby][examples-ruby] - Shows interoperability between Ruby and R

### Speeding Up Deploys

Since the container stack makes use of docker together with a [`Dockerfile`][10] to define the image (thus the runtime slug), it is possible to speed up deployments by pre-building these images. This requires having docker installed and an account on [Docker Hub][11] (or any Heroku accessible container registry) in order to deploy them.

An example of how this is done is in the [virtualstaticvoid/heroku-docker-r-examples][examples-speedy] repository.

Additionally, the [`Dockerfile`][10] provides a great deal of flexibility which was not available with the R buildpack, such as installing binary dependencies and having greater control over the runtime environment.

## License

MIT License. Copyright (c) 2018 Chris Stefano. See MIT_LICENSE for details.

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

[examples]: https://github.com/virtualstaticvoid/heroku-docker-r-examples
[examples-console]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/console
[examples-packrat]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/packrat
[examples-shiny]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/shiny
[examples-python]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/python
[examples-java]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/java
[examples-ruby]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/ruby
[examples-speedy]: https://github.com/virtualstaticvoid/heroku-docker-r-examples/speedy
