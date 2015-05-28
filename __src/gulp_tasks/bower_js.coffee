tools = require './tools.coffee'

fs  = tools.fs
log = tools.log

gulp  = tools.gulp
gutil = tools.gutil

params = tools.params

batch    = tools.batch
plumber  = tools.plumber
chokidar = tools.chokidar

concat = tools.concat
uglify = tools.uglify
mainBowerFiles = tools.mainBowerFiles

livereload = tools.livereload

# Main Task
gulp.task 'compileBowerJS', ->
  dest_file = params.bower.js_file
  js_mask   = params.bower.js_mask
  js_files  = mainBowerFiles(js_mask)

  if js_files.length is 0
    filepath = [ params.bower.dest_js, dest_file ].join('/')
    fs.unlink filepath, (err) -> log "Deleted (File) => `#{ dest_file }`"
  else
    gulp.src(js_files, { base: params.bower.src })
      .pipe plumber()
      .pipe concat(dest_file)
      .pipe uglify()
      .pipe gulp.dest(params.bower.dest_js)
      .pipe livereload()
      .on 'error', gutil.log

# Watcher
gulp.task 'watchBowerJS', ->
  js_files = params.bower.src + params.bower.js_mask

  chokidar.watch([ params.bower.src, js_files ])
    .on 'ready', ->
      log 'watchBower::ready'
      gulp.start('compileBowerJS')

    .on 'addDir', batch { timeout: 100 }, (events, cb) ->
      log 'watchBower::linkDirs'

      gulp.start('compileBowerJS')
      events.on('data', log).on('end', cb)

    .on 'unlinkDir', batch { timeout: 100 }, (events, cb) ->
      log 'watchBower::unlinkDirs'

      gulp.start('compileBowerJS')
      events.on('data', log).on('end', cb)
