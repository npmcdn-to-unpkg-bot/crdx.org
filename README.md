# crdx.org

This is the source of [crdx.org](http://crdx.org) which is currently generated by [jekyll](https://github.com/mojombo/jekyll/), and powered by grunt.

## grunt, grunt

### Install grunt

    npm install -g grunt-cli

### Install dependencies

    npm install

### Run tasks

**Note**: "production" implies "without drafts" only.

Build assets only:

    grunt assets

Build all with drafts:

    grunt drafts

Build all as production:

    grunt build

Watch and build all as production when anything changes:

    grunt
