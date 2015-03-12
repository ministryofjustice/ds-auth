class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = [Settings.sandbox_email_address]
  end
end
