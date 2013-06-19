class App.Folder extends Spine.Model
  @configure 'Folder', 'id', 'title', 'modifiedDate'

  @extend Spine.Model.Ajax

  @url: "/samba"