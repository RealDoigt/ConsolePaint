namespace ConsolePaint

import System

class MiniConsole:
	
	private width as byte
	private height as byte
	private x as byte
	private y as byte
	private border as RectanglePainting.BorderType?
	private borderColor as ConsoleColor
	private printCursorY as byte = 0
	private printCursorX as byte = 0
	
	BorderColor:
		
		get:
			return borderColor
			
		set:
			
			borderColor = value
			Draw()
	
	Border:
		
		get:
			
			return border
			
		set:
			border = value
			Draw()
				
	Height:
		
		get:
			return height
			
		set:
			
			if value + y > Console.WindowHeight:
				raise OutOfWindowBoundsException()
			
			Redraw(height, value)
			
	Width:
		
		get:
			return width
			
		set:
			
			if value + x > Console.WindowWidth:
				raise OutOfWindowBoundsException()
			
			Redraw(width, value)
			
	Y:
		
		get:
			return y
			
		set:
			
			if value + height > Console.WindowHeight:
				raise OutOfWindowBoundsException()
			
			Redraw(y, value)
			
	X:
		
		get:
			return x
			
		set:
			
			if value + width > Console.WindowWidth:
				raise OutOfWindowBoundsException()
				
			Redraw(x, value)
	
	def constructor(width as byte, height as byte, x as byte, y as byte, border as RectanglePainting.BorderType?, borderColor as ConsoleColor):
		
		if width + x > Console.WindowWidth or height + y > Console.WindowHeight:
			raise OutOfWindowBoundsException()
		
		self.width = width
		self.height = height
		self.x = x
		self.y = y
		self.border = border
		
		if border.HasValue:
			self.borderColor = borderColor
		
	def constructor(width as byte, height as byte, border as RectanglePainting.BorderType?, borderColor as ConsoleColor):
		
		init(width, height)
		self.border = border
		
		if border.HasValue:
			self.borderColor = borderColor
		
	def constructor(width as byte, height as byte):
		init(width, height)
		
	private def init(width as byte, height as byte):
		
		x = 0
		y = 0
		
		if width > Console.WindowWidth or height > Console.WindowHeight:
			raise OutOfWindowBoundsException()
			
		self.width = width
		self.height = height
		
	private def ResetCursors():
		
		printCursorX = 0
		printCursorY = 0
		
	private def Redraw(ref field as byte, val as byte):
		
		# This order must not change
		Erase()
		ResetCursors()
		field = val
		Draw()
		
	def Draw():
		
		if border.HasValue:
			RectanglePainting.DrawRectangle(border.Value, x, y, height, width, borderColor)
			
	def Erase():
		
		RectanglePainting.DrawRectangle(x, y, height, width, Console.BackgroundColor)
		CleanContent()
		
	def CleanContent():
		
		posX as byte = x + 1
		Console.SetCursorPosition(posX, y + 1)
		
		for indexY in range(height - 2):
			
			for indexX in range(width -2):
				Console.Write(" ");
				
			++Console.CursorTop
			Console.CursorLeft = posX
	
	def WriteLine():
		
		++printCursorY
		printCursorX = 0
		
	virtual def WriteLine(text as string):
		
		Write(text)
		WriteLine()
		
	virtual def WriteLine(text as string, foregroundColor as ConsoleColor):
		
		currentColor = Console.ForegroundColor
		Console.ForegroundColor = foregroundColor
		WriteLine(text)
		Console.ForegroundColor = currentColor
		
	virtual def WriteLine(text as string, foregroundColor as ConsoleColor, backgroundColor as ConsoleColor):
		
		currentColor = Console.BackgroundColor
		Console.BackgroundColor = backgroundColor
		WriteLine(text, foregroundColor)
		Console.BackgroundColor = currentColor
		
	virtual def Write(text as string, foregroundColor as ConsoleColor):
		
		currentColor = Console.ForegroundColor
		Console.ForegroundColor = foregroundColor
		Write(text)
		Console.ForegroundColor = currentColor
		
	virtual def Write(text as string, foregroundColor as ConsoleColor, backgroundColor as ConsoleColor):
		
		currentColor = Console.BackgroundColor
		Console.BackgroundColor = backgroundColor
		Write(text, foregroundColor)
		Console.BackgroundColor = currentColor
		
	virtual def Write(text as string):
		
		posX as byte = x + 1
		posY as byte = y + 1
		
		Console.SetCursorPosition(posX + printCursorX, posY + printCursorY)
		
		indexX as ushort = 0
		indexY as ushort = 0
		
		while indexY < height - 2 and indexX < text.Length:
			
			if printCursorY >= height - 2:
				
				CleanContent()
				indexY = 0
				ResetCursors()
				Console.SetCursorPosition(posX, posY)
			
			while printCursorX < width - 2 and indexX < text.Length:
				
				# Temporary fix for bug with small inputs; 
				# small inputs (usually around 20% of width or lower) never get a newline
				# there's probably a real solution, but for now, it'll have to do
				if text.Length <= 3 and Console.CursorLeft + 1 == width - 2 + posX:
					break
				
				# slighlty larger problem strings will neatly wrap around still with this:				
				if text.Length / width * 100 <= 20 and Console.CursorLeft + 1 == width + x:
					break					
				
				Console.Write(text[indexX])
				++indexX
				++printCursorX
				
			if printCursorX >= width - 2:
				printCursorX = 0
				
			++indexY
			++Console.CursorTop 
			Console.CursorLeft = posX
			++printCursorY
			
		--printCursorY
		
	virtual def ReadLine():
		return ReadLine(false)
		
	virtual def ReadLine(intercept as bool):
		
		keyInfo as ConsoleKeyInfo
		characters = List[of char]()
		
		while true:
			
			keyInfo = Console.ReadKey(true)
			
			if (not intercept):
				Write("$(keyInfo.KeyChar)")
				
			characters.Add(keyInfo.KeyChar)
			
			break unless keyInfo.Key != ConsoleKey.Enter
			
		return string(characters.ToArray())
		
	virtual def ReadLine(foregroundColor as ConsoleColor):
		
		currentColor = Console.ForegroundColor
		Console.ForegroundColor = foregroundColor
		result = ReadLine()
		Console.ForegroundColor = currentColor
		
		return result
		
	virtual def ReadLine(foregroundColor as ConsoleColor, backgroundColor as ConsoleColor):
		
		currentColor = Console.BackgroundColor
		Console.BackgroundColor = backgroundColor
		result = ReadLine(foregroundColor)
		Console.BackgroundColor = currentColor
		
		return result