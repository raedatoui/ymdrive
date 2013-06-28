class App.FileIndex extends App.BaseController

  className: 'files list'

  elements:
    '.collection': 'collectionList'
    '#back' : 'backButton'
    "#samba" : "container"

  events:
    "click #notify" : "handleNotify"
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

    @collectionList.css 'width', ''


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
  handleSync: (e) =>
    e.preventDefault()
    if !App.Folder.sambaConnected
      @notify "You need to connect to the file server first, smarty pants!"
      return

    files = App.File.findAllByAttribute('selected', true)
    counter = 0
    for file in files
      format = App.Format.findByAttribute("format",file.type)
      mimetype = format.mimetype
      data =
        "file_id": file.id
        "url": file.exportLinks[mimetype]
        "name": file.title
      if file.type != "other"
        data["extension"] = format.extension
        console.log format.extension
      $.ajax
        url: "/sync"
        type: "POST"
        data: data
      .done (response) =>
        synced_file = App.File.find(response.id)
        synced_file.synced = true
        synced_file.selected = false
        synced_file.save()
        $("##{response.id} input:checkbox").attr "disabled", "disabled"
        counter++
        if counter == files.length
          @notify "Syncing of #{files.length} file(s) complete"
          # $('.collection tbody').empty()
          # @renderList()

  handleNotify: (e) =>
    e.preventDefault()
    el = @list.getElAt 1
    console.log el
    @notify "Syncing of 6 file(s) complete"

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