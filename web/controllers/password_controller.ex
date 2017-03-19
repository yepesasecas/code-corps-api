defmodule CodeCorps.PasswordController do
  use CodeCorps.Web, :controller

  alias CodeCorps.{Emails, Mailer, User, AuthToken}
  alias Ecto.Changeset

  @doc"""
  forgot_password should take an email and generate an AuthToken model and send an email
  """
  def forgot_password(conn, %{"email" => email}) do
    with %User{} = user <- Repo.get_by(User, email: email),
        %Changeset{valid?: true} <- AuthToken.changeset(%AuthToken{}, user) do

        try_create_forgot_password(user)
        |> send_forgot_password_email

        conn
        |> put_status(200)
        |> render("show.json", email: user.email)

    else
      nil ->
        conn
        |> put_status(200)
        |> render("show.json", email: nil)
    end
  end

  defp try_create_forgot_password(user) do
    Emails.ForgotPasswordEmail.create(user)
  end

  defp send_forgot_password_email(email) do
    email |> Mailer.deliver_now
  end

end
