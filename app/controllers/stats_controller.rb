class StatsController < ApplicationController

  def index
    links = Link.limit(1000).offset([1000 * (params[:page].to_i - 1), 0].max).all
    render json: {
      data: links.map{|link|
        {
          url: link.url,
          visit_count: link.visit_count,
          details: "#{stats_url}/#{link.shortcode}",
          created_at: link.created_at
        }
      },
      total: Link.count,
      next_page: Link.count > 1000 * [params[:page].to_i, 1].max ? "#{stats_url}?page=#{[params[:page].to_i, 1].max + 1}" : nil # show next page if there is more
    }
  end

  def show
    link_id = Link.resolve_id(params[:id])
    stats = LinkStat.where(link_id: link_id).order("id DESC").limit(100).all
    render json: {
      visit_count: Link.select("visit_count").where(id: link_id).first&.visit_count||0,
      visits: stats.map{|stat|
        {
          timestamp: stat.created_at,
          remote_ip: stat.details[:"Remote-IP"],
          user_agent: stat.details[:"User-Agent"],
          language: stat.details[:"Language"]
        }
      }
    }
  end

end