SetBatchLines -1 ;Go as fast as CPU will allow
#NoTrayIcon
#SingleInstance force

; Includes
#Include %A_ScriptDir%\node_modules
#Include biga.ahk\export.ahk

A := new biga()
table := []

; inputs
inputs := [ "GRAPES", "TRIANGLE", "PRAISE", "SPEAR"]
; exitapp

; read words.txt into an array and remove any `r, `n, or other whitespace
FileRead, OutputVar, % A_ScriptDir "\words.txt"
wordsArr := A.map(A.split(OutputVar, "`n"), A.trim)

wordsArr2 := []
; remap words.txt to instantly loopup key
for _, value in wordsArr {
	wordsArr2[value] := true
}

for _, value in inputs {
	anagrams := permutations.generate(value, true)
	validArray := []
	for _, value2 in anagrams {
		if (wordsArr2[value2]) {
			validArray.push(value2)
		}
	}
	msgbox, % A.print(validArray)
}

msgbox, % A.print(A.sample(anagrams))
exitapp



wordsArr2 := []
loop, % wordsArr.Count() {
	wordsArr2[wordsArr[A_Index]] := 1
}

; fill the table since it has a faster lookup
; for _, value in wordsArr {
;     table[value] := 1
; }
; table.printTableData()

;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
; MAIN
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/

loop, % inputs.Count() {
	msgbox, % fn_findAnagramsInDictionary(wordsArr2, inputs[A_Index])
}
ExitApp


;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
; Functions
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/

; returns an array of all anagrams that match the supplied dictionary
fn_findAnagramsInDictionary(param_dictionary, param_string)
{
	; global table, A
	outputArray := []
	; possibleAnagramsArray := fn_makeAllAnagrams(param_string)

	msgbox, looking up matches now
	for _, value in possibleAnagramsArray {
		if (param_dictionary[value] == 1) {
			msgbox, %value% was true!
		}
	}
	; msgbox, % A.printObj(possibleAnagramsArray)
	; return A.join(A.intersection(possibleAnagramsArray, param_dictionary), ", ")
	return A.join(outputArray, "") ; join the output array into a msgbox-able string
}


class permutations {
	; --- Static Methods ---
	generate(param_array, param_stringOut:=false, param_maxPermutation:="") {
		; prepare inputs
		if (!IsObject(param_array)) {
			param_array := StrSplit(param_array)
		}

		this.outArray := []
		l_length := param_array.Count()
		l_permutationsArray := this.gen(l_length, param_array, param_maxPermutations)
		; return array of arrays if user didn't specify param_stringOut
		if (param_stringOut == false) {
			return l_permutationsArray
		}
		l_OutArray := []
		for _, l_obj in l_permutationsArray {
			l_string := ""
			for l_index, l_value in l_obj {
				l_string .= l_value
				;  (index < this.Count() ? "" : "")
			}
			l_OutArray.push(l_string)
		}
		return l_OutArray
	}
	
	gen(param_n:="", param_array:="", param_maxPermutations:="") {
		; prepare defaults
		if (param_n == "") {
			param_n := param_array.Count()
		}

		; create
		if (param_n == 1) {
			this.outArray.push(param_array.Clone())
		}
		loop, % param_n
		{
			if (param_maxPermutations) {
				if (param_maxPermutations <= this.outArray.Count()) {
					return this.outArray
				}
			}
			this.gen(param_n - 1, param_array, param_maxPermutations)
			if (mod(param_n, 2) != 0) {
				this._swap(param_array, 1, param_n) ;odd
			} else {
				this._swap(param_array, A_Index, param_n)
			}
		}
		return this.outArray
	}

	_swap(param_array, param_index1, param_index2) {
		tempVar := param_array[param_index1]
		param_array[param_index1] := param_array[param_index2]
		param_array[param_index2] := tempVar
		return param_array
	}
}