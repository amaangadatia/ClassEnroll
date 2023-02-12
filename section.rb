#require_relative "class_enroll.rb"
#include ClassEnroll

class Section
    attr_accessor :course_num, :section_num, :num_studs_enrolled
    def initialize(course_num, section_num, num_studs_enrolled)
        @course_num = course_num
        @section_num = section_num
        @num_studs_enrolled = @num_studs_enrolled
    end
end