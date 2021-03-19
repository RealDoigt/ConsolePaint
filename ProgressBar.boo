namespace ConsolePaint

import System

class MaxValueCannotBeZeroException(ArgumentException):
	pass

class ProgressBar:
	
	enum Ends:
		None
		Bracket
		Parenthesis
		CurlyBracket
	
	private width as byte
	private height as byte
	private posX as byte
	private posY as byte
	private maxValue as uint
	private currentValue as uint
	private ends as Ends
	private glyph as char?
	private foregroundColor as ConsoleColor
	private backgroundColor as ConsoleColor
	
	Color:
		get:
			return foregroundColor
		
		set:
			
			foregroundColor = value
			Draw()
			
	BackColor:
		get:
			return backgroundColor
			
		set:
			
			backgroundColor = value
			Draw()
	
	MaxValue:
		get:
			return maxValue
			
	CurrentValue:
		get:
			return currentValue
		
		set:
			if value <= maxValue:
				currentValue = value
				
			Draw()
				
	PercentValue:
		get:
			return (currentValue cast decimal / maxValue cast decimal) * 100 
	
	def constructor(width as byte, posX as byte, posY as byte, maxValue as uint):
		if maxValue == 0:
			raise MaxValueCannotBeZeroException()			
		
		self.width = width
		height = 1
		self.posX = posX
		self.posY = posY
		self.maxValue = maxValue
		ends = Ends.None
		currentValue = 0
		foregroundColor = Console.ForegroundColor
		backgroundColor = Console.BackgroundColor
		
	def constructor(width as byte, posX as byte, posY as byte, maxValue as uint, ends as Ends):
		if maxValue == 0:
			raise MaxValueCannotBeZeroException()		
			
		self.width = width
		height = 1
		self.posX = posX
		self.posY = posY
		self.maxValue = maxValue
		self.ends = ends
		currentValue = 0
		foregroundColor = Console.ForegroundColor
		backgroundColor = Console.BackgroundColor
		
	def constructor(width as byte, height as byte, posX as byte, posY as byte, maxValue as uint, ends as Ends, glyph as char, foreground as ConsoleColor, background as ConsoleColor):
		if maxValue == 0:
			raise MaxValueCannotBeZeroException()		
			
		self.width = width
		self.height = height
		self.posX = posX
		self.posY = posY
		self.maxValue = maxValue
		self.ends = ends
		self.glyph = glyph
		currentValue = 0
		foregroundColor = foreground
		backgroundColor = background
		
	def Draw():
		
		Console.SetCursorPosition(posX, posY)
		
		currentBrush = Painting.brush
		currentBackColor = Console.BackgroundColor
		Console.BackgroundColor = backgroundColor
		
		for y in range(height):
			
			Painting.brush = char(' ')
			Painting.DrawHorizontalLine(Console.CursorLeft, Console.CursorTop, width, Console.ForegroundColor)
			
			Painting.brush = currentBrush
		
			if glyph.HasValue:
				Painting.brush = glyph.Value
				
			Console.CursorLeft = posX
			
			if ends == Ends.Bracket:
				Console.Write("[")
				
			elif ends == Ends.CurlyBracket:
				Console.Write("{")
				
			elif ends == Ends.Parenthesis:
				Console.Write("(")
			
			Painting.DrawHorizontalLine(Console.CursorLeft, Console.CursorTop, (currentValue cast double / maxValue cast double) * width, foregroundColor)
			
			if ends == Ends.Bracket:
				Console.Write("]")
				
			elif ends == Ends.CurlyBracket:
				Console.Write("}")
				
			elif ends == Ends.Parenthesis:
				Console.Write(")")
				
			++Console.CursorTop
				
		Painting.brush = currentBrush
		Console.BackgroundColor = currentBackColor
		
	override def ToString():
		return "$currentValue / $maxValue"

