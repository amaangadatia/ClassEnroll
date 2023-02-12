#!/usr/bin/env ruby
require 'csv'
require_relative 'student'
require_relative 'course'

module ClassEnroll

    @@students = Hash.new
    @@courses = Hash.new

    # reads student data from csv input file
    # and stores it in a hash of student objects
    def store_student_data
        incsv = ARGV[0]
        CSV.foreach((incsv), headers: true, col_sep: ",") do |row|
            student = Student.new(row["StudentId"].to_s, row["Units"].to_i, row["Num-Courses"].to_i, row["Prereqs"].to_s, row["Choices"].to_s)
            @@students.store(row["StudentId"], student)
        end

        @@students.each do |id, student|
            print student.student_id,
            puts
            print student.courses_wanted, "\n"
        end
    end
    
    # reads course data from csv input file
    # and stores it in a hash of course objects

    def store_course_data
        file = ARGV[0]
        CSV.foreach((file), headers: true, col_sep: ",") do |row|
            course = Course.new(row["Course-Num"].to_s, row["Num-Sections"].to_i, row["Min-Enroll"].to_i, row["Max-Enroll"].to_i, row["Prerequisites"].to_s)
            @@courses.store(row["Course-Num"], course)
        end

        @@courses.each do |num, course|
            print course.course_num,
            puts
            print course.prereq_courses, "\n"
        end
    end


    # creates suggested enrollment plan per student
    def generate_student_plan
    end

    # creates suggested enrollment plan per course
    def generate_course_plan
    end

    # creates txt file with a summary of the general enrollment plan
    def generate_summary_plan
    end

    # creates enrollment plans per student and per course, respectively
    # creates summary of general enrollment plan in txt file
    # utilizes the three methods above
    def generate_enroll_plan
    end
end


include ClassEnroll

if __FILE__ == $0
    store_course_data
    #store_student_data
end