defmodule GraphqlReactWeb.GraphQL.Schema do

  use Absinthe.Schema
  alias GraphqlReactWeb.GraphQL.Accounts.AccountsResolvers


  query do
    field :get_user, :user do
      resolve &AccountsResolvers.get_current_user/3
    end
  end

  mutation do
    field :register_user, :user do
      arg(:input, :user_input)
      resolve &AccountsResolvers.create_user/3
      # resolve fn _entity, %{input: post_params}, _context ->
      #   {:ok, Grapgql.Accounts.create_user(post_params)}
      # end
    end

    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &AccountsResolvers.login/3
    end

  end

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
  end

  object :session do
    field :user, non_null(:user)
    field :token, non_null(:string)
end
end
