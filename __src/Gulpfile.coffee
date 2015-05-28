gulp = require 'gulp'

require './gulp_tasks/livereload.coffee'

require './gulp_tasks/bower_css.coffee'
require './gulp_tasks/bower_js.coffee'

require './gulp_tasks/images_min.coffee'

require './gulp_tasks/coffee.coffee'
require './gulp_tasks/js.coffee'

require './gulp_tasks/sass.coffee'
require './gulp_tasks/css.coffee'

require './gulp_tasks/jade.coffee'

# Default task call every tasks created so far.
gulp.task 'default', [
  # 'watchBowerJS'
  # 'watchBowerCSS'

  'watchSassScss'
  'watchCSS'

  'watchCoffee'
  'watchJS'

  'watchJade'

  'watchImages'
  'autoreload'
]
