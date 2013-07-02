class App.SambaIndex extends App.BaseController

  className: 'samba-index'

  events:
    "click #sambabtn" : "connectSamba"

  constructor: ->
     super
     @render()

  render: =>
     $.ajax
      url: "/connected"
      type: "GET"
      success: (data) =>
        if not data.connected
          @html @view "samba/form"
        else
          @renderView data

  renderView: (data) =>
    App.Folder.sambaConnected = true

    @el.append @view("common/cursor")

    App.Folder.bind "refresh", =>
      @html @view "samba/index"
      $("#cursor-loader").remove()

      $("#tree1").tree
        data: App.Folder.all()
        # dragAndDrop: true

      $("#tree1").bind "tree.select", (event) ->
        if event.node
          # node was selected
          node = event.node
          App.Folder.selectedLocation = node.id


    App.Folder.fetch()

  connectSamba: =>
    data =
      username: $("#inputUser").val()
      password: $("#inputPassword").val()

    $.ajax
      url: "/connect"
      data: data
      type: "POST"
      success: (data) =>
        @renderView data