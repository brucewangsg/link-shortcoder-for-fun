class Link < ApplicationRecord

  def shortcode # deterministic shortcode with based on id that get converted into base36
    self.class.shortcode_from_id(self.id)
  end

  def self.shortcode_from_id(id)
    code = id.to_s(36)
    if id < 46656 # 36**3
      pad = '0' * (3 - code.size)
    end
    self.randomize(pad + code)
  end

  def self.randomize(code)
    code.split('').map.with_index do |chr, i|
      if i % 2
        (35 - ((chr.to_i(36) + 18) % 36)).to_s(36)
      elsif i % 3
        (35 - ((chr.to_i(36) + 12) % 36)).to_s(36)
      elsif i % 5
        (35 - ((chr.to_i(36) + 24) % 36)).to_s(36)
      else
        (35 - chr.to_i(36)).to_s(16)
      end
    end.join('')
  end

  def self.unrandomize(code)
    code.downcase.split('').map.with_index do |chr, i|
      if i % 2
        (((35 - chr.to_i(36)) + 36 - 18) % 36).to_s(36)
      elsif i % 3
        (((35 - chr.to_i(36)) + 36 - 12) % 36).to_s(36)
      elsif i % 5
        (((35 - chr.to_i(36)) + 36 - 24) % 36).to_s(36)
      else
        (35 - chr.to_i(36)).to_s(16)
      end
    end.join('')
  end

  def self.resolve_id(shortcode)
    self.unrandomize(shortcode).sub(/^0+/,'').to_i(36)
  end

end
