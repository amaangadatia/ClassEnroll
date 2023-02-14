#require_relative 'class_enroll'
require_relative 'section'

class Course
    #include ClassEnroll

    attr_reader :course_num, :num_sections, :min_enroll, :max_enroll, :prereq_courses, :sections
    def initialize(course_num, num_sections, min_enroll, max_enroll, prereq_courses)
        @course_num = course_num
        @num_sections = num_sections
        @min_enroll = min_enroll
        @max_enroll = max_enroll
        @prereq_courses = prereq_courses.split(";")
        @sections = Hash.new
    end

    # creates section for a course
    def enroll_student(student)
        # check if section needs to be created or if section exists
        # create section if no section exists or if existing section has already reached minimum capacity
        # add section to section hash map
        # add student to section

        # if section exists, add student
        # Update student object with course id they were put in

        # section = Section.new(course_num, section_num)
        # @sections.store(section_num, section)
    end    
end