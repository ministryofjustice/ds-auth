class AddFailureUriToDoorkeeperApplication < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :failure_uri, :text
  end
end
