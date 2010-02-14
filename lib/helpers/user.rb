# This helper ensures we have a proper, authenticated, and signed up user.
def auth
  if gmail_user && !gmail_user.kind_of?(Warden::GoogleApps::User)
    # we are logged in with a proper, setup user. all good
  elsif gmail_user
    # we have a un setup user. sent to setup page
    redirect '/signup/'
  else
    # not logged in. Authenticate
    unless env['warden'].authenticate!
      throw(:warden)
    end
  end
end

