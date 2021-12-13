#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
#Include String-object-file.ahk
SetTitleMatchMode, 2

FileSelectFile, archon_container_path,,, Select the Archon container listing file:
If (ErrorLevel == 1)
  Return
Else
{
  Containers := StrObj(archon_container_path)
}

series := Containers.Series1
subseries := Containers.Series1.1.title
MsgBox,,, %series%`n%subseries%