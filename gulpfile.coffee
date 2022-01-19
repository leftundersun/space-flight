gulp = require 'gulp'
coffee = require 'gulp-coffee'

gulp.task 'default', () ->
  new Promise (accept, reject) ->
    try
      gulp.src [
        '*.coffee',
        '**/*.coffee',
        '!node_modules',
        '!node_modules/*',
        '!node_modules/**/*',
        '!dist',
        '!dist/*',
        '!dist/**/*',
        '!logs',
        '!logs/*',
        '!logs/**/*'
      ]
      .pipe coffee()
      .on 'error', (e) ->
        console.log e.toString()
      .pipe gulp.dest './dist'

      gulp.src [
        '*',
        '.*',
        '**/*',
        '!*.coffee',
        '!**/*.coffee',
        '!.git',
        '!.git/*',
        '!.gitignore',
        '!.dockerignore',
        '!Dockerfile',
        '!docker-compose.yml',
        '!node_modules',
        '!node_modules/*',
        '!node_modules/**/*',
        '!dist',
        '!dist/*',
        '!dist/**/*',
        '!logs',
        '!logs/*',
        '!logs/**/*'
      ], {
        'allowEmpty': true
      }
      .pipe gulp.dest './dist'

      accept()
    catch e
      console.log e.toString()
      reject e

gulp.task 'watch', () ->
  gulp.watch [
    '*.coffee',
    '**/*.coffee',
    '!node_modules/*',
    '!node_modules/**/*',
    '!dist/*',
    '!dist/**/*'
  ], gulp.series 'default'