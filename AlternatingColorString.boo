namespace ConsolePaint

import System

class AlternatingColorString(IColorText):
	
	private internalCount = 0
	
	background as ConsoleColor
	foreground as (ConsoleColor)
	characters as string
	
	def constructor(characters as string, background as ConsoleColor, *foreground as (ConsoleColor)):
		
		self.characters = characters
		self.background = background
		self.foreground = foreground
		
	private InternalCount:
		get:
			return internalCount
		
		set:
			if (value < foreground.Length):
				internalCount = value
				
			else:
				internalCount = 0
		
	private NextColor:
		get:
			return foreground[InternalCount++]
			
	def ResetCounter():
		InternalCount = 0
		
	def Write():
		
		currentBackground = Console.BackgroundColor
		currentForeground = Console.ForegroundColor
		Console.BackgroundColor = background
		
		for c in characters:
			
			Console.ForegroundColor = NextColor
			Console.Write(c)
			
		Console.BackgroundColor = currentBackground
		Console.ForegroundColor = currentForeground
		
	def WriteLine():
		Write()
		Console.WriteLine()
		
	override def ToString():
		return characters
		
	def ToCharArray():
		ToString().ToCharArray()
		
	def ToColorCharArray():
		
		result as List[of ColorChar]
		
		for c in characters:
			result.Add(ColorChar(background, NextColor, c))
			
		return result.ToArray()

