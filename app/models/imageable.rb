module Imageable

  def upload_file
    if self.image.is_a?(ActionDispatch::Http::UploadedFile)
      Dir.mkdir(Rails.root.join('public', 'uploads')) unless Dir.exist?(Rails.root.join('public', 'uploads'))
      File.open(Rails.root.join('public', 'uploads', self.image.original_filename), 'wb') do |file|
        file.write(self.image.read)
      end
      self.image = Pathname('/uploads').join(self.image.original_filename).to_s
    end
  end

  def delete_file
    if StaticImage.where(image: self.image).count == 1
      File.delete(Rails.root.join('public', self.image[1..-1]))
    end
  end

  def image_or_default
    if self.image and File.exists?(Rails.root.join('public', self.image[1..-1]))
      self.image
    else
      case self.key.to_sym
        when :horizontal
          'horizontal-banner-sample.jpg'
        when :vertical
          'vertical-banner-sample.jpg'
        when :new_1
          'new1.jpg'
        when :new_2
          'new2.jpg'
        when :new_3
          'new3.jpg'
        when :deal_1
          'deal1.jpg'
        when :deal_2
          'deal2.jpg'
        when :deal_3
          'deal3.jpg'
        when :deal_4
          'deal4.jpg'
      end
    end
  end
end