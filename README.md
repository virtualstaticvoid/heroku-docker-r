# Heroku R Docker Image

This is the docker image for applications which use [R][2] for statistical computing and [CRAN][3] for R packages, running on [Heroku][4].

This project aims to provide compatibility with the [heroku-buildpack-r][5] so that it is possible to simply add 2 new files to your existing R applications and deploy using the new [`container`][7] stack.

It introduces support for [packrat][8], which is a dependency manager for R packages.

The docker image source code can be found at [https://github.com/virtualstaticvoid/heroku-docker-r][1].

## Usage

### New R Applications

_TO BE COMPLETED_

### Existing R Applications

See the [migrating][9] guide for details on how to migrate your existing R application.

## Speeding Up Deploys

_TO BE COMPLETED_

## Examples

The following example applications can be used as templates for your R applications. They illustrate usage of this docker image and the configuration necessary to deploy to Heroku.

* [Simple R console][console] application
* [R with Packrat][packrat]
* [Shiny][shiny] application
* [R and Python][python] application
* [R and Java][java] application
* [R and Ruby][ruby] application

## License

MIT License. Copyright (c) 2018 Chris Stefano. See MIT_LICENSE for details.

## Additional Information

R is "GNU S", a freely available language and environment for statistical computing and graphics which provides a wide variety of statistical and graphical techniques: linear and nonlinear modelling, statistical tests, time series analysis, classification, clustering, etc. Please consult the [R project homepage][2] for further information.

[CRAN][3] is a network of ftp and web servers around the world that store identical, up-to-date, versions of code and documentation for R.

[1]: https://github.com/virtualstaticvoid/heroku-docker-r
[2]: http://www.r-project.org
[3]: http://cran.r-project.org
[4]: https://heroku.com
[5]: https://github.com/virtualstaticvoid/heroku-buildpack-r
[6]: https://devcenter.heroku.com/articles/heroku-yml-build-manifest
[7]: https://devcenter.heroku.com/articles/container-registry-and-runtime
[8]: http://rstudio.github.io/packrat
[9]: https://github.com/virtualstaticvoid/heroku-docker-r/blob/master/MIGRATING.md

[console]: https://github.com/virtualstaticvoid/heroku-docker-r-console
[packrat]: https://github.com/virtualstaticvoid/heroku-docker-r-packrat
[shiny]: https://github.com/virtualstaticvoid/heroku-docker-r-shiny
[python]: https://github.com/virtualstaticvoid/heroku-docker-r-python
[java]: https://github.com/virtualstaticvoid/heroku-docker-r-java
[ruby]: https://github.com/virtualstaticvoid/heroku-docker-r-ruby
