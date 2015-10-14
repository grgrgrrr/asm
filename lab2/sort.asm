assume cs:cseg, ds:dseg, ss:sseg

cseg    segment

bubblesort proc

bubblesort endp

start:
cseg    ends


dseg    segment byte
n db 5
arr db 5,2,1,3,4
dseg    ends


sseg    segment stack
        db      100h    dup(?)
sseg    ends
end start
