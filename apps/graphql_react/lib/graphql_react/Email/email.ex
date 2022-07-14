defmodule GraphqlReact.Email do
  import Bamboo.Email
  import Bamboo.SendGridHelper
  use Bamboo.Phoenix, view: GraphqlReactWeb.EmailView

  def send_marketing_email(email,name) do
    _email =  new_email()
             |> to(email)
             |> from({ Application.get_env(:graphql_react, :from_email_name), Application.get_env(:graphql_react, :from_email)})
             |> with_template(Application.get_env(:graphql_react, :registration_email_confirmation_template))
             |> add_dynamic_field("name", name)
             |> GraphqlReact.Mailer.deliver_later
             {:ok, "sent"}
  end

  def reset_password_email(%GraphqlReact.Accounts.PasswordReset{} = password_reset) do
    _email =  new_email()
             |> to(password_reset.user.email)
             |> from({ Application.get_env(:graphql_react, :from_email_name), Application.get_env(:graphql_react, :from_email)})
             |> with_template(Application.get_env(:graphql_react, :reset_password_email_template_id))
             |> add_dynamic_field("password_code", password_reset.code)
  end
  def update_email(new_email,url) do
    _email = new_email()
      |> to(new_email)
      |> from({ Application.get_env(:graphql_react, :from_email_name), Application.get_env(:graphql_react, :from_email)})
      |> with_template(Application.get_env(:graphql_react, :change_email_temp_id))
      |> add_dynamic_field("url", url)
  end

  def email_verification(email, url) do
    _email = new_email()
      |> to(email)
      |> from({ Application.get_env(:graphql_react, :from_email_name), Application.get_env(:graphql_react, :from_email)})
      |> with_template(Application.get_env(:graphql_react, :email_verification_id))
      |> add_dynamic_field("url", url)
  end
end
