require 'rails_helper'

RSpec.describe LinksController, type: :request do
  let(:params) { 
    { 
      url: "http://www.example.com/" 
    } 
  }
  it 'should create new link' do
    post '/links', params: params
    expect(response.status).to eq(200)
    expect(Link.last.url).to eq(params[:url])
    expect(JSON.parse(response.body)["data"]["url"]).to eq(params[:url])    

    same_id = Link.last.id

    post '/links', params: params
    expect(response.status).to eq(200)
    expect(Link.last.id).to eq(same_id) # duplicate, it should not create new instance
    expect(JSON.parse(response.body)["data"]["url"]).to eq(params[:url])
  end
end