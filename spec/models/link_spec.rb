require 'rails_helper'

RSpec.describe Link, type: :model do
  it "should generate link code" do
    link = Link.create(url: "http://sample.com/")
    expect(link.shortcode.size).to eq(3)
    expect(Link.resolve_id(link.shortcode)).to eq(link.id)

    (1...20000).each do |i|
      expect(Link.resolve_id(Link.shortcode_from_id(i))).to eq(i)
    end
  end
end
