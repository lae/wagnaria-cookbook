default[:wagnaria][:user] = "wagnaria"
default[:wagnaria][:group] = "wagnaria"

default[:wagnaria][:repo] = "https://github.com/liliff/wagnaria.git"
default[:wagnaria][:tag] = "HEAD"
default[:wagnaria][:destination] = "/home/wagnaria"

default[:wagnaria][:gunicorn][:port] = 9001

default[:wagnaria][:pyenv][:version] = "3.2"
default[:wagnaria][:pyenv][:packages] = ["pyyaml", "pymongo"]
