require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should create a new user" do
    # Set up the necessary data for the test
    params = { user: { cpf: "12345678901", name: "John Doe", email: "johndoe@example.com", phone: "1234567890", birthdate: "1990-01-01", app_password: "password123" }, address: { street: "123 Main St", city: "New York", state: "NY", zip_code: "12345", neighborhood: "Manhattan" }, account: { num_account: "123456789", balance: 0.0, status: "active", agency: "123", password: "password123" } }

    puts params
    # Send a POST request to the create action with the necessary parameters and token
    post users_url, params: params

    # Verify that the user was created successfully
    assert_response :created
    assert_equal "User was successfully created.", flash[:notice]

    # Verify that the user was saved in the database
    assert_not_nil User.find_by(cpf: "12345678901")
  end
end