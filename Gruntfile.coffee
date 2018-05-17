module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    version_tag: 'v<%= pkg.version %>'
    comments: """
/*!
storyofmylife, a Select Box Enhancer for jQuery and Prototype
by Patrick Filler for Harvest, http://getharvest.com

Version <%= pkg.version %>
Full source at https://github.com/websitebloger/storyofmylife
Copyright (c) 2011-<%= grunt.template.today('yyyy') %> Harvest http://getharvest.com

MIT License, https://github.com/websitebloger/storyofmylife/blob/master/LICENSE.md
This file is generated by `grunt build`, do not edit it by hand.
*/
\n
"""
    minified_comments: "/* storyofmylife <%= version_tag %> | (c) 2011-<%= grunt.template.today('yyyy') %> by Harvest | MIT License, https://github.com/websitebloger/storyofmylife/blob/master/LICENSE.md */\n"

    concat:
      options:
        banner: '<%= comments %>'
      jquery:
        src: ['public/storyofmylife.jquery.js']
        dest: 'public/storyofmylife.jquery.js'
      proto:
        src: ['public/storyofmylife.proto.js']
        dest: 'public/storyofmylife.proto.js'
      css:
        src: ['public/storyofmylife.css']
        dest: 'public/storyofmylife.css'

    coffee:
      options:
        join: true
      jquery:
        files:
          'public/storyofmylife.jquery.js': ['coffee/lib/select-parser.coffee', 'coffee/lib/abstract-storyofmylife.coffee', 'coffee/storyofmylife.jquery.coffee']
      proto:
        files:
          'public/storyofmylife.proto.js': ['coffee/lib/select-parser.coffee', 'coffee/lib/abstract-storyofmylife.coffee', 'coffee/storyofmylife.proto.coffee']
      test:
        files:
          'spec/public/jquery_specs.js': 'spec/jquery/*.spec.coffee'
          'spec/public/proto_specs.js': 'spec/proto/*.spec.coffee'

    uglify:
      options:
        banner: '<%= minified_comments %>'
      jquery:
        options:
          mangle:
            except: ['jQuery']
        files:
          'public/storyofmylife.jquery.min.js': ['public/storyofmylife.jquery.js']
      proto:
        files:
          'public/storyofmylife.proto.min.js': ['public/storyofmylife.proto.js']

    sass:
      options:
        outputStyle: 'expanded'
      storyofmylife_css:
        files:
          'public/storyofmylife.css': 'sass/storyofmylife.scss'

    postcss:
      options:
        processors: [
          require('autoprefixer')(browsers: 'last 2 versions, IE 8')
        ]
      main:
        src: 'public/storyofmylife.css'

    cssmin:
      options:
        banner: '<%= minified_comments %>'
        keepSpecialComments: 0
      main:
        src: 'public/storyofmylife.css'
        dest: 'public/storyofmylife.min.css'

    watch:
      default:
        files: ['coffee/**/*.coffee', 'sass/*.scss']
        tasks: ['build', 'jasmine']
      test:
        files: ['spec/**/*.coffee']
        tasks: ['jasmine']

    jasmine:
      jquery:
        options:
          vendor: [
            'https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js'
          ]
          specs: 'spec/public/jquery_specs.js'
        src: [ 'public/storyofmylife.jquery.js' ]
      proto:
        options:
          vendor: [
            'https://ajax.googleapis.com/ajax/libs/prototype/1.7.0.0/prototype.js'
            'node_modules/simulant/dist/simulant.umd.js'
          ]
          specs: 'spec/public/proto_specs.js'
        src: [ 'public/storyofmylife.proto.js' ]

  grunt.loadTasks 'tasks'

  grunt.registerTask 'default', ['build']
  grunt.registerTask 'build', ['coffee:jquery', 'coffee:proto', 'sass', 'concat', 'uglify', 'postcss', 'cssmin']
  grunt.registerTask 'test',  ['coffee', 'jasmine']
  grunt.registerTask 'test:jquery',  ['coffee:test', 'coffee:jquery', 'jasmine:jquery']
  grunt.registerTask 'test:proto',  ['coffee:test', 'coffee:proto', 'jasmine:proto']


