# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
### Changed
### Fixed
### Removed

## [1.0.4] 2023-10-09
### Added
- Minimum Ruby version @ 2.2.0
- Support tracking `load` in addition to `require`!
- More tests
- Better documentation
- New ENV control variables
  - wrap/log load in addition to require
    - ENV['REQUIRE_BENCH_TRACKED_METHODS']
  - rescue errors
    - ENV['REQUIRE_BENCH_RESCUED_CLASSES']
  - log start
    - ENV['REQUIRE_BENCH_LOG_START']
  - load/require timeout
    - ENV['REQUIRE_BENCH_TIMEOUT']
  - A pattern for paths that should be included/tracked
    - ENV['REQUIRE_BENCH_INCLUDE_PATTERN']
  - Should grouping be by basename or by path?
    - ENV['REQUIRE_BENCH_GROUP_PRECEDENCE']
  - Prefer to not group some pattern (i.e. some libraries)
    - ENV['REQUIRE_BENCH_NO_GROUP_PATTERN']
### Changed
- RequireBench::Version is now RequireBench::VERSION::Version (uses version_gem)
### Fixed
- No RequireBench behavior unless ENV['REQUIRE_BENCH'] == 'true'
- Use `casecmp?` instead of `==` to check ENV variable flags ^

## [1.0.3] 2020-04-08
### Added
- More tests

## [1.0.2] 2020-04-08
### Added
- Improved documentation
- Improved handling of ENV variables

## [1.0.1] 2018-09-21
### Added
- Improved documentation
- MIT license

## [1.0.0] 2018-09-21
### Added
- Initial release

[Unreleased]: https://gitlab.com/pboling/require_bench/-/compare/v1.0.4...HEAD
[1.0.4]: https://gitlab.com/pboling/require_bench/-/compare/v1.0.3...v1.0.4
[1.0.3]: https://gitlab.com/pboling/require_bench/-/compare/v1.0.2...v1.0.3
[1.0.2]: https://gitlab.com/pboling/require_bench/-/compare/v1.0.1...v1.0.2
[1.0.1]: https://gitlab.com/pboling/require_bench/-/compare/v1.0.0...v1.0.1
[1.0.0]: https://gitlab.com/pboling/require_bench/-/compare/67e03119ddb8be7b04ae7fd12da62d0ea5b6fb74...v1.0.0
