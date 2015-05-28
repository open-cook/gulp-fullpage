path  = require 'path'
__src = "#{ __dirname }/.."
__abs = (_path) -> path.resolve(_path) + '/'

config =
  # Livereload
  livereload:
    port: 3030

  # Images
  images:
    src:  __abs "#{ __src }/app/assets/images/"
    dest: __abs "#{ __src }/../images/"
    mask: '**/*'

  # Bower params
  bower:
    src: __abs "#{ __src }/bower_components/"

    css_mask: '**/*.css'
    css_file: 'base.css'
    dest_css: __abs "#{ __src }/../stylesheets/"

    js_mask: '**/*.js'
    js_file: 'base.js'
    dest_js: __abs "#{ __src }/../javascripts/"

  # JavaScript
  js:
    src:  __abs "#{ __src }/app/assets/javascripts/"
    dest: __abs "#{ __src }/../javascripts/"

    mask: "**/*.js"

  # CoffeeScript
  coffee:
    src:  __abs "#{ __src }/app/assets/javascripts/"
    dest: __abs "#{ __src }/../javascripts/"

    mask: "**/*.coffee"

  # CSS
  css:
    src:  __abs "#{ __src }/app/assets/stylesheets/"
    dest: __abs "#{ __src }/../stylesheets/"

    mask: "**/*.css"

  # SASS
  sass:
    src:  __abs "#{ __src }/app/assets/stylesheets/"
    dest: __abs "#{ __src }/../stylesheets/"

    mask_sass: "**/*.sass"
    mask_scss: "**/*.scss"

  # JADE
  jade:
    layouts_src: __abs "#{ __src }/app/views/HTML/"
    src:  __abs "#{ __src }/app/views/layouts/"
    dest: __abs "#{ __src }/../"

    mask: "**/*.jade"

module.exports = config
