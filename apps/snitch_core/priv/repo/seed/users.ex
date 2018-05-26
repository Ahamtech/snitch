defmodule Snitch.Seed.Users do
  @moduledoc false

  alias Ecto.DateTime
  alias Comeonin.Argon2
  alias Snitch.Repo
  alias Snitch.Data.Schema.{User, Address}
  alias Snitch.Data.Model.{State, Country}

  require Logger

  @user_passwd Argon2.hashpwsalt("avenger")
  @admin_passwd Argon2.hashpwsalt("wizard")

  def seed_users! do
    users = [
      user("Harry", "Potter", "admin@snitch.com", @admin_passwd, true),
      user("Tony", "Stark", "tony@snitch.com", @user_passwd),
      user("Steven", "Rogers", "steven@snitch.com", @user_passwd)
    ]

    Repo.insert_all(User, users, on_conflict: :nothing, conflict_target: [:email])
    Logger.info("Inserted #{length(users)} users.")
  end

  def user(first_name, last_name, email, pwd_hash, admin \\ false) do
    %{
      first_name: first_name,
      last_name: last_name,
      email: email,
      password_hash: pwd_hash,
      is_admin: admin,
      inserted_at: DateTime.utc(),
      updated_at: DateTime.utc()
    }
  end

  def seed_address! do
    Repo.delete_all(Address)

    Enum.map(
      [
        %Address{
          first_name: "Tony",
          last_name: "Stark",
          address_line_1: "10-8-80 Malibu Point",
          zip_code: "90265",
          city: "Malibu",
          phone: "1234567890",
          state_id: State.get(%{code: "US-CA"}).id,
          country_id: Country.get(%{iso: "US"}).id
        },
        %Address{
          first_name: "noname",
          last_name: "noname",
          address_line_1: "somewhere",
          address_line_2: "street",
          zip_code: "00000",
          city: "Pune",
          phone: "1234567890",
          state_id: State.get(%{code: "IN-MH"}).id,
          country_id: Country.get(%{iso: "IN"}).id
        },
        %Address{
          first_name: "noname",
          last_name: "noname",
          address_line_1: "nowhere",
          address_line_2: "street",
          zip_code: "11111",
          city: "Patna",
          phone: "1234567890",
          state_id: State.get(%{code: "IN-BR"}).id,
          country_id: Country.get(%{iso: "IN"}).id
        }
      ],
      &Repo.insert!/1
    )
  end
end
