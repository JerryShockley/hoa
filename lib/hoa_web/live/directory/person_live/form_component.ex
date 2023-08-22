defmodule HoaWeb.PersonLive.FormComponent do
  use HoaWeb, :live_component

  alias Hoa.Directory

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage person records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="person-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:first_name]} type="text" label="First name" />
        <.input field={@form[:nickname]} type="text" label="Nickname" />
        <.input field={@form[:middle_name]} type="text" label="Middle name" />
        <.input field={@form[:last_name]} type="text" label="Last name" />
        <.input field={@form[:mobile_phone]} type="text" label="Mobile phone" />
        <.input field={@form[:work_phone]} type="text" label="Work phone" />
        <.input field={@form[:email]} type="text" label="Email" />
        <.input field={@form[:mobile_phone_public]} type="checkbox" label="Mobile phone public" />
        <.input field={@form[:work_phone_public]} type="checkbox" label="Work phone public" />
        <.input field={@form[:email_public]} type="checkbox" label="Email public" />
        <.input field={@form[:bio]} type="text" label="Bio" />
        <.input field={@form[:dob]} type="date" label="Dob" />
        <.input
          field={@form[:home_relationship]}
          type="select"
          label="Home relationship"
          prompt="Choose a value"
          options={Ecto.Enum.values(Hoa.Directory.Person, :home_relationship)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Person</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{person: person} = assigns, socket) do
    changeset = Directory.change_person(person)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset =
      socket.assigns.person
      |> Directory.change_person(person_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    case Directory.update_person(socket.assigns.person, person_params) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_person(socket, :new, person_params) do
    case Directory.create_person(person_params) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
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
