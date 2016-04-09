module LineBotApi

  class Client
    TO_CHANNEL = 1383378250
    EVENT_TYPE = "138311608800106203"
    EVENT_URL = 'https://trialbot-api.line.me/v1/events'
    attr_accessor :channel_id, :channel_secret, :channel_mid, :proxy

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def credentials
      {
        "X-Line-ChannelID": channel_id,
        "X-Line-ChannelSecret": channel_secret,
        "X-Line-Trusted-User-With-ACL": channel_mid,
      }
    end

    def send_text_message(to, message)
      RestClient.proxy = proxy unless proxy.nil?
      request_headers = credentials.merge({
        "Content-Type": "application/json",
      })
      request_params = {
        to: [to],
        toChannel: TO_CHANNEL,
        eventType: EVENT_TYPE,
        content: {
          contentType: 1,
          toType: 1,
          text: message,
        }
      }
      RestClient.post EVENT_URL, request_params.to_json, request_headers
    end

  end
end
