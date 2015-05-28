tools = require './tools.coffee'

fs  = tools.fs
log = tools.log

gulp  = tools.gulp
gutil = tools.gutil

params = tools.params

batch    = tools.batch
plumber  = tools.plumber
chokidar = tools.chokidar

mainBowerFiles = tools.mainBowerFiles

concat = tools.concat
minCSS = tools.minCSS

postcss         = tools.postcss
autoprefixer    = tools.autoprefixer
postcss_opacity = tools.postcss_opacity

livereload = tools.livereload

# Main Task
gulp.task 'compileBowerCSS', ->
  dest_file = params.bower.css_file
  css_mask  = params.bower.css_mask
  css_files = mainBowerFiles(css_mask)

  if css_files.length is 0
    filepath = [ params.bower.dest_css, dest_file ].join('/')
    fs.unlink filepath, (err) -> log "Deleted (File) => `#{ dest_file }`"
  else
    gulp.src(css_files, { base: params.bower.src })
      .pipe plumber()
      .pipe concat(dest_file)
      .pipe minCSS( keepBreaks:true )
      .pipe postcss [
        autoprefixer( browsers: ['last 3 version'] )
        postcss_opacity
      ]
      .pipe gulp.dest(params.bower.dest_css)
      .pipe livereload()
      .on 'error', gutil.log

# Watcher
gulp.task 'watchBowerCSS', ->
  css_files = params.bower.src + params.bower.css_mask

  chokidar.watch([ params.bower.src, css_files ])
    .on 'ready', ->
      log 'watchBower::ready'
      gulp.start('compileBowerCSS')

    .on 'addDir', batch { timeout: 100 }, (events, cb) ->
      log 'watchBower::linkDirs'

      gulp.start('compileBowerCSS')
      events.on('data', log).on('end', cb)

    .on 'unlinkDir', batch { timeout: 100 }, (events, cb) ->
      log 'watchBower::unlinkDirs'

      gulp.start('compileBowerCSS')
      events.on('data', log).on('end', cb)

