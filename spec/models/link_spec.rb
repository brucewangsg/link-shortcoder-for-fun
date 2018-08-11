require 'rails_helper'

RSpec.describe Link, type: :model do
  it "should generate link code" do
    link = Link.create(url: "http://sample.com/")
    expect(link.shortcode.size).to eq(3)
    expect(Link.resolve_id(link.shortcode)).to eq(link.id)
  end

  it "should should always resolve shortcode back to the original id" do
    (1...50000).each do |i|
      expect(Link.resolve_id(Link.shortcode_from_id(i))).to eq(i)
    end
  end

  it "should have uniq codes" do
    codes = (1...50000).map{|num|Link.shortcode_from_id(num)}
    expect(codes.uniq.count).to eq(codes.count)
  end
end
