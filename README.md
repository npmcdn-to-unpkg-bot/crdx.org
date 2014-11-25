# crdx.org

This is the source of [crdx.org](http://crdx.org), powered by [jekyll](https://github.com/mojombo/jekyll/).

## grunt, grunt

### Install dependencies

    sudo apt-get install ruby ruby-dev nodejs
    
### Install subdependencies

    sudo gem install jekyll
    npm install -g grunt-cli
    npm install

## Watch

    grunt watch  [--drafts]
    grunt w [--drafts]

Build the website, and then watch for changes and rebuild when they change. Pass `--drafts` to include draft posts.

Additionally, a livereload server will start on [localhost:9001](http://localhost:9001).

## Build

    grunt build [--drafts]
    grunt b [--drafts]

Build the website. Pass `--drafts` to include draft posts.
