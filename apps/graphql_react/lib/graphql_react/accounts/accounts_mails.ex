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



  def add_secondary_email(args, user) do

    primary_email =  UserEmails.get_primary_email(user.id)
    secondary_emails =  UserEmails.get_secondary_email(user.id)

    email_list = secondary_emails
      |> Enum.filter(fn(value) -> value.email == args.email end)
      |> Enum.map(fn(filtered_value) -> filtered_value  end)

    # IO.inspect user_emails
    IO.inspect primary_email
    IO.inspect secondary_emails
    IO.inspect length(secondary_emails)
    cond do
      args.email == primary_email.email ->
        {:error, "you have  entered your existing primary email! try a different one"}

      length(secondary_emails) == 3 ->
        {:error, "you have already  addded allowed number of emails !"}
      length(email_list) > 0 ->
        {:error, "This email is already added !"}
      true ->
        new_email = %{
          email: args.email,
          is_verified: false,
          is_primary: false,
          user_id: user.id
        }
        case UserEmails.add_email(new_email) do
          {:ok, email} ->
            {:ok , code } = Accounts.get_email_verification_code(user)
            url = Helpers.get_client_url(user, "/settings-add-email") <> "/#{code.code}" <> "/#{email.id}"
            IO.inspect url
            code
            |> Repo.preload(:user)
            |> Email.update_email(args.email, url)
            |> GraphqlReact.Mailer.deliver_later
            {:ok, "Email added, please verfiy your new email"}
          {:error, _} ->
            {:error, "Failed to add the email"}
        end
      end
  end

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

  def delete_email(id) do

    email = UserEmails.get_email_by_email_id(id)
    cond do
      email.is_primary ->
        {:error , "Can't delete email! email is primary"}
      true ->
        case Repo.delete(email) do
          {:error, _} ->
            {:error, "Failed to delete email ! try again later"}
          {:ok , _} ->
        {:ok, "Email Deleted Successfully"}
        end
    end
  end

  def set_primary_email(id , user) do
    primary_email =  UserEmails.get_primary_email(user.id)
    email = UserEmails.get_email_by_email_id(id)
    cond do
      email.is_primary ->
        {:error , "email is already primary"}
      email.is_verified == false ->
        {:error , "you need to verfiy this email first !"}
      true ->
        UserEmails.update_email(primary_email, %{is_primary: false})
        UserEmails.update_email(email, %{is_primary: true})
        {:ok, "successfully set email as primary"}

    end
  end


end
