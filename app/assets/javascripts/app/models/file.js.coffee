class App.File extends Spine.Model
  @configure 'File', 'id', 'title', 'type', 'link', 'modifiedDate','createdDate', 'syncedDate', 'loaded', 'collection_id', 'icon', 'file_id','owners', 'synced', 'selected'

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

  @breadcrumbs: (file) ->
    if file.collection()
      return  @breadcrumbs(file.collection()) +  " / " + "<a href='/#/#{file.id}'>" + file.title + "</a>"
    else
      return "<a href='/#/'>" + file.title + "</a>"