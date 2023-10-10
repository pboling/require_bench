# RequireBench

Have a Ruby project that has stopped loading, and you aren't sure where the issue is?

Knowing the last file that was successfully _required_, or _loaded_ by Ruby can be helpful in diagnosing the issue.  This gem will help you find that last required file.  It can also help you see where expensive (slow) processing is occurring, by adding `Benchmark.realtime` to every `require` / `load`, and printing the result for every file.

As of version 1.0.4 it can also add timeout, rescue, and additional logging to both `require` and `load`.

This is an extraction of a debugging tool that I have copy/pasted into many projects over the years, and it is now time to set it free.

*Note*: This gem will make code load slower than normal, but may end up saving you time by showing you where a problem is.

*Warning*: This gem is for debugging problems.  It uses a global **$** variable, which is sad practice.  It uses it as a safety semaphore, so I consider it justified.  If you can think of a better way to implement the safety semaphore, let me know!

*Caveat*: This gem has no effects unless a particular environment variable is set.  It does nothing at all unless it is 'invoked' by detection of the environment variable (`ENV['REQUIRE_BENCH'] == 'true'`).  The *Warning* above is mitigated by the gem not having any of its code, other than the namespace and version, activated under normal circumstances.

| Project                | RequireBench                                                                                                                                                                                                                                                                                                                      |
|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| gem name               | [require_bench](https://rubygems.org/gems/require_bench)                                                                                                                                                                                                                                                                          |
| license                | [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)                                                                                                                                                                                                                        |
| download rank          | [![Downloads Today](https://img.shields.io/gem/rd/require_bench.svg)](https://github.com/pboling/require_bench)                                                                                                                                                                                                                   |
| version                | [![Version](https://img.shields.io/gem/v/require_bench.svg)](https://rubygems.org/gems/require_bench)                                                                                                                                                                                                                             |
| dependencies           | [![Depfu](https://badges.depfu.com/badges/247bffc753b0cd49d3c08ce03b5c251c/count.svg)](https://depfu.com/github/pboling/require_bench?project_id=5824)                                                                                                                                                                            |
| continuous integration | [![Current][🚎ini-cwfi]][🚎ini-cwf] [![Heads][🖐ini-hwfi]][🖐ini-hwf] [![Style][🧮ini-swfi]][🧮ini-swf]                                                                                                                                                                                                                           |
| test coverage          | [![Coverage][📗ini-covwfi]][📗ini-covwf] [![Test Coverage](https://api.codeclimate.com/v1/badges/18523205c207a2b53045/test_coverage)](https://codeclimate.com/github/pboling/require_bench/test_coverage)                                                                                                                         |
| maintainability        | [![Maintainability](https://api.codeclimate.com/v1/badges/18523205c207a2b53045/maintainability)](https://codeclimate.com/github/pboling/require_bench/maintainability)                                                                                                                                                            |
| code triage            | [![Open Source Helpers](https://www.codetriage.com/pboling/require_bench/badges/users.svg)](https://www.codetriage.com/pboling/require_bench)                                                                                                                                                                                     |
| homepage               | [on Github.com][homepage], [on Railsbling.com][blogpage]                                                                                                                                                                                                                                                                          |
| documentation          | [on RDoc.info][documentation]                                                                                                                                                                                                                                                                                                     |
| Support                | [Chat on Element / Matrix / Gitter][🏘chat]                                                                                                                                                                                                                                                                                       |
| Spread ~♡ⓛⓞⓥⓔ♡~        | [🌏](https://about.me/peter.boling), [👼](https://angel.co/peter-boling), [![Liberapay Patrons][⛳liberapay-img]][⛳liberapay] [![Follow Me on LinkedIn][🖇linkedin-img]][🖇linkedin] [![Find Me on WellFound:][✌️wellfound-img]][✌️wellfound] [![My Blog][🚎blog-img]][🚎blog] [![Follow Me on Twitter][🐦twitter-img]][🐦twitter] |

[![Support my refugee and open source work @ ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/O5O86SNP4)

[⛳liberapay-img]: https://img.shields.io/liberapay/patrons/pboling.svg?logo=liberapay
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇linkedin]: http://www.linkedin.com/in/peterboling
[🖇linkedin-img]: https://img.shields.io/badge/PeterBoling-blue?style=plastic&logo=linkedin
[✌️wellfound]: https://angel.co/u/peter-boling
[✌️wellfound-img]: https://img.shields.io/badge/peter--boling-orange?style=plastic&logo=angellist
[🐦twitter]: http://twitter.com/intent/user?screen_name=galtzo
[🐦twitter-img]: https://img.shields.io/twitter/follow/galtzo.svg?style=social&label=Follow%20@galtzo
[🚎blog]: http://www.railsbling.com/tags/oauth2/
[🚎blog-img]: https://img.shields.io/badge/blog-railsbling-brightgreen.svg?style=flat
[my🧪lab]: https://gitlab.com/pboling
[my🧊berg]: https://codeberg.org/pboling
[my🛖hut]: https://sr.ht/~galtzo/

<!-- columnar badge #s for Project Health table:
⛳️
🖇
🏘
🚎
🖐
🧮
📗
🚀
💄
👽
-->

[🚎ini-cwf]: https://github.com/pboling/require_bench/actions/workflows/current.yml
[🚎ini-cwfi]: https://github.com/pboling/require_bench/actions/workflows/current.yml/badge.svg
[🖐ini-hwf]: https://github.com/pboling/require_bench/actions/workflows/heads.yml
[🖐ini-hwfi]: https://github.com/pboling/require_bench/actions/workflows/heads.yml/badge.svg
[🧮ini-swf]: https://github.com/pboling/require_bench/actions/workflows/style.yml
[🧮ini-swfi]: https://github.com/pboling/require_bench/actions/workflows/style.yml/badge.svg
[📗ini-covwf]: https://github.com/pboling/require_bench/actions/workflows/coverage.yml
[📗ini-covwfi]: https://github.com/pboling/require_bench/actions/workflows/coverage.yml/badge.svg

[🏘chat]: https://matrix.to/#/#pboling_require_bench:gitter.im

## Installation

Add this line to your application's Gemfile:

```ruby
gem "require_bench"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install require_bench

## Usage

Require the library where it will be loaded prior to any other requires you want to benchmark.

```ruby
require "require_bench"
```

By default this gem does **nothing**, hacks **nothing**, and has **zero** effects.

### Turn on benchmarking & output

Add an environment variable, however you normally do such things, so that in Ruby:

```ruby
ENV["REQUIRE_BENCH"] == "true"
```

Any value other than `'true'` means RequireBench is still turned off.

### Handy Rake Task

#### For a Gem Library

Require in Rakefile:

```ruby
require "bundler/setup"
require "require_bench/tasks" # Near the top, just below require 'bundler/setup'!
```

#### For Rails

Require in Rakefile:

```ruby
require_relative "config/application"
require "require_bench/tasks" # Near the top, just below require_relative 'config/application'!
```

#### Example

When running from command line, you will see output as the Rails app boots. In the case below it ignores all gem libraries, and only tracks Rails.
The output at the top shows the config being used.
```bash
$ REQUIRE_BENCH=true bundle exec rake require_bench:hello
[RequireBench] Using skip pattern: (?-mix:gems)
[RequireBench] Using include pattern: (?-mix:my_app)
[RequireBench] Using no group pattern: (?-mix:ext|config)
🚥 [RequireBench-r] ☑️   0.005564 /Volumes/🐉🩸/src/apps/my_app/lib/middleware/omniauth_bypass.rb 🚥
🚥 [RequireBench-r] ☑️   0.001099 /Volumes/🐉🩸/src/apps/my_app/lib/middleware/sidekiq/match_deployment_rules.rb 🚥
🚥 [RequireBench-r] ☑️   0.001121 /Volumes/🐉🩸/src/apps/my_app/lib/middleware/sidekiq/request_store.rb 🚥
🚥 [RequireBench-r] ☑️   0.000989 /Volumes/🐉🩸/src/apps/my_app/lib/middleware/sidekiq/clear_active_record_connections.rb 🚥
🚥 [RequireBench-r] ☑️   0.006890 /Volumes/🐉🩸/src/apps/my_app/lib/middleware/sidekiq/worker_killer.rb 🚥
🚥 [RequireBench-r] ☑️   0.001990 /Volumes/🐉🩸/src/apps/my_app/lib/parsers/pku_parser.rb 🚥

[RequireBench] Slowest Loads by Library, in order
 1.   0.017653 my_app
==========
  0.017653 TOTAL
```

### Output Options

If the output is too noisy from deep libraries you can add a regex to skip benchmarking of files that match.

```bash
export REQUIRE_BENCH_SKIP_PATTERN=activesupport,rspec
```

`ENV['REQUIRE_BENCH_SKIP_PATTERN']` must be one of:
  * a string, to be split by comma (`,`), then joined by pipe (`|`) with `Regexp.union`
  * a string, to be split by pipe (`|`), then joined by pipe (`|`) with `Regexp.union`

```ruby
ENV["REQUIRE_BENCH_SKIP_PATTERN"] = "activesupport,rspec"
# or
ENV["REQUIRE_BENCH_SKIP_PATTERN"] = "activesupport|rspec"
```

Any file being required that matches the pattern will use the standard, rather than the benchmarked, require.

#### Fully qualified paths

Fully qualified paths, or any portion thereof, are fine, because the strings are always Regexp escaped.

### Other ENV control variables

- wrap/log load in addition to require
    - `ENV['REQUIRE_BENCH_TRACKED_METHODS']`
- rescue errors
    - `ENV['REQUIRE_BENCH_RESCUED_CLASSES']`
- log start
    - `ENV['REQUIRE_BENCH_LOG_START']`
- load/require timeout
    - `ENV['REQUIRE_BENCH_TIMEOUT']`
- A pattern for paths that should be included/tracked
    - `ENV['REQUIRE_BENCH_INCLUDE_PATTERN']`
- Should grouping be by basename or by path?
    - `ENV['REQUIRE_BENCH_GROUP_PRECEDENCE']`
- Prefer to not group some pattern (i.e. some libraries)
    - `ENV['REQUIRE_BENCH_NO_GROUP_PATTERN']`

If you'd like to help document any of these further, PRs are appreciated!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To get code coverage:
```shell
CI_CODECOV=true COVER_ALL=false bundle exec rspec
```

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
spec.add_dependency("require_bench", "~> 0.0")
```

## License

* Copyright (c) 2018-2020, 2023 [Peter H. Boling][peterboling] of [Rails Bling][railsbling]

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

[license]: LICENSE
[semver]: http://semver.org/
[pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[railsbling]: http://www.railsbling.com
[peterboling]: http://www.peterboling.com
[documentation]: http://rdoc.info/github/pboling/require_bench/frames
[homepage]: https://github.com/pboling/require_bench/
[blogpage]: http://www.railsbling.com/tags/require_bench/
