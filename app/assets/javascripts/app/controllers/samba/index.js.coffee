class App.SambaIndex extends App.BaseController

  className: 'samba-index'

  events:
    "click #samba" : "connectSamba"

  constructor: ->
     super
     throw '@viewMode required' unless @viewMode
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
    if @viewMode is "simple"
      @html @view "samba/connected", data
    else
      @html @view "samba/index"

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