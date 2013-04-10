module.exports = function(grunt) {
    grunt.loadNpmTasks("grunt-contrib-less");
    grunt.loadNpmTasks("grunt-contrib-watch");
    grunt.loadNpmTasks("grunt-contrib-jshint");
    grunt.loadNpmTasks("grunt-contrib-cssmin");
    grunt.loadNpmTasks('grunt-contrib-uglify');

    grunt.initConfig({
        pkg: grunt.file.readJSON("package.json"),

        uglify: {
            all: {
                files: {
                    "js/all.min.js": [
                        "js/html5shiv.js",
                        "js/bootstrap.min.js", // todo use non-minified versions of these
                        "js/util.js",
                        "js/cookie-generator.js",
                        "js/github-commits.js"
                    ]
                },
            },
        },

        cssmin: {
            all: {
                files: {
                    "css/style.min.css": [
                        "css/bootstrap.min.css",
                        "css/bootstrap-responsive.min.css",
                        "css/glyphicons.css",
                        "css/syntax.css",
                        "css/style.css",
                    ]
                },
            },
        },

        less: {
            all: {
                files: {
                    "css/style.css": "css/style.less"
                }
            },
        },

        watch: {
            files: ["**/*", "!node_modules/**/*"],
            tasks: ["jshint", "uglify", "less", "cssmin", "jekyll"]
        },

        jshint: {
            Gruntfile: {
                options: {
                    es5: true,
                },
                files: {
                    src: ["Gruntfile.js"],
                },
            },

            js: {
                options: {
                    laxbreak: true
                },
                files: {
                    src: ["js/{util,github-commits,cookie-generator}.js"]
                },
            },
        },
    });

    grunt.registerTask("jekyll", "generates jekyll", function() {
        var done = this.async();

        grunt.util.spawn({ cmd: "jekyll" }, function(error, result, code) {
            if (error)
            {
                grunt.log.error(error);
                done(false);
            }
            else
            {
                grunt.log.writeln(result);
                done(true);
            }
        });
    });

    grunt.registerTask("default", ["watch"]);
};