#!/usr/bin/env ruby

module ClassEnroll
    # reads student data from csv input file
    # and stores it in a array of student objects
    def store_student_data
        incsv = ARGV[0]
        input = CSV.read(incsv)
        student1 = Student.new(input[0].to_s, input[1].to_i, input[2].to_i, input[3].to_i, input[4].to_s)
        puts student1
    end
    
    # reads course data from csv input file
    # and stores it in a array of course objects
    def store_course_data
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

require 'csv'
#require_relative "course.rb"
require_relative "student.rb"
#require_relative "section.rb"
include ClassEnroll

ClassEnroll.store_student_data