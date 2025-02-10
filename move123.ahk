#Requires AutoHotkey v2.0
#SingleInstance Force

; Create the destination directory if it doesn't exist
destPath := "C:\123"
DirCreate(destPath)

; Initialize shell object once at script start
shell := ComObject("Shell.Application")
shellWindows := shell.Windows()

Del::
{
    ; Quick check for text editing context first
    if (isFileRenaming()) {
        Send("{Del}")
        return
    }
    
    ; Get selected items
    selected := getSelected()
    if (selected.Length = 0) {
        Send("{Del}")
        return
    }
    
    ; Fast path for recycle bin operations
    if (GetActiveFolderPath() = destPath) {
        ; Fix: Iterate through selected items for recycling
        for item in selected {
            FileRecycle(item)
        }
        return
    }
    
    ; Generate timestamp once for all operations
    currentTime := FormatTime(A_Now, "yyyy.MM.dd-HH.mm.ss")
    
    ; Process files in batch
    errorMsg := ""
    for item in selected {
        if (item = "") {
            continue
        }
        
        ; Faster path detection
        isDir := InStr(FileExist(item), "D")
        
        ; Quick path construction
        SplitPath(item, &name)
        newPath := destPath "\" currentTime "-" name
        
        ; Single operation move attempt
        try {
            if (isDir) {
                DirMove(item, newPath)
            } else {
                FileMove(item, newPath)
            }
        } catch as err {
            ; Fallback to copy+delete if move fails (usually cross-drive)
            try {
                if (isDir) {
                    DirCopy(item, newPath)
                    DirDelete(item, 1)
                } else {
                    FileCopy(item, newPath)
                    FileDelete(item)
                }
            } catch as err2 {
                errorMsg .= "Error moving " item ": " err2.Message "`n"
            }
        }
    }
    
    ; Show errors if any occurred
    if (errorMsg) {
        MsgBox(errorMsg)
    }
    
    ; Single refresh at the end
    RefreshExplorer()
}

GetActiveFolderPath() {
    static hwndCache := Map()
    static pathCache := Map()
    
    try {
        activeWin := WinActive("A")
        ; Use cached path if available
        if (hwndCache.Has(activeWin)) {
            if (DirExist(pathCache[activeWin])) {
                return pathCache[activeWin]
            }
        }
        
        winClass := WinGetClass(activeWin)
        if (winClass ~= "CabinetWClass|ExploreWClass") {
            for window in shellWindows {
                try {
                    if (activeWin = window.HWND) {
                        path := window.Document.Folder.Self.Path
                        if (DirExist(path)) {
                            ; Cache the result
                            hwndCache[activeWin] := true
                            pathCache[activeWin] := path
                            return path
                        }
                    }
                }
            }
        }
    }
    return ""
}

RefreshExplorer() {
    for window in shellWindows {
        try window.Refresh()
    }
}

isFileRenaming() {
    static renamePattern := "Edit"
    static winClassPattern := "CabinetWClass|ExploreWClass|Progman|WorkerW"
    
    try {
        if (WinGetClass(WinActive("A")) ~= winClassPattern) {
            return ControlGetClassNN(ControlGetFocus("A")) ~= renamePattern
        }
    }
    return false
}

getSelected() {
    Static SWC_DESKTOP := 8
    Static SWFO_NEEDDISPATCH := 1
    Static explorerPattern := "Progman|WorkerW|(Cabinet|Expose)WClass"
    
    sel := []
    
    winClass := WinGetClass(hWnd := WinActive("A"))
    if !(winClass ~= explorerPattern)
        return sel
    
    try {
        if (winClass ~= "Progman|WorkerW") {
            shellFolderView := shellWindows.FindWindowSW(0, 0, SWC_DESKTOP, 0, SWFO_NEEDDISPATCH).Document
        } else {
            for window in shellWindows {
                if (hWnd = window.HWND) {
                    shellFolderView := window.Document
                    break
                }
            }
        }
        
        for item in shellFolderView.SelectedItems {
            try {
                if (FileExist(item.Path) || DirExist(item.Path))
                    sel.Push(item.Path)
            }
        }
    }
    
    return sel
}
