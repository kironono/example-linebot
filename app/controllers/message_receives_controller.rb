class MessageReceivesController < ApplicationController

  protect_from_forgery with: :null_session

  def callback
    from = params[:result][0][:content][:from]
    text = params[:result][0][:content][:text]

    message = params.to_s
    response_message(from, message)
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
