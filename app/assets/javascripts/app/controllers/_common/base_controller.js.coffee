class App.BaseController extends Exo.Spine.Controller

  resize: ->

  notify: (text) ->
    notification = $('<div class="notification">')
    notification.text text
    $('#notifications').append notification
    setTimeout ->
        notification.fadeOut 400, ->
          $(this).remove()
      , 2000


  doActivate: ->
    @onActivated()

  doDeactivate: ->
    @el.remove()
    @onDeactivated()


  activateNext: (next) ->
    unless @next
      @next = next
      @next.one "onDeactivated", @onControllerDeactivated
      @next.one "onActivated", @onControllerActivated
      #@append @next
      @next.appendTo @container
      @addChild @next
      @next.activate()

  onControllerActivated: (controller) =>
    @current = controller
    @next = null
    @current.resize()

  onControllerDeactivated: (controller) =>
    @removeChild controller
    controller.release()