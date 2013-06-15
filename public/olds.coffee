# coding: utf-8

URL = '/list'
MAX_POPUP = 10
ARCHIVE_DOMAIN = 'http://web.archive.org'

g_list = []
g_interval = null
g_popups = []
g_popups_index = 0
g_loading = true
g_z_index = 1
g_window_width = 0
g_window_height = 0

init = ()->
  # ウィンドウサイズ監視
  resize()
  $(window).resize(resize)

  # 要素の準備
  parent = $('#news')
  element = parent.find('li')
  g_popups.push element
  for i in [0 ... MAX_POPUP - 1]
    clone = element.clone(true)
    g_popups.push clone
    clone.appendTo(parent)

  loadList() # load start
  g_interval = setInterval(startPopup, 1500)

resize = ()->
  w = $(window)
  g_window_width = w.width()
  g_window_height = w.height()

loadList = ()->
  g_loading = true
  $.post(URL, {}, (data)->
      g_loading = false
      g_list = g_list.concat(JSON.parse(data))
    )

startPopup = ()->
  data = g_list.shift()
  element = g_popups[g_popups_index]
  element.find('a').attr('href', ARCHIVE_DOMAIN + data.key)
  element.find('.date').text(data.date)
  element.find('.title').text(data.title)
  width = element.outerWidth()
  height = element.outerHeight()
  x = Math.floor(Math.random() * (g_window_width - width))
  y = Math.floor(Math.random() * (g_window_height - height))
  element.css({
      'left': x,
      'top': y,
      'z-index': g_z_index
    })
  #element.fadeIn(1500).delay(5000).fadeOut(1500)
  element.addClass('animation').delay(7000).queue((next)->
      $(this).removeClass('animation')
      next()
    )

  g_z_index += 1
  g_popups_index = (g_popups_index + 1) % MAX_POPUP
  if g_loading == false and g_list < 10
    loadList()

window.onload = ()->
  init()
  $('#social-button .twitter').socialbutton('twitter', {
      button: 'horizontal'
    })
  $('#social-button .hatebu').socialbutton('hatena')
