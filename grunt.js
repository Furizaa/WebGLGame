/*
 * BindingOfSamus
 *
 * Author: Andreas Hoffmann <furizaa@gmail.com>
 */

module.exports = function(grunt) {
    'use strict'; // jsHint ;_;

    // Build configuration
    grunt.initConfig({
        pgk: '<json:package.json>',
        test: {
            all: ['test/**/*.js']
        },
        lint: {
            all: ['grunt.js']
        },
        coffeefiles_public: ['src/**/*.coffee'],
        coffee: {
            compile: {
                files: {
                    'server.js': 'server.coffee',
                    'public/js/*.js': '<config:coffeefiles_public>'
                }
            }
        },
        less: {
            core: {
                options: {
                    paths: ["assets/less"]
                },
                files: {
                    "public/css/core.css": "assets/less/core.less"
                }
            }
        },
        watch: {
            //Cafeine watcher: Run coffee on all .coffee files
            cafeine: {
                files: ['<config:coffeefiles_public>', 'server.coffee'],
                tasks: 'coffee'
            },
            lesscompiler: {
                files: ['assets/less/*.less'],
                tasks: 'less'
            }
        },
        jshint: {
            options: {
                curly: true,
                eqeqeq: true,
                immed: true,
                latedef: true,
                newcap: true,
                noarg: true,
                sub: true,
                undef: true,
                boss: true,
                eqnull: true,
                node: true,
                es5: true,
                strict: false
            },
            globals: {}
        }
    });

    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-less');

    grunt.registerTask('default', 'lint coffee less');

};