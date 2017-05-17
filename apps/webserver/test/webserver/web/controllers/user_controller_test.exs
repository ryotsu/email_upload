# defmodule Webserver.Web.UserControllerTest do
#   use Webserver.Web.ConnCase

#   alias Webserver.Account
#   alias Webserver.Account.User

#   @create_attrs %{dropbox_token: "some dropbox_token", dropbox_uid: "some dropbox_uid", firstname: "some firstname", lastname: "some lastname", namespace: "some namespace"}
#   @update_attrs %{dropbox_token: "some updated dropbox_token", dropbox_uid: "some updated dropbox_uid", firstname: "some updated firstname", lastname: "some updated lastname", namespace: "some updated namespace"}
#   @invalid_attrs %{dropbox_token: nil, dropbox_uid: nil, firstname: nil, lastname: nil, namespace: nil}

#   def fixture(:user) do
#     {:ok, user} = Account.create_user(@create_attrs)
#     user
#   end

#   setup %{conn: conn} do
#     {:ok, conn: put_req_header(conn, "accept", "application/json")}
#   end

#   test "lists all entries on index", %{conn: conn} do
#     conn = get conn, user_path(conn, :index)
#     assert json_response(conn, 200)["data"] == []
#   end

#   test "creates user and renders user when data is valid", %{conn: conn} do
#     conn = post conn, user_path(conn, :create), user: @create_attrs
#     assert %{"id" => id} = json_response(conn, 201)["data"]

#     conn = get conn, user_path(conn, :show, id)
#     assert json_response(conn, 200)["data"] == %{
#       "id" => id,
#       "name" => "some firstname some lastname",
#       "email" => "some namespace@dropbox.kochika.me"}
#   end

#   test "does not create user and renders errors when data is invalid", %{conn: conn} do
#     conn = post conn, user_path(conn, :create), user: @invalid_attrs
#     assert json_response(conn, 422)["errors"] != %{}
#   end

#   test "updates chosen user and renders user when data is valid", %{conn: conn} do
#     %User{id: id} = user = fixture(:user)
#     conn = put conn, user_path(conn, :update, user), user: @update_attrs
#     assert %{"id" => ^id} = json_response(conn, 200)["data"]

#     conn = get conn, user_path(conn, :show, id)
#     assert json_response(conn, 200)["data"] == %{
#       "id" => id,
#       "name" => "some updated firstname some updated lastname",
#       "email" => "some updated namespace@dropbox.kochika.me"}
#   end

#   test "does not update chosen user and renders errors when data is invalid", %{conn: conn} do
#     user = fixture(:user)
#     conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
#     assert json_response(conn, 422)["errors"] != %{}
#   end

#   test "deletes chosen user", %{conn: conn} do
#     user = fixture(:user)
#     conn = delete conn, user_path(conn, :delete, user)
#     assert response(conn, 204)
#     assert_error_sent 404, fn ->
#       get conn, user_path(conn, :show, user)
#     end
#   end
# end
