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

`source /path/to/where/you/put/this/completions.bash`

## Getting Started

### Initialize Project

To initialize your project to use `nightwind`, run:

```bash
nightwind init 
```

This will generate some default template files for running a laravel application in docker with the following services: `php-fpm`, `nginx`, `redis` & `mysql`.

#### Customize Initial Variables:
Before you move on to starting your docker services, you should then customize the values of `.nightwind/variables.json` to your liking or to your environment's requirements & add custom variables:

```js
{
    "env": "local", // your apps environment
    "domain": "app.test", // the domain/hostname of your app, should be changed to reflect env domain.
    "db_host_port": 3306, // the port your machine should use for mysql
    "redis_host_port": 6379, // the port your machine should use for redis
    "docker_user_uid": 1000,  // the linux user uid for the application dockerfile
    "docker_php_version": 8.1, // the php version for the application dockerfile
    "nginx_host_http_port": 80, // the port your machine should use for nginx http traffic
    "nginx_host_https_port": 443, // the port your machine should use for nginx https traffic
    "docker_username": "nightwind", // the linux username for the application dockerfile 
    "docker_tag_namespace": "nightwind" // tag namespace to use for tagging/naming docker resources, e.g image tag : <namespace>/web-server.
}
```

**Note** - Key naming convention can be whatever format you prefer, but variable reference should be camel case. See template data section for more.
#### Customize Templates

At this point, you can optionally review the `.nightwind/templates` files and tweak to your liking/needs.


### Start Docker Services
#### Render Templates

<!-- 

Before starting project services, you will want to render your files from your available `.nightwind/templates` files for your docker setup to use. This can be done
with the `nightwind render` command. This will create a small docker image `nightwind/renderer` and run a small script to generate your available
`.nightwind/templates` files in `.nightwind/rendered`. You may add any files here as needed with the filename in the following format: `your-filename.<extension>.blade`.

At this point, review `.nightwind/rendered` files and be sure you are happy with your rendered setup, otherwise customize templates and re-render.

##### Template Data

To edit the template data for your templates, add key/value pairs to your `.nightwind/variables.yaml` file.

These key value pairs will used during rendering for variables. In addition to this file, your project's `.env` file is also used for variable data.

As an example,`{{ $APP_ENV }}` can be used wihout having to duplicate your application's env value in both the `.env` and the `.nightwind/variables.yaml`.

See [Blade](https://laravel.com/docs/9.x/blade) for docs on templating specific syntax/features.

### Template Partials/Includes

You may use the `@include` directive to include partial files, however as a heads up, a `@include` directive will include the content of the file as is,
so all formatting of that file will be preserved and you should structure those files accordingly if you are including the them in files
that have formatting/semantical requirements. For example

This include file (template-example.yaml):

```yaml
    something: foo
       foo: bar
```

used in this manner:

```yaml
name: Bob
@include('template-example.yaml') # this will embedd the content of the file as is so if you have tabs and specific formatting, it will be preserved
```

Would result in a rendered file in this structure:

```
name: Bob
    something: foo
        foo: bar

```

#### Local Setup

If in local env, remember to configure hosts for local testing by adding an entry to your hosts file for local testing:

```
127.0.0.1 app.test # use your local domain if you provided one during `nightwind init`.

# Allow talking to the Docker host
192.168.1.72 host.docker.internal
192.168.1.72 gateway.docker.internal
```

### Production Setup

At your discretion to make necessary changes to your templates as out of box templates are designed mostly for a local env, but some general tips:

- Be sure `variables.yaml` are to your liking and match what your production env expects, for example `domain` should be your actual site's domain.
- Make sure your templates contain any production specific needs as well.

### Up & Running

At this point, it is assumed your template files and `variables.yaml` are to your liking or fit your env needs and you have rendered your template files
, it is a good idea to review your rendered files to make sure it has rendered to your expectations, and that your env/connection
settings match your docker setup. When ready, you may start up services with:

```bash
# if ready to start up project otherwise review templates and make changes as needed before running:
nightwind up
```

Then your usual starting commands:

```
nightwind composer install
nightwind artisan migrate

```

_Note_ Your usual starting commands could be done via the `.nightwind/rendered/hooks/after_up` hook, which is what is generated by default by `nightwind init`

### Help

`nightwind --help`

### Extending/Custom Commands

`nightwind` is extensible via [Bashly](https://bashly.dannyb.co/configuration/command/) by adding your command yaml files to `~/.nightwind/commands` and
utilizing symlinks to have bashly include your scripts when rebuilding the cli. As an example, lets add a `myscript`:

1. Create a custom command yaml definition file as documented in bashly docs in `~/.nightwind/commands/myscript`.
2. This file should contain a custom filename so that bashly generates a file for it in directory you can symlink to. `filename: custom/myscript`
3. Symlink a directory to this location so you can manage your script files: `ln -s /usr/local/bin/nightwind/src/custom ~/.nightwind/custom`
4. Run `nightwind extend`
5. Write the logic for your script in `~/.nightwind/custom/myscript` and re-run `nightwind extend` after making changes.
6. You should be able to call your `nightwind myscript` command.

**Note:** That this will create a docker image for `bashly` to regnerate the cli in a emphemeral container. You may consider running `docker system prune`
or remove the image if you are not going to be regenerating the cli often.

**Note** You may also use this method of writing custom commands if you dont wish to use symlinks: [Embed YAML definition alongside bash code](https://bashly.dannyb.co/advanced/split-config/#download-command-sh)

### Contributing

- Install [Bashly](https://bashly.dannyb.co/installation/) or run with docker.
- On new branch, add command/feature changes
- Regenerate CLI script from `src` using `bashly generate` or use `./dev` to watch for changes (via inotifytools) to automatically regenerate cli.
- Open Pull Request
- Collab Corp Discord (Will send invite as requested)

### Kudos

- Ascii Text For Logo - [https://fsymbols.com/generators/carty/](https://fsymbols.com/generators/carty/)
- [Bashly](https://bashly.dannyb.co/installation/) for feature rich bash cli generation. -->
