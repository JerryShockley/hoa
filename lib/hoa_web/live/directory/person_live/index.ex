defmodule HoaWeb.PersonLive.Index do
  use HoaWeb, :live_view

  alias Hoa.Directory
  alias Hoa.Directory.Person

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :people, Directory.list_people())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, Directory.get_person!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing People")
    |> assign(:person, nil)
  end

  @impl true
  def handle_info({HoaWeb.PersonLive.FormComponent, {:saved, person}}, socket) do
    {:noreply, stream_insert(socket, :people, person)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Directory.get_person!(id)
    {:ok, _} = Directory.delete_person(person)

    {:noreply, stream_delete(socket, :people, person)}
  end
end
