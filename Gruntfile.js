module.exports = function(grunt) {
    grunt.loadNpmTasks("grunt-contrib-less");
    grunt.loadNpmTasks("grunt-contrib-watch");
    grunt.loadNpmTasks("grunt-contrib-jshint");

    grunt.initConfig({
        pkg: grunt.file.readJSON("package.json"),

        less: {
            dist: {
                files: {
                    "css/style.css": "css/style.less"
                },
                options: {
                    yuicompress: true
                }
            },

            dev: {
                files: {
                    "css/style.css": "css/style.less"
                }
            }
        },

        watch: {
            files: ["**/*", "!node_modules/**/*"],
            tasks: ["jshint", "less:dist", "jekyll"]
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