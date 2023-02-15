#!/usr/bin/env ruby
require 'csv'
require_relative 'student'
require_relative 'course'
require_relative 'section'

module ClassEnroll

    @@students = Hash.new
    @@courses = Hash.new
    @@total_students_enrolled = 0
    @@total_sections_torun = 0
    @@total_sections_tocancel = 0

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

        headers = ["Course-Num","Section-Num","Roster","Num-Enroll","Balance","Status"]
        CSV.open(outcsv, "w") do |csv|
            csv << headers
            @@courses.each do |course_num, course|
                course.sections.each do |section_num, section|
                    balance = course.max_enroll - section.num_studs_enrolled
                    @@total_students_enrolled += section.num_studs_enrolled

                    if section.num_studs_enrolled < course.min_enroll
                        status = "Cancel"
                        @@total_sections_tocancel += 1
                    else
                        status = "Ok"
                        @@total_sections_torun += 1
                    end

                    csv << [course_num, section_num, section.students.join(";"), section.num_studs_enrolled.to_s, balance.to_s, status]
            end
        end

        # File.open(outcsv, "w") {|f| f.write(headers)}

        # CSV.foreach(("courses_out.csv"), headers: true, col_sep: ",") do |row|
        #     File.open(outcsv, "a") {|f| f.write(row)}
        # end        
    end

    def output_students_enroll_plan
        outcsv = ARGV[3]

        # if File.exists?(outcsv)
        #     File.delete(outcsv)
        # end

        headers = ["StudentId","Courses","Num-Req","Reason"]
        CSV.open(outcsv, "w") do |csv|
            csv << headers
            @@students.each do |id, student|
                csv << [id, student.courses_enrolled_in.join(";"), student.num_courses_wanted.to_s, "TBD"]
                #row = id + "," + student.courses_enrolled_in.join(";") + "," + student.num_courses_wanted.to_s + "," + "TBD"
            end
        end
        # File.open(outcsv, "w") {|f| f.write(headers)}

        
        # CSV.foreach(("students_out.csv"), headers: true, col_sep: ",") do |row|
        #     File.open(outcsv, "a") {|f| f.write(row)}
        # end
    end

    def output_summary_enroll_plan
        outcsv = ARGV[4]

        # if File.exists?(outcsv)
        #     File.delete(outcsv)
        # end

        File.open(outcsv, "w") { |f|
            f.write("Number of students: " + @@total_students_enrolled.to_s + "\n")
            f.write("Number of course sections that can run: " + @@total_sections_torun.to_s + "\n")
            f.write("Number of course sections that may be cancelled: " + @total_sections_tocancel.to_s + "\n")
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


    # creates enrollment plans per student and per course, respectively
    # creates summary of general enrollment plan in txt file
    # utilizes the three methods above
    def generate_enroll_plan
        # sorts students by number of units completed in descending order
        # so priority goes to student(s) with higher amount of units
        @@students.sort_by {|id, student| -student.num_units_done}

        @@students.each do |id, student|
            #print id, check_course_choices(student), "\n"
            if check_course_choices(student)
                student.courses_wanted.each do |course_id|
                    course = @@courses[course_id]
                    if meets_prereqs(student, course) and 
                        (student.courses_enrolled_in.length == 2 or 
                        student.courses_enrolled_in.length == student.num_courses_wanted)

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

end


include ClassEnroll

if __FILE__ == $0
    store_course_data
    store_student_data
    generate_enroll_plan
    output_courses_enroll_plan
    output_students_enroll_plan
    output_summary_enroll_plan
end