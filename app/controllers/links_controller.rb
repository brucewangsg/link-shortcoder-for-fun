class LinksController < ApplicationController
  def create
    url = normalized_url
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
    url = normalized_url
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

  private 

  def normalized_url
    url = params[:url].to_s.split('://').last.split('#').first.split(/[\r\n]/).first
    url = url.index('/').nil? && !url.blank? && url =~ /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?$/ ? "#{url}/" : url
  end
end
