defmodule HoaWeb.PetLive.Index do
  use HoaWeb, :live_view

  alias Hoa.Directory
  alias Hoa.Directory.Pet

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :pets, Directory.list_pets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pet")
    |> assign(:pet, Directory.get_pet!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Pet")
    |> assign(:pet, %Pet{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pets")
    |> assign(:pet, nil)
  end

  @impl true
  def handle_info({HoaWeb.PetLive.FormComponent, {:saved, pet}}, socket) do
    {:noreply, stream_insert(socket, :pets, pet)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pet = Directory.get_pet!(id)
    {:ok, _} = Directory.delete_pet(pet)

    {:noreply, stream_delete(socket, :pets, pet)}
  end
end
