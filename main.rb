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