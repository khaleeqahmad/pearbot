class Round < ApplicationRecord
  belongs_to :pool
  has_many :groupings
  has_many :participants, through: :groupings

  def available_participants
    pool.available_participants
  end
end
