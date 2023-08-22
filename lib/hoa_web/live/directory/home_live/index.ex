defmodule HoaWeb.HomeLive.Index do
  use HoaWeb, :live_view

  alias Hoa.Directory
  alias Hoa.Directory.Home

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :homes, Directory.list_homes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Home")
    |> assign(:home, Directory.get_home!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Home")
    |> assign(:home, %Home{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Homes")
    |> assign(:home, nil)
  end

  @impl true
  def handle_info({HoaWeb.HomeLive.FormComponent, {:saved, home}}, socket) do
    {:noreply, stream_insert(socket, :homes, home)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    home = Directory.get_home!(id)
    {:ok, _} = Directory.delete_home(home)

    {:noreply, stream_delete(socket, :homes, home)}
  end
end
