class MessageReceivesController < ApplicationController

  protect_from_forgery with: :null_session

  def callback
    result = params[:result].first
    from = result[:content][:from]
    text = result[:content][:text]

    response_message(from, text)
    render json: [], status: :ok
  end

  private

  def response_message(to, message)
    RestClient.proxy = ENV['FIXIE_URL']
    request_headers = {
      "Content-Type": "application/json",
      "X-Line-ChannelID": ENV['LINE_CHANNEL_ID'],
      "X-Line-ChannelSecret": ENV['LINE_CHANNEL_SECRET'],
      "X-Line-Trusted-User-With-ACL": ENV['LINE_CHANNEL_MID'],
    }
    request_params = {
      to: [to],
      toChannel: 1383378250,
      eventType: "138311608800106203",
      content: {
        contentType: 1,
        toType: 1,
        text: message,
      }
    }
    RestClient.post 'https://trialbot-api.line.me/v1/events', request_params.to_json, request_headers
  end

end
