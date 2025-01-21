# recycle-bin-parallels

Parallels removed the option to have a recycle bin in windows for shared folders. When you want to delete a file in windows you get a popup that warns you will permanently remove the file without passing by the recycle bin.

You can read about it here:

https://docs.parallels.com/pdfm-ug-20/parallels-desktop-for-mac-20-users-guide/use-windows-on-your-mac/setting-how-windows-works-with-macos/sharing-items-between-macos-and-windows/sharing-files-and-folders#how-deleting-files-from-shared-folders-works-in-windows

How I fixed it:

Created an autohotkey v2 script.

When you press the trigger shortcut:

1.If you have files or folders selected they will be instantly moved without confirmation to a special directory (C:/123/) which acts as your recycle bin.
You will find all the discarded files there.
Once in a while go there to empty it like you would do with the recycle bin.

No more popup/warning about the final deletion and also you recover the recycle bin function that was lost. win/win.

Note: The only difference I had to implement is prepending the date/time to the filenames when moving them to the special directory. This is because the "real" windows recycle bin allows to hold files even if they have the same name. This folder doesn't. So by having a timestamp attached you will never enounter a duplicate filename when deleting a file. Also another advantage is that you can order the folder by name and the files will be ordered by date of deletion, which is what you want in a recycle bin.

2.On the mac there is no "del" key like on windows keyboards. This is nuts.
So this script has a dual purpose: If you are trying to delete files/folders it will do just that.
But if you are editing text it will send the "del" command.

So combining 1+2 I have exactly recreated the windows "del" button functions but with the difference that files are being sent to the special directory instead of the recycle bin.

NOTE: This script is triggered by the "del" key on the keyboard by default. You can change it (read on).


3 options to proceed:
1. Take the code, save it to a .ahk file, download autohotkey v2 in windows and you are good to go.
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

The "del" key doesn't exist on mac, so I reassigned the "\\" Key (the one that sits between the Delete and the Enter buttons on a mac US Keyboard layout) to Del.

So that I finally have this Del button on the mac keyboard.

To recover the lost "\\" key I configured >> "Shift + \\" >> I get "\\"

You could also configure Option + \\ to give you the vertical line (which is the secondary char of that keystroke).


So you have 2 options:
1. You do like me and reassign the key, then the script will work when pressing the "del" key:
   
   A. You can do this for windows only via "sharpkeys" installed on windows (free)
   
![SharpKeys_2025-01-21 12-58-34](https://github.com/user-attachments/assets/4bd061fe-7e55-4be4-b9d6-4f9007c3fa7c)

   B. For windows + mac via bettermouse installed on mac (paid)

   <img width="330" alt="example" src="https://github.com/user-attachments/assets/fdb8adb4-8c51-40cb-9185-04983fe8b3df" />


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

    Then you can recompile the .exe file with autohotkey v2:

   ![explorer_2025-01-21 13-01-49](https://github.com/user-attachments/assets/ea386457-b1a6-44a9-83bb-93503d952cd0)

