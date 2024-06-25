defmodule HoaWeb.HomeLiveTest do
  use HoaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Hoa.DirectoryFixtures

  setup :register_and_log_in_user

  @create_attrs %{
    home_name: "3812 NW 74th Ave",
    lot_number: "some lot_number",
    rental: true,
  }
  @update_attrs %{
    home_name: "3814 NW 74th Ave",
    lot_number: "some lot_number",
    rental: true,
  }
  @invalid_attrs %{
    home_name: nil,
    lot_number: nil,
    rental: false,
  }

  defp create_home(_) do
    {:ok, home} = home_fixture()
    %{home: home}
  end

  describe "Index" do
    setup [:create_home]

    test "lists all homes", %{conn: conn, home: home} do
      {:ok, _index_live, html} = live(conn, ~p"/homes")

      assert html =~ "Listing Homes"
      assert html =~ home.home_name
    end

    test "saves new home", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/homes")

      assert index_live |> element("a", "New Home") |> render_click() =~
               "New Home"

      assert_patch(index_live, ~p"/homes/new")

      assert index_live
             |> form("#home-form", home: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#home-form", home: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/homes")

      html = render(index_live)
      assert html =~ "Home created successfully"
      assert html =~ "3812 NW 74th Ave"
    end

    test "updates home in listing", %{conn: conn, home: home} do
      {:ok, index_live, _html} = live(conn, ~p"/homes")

      assert index_live |> element("#homes-#{home.id} a", "Edit") |> render_click() =~
               "Edit Home"

      assert_patch(index_live, ~p"/homes/#{home}/edit")

      assert index_live
             |> form("#home-form", home: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#home-form", home: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/homes")

      html = render(index_live)
      assert html =~ "Home updated successfully"
      assert html =~ "3814 NW 74th Ave"
    end

    test "deletes home in listing", %{conn: conn, home: home} do
      {:ok, index_live, _html} = live(conn, ~p"/homes")

      assert index_live |> element("#homes-#{home.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#homes-#{home.id}")
    end
  end

  describe "Show" do
    setup [:create_home]

    test "displays home", %{conn: conn, home: home} do
      {:ok, _show_live, html} = live(conn, ~p"/homes/#{home}")

      assert html =~ "Show Home"
      assert html =~ home.home_name
    end

    test "updates home within modal", %{conn: conn, home: home} do
      {:ok, show_live, _html} = live(conn, ~p"/homes/#{home}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Home"

      assert_patch(show_live, ~p"/homes/#{home}/show/edit")

      assert show_live
             |> form("#home-form", home: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#home-form", home: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/homes/#{home}")

      html = render(show_live)
      assert html =~ "Home updated successfully"
      assert html =~ "3814 NW 74th Ave"
    end
  end
end
