require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :name => "MyString",
      :type => "RealUser",
      :think_time => 1
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input#user_name[name=?]", "user[name]"

      assert_select "textarea#user_type[name=?]", "user[type]"

      assert_select "input#user_think_time[name=?]", "user[think_time]"
    end
  end
end
