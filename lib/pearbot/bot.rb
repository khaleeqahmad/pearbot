module Pearbot
  class Bot < SlackRubyBot::Bot
    require_relative 'slack_api/web_client.rb'
    require_relative 'pool_commands.rb'
  end
end
