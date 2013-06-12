class App.File extends Spine.Model
  @configure 'File', 'id', 'title', 'type', 'link', 'modifiedDate', 'loaded', 'collection_id', 'icon'
  @extend Spine.Model.Ajax

  @belongsTo 'collection', 'App.File'
  @hasMany 'files', 'App.File'

  @fetchByCollection: (token, params) ->
    @ajax().ajax(
      params,
      type: 'GET',
      url:  "/files/#{token}"
    ).success (records) =>
      @refresh(records)

  @filter: (id) ->
    @all().filter (file) ->
      file.collection_id is id