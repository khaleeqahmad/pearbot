module Pearbot
  module SharedCommands
    class Snooze < PearbotCommand
      match /snooze ?(me)/

      help do
        title 'snooze me'
        desc 'Temporarily disable drawing for yourself.'
      end

      def self.call(client, data, match)
        participant = Participant.find_by(slack_user_id: data.user)
        pool = participant.pools.last
        pool.refresh_participants if pool.present?

        if pool.blank?
          client.say(channel: data.channel, text: "🙅‍♀️ No pool exists ", gif: 'no')
        else
          participant.snooze_pool(pool)
          client.say(channel: data.channel, text: "Snoozed drawing for #{participant.name} in <##{pool.slack_channel_id}>. 😴", gif: 'sleep')
        end
      end
    end
    class Resume < PearbotCommand
      match /resume ?(me)/

      help do
        title 'resume me/@user'
        desc 'Re-enables drawing for yourself.'
      end

      def self.call(client, data, match)
        participant = Participant.find_by(slack_user_id: data.user)
        pool = participant.pools.last
        pool.refresh_participants if pool.present?

        if pool.blank?
          client.say(channel: data.channel, text: "🙅‍♀️ No pool exists ", gif: 'no')
        else
          participant.resume_pool(pool)
          client.say(channel: data.channel, text: "Resumed drawing for #{participant.name} in <##{pool.slack_channel_id}>. 😊", gif: 'awake')
        end
      end
    end
  end
end