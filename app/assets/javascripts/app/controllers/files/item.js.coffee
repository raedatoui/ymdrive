class App.FileItem extends App.BaseController

  tag: 'tr'

  className: 'file-item item'

  elements:
    "#synced" : "checkBox"

  events:
    'click .delete': 'destroy'
    'click .title' : 'show'
    'click #synced' : 'prepareSync'

  prepareWithModel: (model) ->
    @model = model
    @render()

  doDeactivate: ->
    @el.remove()
    @onDeactivated()

  render: ->
    @html @view("files/item", @model)
    if @model.synced
      @checkBox.attr "checked", "checked"
      @checkBox.attr "disabled", "disabled"

  show: ->
    # if @model.type == "folder"
    #   Spine.trigger "loadCollection", @model , "fwd"

  destroy: ->
    if confirm("\"#{@model.title}\" will be permanently removed. Continue?")
      @model.destroy()
      @deactivate()

  prepareSync: ->
    @model.selected = @checkBox.is(':checked')
    @model.save()