default[:wagnaria][:user] = "wagnaria"
default[:wagnaria][:group] = "wagnaria"

default[:wagnaria][:repo] = "https://github.com/liliff/wagnaria.git"
default[:wagnaria][:tag] = "master"
default[:wagnaria][:destination] = "/home/wagnaria"
default[:wagnaria][:virtualenv] = "#{default[:wagnaria][:destination]}/shared/env"
default[:gunicorn][:virtualenv] = default[:wagnaria][:virtualenv]

default[:wagnaria][:gunicorn][:socket] = "/var/run/wagnaria.sock"

default[:wagnaria][:pyenv][:version] = "3.2"
default[:wagnaria][:pyenv][:packages] = ["pyyaml", "pymongo"]

default[:nginx][:default_site_enabled] = false
