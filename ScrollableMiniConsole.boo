namespace ConsolePaint

import System
import System.Collections.Generic

class NegativeIndexException(ArgumentException):
	pass
	
class IndexLargerThanSizeException(ArgumentException):
	pass

class ScrollableMiniConsole(MiniConsole):
	
	private text = List[of char]()
	private foregroundColors = List[of ConsoleColor?]()
	private backgroundColors = List[of ConsoleColor?]()
	private lastPrintedCharIndex = 0
	
	Text:
		get:
			return string(text.ToArray())
			
	Count:
		get:
			return text.Count
			
	CharIndex:
		get:
			return lastPrintedCharIndex
	
	def constructor(width as byte, height as byte, x as byte, y as byte, border as RectanglePainting.BorderType?, borderColor as ConsoleColor):
		super(width, height, x, y, border, borderColor)
	
	def constructor(width as byte, height as byte, border as RectanglePainting.BorderType?, borderColor as ConsoleColor):
		super(width, height, border, borderColor)
	
	def constructor(x as byte, y as byte):
		super(x, y)
		
	def Clear():
		
		text.Clear()
		CleanContent()
		
	private def ManageCharacters(text as string):
		
		self.text.AddRange(text)
		lastPrintedCharIndex += text.Length - 1
		
	private def ManageColors(textLength as int, foregroundColor as ConsoleColor?, backgroundColor as ConsoleColor?):
		
		for count in range(textLength):
			
			foregroundColors.Add(foregroundColor)
			backgroundColors.Add(backgroundColor)
		
	override def Write(text as string):
		
		ManageCharacters(text)
		super.Write(text)
		ManageColors(text.Length, null, null)
		
	override def Write(text as string, foregroundColor as ConsoleColor):
		
		ManageCharacters(text)
		super.Write(text, foregroundColor)
		ManageColors(text.Length, foregroundColor, null)
		
	override def Write(text as string, foregroundColor as ConsoleColor, backgroundColor as ConsoleColor):
		
		ManageCharacters(text)
		super.Write(text, foregroundColor, backgroundColor)
		ManageColors(text.Length, foregroundColor, backgroundColor)
	
	override def WriteLine(text as string):
	
		ManageCharacters(text)
		super.WriteLine(text)
		ManageColors(text.Length, null, null)
		
	override def WriteLine(text as string, foregroundColor as ConsoleColor):
		
		ManageCharacters(text)
		super.WriteLine(text, foregroundColor)
		ManageColors(text.Length, foregroundColor, null)
		
	override def WriteLine(text as string, foregroundColor as ConsoleColor, backgroundColor as ConsoleColor):
		
		ManageCharacters(text)
		super.WriteLine(text, foregroundColor, backgroundColor)
		ManageColors(text.Length, foregroundColor, backgroundColor)
	
	def Scroll(chars as int):
		
		newIndex = lastPrintedCharIndex + chars
		
		if newIndex < 0:
			raise NegativeIndexException()
			
		if newIndex >= text.Count:
			raise IndexLargerThanSizeException()
		
		# 2 is the number of chars taken up by the borders
		maxChars = Width * Height - 2 + (chars * - 1) 
		
		# Sorry about the mess! These will be cleaned up a bit later; I needed something fast to test this 
		msg = Text[-maxChars:newIndex]
		fgc = foregroundColors.ToArray()[-maxChars:newIndex]
		bgc = backgroundColors.ToArray()[-maxChars:newIndex]
		
		for count in range(msg.Length):
			
			str = "$(msg[count])"
			
			if bgc[count].HasValue:
				Write(str, fgc[count].Value, bgc[count].Value)
				
			elif fgc[count].HasValue:
				Write(str, fgc[count].Value)
				
			else:
				Write(str)
				
		lastPrintedCharIndex = newIndex
		
		