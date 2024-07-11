defmodule HoaWeb.PetLive.FormComponent do
  use HoaWeb, :live_component

  alias Hoa.Directory

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage pet records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="pet-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          field={@form[:type]}
          type="select"
          label="Type"
          prompt="Choose a value"
          options={Ecto.Enum.values(Hoa.Directory.Pet, :type)}
        />
        <.input field={@form[:breed]} type="text" label="Breed" />
        <.input field={@form[:coloring]} type="text" label="Coloring" />
        <.input field={@form[:weight]} type="number" label="Weight" />
        <.input field={@form[:dob]} type="date" label="Date" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Pet</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{pet: pet} = assigns, socket) do
    changeset = Directory.change_pet(pet)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"pet" => pet_params}, socket) do
    changeset =
      socket.assigns.pet
      |> Directory.change_pet(pet_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"pet" => pet_params}, socket) do
    save_pet(socket, socket.assigns.action, pet_params)
  end

  defp save_pet(socket, :edit, pet_params) do
    case Directory.update_pet(socket.assigns.pet, pet_params) do
      {:ok, pet} ->
        notify_parent({:saved, pet})

        {:noreply,
         socket
         |> put_flash(:info, "Pet updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_pet(socket, :new, pet_params) do
    case Directory.create_pet(pet_params) do
      {:ok, pet} ->
        notify_parent({:saved, pet})

        {:noreply,
         socket
         |> put_flash(:info, "Pet created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
