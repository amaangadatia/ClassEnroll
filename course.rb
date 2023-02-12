#require_relative "class_enroll.rb"
#include ClassEnroll

class Course
    attr_accessor :course_num, :num_sections, :prereq_courses, :sections

    def initialize(course_num, num_sections, prereq_courses, sections)
        @course_num = course_num
        @num_sections = num_sections
        @prereq_courses = prereq_courses
        @sections = sections
    end

end