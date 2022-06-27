# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Grapgql.Repo.insert!(%Grapgql.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias GraphqlReact.Repo
alias GraphqlReact.Accounts
alias GraphqlReact.Accounts.User

Repo.delete_all(User)


Accounts.create_user(%{email: "test-1@example.com", username: "test", first_name: "test-fname",last_name: "test-lname",password: "12345",password_confirmation: "12345"})
Accounts.create_user(%{email: "test-2@example.com", username: "test", first_name: "test-fname",last_name: "test-lname",password: "12345",password_confirmation: "12345"})
Accounts.create_user(%{email: "test-3@example.com", username: "test", first_name: "test-fname",last_name: "test-lname",password: "12345",password_confirmation: "12345"})
Accounts.create_user(%{email: "test-4@example.com", username: "test", first_name: "test-fname",last_name: "test-lname",password: "12345",password_confirmation: "12345"})
Accounts.create_user(%{email: "test-5@example.com", username: "test", first_name: "test-fname",last_name: "test-lname",password: "12345",password_confirmation: "12345"})
