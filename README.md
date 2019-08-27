[![Build Status](https://travis-ci.org/ServiceInnovationLab/feijoa.svg?branch=master)](https://travis-ci.org/ServiceInnovationLab/feijoa)
[![Maintainability](https://api.codeclimate.com/v1/badges/8f2b6efc2000ad726fd2/maintainability)](https://codeclimate.com/github/ServiceInnovationLab/feijoa/maintainability)

# Feijoa

## Overview
A Rails web app to demonstrate consent management

## Environments
**Environment** | **URL**  | **Git Branch**
---    | ---                                | ---    |
production | https://feijoa.herokuapp.com/ | master |
staging | https://feijoa-staging.herokuapp.com/ | staging |


## Project Resources

**Resource** | **URL**
---     | ---
Backlog | https://trello.com/b/1XoN2WJT/yeah-nah-feijoa
CI      | https://travis-ci.org/ServiceInnovationLab/feijoa

**Role(s)** | **Name(s)**
---        | ---
Team       | Yeah Nah / Feijoa
Developers | [Brenda Wallace](https://github.com/Br3nda), [Lyall Morrison](https://github.com/lamorrison)
Designers |
Testers | [Merridy Marshall](https://github.com/merridy)
Project Manager |
Product Owner |

## Comms
Slack: LabPlus-team #feijoa

## Setup

### Development
In the application directory:

Make a copy of the example environment file containing some important settings

```
> cp example.env .env
```

Install bundler 1.x if required
```
> gem install bundler -v 1.17.3
```

[Install Elastic search](https://www.elastic.co/downloads/elasticsearch) On ubuntu you can use the same script as travis-ci
```
ELASTIC_SEARCH_VERSION="6.2.3" ./bin/install_elasticsearch.sh
```

Install Rails dependencies and create local databases
```
> bin/setup
```

Start a local server
```
> bundle exec rails server
```

## Testing

### Rubocop
```
> rubocop
```

### Rspec
```
> bundle exec rspec
```

Test coverage is reported to `coverage/index.html`

## Gems

### [Administrate](https://github.com/thoughtbot/administrate)
 > Administrate is a library for Rails apps that automatically generates admin
 > dashboards. Administrate's admin dashboards give non-technical users clean
 > interfaces that allow them to create, edit, search, and delete records for
 > any model in the application.

The _Administrate_ dashboards are available at `/admin/` for `admin_user`s.

The gem is hard coded to use the `/admin/` route which created a conflict with the controllers for the `admin` account type. We resolved this by renaming the `admin` account type to `admin_user` so all those routes are `/admin_user/*`.

Dashboards must be explicitly generated for new models. There is a generator, `rails generate administrate:dashboard Foo`, or see the project documentation for further details. Be aware that the auto-generated dashboards will expose the (encrypted) passwords for users unless you remove those fields from the generated views manually.

You will also need to add new dashboards to `routes.rb`, which will also allow them to appear in the auto-generated navigation. For example:
```
namespace :admin do
  resources :users
  resources :admin_users
  resources :birth_records
  resources :shares
  resources :organisations
  resources :organisation_members
  
  root to: 'birth_records#index'
end
```
