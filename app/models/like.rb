class Like < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :player
  belongs_to :game, counter_cache: true

  after_create_commit lambda {
    broadcast_update_later_to 'activity', target: "#{dom_id(game)}_likes_count",
                                          html: game.likes_count
  }

  after_destroy_commit lambda {
    broadcast_update_later_to 'activity', target: "#{dom_id(game)}_likes_count",
                                          html: game.likes_count,
                                          locals: { like: nil }
  }
end
