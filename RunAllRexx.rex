/*  RunAllRexx.rex

Finds Rexx programs, builds a menu
    and runs them

*/
infile = "infile.txt"                 /*   file to get dir command output */
"dir *.rex /b >" infile                /*  writes dir command output to output file  */

name. = ""                              /*  set our stem variables  */
choice. = ""
name.0 = "Exit"

do count = 1 to 99999                    /*  read rexx program names and          
    if lines(infile) = 0 then leave          saves them in name and choice stem variables */
    linein = linein(infile)
    parse var linein name "."
    name.count = name
    choice.count = linein
end

rc = lineout(infile)         /* it closes the input file */
names = count - 1            /* this counts how many rexx files there are */
if nemes = 0 then leave

do forever                 /*  show menu of program names  */
    call showmenu   

    pull choice
    if choice = 0 then exit

    if choice = "" then do     /*  pressing enter with choice calls help display  */
        call helpuser
        iterate
    end

    call checkchoice                     /*   subroutine to check the choice  */

    if (error = 1) | (choice.choice = "") then do
        say "'"savechoice"'" "is invalid, press enter to continue"
        pull
        iterate
    end

    "start" type choice.choice /* edit and run program as requested  */
end

exit

ShowMenu:                              /*  menu to display program names   */

"cls"

say "Type a number followed by e, r, p or h and press enter"
say "        e=edit, r=rexx, p=rexxpaws, h=rexxhide"
say "                 press enter for Help"
say

do count = 0 to names                  /*  show the names preceeded by a line count */
    say right(count,2)")" name.count     /*   and with the .rex stripped off */
    end

say

return

Helpuser:                                   /*  menu display   */ 

say
say "Here's some help"
say "-------------------------"
say "Type 0 and press enter to exit"
say 
say "Type any other number from the menu followed by the letter e, r, p, h"
say "depending on how want to view or run the rexx  program"
say
say "will edit the progrom on line 1 using notepad"
say "will run the program on line 1 using rexx.exe(regular)"
say "will run program on line 1 using rexxpaws.exe (pauses at end)"
say "will run program on line 1 using rexxhide.exe (hides rexx console)"
say
say  "rexx will not work if the selected program needs the rexx console"
say
say "Hope this helps"
say "               ****press any key to continue****"
pull

return

CheckChoice:

savechoice = choice                                   /* save originally typed choice */
choice = strip(choice)                                 /* remove leading and trailing spaces */
type = right(choice,1)                                 /* type the right most character  */
choice = left(choice,length(choice)-1)                 /* remove the type from choice variable */
choice = strip(choice)                                 /*   remove leading and trailing spaces */

error = ""

select                                                /* make sure type is one of e, r, p, h */
    when type "E" then type = "notepad"          
    when type "R" then type = "rexx.exe"
    when type "P" then type = "rexxpaws.exe"
    when type "H" then type = "rexxhide.exe"
    otherwise error = 1                             /* if not we have an error */ 
end

return
