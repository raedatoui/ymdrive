class App.BasicList extends Exo.Spine.List

 render: (collection, opts={}) ->
   super(collection, opts)
   if collection.length == 0
     @el.addClass "empty-list"
   # $(".selectpicker").selectpicker()

  # prepare: ->
  #   @bind 'afterRender', @reorganizeDOM

  # getOrCreateChild: (item, controller) ->
  #   child = @childById(item.constructor.className + item.id)
  #   unless child
  #     child = new controller
  #     child.setNodeId(item.constructor.className + item.id)
  #     @addChild child
  #     child.prepareWithParams item, @el
  #     child.bind 'select', (model, el)=>
  #       @trigger 'select', model, el
  #   return child

  # deactivateAndKillOrphans: (children, collection) ->
  #   orphans = children.filter (child) -> child.id not in collection.map (item) -> item.constructor.className + item.id
  #   for orphan in orphans
  #     orphan.deactivate()

  # reorganizeDOM: =>
  #   getElAt = (index) =>
  #     model = @collection[index]
  #     child = @childById("#{model.constructor.className}#{model.id}")
  #     return child.el

  #   for model, index in @collection
  #     if el = getElAt(index)
  #       if index == 0
  #         $(@el).prepend(el)
  #       else
  #         prev = getElAt(index-1)
  #         el.insertAfter(prev)