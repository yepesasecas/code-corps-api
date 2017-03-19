defmodule CodeCorps.Emails.ForgotPasswordEmailTest do
  use CodeCorps.ModelCase
  use Bamboo.Test

  alias CodeCorps.Emails.ForgotPasswordEmail

  test "forgot password email works" do
    user = insert(:user)

    email = ForgotPasswordEmail.create(user)
    assert email.from == "Code Corps<team@codecorps.org>"
    assert email.to == user.email
  end
end
