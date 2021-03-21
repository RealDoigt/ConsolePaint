namespace ConsolePaint

import System
import System.Collections.Generic

struct ColorChar(IColorText):
	
	backgroundColor as ConsoleColor
	foregroundColor as ConsoleColor
	character as char
	
	def constructor(backgroundColor as ConsoleColor, foregroundColor as ConsoleColor, character as char):
		
		self.backgroundColor = backgroundColor
		self.foregroundColor = foregroundColor
		self.character = character
		
	def Write():
		
		currentBackground = Console.BackgroundColor
		currentForeground = Console.ForegroundColor
		Console.BackgroundColor = backgroundColor
		Console.ForegroundColor = foregroundColor
		
		Console.Write(character)
		
		Console.BackgroundColor = currentBackground
		Console.ForegroundColor = currentForeground
		
	def WriteLine():
		Write()
		Console.Write("\n")
		
	static def Write(colorChars as (ColorChar)):
		for colorChar in colorChars:
			colorChar.Write()
			
	static def WriteLine(colorChars as (ColorChar)):
		
		Write(colorChars)
		Console.WriteLine()
		
	static def ToColorString(colorChars as (ColorChar)):
		
		colorCounts = Dictionary[of ConsoleColor, int]()
		backColorCounts = Dictionary[of ConsoleColor, int]()
		
		def countColors(dict as Dictionary[of ConsoleColor, int]):
			for colorChar in colorChars:
				
				if dict.ContainsKey(colorChar.foregroundColor):
					dict[colorChar.foregroundColor] += 1
					# funny thing is you can use neither pre nor post incrementation, this is dumb lol
					
				else:
					dict[colorChar.foregroundColor] = 1
					
		countColors(colorCounts)
		countColors(backColorCounts)
		
		def findBestCount(dict as Dictionary[of ConsoleColor, int]) as ConsoleColor:
			
			bestCount = 0
			bestColor as ConsoleColor
			
			for pair in dict:
				
				if pair.Value > bestCount:
					
					bestCount = pair.Value
					bestColor = pair.Key
					
			return bestColor
			
		backColor = findBestCount(backColorCounts)
		pair = findBestCount(colorCounts)
		str = ToString(colorChars)
		
		return ColorString(backColor, pair, str)
		
	static def ToString(colorChars as (ColorChar)):
		str = ""
		
		for colorChar in colorChars:
			str = "$str$(colorChar.character)"
			
		return str
			
		
	override def ToString():
		return "$character"

