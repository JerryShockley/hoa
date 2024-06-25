defmodule HoaWeb.HomeLive.FormComponent do
  use HoaWeb, :live_component

  alias Hoa.Directory

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage home records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="home-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:home_name]} type="text" label="Home house number and street" />
        <.input field={@form[:lot_number]} type="text" label="Lot number" />
        <.input field={@form[:rental]} type="checkbox" label="Rental" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Home</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{home: home} = assigns, socket) do
    changeset = Directory.change_home(home)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"home" => home_params}, socket) do
    changeset =
      socket.assigns.home
      |> Directory.change_home(home_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"home" => home_params}, socket) do
    save_home(socket, socket.assigns.action, home_params)
  end

  defp save_home(socket, :edit, home_params) do
    case Directory.update_home(socket.assigns.home, home_params) do
      {:ok, home} ->
        notify_parent({:saved, home})

        {:noreply,
         socket
         |> put_flash(:info, "Home updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_home(socket, :new, home_params) do
    case Directory.create_home(home_params) do
      {:ok, home} ->
        notify_parent({:saved, home})

        {:noreply,
         socket
         |> put_flash(:info, "Home created successfully")
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
