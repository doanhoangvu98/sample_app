require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:vu)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template "password_resets/new"
    # Invalid email
    post password_resets_path, params: {password_reset: {email: ""}}
    assert_not flash.blank?
    assert_template "password_resets/new"
    # Valid email
    post password_resets_path, params: {password_reset: {email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: "111111",
        password_confirmation: "222222"
      }
    }
    assert_select "div#error_explanation"
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
