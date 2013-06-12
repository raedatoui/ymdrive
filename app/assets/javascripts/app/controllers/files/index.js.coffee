class App.FileIndex extends App.BaseController

  className: 'files list'

  elements:
    '.collection': 'collectionList'
    '#back' : 'backButton'

  events:
    "click #back" : "handleBack"
    "click #refresh" : "handleRefresh"

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
    Spine.Route.setup(trigger:true)
    @collection.loaded = true
    @collection.save()
    @list.render App.File.filter @collection.id

  refilter: (collection) =>
    @collection = collection
    @filter()

  filter: ->
    if not @collection.loaded
      App.File.one 'refresh change', @renderList
      App.File.fetchByCollection @collection.id
    else
      @renderList()

  handleBack: (e) =>
    e.preventDefault()
    @navigate "/#{@collection.collection().id}"

  handleRefresh: (e) =>
    e.preventDefault()
    @collection.files.all()