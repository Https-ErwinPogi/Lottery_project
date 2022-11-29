class Clients::ProfileController < ApplicationController
  def index
    @users = User.all
  end
end
