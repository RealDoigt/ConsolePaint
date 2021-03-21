namespace ConsolePaint

import System

struct ColorString(IColorText):
	
	backgroundColor as ConsoleColor
	foregroundColor as ConsoleColor
	characters as string
	
	def constructor(backgroundColor as ConsoleColor, foregroundColor as ConsoleColor, characters as string):
		
		self.backgroundColor = backgroundColor
		self.foregroundColor = foregroundColor
		self.characters = characters
		
	def Write():
		
		currentBackground = Console.BackgroundColor
		currentForeground = Console.ForegroundColor
		Console.BackgroundColor = backgroundColor
		Console.ForegroundColor = foregroundColor
		
		Console.Write(characters)
		
		Console.BackgroundColor = currentBackground
		Console.ForegroundColor = currentForeground
		
	def WriteLine():
		
		Write()
		Console.Write("\n");
		
	override def ToString():
		return "$characters"
