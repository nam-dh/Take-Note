class Course < ActiveRecord::Base
  belongs_to :user
	has_many :note, :order => 'date DESC, title DESC', :dependent => :destroy
  default_scope order('courses.user_id')
end
