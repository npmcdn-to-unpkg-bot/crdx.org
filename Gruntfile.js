module.exports = function(grunt) {
    grunt.loadNpmTasks("grunt-contrib-less");
    grunt.loadNpmTasks("grunt-contrib-watch");
    grunt.loadNpmTasks("grunt-contrib-jshint");
    grunt.loadNpmTasks("grunt-contrib-cssmin");
    grunt.loadNpmTasks('grunt-contrib-uglify');

    grunt.initConfig({
        pkg: grunt.file.readJSON("package.json"),

        /*
        uglify: {
            all: {
                files: {
                    "js/all.min.js": [
                        // third party
                        "js/jquery.js",
                        "js/bootstrap.js",

                        // mine
                        "js/util-jsh.js",
                        "js/cookie-generator-jsh.js",
                        "js/github-commits-jsh.js"
                    ]
                },
            },
        },

        cssmin: {
            all: {
                files: {
                    "css/all.min.css": [
                        // third party
                        "css/bootstrap.css",
                        "css/bootstrap-responsive.css",
                        "css/glyphicons.css",
                        "css/syntax.css",

                        // mine
                        "css/style.css",
                    ]
                },
                options: {
                    keepSpecialComments: 0,
                }
            },
        },
        */

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
                    src: ["js/{util,page-*}.js"]
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

    grunt.registerTask("all", ["jshint", /*"uglify",*/ "less", /*"cssmin",*/ "jekyll"]);

    grunt.registerTask("default", "watch");
    grunt.registerTask("build", "all");
};