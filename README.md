# Docker Compose + WordPress

This is a quick and automated way to start WordPress.

## Requirements

- [docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/)

And various system tools
- [make](https://www.gnu.org/software/make/)
- awk
- gzip
- gunzip
- pv

## Quick start

### Generate environment file

Generate the environment file is the first step:

```
make generate-env
```

This will create a `default.env` containing required environment variables.

### Start

Start containers using the following command:

```
make start
```

### Stop

Stop containers by running:

```
make stop
```

This will leave data untouched in volumes.

### Clean

You don't want to play with WordPress any more, no prob, run:

```
make clean
```

This will remove containers and volumes.

## Advanced usages

You may use other environments name like `staging` or `production`.
Just append `-e stage=<stage>` to make commands.
See
[github.com/kmmndr/makefile-collection](https://github.com/kmmndr/makefile-collection)
for more informations about makefiles used here.

For example:

```
make -e stage=staging generate-env
make -e stage=staging start
```

For obvious security reason, if you want a better password than the one defined
by default. Create a file named `override.env` containing your variables. It
can be a simple text file or an executable file expected to print variables on
STDOUT.

Docker daemon is handy and simple, for more advanced usages use a real
container orchestrator like k8s.
