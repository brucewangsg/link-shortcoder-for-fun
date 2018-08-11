class Link < ApplicationRecord

  def shortcode # deterministic shortcode with based on id that get converted into base36
    self.class.shortcode_from_id(self.id)
  end

  def self.shortcode_from_id(id)
    code = id.to_s(36)
    pad = ''
    if id < 46656 # 36**3
      pad = '0' * (3 - code.size)
    end
    self.randomize(pad + code)
  end

  def self.randomize(code)
    first_char = 0
    code.split('').reverse.map.with_index do |chr, i|
      if i == 0
        v = chr.to_i(36)
        first_char = v
        v = v*3; v+=(v>=72?2:(v>=36?1:0)); 
        v += 18;
        (35 - (v % 36)).to_s(36)
      elsif i % 2 || i == 1
        v = chr.to_i(36)
        v = v*2; v+=(v>=36?1:0); 
        v += 24 + (i == 1 ? first_char % 3 : first_char % 2);
        (35 - (v % 36)).to_s(36)
      elsif i % 3
        (35 - ((chr.to_i(36) + 12) % 36)).to_s(36)
      elsif i % 5
        (35 - ((chr.to_i(36) + 24) % 36)).to_s(36)
      else
        (35 - chr.to_i(36)).to_s(16)
      end
    end.join('').reverse
  end

  def self.unrandomize(code)
    first_char = 0
    code.downcase.split('').reverse.map.with_index do |chr, i|
      if i == 0
        first_char = 
        v = chr.to_i(36)
        v = ((35 - chr.to_i(36)) + 36 - 18) % 36
        m = v % 3
        v = (v + 36 * m) / 3
        first_char = v
        (v).to_s(36)
      elsif i % 2 || i == 1
        v = chr.to_i(36)
        v = ((35 - chr.to_i(36)) + 36 - 24 - (i == 1 ? first_char % 3 : first_char % 2)) % 36
        m = v % 2
        v = (v + 36 * m) / 2
        (v).to_s(36)
      elsif i % 3
        (((35 - chr.to_i(36)) + 36 - 12) % 36).to_s(36)
      elsif i % 5
        (((35 - chr.to_i(36)) + 36 - 24) % 36).to_s(36)
      else
        (35 - chr.to_i(36)).to_s(16)
      end
    end.join('').reverse
  end

  def self.resolve_id(shortcode)
    self.unrandomize(shortcode).sub(/^0+/,'').to_i(36)
  end

end
