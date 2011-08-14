require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "transaction creation convenience function correctly invokes create_publication" do
    user = User.new
    user.expects(:create_publication).with(Transaction, {attr_name: 'value'}).returns(:instance)

    assert_equal :instance, user.create_transaction({attr_name: 'value'})
  end

  test "local transaction creation convenience function correctly invokes create_publication" do
    user = User.new
    user.expects(:create_publication).with(LocalTransaction, {attr_name: 'value'}).returns(:instance)

    assert_equal :instance, user.create_local_transaction({attr_name: 'value'})
  end
end