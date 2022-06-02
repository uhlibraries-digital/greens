class ArksController < ApplicationController

  def show
    parts = params[:id].match(/(ark:\/[^\/]*\/[^\/]*)([\/\.].*)/)
    if parts.nil?
      id = params[:id]
      suffix = ''
    else
      id = parts[1]
      suffix = parts[2]
    end

    @ark = Ark.find_by(identifier: id) or not_found

    if !@ark.where.nil? and url_valid?(@ark.where) and request.env["REQUEST_URI"][-2, 2] != '??' and request.env["REQUEST_URI"][-1, 1] != '?'
      if !@ark.where.match(/^.*[\?=&\/]$/).nil?
        suffix.slice!(0)
      end
      redirect_to @ark.where + suffix
      return
    end

    render(content_type: 'text/plain', layout: false)
  end

  def index
    @ark = Ark.paginate(:page => params[:page], :per_page => 100)
  end

  def home
  end

  def search
    @ark = Ark.where("identifier LIKE :search OR what LIKE :search OR who LIKE :search OR `where` LIKE :search OR `when` LIKE :search", search: "%#{params[:q]}%")
      .order('what')
      .paginate(:page => params[:page], :per_page => 100)
  end

end
