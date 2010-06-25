class String
  def self.random(length=10)
     ('a'..'z').sort_by {rand}[0,length].join
   end
end