class FormatsController < ApplicationController

  def index
    respond_with Format.all
  end

end
