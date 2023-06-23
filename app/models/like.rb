class Like < ApplicationRecord
  belongs_to :player
  belongs_to :game, counter_cache: true
end
