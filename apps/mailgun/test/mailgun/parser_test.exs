defmodule Mailgun.ParserTest do
  use ExUnit.Case

  alias Mailgun.Parser
  alias Mailgun.Mail
  alias Mailgun.Mail.Attachment

  @attachments"[{\"url\":\"http://www.somedomain.com/someattachment\",\"size\":9999,\"name\":\"Some attachment\",\"content-type\":\"image/jpg\"}]"

  @valid_mail %{"timestamp" => "1495523612", "token" => "52826331f99713e67730b6df23301a3fda308e3ea1dbefb01c", "signature" => "f37244bf301a03a1e1eaf1bfff50ac574300b42c1582e9d106bd85eff20503e8", "sender" => "somesender@gmail.com", "recipient" => "somerecipient@dropbox.kochika.me", "attachments" => @attachments}


  test "parse mail when mail is valid" do
    assert {:ok, mail} = Parser.verify_and_parse(@valid_mail)
    assert mail == %Mail{
      sender: "somesender@gmail.com",
      service: :dropbox,
      namespace: "somerecipient",
      timestamp: 1495523612,
      attachments: [
        %Attachment{
          name: "Some attachment",
          url: "http://www.somedomain.com/someattachment",
          size: 9999,
          content_type: "image/jpg",
          downloaded?: false,
          download_path: nil,
          uploaded?: false,
        }
      ]
    }
  end

  test "parse mail when signature is invalid" do
    mail = %{@valid_mail | "signature" => "f37244bf301a03a1e1eaf1bfff50ac574300b42c1582e9d106bd85eff20503e9"}

    assert {:error, "Invalid signature"} == Parser.verify_and_parse(mail)
  end

  test "parse mail when service is invalid" do
    mail = %{@valid_mail | "recipient" => "somerecipient@gdrive.kochika.me"}

    assert {:error, "Unrecognized service"} == Parser.verify_and_parse(mail)
  end
end
