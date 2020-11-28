namespace ConsolePaint

import System

class StartingNumberTooLowException(ArgumentException):
	pass
	
class StartingNumberTooHighException(ArgumentException):
	pass
	
class ListTooLongException(ArgumentException):
	pass

static class MenuMaking:
	
	public enum OLNumeral:
		Binary
		Decimal
		Hexadecimal
		Octal
		Roman
		Greek
		#AlphabetLowerCase
		#AlphabetUpperCase
	
	public def GetRoman(number as int):
		
		if number > 3999:
			raise StartingNumberTooHighException()
			
		if number < 1:
			raise StartingNumberTooLowException()
			
		return Numeral.ToRoman(number)
	
	public def MakeOrderedList(posX as byte, posY as byte, list as (string)):
		MakeOrderedList(posX, posY, list, OLNumeral.Decimal, 1, 1)
		
	public def MakeOrderedList(posX as byte, posY as byte, list as (string), numeral as OLNumeral, startingNumber as int, yPadding as byte):
		
		if startingNumber < 1:
			raise StartingNumberTooLowException()
			
		if numeral == OLNumeral.Roman and startingNumber + list.Length > 3999:
			raise StartingNumberTooHighException()
			
		if numeral == OLNumeral.Greek and startingNumber + list.Length > 9999:
			raise StartingNumberTooHighException()
		
		if posY + list.Length >= Console.WindowHeight:
			raise ListTooLongException()
			
		if posX >= Console.WindowWidth:
			raise OutOfWindowBoundsException()			
		
		Console.CursorTop = posY
		
		for count in range(list.Length):
			
			Console.CursorLeft = posX
			
			if numeral == OLNumeral.Binary:
				Console.Write(Convert.ToString(count + startingNumber, 2))
				
			elif numeral == OLNumeral.Octal:
				Console.Write(Convert.ToString(count + startingNumber, 8))
				
			elif numeral == OLNumeral.Hexadecimal:
				Console.Write(Convert.ToString(count + startingNumber, 16))
				
			elif numeral == OLNumeral.Greek:
				Console.Write(Numeral.ToGreek(count + startingNumber))
				
			elif numeral == OLNumeral.Roman:
				Console.Write(Numeral.ToRoman(count + startingNumber))
				
			else:
				Console.Write(count + startingNumber)
			
			Console.Write(". $(list[count])")
			Console.CursorTop += yPadding
			
	public def MakeUnorderedList(posX as byte, posY as byte, list as (string)):
		MakeUnorderedList(posX, posY, list, char('*'), 1)
			
	public def MakeUnorderedList(posX as byte, posY as byte, list as (string), bullet as char, yPadding as byte):
		
		Console.CursorTop = posY
		
		for element in list:
				
			Console.CursorLeft = posX
			Console.Write("$bullet $element")
			Console.CursorTop += yPadding		
	
	public def MakeBorderedOL(posX as byte, posY as byte, list as (string), border as RectanglePainting.BorderType, color as ConsoleColor):
		MakeBorderedOL(posX, posY, list, OLNumeral.Decimal, 1, 0, 1, border, 0, 0, color)
	
	public def MakeBorderedOL(posX as byte, posY as byte, list as (string), numeral as OLNumeral, xPadding as byte, yPadding as byte, border as RectanglePainting.BorderType, color as ConsoleColor):
		MakeBorderedOL(posX, posY, list, numeral, 1, xPadding, yPadding, border, 0, 0, color)
	
	public def MakeBorderedOL(posX as byte, posY as byte, list as (string), numeral as OLNumeral, startingNumber as int, xPadding as byte, yPadding as byte, border as RectanglePainting.BorderType, minBorderWidth as byte, minBorderHeight as byte, color as ConsoleColor):
		
		# xExtra 
		xExtra as byte
		lastNumber = list.Length + startingNumber
		
		if numeral == OLNumeral.Decimal:
			xExtra = "$lastNumber".Length
		
		#TODO: comparer la longueur comme la liste de mots
		elif numeral == OLNumeral.Roman:
			xExtra = FindLargestRoman(list.Length)
			
		elif numeral == OLNumeral.Binary:
			xExtra = "$(Convert.ToString(lastNumber, 2))".Length
			
		elif numeral == OLNumeral.Octal:
			xExtra = "$(Convert.ToString(lastNumber, 8))".Length
			
		elif numeral == OLNumeral.Hexadecimal:
			xExtra = "$(Convert.ToString(lastNumber, 16))".Length
		
		#TODO: comparer la longueur comme la liste de mots
		else:
			xExtra = "$(Numeral.ToGreek(lastNumber))".Length
			
		++xExtra #Space occupied by dot
		
		MakeOrderedList(posX + xPadding + 1, posY + 1, list, numeral, startingNumber, yPadding)
		DrawBorders(posX, posY, list, xPadding, yPadding, border, minBorderWidth, minBorderHeight, color, xExtra)
		
	public def MakeBorderedUL(posX as byte, posY as byte, list as (string), border as RectanglePainting.BorderType, color as ConsoleColor):
		MakeBorderedUL(posX, posY, list, char('*'), 0, 1, border, 0, 0, color)
	
	public def MakeBorderedUL(posX as byte, posY as byte, list as (string), bullet as char, xPadding as byte, yPadding as byte, border as RectanglePainting.BorderType, color as ConsoleColor):
		MakeBorderedUL(posX, posY, list, bullet, xPadding, yPadding, border, 0, 0, color)
	
	public def MakeBorderedUL(posX as byte, posY as byte, list as (string), bullet as char, xPadding as byte, yPadding as byte, border as RectanglePainting.BorderType, minBorderWidth as byte, minBorderHeight as byte, color as ConsoleColor):
		
		MakeUnorderedList(posX + xPadding + 1, posY + 1, list, bullet, yPadding)
		DrawBorders(posX, posY, list, xPadding, yPadding, border, minBorderWidth, minBorderHeight, color, 2)

	public def MakeBorderedText(posX as byte, posY as byte, text as string, border as RectanglePainting.BorderType, color as ConsoleColor, isJustified as bool):
		MakeBorderedText(posX, posY, text, 0, 0, border, 0, 0, color)
	
	public def MakeBorderedText(posX as byte, posY as byte, text as string, xPadding as byte, yPadding as byte, border as RectanglePainting.BorderType, color as ConsoleColor, isJustified as bool):
		MakeBorderedText(posX, posY, text, xPadding, yPadding, border, 0, 0, color)
		
	public def MakeBorderedText(posX as byte, posY as byte, text as string, xPadding as byte, yPadding as byte, border as RectanglePainting.BorderType, minBorderWidth as byte, minBorderHeight as byte, color as ConsoleColor):
		pass
		
	private def DrawBorders(posX as byte, posY as byte, list as (string), xPadding as byte, yPadding as byte, border as RectanglePainting.BorderType, minBorderWidth as byte, minBorderHeight as byte, color as ConsoleColor, xExtra as byte):
		
		height as byte = list.Length * yPadding
		
		if height < minBorderHeight:
			height = minBorderHeight
			
		width as byte = FindLargest(list) + (xPadding << 1) + xPadding + xExtra
		
		if width < minBorderWidth:
			width = minBorderWidth
			
		RectanglePainting.DrawRectangle(border, posX, posY, height + 2, width + 2, color) // 2 is the border's total character space
	
	public def GetSelection(posX as byte, posY as byte, listLength as byte):
		return GetSelection(posX, posY, listLength, 1, char('>'))
		
	public def GetSelection(posX as byte, posY as byte, listLength as byte, yPadding as byte, cursor as char):
		
		selection as byte = 0
		Console.CursorTop = posY
		
		while true:
			
			Console.CursorLeft = posX
			Console.Write(cursor)
			input = Console.ReadKey(true).Key
			
			if input == ConsoleKey.UpArrow and selection - 1 >= 0:
				
				Console.CursorLeft = posX
				Console.Write(" ")
				--selection
				Console.CursorTop -= yPadding
				
			elif input == ConsoleKey.DownArrow and selection + 1 < listLength:
				
				Console.CursorLeft = posX
				Console.Write(" ")
				++selection
				Console.CursorTop += yPadding
				
			elif input == ConsoleKey.Enter:
				
				Console.CursorLeft = posX
				Console.Write(" ")
				return selection
				
	private def FindLargest(list as (string)):
		
		largest = 0
		
		for element in list:
			if element.Length > largest:
				largest = element.Length
				
		return largest
	
	# Wanted to do a callable() as string with params but it will not allow it
	private def FindLargestRoman(listLength as int):
		 
		 largest = 0
		 
		 for count in range(listLength):
		 	if "$(Numeral.ToRoman(count))".Length > largest:
		 		largest = "$(Numeral.ToRoman(count))".Length
		 		
		 return largest
		 