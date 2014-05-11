path = require "path"
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
matchdep = require "matchdep"

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"
    yaml: grunt.file.readYAML "_config.yml"

    livereload:
      port: 35729

    connect:
      livereload:
        options:
          port: 9001
          base: "_site/htdocs"
          middleware: (connect, options) ->
            [lrSnippet, connect.static path.resolve(options.base)]

    clean:
      all: [
        "assets/*"
      ]

    coffee:
      options:
        sourceMap: true
      all:
        expand: true
        ext: ".coffee.js"
        src: "js/*.coffee"
        dest: "assets/"

    uglify:
      options:
        sourceMap: (dest) -> dest + ".map"
        sourceMappingURL: (dest) -> path.basename(dest) + ".map"
      all:
        expand: true
        ext: ".min.js"
        src: "js/*.js"
        dest: "assets/"

    less:
      options:
        compress: true
      all:
        files:
          "assets/css/main.min.css": "less/_.less"

    cssmin:
      options:
        keepSpecialComments: 0
      all:
        expand: true
        ext: ".min.css"
        src: ["css/*.css"]
        dest: "assets/"

    copy:
      images:
        expand: true
        src: "img/*"
        dest: "assets/"

    jekyll:
      all:
        options:
          drafts: grunt.option("drafts")

    regarde:
      coffee:
        files: "js/*.coffee"
        tasks: ["coffee", "jekyll", "livereload"]
      less:
        files: "less/*.less"
        tasks: ["less", "jekyll", "livereload"]
      cssmin:
        files: "css/*.css"
        tasks: ["cssmin", "jekyll", "livereload"]
      uglify:
        files: "js/*.js"
        tasks: ["uglify", "jekyll", "livereload"]
      images:
        files: "img/*"
        tasks: ["copy", "jekyll", "livereload"]
      jekyll:
        files: [
          "*", # individual files in the root
          "_{drafts,includes,layouts,plugins,posts}/**"     # all of jekyll's _underscore directories (except _site!)
          "misc/**"                                         # all of misc
        ]
        tasks: ["jekyll", "livereload"]

  matchdep.filter("grunt-*").forEach (pkg) ->
    console.log "Loading #{pkg}"
    grunt.loadNpmTasks pkg

  # jekyll
  grunt.registerMultiTask "jekyll", ->
    done = @async()

    args = ["build"]

    options = [
      { name: "drafts", value: false, flag: "--drafts" }
    ]

    for option in options
      args.push(option.flag) if @data.options[option.name] or option.value

    grunt.util.spawn { cmd: "jekyll", args: args }, (error, result, code) ->
      if error
        grunt.log.error error
        done false
      else
        grunt.log.writeln result
        done true

  grunt.event.on "regarde:file:changed", (section, filePath, tasks, spawn) ->
    # When a change occurs, override the source to be just that file, rather
    # than all the files defined above. This means that only the changed
    # file will be recompiled and not everything.
    for task in ["coffee", "cssmin", "uglify"]
      if grunt.file.isMatch(grunt.config("regarde.#{task}.files"), filePath)
        grunt.config "#{task}.all.src", filePath

  # live reload
  grunt.registerTask "lr", [
    "livereload-start"
    "connect"
    "regarde"
  ]

  # public tasks
  grunt.registerTask "assets", [
    "coffee"            # *.coffee -> *.js
    "uglify"            # *.js     -> *.min.js
    "less"              # *.less   -> *.css
    "cssmin"            # *.css    -> *.min.css
    "copy:images"
  ]

  grunt.registerTask "build", [
    "assets"
    "jekyll"
  ]

  grunt.registerTask "watch", [
    "build"
    "lr"
  ]

  # aliases
  grunt.registerTask "b", "build"
  grunt.registerTask "w", "watch"

  # default task
  grunt.registerTask "default", ->
    console.log "Please use either w (watch) or b (build). Pass --drafts to enable draft posts."
