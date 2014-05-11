# crdx.org

This is the source of [crdx.org](http://crdx.org) which is currently powered by [jekyll](https://github.com/mojombo/jekyll/).

## grunt, grunt

### Install grunt

    npm install -g grunt-cli

### Install dependencies

    npm install

### Development

    grunt watch  [--drafts]
    grunt w [--drafts]

Build the website, and then watch for changes and rebuild when they change. Pass `--drafts` to include draft posts.

Additionally, a livereload server will start on [localhost:9001](http://localhost:9001).

### Build

    grunt build [--drafts]
    grunt b [--drafts]

Build the website. Pass `--drafts` to include draft posts.
