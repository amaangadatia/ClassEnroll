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
Filename: student.rb
Description: This file contains the class for instantiating a Student object.
Last modified on: 2/16/23

=end

class Student
    @@students = Hash.new
    attr_reader :student_id, :num_units_done, :num_courses_wanted, :prereqs_completed, :courses_wanted, :courses_enrolled_in
    attr_accessor :valid_request, :reason   # The reason for why a student wasn't enrolled in a course section can vary, 
                                            # which is why get and set methods are needed for it. Same reasoning for 
                                            # checking if a student made a valid course request.

    def initialize(student_id, num_units_done, num_courses_wanted, prereqs_completed, courses_wanted)
        @student_id = student_id
        @num_units_done = num_units_done
        @num_courses_wanted = num_courses_wanted
        @prereqs_completed = prereqs_completed.split(";")
        @courses_wanted = courses_wanted.split(";")
        @courses_enrolled_in = Array.new
        @valid_request = false
        @reason = ""                # the default reason if a student gets enrolled in the course(s) they requested
    end

    def self.students
        @@students
    end

    # reads student data from user specified name of a csv input file line by line,
    # stores each student's data in a Student object, 
    # and then stores each Student in a hash of Student objects
    def self.store_student_data
        incsv = ""

        # checks if input file exists; if not, reprompts user to reenter file name
        loop do
            print "\nPlease type the name of the INPUT file containing STUDENTS' REQUESTS, including .csv extension: \n"
            incsv = gets
            incsv = incsv.chomp
            
            if not File.exists?(incsv)
                print "Error: File " + incsv + " doesn't exist. Please specify a valid file name. \n"
            else
                break
            end
        end

        CSV.foreach((incsv), headers: true, col_sep: ",") do |row|
            student = Student.new(row["StudentId"].to_s, row["Units"].to_i, row["Num-Courses"].to_i, row["Prereqs"].to_s, row["Choices"].to_s)
            @@students.store(row["StudentId"], student)
        end
    end

    # writes the enrollment plan per student to a csv file and outputs the file
    def self.output_students_enroll_plan
        print "\nPlease type the name of the file of where to OUTPUT the enrollment plan PER STUDENT, including .csv extension: \n"
        outcsv = gets
        outcsv = outcsv.chomp

        headers = ["StudentId","Courses","Num-Req","Reason"]
        CSV.open(outcsv, "w") do |csv|
            csv << headers
            Student.students.each do |id, student|
                csv << [id, student.courses_enrolled_in.join(";"), student.num_courses_wanted.to_s, student.reason]
            end
        end
    end

    # adds the course that the student was enrolled in into an array of courses the Student is enrolled in
    def enrolled_in(course_id)
        @courses_enrolled_in.push(course_id)
    end
end