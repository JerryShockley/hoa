defmodule HoaWeb.PersonLiveTest do
  use HoaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Hoa.DirectoryFixtures

  setup :register_and_log_in_user

  @create_attrs %{
    first_name: "some first_name",
    last_name: "some last_name",
    mobile_phone: "3345679100",
    email: "some@email.com",
    mobile_phone_public: true,
    email_public: true,
    bio: "some bio",
    dob: "2023-07-28",
    nickname: "some nick_name",
    middle_name: "some middle_name",
    home_relationship: :owner,
    work_phone: "922-655-0103",
    work_phone_public: true
  }
  @update_attrs %{
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    mobile_phone: "(405)777-1234)",
    email: "updated_some@email.com",
    mobile_phone_public: false,
    email_public: false,
    bio: "some updated bio",
    dob: "2023-07-29",
    home_relationship: :renter,
    nickname: "some updated nick_name",
    middle_name: "some updated middle_name",
    work_phone: "213-045-2389"
  }
  @invalid_attrs %{
    first_name: nil,
    last_name: nil,
    mobile_phone: "9228765432",
    email: "!3f@bad.com",
    mobile_phone_public: false,
    email_public: false,
    bio: nil,
    dob: "2050-01-01",
    home_relationship: :owner,
    nickname: nil,
    middle_name: nil,
    work_phone: "sadgfasdgasd",
    work_phone_public: false
  }

  defp create_person(_) do
    person = person_fixture_with_nested()
    %{person: person}
  end

  describe "Index" do
    setup [:create_person]

    test "lists all people", %{conn: conn, person: person} do
      {:ok, _index_live, html} = live(conn, ~p"/people")

      assert html =~ "Listing People"
      assert html =~ person.first_name
    end

    test "saves new person", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/people")

      assert index_live |> element("a", "New Person") |> render_click() =~
               "New Person"

      assert_patch(index_live, ~p"/people/new")

      assert index_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#person-form", person: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/people")

      html = render(index_live)
      assert html =~ "Person created successfully"
      assert html =~ "some first_name"
    end

    test "updates person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/people")

      assert index_live |> element("#people-#{person.id} a", "Edit") |> render_click() =~
               "Edit Person"

      assert_patch(index_live, ~p"/people/#{person}/edit")

      assert index_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#person-form", person: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/people")

      html = render(index_live)
      assert html =~ "Person updated successfully"
      assert html =~ "some updated first_name"
    end

    test "deletes person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/people")

      assert index_live |> element("#people-#{person.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#people-#{person.id}")
    end
  end

  describe "Show" do
    setup [:create_person]

    test "displays person", %{conn: conn, person: person} do
      {:ok, _show_live, html} = live(conn, ~p"/people/#{person}")

      # assert_navigation
      assert html =~ "Person Detail"
      assert html =~ person.first_name

    end

    test "updates person within modal", %{conn: conn, person: person} do
      {:ok, show_live, _html} = live(conn, ~p"/people/#{person.id}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Person"

      assert_patch(show_live, ~p"/people/#{person.id}/show/edit")

      assert show_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#person-form", person: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/people/#{person}")

      html = render(show_live)
      assert html =~ "Person updated successfully"
      assert html =~ "some updated first_name"
    end
  end
end
