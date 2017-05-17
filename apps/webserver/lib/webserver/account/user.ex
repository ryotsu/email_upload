defmodule Webserver.Account.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Webserver.Account.User

  schema "account_users" do
    field :dropbox_token, Cloak.EncryptedBinaryField
    field :dropbox_uid, :string
    field :firstname, :string
    field :lastname, :string
    field :namespace, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :namespace, :dropbox_uid, :dropbox_token])
    |> validate_required([:firstname, :lastname, :namespace, :dropbox_uid,
                          :dropbox_token])
    |> unique_constraint(:namespace)
    |> unique_constraint(:dropbox_uid)
  end
end
