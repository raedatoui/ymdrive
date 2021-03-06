#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route
#= require spine/relation

#= require modernizr-2.6.2.min
#= require jquery_ujs
#= require exo
#= require exo.spine
#= require TweenMax.min
#= require hamlcoffee
#= require moment.min
#= require simple.widget
#= require mouse.widget
#= require tree.jquery
#= require twitter/bootstrap
#= require bootstrap-select.min

#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

class App extends Spine.Controller

  elements:
    ".left" : "leftContainer"
    ".right" : "rightContainer"

  constructor: ->
    super

    rootCollection = new App.File
    rootCollection.type = "folder"
    rootCollection.title = "Home"
    rootCollection.id = "root"
    rootCollection.save({ajax:false})

    @routes
      '/settings': (params) ->
        @sambaIndex.el.hide()
        @current.el.hide()
        $('.separator').hide()

        @settings =  new App.Settings
        @append @settings
        @settings.activate()

      '/:token': (params) ->
        if @settings
          @settings.deactivate()
        @sambaIndex.el.show()
        if @current
          @current.el.show()
        $('.separator').show()

        if params.token != "settings"
          id = if params.token == "" then "root" else params.token
          collection = App.File.findByAttribute('id', id)
          if @current and @current.constructor.name == "FileIndex"
            @current.refilter collection
          else
            @current.deactivate() if @current
            @activateNext new App.FileIndex
              collection: collection

    if Spine.Route.getPath() == ""
      @activateNext new App.FileIndex
        collection: rootCollection


    @sambaIndex = new App.SambaIndex
    @sambaIndex.appendTo @leftContainer
    @sambaIndex.activate()

    App.Format.one 'refresh', =>
      Spine.Route.setup(trigger:true)
    App.Format.fetch()


  activateNext: (next) ->
    unless @next
      @next = next
      @next.one "onDeactivated", @onControllerDeactivated
      @next.one "onActivated", @onControllerActivated
      @next.appendTo @rightContainer
      @next.activate()

  onControllerActivated: (controller) =>
    @current = controller
    @next = null
    @current.resize()

  onControllerDeactivated: (controller) =>
    # @removeChild controller
    controller.release()

window.App = App
