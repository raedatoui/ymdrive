class App.FileItem extends App.BaseController

  tag: 'tr'

  className: 'file-item item'

  elements:
    ".synced" : "checkBox"
    ".selector" : "selector"
    "td"        : "cells"

  events:
    'click .title' : 'show'
    'click .synced' : 'prepareSync'

  prepareWithModel: (model) ->
    @model = model

    # Spine.Ajax.disable =>
    #   @model.destroy()

    @model.bind "refresh", =>
      console.log  "tooooooo"
    @render()

  doDeactivate: ->
    @el.remove()
    @onDeactivated()

  render: ->
    @html @view("files/item", @model)
    @el.attr "id", @model.id
    if @model.synced
      @el.addClass "synced"
      @cells.addClass "synced"
      # @checkBox.attr "checked", "checked"
      # @checkBox.attr "disabled", "disabled"

  show: ->
    # if @model.type == "folder"
    #   Spine.trigger "loadCollection", @model , "fwd"

  destroy: ->
    if confirm("\"#{@model.title}\" will be permanently removed. Continue?")
      @model.destroy()
      @deactivate()

  select: =>
    if @model.type != "folder"
      @checkBox.attr "checked", true
      @prepareSync()

  prepareSync: ->
    @model.selected = @checkBox.is(':checked')
    @model.save({ajax:false})
    if @checkBox.is(':checked')
      @selector.empty()
      @selector.append @view("files/format_selector", @model)
      $(".selectpicker").selectpicker()
    else
      @selector.empty()