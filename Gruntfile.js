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
                        "js/jquery.js",
                        "js/bootstrap.js",
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
                    "css/all.min.css": [
                        "css/bootstrap.css",
                        "css/bootstrap-responsive.css",
                        "css/glyphicons.css",
                        "css/syntax.css",
                        "css/style.css",
                    ]
                },
                options: {
                    keepSpecialComments: 0,
                }
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
            tasks: ["all"]
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

    grunt.registerTask("jekyll", function() {
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

    grunt.registerTask("all", ["jshint", "uglify", "less", "cssmin", "jekyll"]);

    grunt.registerTask("default", "watch");
    grunt.registerTask("build", "all");
};