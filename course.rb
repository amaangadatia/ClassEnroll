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
Filename: course.rb
Description: This file contains the class for instantiating a Course object.
Last modified on: 2/16/23

=end

require_relative 'section'

class Course
    @@courses = Hash.new
    @@total_sections_torun = 0
    @@total_sections_tocancel = 0
    attr_reader :course_num, :num_sections, :min_enroll, :max_enroll, :prereq_courses, :sections
    def initialize(course_num, num_sections, min_enroll, max_enroll, prereq_courses)
        @course_num = course_num
        @num_sections = num_sections
        @min_enroll = min_enroll
        @max_enroll = max_enroll
        @prereq_courses = prereq_courses.split(";")
        @sections = Hash.new                        # a hash of sections within a particular course
    end

    def self.courses
        @@courses
    end

    def self.total_sections_torun
        @@total_sections_torun
    end

    def self.total_sections_tocancel
        @@total_sections_tocancel
    end

    # reads course data from user specified name of a csv input file line by line,
    # stores each course's data in a Course object,
    # and then stores each Course in a hash of Course objects
    def self.store_course_data
        incsv = ""

        # checks if input file exists; if not, reprompts user to reenter file name
        loop do
            print "Please type the name of the INPUT file containing COURSES OFFERED, including .csv extension: \n"
            incsv = gets
            incsv = incsv.chomp
            
            if not File.exists?(incsv)
                print "Error: File " + incsv + " doesn't exist. Please specify a valid file name. \n"
            else
                break
            end
        end
        
        CSV.foreach((incsv), headers: true, col_sep: ",") do |row|
            course = Course.new(row["Course-Num"].to_s, row["Num-Sections"].to_i, row["Min-Enroll"].to_i, row["Max-Enroll"].to_i, row["Prerequisites"].to_s)
            @@courses.store(row["Course-Num"], course)
        end
    end

    # writes the enrollment plan per course to a csv file and outputs the file
    def self.output_courses_enroll_plan
        print "\nPlease type the name of the file of where to OUTPUT the enrollment plan PER COURSE, including .csv extension: \n"
        outcsv = gets
        outcsv = outcsv.chomp

        headers = ["Course-Num","Section-Num","Roster","Num-Enroll","Balance","Status"]
        CSV.open(outcsv, "w") do |csv|
            csv << headers
            Course.courses.each do |course_num, course|
                course.sections.each do |section_num, section|
                    balance = course.max_enroll - section.num_studs_enrolled

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
        end
    end

    # returns the section of a course in which a student is to be placed in
    def get_section_to_put_student_in
        # creates a section if no section exists
        if @sections.length == 0
            section = Section.new(course_num, 1)
            @sections.store(1, section)
            return section
        end

        # keeps track of the previous section to determine the number for a new section
        # if a new section is to be created
        last_section_num = 0

        # returns a section if it hasn't reached its minimum enrollment
        @sections.each do |section_num, section|
            if section.num_studs_enrolled < @min_enroll
                return section
            end
            last_section_num = section_num
        end

        # if existing section(s) have reached minimum enrollment, create a 
        # new section if the course hasn't reached the max number of allowed sections
        if @sections.length < @num_sections
            new_section_number = last_section_num + 1
            section = Section.new(course_num, new_section_number)
            @sections.store(new_section_number, section)
            return section
        end      

        # sort sections by least enrollment to balance enrollment across sections
        @sections = @sections.sort_by {|section_num, section| [section.num_studs_enrolled, section.section_num]}.to_h
        
        # checks if a section has exceeded its max enrollment
        @sections.each do |section_num, section|
            if section.num_studs_enrolled < max_enroll
                return section
            end
        end

        return nil
    end

    # enrolls a student in a course section
    def enroll_student(student)
        section = get_section_to_put_student_in

        # if section cannot accept more students, give reason for not enrolling student
        if section.nil? 
            student.reason = "Full"
            return
        end

        # adds student to section
        section.add_student(student)

        # Update student object with course number they were put in
        student.enrolled_in(@course_num)
    end
end