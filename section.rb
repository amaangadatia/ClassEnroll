#require_relative "class_enroll.rb"
#include ClassEnroll
require_relative 'student'

class Section
    attr_reader :course_num, :section_num, :num_studs_enrolled, :students
    def initialize(course_num, section_num)
        @course_num = course_num
        @section_num = section_num
        @num_studs_enrolled = 0
        @students = Hash.new
    end

    def add_student(student_id, student)
        @students.store(student_id, student)
        @num_studs_enrolled += 1
    end

end