module ImageUploadHandling
  extend ActiveSupport::Concern

  def resize_image_file(image_param, width:, height:)
    return unless image_param

    ImageProcessing::MiniMagick
      .source(image_param)
      .resize_to_fit(width, height)
      .call(destination: image_param.tempfile.path)
  end
end
