namespace ConsolePaint

import System

class NegativeLengthException(ArgumentException):
	pass

class NegativeCoordinateException(ArgumentException):
	pass

class OutOfWindowBoundsException(Exception):
	pass

class InvalidAngleException(ArgumentException):
	pass

static class Painting:
"""This class allows you to program the console window's inner appearance."""
	
	public brush = char('█')
	
	private def Draw(posX as short, posY as short):
		
		Console.SetCursorPosition(posX, posY)
		Console.Write(brush)
	
	def DrawCell(posX as short, posY as short, color as ConsoleColor):
		
		if posX < 0 or posY < 0:
			raise NegativeCoordinateException()
			
		if posY > Console.WindowHeight or posX > Console.WindowWidth:
			raise OutOfWindowBoundsException()
			
		previousColor = Console.ForegroundColor
		Console.ForegroundColor = color
		Draw(posX, posY)
		Console.ForegroundColor = previousColor
	
	def DrawHorizontalLine(posX as short, posY as short, length as short, color as ConsoleColor):
		
		if length < 0:
			raise NegativeLengthException()
		
		if posX < 0 or posY < 0:
			raise NegativeCoordinateException()
			
		if posX + length > Console.WindowWidth or posY > Console.WindowHeight:
			raise OutOfWindowBoundsException()
		
		DrawLine({count as short|Draw(posX + count, posY)}, length, color)
	
	def DrawVerticalLine(posX as short, posY as short, length as short, color as ConsoleColor):
		
		if length < 0:
			raise NegativeLengthException()
			
		if posX < 0 or posY < 0:
			raise NegativeCoordinateException()
			
		if posX > Console.WindowWidth or posY + length > Console.WindowHeight:
			raise OutOfWindowBoundsException()
		
		DrawLine({count as short|Draw(posX, posY + count)}, length, color)
	
	def DrawDiagonalLine(posX as short, posY as short, length as short, color as ConsoleColor, angle as sbyte):
		
		// this is a temporary limitation until I get around to implementing more varied types of angles
		if Math.Abs(angle) > 1 or angle == 0:
			raise InvalidAngleException()
		
		if length < 0:
			raise NegativeLengthException()
			
		if posX < 0 or posY < 0:
			raise NegativeCoordinateException()
			
		if posX + length > Console.WindowWidth or posY + length * angle > Console.WindowHeight:
			raise OutOfWindowBoundsException()
			
		DrawLine({count as short|Draw(posX + count, posY + count * angle)}, length, color)
		
	private def DrawImage(image as Drawing.Bitmap, posX as short, posY as short, convert as callable(Drawing.Color) as ConsoleColor):
		
		if posX < 0 or posY < 0:
			raise NegativeCoordinateException()
		
		if image.Height + posY > Console.WindowHeight or image.Width + posX > Console.WindowWidth:
			raise OutOfWindowBoundsException()
		
		height = image.Height
		width = image.Width
		
		for count in range(height):
			
			for scount in range(width):
				
				Console.ForegroundColor = convert(image.GetPixel(scount, count))
				Draw(posX + scount, posY + count)
		
	def DrawImage(image as Drawing.Bitmap, posX as short, posY as short):
		DrawImage(image, posX, posY, Palette.ColorToConsoleColor)
				
	def DrawDarkImage(image as Drawing.Bitmap, posX as short, posY as short):
		DrawImage(image as Drawing.Bitmap, posX, posY, Palette.ColorToDarkConsoleColor)
	
	def MakeMonochrome(image as Drawing.Bitmap) as ConsoleImage:
	"""A convenient alternative to typing MakeMonochrome(image, gray)"""
		return MakeMonochrome(image, Palette.Color.Gray)
	
	def MakeMonochrome(image as Drawing.Bitmap, palette as Palette.Color) as ConsoleImage:
		
		height = image.Height
		width = image.Width
		
		colors as (ConsoleColor, 2) = matrix(ConsoleColor, height, width)
				
		MakeImage({x as short, y as short|colors[y, x] = Palette.ColorToMonochrome(image.GetPixel(x, y), palette)}, height, width)
		
		return ConsoleImage(colors)
		
	def MakeDuochrome(image as Drawing.Bitmap) as ConsoleImage:
		return MakeDuochrome(image, Palette.DuoColor.Cyan_Blue);
		
	def MakeDuochrome(image as Drawing.Bitmap, palette as Palette.DuoColor) as ConsoleImage:
		
		height = image.Height
		width = image.Width
		
		colors as (ConsoleColor, 2) = matrix(ConsoleColor, height, width)
		
		MakeImage({x as short, y as short|colors[y, x] = Palette.ColorToDuochrome(image.GetPixel(x, y), palette)}, height, width)
		
		return ConsoleImage(colors)
		
	private def DrawLine(expr as callable(short) as void, length as short, color as ConsoleColor):
		
		previousColor = Console.ForegroundColor
		Console.ForegroundColor = color
		
		for count in range(length):
			expr(count)
			
		Console.ForegroundColor = previousColor
		
	internal def MakeImage(expr as callable(short, short) as void, height as short, width as short):
		
		for count in range(height):
			for scount in range(width):
				expr(scount, count)
				
	def DrawSpinningAnimation(expr as Func[of bool], millisecondDelay as int):
		
		x = Console.CursorLeft cast byte
		count as byte = 0
		animationFrames = "|/-\\"
		
		while expr():
			
			Console.Write(animationFrames[count])
			Console.CursorLeft = x
			++count
			
			if millisecondDelay > 0:
				Threading.Thread.Sleep(millisecondDelay)
			
			if count == 4:
				count = 0