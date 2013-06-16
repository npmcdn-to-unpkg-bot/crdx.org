path = require "path"
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet

module.exports = (grunt) ->
    path = require("path")

    grunt.initConfig
        pkg: grunt.file.readJSON "package.json"
        yaml: grunt.file.readYAML "_config.yml"

        livereload:
            port: 35729

        connect:
            livereload:
                options:
                    port: 9001
                    base: "../dist/deploy"
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
                expand: true
                ext: ".min.css"
                src: "css/*.less"
                dest: "assets/"

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
            drafts:
                options:
                    drafts: true
            production:
                options:
                    drafts: false

        regarde:
            coffee:
                files: "js/*.coffee"
                tasks: ["coffee:all", "jekyll:production", "livereload"]
            less:
                files: "css/*.less"
                tasks: ["less:all", "jekyll:production", "livereload"]
            cssmin:
                files: "css/*.css"
                tasks: ["cssmin:all", "jekyll:production", "livereload"]
            uglify:
                files: "js/*.js"
                tasks: ["uglify:all", "jekyll:production", "livereload"]
            images:
                files: "img/*"
                tasks: ["copy:images", "jekyll:production", "livereload"]
            jekyll:
                files: ["*", "_*/**", "misc/**"]
                tasks: ["jekyll:production", "livereload"]

    grunt.loadNpmTasks "grunt-contrib-less"
    grunt.loadNpmTasks "grunt-contrib-cssmin"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-regarde"
    grunt.loadNpmTasks "grunt-contrib-connect"
    grunt.loadNpmTasks "grunt-contrib-livereload"

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
        for task in ["coffee", "less", "cssmin", "uglify"]
            if grunt.file.isMatch(grunt.config("regarde.#{task}.files"), filePath)
                grunt.config "#{task}.all.src", filePath

    grunt.registerTask "assets", [
        "coffee" # *.coffee -> *.js
        "uglify" # *.js     -> *.min.js
        "less"   # *.less   -> *.css
        "cssmin" # *.css    -> *.min.css
        "copy:images"
    ]

    grunt.registerTask "drafts", [
        "assets"
        "jekyll:drafts"
    ]

    grunt.registerTask "build", [
        "assets"
        "jekyll:production"
    ]

    # live reload
    grunt.registerTask "lr", [
        "livereload-start"
        "connect"
        "regarde"
    ]

    # aliases
    grunt.registerTask "b", "build"
    grunt.registerTask "w", "lr"

    # default task
    grunt.registerTask "default", "lr"
