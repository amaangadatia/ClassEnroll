#require_relative 'class_enroll'

class Student
    #include ClassEnroll

    attr_accessor :student_id, :num_units_done, :num_courses_wanted, :prereqs_completed, :courses_wanted
    def initialize(student_id, num_units_done, num_courses_wanted, prereqs_completed, courses_wanted)
        @student_id = student_id
        @num_units_done = num_units_done
        @num_courses_wanted = num_courses_wanted
        @prereqs_completed = prereqs_completed.split(";")
        @courses_wanted = courses_wanted.split(";")
=begin
        print prereqs_completed
        puts
        print @prereqs_completed
        puts
=end
    end
end