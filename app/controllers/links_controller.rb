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

  def check
    if link = Link.where(url: params[:url]).first
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
      redirect_to link.url
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
