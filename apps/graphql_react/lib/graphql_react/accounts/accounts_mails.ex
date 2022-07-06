defmodule GraphqlReact.Accounts.AccountMails do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GraphqlReact.Repo

  alias GraphqlReact.Accounts
  alias GraphqlReact.Accounts.User
  alias GraphqlReact.Accounts.Authentication
  alias GraphqlReact.Accounts.Encryption
  alias GraphqlReact.Accounts.PasswordReset
  alias GraphqlReact.Accounts.Setting
  alias GraphqlReact.Accounts.Settings
  alias GraphqlReact.Accounts.UserEmails
  alias GraphqlReact.Accounts.UserEmail
  alias GraphqlReact.Email
  alias GraphqlReact.Helpers



  def verify_secondary_email(args)  do

    case Accounts.get_reset_code(args.code) do
      nil->
        {:error, "invalid code or link has expired"}
      code->
        case  UserEmails.get_email(args.email_id) do
          nil ->
            {:error, "email not found"}
          email ->
            change_attr = %{
              is_verified: true
            }
            case UserEmails.update_email(email,change_attr) do
              nil ->
                {:error, "failed to verfiy email ! try again"}
              e ->
                Accounts.delete_all_existing_user_codes(code.user_id)
                {:ok, "email verified succesfully "}
            end
        end
    end
  end

end
