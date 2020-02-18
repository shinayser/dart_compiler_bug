# dart_compiler_bug

A project to reproduce a Dart  compiler bug.

## What is happening?

The problem is that because of something (that I don't know) the variable 'localId' being passed as parameter to the function
'finishOrCancelRecover' (of the class 'Requests') is being replaced by some other variable in memory. 

I've added as much as code I could to reproduce my real world production app, so you will find some boilerplate code.

Also, I tried to reproduce this problem on a pure dart cli project (no Flutter dependency) but could't make it.

Just run the project (I tested on a physical device only), follow the steps on screen and look at logs when asked.

(probably a pointers mess?)
