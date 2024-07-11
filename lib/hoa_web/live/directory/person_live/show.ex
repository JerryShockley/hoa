defmodule HoaWeb.PersonLive.Show do
  use HoaWeb, :live_view

  alias Hoa.Directory
  alias Hoa.Directory.Person

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    person = Directory.get_person!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:person, person)
     |> assign(:age, calculate_age(person.dob))
     |> assign(:full_name, first_and_last_name(person))
     |> assign(:phones, format_phones(person))
     |> assign_home_variables(person)
     |> assign(:mailing_address, format_mailing_address(person))
    }
  end

  defp page_title(:show), do: "Show Person"
  defp page_title(:edit), do: "Edit Person"

  defp assign_home_variables(socket, person) do
    case determine_home_types(person) do
      {:primary_home} ->
        socket
        |> assign(:primary_home, hd(person.homes))
        |> assign(:rental_homes, nil)
      {:primary_and_rental, primary_home, rental_homes} ->
        socket
        |> assign(:primary_home, primary_home)
        |> assign(:rental_homes, rental_homes)
      {:rentals} ->
        socket
        |> assign(:primary_home, nil)
        |> assign(:rental_homes, person.homes)
      _ ->
        socket
        |> assign(:primary_home, nil)
        |> assign(:rental_homes, nil)
    end
  end
  # Assumption: Only owners can have more than 1 home.
  defp determine_home_types(%Person{home_relationship: :owner} = person) do
    case Enum.count(person.homes) do
      0 -> {:error, "Person not linked to a Home: #{person.first_name} /
             #{person.last_name} ID: #{Integer.to_string(person.id)}"}
      1 -> {:primary_home}
      _ ->
         # Assumption: There shouldn't be more than one non-rental home per owner
         primary_home = Enum.find(person.homes, nil, &(&1.rental === false))
         if primary_home === nil do
           {:rentals}
         else
           phome = hd(primary_home)
           {:primary_and_rental, phome, Enum.reject(person.homes,
             &(&1.id === phome.id))}
         end
        end
    end

  defp determine_home_types(%Person{} = _person), do: {:primary_home}

  defp calculate_age(dob) do
    age_in_days = Date.diff(Date.utc_today(), dob)
    div(age_in_days, 365)
  end
  defp first_and_last_name(person) do
    "#{person.first_name} #{person.last_name}"
  end
  defp format_phones(person) do
    %{}
    |> Map.put(:home, format_phone_string(person.home_phone))
    |> Map.put(:mobile, format_phone_string(person.mobile_phone))
    |> Map.put(:work, format_phone_string(person.work_phone))
  end

  defp format_mailing_address( person = %Person{street1: nil, street2: nil}) do
    "#{create_addressee_name(person)}\n#{person.homes[0].home_name}\nCamas, WA 98607"
  end

  defp format_mailing_address( person = %Person{street1: street1,
         street2: nil, city: city, state: state, postal_code: zip,
         country_code: country}) do
    "#{create_addressee_name(person)}\n#{street1}\n#{city}, #{state} #{zip}\n#{country}"
  end

  defp format_mailing_address( person = %Person{street1: street1,
         street2: street2, city: city, state: state, postal_code: zip,
         country_code: country}) do
    "#{create_addressee_name(person)}\n#{street1}\n#{street2}\n#{city}, #{state} #{zip}\n#{country}"
  end

  # defp format_home_names(nil), do: nil
  # defp new_view_home_list(home_list) do
  #   home_list
  #   |> Enum.reduce([], fn h, acc -> acc ++ new_view_homemap(h) end)
  # end
  # defp new_view_homemap(%Home{} = home) do
  #   %{}
  #   |> Map.put(:home_name, home.home_name)
  #   |> Map.put(:home_id, home.id)
  # end
  defp create_addressee_name(%Person{mail_addressee: nil,
         first_name: first, last_name: last}) do
    "#{first} #{last}"
  end
  defp create_addressee_name(%Person{mail_addressee: addressee}), do: addressee

  defp format_phone_string(nil), do: nil
  defp format_phone_string(str) do
    "#{String.slice(str, 0..2)}-#{String.slice(str, 3..5)}-#{String.slice(str, 6..9)}"
  end

end
