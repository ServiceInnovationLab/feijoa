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
Developers | [@br3nda](https://github.com/Br3nda), [@lamorrison](https://github.com/lamorrison), [@mermop](https://github.com/mermop), [@JacOng17](https://github.com/JacOng17)
Designers | [@rosspatel01](https://github.com/rosspatel01)
Testers |
Scrum Master | [@merridy](https://github.com/merridy)
Product Owner | [@workbygrant](https://github.com/workbygrant)

## Comms

Slack: LabPlus-team #feijoa

## Setup

### Prerequisites

- Postgres
- Java

### Development

In the application directory:

**1. Make a copy of the example environment file containing some important settings**

```bash
cp example.env .env
```

**2. Install Rails dependencies and create local databases**

```bash
bin/setup
```

**3. [Install and run Elastic search](https://www.elastic.co/downloads/elasticsearch)**

By default this is expected to run on localhost:9200 - if you have ElasticSearch running on a different port, you can change `ELASTICSEARCH_URL` in your `.env` file.

On Ubuntu you can use the same script as Travis CI:

```bash
ELASTIC_SEARCH_VERSION="6.2.3" ./bin/install_elasticsearch.sh
```

On Mac you may want to use Homebrew:

```bash
brew install elasticsearch
brew services start elasticsearch
```

**To check whether Elastic Search is running (or not)**
`sudo service elasticsearch status`

**4. Create a search index in Elastic Search**

You will need to build an ElasticSearch index for the new organisations:

```bash
bundle exec rake search:index
```

**5. Start a local server**

```bash
bundle exec rails server
```

## Local data

You can import organisations

```bash
bundle exec rake import:ece
bundle exec rake import:schools
bundle exec rake import:tkkm
```

## Testing

### Rubocop

```bash
bundle exec rubocop
```

### Rspec

```bash
bundle exec rspec
```

Test coverage is reported to `coverage/index.html`

---

### Creating users/organisations, etc...in **rails console:**

**To create a user to login:**

`user = FactoryBot.create :user, email: '<emailAddress>', password: '<password>'`

**To create an organisation:**

`organisation = FactoryBot.create :organisation`

**To add user to an organisation:** (**add_role(organisation, role)** method from `user.rb`)

Eg.
`user.add_role(organisation, OrganisationMember::ADMIN_ROLE)`
