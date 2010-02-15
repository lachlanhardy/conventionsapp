# This helper ensures we have a proper, authenticated, and signed up user.
def auth
 if logged_in?
   # do nothing
 else
   unless env['warden'].authenticate!
     throw(:warden)
   end
 end
end

# This helper checks if we are correctly logged in and signed up. If we are logged in but not signed up, forces us to complete the sign up
def logged_in?
  if gmail_user && !gmail_user.kind_of?(Warden::GoogleApps::User)
  # fully logged in and signed up
    return true
  elsif gmail_user
    # not signed up. Send to sign up form.
    throw(:redirect, '/signup/')
  else
    false
  end
end

