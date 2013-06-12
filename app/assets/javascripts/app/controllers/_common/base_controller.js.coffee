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
    # TweenLite.to @el, .5,
    #   css:
    #     left: - @el.width()
    #   onCompleted: =>
       @onDeactivated()
