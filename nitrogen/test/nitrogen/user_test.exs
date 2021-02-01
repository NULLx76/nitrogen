defmodule Nitrogen.UserTest do
  use Nitrogen.DataCase

  alias Nitrogen.User

  import Nitrogen.Factory

  describe "users" do
    test "list_users/0 returns all users" do
      user = insert(:user)
      assert User.list_users() == [user]
    end
  end
end
