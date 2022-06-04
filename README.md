# Nightwind CLI

Manage your laravel project's docker compose setup with blade rendered template files.

## Introduction

`nightwind` is a part bash, part php CLI (via ephemeral docker container) for managing & running your laravel project's docker compose setup with [blade](https://laravel.com/docs/9.x/blade) rendered template files.

## Dependencies

- Bash 4.3 + (With tools: find|sed)
- Docker with [Composer v2](https://docs.docker.com/compose/cli-command/)

### Supported/Tested OS

- Linux
- Windows (WLS2/Ubuntu For Windows)

## Installation

Download specific tag/version and make available in $PATH:

```
# in ~/.bashrc or equivalent
PATH=/usr/local/bin/nightwind:$PATH
```

### Optionally source bash completion:

`source /usr/local/bin/nightwind/completions.bash`

## Getting Started

### Initialize Project

To initialize your project to use `nightwind`, run:

```bash
nightwind init 
```

This will generate some default template files for running a laravel application in docker with the following services: `php-fpm`, `nginx`, `redis` & `mysql`.

*Note* Subsequent calls to `nightwind init` will generate files only if they dont exist. `nightwind init --force` will force overwrite ALL existing files.

#### Customize Initial/Base Variables:
Before you move on to starting your docker services, you should then customize the values of `.nightwind/variables.json` to your liking or to your environment's requirements:

```js
{
    "domain": "app.test", // the domain/hostname of your app, should be changed to reflect env domain.
    "db_host_port": 3306, // the port your machine should use for mysql
    "redis_host_port": 6379, // the port your machine should use for redis
    "docker_user_uid": 1000,  // the linux user uid for the application dockerfile
    "docker_php_version": 8.1, // the php version for the application dockerfile
    "nginx_host_http_port": 80, // the port your machine should use for nginx http traffic
    "nginx_host_https_port": 443, // the port your machine should use for nginx https traffic
    "docker_username": "nightwind", // the linux username for the application dockerfile 
    "docker_tag_namespace": "nightwind" // tag namespace/prefix to use for tagging/naming docker resources, e.g image tag : <namespace>/web-server.
    "docker_ssl_directory": "/var/www/ssl" // the directory for local self signed certs or your project's ssl in docker container.    
}
```
You may add any custom variables as well, this file along with your `.env` will get converted to camel cased variable data when you run `nightwind render`. 

See render templates/template data section below for more.

#### Customize Templates

At this point, you can optionally review the `.nightwind/templates` files and tweak to your liking/needs. Make sure variables are referenced in camel case, match your needs, etc.


### Rendering Templates

Before starting your project docker services, you templates must be rendered.

To render templates, run `nightwind render`, before running review your variable data as documented below:

##### Template File Variable Data

There are 3 options for variable data:

1. Your `.nightwind/variables.json` file acts as the base variable data.
2. Your project's `.env` file which takes precedence  over your `variables.json` file.
3. Command line options when running `nightwind render`. Example: `nightwind render --app-env=production`


*NOTE* - Since command line options are often passed as kebab case and php does not support kebab cased variables, e.g `$app-env`, all variable data is converted to camel case. Therefore, if you define a variable in your `variables.json` or `.env` file as snake or kebab case, you will need to reference it as camel case in your template files.


### Up & Running

At this point, it is assumed your template files and `variables.json|.env` are to your liking, fit your env needs and reflect the requirements of your rendered in your `.nightwind/rendered/app.yaml` file.  When ready, you may start up services with:

```bash
# if ready to start up project otherwise review templates and make changes as needed before running:
nightwind up
```


**NOTE** You may add extra post start up commands via the `.nightwind/hooks/after_up` hook.

At this point, your docker services should be up and running, if you are in a local env, configure your hosts for local testing by adding an entry to your hosts file for local testing:

```
127.0.0.1 app.test # use your local domain if you provided one during `nightwind init`.

# Allow talking to the Docker host
192.168.1.72 host.docker.internal
192.168.1.72 gateway.docker.internal
```

### Help

`nightwind --help`

### Extending/Custom Commands


### Contributing

- Install [Bashly](https://bashly.dannyb.co/installation/) or run with docker.
- On new branch, add command/feature changes
- Regenerate CLI script from `src` using `bashly generate` or use `./dev` to watch for changes (via inotifytools) to automatically regenerate cli.
- Open Pull Request
- Collab Corp Discord (Will send invite as requested)

### Kudos

- Ascii Text For Logo - [https://fsymbols.com/generators/carty/](https://fsymbols.com/generators/carty/)
- [Bashly](https://bashly.dannyb.co/installation/) for feature rich bash cli generation.

