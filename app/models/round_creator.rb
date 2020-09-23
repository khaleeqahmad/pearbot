class RoundCreator
  # class RoundCreationsException < StandardError

  def initialize(pool)
    @pool = pool
  end

  def create
    ordered_participants.each do |participant|
      next if round.reload.participants.include?(participant)
      partner = find_partner_for(participant)
      if partner.present?
        round.groupings.create(participants: [participant, partner])
      else
        remainders.push(participant)
      end
    end

    if remainders.any?
      remainders.each do |participant|
        grouping = find_grouping_for(participant)
        grouping.participants << participant if grouping.present?
      end
    end
    round
  end

  private

  def round
    @round ||= Round.create(pool: @pool)
  end

  def remainders
    @remainders ||= []
  end

  def find_partner_for(participant)
    options = participant.pairable_with(round) - round.reload.participants
    options.shuffle.first
  end

  def find_grouping_for(participant)
    round.groupings.each do | grouping |
      next unless grouping_available_for_participant(grouping, participant)
      return grouping
    end
  end

  def grouping_available_for_participant(grouping, participant)
    (grouping.participants & participant.pairable_with(round)).empty?
  end


  def ordered_participants
    # Could this be faster with DB query?
    available_participants.sort_by { |participant| participant.number_of_filters }
  end

  def available_participants
    @pool.available_participants
  end
end
