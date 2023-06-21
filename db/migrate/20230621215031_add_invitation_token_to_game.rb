class AddInvitationTokenToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :invitation_token, :string
  end
end
