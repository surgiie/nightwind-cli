# Nightwind CLI

A command-line interface for interacting, managing and running your Laravel docker compose projects with blade rendered templates.

## Dependencies

- Bash 4.3 + (With tools: find)
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

To initialize your project's template files, run `nightwind init`.

This will generate a `.nightwind` folder in the root directory of your laravel project.

This directory will contain some default template files for the following stack/features:

- php-fpm
- nginx
- redis
- mysql 
- local ssl self signed cert

The out of box defaults are tailored for a local environment that mimics a production like environment as much as possible, and of course can be completely changed to your liking.


*Note* `nightwind init` will generate files only if they dont already exist, `nightwind init --force` will force overwrite ALL existing files if you wish to re-initialize files.

#### Customize Variables:

Your first step before rendering your template files, should be to customize the values of `.nightwind/variables.json` to your liking or to your environment's requirements:

```js
{
    "domain": "app.local", // the domain/hostname of your app, should be changed to reflect env domain.
    "db_host_port": 3306, // the port your machine should use for mysql
    "redis_host_port": 6379, // the port your machine should use for redis
    "docker_user_uid": 1000,  // the linux user uid for the application dockerfile
    "docker_php_version": 8.1, // the php version for the application dockerfile
    "nginx_host_http_port": 80, // the port your machine should use for nginx http traffic
    "nginx_host_https_port": 443, // the port your machine should use for nginx https traffic
    "docker_username": "nightwind", // the linux username for the application dockerfile 
    "docker_tag_namespace": "nightwind", // tag namespace/prefix to use for tagging/naming docker resources, e.g image tag : <namespace>/web-server.
    "docker_ssl_directory": "/var/www/ssl" // the directory for local self signed certs or your project's ssl in docker container.    
}
```
You may add any custom variables as well, this file along with your `.env` will get converted to camel case variable data when you run `nightwind render`. 

See render templates/template data section below for more.

#### Env Setup

For your local environment, configure your hosts for local testing by adding an entry to your hosts file for local testing:

```
127.0.0.1 app.local # use domain as you defined in your variables.json

# Allow talking to the Docker host
192.168.1.72 host.docker.internal
192.168.1.72 gateway.docker.internal
```

For other environments, setup is of course at your discretion/needs.
#### Customize Templates

At this point, you can optionally review the `.nightwind/templates` files and tweak to your liking/needs. Make sure variables are referenced in camel case and match your needs.

**Note** All variables in your `variables.json` should be referenced in <strong>camel case</strong>. See template variable data section below for more.


#### Customize Hooks

You can optionally review the `.nightwind/hooks` files and tweak to your liking/needs. The current hooks scripts will automatically run if a script file for it exists in `.nightwind/hooks`


`.nightwind/hooks/before_up`  - Runs before `nightwind up` tasks are performed.
`.nightwind/hooks/after_up`  - Runs after `nightwind up` tasks are performed.
`.nightwind/hooks/before_down`  - Runs after `nightwind down` tasks are performed.
`.nightwind/hooks/after_down`  - Runs after `nightwind down` tasks are performed.

#### Rendering Templates

Before starting your project docker compose services, your templates must be rendered.

To render templates, run `nightwind render`. 

This will create a small docker image and run a ephemeral container to do the rendering in the php using the blade engine.

**Note*: By default the image is not removed after its done. If you are not planning to render your templates often, you can have it remove itself with `nightwind render --remove`
###### Template Variable Data

There are 3 options for variable data.

1. Your `.nightwind/variables.json` file acts as the base variable data.
2. Your project's `.env` file which takes precedence over your `variables.json` file. 
3. Command line options when running `nightwind render`. Example: `nightwind render --app-env=production`


*NOTE* - Since command line options are often passed as kebab case and php does not support kebab cased variables, e.g `$app-env`, all variable data is converted to camel case. Therefore, if you define a variable in your `variables.json` or `.env` file as snake or kebab case, you will need to reference it as camel case in your template files. e.g your `APP_ENV` .env value will be referenced as `$appEnv` in your template files.


### Up & Running
Out of the box, you should be able to get up and running locally with:

```bash
nightwind init
nightwind render
nightwind up
```

Otherwise at this point, it is assumed you:

- Customized `.nightwind/hooks` and `.nightwind/templates` to your liking/needs.
- Customized `variables.json` and `.env` to your templates needs.
- Rendered templates with `nightwind render` 

 When ready to start up things, you may do so with `nightwind up`


At this point, you should be able to load your laravel site at `https://<domain>`, where domain is the `domain` you provided in your `variables.json` and 
if env is local, the hostname/domain you configured in your hosts file.

### Contributing

- Install [Bashly](https://bashly.dannyb.co/installation/) or run with docker.
- On new branch, add command/feature changes
- Regenerate CLI script from `src` using `bashly generate` or using the docker `./generate` script.
- Open Pull Request

### Kudos

- Ascii Text For Logo - [https://fsymbols.com/generators/carty/](https://fsymbols.com/generators/carty/)
- [Bashly](https://bashly.dannyb.co/installation/) for feature rich bash cli generation.

