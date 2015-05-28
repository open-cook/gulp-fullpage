tools = require './tools.coffee'

fs   = tools.fs
log  = tools.log

gulp  = tools.gulp
gutil = tools.gutil

params = tools.params

batch    = tools.batch
plumber  = tools.plumber
chokidar = tools.chokidar

uglify     = tools.uglify
livereload = tools.livereload

# Main Task
gulp.task 'copyJS', ->
  js_files = params.js.src + params.js.mask

  gulp.src([ js_files ])
    .pipe plumber()
    .pipe uglify()
    .pipe gulp.dest(params.js.dest)
    .pipe livereload()
    .on 'error', gutil.log

# Watcher
gulp.task 'watchJS', ->
  js_files = params.js.src + params.js.mask

  chokidar.watch([ params.js.src, js_files ])
    .on 'ready', ->
      log 'copyJS::ready'
      gulp.start('copyJS')

    .on 'add', batch { timeout: 100 }, (events, cb) ->
      log 'copyJS::add'

      gulp.start('copyJS')
      events.on('data', log).on('end', cb)

    .on 'change', batch { timeout: 100 }, (events, cb) ->
      log 'copyJS::change'

      gulp.start('copyJS')
      events.on('data', log).on('end', cb)

    .on 'unlink', batch { timeout: 100 }, (events, cb) ->
      log 'copyJS::unlink'

      events
        .on('data', (filepath) ->
          filename = filepath.split(params.js.src)[1]
          filepath = params.js.dest + filename
          fs.unlink filepath, (err) -> log "Deleted (File) => `#{ filepath }`"
        )
        .on('end', cb)

    .on 'addDir', batch { timeout: 100 }, (events, cb) ->
      log 'copyJS::linkDirs'

      gulp.start('copyJS')
      events.on('data', log).on('end', cb)

    .on 'unlinkDir', batch { timeout: 100 }, (events, cb) ->
      log 'copyJS::unlinkDirs'

      events.on('data', (dirpath) ->
        dirpath = dirpath.split(params.js.src)[1]
        dirpath = params.js.dest + dirpath

        fs.rmdir dirpath, (err) -> log "Deleted (Directory) `#{ dirpath }`"
      ).on('end', cb)
