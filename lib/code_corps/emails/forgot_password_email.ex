defmodule CodeCorps.Emails.ForgotPasswordEmail do
  import Bamboo.Email
  import Bamboo.PostmarkHelper

  alias CodeCorps.{Emails.BaseEmail, AuthToken}

  def create(user, token) do
    BaseEmail.create
    |> to(user.email)
    |> template(template_id(), [link: link(token)])
  end

  defp template_id, do: Application.get_env(:code_corps, :postmark_forgot_password_template)

  defp link(token) do
    "#{token}" # TODO: we can replace this with the proper string later
  end
end
