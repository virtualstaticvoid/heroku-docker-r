# Heroku R Docker Image

This is the docker image for applications which use [R][rproject] for statistical computing and [CRAN][cran] for R packages, running on [Heroku][heroku].

This project is compatible with the [heroku-buildpack-r][buildpackr] so that it is possible to migrate your existing Heroku R applications and deploy them using the new Heroku [`container`][container_stack] stack, however there are some caveats if multiple buildpacks were used together with [heroku-buildpack-r][buildpackr]. The new stack alleviates many of the complexities and issues with the R buildpack.

Supports the [packrat][packrat] and [renv][renv] package managers, and there are builds which include [Shiny][shiny] and [Plumber][plumber], tagged as [`shiny`][tagshiny] and [`plumber`][tagplumber] respectively.

The docker image source code and further instructions can be found at [github.com/virtualstaticvoid/heroku-docker-r][repo].

## License

MIT License. Copyright (c) 2018 Chris Stefano. See MIT_LICENSE for details.

[buildpackr]: https://github.com/virtualstaticvoid/heroku-buildpack-r
[container_stack]: https://devcenter.heroku.com/articles/container-registry-and-runtime
[cran]: http://cran.r-project.org
[dockerhub]: https://hub.docker.com/repository/docker/virtualstaticvoid/heroku-docker-r
[heroku]: https://heroku.com
[packrat]: http://rstudio.github.io/packrat
[plumber]: https://www.rplumber.io
[renv]: http://rstudio.github.io/renv
[repo]: https://github.com/virtualstaticvoid/heroku-docker-r
[rproject]: http://www.r-project.org
[shiny]: https://shiny.rstudio.com
[tagplumber]: https://hub.docker.com/r/virtualstaticvoid/heroku-docker-r/tags?page=1&name=plumber
[tagshiny]: https://hub.docker.com/r/virtualstaticvoid/heroku-docker-r/tags?page=1&name=shiny
[ubuntu]: https://hub.docker.com/repository/ubuntu
