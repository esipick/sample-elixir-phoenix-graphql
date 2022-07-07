defmodule GraphqlReactWeb.GraphQL.Schema do

  use Absinthe.Schema
  alias GraphqlReactWeb.GraphQL.Accounts.AccountsResolvers

# Queries
  query do
    field :get_user, :user do
      resolve &AccountsResolvers.get_current_user/3
    end

    field :verify_email, :string do
      arg :code, non_null(:string)
      arg :user_id, non_null(:integer)
      resolve &AccountsResolvers.verify_email/3
    end
    field :verify_secondary_email, :string do
      arg :code, non_null(:string)
      arg :email_id, non_null(:integer)
      resolve &AccountsResolvers.verify_secondary_email/3
    end

    field :get_user_emails, :emails do
      resolve &AccountsResolvers.get_user_emails/3
    end
  end

# Mutations
  mutation do
    field :register_user, :user do
      arg(:input, :user_input)
      resolve &AccountsResolvers.create_user/3
    end

    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &AccountsResolvers.login/3
    end

    field :forgot_password, :string do
      arg :email, non_null(:string)
      resolve &AccountsResolvers.forgot_submit/3
    end

    field :reset_password, :string do
      arg :code, non_null(:string)
      arg :password, non_null(:string)
      arg :password_confirmation, non_null(:string)
      resolve &AccountsResolvers.reset_password/3
    end

    field :update_email, :string do
      arg :email, non_null(:string)
      resolve &AccountsResolvers.update_email/3
    end

    field :update_password, :string do
      arg :old_password, non_null(:string)
      arg :new_password, non_null(:string)
      arg :confirm_new_password, non_null(:string)
      resolve &AccountsResolvers.update_password/3
    end

    field :add_email, :string do
      arg :email, non_null(:string)
      resolve &AccountsResolvers.add_new_email/3
    end


  end


# Object & Types
  object :user do
    field :id, :id
    field :username, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
  end

  input_object :user_input do
    field :username, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :password_confirmation, :string
    field :platform, :string
  end

  object :session do
    field :user, non_null(:user)
    field :token, non_null(:string)
  end

  object :emails do
    field :user_emails, list_of(:user_email)
  end
  object :user_email do
    field :email, :string
    field :is_verified, :string
    field :is_primary, :string
  end


end
