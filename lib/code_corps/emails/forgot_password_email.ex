defmodule CodeCorps.Emails.ForgotPasswordEmail do
  import Bamboo.Email
  import Bamboo.PostmarkHelper

  alias CodeCorps.Emails.BaseEmail

  def create(user) do
    BaseEmail.create
    |> to(user.email)
    |> template(template_id(), {})
  end

  defp template_id, do: Application.get_env(:code_corps, :postmark_receipt_template)
end
