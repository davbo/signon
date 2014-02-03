require 'test_helper'
require 'gds_api/base'

class SSOPushErrorTest < ActiveSupport::TestCase

  def setup
    @sso_push_user = create(:user, name: "SSO Push User")
    SSOPushCredential.stubs(:user_email).returns(@sso_push_user.email)

    @user = create(:user)
    @application = create(:application, redirect_uri: "http://app.com/callback")
  end

  context "rescuing GdsApi::HTTPErrorResponse" do
    should "add application name, user uid and response error code to exception message" do
      ex = GdsApi::HTTPErrorResponse.new(504)
      SSOPushClient.any_instance.stubs(:post_json!).raises(ex)
      @error_message_template = "SSOPushError: Error pushing to %s for user with uid %s, got response %d"

      exception = assert_raise(SSOPushError) do
        SSOPushClient.new(@application).reauth_user(@user.uid)
      end
      assert_equal @error_message_template % [@application.name, @user.uid, 504], exception.message
    end
  end

  context "rescuing other GdsApi errors" do
    should "add application name, user uid and error message to exception message" do
      ex = GdsApi::TimedOutException.new()
      SSOPushClient.any_instance.stubs(:post_json!).raises(ex)
      @error_message_template = "SSOPushError: Error pushing to %s for user with uid %s. %s"

      exception = assert_raise(SSOPushError) do
        SSOPushClient.new(@application).reauth_user(@user.uid)
      end
      assert_equal @error_message_template %
                    [@application.name, @user.uid, "Timeout connecting to application."], exception.message
    end
  end

  context "rescuing StandardError" do
    should "add application name, user uid and message to exception message" do
      ex = StandardError.new()
      SSOPushClient.any_instance.stubs(:post_json!).raises(ex)
      @error_message_template = "SSOPushError: Error pushing to %s for user with uid %s. StandardError"

      exception = assert_raise(SSOPushError) do
        SSOPushClient.new(@application).reauth_user(@user.uid)
      end
      assert_equal @error_message_template % [@application.name, @user.uid, 504], exception.message
    end
  end

end
