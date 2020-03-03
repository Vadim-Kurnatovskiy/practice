# app/models/consultation.rb
class Consultation < ActiveRecord::Base
  attr_accessible :content, :author_name, :author_email
  
  def author_name_string
    author_name.present? ? author_name : 'Аноним'
  end
end

class Question < ActiveRecord::Base
  attr_accessible :content, :author_name, :author_email
  
  def author_name_string
    author_name.present? ? author_name : 'Аноним'
  end
end