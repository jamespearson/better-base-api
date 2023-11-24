# Base API Project

[![Code Climate](https://codeclimate.com/github/jamespearson/better-base-api.png)](https://codeclimate.com/github/jamespearson/better-base-api)
[![Ruby Code Style](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/standardrb/standard)

## Requirements

- Ruby 3.2.2 or above
- Postgres (~16)
- Redis

## Features

- Devise JWT for Authentication
- Rspec (with Shoulda and FactoryBot) for tests
- Capastrano for deployment
- StandardRB for linting
- UUID as the default Id.

## Configuation

### Credentials

Editing the credentials for the first time will create the `master.key` this should be stored in 1Password for developers on the project to share without having to commit it.

`EDITOR="code --wait" rails credentials:edit`

A sample credientials file can be found in `config/credentials.template.yml`

### Database

An initial user and user_roles setup is included, run:

`bundle exec rails db:create db:migrate`

### Deployment settings

Update the deploy file at config/deploy.rb with values as required:

- application: Set to the application name or project name
- repo_url: Set to the URL where your code is being stored, you can normally get this with `git remote -v`` and copy the URL of origin
- linked_files: Set to a list of files that should be shared and persisted over all releases, for e.g. `config/database.yml`, `config/master.key`, config/application.yml, etc. These files will not be deleted/reset in every release (other files will!!)

Update `config/deploy/staging.rb` and `config/deploy/production.rb` to meet your requirements.

### Extras

- Change the URL for the CodeClimate Badge in the ReadMe, letting CodeClimate review your PRs and code is encourged.
-

## Development

### User Roles

User roles are managed on the role by (role_model)[https://github.com/martinrehfeld/role_model]

### Serializers

All data presented to the user should go via (jsonapi-serializer)[https://github.com/jsonapi-serializer/jsonapi-serializer].

### Authentication, Policies and Scopes

All data access and permissions should be managed by Policy, and policy scopes using (Pundit)[https://github.com/varvet/pundit]

### History

Models can keep a change log by using [audited](https://github.com/collectiveidea/audited)

### Other

- This project defaults to using port 3001, so the front end can run on port 3000
