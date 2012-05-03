#encoding: utf-8
require 'integration_test_helper'

class LocalTransactionCreationTest < ActionDispatch::IntegrationTest
  setup do
    LocalService.create(lgsl_code: 1, providing_tier: %w{county unitary})
    LocalAuthority.create(snac: 'ABCDE')

    panopticon_has_metadata(
      "id" => 2357,
      "slug" => "foo-bar",
      "kind" => "local_transaction",
      "name" => "Foo bar"
    )

    setup_users
  end

  test "creating a local transaction sends the right emails" do


    email_count_before_start = ActionMailer::Base.deliveries.count

    visit "/admin/publications/2357"

    fill_in 'Lgsl code', :with => '1'
    click_button 'Create Local transaction'
    assert page.has_content? "Viewing “Foo bar” Edition 1"

    assert_equal email_count_before_start + 1, ActionMailer::Base.deliveries.count
    assert_match /Created Local transaction: "Foo bar"/, ActionMailer::Base.deliveries.last.subject
  end

  test "creating a local transaction with a bad LGSL code displays an appropriate error" do

    visit "/admin/publications/2357"
    assert page.has_content? "We need a bit more information to create your local transaction."

    fill_in "Lgsl code", :with => "2"
    click_on 'Create Local transaction edition'

    assert page.has_content? "Lgsl code 2 not recognised"
  end


  test "creating a local transaction from panopticon requests an LGSL code" do

    visit "/admin/publications/2357"
    assert page.has_content? "We need a bit more information to create your local transaction."

    fill_in 'Lgsl code', :with => '1'
    click_button 'Create Local transaction'
    assert page.has_content? "Viewing Edition 1 of “Foo bar”"
  end
end
