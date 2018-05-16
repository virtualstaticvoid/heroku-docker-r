# Migrating Existing R Applications

This guide is for migrating your existing R application which used the [heroku-buildpack-r][1] on Heroku.

Follow these steps to define the docker image and deployment configuration for your application.

## Shiny Applications

These steps are for [shiny][2] applications.

In your R application source's root directory:

* Create a `Dockerfile` file and insert the following content.

  ```
  FROM virtualstaticvoid/heroku-docker-r:3.4.4-shiny AS builder

  FROM virtualstaticvoid/heroku-docker-r:3.4.4
  COPY --from=builder /app /app
  ENV PORT=8080
  CMD "/usr/bin/R --no-save -f /app/run.R"
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

## Console Applications

These steps are for console based applications.

In your R application source's root directory:

* Create a `Dockerfile` file and insert the following content.

  ```
  FROM virtualstaticvoid/heroku-docker-r:3.4.4-build AS builder

  FROM virtualstaticvoid/heroku-docker-r:3.4.4
  COPY --from=builder /app /app
  CMD "/usr/bin/R --no-save -f /app/<your-R-program-filename>"
  ```

  Change `<your-R-program-filename>` to the main R program you want to have executed. E.g. `app.R`.

* Create a `heroku.yml` file and insert the following content.

  ```yaml
  build:
    docker:
      console: Dockerfile
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

These steps are for R applications which use [multiple buildpacks][5].

Unfortunately, use of multiple buildpacks is not supported _nor needed_ on the `container` stack.

You will therefore need to refactor your setup to include the additional language stacks you need by installing them in the `Dockerfile`.

This should be fairly straight forward, considering that most language stacks can be installed using `apt`.

* Create a `Dockerfile` file and insert the following content.

  ```
  FROM virtualstaticvoid/heroku-docker-r:3.4.4-build AS builder

  FROM virtualstaticvoid/heroku-docker-r:3.4.4
  COPY --from=builder /app /app

  RUN apt-get update -q \
   && apt-get install -qy \
     <package-list> \
   && rm -rf /var/lib/apt/lists/*

  CMD "/usr/bin/R --no-save -f /app/<your-R-program-filename>"
  ```

  Change `<package-list>` to include the binary dependencies you need to have installed, and `<your-R-program-filename>` to the main R program you want to have executed. E.g. `/app/app.R`.

  Checkout the [Dockerfile][6] reference for a complete list of directives available, nothing that not all are available as specified in the Heroku Container Registry and Runtime [documentation][7].

  Note that [multi-stage][8] docker builds are used to reduce the image file size produced, in order to speed up the slug deployments.

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

## Slug Compilation

During the slug compilation phase during a Heroku deploy with the `container` stack, you will notice that the build output is now different. It contains the docker build instructions and outputs as the image is being built.

Example output during deployment of a console application:

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
remote: Step 1/5 : FROM virtualstaticvoid/heroku-docker-r:3.4.4-build AS builder
remote: 3.4.4-build: Pulling from virtualstaticvoid/heroku-docker-r
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
remote: Status: Downloaded newer image for virtualstaticvoid/heroku-docker-r:3.4.4-build
remote: # Executing 3 build triggers...
remote: Step 1/1 : COPY . /app
remote: Step 1/1 : RUN if [ -f "/app/init.R" ]; then /usr/bin/R --no-init-file --no-save --quiet --slave -f /app/init.R; fi;
remote:  ---> Running in b8ec7dab059a
remote: Step 1/1 : RUN if [ -f "/app/packrat/init.R" ]; then /usr/bin/R --no-init-file --no-save --quiet --slave -f /app/packrat/init.R --args --bootstrap-packrat; fi;
remote:  ---> Running in f15cfb28f0c6
remote:  ---> 131fc9dcd338
remote: Removing intermediate container b8ec7dab059a
remote: Removing intermediate container f15cfb28f0c6
remote: Step 2/5 : LABEL "git.sha.heroku" "$SOURCE_VERSION"
remote:  ---> Running in 5d5ff681aae4
remote:  ---> 99984912d2ec
remote: Removing intermediate container 5d5ff681aae4
remote: Step 3/5 : FROM virtualstaticvoid/heroku-docker-r:3.4.4
remote: 3.4.4: Pulling from virtualstaticvoid/heroku-docker-r
remote: d3938036b19c: Already exists
...
remote: 5555fed98b2a: Pulling fs layer
...
remote: 4c2d49921cd9: Waiting
...
remote: d5d354d6b3ec: Download complete
remote: 5555fed98b2a: Verifying Checksum
...
remote: a58b50def5ab: Pull complete
remote: Digest: sha256:b915ea54e6b4eb6a4863ee0925ed450647e6c73eba043bf60b10799b56f5a9bc
remote: Status: Downloaded newer image for virtualstaticvoid/heroku-docker-r:3.4.4
remote:  ---> 7660ef22569b
remote: Step 4/5 : COPY --from=builder /app /app
remote:  ---> 57ec5452947d
remote: Step 5/5 : CMD /usr/bin/R --no-save -f /app/app.R
remote:  ---> Running in b545087bfe76
remote:  ---> 9a5ca146f496
remote: Removing intermediate container b545087bfe76
remote: [Warning] One or more build-args [SOURCE_VERSION] were not consumed
remote: Successfully built 9a5ca146f496
remote: Successfully tagged a4d0f4b97ebe88c0e65264081366350647bfc9b6:latest
remote: Login Succeeded
remote: Tagged image "a4d0f4b97ebe88c0e65264081366350647bfc9b6" as "registry.heroku.com/xyz-abc-12345/console" The push refers to a repository [registry.heroku.com/xyz-abc-12345/console]
remote: a0638673a463: Preparing
...
remote: 3d3996739656: Waiting
...
remote: 3f8b58dc539d: Pushed
...
remote: latest: digest: sha256:5657f285ae8a39f9995af3ec89dc9431e49718bc2e43259259525a6f3d5a619f size: 2615
remote: Verifying deploy... done.
To https://git.heroku.com/xyz-abc-12345.git
 * [new branch]      master -> master
```

During this phase your `init.R` file will be executed, which typically installs and configures any R packages you require, as before with the buildpack.

If you have provided an `Aptfile` in your application directory then those packages will be installed during this process.

Furthermore, if you use [packrat][3] to manage your R package dependencies, then you can elect to do away with your `init.R` if all it was doing was installing packages.

## Troubleshooting

* If you are using a `Procfile`, then you will need to change the arguments to [`CMD`][4] directive in the `Dockerfile` to be the same as that in your `Procfile`.
* Any `fakechroot` and `fakeroot` command prefixes are no longer needed and must be removed.
* The container's file system layout follows the same convention as that of the buildpack, so your application files are located in the `/app` directory.

[1]: https://github.com/virtualstaticvoid/heroku-buildpack-r
[2]: https://shiny.rstudio.com
[3]: http://rstudio.github.io/packrat
[4]: https://docs.docker.com/v17.09/engine/reference/builder/#cmd
[5]: https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app
[6]: https://docs.docker.com/engine/reference/builder
[7]: https://devcenter.heroku.com/articles/container-registry-and-runtime#unsupported-dockerfile-commands
[8]: https://docs.docker.com/develop/develop-images/multistage-build
