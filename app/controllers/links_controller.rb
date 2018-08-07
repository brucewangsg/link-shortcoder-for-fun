class LinksController < ApplicationController
  def create
    unless link = Link.where(url: params[:url]).first
      link = Link.create(url: params[:url])
    end
    render json: { data: {
        id: link.id,
        shortcode: link.shortcode,
        url: link.url
      }
    }
  end
end
