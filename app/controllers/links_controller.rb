class LinksController < ApplicationController
  def create
    url = params[:url].to_s.split('://').last
    unless link = Link.where(url: url).first
      link = Link.create(url: url)
    end
    render json: { data: {
        id: link.id,
        shortcode: link.shortcode,
        url: link.url
      }
    }
  end

  def check
    url = params[:url].to_s.split('://').last
    if link = Link.where(url: url).first
      render json: { data: {
          id: link.id,
          shortcode: link.shortcode,
          url: link.url
        }
      }
    else
      render json: { error: {
          message: 'Not Found'
        }
      }
    end
  end

  def show
    link_id = Link.resolve_id(params[:id])
    link = Link.where(id: link_id).first
    if link
      redirect_to "#{request.protocol}#{link.url}"
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
