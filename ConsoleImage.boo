namespace ConsolePaint

import System
import System.Collections.Generic

class ImageTooLargeException(Exception):
	pass
	
class ConsoleImage:
"""An instance of ConsoleImage holds pixel data in the limited .Net console colour palette as well as methods to draw them on screen or file."""

	private colors as (ConsoleColor, 2)
	
	def constructor(bitmap as Drawing.Bitmap):
	"""This constructor instantiates the class by converting colours to the limited .Net palette."""
		
		colors = matrix(ConsoleColor, bitmap.Height, bitmap.Width)
		
		height = bitmap.Height
		width = bitmap.Width
		
		Painting.MakeImage({x as short, y as short|colors[y, x] = Palette.ColorToConsoleColor(bitmap.GetPixel(x, y))}, height, width)
				
	def constructor(NCIFilePath as string):
	"""
	This constructor initiates the class by rebuilding the image from a binary data file. 
	NCI stands for .Net Console Image
	"""
		ReadFromFile(NCIFilePath)
				
	internal def constructor(multiColorArray as (ConsoleColor, 2)):
	"""An internal constructor intended for building monochromatic ConsoleImages"""
		colors = multiColorArray
				
	def Paint():
	"""This method calls the PaintAt method using 0 as the value of both parameters."""
		PaintAt(0, 0)
				
	virtual def PaintAt(posX as short, posY as short):
	"""
	@summary This method draws on the screen the pixel data this instance holds.
	@posX X coordinate of the cursor's starting position.
	@posY Y coordinate of the cursor's starting position.
	"""
	# Done goofed: the comment notation used above hasn't been implemented yet
	# and may very well never get implemented.
		Painting.MakeImage({x as short, y as short|Painting.DrawCell(posX + x, posY + y, colors[y, x])}, Height, Width)
				
	Height as int:
		get:
			return colors.GetLength(0)
			
	Width as int:
		get:
			return colors.GetLength(1)
			
	def PaintToFile(filePath as string):
	"""This method calls ToBitmap then uses the resulting instance's Save method to produce a Png file."""
		ToBitmap().Save(filePath, Drawing.Imaging.ImageFormat.Png)
		
	protected virtual def ReadFromFile(NCIFilePath as string):
		
		if not NCIFilePath.EndsWith(".nci"):
			NCIFilePath = "$(NCIFilePath).nci"
			
		if not IO.File.Exists(NCIFilePath):
			raise IO.FileNotFoundException()
			
		shades = List[of byte]()
		simpleColors = List[of byte]()
			
		using reader = IO.BinaryReader(IO.File.Open(NCIFilePath, IO.FileMode.Open)):
			
			height = reader.ReadByte()
			width = reader.ReadByte()
			
			colors = matrix(ConsoleColor, height, width)
			totalLength = Height * Width
			count = 0
			
			while count < totalLength:
				
				currentByte = reader.ReadByte()
				
				if currentByte == 0:
					
					copies = reader.ReadByte()
					toCopy = reader.ReadByte()
					
					for scount in range(copies):
						
						simpleColors.Add(toCopy)
						++count
					
				else:
					
					simpleColors.Add(currentByte)
					++count
				
			while reader.PeekChar() > -1:
				
				currentByte = reader.ReadByte()
				
				if currentByte == 0:
					
					copies = reader.ReadByte()
					toCopy = reader.ReadByte()
					
					for scount in range(copies):
						shades.Add(toCopy)
					
				else:
					shades.Add(currentByte)
					
		count = 0
		
		for y in range(Height):
			
			for x in range(Width):
				
				colors[y, x] = Palette.SimplePairToConsoleColor(simpleColors[count] cast Palette.SimpleColor, shades[count] cast Palette.Shade)
				++count
				
		
	virtual def WriteToFile(NCIFilePath as string):
	"""Writes to file the pixel data this instance contains using a custom image format; the .Net Console Image. (using RLE encoding)"""
		
		if Height > byte.MaxValue or Width > byte.MaxValue:
			raise ImageTooLargeException()
		
		if not NCIFilePath.EndsWith(".nci"):
			NCIFilePath = "$(NCIFilePath).nci"
			
		simpleColors as (int) = array(int, Width * Height)
		shades as (int) = array(int, Width * Height)
		count = 0
		
		for y in range(Height):
			
			for x in range(Width):
				
				simpleColors[count] = Palette.ConsoleColorToSimpleColor(colors[y, x]) cast int
				shades[count] = Palette.ConsoleColorToSimpleShade(colors[y, x]) cast int
				++count
				
		simpleColorList = ToRLE(simpleColors)
		simpleShadeList = ToRLE(shades)
		
		using writer = IO.BinaryWriter(IO.File.Open(NCIFilePath, IO.FileMode.Create)):
			
			writer.Write(Height cast byte)
			writer.Write(Width cast byte)
			
			for num in simpleColorList:
				writer.Write(num cast byte)
				
			for num in simpleShadeList:
				writer.Write(num cast byte)
	
	internal def ToRLE(list as (int)):
		
		toCompare = 0
		result = List[of int]()
		count = 1
		
		while count < list.Length:
			
			if list[count] != list[toCompare] or count - toCompare > byte.MaxValue:
				
				if count - toCompare > 1:
					
					result.Add(0)
					result.Add(count - toCompare)
					result.Add(list[toCompare])
					
				else:
					result.Add(list[toCompare])
				
				toCompare = count
					
			++count
			
		if count - toCompare > 1:
			
			result.Add(0)
			result.Add(count - toCompare)
			result.Add(list[toCompare])
			
		else:
			result.Add(list[toCompare])
			
		return result.ToArray()
	
	def ToBitmap() as Drawing.Bitmap:
	"""This method converts this instance of console image to a bitmap, however the colour's quality loss remains."""
		
		image = Drawing.Bitmap(Width, Height)
		
		Painting.MakeImage({x as short, y as short|image.SetPixel(x, y, Palette.ConsoleColorToColor(colors[y, x]))}, Height, Width)
		
		return image
	
	self[x as int, y as int]:
		get:
			return colors[y, x]
			
		set:
			colors[y, x] = value
			
	override def ToString():
		return "$Width by $Height image"