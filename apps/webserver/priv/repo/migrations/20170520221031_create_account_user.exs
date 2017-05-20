defmodule Webserver.Repo.Migrations.CreateWebserver.Account.User do
  use Ecto.Migration

  def change do
    create table(:account_users) do
      add :firstname, :string
      add :lastname, :string
      add :namespace, :string
      add :dropbox_uid, :string
      add :dropbox_token, :binary

      timestamps()
    end

    create unique_index(:account_users, [:namespace])
    create unique_index(:account_users, [:dropbox_uid])
  end
end
