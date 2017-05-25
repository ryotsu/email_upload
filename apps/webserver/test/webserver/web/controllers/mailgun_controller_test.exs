defmodule Webserver.Web.MailgunControllerTest do
  use Webserver.Web.ConnCase

  alias Webserver.Account
  alias Uploader.Queue
  alias Mailgun.Mail
  alias Mailgun.Mail.Attachment

  @create_attrs %{dropbox_token: "some dropbox_token", dropbox_uid: "some dropbox_uid", firstname: "some firstname", lastname: "some lastname", namespace: "some namespace"}

  @attachment %{"name" => "Some attachment", "url" => "http://www.somedomain.com/someattachment", "size" => 9999, "content-type" => "image/jpg"}

  @valid_mail %{"timestamp" => "1495523612", "token" => "52826331f99713e67730b6df23301a3fda308e3ea1dbefb01c", "signature" => "f37244bf301a03a1e1eaf1bfff50ac574300b42c1582e9d106bd85eff20503e8", "sender" => "somesender@gmail.com", "recipient" => "some namespace@dropbox.kochika.me", "attachments" => [@attachment]}


  setup %{conn: conn} do
    {:ok, _queue} = Queue.start_link()
    {:ok, _user} = Account.create_user(@create_attrs)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "push email when valid", %{conn: conn} do

    _conn = post conn, mailgun_path(conn, :webhook), @valid_mail
    assert Queue.pop == [%Mail{
      sender: "somesender@gmail.com",
      service: :dropbox,
      token: "some dropbox_token",
      namespace: "some namespace",
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
    }]

    assert Queue.pop == []
  end
end
