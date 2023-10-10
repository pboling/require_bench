## Contributing

Bug reports and pull requests are welcome on GitLab at [https://gitlab.com/pboling/require_bench][🚎src-main]
. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct][conduct].

To submit a patch, please fork the project and create a patch with tests. Once you're happy with it send a pull request
and post a message to the [gitter chat][🏘chat].

## Release

To release a new version:

1. Run `bin/setup && bin/rake` as a tests, coverage, & linting sanity check
2. Update the version number in `version.rb`
3. Run `bin/setup && bin/rake` again as a secondary check, and to update `Gemfile.lock`
4. Run `git commit -am "🔖 Prepare release v<VERSION>"` to commit the changes
   a. NOTE: Remember to [check the build][build]!
5. Run `rake build`
6. Run [`bin/checksums`](https://github.com/rubygems/guides/pull/325) to create SHA-256 and SHA-512 checksums
   a. Checksums will be committed automatically by the script
7. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org][rubygems]

NOTE: You will need to have a public key in `certs/`, and list your cert in the
`gemspec`, in order to sign the new release.
See: [RubyGems Security Guide][rubygems-security-guide]

## Contributors

See: [https://gitlab.com/pboling/require_bench/-/graphs/main][🖐contributors]

[conduct]: https://gitlab.com/pboling/require_bench/-/blob/main/CODE_OF_CONDUCT.md
[build]: https://github.com/pboling/require_bench/actions
[🖐contributors]: https://gitlab.com/pboling/require_bench/-/graphs/main
[🚎src-main]: https://gitlab.com/pboling/require_bench/-/tree/main
[🏘chat]: https://matrix.to/#/#pboling_require_bench:gitter.im
[rubygems-security-guide]: https://guides.rubygems.org/security/#building-gems
[rubygems]: https://rubygems.org
