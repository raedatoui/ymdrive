class App.Folder extends Spine.Model
  @configure 'Folder', 'id', 'title', 'type', 'link', 'modifiedDate', 'loaded', 'collection_id', 'icon', 'file_id','owners', 'synced', 'selected'

  @extend Spine.Model.Ajax