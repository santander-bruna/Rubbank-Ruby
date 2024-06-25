require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @account = accounts(:one)
    @token = JsonWebToken.new.encode(user_id: @user.id)
  end

  test "should create a new account" do
    # Set up the necessary data for the test
    params = { account: { num_account: "123456789", balance: 100.0, status: "active", user_id: @user.id, agency: "123" } }

    # Send a POST request to the create action with the necessary parameters and token
    post accounts_url, params: params, headers: { Authorization: @token }

    # Verify that the account was created successfully
    assert_response :created
    assert_equal "Account was successfully created.", flash[:notice]

    # Verify that the account was saved in the database
    assert_not_nil Account.find_by(num_account: "123456789")
  end
end