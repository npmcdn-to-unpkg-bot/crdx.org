module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON "package.json"

        coffee:
            all:
                options:
                    sourceMap: true
                files:
                    "js/all.js" : [
                        "js/util.coffee"
                        "js/page-cookies.coffee"
                        "js/page-code.coffee"
                    ]

        uglify:
            all:
                files: "js/all.min.js": "js/all.js"
                options:
                    sourceMappingURL: "all.min.js.map"
                    sourceMap: "js/all.min.js.map"
                    sourceMapIn: "js/all.js.map"

        stylus:
            all:
                files: "css/style.css": "css/style.styl"

        cssmin:
            options:
                keepSpecialComments: 0

            mine:
                files: "css/style.min.css": "css/style.css"
            others:
                files:
                    "css/glyphicons.min.css": "css/glyphicons.css"
                    "css/highlight.min.css": "css/highlight.css"

        watch:
            #Gruntfile:
            #    files: []
            #    tasks:
            jekyll:
                files: [
                    "**/*"
                    "!js/*.coffee"       # ignore
                    "!css/*.styl"        # ignore
                    "!node_modules/**/*" # ignore
                ]
                tasks: ["jekyll"]

            coffee:
                files: [
                    "js/*.coffee"
                    "!js/*.src.coffee" # ignore
                ]
                tasks: ["coffee", "uglify"]

            stylus:
                files: "css/*.styl"
                tasks: ["stylus", "cssmin:mine"]

    grunt.registerTask "jekyll", ->
        done = this.async()

        grunt.util.spawn cmd: "jekyll", (error, result, code) ->
            if error
                grunt.log.error error
                done false
            else
                grunt.log.writeln result
                done true

    # load all the things
    grunt.loadNpmTasks "grunt-contrib-stylus"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-cssmin"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-coffee"

    grunt.registerTask "build", [
        "coffee" # *.coffee -> *.js
        "uglify" # *.js     -> *.min.js
        "stylus" # *.styl   -> *.css
        "cssmin" # *.css    -> *.min.css
        "jekyll"
    ]

    grunt.registerTask "default", [
        "watch"
    ]