unless @log
  @log = -> try console.log.apply(console, arguments)

