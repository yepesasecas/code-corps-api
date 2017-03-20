defmodule CodeCorps.Emails.ForgotPasswordEmailTest do
  use CodeCorps.ModelCase
  use Bamboo.Test

  alias CodeCorps.{Emails.ForgotPasswordEmail, AuthToken}

  test "forgot password email works" do
    user = insert(:user)
    { :ok, %AuthToken{ value: token } } = AuthToken.changeset(%AuthToken{}, user) |> Repo.insert

    email = ForgotPasswordEmail.create(user, token)
    assert email.from == "Code Corps<team@codecorps.org>"
    assert email.to == user.email
  end
end
