tools = require './tools.coffee'

fs   = tools.fs
log  = tools.log

gulp  = tools.gulp
gutil = tools.gutil

params = tools.params

batch    = tools.batch
plumber  = tools.plumber
chokidar = tools.chokidar

jade    = tools.jade
minHTML = tools.minHTML

livereload = tools.livereload

# Main Task
gulp.task 'compileJade', ->
  jade_files    = params.jade.src + params.jade.mask
  layouts_files = params.jade.layouts_src + params.jade.mask

  gulp.src([ jade_files, layouts_files ])
    .pipe plumber()
    .pipe jade(pretty: true)
    # .pipe minHTML( conditionals: true, spare: true )
    .pipe gulp.dest(params.jade.dest)
    .pipe livereload()
    .on 'error', gutil.log

# Watcher
gulp.task 'watchJade', ->
  jade_files    = params.jade.src + params.jade.mask
  layouts_files = params.jade.layouts_src + params.jade.mask

  chokidar.watch([ params.jade.src, layouts_files, jade_files ])
    .on 'ready', ->
      log 'compileJade::ready'
      gulp.start('compileJade')

    .on 'add', batch { timeout: 100 }, (events, cb) ->
      log 'compileJade::add'

      gulp.start('compileJade')
      events.on('data', log).on('end', cb)

    .on 'change', batch { timeout: 100 }, (events, cb) ->
      log 'compileJade::change'

      gulp.start('compileJade')
      events.on('data', log).on('end', cb)

    .on 'unlink', batch { timeout: 100 }, (events, cb) ->
      log 'compileJade::unlink'

      events
        .on('data', (filepath) ->
          filename = filepath.split(params.jade.src)[1]
          filename = filename.replace(/jade$/g, 'html')
          filepath = params.jade.dest + filename

          fs.unlink filepath, (err) -> log "Deleted (File) => `#{ filepath }`"
        )
        .on('end', cb)

    .on 'addDir', batch { timeout: 100 }, (events, cb) ->
      log 'compileJade::linkDirs'

      gulp.start('compileJade')
      events.on('data', log).on('end', cb)

    .on 'unlinkDir', batch { timeout: 100 }, (events, cb) ->
      log 'compileJade::unlinkDirs'

      events.on('data', (dirpath) ->
        dirpath = dirpath.split(params.jade.src)[1]
        dirpath = params.jade.dest + dirpath

        fs.rmdir dirpath, (err) -> log "Deleted (Directory) `#{ dirpath }`"
      ).on('end', cb)
