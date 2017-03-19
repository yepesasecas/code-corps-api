defmodule CodeCorps.PasswordControllerTest do
  @moduledoc false

  use CodeCorps.ApiCase, resource_name: :password
  use Bamboo.Test

  test "creates and renders resource when email is valid", %{conn: conn} do
    user = insert(:user)
    attrs = %{"email" => user.email}
    conn = post conn, password_path(conn, :forgot_password), attrs
    response = json_response(conn, 200)
    assert response == %{ "email" => user.email }
    assert_delivered_email CodeCorps.Emails.ForgotPasswordEmail.create(user)
  end

  test "does not create resource and renders 200 when email is invalid", %{conn: conn} do
    user = insert(:user)
    attrs = %{"email" => "random_email@gmail.com"}
    conn = post conn, password_path(conn, :forgot_password), attrs
    response = json_response(conn, 200)
    assert response == %{ "email" => nil }
    refute_delivered_email CodeCorps.Emails.ForgotPasswordEmail.create(user)
  end

end
