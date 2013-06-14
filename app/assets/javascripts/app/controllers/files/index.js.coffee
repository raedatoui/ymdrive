class App.FileIndex extends App.BaseController

  className: 'files list'

  elements:
    '.collection': 'collectionList'
    '#back' : 'backButton'

  events:
    "click #back" : "handleBack"
    "click #refresh" : "handleRefresh"
    "click #settings" : "handleSettings"
    "click #sync" : "handleSync"

  constructor: ->
    super
    @filter()
    Spine.bind "loadCollection", (item) =>
      @collection = item
      @filter()

  prepare: ->
    @render()
    @list = new App.BasicList
      controller: App.FileItem
      el: @collectionList

  render: =>
    console.log "here", @collection
    @html @view "files/index",
      collection: @collection

  renderList: =>
    $("#cursor-loader").remove()
    # @collectionList.show()
    if not @collection.loaded
      @collection.loaded = true
      @collection.save()
    @list.render App.File.filter @collection.id

  refilter: (collection) =>
    @collection = collection
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
    TweenLite.to @collectionList, 0.75,
      css:
        left: 0
      onComplete: =>
        @onActivated()

  doDeactivate: ->
    TweenLite.to @collectionList, 0.75,
      css:
        left: - @el.width()
      onComplete: =>
        @el.remove()
        @onDeactivated()