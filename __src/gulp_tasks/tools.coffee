'use strict'

module.exports =
  # App params
  params: require './_params'

  # `console.log` shortcut
  log: require './log.coffee'

  # Events debounce
  batch: require 'gulp-batch'
  # Watcher => events: ready add change unlink addDir unlinkDir raw error
  chokidar: require 'chokidar'
  # Gulp - don't panic!
  plumber: require 'gulp-plumber'
  # Page autoreload
  livereload: require 'gulp-livereload'

  # Base
  fs:    require 'fs'
  path:  require 'path'
  gulp:  require 'gulp'
  gutil: require 'gulp-util'

  # Images
  imagemin: require 'gulp-imagemin'
  pngquant: require 'imagemin-pngquant'

  # Common
  concat: require 'gulp-concat' # files
  uglify: require 'gulp-uglify' # JS

  # Coffee
  coffee:  require 'gulp-coffee'

  # SCSS/CSS
  sass:         require 'gulp-sass'
  minCSS:       require 'gulp-minify-css'

  # https://github.com/ai
  postcss:         require 'gulp-postcss'
  postcss_opacity: require 'postcss-opacity'
  autoprefixer:    require 'autoprefixer-core'

  # JADE/HTML
  jade:    require 'gulp-jade'
  minHTML: require 'gulp-minify-html'

  # Bower/Vendors
  mainBowerFiles: require 'main-bower-files'
