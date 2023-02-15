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

    # checks if a section for a course needs to be created
    def get_section_to_put_student_in
        # create section if no section exists
        if @sections.length == 0
            section = Section.new(course_num, 1)
            @sections.store(1, section)
            return section
        end

        # returns a section if it hasn't reached it's minimum enrollment
        @sections.each do |section_num, section|
            if section.num_studs_enrolled < @min_enroll 
                return section
            end
        end

        # if existing sections have reached minimum enrollment
        # create a new section if course hasn't reached max allowed sections
        if @sections.length < @num_sections
            new_section_number = section_num + 1
            section = Section.new(course_num, new_section_number)
            @sections.store(new_section_number, section)
            return section
        end      
        
        # sort sections by least enrollment to balance enrollment across sections
        @sections = @sections.sort_by {|section_num, section| [section.num_studs_enrolled, section.section_num]}.to_h
        return @sections.values[0]
        
    end

    
    def enroll_student(student)
        section = get_section_to_put_student_in

        # add student to section
        section.add_student(student)

        # Update student object with course id they were put in
        student.enrolled_in(@course_num)
    end
    

end