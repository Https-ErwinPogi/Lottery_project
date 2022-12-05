class Clients::InvitesController < ApplicationController
  require "rqrcode"
  before_action :authenticate_user!
  before_action :generate_qr
  before_action :invite_link

  def index ;end

  private

  def invite_link
    @url = "#{request.base_url}/users/sign_up?promoter=#{current_user.email}"
  end
  def generate_qr
    qr_code = RQRCode::QRCode.new("#{invite_link}")

    @qr_as_svg = qr_code.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 5,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
