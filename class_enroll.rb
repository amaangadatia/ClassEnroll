#!/usr/bin/env ruby
require 'csv'
require_relative 'student'
require_relative 'course'
require_relative 'section'

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
=begin
        @@students.each do |id, student|
            print "ID: " + student.student_id, "\n"
            print "Wants: " + student.courses_wanted.join(","), "\n"
        end
=end
    end
    
    # reads course data from csv input file
    # and stores it in a hash of course objects

    def store_course_data
        file = ARGV[1]
        CSV.foreach((file), headers: true, col_sep: ",") do |row|
            course = Course.new(row["Course-Num"].to_s, row["Num-Sections"].to_i, row["Min-Enroll"].to_i, row["Max-Enroll"].to_i, row["Prerequisites"].to_s)
            @@courses.store(row["Course-Num"], course)
        end
=begin
        @@courses.each do |num, course|
            print "Course: " + course.course_num, "\n"
            print "Prereqs: " + course.prereq_courses.join(","), "\n"

        end
=end
    end


    def output_courses_enroll_plan
        outcsv = ARGV[2]

        # if File.exists?(outcsv)
        #     File.delete(outcsv)
        # end

        headers = "Course-Num,Section-Num,Roster,Num-Enroll,Balance,Status\n"
        File.open(outcsv, "w") {|f| f.write(headers)}

        CSV.foreach(("courses_out.csv"), headers: true, col_sep: ",") do |row|
            File.open(outcsv, "a") {|f| f.write(row)}
        end        
    end

    def output_students_enroll_plan
        outcsv = ARGV[3]

        # if File.exists?(outcsv)
        #     File.delete(outcsv)
        # end

        headers = "StudentId,Courses,Num-Req,Reason\n"
        File.open(outcsv, "w") {|f| f.write(headers)}

        CSV.foreach(("students_out.csv"), headers: true, col_sep: ",") do |row|
            File.open(outcsv, "a") {|f| f.write(row)}
        end
    end

    def output_summary_enroll_plan(num_students, num_courses_torun, num_courses_tocancel)
        outcsv = ARGV[4]

        # if File.exists?(outcsv)
        #     File.delete(outcsv)
        # end

        File.open(outcsv, "w") { |f|
            f.write("Number of students: " + num_students.to_s + "\n")
            f.write("Number of course sections that can run: " + num_courses_torun.to_s + "\n")
            f.write("Number of course sections that may be cancelled: " + num_courses_tocancel.to_s + "\n")
        }
    

    end

    # checks if student submitted course requests
    def check_course_choices(student)
        if student.num_courses_wanted > 0 and not(student.courses_wanted.include? "None")
            return true
        else
            return false
        end
    end

    # checks if student meets the prerequisites for a course
    def meets_prereqs(student, course)
        # checks if the course has no prerequisites
        if course.prereq_courses.length() == 1 and course.prereq_courses.include? "None"
            return true
        end

        # if the course does have prerequisites, checks if the student meets them
        course.prereq_courses.each do |preq_course|
            if not(student.prereqs_completed.include? preq_course)
                return false
            end
        end
        return true
    end


    # creates suggested enrollment plan per student
    def generate_student_plan
        @@students.each do |id, student|
            #print id, check_course_choices(student), "\n"
            if check_course_choices(student)
                student.courses_wanted.each do |course_id|
                    course = @@courses[course_id]
                    if meets_prereqs(student, course)
                        course.enroll_student(student)
                    end
                    # print "Before meets_prereq: " + course_id, "\n"
                    # print id, meets_prereqs(student, course_id), "\n"
                end
            else
                print "Student " + id.to_s + " has no choices.\n"
            end
        end
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
    store_student_data
    generate_student_plan
    #output_courses_enroll_plan
    #output_students_enroll_plan
    #output_summary_enroll_plan(5, 4, 2)
end