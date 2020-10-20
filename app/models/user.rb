class User < ApplicationRecord

	def self.authenticate(ln, pass)
#	  u=find(:first, :conditions=>["login = ?", login])
# TODO fix this as possible SQL injection:
	u = User.find_by(login: ln)
	  return nil if u.nil?
	  if pass==u.password
	  	return u
	  else
	  	return nil
	  end
	end  
	
end
