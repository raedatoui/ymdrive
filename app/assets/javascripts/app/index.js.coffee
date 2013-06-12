#= require json2
#= require jquery
#= require spine/spine
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

#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

class App extends Exo.Spine.Controller

  constructor: ->
    super

    @routes
      '/:token': (params) ->
        collection = App.File.findByAttribute('id', params.token)
        if collection
          @activateNext new App.FileIndex
            collection: collection


    rootCollection = new App.File
    rootCollection.type = "folder"
    rootCollection.title = "root"
    rootCollection.id = "root"
    rootCollection.save()
    @activateNext new App.FileIndex
      collection: rootCollection


  activateNext: (next) ->
    unless @next
      @next = next
      @next.one "onDeactivated", @onControllerDeactivated
      @next.one "onActivated", @onControllerActivated
      @append @next
      @addChild @next
      @next.activate()

  onControllerActivated: (controller) =>
    @current = controller
    @next = null
    @current.resize()

  onControllerDeactivated: (controller) =>
    @removeChild controller
    controller.release()

window.App = App
