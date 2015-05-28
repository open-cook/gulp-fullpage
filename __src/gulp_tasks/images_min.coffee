tools = require './tools.coffee'

fs  = tools.fs
log = tools.log

gulp  = tools.gulp
gutil = tools.gutil

params = tools.params

batch    = tools.batch
plumber  = tools.plumber
chokidar = tools.chokidar

imagemin = tools.imagemin
pngquant = tools.pngquant

livereload = tools.livereload

# Main Task
gulp.task 'optimizeImages', ->
  images = params.images.src + params.images.mask

  gulp.src( images )
    .pipe plumber()
    .pipe imagemin(
        progressive: true
        use: [ pngquant() ]
        svgoPlugins: [{ removeViewBox: false }]
    )
    .pipe gulp.dest(params.images.dest)
    .pipe livereload()
    .on 'error', gutil.log

# Watcher
gulp.task 'watchImages', ->
  images_files = params.images.src + params.images.mask

  chokidar.watch([ params.images.src, images_files ])
    .on 'ready', ->
      log 'optimizeImages::ready'
      gulp.start('optimizeImages')

    .on 'add', batch { timeout: 100 }, (events, cb) ->
      log 'optimizeImages::add'

      gulp.start('optimizeImages')
      events.on('data', log).on('end', cb)

    .on 'change', batch { timeout: 100 }, (events, cb) ->
      log 'optimizeImages::change'

      gulp.start('optimizeImages')
      events.on('data', log).on('end', cb)

    .on 'unlink', batch { timeout: 100 }, (events, cb) ->
      log 'optimizeImages::unlink'

      events
        .on('data', (filepath) ->
          filename = filepath.split(params.images.src)[1]
          filepath = params.images.dest + filename

          fs.unlink filepath, (err) -> log "Deleted (File) => `#{ filepath }`"
        )
        .on('end', cb)

    .on 'addDir', batch { timeout: 100 }, (events, cb) ->
      log 'optimizeImages::linkDirs'

      gulp.start('optimizeImages')
      events.on('data', log).on('end', cb)

    .on 'unlinkDir', batch { timeout: 100 }, (events, cb) ->
      log 'optimizeImages::unlinkDirs'

      events.on('data', (dirpath) ->
        dirpath = dirpath.split(params.images.src)[1]
        dirpath = params.images.dest + dirpath

        fs.rmdir dirpath, (err) -> log "Deleted (Directory) `#{ dirpath }`"
      ).on('end', cb)
