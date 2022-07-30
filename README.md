# Compiler Explore Dockerized

Compiler Explorer is an extremely useful tool for testing compiler and language features.
This repository helps dockerize compiler explorer and build docker volumes full of compilers and libraries.
The docker image is an empty instance of compiler explorer, containing no compilers.
The docker volume is mounted when the docker image starts, and it has the compilers and libraries installed.

Compiler Explorer (the website code) is installed in `/compiler-explorer`.
This code comes from [compiler-explorer](https://github.com/compiler-explorer/compiler-explorer.git) git repository.
The compilers, libraries, and tools that compiler explorer uses is installed in `/opt/compiler-explorer`.
These are installed manually or by [infra](https://github.com/compiler-explorer/infra.git), an installer that pulls from the compiler explorer's repository of compilers and libraries.

Images for each release of compiler-explore can be found at [compiler-explorer-docker](https://hub.docker.com/repository/docker/tylerhx111/compiler-explorer).
The following docker command will fetch the most recent version or a specific version of the compiler explorer image.
```bash
$ docker pull ghcr.io/tylerh111/compiler-explorer
$ docker pull ghcr.io/tylerh111/compiler-explorer:<tag>
```

Docker images and volumes are provided on dockerhub and github.
The steps for building your own image are provided below.


## Building Compiler Explorer Image

The Compiler Explorer image is built from `dockerfile.ce`.
This will install the prerequisits, the dependencies, and compiler explorer itself.
An argument can be provided to install a specific version of compiler explorer.
The version could be a commit or reference. The default is `main`.

The script `build_ce.sh` is provided for convenience.
It will automatically tag the build as `compiler-explorer:latest` and `compiler-explorer:<commit>`.
The script also takes the argument for the commit and passes that to `docker build`.

```bash
$ ./build_ce.sh [commit]
# or
$ docker build -f dockerfile.ce -t compiler-explorer:<commit> --build-arg commit=<commit> .
$ docker tag compiler-explorer:<commit> compiler-explorer:latest
```

## Building Compiler Explorer Volume

As mentioned before, the image is empty, i.e. it does not contain any compilers.
Compiler Explorer is flexible to allow compilers to be installed anywhere.
This is because the config files are located in `/compiler-explorer/etc/config`.
Instead of hardcoding configurations in the image, the image creates a symbolic link to `/opt/compiler-explorer/config`.
Compilers and libraries can be installed manually or by infra.

Everything (besides the website) can be installed in `/opt/compiler-explorer`.
A volume can be created with all the compilers, libraries, tools, and their configuration.
Then it can be mounted at `/opt/compiler-explorer`.

First create the volume.
This will create a volume called `compiler-explorer`.
```
$ docker volume create compiler-explorer
```

Then, run a docker container and mount both this repository and the `compiler-explorer` volume.
```
$ docker run -it --rm -v compiler-explorer:/opt/compiler-explorer ubuntu:20.04 /bin/bash
```

Finally, install compilers and libraries.
All compilers and libraries should be installed somewhere in `/opt/compiler-explorer`.
Manually installing compilers and libraries is simplest.

Remember to add the config files under `/opt/compiler-explorer/config`.
Use the files in `config` or `compiler-explorer/etc/config` directory as an example.


## Starting Compiler Explorer

Once the image is built and the volume is full of compilers, use the following command to start compiler explorer.
```bash
$ ./run_ce.sh [tag] [volume]
# or
$ docker run -d -p 10240:10240 --restart=on-failure -v compiler-explorer:/opt/compiler-explorer compiler-explorer
```

Compiler Explorer will start up at localhost on port 10240.
Go to https://localhost:10240.

