namespace ConsolePaint

import System

internal static class Numeral:
	
//	alphabet = ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
//	"Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z")
	
	romanUnits = ("I", "X", "C", "M")
	romanFives = ("V", "L", "D")
	
	greekUnits = ("Α'", "Β'", "Γ'", "Δ'", "Ε'", "Ϝ", "Ζ'", "Η'", "Θ'")
	greekTens = ("Ι'", "Κ'", "Λ'", "Μ'", "Ν'", "Ξ'", "Ο'", "Π'", "Ϙ'")
	greekHundreds = ("Ρ'", "Σ'", "Τ'", "Υ'", "Φ'", "Χ'", "Ψ'", "Ω'", "Ͳ'")
	greekThousands = (",Α", ",Β", ",Γ", ",Δ", ",Ε", ",Ϝ", ",Ζ", ",Η", ",Θ")
	
	public def ToGreek(num as int):
		
		# it is assumed no number greater than 9999 will be fed to this def
		
		numStr = "$num"
		numGreek as (string) = array(string, numStr.Length)
		index as byte = 0
		
		if num >= 1000:
			numGreek[index] = greekThousands[int.Parse("$(numStr[index++])") - 1]
			
		if num >= 100:
			
			if int.Parse("$(numStr[index])") == 0:
				numGreek[index++] = ""
			
			else:
				numGreek[index] = greekHundreds[int.Parse("$(numStr[index++])") - 1]
			
		if num >= 10:
			
			if int.Parse("$(numStr[index])") == 0:
				numGreek[index++] = ""
			
			else:			
				numGreek[index] = greekTens[int.Parse("$(numStr[index++])") - 1]
		
		if int.Parse("$(numStr[index])") == 0:
			numGreek[index] = ""

		else:
			numGreek[index] = greekUnits[int.Parse("$(numStr[index])") - 1]
		
		return string.Concat(numGreek)
		
	private def BuildRomanUnitString(num as int, level as int):
		
		result = ""
		
		for count in range(num):
			result += romanUnits[level]
			
		return result
		
	private def BuildRomanNumString(num as int, level as int):
		
		if num == 0:
			return ""
		
		if num == 9:
			return "$(romanUnits[level])$(romanUnits[level + 1])"
		
		if num == 5:
			return romanFives[level]
			
		if num == 4:
			return "$(romanUnits[level])$(romanFives[level])"
			
		if num > 5:
			return "$(romanFives[level])$(BuildRomanUnitString(num - 5, level))"
		
		return BuildRomanUnitString(num, level)
					
	public def ToRoman(num as int):
		
		# it is assumed no number greater than 3999 will be fed to this def
		
		numStr = "$num"
		numRoman as (string) = array(string, numStr.Length)
		index as byte = 0
		
		if num >= 1000:
			numRoman[index] = BuildRomanNumString(int.Parse("$(numStr[index++])"), 3)
			
		if num >= 100:
			numRoman[index] = BuildRomanNumString(int.Parse("$(numStr[index++])"), 2)
			
		if num >= 10:
			numRoman[index] = BuildRomanNumString(int.Parse("$(numStr[index++])"), 1)
			
		numRoman[index] = BuildRomanNumString(int.Parse("$(numStr[index])"), 0)
		
		return string.Concat(numRoman)