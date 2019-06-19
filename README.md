[![Build Status](https://travis-ci.org/ServiceInnovationLab/feijoa.svg?branch=master)](https://travis-ci.org/ServiceInnovationLab/feijoa)

# Feijoa

## Overview
A Rails web app to demonstrate consent management

## Environments
**Environment** | **URL**  | **Git Branch**
---    | ---                                | ---    |
Heroku | https://feijoa.herokuapp.com/ | master |

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
