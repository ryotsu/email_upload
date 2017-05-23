defmodule Mailgun.Mail do
  @moduledoc """
  Struct model for a  mail
  """

  alias Mailgun.Mail.Attachment

  @enforce_keys [:sender, :service, :namespace, :attachments, :timestamp]

  defstruct [:sender, :service, :namespace, :attachments, :timestamp]

  @typedoc """
  Represents Mail struct as a type
  """
  @type t :: %__MODULE__{
    sender: String.t,
    service: :dropbox,
    namespace: String.t,
    attachments: [Attachment.t],
    timestamp: integer
  }
end
