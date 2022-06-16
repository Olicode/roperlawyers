require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test "send_user_updates" do
    mail = AdminMailer.send_user_updates
    assert_equal "Send user updates", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
