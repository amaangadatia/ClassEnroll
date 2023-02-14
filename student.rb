#require_relative 'class_enroll'

class Student
    #include ClassEnroll

    attr_reader :student_id, :num_units_done, :num_courses_wanted, :prereqs_completed, :courses_wanted
    def initialize(student_id, num_units_done, num_courses_wanted, prereqs_completed, courses_wanted)
        @student_id = student_id
        @num_units_done = num_units_done
        @num_courses_wanted = num_courses_wanted
        @prereqs_completed = prereqs_completed.split(";")
        @courses_wanted = courses_wanted.split(";")
        @courses_enrolled_in = Array.new
=begin
        print prereqs_completed
        puts
        print @prereqs_completed
        puts
=end
    end

    def enrolled_in(course_id)
        @courses_enrolled_in.push(course_id)
    end

end