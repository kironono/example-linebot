class MessageReceivesController < ApplicationController

  protect_from_forgery with: :null_session
  before_action :get_client

  def callback
    params[:result].each do |result|
      from = result[:content][:from]
      text = result[:content][:text]
      @client.send_text_message(from, text) if text.present?
    end
    render json: [], status: :ok
  end

  private

  def get_client
    options = {
      channel_id: ENV['LINE_CHANNEL_ID'],
      channel_secret: ENV['LINE_CHANNEL_SECRET'],
      channel_mid: ENV['LINE_CHANNEL_MID'],
      proxy: ENV['FIXIE_URL'],
    }
    @client = LineBotApi::Client.new(options)
  end

end
