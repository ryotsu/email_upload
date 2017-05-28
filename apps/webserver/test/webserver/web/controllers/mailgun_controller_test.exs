defmodule Webserver.Web.MailgunControllerTest do
  use Webserver.Web.ConnCase

  alias Webserver.Account

  @create_attrs %{dropbox_token: "some dropbox_token", dropbox_uid: "some dropbox_uid", firstname: "some firstname", lastname: "some lastname", namespace: "some namespace"}

  @attachments"[{\"url\":\"http://www.somedomain.com/someattachment\",\"size\":9999,\"name\":\"Some attachment\",\"content-type\":\"image/jpg\"}]"

  @valid_mail %{"timestamp" => "1495523612", "token" => "52826331f99713e67730b6df23301a3fda308e3ea1dbefb01c", "signature" => "f37244bf301a03a1e1eaf1bfff50ac574300b42c1582e9d106bd85eff20503e8", "sender" => "somesender@gmail.com", "recipient" => "some namespace@dropbox.kochika.me", "attachments" => @attachments}


  setup %{conn: conn} do
    Application.stop(:uploader)
    :ok = Application.start(:uploader)
    {:ok, _user} = Account.create_user(@create_attrs)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "push email to queue when valid", %{conn: conn} do
    conn = post conn, mailgun_path(conn, :webhook), @valid_mail
    assert json_response(conn, 200)["data"] == %{"status" => "success"}
  end

  test "push email to queue when invalid signature", %{conn: conn} do
    invalid_email = %{@valid_mail | "timestamp" => "123"}
    conn = post conn, mailgun_path(conn, :webhook), invalid_email
    assert json_response(conn, 406)["errors"] == %{"detail" => "Invalid signature"}
  end

  test "push email to queue when invalid service", %{conn: conn} do
    invalid_email = %{@valid_mail | "recipient" => "namespace@invalid.kochika.me"}
    conn = post conn, mailgun_path(conn, :webhook), invalid_email
    assert json_response(conn, 406)["errors"] == %{"detail" => "Unrecognized service"}
  end

  test "push email to queue when invalid namespace", %{conn: conn} do
    invalid_email = %{@valid_mail | "recipient" => "invalid@dropbox.kochika.me"}
    conn = post conn, mailgun_path(conn, :webhook), invalid_email
    assert json_response(conn, 406)["errors"] == %{"detail" => "Unknown user"}
  end
end
