tools = require './tools.coffee'

fs  = tools.fs
log = tools.log

gulp  = tools.gulp
gutil = tools.gutil

params = tools.params

batch    = tools.batch
plumber  = tools.plumber
chokidar = tools.chokidar

coffee = tools.coffee
uglify = tools.uglify

livereload = tools.livereload

# Main Task
gulp.task 'compileCoffee', ->
  coffee_files = params.coffee.src + params.coffee.mask

  gulp.src( coffee_files )
    .pipe plumber()
    .pipe coffee( bare: true )
    .pipe uglify()
    .pipe gulp.dest(params.coffee.dest)
    .pipe livereload()
    .on 'error', gutil.log

# Watcher
gulp.task 'watchCoffee', ->
  coffee_files = params.coffee.src + params.coffee.mask

  chokidar.watch([ params.coffee.src, coffee_files ])
    .on 'ready', ->
      log 'compileCoffee::ready'
      gulp.start('compileCoffee')

    .on 'add', batch { timeout: 100 }, (events, cb) ->
      log 'compileCoffee::add'
      gulp.start('compileCoffee')
      events.on('data', log).on('end', cb)

    .on 'change', batch { timeout: 100 }, (events, cb) ->
      gulp.start('compileCoffee')
      events.on('data', log).on('end', cb)

    .on 'unlink', batch { timeout: 100 }, (events, cb) ->
      log 'compileCoffee::unlink'
      events
        .on('data', (filepath) ->
          filepath = filepath.split(params.coffee.src)[1]
          filename = filepath.replace(/coffee$/g, 'js')
          filepath = params.coffee.dest + filename

          fs.unlink filepath, (err) -> log "Deleted (File) => `#{ filepath }`"
        )
        .on('end', cb)

    .on 'addDir', batch { timeout: 100 }, (events, cb) ->
      log 'compileCoffee::linkDirs'

      gulp.start('compileCoffee')
      events.on('data', log).on('end', cb)

    .on 'unlinkDir', batch { timeout: 100 }, (events, cb) ->
      log 'compileCoffee::unlinkDirs'

      events.on('data', (dirpath) ->
        dirpath = dirpath.split(params.coffee.src)[1]
        dirpath = params.coffee.dest + dirpath

        fs.rmdir dirpath, (err) -> log "Deleted Directory => `#{ dirpath }`"
      ).on('end', cb)
