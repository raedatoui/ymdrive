class App.Settings extends App.BaseController

  className: "settings"

  events:
    "click #back" : "handleBack"

  constructor: ->
    super
    @el.css "opacity", 0

  render: =>
    @html @view "settings/index", {formats: App.Format.all()}
    TweenLite.to @el, 0.75,
          css:
            opacity: 1

  doActivate: ->
    App.Format.one 'refresh', @render
    App.Format.fetch()
    @onActivated()

  handleBack: (e) =>
    e.preventDefault()
    @navigate "/"