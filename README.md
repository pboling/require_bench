# RequireBench

Have a Ruby project that has stopped loading, and you aren't sure where the issue is?

Knowing the last file that was successfully "required" by Ruby can be helpful in diagnosing the issue.  This gem will help you find that last required file.  It can also help you see where expensive (slow) processing is occurring, by adding `Benchmark.realtime` to every require, and printing the result for every file.

This is an extraction of a debugging tool that I have copy/pasted into many projects over the years, and it is now time to set it free.

*Warning*: This gem is for debugging problems.  It uses a global **$** variable, which is sad practice.  It uses it as a safety semaphore, so I consider it justified.  If you can think of a better way to implement the safety semaphore, let me know!

| Project                 |  RequireBench |
|------------------------ | ----------------------- |
| gem name                |  [require_bench](https://rubygems.org/gems/require_bench) |
| license                 |  [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT) |
| download rank           |  [![Downloads Today](https://img.shields.io/gem/rd/require_bench.svg)](https://github.com/pboling/require_bench) |
| version                 |  [![Version](https://img.shields.io/gem/v/require_bench.svg)](https://rubygems.org/gems/require_bench) |
| dependencies            |  [![Depfu](https://badges.depfu.com/badges/247bffc753b0cd49d3c08ce03b5c251c/count.svg)](https://depfu.com/github/pboling/require_bench?project_id=5824) |
| continuous integration  |  [![Build Status](https://travis-ci.org/pboling/require_bench.svg?branch=master)](https://travis-ci.org/pboling/require_bench) |
| test coverage           |  [![Test Coverage](https://api.codeclimate.com/v1/badges/18523205c207a2b53045/test_coverage)](https://codeclimate.com/github/pboling/require_bench/test_coverage) |
| maintainability         |  [![Maintainability](https://api.codeclimate.com/v1/badges/18523205c207a2b53045/maintainability)](https://codeclimate.com/github/pboling/require_bench/maintainability) |
| code triage             |  [![Open Source Helpers](https://www.codetriage.com/pboling/require_bench/badges/users.svg)](https://www.codetriage.com/pboling/require_bench) |
| homepage                |  [on Github.com][homepage], [on Railsbling.com][blogpage] |
| documentation           |  [on RDoc.info][documentation] |
| Spread ~♡ⓛⓞⓥⓔ♡~      |  [🌍 🌎 🌏](https://about.me/peter.boling), [🍚](https://www.crowdrise.com/helprefugeeswithhopefortomorrowliberia/fundraiser/peterboling), [➕](https://plus.google.com/+PeterBoling/posts), [👼](https://angel.co/peter-boling), [🐛](https://www.topcoder.com/members/pboling/), [:shipit:](http://coderwall.com/pboling), [![Tweet Peter](https://img.shields.io/twitter/follow/galtzo.svg?style=social&label=Follow)](http://twitter.com/galtzo) |

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'require_bench'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install require_bench

## Usage

Require the library where it will be loaded prior to any other requires you want to benchmark.

```ruby
require 'require_bench'
```

By default this gem does **nothing**, hacks **nothing**, and has **zero** effects.

### Turn on benchmarking & output

Add an environment variable, however you normally do such things, so that in Ruby:

```ruby
ENV['REQUIRE_BENCH'] == 'true'
```

Any value other than `'true'` means RubyBench is still turned off.

### Handy Rake Task for Rails:

Require in Rakefile, as follows:

```ruby
  require 'bundler/setup'
  require 'require_bench/tasks' # Near the top, just below require 'bundler/setup'!
```

This will ensure it will load before other stuff.

When running from command line, you will see output as the Rails app boots.
```bash
∴ REQUIRE_BENCH=true bundle exec rake require_bench:hello
[RequireBench]  12.179703 /path/to/my_app/config/application
[RequireBench]   0.001726 resque/tasks
[RequireBench]   0.000917 resque/scheduler/tasks
[RequireBench]   0.000011 rake
[RequireBench]   0.000014 active_record
[RequireBench]   0.008673 sprockets/rails/task
[RequireBench]   0.000012 dynamoid
[RequireBench]   0.000004 dynamoid/tasks/database
[RequireBench]   0.000012 raven/integrations/tasks
[RequireBench]   0.003107 rspec/core/rake_task
[RequireBench]   0.000017 csv
[RequireBench]   0.000012 resque/tasks
[RequireBench]   0.000007 resque/scheduler/tasks
[RequireBench]   0.064950 rails/tasks
[RequireBench]   0.003305 rake/testtask
[RequireBench]   0.001886 rubocop/rake_task
[RequireBench]   0.000012 hubspot-ruby
[RequireBench]   2.291259 /path/to/my_app/config/environment.rb

[RequireBench] Slowest Loads by Library, in order
 1.  11.914224 /path/to/my_app/config/application
 2.   2.153282 /path/to/my_app/config/environment.rb
 3.   0.061008 rails
 4.   0.010827 sprockets
 5.   0.003179 rspec
 6.   0.003144 rake
 7.   0.003127 resque
 8.   0.001543 rubocop
 9.   0.000021 dynamoid
10.   0.000016 csv
11.   0.000016 active_record
12.   0.000010 raven
13.   0.000005 hubspot-ruby
==========
 14.150402 TOTAL
```

### Output Options

If the output is too noisy from deep libraries you can add a regex to skip benchmarking of files that match.

If the value is set in the shell, it should be a string.  RequireBench will split the string by comma, Regexp escape each value, and join together with pipe (`|`) to form the regex pattern.

```bash
export REQUIRE_BENCH_SKIP_PATTERN=activesupport,rspec
```

If the `ENV['REQUIRE_BENCH_SKIP_PATTERN']` value is set in Ruby, it can be one of:
  * a string, to be split by comma, each Regexp escaped, then joined by pipe (`|`)
  * an array of strings, each to be Regexp escaped, then joined by pipe (`|`)
  * a Regexp object, which will be used as is.

```ruby
ENV['REQUIRE_BENCH_SKIP_PATTERN'] = 'activesupport,rspec'
# or
ENV['REQUIRE_BENCH_SKIP_PATTERN'] = [ 'activesupport', 'rspec' ]
# or
ENV['REQUIRE_BENCH_SKIP_PATTERN'] = Regexp.new('activesupport|rspec')
```

Any file being required that matches the pattern will use the standard, rather than the benchmarked, require.

#### Fully qualified paths

Fully qualified paths, or any portion thereof, are fine, because the strings are always Regexp escaped.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pboling/require_bench.

## Code of Conduct

Everyone interacting in the AnonymousActiveRecord project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pboling/require_bench/blob/master/CODE_OF_CONDUCT.md).

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver].
Violations of this scheme should be reported as bugs. Specifically,
if a minor or patch version is released that breaks backward
compatibility, a new version should be immediately released that
restores compatibility. Breaking changes to the public API will
only be introduced with new major versions.

As a result of this policy, you can (and should) specify a
dependency on this gem using the [Pessimistic Version Constraint][pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency 'require_bench', '~> 0.0'
```

## License

* Copyright (c) 2018 [Peter H. Boling][peterboling] of [Rails Bling][railsbling]

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT) 

[license]: LICENSE
[semver]: http://semver.org/
[pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[railsbling]: http://www.railsbling.com
[peterboling]: http://www.peterboling.com
[documentation]: http://rdoc.info/github/pboling/require_bench/frames
[homepage]: https://github.com/pboling/require_bench/
[blogpage]: http://www.railsbling.com/tags/require_bench/
