# Gris

[Gris](https://github.com/artsy/gris) is a framework for building opinionated Rack-based hypermedia APIs. Gris aims to provide useful generators, helpers and middleware common to API microservices. Note that Gris is in development and that the ground may shift.

It makes use of [Grape](https://github.com/intridea/grape), [Roar](https://github.com/apotonick/roar), [RSpec](http://rspec.info/), [Hyperclient](https://github.com/codegram/hyperclient), and [Active Record](https://github.com/rails/rails/tree/main/activerecord) with PostgreSQL among other excellent projects. Gris is derived from/inspired by the stellar and more sophisticated [Napa framework by Bellycard Inc.](https://github.com/bellycard/napa). We stand on the shoulders of tall people.

[![Build Status](https://semaphoreci.com/api/v1/projects/aeb68b19-58b7-4015-885d-e989a3e96ca2/418227/badge.svg)](https://semaphoreci.com/artsy-it/gris)

[![Gem Version](https://badge.fury.io/rb/gris.svg)](http://badge.fury.io/rb/gris)
[![Code Climate](https://codeclimate.com/github/artsy/gris/badges/gpa.svg)](https://codeclimate.com/github/artsy/gris)
[![Dependency Status](https://gemnasium.com/artsy/gris.svg)](https://gemnasium.com/artsy/gris)

---

### Installation

Gris is [available as a gem on rubygems](https://rubygems.org/gems/gris), to install it run:

```
gem install gris
```

Otherwise, if your project uses [Bundler](http://bundler.io/), add gris to your Gemfile:

```
gem 'gris'
```

And run:

```
$ bundle install
```

---

### Quickstart Demo(s)

You can find example pull requests providing walkthroughs of new app set up here:
[https://github.com/artsy/gris-demo/pulls](https://github.com/artsy/gris-demo/pulls)

---

### Usage

##### CLI & Generators

Run the `gris` terminal prompt to see available features:

```
Commands:
  gris console [environment]                                                            # Start the Gris console
  gris generate api <api_name>                                                          # Generate a Grape API, Model and Representer
  gris generate migration <migration_name> [field[:type][:index] field[:type][:index]]  # Generate a Database Migration
  gris help [COMMAND]                                                                   # Describe available commands or one specific command
  gris new <app_name> [app_path]                                                        # Generates a scaffold for a new Gris service
  gris version                                                                          # Shows the Gris version number
```

---

### Caching

You can use caching by including this module in your ActiveRecord models,

    class OfferEvent < ActiveRecord::Base
      include Gris::Caching
    end

and then cache inside GET requests like this

    offer_event =  OfferEvent.cached_find(id)

To expire the cache for an object, call

    OfferEvent.expire_cache_for(id)

or, if you have an instance, use

    offer_event.expire_cache

### The name

Gris is named for the Cubist painter [Juan Gris](https://www.artsy.net/artist/juan-gris).

![juan-gris-bottles-and-bowl-1911](https://cloud.githubusercontent.com/assets/197336/9348124/5ef5531c-4600-11e5-8318-4858076d7c6d.jpg)
