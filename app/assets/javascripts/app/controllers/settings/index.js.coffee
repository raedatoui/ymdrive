class App.Settings extends App.BaseController

  className: "settings"

  elements:
    "#container" : "container"
  events:
    "click #back" : "handleBack"

  constructor: ->
    super
    # @el.css "opacity", 0

  render: =>
    @html @view "settings/index", {formats: App.Format.all()}
    $('.selectpicker').selectpicker()
    # @activateNext new App.SambaIndex(viewMode: "simple")

    # TweenLite.to @el, 0.75,
    #       css:
    #         opacity: 1

  doActivate: ->
    @render()
    @onActivated()

  doDeactivate: ->
    @el.remove()
    @onDeactivated()

  handleBack: (e) =>
    e.preventDefault()
    @navigate "/"