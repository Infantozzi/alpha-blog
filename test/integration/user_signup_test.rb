require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest

  test "should signup user with valid data" do
    get "/signup"
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: "John Nunez", email: "giganunez@nunezmail.com", password: "ultimatenunez123" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_includes response.body, "[John Nunez]"
    assert_includes response.body, "Logout"
    assert_not_includes response.body, "Sign up"
    assert_select "div.alert", true, "Welcome"
    assert_select "div.alert", true, "John Nunez"
    assert_not_nil session[:user_id]
  end

  test "should not signup user with invalid data" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "1", email: "marshmallow", password: "oi" } }
      assert_match "errors", response.body
      assert_select 'div.alert'
      assert_select 'h4.alert-heading'
      assert_nil session[:user_id]
    end
  end

end