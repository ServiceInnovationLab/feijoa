# Feijoa

[![Build Status](https://travis-ci.org/ServiceInnovationLab/feijoa.svg?branch=master)](https://travis-ci.org/ServiceInnovationLab/feijoa)
[![Maintainability](https://api.codeclimate.com/v1/badges/8f2b6efc2000ad726fd2/maintainability)](https://codeclimate.com/github/ServiceInnovationLab/feijoa/maintainability)

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
Backlog | [https://trello.com/b/1XoN2WJT/yeah-nah-feijoa](https://trello.com/b/1XoN2WJT/yeah-nah-feijoa)
CI      | [https://travis-ci.org/ServiceInnovationLab/feijoa](https://travis-ci.org/ServiceInnovationLab/feijoa)

**Role(s)** | **Name(s)**
---        | ---
Team       | Yeah Nah / Feijoa
Developers | [@br3nda](https://github.com/Br3nda), [@lamorrison](https://github.com/lamorrison), [@mermop](https://github.com/mermop), [@JacOng17](https://github.com/JacOng17)
Designers | [@rosspatel01](https://github.com/rosspatel01)
Testers |
Scrum Master | [@merridy](https://github.com/merridy)
Product Owner | [@workbygrant](https://github.com/workbygrant)

## Comms

Slack: LabPlus-team #feijoa

## Setup

### Development

In the application directory:

**1. Install Rails dependencies and create local databases**

```sh
> bin/setup
```

**2. [Install and run Elastic search](https://www.elastic.co/downloads/elasticsearch).**
By default this is expected to run on localhost:9200 - if you have ElasticSearch running on a different port, you can change `ELASTICSEARCH_URL` in your `.env` file.

On Ubuntu you can use the same script as Travis CI:

```sh
ELASTIC_SEARCH_VERSION="6.2.3" ./bin/install_elasticsearch.sh
```

On Mac you may want to use Homebrew:

```sh
brew install elasticsearch
brew services start elasticsearch
```

**3. Create a search index in Elastic Search**

```sh
bundle exec rake search:index
```

*If you come across an `[FORBIDDEN/12/index read-only / allow delete (api)]` error:*

```sh
curl -XPUT -H "Content-Type: application/json" http://localhost:9200/_all/_settings -d '{"index.blocks.read_only_allow_delete": null}'

```

**4. Start a local server**

```sh
bundle exec rails server
```

## Local data

You can import organisations

```sh
bundle exec rake import:ece
bundle exec rake import:schools
bundle exec rake import:tkkm
```

You will need to build an ElasticSearch index for the new organisations:
`bundle exec rake search:index`

## Testing

### Rubocop

```sh
rubocop
```

### Rspec

```sh
bundle exec rspec
```

Test coverage is reported to `~/<FILEPATH>/coverage/index.html`

---

## Setting up local users

In the `seeds.rb` file, feel free to add or remove users.

To display them:

```rails
User.all
```

To find a partiular user:

```rails
User.find(<id of the user you want to find>)
```

To select a particular user, give them a variable to hold their data:

```rails
u = User.find(<id of the user you want to find>)
```

To add information/data to the user's fields (you can find out what's available in `db/schema.rb`) & save:

**For example:**

```rails
u.password = "123456789"
u.save
```

To connect the user with an organisation:

```rails
O.add_admin(u)
```

## Setting up organisations

To display them:

```rails
Organisation.all
```

To find a partiular organisation:

```rails
Organisation.find(<id of the organisation you want to find>)
```

To select a particular user, give them a variable to hold their data:

```rails
O = Organisation.find(<id of the user you want to find>)
```

---

## Adding Birth Records

```rails
FactoryBot.create_list :birth_record, <number of records you want>
```

---

## Methods for models

You can find what methods are available in the `app/models/<the model you want to use>` files.
