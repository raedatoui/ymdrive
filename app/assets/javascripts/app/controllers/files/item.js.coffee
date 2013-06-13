class App.FileItem extends App.BaseController

  tag: 'tr'

  className: 'file-item item'

  events:
    'click .delete': 'destroy'
    'click .title' : 'show'

  prepareWithModel: (model) ->
    @model = model
    @render()

  doDeactivate: ->
    @el.remove()
    @onDeactivated()

  render: ->
    @html @view("files/item", @model)

  show: ->
    if @model.type == "folder"
      Spine.trigger "loadCollection", @model

  destroy: ->
    if confirm("\"#{@model.title}\" will be permanently removed. Continue?")
      @model.destroy()
      @deactivate()
