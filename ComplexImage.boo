namespace ConsolePaint

import System

class ComplexConsoleImage(ConsoleImage):
"""
This is an advanced version of the ConsoleImage class which also handles the 
type of brush and the background colour of each pixel.
"""
	
	private backgroundColors as (ConsoleColor, 2)
	private glyphs as (char, 2)
	
	public def constructor(height as ushort, width as ushort):
		
		super(matrix(ConsoleColor, height, width))
		backgroundColors = matrix(ConsoleColor, height, width)
		glyphs = matrix(char, height, width)
		
	public def SetBackground(x as ushort, y as ushort, color as ConsoleColor):
		
		if x > Width or y > Height:
			raise IndexOutOfRangeException()
			
		backgroundColors[y, x] = color
		
	public def GetBackground(x as ushort, y as ushort) as ConsoleColor:
		
		if x > Width or y > Height:
			raise IndexOutOfRangeException()
			
		return backgroundColors[y, x]
		
	public def SetGlyph(x as ushort, y as ushort, glyph as char):
		
		if x > Width or y > Height:
			raise IndexOutOfRangeException()
			
		glyphs[y, x] = glyph
		
	public def GetGlyph(x as ushort, y as ushort) as char:
		
		if x > Width or y > Height:
			raise IndexOutOfRangeException()
			
		return glyphs[y, x]
		
	public override def PaintAt(posX as short, posY as short):
		
		previousBrush = Painting.brush
		previousBGColor = Console.BackgroundColor
		
		height = Height
		width = Width
		
		for count in range(height):
			
			for scount in range(width):
					
				if (glyphs[count, scount] != '\0'):
					
					Painting.brush = glyphs[count, scount]
					Console.BackgroundColor = backgroundColors[count, scount]
					Painting.DrawCell(posX + scount, posY + count, self[scount, count])
		
		Console.BackgroundColor = previousBGColor
		Painting.brush = previousBrush
		
	public override def WriteToFile(CNCIFilePath as string):
		
		if not CNCIFilePath.EndsWith(".cnci"):
			CNCIFilePath = "$(CNCIFilePath).cnci"
			
		using writer = IO.BinaryWriter(IO.File.Open(CNCIFilePath, IO.FileMode.Create)):
			
			writer.Write(Height cast short)
			writer.Write(Width cast short)
			
			# foreground color
			Painting.MakeImage({x as short, y as short|writer.Write(self[y, x] cast byte)}, Height, Width)
			# background color
			Painting.MakeImage({x as short, y as short|writer.Write(backgroundColors[y, x] cast byte)}, Height, Width)
			# brush
			Painting.MakeImage({x as short, y as short|writer.Write(glyphs[y, x])}, Height, Width)
	
	# This def and the one it was copied from will be rewritten at some point to reduce redundancy.
	# This was done very hastily because I didn't have as much time as I used to have.
	public static def MakeFromFile(CNCIFilePath as string):
	
		if not CNCIFilePath.EndsWith(".cnci"):
			CNCIFilePath = "$(CNCIFilePath).cnci"
			
		if not IO.File.Exists(CNCIFilePath):
			raise IO.FileNotFoundException()
			
		image as ComplexConsoleImage
			
		using reader = IO.BinaryReader(IO.File.Open(CNCIFilePath, IO.FileMode.Open)):
			
			height = 0
			width = 0
			count = 0
			
			
			# The first two numbers of the file are the image's height and width.
			if reader.PeekChar() > -1:
				
				height = reader.ReadInt16()
				width = reader.ReadInt16()
				image = ComplexConsoleImage(height, width)
				
			while reader.PeekChar() > -1 and count < height:
				
				scount = 0
				
				while reader.PeekChar() > -1 and scount < width:
					
					image[count, scount++] = reader.ReadByte() cast ConsoleColor
					
				++count
			
			count = 0			
			
			while reader.PeekChar() > -1 and count < height:
				
				scount = 0
				
				while reader.PeekChar() > -1 and scount < width:
					
					image.backgroundColors[count, scount++] = reader.ReadByte() cast ConsoleColor
					
				++count
				
			count = 0			
			
			while reader.PeekChar() > -1 and count < height:
				
				scount = 0
				
				while reader.PeekChar() > -1 and scount < width:
					
					image.glyphs[count, scount++] = reader.ReadChar()
					
				++count
				
		return image
	
	# this future method will help reduce redundancy, it will also not be here
	#private static def LoopThroughFile(, reader as IO.BinaryReader, height as short, width as short)			