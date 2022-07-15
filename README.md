# Compiler Explore Dockerized

Compiler Explorer is an extremely useful tool for testing compiler and language features.
This repository helps dockerize compiler explorer and build docker volumes full of compilers and libraries.
The docker image is an empty instance of compiler explorer, containing no compilers.
A volume is mount when the docker image starts that has the compilers installed.

Compiler Explorer (the website code) is installed in `/compiler-explorer`.
This code comes from [compiler-explorer](https://github.com/compiler-explorer/compiler-explorer.git) git repository.
The compilers, libraries, and tools that compiler explorer uses in installed in `/opt/compiler-explorer`.
These are installed manually or by [infra](https://github.com/compiler-explorer/infra.git), an installed that pulls from the compiler explorer's repository of compilers and libraries.

Docker images and volumes are provided on dockerhub and github.
The steps for building your own image are provided below.


## Building Compiler Explorer Image

The Compiler Explorer image is built from `dockerfile.ce`.
This will install the prerequisits, the dependencies, and compiler explorer itself.
An argument can be provided to install a specific version of compiler explorer.
The version could be a commit or reference. The default is `main`.

The script `build.sh` is provided for convenience.
It will automatically tag the build as `compiler-explorer:latest` and `compiler-explorer:<commit>`.
The script also takes the argument for the commit and passes that to `docker build`.

```bash
$ ./build.sh <commit>
# or
$ docker build -t compiler-explorer --build-arg commit=<commit> .
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
```
$ docker run -d -p 10240:10240 --restart=on-failure -v compiler-explorer:/opt/compiler-explorer compiler-explorer
```

Compiler Explorer will start up at localhost on port 10240.
Go to https://localhost:10240.

