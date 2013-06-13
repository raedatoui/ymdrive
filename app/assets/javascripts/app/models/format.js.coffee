class App.Format extends Spine.Model
  @configure 'Format', 'id', 'label', 'mimetype', 'icon', 'format'
  @extend Spine.Model.Ajax

  @FORMATS =
    document: [
      label: "HTML"
      value: "text/html"
    ,
      label: "Plain text"
      value: "text/plain"
    ,
      label: "Rich text"
      value: "application/rtf"
    ,
      label: "Open Office doc"
      value: "application/vnd.oasis.opendocument.text"
    ,
      label: "PDF"
      value: "application/pdf"
    ,
      label: "MS Word document"
      value: "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    ]
    spreadsheet: [
      label: "MS Excel"
      value: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    ,
      label: "Open Office sheet"
      value: "application/x-vnd.oasis.opendocument.spreadsheet"
    ,
      label: "PDF"
      value: "application/pdf"
    ]
    form: [
      label: "MS Excel"
      value: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    ,
      label: "Open Office sheet"
      value: "application/x-vnd.oasis.opendocument.spreadsheet"
    ,
      label: "PDF"
      value: "application/pdf"
    ]
    drawing: [
      label: "JPEG"
      value: "image/jpeg"
    ,
      label: "PNG"
      value: "image"
    ,
      label: "SVG"
      value: "image/svg+xml"
    ,
      label: "PDF"
      value: "application/pdf"
    ]
    presentation: [
      label: "MS PowerPoint"
      value: "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    ,
      label: "Open Office, PDF"
      value: "application/pdf"
    ]
    other: [
      label: "As is"
      value: "application/octet-stream"
    ]
