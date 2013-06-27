class App.FileIndex extends App.BaseController

  className: 'files list'

  elements:
    '.collection': 'collectionList'
    '#back' : 'backButton'
    "#samba" : "container"

  events:
    "click #back" : "handleBack"
    "click #refresh" : "handleRefresh"
    "click #settings" : "handleSettings"
    "click #sync" : "handleSync"

  c = {}

  constructor: ->
    super
    @filter()


  prepare: ->
    @render()
    @list = new App.BasicList
      controller: App.FileItem
      el: @collectionList

  render: =>
    @html @view "files/index",
      collection: @collection

    $(window).on 'resize', @resize
    @collectionList.css 'width', ''
    @resize()

  renderList: =>
    $("#cursor-loader").remove()
    # @collectionList.show()
    if not @collection.loaded
      @collection.loaded = true
      @collection.save()
    @list.render App.File.filter @collection.id

    $(".collection tr").draggable
      helper: "clone"
      start: (event, ui) =>
        c.tr = this
        c.helper = ui.helper


  refilter: (collection) =>
    @collection = collection
    @prepare()
    @filter()

  filter: ->
    if not @collection.loaded
      # @collectionList.hide()
      @el.append @view("common/cursor")
      App.File.one 'refresh change', @renderList
      App.File.fetchByCollection @collection.id
    else
      @renderList()

  handleBack: (e) =>
    e.preventDefault()
    @navigate "/#{@collection.collection().id}"

  handleRefresh: (e) =>
    e.preventDefault()
    files = App.File.findAllByAttribute("collection_id",@collection.id)
    for f in files
      f.destroy()
    @renderList()
    @collection.loaded = false
    @collection.save()
    @filter()

  handleSettings: (e) =>
    @naviate "/settings"

  #TODO: refactor refresh technique
  handleSync: =>
    files = App.File.findAllByAttribute('selected', true)
    counter = 0
    for file in files
      $.ajax
        url: "/sync"
        type: "POST"
        data: {"file_id": file.id, "url":file.exportLinks["application/pdf"]}
      .done (response) =>
        file.synced = true
        file.save()
        counter++
        if counter == files.length
          $('.collection tbody').empty()
          @renderList()

  doActivate: ->
    TweenLite.to @collectionList, 0.5,
      css:
        opacity: 1
      delay: .25
      onComplete: =>
        @onActivated()

  doDeactivate: ->
    TweenLite.to @collectionList, 0.5,
      css:
        opacity: 0
      onComplete: =>
        @el.remove()
        @onDeactivated()

  resize: =>
    @collectionList.css "width", "#{@el.width()- 320}px"