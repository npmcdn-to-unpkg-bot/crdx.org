path = require "path"

module.exports = (grunt) ->
    path = require("path")

    grunt.initConfig
        pkg: grunt.file.readJSON "package.json"
        yaml: grunt.file.readYAML "_config.yml"

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

        stylus:
            options:
                compress: true
            all:
                expand: true
                ext: ".min.css"
                src: "css/*.styl"
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

        watch:
            options:
                nospawn: true
            coffee:
                files: "js/*.coffee"
                tasks: ["coffee:all", "jekyll:production"]
            stylus:
                files: "css/*.styl"
                tasks: ["stylus:all", "jekyll:production"]
            cssmin:
                files: "css/*.css"
                tasks: ["cssmin:all", "jekyll:production"]
            uglify:
                files: "js/*.js"
                tasks: ["uglify:all", "jekyll:production"]
            images:
                files: "img/*"
                tasks: ["copy:images", "jekyll:production"]
            jekyll:
                files: [
                    "*"
                    "_*/**"
                    "{misc}/**"
                ]
                tasks: "jekyll:production"

    grunt.loadNpmTasks "grunt-contrib-stylus"
    grunt.loadNpmTasks "grunt-contrib-cssmin"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-copy"

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

    grunt.event.on "watch", (action, filePath) ->
        return if action != "changed"

        # When a change occurs, override the source to be just that file, rather
        # than all the files defined above. This means that only the changed
        # file will be recompiled and not everything.
        for task in ["coffee", "stylus", "cssmin", "uglify"]
            if grunt.file.isMatch(grunt.config("watch.#{task}.files"), filePath)
                grunt.config "#{task}.all.src", filePath

    grunt.registerTask "assets", [
        "coffee" # *.coffee -> *.js
        "uglify" # *.js     -> *.min.js
        "stylus" # *.styl   -> *.css
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

    # aliases
    grunt.registerTask "b", "build"
    grunt.registerTask "w", "watch"

    # default task
    grunt.registerTask "default", "watch"