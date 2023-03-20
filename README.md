# Assignment 1

## Instructions for running the program:

* Before starting, make sure that the input files for the student requests and the courses offered, respectively, are in the same directory as the source code files.

* To run the program, enter “ruby main.rb” on the command line.

* When prompted, enter the NAME of the INPUT FILE containing the COURSES BEING OFFERED to be processed, INCLUDING the .csv extension.
* When prompted, enter the NAME of the INPUT FILE containing the REQUESTS OF STUDENTS to be processed, INCLUDING the .csv extension.

* When prompted, enter the NAME of the OUTPUT FILE where you would like to see the contents of the enrollment plan BY COURSE to be written to, INCLUDING the .csv extension.

* When prompted, enter the NAME of the OUTPUT FILE where you would like to see the contents of the enrollment plan BY STUDENT to be written to, INCLUDING the .csv extension.

* When prompted, enter the NAME of the OUTPUT FILE where you would like to see the overall enrollment plan to be written to, INCLUDING the .txt extension.

* Afterwards, 3 output files will be generated in the current working directory, containing files for the enrollment plans by course and by student (.csv), respectively, and the overall summary of the enrollment plan (.txt).

## Known bugs, issues, limitations:

* This program is only limited to determining the enrollment plan for CS courses requested by students only.

* If a student is not placed into all the courses they requested, the only reasons given to them is that the course’s sections were “Full” or they “Didn’t provide 5 valid course choices.” 

* Students who didn’t provide 5 valid course choices don’t get at least one course.

* Priority for a student who requests an upper level course, meets its prerequisites, but doesn’t provide 5 valid choices is not reduced (i.e. not accounted for).

* When prompted, the names of input files must also have their respective extension attached to it (.csv or .txt).

* The input files must be located IN THE SAME DIRECTORY as the program source code files, otherwise the program will not recognize their names even if they’re typed correctly by the user.

* If the input csv files have a Carriage Return (CR or \r) on each line in addition to the newline character (\n), the data in the first column of each file (student IDs in the students’ requests file and the course numbers in the courses offered file, respectively) appear as blanks to the program, which will cause the program to crash.
  * Make sure to eliminate the CR characters on each line in the input csv files intended to be processed by opening the files in a text editor or VS Code, removing the CR characters, and saving the files as plain text with the same .csv extension. DO NOT eliminate the newline (\n) characters.
  * If the directory containing the program source files is located on a VM, download the input csv files to your local machine, open them in VS Code, and copy the contents of each file individually. Then, open VS Code for your VM, open the directory where the program resides, create new files for each of the input files respectively, and paste their contents in their respective files. This should eliminate the CR characters.
