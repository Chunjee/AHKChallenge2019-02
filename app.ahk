SetBatchLines -1 ;Go as fast as CPU will allow
#NoTrayIcon
#SingleInstance force

; Includes
#Include %A_ScriptDir%\node_modules
#Include array.ahk\export.ahk
#Include biga.ahk\export.ahk
#Include permutations.ahk\export.ahk


; instanciate classes
A := new biga()


; inputs
inputs := [ "GRAPES", "TRIANGLE", "PRAISE", "SPEAR"]


;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
; MAIN
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/
; read words.txt into an array and remove any `r, `n, or other whitespace
wordsArr := fn_ReadFileAndApplyToInstantLookupTable(A_ScriptDir "\words.txt")

for _, value in inputs {
	matches := fn_findAllAnagramsInInstantLookupTable(value, wordsArr)
	; msgbox any
	msgbox, % matches.join(", ")
}
exitapp



;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
; Functions
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/

fn_ReadFileAndApplyToInstantLookupTable(param_filepath)
{
	FileRead, OutputVar, % A_ScriptDir "\words.txt"
	wordsArr := A.map(A.split(OutputVar, "`n"), A.trim)

	wordsArr2 := []
	; remap words.txt to instantly loopup key
	for _, value in wordsArr {
		wordsArr2[value] := true
	}
	return wordsArr2
}

fn_findAllAnagramsInInstantLookupTable(param_anagramSource, param_lookupTable)
{
	anagrams := permutations.generate(param_anagramSource, true)
	validArray := []
	; check all if all anagrams exist in words.txt array
	for _, value2 in anagrams {
		if (param_lookupTable[value2]) {
			; store any valid matches
			validArray.push(value2)
		}
	}
	return validArray
}

;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
; Classes
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/
