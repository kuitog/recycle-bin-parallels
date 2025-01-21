# recycle-bin-parallels

Parallels removed the option to have a recycle bin in windows for shared folders from version 19, you can read about it here:
https://docs.parallels.com/pdfm-ug-20/parallels-desktop-for-mac-20-users-guide/use-windows-on-your-mac/setting-how-windows-works-with-macos/sharing-items-between-macos-and-windows/sharing-files-and-folders#how-deleting-files-from-shared-folders-works-in-windows

How I fixed it:
Created an autohotkey v2 script.
When you press the trigger shortcut:
1.If you have files or folders selected they will be instantly moved without confirmation to a special directory (C:/123/) which acts as your recycle bin. You will find all the discarded files there. Once in a while go there to empty it like you would do with the recycle bin.
No more popup/warning about the final deletion and also you recover the recycle bin function that was lost. win/win.

2.I also hate that on the mac there is no "del" key like on windows keyboards.
So this script when you are editing text sends the "del" command.

So combining 1+2 I have exactly recreated the windows "del" button functions but with the difference that files are being sent to the special directory instead of the recycle bin.

3 options to proceed:
1. Take the code, save it to a .ahk file, download autohotkeyv2 in windows and you are good to go.
2. You can also compile it with autohotkey to an exe file
3. You can download the precompiled release .exe file that it's ready to go
  
For convenience: put a shortcut to the exe file in the startup directory of windows so that it gets executed automatically at computer startup and it's always active.
To do this:
Press Win+R
Write: shell:startup
Press enter
Create a shortcut to the .exe file and move the shortcut to this folder



Also just to give you my complete setup:
The autoit function is triggered by the "del" key.
The "del" key doesn't exist on mac, so I reassigned the "\" Key (the one that sits between the Delete and the Enter buttons on a mac US Keyboard layout) to Del.
So that I finally have this Del button on the mac keyboard.
To recover the lost "\" key I configured >> "Shift + \" >> I get "\"
You could also configure Option + \ to give you the vertical line (which is the secondary char of that keystroke).


So you have 2 options:
1. You do like me and reassign the key, then the script will work when pressing the "del" key:
   A. You can do this for windows only via "sharpkeys" installed on windows (free)
   B. For windows + mac via bettermouse installed on mac (paid)

3. You can change in the autohotkey script the trigger key to any combination you like.
   Note: if you need to change the script, you have to download the source code, edit it and compile it in autohotkey v2
   
    Change this line:

    Del::
   
    To whatever you want.
    For example:

    ^1::
    Would trigger the function when pressing ctrl + 1
   
    #n::
    Win + n

    Here you have the basic hotkeys list:
    https://www.autohotkey.com/docs/v2/howto/WriteHotkeys.htm#Basic_Hotkeys
