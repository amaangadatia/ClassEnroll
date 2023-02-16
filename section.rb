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
Filename: section.rb
Description: This file contains the class for instantiating a [Course] Section object.
Last modified on: 2/16/23

=end

require_relative 'student'

class Section
    attr_reader :course_num, :section_num, :num_studs_enrolled, :students
    def initialize(course_num, section_num)
        @course_num = course_num
        @section_num = section_num
        @num_studs_enrolled = 0
        @students = Array.new       # an array of IDs representing Students enrolled in the course section, aka "the roster"
    end

    # adds a student to a course section and increments the roster count by 1
    def add_student(student)
        @students.push(student.student_id)
        @num_studs_enrolled += 1
    end
end