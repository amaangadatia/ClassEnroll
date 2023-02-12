#require_relative 'class_enroll'

class Course
    #include ClassEnroll

    attr_accessor :course_num, :num_sections, :min_enroll, :max_enroll, :prereq_courses
    def initialize(course_num, num_sections, min_enroll, max_enroll, prereq_courses)
        @course_num = course_num
        @num_sections = num_sections
        @min_enroll = min_enroll
        @max_enroll = max_enroll
        @prereq_courses = prereq_courses.split(";")
    end
end