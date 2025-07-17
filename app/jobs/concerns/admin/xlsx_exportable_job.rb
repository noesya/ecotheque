module Admin::XlsxExportableJob
  extend ActiveSupport::Concern

  def create_export(user, xlsx, filename)
    export = Admin::FileExport.new(user: user)
    export.file.attach({
      io: StringIO.new(xlsx),
      filename: filename,
      content_type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    })
    export.save
    export
  end
end