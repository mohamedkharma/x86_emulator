NAME: Mohamed Kharma
Project 01

In this assignment, we were asked to build an emulator for x86, capable of running simple assembler 
code (binary format). This emulator uses dynamic memory and could run assembly code that contains 
instructions such as MOV, ADD, SUB and flages like ZF, SF, CF.

The way the emulator works is that it takes a file that is loaded with binary executable(.com) format 
and perform the instructions one by one until it sees the end call of CD 20. 

The mahsine will then process the code and the output that contain the results of the new registers
after running the assembly code is then is displayed for the user along with the assembly code that
was used to get the (.com) file.

Additionally, the file that the emulator executes must be in binary format (.com), or else the emulator 
will fail. Also, if the file is empty or the wrong file is used, then an error will occur for the user 
to change the file with the correct one.

Lastly, 
- Source is the cpp file.
- Examples are .com files stored inside "Examples" folder.
- I attached a pdf file that has pictures of the output for both EXAMPLE1 and EXAMPLE2.

