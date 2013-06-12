Spine.Controller.include
  view: (name,data={}) ->
    JST["app/views/#{name}"](data)