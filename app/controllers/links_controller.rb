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
      redirect_to "#{request.protocol||(request.headers['x-forwarded-proto'] ? "#{request.headers['x-forwarded-proto']}://" : nil)||'http://'}#{link.url}"
      
      # storing stats should not slow down the redirection
      process = fork do
        Link.where(id: link.id).update_all("visit_count = visit_count + 1")
        LinkStat.create(link_id: link.id, details: {
          "User-Agent": request.user_agent,
          "Remote-IP": request.env["HTTP_X_FORWARDED_FOR"].try(:split, ',').try(:last) || request.env["REMOTE_ADDR"],
          "Language": request.headers["HTTP_ACCEPT_LANGUAGE"]
        })
        exit
      end
      Process.detach(process)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private 

  def normalized_url
    url = params[:url].to_s.split('://').last.split('#').first.split(/[\r\n]/).first
    url = url.index('/').nil? && !url.index('?').nil? ? url.sub(/\?/, '/?') : url
    url = url.index('/').nil? && !url.blank? && url =~ /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?$/ ? "#{url}/" : url
    url = url.sub(/[\?&]+$/, '').sub(/[\?]{2,}/, '?').sub(/[\&]{2,}/, '&')
  end
end
