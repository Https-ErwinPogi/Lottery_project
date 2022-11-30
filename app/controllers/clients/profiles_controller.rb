class Clients::ProfilesController < ApplicationController
  def index
    @user = User.all
  end
end