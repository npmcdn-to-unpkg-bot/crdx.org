module.exports = (grunt) ->
    # load all the things
    grunt.loadNpmTasks "grunt-contrib-less"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-cssmin"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-coffee"

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

        less:
            all:
                files: "css/style.css": "css/style.less"

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
                    "!css/*.less"        # ignore
                    "!node_modules/**/*" # ignore
                ]
                tasks: ["jekyll"]

            coffee:
                files: [
                    "js/*.coffee"
                    "!js/*.src.coffee" # ignore
                ]
                tasks: ["coffee", "uglify"]

            less:
                files: "css/*.less"
                tasks: ["less", "cssmin:mine"]

    grunt.registerTask "jekyll", ->
        done = this.async()

        grunt.util.spawn cmd: "jekyll", (error, result, code) ->
            if error
                grunt.log.error error
                done false
            else
                grunt.log.writeln result
                done true

    grunt.registerTask "build", [
        "coffee" # *.coffee -> *.js
        "uglify" # *.js     -> *.min.js
        "less"   # *.less   -> *.css
        "cssmin" # *.css    -> *.min.css
        "jekyll"
    ]

    grunt.registerTask "default", [
        "watch"
    ]