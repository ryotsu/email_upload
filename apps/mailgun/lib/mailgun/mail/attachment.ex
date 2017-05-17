defmodule Mailgun.Mail.Attachment do
  @moduledoc """
  Struct model for an attachments
  """

  @enforce_keys [:name, :url, :size, :content_type]

  defstruct [:name, :url, :size, :content_type, {:downloaded?, false},
             {:download_path, nil}, {:uploaded?, false}]

  @typedoc """
  Represents Attachment struct as a type
  """
  @type t :: %__MODULE__{
    name: String.t,
    url: String.t,
    size: integer,
    content_type: String.t,
    downloaded?: boolean,
    download_path: String.t | nil,
    uploaded?: boolean
  }
end
