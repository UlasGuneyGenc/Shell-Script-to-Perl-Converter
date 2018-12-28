Shell Script to Perl Converter
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#	OS: UBUNTU 16.04 LTS			                       										  #
#                                                                                                 #
# 1-) To run the lex and yacc files you need to install lex and yacc on to Linux. In order to do  #                                                                              
#     that  write to the consolo line "sudo apt-get install flex  byacc"                          #
#                         																		  #
# 2-) For compilation, you must use the makeFile found in the lex and yacc files. To use it type  #
#     "make" in the console.This will will create an executable code in the directory you are in. #
#     It will create an executable code in the directory you are in.                              #
#                                                                                                 #
# 3-) To compile without makeFile and creating an executable file manually. You can use these:    #                           
#                                                              -yacc -d project.y        		  #
#                                                              -lex project.l            	 	  #
#                                                              -cc -w lex.yy.c y.tab.c -o project #
#                                                                                                 #
# 4-) To run the executable code, you must type "./project <inputFile>" in the console.           #
#     This will take the input file and convert the given code to perl code after that, it will   #
#     create an output file and will write the converted code on it                               #
#                                                                                                 #
# 5-) To test the converted code you can type "perl output" in the console. This will print       #
#     the output to console screen                                                                #
#                                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #