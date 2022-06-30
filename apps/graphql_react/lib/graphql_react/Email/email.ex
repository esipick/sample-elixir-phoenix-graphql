defmodule GraphqlReact.Email do
  import Bamboo.Email
  import Bamboo.SendGridHelper
  use Bamboo.Phoenix, view: GraphqlReactWeb.EmailView

  def send_marketing_email(email,name) do
    email =  new_email()
             |> to(email)
             |> from({ Application.get_env(:graphql_react, :from_email_name), Application.get_env(:graphql_react, :from_email)})
             |> with_template(Application.get_env(:graphql_react, :registration_email_confirmation_template))
             |> add_dynamic_field("name", name)
             |> GraphqlReact.Mailer.deliver_later
             {:ok, "sent"}
  end

end
