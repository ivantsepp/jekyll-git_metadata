[![Build Status](https://travis-ci.org/ivantsepp/jekyll-git_metadata.svg?branch=master)](https://travis-ci.org/ivantsepp/jekyll-git_metadata)

# Jekyll::GitMetadata

Expose Git metadata to Jekyll. Just like how Github exposes [repository metadata](https://help.github.com/articles/repository-metadata-on-github-pages), this plugin will expose information about your git repository for your templates. For example:

```
{{site.git.total_commits}} # => Will return the total number of commits for your Jekyll repository
```

## Installation

Add to your `Gemfile`:

```
gem 'jekyll-git_metadata'
```

Add to your `_config.yml`:

```yml
gems:
  - jekyll-git_metadata
```

## Usage

This plugin adds a hash of git information to the `site` and `page` variables. The hash looks something like this:

```
{"authors"=>
  [
   {"commits"=>2, "name"=>"Ivan Tse", "email"=>"ivan@example.com"},
   {"commits"=>5, "name"=>"John Smith", "email"=>"john@example.com"}
  ],
 "total_commits"=>7,
 "total_additions"=>57,
 "total_subtractions"=>22,
 "first_commit"=>
  {"short_sha"=>"d15cbe8",
   "long_sha"=>"d15cbe8d0f4d4db9efda7a3daabbe966c21f3848",
   "author_name"=>"John Smith",
   "author_email"=>"john@example.com",
   "author_date"=>"Thu Jan 16 23:36:00 2014 -0500",
   "commit_name"=>"John Smith",
   "commit_email"=>"john@example.com",
   "commit_date"=>"Thu Jan 16 23:36:00 2014 -0500",
   "message"=>"A commit!"},
 "last_commit"=>
  {"short_sha"=>"f88ca3b",
   "long_sha"=>"f88ca3bff630efb6cdb356fad3d640534b109572",
   "author_name"=>"Ivan Tse",
   "author_email"=>"ivan@example.com",
   "author_date"=>"Mon Jul 14 04:04:47 2014 -0400",
   "commit_name"=>"John Smith",
   "commit_email"=>"john@example.com",
   "commit_date"=>"Mon Jul 14 04:04:47 2014 -0400",
   "message"=>"Fix some stuff"}}
```

To access this hash, use either `page.git` or `site.git`. `page.git` contains the git information about that particuliar page/file. `site.git` contains the git information for the entire git repository. `site.git` also includes `total_files` and `project_name` variables.

## Contributing

1. Fork it ( https://github.com/ivantsepp/jekyll-git_metadata/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Suggestions for more git metadata are welcomed!
