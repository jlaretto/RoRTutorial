class User
  attr_accessor :name, :email

  def initialize(param={})
    @name =param[:name]
    @email=param[:email]
  end

  def formatted_email
    "#{@name} <#{@email}>"
  end

end
