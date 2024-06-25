# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Hoa.Repo.insert!(%Hoa.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if soomething goes wrong.
defmodule Seeds do
  alias Hoa.Directory.{Home, Person, Pet}
  alias Hoa.Accounts
  use Ecto.Schema
  import Ecto.Query, warn: false
  alias Hoa.Repo
  # otp_app: :hoa,
  # adapter: Ecto.Adapters.Postgres

  alias NimbleCSV, as: CSV
  # Define the parser (this is equivalent to calling
  # defmodule and should be done at the top of a file)

  CSV.define(MyParser, separator: ",", escape: "\"")

  def strip_unused_elements(map) do
    Map.drop(map, [:unit_city, :unit_state_code, :unit_postal_code])
  end

  # Extracting names here is the only way to harvest the 2nd name
  # associated with the unit since it is not stored elsewhere.

  def parse_people(map) do
    # If addressee contains " and ", then we have two names versus
    # the one in first_name, last_name fields.
    if Map.has_key?(map, :addressee) and
         String.contains?(map[:addressee], " and ") do
      create_people_from_addressee_if_2_names(map)
    else
      create_person_data(map)
    end
    |> set_home_relationship(:owner)
    |> Map.put(:pets, [])
    |> assign_email()
    |> Map.delete(:first_name)
    |> Map.delete(:last_name)
  end

  def show(obj, msg) do
    IO.puts(msg)
    IO.inspect(obj)
    obj
  end

  def set_home_relationship(map, val) do
    case personmap_exists?(map, :p2) do
      true ->
        map
        |> put_in([:people, :p1, :home_relationship], val)
        |> put_in([:people, :p2, :home_relationship], val)

      false ->
        put_in(map, [:people, :p1, :home_relationship], :owner)
    end
  end

  defp create_person_data(map) do
    [{:first_name, first}, {:last_name, last}] =
      check_if_map_elements_contain_values(
        map,
        [:first_name, :last_name]
      )

    fields_map =
      case {first, last} do
        {true, true} ->
          # Use name fields instead of addressee
          Map.take(map, [:first_name, :last_name])

        {true, false} ->
          %{:first_name => map[:first_name], :last_name => "Unknown"}

        {false, true} ->
          %{:first_name => "Unknown", :last_name => map[:last_name]}

        {false, false} ->
          %{:first_name => "Unknown", :last_name => "Unknown"}

        _ ->
          raise "should never happen"
      end

    Map.put(map, :people, %{p1: fields_map})
  end

  defp assign_email(map) do
    if map[:email] != nil do
      emails = String.split(map[:email], [", ", ",", " "])
      [email | _tail] = emails

      case {Enum.count(emails), Enum.count(map[:people])} do
        {1, 1} ->
          # [email | _tail] = emails
          put_in(map, [:people, :p1, :email], email)

        {1, 2} ->
          # [email | _tail] = emails
          put_in(map, [:people, :p1, :email], email)
          put_in(map, [:people, :p1, :email], email)

        {2, 1} ->
          [email1, email2 | []] = emails

          new_p2 = %{
            :first_name => "Unknown1",
            :last_name => "Unknown1",
            :email => email2,
            :home_relationship => :owner
          }

          # Create 2nd dummy person so 2nd email is not lost
          map
          |> put_in([:people, :p2], new_p2)
          |> put_in([:people, :p1, :email], email1)

        {2, 2} ->
          [email1, email2 | []] = emails

          map
          |> put_in([:people, :p1, :email], email1)
          |> put_in([:people, :p1, :home_relationship], :owner)
          |> put_in([:people, :p2, :email], email2)

        _ ->
          raise "Unexpected number of emails or people for #{map.addressee}"
      end
    else
      map
    end
  end

  defp check_if_map_elements_contain_values(map, elem_ary) do
    for e <- elem_ary do
      {e, Map.has_key?(map, e) and String.length(map[e]) > 0}
    end
  end

  def parse_phones(map) do
    if map[:phone] != nil and String.length(map[:phone]) > 9 do
      phones = convert2tuples(map[:phone])

      for p <- phones, reduce: map do
        acc ->
          acc |> assign_phones(p)
      end
    else
      map
    end
  end

  defp personmap_exists?(map, personkey) do
    map[:people] != nil and map[:people][personkey] != nil
  end

  defp people_count(map) do
    if map[:people] == nil do
      0
    else
      Enum.count(map[:people])
    end
  end

  def assign_phones(map, {"cell", phone}) do
    case people_count(map) do
      1 ->
        if(map.people.p1[:mobile_phone] == nil) do
          put_in(map, [:people, :p1, :mobile_phone], phone)
        else
          map
        end

      2 ->
        if(map.people.p1[:mobile_phone] == nil) do
          put_in(map, [:people, :p1, :mobile_phone], phone)
        else
          # We have a 2nd mobile phone, so we assign to 2nd person
          put_in(map, [:people, :p2, :mobile_phone], phone)
        end

      _ ->
        raise("Expected map.people to have either 1 or 2 people.")
    end
  end

  def assign_phones(map, {"home", phone}) do
    Map.put(map, :phone, phone)
  end

  def assign_phones(map, {"work", phone}) do
    if personmap_exists?(map, :p1) do
      put_in(map, [:people, :p1, :work_phone], phone)
    else
      raise "Expected 1 person named :p1 to exist"
    end
  end

  def assign_phones(_map, {type, _phone}), do: raise("Unknown phone type: #{type}")

  def convert2tuples(phone_str) do
    phones = String.split(phone_str, [", ", ","])
    Enum.map(phones, &parse_phone_str/1)
  end

  def parse_phone_str(str) do
    if String.length(str) > 9 do
      [[_, phone_type]] = Regex.scan(~r/\(([c,w,h])\)/, str)

      case phone_type do
        "c" -> {"cell", strip_nondigits_from_str(str)}
        "h" -> {"home", strip_nondigits_from_str(str)}
        "w" -> {"work", strip_nondigits_from_str(str)}
        _ -> {"unknown", strip_nondigits_from_str(str)}
      end
    end
  end

  def strip_nondigits_from_str(str) do
    String.replace(str, ~r/[^\d]/, "")
  end

  def create_people_from_addressee_if_2_names(map) do
    name_strs = String.split(map.addressee, " and ")

    [name1, name2] =
      for name <- name_strs do
        String.split(name, " ")
      end

    name1 = maybe_add_missing_last_name_to_list(name1, List.last(name2, "Empty-list"))

    map
    |> Map.put(:people, %{})
    |> put_in([:people, :p2], convert_name_list_2_map(name2))
    |> put_in([:people, :p1], convert_name_list_2_map(name1))
  end

  def maybe_add_missing_last_name_to_list([_first, second | _] = name, last_name) do
    case Enum.count(name) do
      1 ->
        name ++ [last_name]

      2 ->
        if str_is_initial?(second) do
          name ++ [last_name]
        else
          name
        end

      _ ->
        name
    end
  end

  def maybe_add_missing_last_name_to_list([_first | []] = name, last_name) do
    name ++ [last_name]
  end

  defp str_is_initial?(str), do: String.length(str)

  def convert_name_list_2_map(name) do
    case name do
      [first, last] ->
        %{:first_name => first, :last_name => last}

      [first, middle, last] ->
        %{:first_name => first, :middle_name => String.trim(middle, "."), :last_name => last}

      _ ->
        %{}
    end
  end

  def remove_romano_info(map) do
    if Map.has_key?(map, :addressee) and String.contains?(map[:addressee], "Romano") do
      Map.take(map, [:home_name])
    else
      map
    end
  end

  def convert_keys2atoms(map) do
    for key <- Map.keys(map), reduce: map do
      acc ->
        acc
        |> Map.put(String.to_atom(key), acc[key])
        |> Map.drop([key])
    end
  end

  def convert_peoplemap2list(map) do
    if map[:people] != nil do
      case Enum.count(map[:people]) do
        1 -> Map.put(map, :people, [map[:people][:p1]])
        2 -> Map.put(map, :people, [map[:people][:p1], map[:people][:p2]])
        _ -> raise "Unexpected number of people present"
      end
    else
      map
    end
  end

  def save_user_records do
    users = [
      %{email: "jerry1@shockleynet.com", password: "hello11111"}
    ]

    Enum.each(users, fn user -> Accounts.register_user(user) end)
  end

  defp save_record(attrs) do
    %Home{}
    |> Home.changeset(attrs)
    |> Repo.insert!()
  end

  def create_records(map) do
    # IO.puts "Entering create_records"
    # IO.inspect map
    map
    # |> show("starting processing")
    |> Seeds.convert_keys2atoms()
    # |> show("returned from convert_keys2atoms")
    |> Seeds.strip_unused_elements()
    |> Seeds.remove_romano_info()
    # |> show("Calling parse_people")
    |> Seeds.parse_people()
    # |> show("parsed_people")
    |> Seeds.parse_phones()
    # |> show("parsed_phones")
    |> convert_peoplemap2list
    |> save_record
    |> show("Completed processing")
  end
end

Seeds.save_user_records()

"./priv/repo/2 CREEKS DIRECTORY 2023-1-9.csv"
|> File.stream!()
|> MyParser.parse_stream(skip_headers: false)
|> Stream.transform(nil, fn
  headers, nil -> {[], headers}
  row, headers -> {[Enum.zip(headers, row) |> Map.new()], headers}
end)
|> Stream.each(fn map -> Seeds.create_records(map) end)
|> Stream.run()
