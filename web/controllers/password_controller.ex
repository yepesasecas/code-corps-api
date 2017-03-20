defmodule CodeCorps.PasswordController do
  use CodeCorps.Web, :controller

  alias CodeCorps.{Emails, Mailer, User, AuthToken}

  @doc"""
  forgot_password should take an email and generate an AuthToken model and send an email
  """
  def forgot_password(conn, %{"email" => email}) do
    with %User{} = user <- Repo.get_by(User, email: email),
        { :ok, %AuthToken{} = %{ value: token } } <- AuthToken.changeset(%AuthToken{}, user) |> Repo.insert
    do
      Emails.ForgotPasswordEmail.create(user, token) |> Mailer.deliver_now()
    else
      nil -> nil
    end

    conn |> put_status(:ok) |> render("show.json", email: email)
  end

end
