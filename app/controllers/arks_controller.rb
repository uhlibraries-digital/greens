class ArksController < ApplicationController

  def show
    @ark = Ark.find_by(identifier: params[:id]) or not_found

    if !@ark.where.nil? and url_valid?(@ark.where) and env["REQUEST_URI"][-2, 2] != '??' and env["REQUEST_URI"][-1, 1] != '?'
      redirect_to @ark.where
      return
    end

    render(content_type: 'text/plain', layout: false)
  end

  def index
    @ark = Ark.paginate(:page => params[:page], :per_page => 100)
  end

  def home
  end

end
