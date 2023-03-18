=begin

Project name: Class Enroll
Description: This program simulates a portion of a course enrollment system for students at an educational institution.
             It generates a plan for enrolling students specifically into CS course sections based on the requests of students 
             and the availability of courses. While it focuses on the CS program at TCNJ, this application can eventually be
             general enough to be used at other types of institutions and be expanded in the future to handle more students, courses,
             various class sizes, and more restrictions.
             The application takes in two input files of csv format: one that contains the list of students and their requests and the
             other containing the courses that will be offered in the upcoming semester. It then outputs three files: one csv file containing
             the enrollment plan for each course, one csv file containing the enrollment plan for each student, and one text file containing
             the summary of the enrollment plan. 
Filename: main.rb
Description: This file contains the main program which runs the application.
Last modified on: 3/18/23

=end

#!/usr/bin/env ruby
require_relative 'class_enroll'

if __FILE__ == $0
    print "Welcome to the ClassEnroll program!\n\n"
    Course.store_course_data
    Student.store_student_data
    ClassEnroll.generate_enroll_plan
    Course.output_courses_enroll_plan
    Student.output_students_enroll_plan
    ClassEnroll.output_summary_enroll_plan
end