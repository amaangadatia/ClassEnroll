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
Filename: class_enroll.rb
Description: This file contains the main program where input files are processed, students are enrolled in courses, and output files containing
             the enrollment plans by course and by student, as well as an overall summary of the enrollment plan are generated.
Last modified on: 3/18/23

=end

require 'csv'
require_relative 'student'
require_relative 'course'
require_relative 'section'

class ClassEnroll

    @@total_students_enrolled = 0

    # writes the overall summary of the enrollment plan of students and courses to a txt file and outputs the file
    def self.output_summary_enroll_plan
        print "\nPlease type the name of the file of where to OUTPUT the ENROLLMENT PLAN SUMMARY, including .txt extension: \n"
        outcsv = gets
        outcsv = outcsv.chomp

        Student.students.each do |id, student|
            if student.valid_request == true
                @@total_students_enrolled += 1
            end
        end

        File.open(outcsv, "w") { |f|
            f.write("Number of students: " + @@total_students_enrolled.to_s + "\n")
            f.write("Number of course sections that can run: " + Course.total_sections_torun.to_s + "\n")
            f.write("Number of course sections that may be cancelled: " + Course.total_sections_tocancel.to_s + "\n")
        }

        print "\n******************** SUMMARY OF ENROLLMENT PLAN ********************\n"
        print "Number of students: " + @@total_students_enrolled.to_s + "\n"
        print "Number of course sections that can run: " + Course.total_sections_torun.to_s + "\n"
        print "Number of course sections that may be cancelled: " + Course.total_sections_tocancel.to_s + "\n"
        print "********************************************************************\n"
    end

    # checks if a student submitted 5 course requests and didn't put any of them as "None"
    # returns a boolean value
    def self.check_course_choices(student)
        if (student.num_courses_wanted > 0 and student.num_courses_wanted < 6) and student.courses_wanted.length() == 5
        # if student.num_courses_wanted > 0 and not(student.courses_wanted.include? "None")
            return true
        else
            student.reason.push("Didn't provide 5 valid course choices")
            return false
        end
    end

    # checks if a student meets the prerequisites for a course
    # returns a boolean value
    def self.meets_prereqs(student, course)
        # checks if the course has no prerequisites
        if course.prereq_courses.length() == 1 and course.prereq_courses.include? "None"
            return true
        end

        # if the course does have prerequisites, checks if the student meets them
        course.prereq_courses.each do |preq_course|
            if not(student.prereqs_completed.include? preq_course)
                student.reason.push("Did not meet prereqs for " + course.course_num)
                return false
            end
        end

        return true
    end

    # enrolls a student in a requested course, but making sure they don't get enrolled 
    # in more than 2 courses and more than the number of courses they requested
    def self.meets_enrollment_conditions(student, course)
        return (meets_prereqs(student, course) and student.courses_enrolled_in.length < student.num_courses_wanted and student.courses_enrolled_in.length < 2)
    end

    # passes over all students and enrolls them in one course to begin with
    def self.enroll_in_one_course
        # sorts students by number of units completed in descending order
        # so priority goes to student(s) with higher amount of units
        Student.students.sort_by {|id, student| -student.num_units_done}

        # loops through each student in the Student hash
        Student.students.each do |id, student|
            # verify their course choices
            if check_course_choices(student)
                # loops through each student's list of requested courses
                student.courses_wanted.each do |course_id|
                    if course_id == "None"
                        next
                    end

                    course = Course.courses[course_id]

                    # verifies that student makes a valid course request
                    # even if out of a student's course choices they requested one invalild (nonexisting) course,
                    # the student will not be counted in the "Number of students" output in the summary of the enrollment plan
                    if course.nil?
                        student.valid_request = false
                    else
                        student.valid_request = true
                    end

                    if meets_enrollment_conditions(student, course)
                        is_enrolled = course.enroll_student(student)
                        
                        # if student got enrolled in their first choice, move to the next student
                        # to ensure every student gets at least one course to begin with
                        if is_enrolled == true
                            break
                        end
                    end
                end
            end
        end
    end
    
    # attempts to enroll students in additional courses up to the amount they requested (max of 2)
    def self.enroll_in_more_courses

        # loops through each student in the Student hash
        Student.students.each do |id, student|
            # verify their course choices
            if check_course_choices(student)
                # loops through each student's list of requested courses
                student.courses_wanted.each do |course_id|
                    if course_id == "None"
                        next
                    end

                    course = Course.courses[course_id]

                    # verifies that student makes a valid course request
                    # even if out of a student's course choices they requested one invalild (nonexisting) course,
                    # the student will not be counted in the "Number of students" output in the summary of the enrollment plan
                    if course.nil?
                        student.valid_request = false
                    else
                        student.valid_request = true
                    end

                   
                    if meets_enrollment_conditions(student, course)
                        # if a student is already enrolled in a course, go to the next course
                        # they requested to determine if they can be enrolled in it
                        if student.courses_enrolled_in.include? course_id
                            next
                        end

                        course.enroll_student(student)
                    end
                end
            end
        end
    end

    # generates the enrollment plan for every student and every course
    def self.generate_enroll_plan
        enroll_in_one_course
        enroll_in_more_courses
    end
end