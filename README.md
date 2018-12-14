# Repoman

## Intro

Helps you manage your repos! I use this to manage microservices with lots of libraries. As long as you keep your config up to date, you never have to worry about what you do and do not have locally.
The name 'repoman' is (already taken)[] so I guess this will have a new name by the time it hits first release, but let's roll with it for now!

## Usage

First, you need a config file. The expectation is that you have a config for each cohesive "group" of repositories, but you can manage it however you'd like!
Given a directory structure like:
```
~
  project
    services
      user_service
      order_service
    libraries
      authentication_middleware
```
then your config might look something like this:
```
{
    "root": "~/project",
        "repositories": [
        {
            "name": "user_service",
            "aliases": ["user"],
            "path": "services/user_service",
            "remote": "git@github.com:my_organization/user_service"
        },
        {
            "name": "order_service",
            "aliases": ["order"],
            "path": "services/order_service",
            "remote": "git@github.com:my_organization/order_service"
        },
        {
            "name": "authentication_middleware",
            "aliases": ["auth", "auth_gem"],
            "path": "libraries/authentication_middleware",
            "remote": "git@github.com:my_organization/authentication_middleware"
        },
        ]
}
```

Instead of detailed usage (that's what documentation is for!) here are some usage examples:
```
repoman branch
services/user_service                       bug-fix-7
services/order_service                      bug-fix-22
libraries/authentication_middleware         master

repoman status --no-skip-clean
services/user_service                       bug-fix-7           2 files changed, 5 insertions(+), 30 deletions(-)
services/order_service                      bug-fix-22
libraries/authentication_middleware         master

repoman status
services/user_service                       bug-fix-7           2 files changed, 5 insertions(+), 30 deletions(-)
```

## Installation

Easy!

```
gem install repoman
```
**NOTE: This is a lie. This is neither published, nor an unclaimed name.**
