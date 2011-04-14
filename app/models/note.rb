class Note < ActiveRecord::Base
	belongs_to :course
  validates :course_id, :presence => true
  validates :date, :presence => true
  validates :title, :presence => true
  default_scope order('notes.course_id')
end
