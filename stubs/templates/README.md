## Templates Directories

### compose directory

Your project's docker compose yaml files should go here.


- `nightwind` will apply the `app.yaml` file first before applying any other yaml. Think of this file as the base file.
- `nightwind` will also apply yaml file for a specific env only if you name the file `<environment>.env.yaml` where `<environment>` is the value of your app's `APP_ENV` value.

### dockerfiles directory

Your project's dockerfiles should go here.

- `nightwind` expects filenames in this format: `<service>.Dockerfile` where `<service>` corresponds to one your service names in your yaml files. 

Ex: `database.Dockerfile` would correspond to the `database:` service in one of your docker compose yaml files.


### entrypoints directory

Your project's dockerfiles bash entry points should go here. 

- `nightwind` does not require this structure/directory but extracted out of box for customizing startup logic.


### hooks directory

There are points in execution of nightwind commands you can write custom scripts for, currently those are:

#### Before Up

Executed before `nightwind up` starts doing anything. File: `.nightwind/rendered/hooks/before_up`

#### After Up

Executed after `nightwind up` starts services (successfully). File: `.nightwind/rendered/hooks/after_up`



### web-server directory

Not required, but structured this way out of the box for your project's nginx configurations/files.



**Note:** Every other root file is not required but provided simply as a sensible default, feel free to customize to your liking :) 
