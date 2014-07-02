/*global module:false*/
var path = require('path');
var lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet;
 
var folderMount = function folderMount(connect, point) {
  return connect.static(path.resolve(point));
};
 
module.exports = function(grunt) {
 
  // Project configuration.
  grunt.initConfig({
    // Metadata.
    pkg: grunt.file.readJSON('package.json'),
 
    connect: {
      livereload: {
        options: {
          port: 9000,
          middleware: function(connect, options) {
            return [lrSnippet, folderMount(connect, '.')]
          }
        }
      }
    },
    regarde: {
      txt: {
        files: ['js/*.js', 'coffee/*.coffee', 'index.html'],
        tasks: ['coffee', 'livereload']
      },
    },
    open: {
      all: {
        // Gets the port from the connect configuration
        path: 'http://localhost:9000'
      }
    },
    coffee: {
      compile: {
        files: {
          'js/main.js': 'coffee/main.coffee', // 1:1 compile
        }
      }
    }
  });
 
  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-regarde');
  grunt.loadNpmTasks('grunt-contrib-livereload');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-open');
  grunt.loadNpmTasks('grunt-contrib-coffee');
 
  // Default task.
  grunt.registerTask('default', ['livereload-start', 'coffee', 'connect', 'open', 'regarde']);
 
};