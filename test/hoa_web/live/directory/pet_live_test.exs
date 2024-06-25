defmodule HoaWeb.PetLiveTest do
  use HoaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Hoa.DirectoryFixtures

  setup :register_and_log_in_user

  @create_attrs %{
    name: "some name",
    type: :dog,
    breed: "some breed",
    weight: 23,
    dob: "2023-01-01"
  }
  @update_attrs %{
    name: "some updated name",
    type: :cat,
    breed: "some updated breed",
    weight: 13,
    dob: "2023-01-02"
  }
  @invalid_attrs %{name: nil, type: nil, breed: nil, dob: nil, weight: nil}

  defp create_pet(_) do
    {:ok, pet} = pet_fixture()
    %{pet: pet}
  end

  describe "Index" do
    setup [:create_pet]

    test "lists all pets", %{conn: conn, pet: pet} do
      {:ok, _index_live, html} = live(conn, ~p"/pets")

      assert html =~ "Listing Pets"
      assert html =~ pet.name
    end

    test "saves new pet", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/pets")

      assert index_live |> element("a", "New Pet") |> render_click() =~
               "New Pet"

      assert_patch(index_live, ~p"/pets/new")

      assert index_live
             |> form("#pet-form", pet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pet-form", pet: @create_attrs)
             |> render_submit()

      # assert_patch(index_live, ~p"/pets")

      html = render(index_live)
      assert html =~ "Pet created successfully"
      assert html =~ "some name"
    end

    test "updates pet in listing", %{conn: conn, pet: pet} do
      {:ok, index_live, _html} = live(conn, ~p"/pets")

      assert index_live |> element("#pets-#{pet.id} a", "Edit") |> render_click() =~
               "Edit Pet"

      assert_patch(index_live, ~p"/pets/#{pet}/edit")

      assert index_live
             |> form("#pet-form", pet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pet-form", pet: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pets")

      html = render(index_live)
      assert html =~ "Pet updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes pet in listing", %{conn: conn, pet: pet} do
      {:ok, index_live, _html} = live(conn, ~p"/pets")

      assert index_live |> element("#pets-#{pet.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pets-#{pet.id}")
    end
  end

  describe "Show" do
    setup [:create_pet]

    test "displays pet", %{conn: conn, pet: pet} do
      {:ok, _show_live, html} = live(conn, ~p"/pets/#{pet}")

      assert html =~ "Show Pet"
      assert html =~ pet.name
    end

    test "updates pet within modal", %{conn: conn, pet: pet} do
      {:ok, show_live, _html} = live(conn, ~p"/pets/#{pet}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Pet"

      assert_patch(show_live, ~p"/pets/#{pet}/show/edit")

      assert show_live
             |> form("#pet-form", pet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#pet-form", pet: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/pets/#{pet}")

      html = render(show_live)
      assert html =~ "Pet updated successfully"
      assert html =~ "some updated name"
    end
  end
end
