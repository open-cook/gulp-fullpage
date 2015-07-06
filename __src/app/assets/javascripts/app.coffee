@LandingSections = do ->
  size_fit: ->
    @win  ||= $ window
    @doc  ||= $ document
    @body ||= $ 'body'

    log 'resize'

    win_w = @win.outerWidth(true)
    win_h = @win.outerHeight(true)
    $('@landing-section').css { 'min-height': win_h }

@AutoScrollToActive = do ->
  go: (callback) ->
    html     = $ 'html'
    sections = $('@landing-section')

    # find active section
    current_scroll = html.scrollTop()
    active_section = $('@landing-section').first()
    section_hdiff  = Math.abs(current_scroll - active_section.offset().top)

    for section in sections
      section = $ section

      diff = Math.abs current_scroll - section.offset().top

      if diff <= section_hdiff
        section_hdiff  = diff
        active_section = section

    sections.removeClass    'active-section'
    active_section.addClass 'active-section'

    as_top = active_section.offset().top
    html.stop(true,true).animate({ scrollTop: as_top }, 2000, 'linear', -> callback() if callback)

$(window).resize throttle ->
    LandingSections.size_fit()
    $(window).disablescroll()
    AutoScrollToActive.go -> $(window).disablescroll('undo')
  , 100

$(window).scroll debounce ->
  $(window).disablescroll()
  AutoScrollToActive.go -> $(window).disablescroll('undo')
, 400

$ ->
  LandingSections.size_fit()
