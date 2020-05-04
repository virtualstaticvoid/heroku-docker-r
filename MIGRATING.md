# Migrating Existing R Applications

This guide is for migrating existing R applications which make use of the [heroku-buildpack-r][1] on Heroku.

Follow these steps to migrate your R application to use the Heroku `container` stack.

**NOTE**: Docker *is not required* to be installed on your machine, unless you need to build and run the images locally. For the most common use cases, you will probably use the default setup, so it won't be necessary to have docker installed in that case.

## Shiny Applications

These steps are for [Shiny][2] applications.

In your R application source's root directory:

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

* Configure Heroku to use the `container` stack.

  ```bash
  heroku stack:set container
  ```

* Deploy your application to Heroku, replacing `<branch>` with your branch. E.g. `master`.

  ```bash
  git push heroku <branch>
  ```

## Other R Applications

These steps are for console and other types of R applications.

In your R application source's root directory:

* Create a `Dockerfile` file and insert the following content.

  ```
  FROM virtualstaticvoid/heroku-docker-r:build
  CMD "/usr/bin/R --no-save -f /app/<R-program>"
  ```

  Change `<R-program>` to be the main R program you want to have executed, or change it to just run the R console for interactive use. E.g. `CMD "/usr/bin/R --no-save"`.

* Create a `heroku.yml` file and insert the following content.

  ```yaml
  build:
    docker:
      app: Dockerfile
  ```

* Commit the changes, using `git` as per usual.

  ```bash
  git add Dockerfile heroku.yml
  git commit -m "Using heroku-docker-r FTW"
  ```

* Configure Heroku to use the `container` stack.

  ```bash
  heroku stack:set container
  ```

* Deploy your application to Heroku, replacing `<branch>` with your branch. E.g. `master`.

  ```bash
  git push heroku <branch>
  ```

## Multi-Buildpack Applications

For R applications which make use of [multiple buildpacks][5], this is not supported _nor needed_ on the `container` stack.

You will need to refactor your setup to include the components, which those buildpacks provided, in the `Dockerfile` if possible.

Details on this are out of the scope of this document, as there are too many permutations possible.

## Slug Compilation

During the slug compilation phase of the Heroku deploy on the `container` stack, you will notice that the build output is now different. It shows the docker build instructions and outputs as the image is being built.

During this phase your `init.R` file is executed, to typically install and configure any R packages you require, as it did before with the R buildpack.

If you have provided an `Aptfile` in your application directory then those packages will be installed during this process.

Furthermore, if you use [packrat][3] to manage your R package dependencies, then you can elect to do away with your `init.R` if all it was doing was installing packages :-).

This is an example of the output during compilation:

```
$ git push heroku master

Counting objects: 9, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (9/9), 2.17 KiB | 1.08 MiB/s, done.
Total 9 (delta 0), reused 0 (delta 0)
remote: Compressing source files... done.
remote: Building source:
remote: === Fetching app code
remote: Sending build context to Docker daemon  9.216kB
remote: Step 1/5 : FROM virtualstaticvoid/heroku-docker-r:build
remote: build: Pulling from virtualstaticvoid/heroku-docker-r
remote: d3938036b19c: Pulling fs layer
...
remote: 817da545be2b: Waiting
...
remote: a9b30c108bda: Verifying Checksum
remote: a9b30c108bda: Download complete
...
remote: d3938036b19c: Pull complete
...
remote: Digest: sha256:a88020addc2f8b80e674eb169e09c5b02bf1da169b6fcaef02b87b059fd38164
remote: Status: Downloaded newer image for virtualstaticvoid/heroku-docker-r:build
remote: # Executing build triggers...
...
remote: Step 1/1 : COPY . /app
remote: Step 1/1 : RUN if [ -f "/app/init.R" ]; then /usr/bin/R --no-init-file --no-save --quiet --slave -f /app/init.R; fi;
remote:  ---> Running in b8ec7dab059a
remote: Step 1/1 : RUN if [ -f "/app/packrat/init.R" ]; then /usr/bin/R --no-init-file --no-save --quiet --slave -f /app/packrat/init.R --args --bootstrap-packrat; fi;
remote:  ---> Running in f15cfb28f0c6
...
remote: Successfully built 9a5ca146f496
remote: Successfully tagged a4d0f4b97ebe88c0e65264081366350647bfc9b6:latest
remote: a0638673a463: Preparing
remote: 3d3996739656: Waiting
remote: 3f8b58dc539d: Pushed
remote: Verifying deploy... done.
To https://git.heroku.com/xyz-abc-12345.git
 * [new branch]      master -> master
```

## Troubleshooting

* If you are using a `Procfile`, then you will need to change the arguments to [`CMD`][4] directive in the `Dockerfile` to be the same as that in your `Procfile`. See the [Build Manifest][9] documentation for further details.
* Any `fakechroot` and `fakeroot` command prefixes are no longer needed and must be removed.
* The container's file system layout follows the same convention as that of the R buildpack, so your application files will be located in the `/app` directory.

[1]: https://github.com/virtualstaticvoid/heroku-buildpack-r
[2]: https://shiny.rstudio.com
[3]: http://rstudio.github.io/packrat
[4]: https://docs.docker.com/v17.09/engine/reference/builder/#cmd
[5]: https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app
[6]: https://docs.docker.com/engine/reference/builder
[7]: https://devcenter.heroku.com/articles/container-registry-and-runtime#unsupported-dockerfile-commands
[8]: https://docs.docker.com/develop/develop-images/multistage-build
[9]: https://devcenter.heroku.com/articles/heroku-yml-build-manifest#defining-the-process-to-run
[10]: https://cran.r-project.org/web/packages/gmp/index.html
