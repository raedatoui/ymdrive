class App.Format extends Spine.Model
  @configure 'Format', 'id', 'label', 'mimetype', 'icon', 'format', 'extension'
  @extend Spine.Model.Ajax

  @FORMATS =
    document: [
      label: "HTML"
      value: "text/html"
      extension: "html"
    ,
      label: "Plain text"
      value: "text/plain"
      extension: "txt"
    ,
      label: "Rich text"
      value: "application /rtf"
      extension: "rtf"
    ,
      label: "Open Office doc"
      value: "application/vnd.oasis.opendocument.text"
      extension: "odt"
    ,
      label: "PDF"
      value: "application/pdf"
      extension: "pdf"
    ,
      label: "MS Word document"
      value: "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      extension: "docx"
    ]
    spreadsheet: [
      label: "MS Excel"
      value: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      extension: "xlsx "
    ,
      label: "Open Office sheet"
      value: "application/x-vnd.oasis.opendocument.spreadsheet"
      extension: "ods"
    ,
      label: "PDF"
      value: "application/pdf"
      extension: "pdf"
    ]
    # form: [
    #   label: "MS Excel"
    #   value: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

    # ,
    #   label: "Open Office sheet"
    #   value: "application/x-vnd.oasis.opendocument.spreadsheet"
    # ,
    #   label: "PDF"
    #   value: "application/pdf"
    # ]
    drawing: [
      label: "JPEG"
      value: "image/jpeg"
      extension: "jpg"
    ,
      label: "PNG"
      value: "image"
      extension: "png"
    ,
      label: "SVG"
      value: "image/svg+xml"
      extension: "svg"
    ,
      label: "PDF"
      value: "application/pdf"
      extension: "pdf"
    ]
    presentation: [
      label: "MS PowerPoint"
      value: "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      extension: "pptx"
    ,
      label: "Open Office, PDF"
      value: "application/pdf"
      extension: "pdf"
    ,
      label: "Plain text"
      value: "text/plain"
      extension: "txt"
    ]
    other: [
      label: "As is"
      value: "application/octet-stream"
    ]
