﻿namespace ConsolePaint

import System

public static class Palette:
	
	internal def ConsoleColorToColor(color as ConsoleColor):
		
		if color == ConsoleColor.Black:
			return Drawing.Color.Black
			
		if color == ConsoleColor.Blue:
			return Drawing.Color.FromArgb(0, 0, 255)
			
		if color == ConsoleColor.Cyan:
			return Drawing.Color.FromArgb(0, 255, 255)
			
		if color == ConsoleColor.DarkBlue:
			return Drawing.Color.FromArgb(0, 0, 128)
			
		if color == ConsoleColor.DarkCyan:
			return Drawing.Color.FromArgb(0, 128, 128)
			
		if color == ConsoleColor.DarkGray:
			return Drawing.Color.FromArgb(128, 128, 128)
			
		if color == ConsoleColor.DarkGreen:
			return Drawing.Color.FromArgb(0, 128, 0)
			
		if color == ConsoleColor.DarkMagenta:
			return Drawing.Color.FromArgb(128, 0, 128)
			
		if color == ConsoleColor.DarkRed:
			return Drawing.Color.FromArgb(128, 0, 0)
			
		if color == ConsoleColor.DarkYellow:
			return Drawing.Color.FromArgb(128, 128, 0)
			
		if color == ConsoleColor.Gray:
			return Drawing.Color.FromArgb(192, 192, 192)
			
		if color == ConsoleColor.Green:
			return Drawing.Color.FromArgb(0, 255, 0)
			
		if color == ConsoleColor.Magenta:
			return Drawing.Color.FromArgb(255, 0, 255)
			
		if color == ConsoleColor.Red:
			return Drawing.Color.FromArgb(255, 0, 0)
			
		if color == ConsoleColor.Yellow:
			return Drawing.Color.FromArgb(255, 255, 0)
		
		return Drawing.Color.White
	
	# Here's an explanation of how bitwise operations work for noobs like me: https://www.alanzucconi.com/2015/07/26/enum-flags-and-bitwise-operators/
	# Original code by Malwyn at https://stackoverflow.com/questions/1988833/converting-color-to-consolecolor/29192463#29192463
	# Basically how it works is it is changing the value of the index at the bit level.
	internal def ColorToConsoleColor(color as Drawing.Color):
		
		index as short
		
		# I took the liberty to have || ("or" in boo) instead of | since | cannot be used like that in boo
		# (or if there is a way, the documentation is lacking)	and secondly it doesn't matter if the other 
		# parts of the condition are not evaluated; the bitwise operations begin after the index is set to 
		# 8 even in the original code. So technically, this is a faster implementation.
		if color.B > 128 or color.G > 128 or color.R > 128:
			index = 8 // 8 is the number of bits in a standard byte or octet
			# Light colour
			
		else:
			index = 0
			# Dark colour
			
		if  color.R > 64: # 64 is half of 128 which can be used as a treshold of sorts
			index |= 4
			
		else:
			index |= 0
			
		if color.G > 64:
			index |= 2
			
		else:
			index |= 0
			
		if color.B > 64:
			index |= 1
			
		else:
			index |= 0
			
		return index cast ConsoleColor
		
	internal def ColorToDarkConsoleColor(color as Drawing.Color):
		
		tolerance = 25
		redTol = color.R + tolerance
		blueTol = color.B + tolerance
		greenTol = color.G + tolerance
		
		if color.R > greenTol and color.R > blueTol:
			return ColorToMonochrome(color, Color.Red)
			
		if color.R > greenTol and color.B > greenTol:
			return ColorToMonochrome(color, Color.Magenta)
			
		if color.R > blueTol and color.G > blueTol:
			return ColorToMonochrome(color, Color.Yellow)
			
		if color.G > redTol and color.G > blueTol:
			return ColorToMonochrome(color, Color.Green)

		if color.G > redTol and color.B > redTol:
			return ColorToMonochrome(color, Color.Cyan)
			
		if color.B > greenTol and color.B > redTol:
			return ColorToMonochrome(color, Color.Blue)
			
		return ColorToMonochrome(color, Color.Gray)
		
	internal def ColorToMonochrome(color as Drawing.Color, palette as Color):
		
		// this is done because 100 is easily divisible by 4, which is the amount of colours available in
		// a monochrome palette. However, since it's originally a float, 25 and 75 are rounded down.
		brightness = (color.GetBrightness() * 10) cast byte
		
		if brightness <= 2:
			return ConsoleColor.Black
			
		if brightness <= 5:
			return (Enum).Parse(ConsoleColor, "Dark$palette")
			
		if brightness <= 7:
			return (palette cast int) cast ConsoleColor
			
		return ConsoleColor.White
		
	internal def ColorToDuochrome(color as Drawing.Color, palette as DuoColor):
		
		brightness = (color.GetBrightness() * 10) cast byte
		
		if brightness <= 1:
			return ConsoleColor.Black
			
		if brightness <= 3:
			tempStrings = "$palette".Split("_"[0])
			return (Enum).Parse(ConsoleColor, "Dark$(tempStrings[1])")
			
		if brightness <= 5:
			return (Enum).Parse(ConsoleColor, "$palette".Split("_"[0])[1])
			
		if brightness <= 7:
			return (Enum).Parse(ConsoleColor, "$palette".Split("_"[0])[0])
			
		return ConsoleColor.White
		
#	internal def ColorToCompositeMonochrome(color as Drawing.Color, palette as CompositeColor):
#		
#		brightness = (color.GetBrightness() * 10) cast byte
#		
#	internal def CompositeToShade(palette as ComplexColor, tone as Shade):
#		pass

	internal def ConsoleColorToSimpleColor(color as ConsoleColor):
		
		if color == ConsoleColor.Black:
			return SimpleColor.White
		
		colstr = "$color"
		
		if colstr.Contains("Dark"):
			return (Enum).Parse(SimpleColor, colstr.Replace("Dark", ""))
			
		return (color cast int) cast SimpleColor
		
	internal def ConsoleColorToSimpleShade(color as ConsoleColor):
		
		if "$color".Contains("Dark") or color == ConsoleColor.Black:
			return Shade.Dark
			
		return Shade.None
		
	internal def SimplePairToConsoleColor(color as SimpleColor, shade as Shade):
		
		if color == SimpleColor.White and shade == Shade.Dark:
			return ConsoleColor.Black
			
		if shade == Shade.Dark:
			return (Enum).Parse(ConsoleColor, "Dark$color")
			
		return (color cast int) cast ConsoleColor
		
	internal def ColorToComposite(color as Drawing.Color, tolerance as byte):
		
		brightness = (color.GetBrightness() * 10) cast byte
			
		if brightness < 2:
			return CompositeColor.Black

		elif brightness > 8:
			return CompositeColor.White
			
		shade as Shade
			
		if brightness == 2:
			shade = Shade.Darkest
			
		elif brightness == 3:
			shade = Shade.Darker
			
		elif brightness == 4:
			shade = Shade.Dark
			
		elif brightness == 5:
			shade = Shade.None
			
		elif brightness == 6:
			shade = Shade.Light
			
		elif brightness == 7:
			shade = Shade.Lighter
		
		elif brightness == 8:
			shade = Shade.Lightest
			
		else:
			shade = Shade.White
			
		# this section compares the effective range of each type of light (r,g,b)
		# against each other to determine the color
		# 0: the two colors are equal
		# -1: b is greater than a
		# 1: a is greater than b
		
		def compareRanges(lightA as byte, lightB as byte):
			
			if lightA == lightB:
				return 0
				
			colorRange = 0
			
			if lightA <= lightB + tolerance and lightA >= lightB - tolerance:
				++colorRange # a is in b's range
				
			if lightB <= lightA + tolerance and lightB >= lightA - tolerance:
				++colorRange # a is in b's range
				
			if colorRange == 2:
				return 0
				
			if lightA > lightB:
				return 1
			
			return -1
		
		simpleColor as Color
		
		bgComparison = compareRanges(color.B, color.G)
		brComparison = compareRanges(color.B, color.R)
		grComparison = compareRanges(color.G, color.R)
		
		if bgComparison == 1 and brComparison == 1:
			simpleColor = Color.Blue
			
		elif bgComparison == -1 and grComparison == 1:
			simpleColor = Color.Green
			
		elif brComparison == -1 and grComparison == -1:
			simpleColor = Color.Red
			
		elif bgComparison == 0 and brComparison != 0 and grComparison != 0:
			simpleColor = Color.Cyan
			
		elif bgComparison != 0 and brComparison == 0 and grComparison != 0:
			simpleColor = Color.Magenta
			
		elif bgComparison != 0 and brComparison != 0 and grComparison == 0:
			simpleColor = Color.Yellow
			
		else:
			simpleColor = Color.Gray
		
		if shade != Shade.None:
			return (Enum).Parse(CompositeColor, "$shade$simpleColor")
			
		else:
			return (simpleColor cast int) cast CompositeColor
	
	def GetCompositeFromName(color as CompositeColor):
		
		if color == CompositeColor.White:
			return ColorChar(ConsoleColor.White, ConsoleColor.White, char('█'))
			
		elif color == CompositeColor.Black:
			return ColorChar(ConsoleColor.Black, ConsoleColor.Black, char('█'))
		
		glyph as char
		backColor as ConsoleColor
		foreColor as ConsoleColor
		colorString = "$color"
		
		if colorString.Contains("White") or colorString.Contains("Darkest"):
			glyph = char('░')
			
		elif colorString.Contains("Lightest") or colorString.Contains("Darker"):
			glyph = char('▒')
			
		elif colorString.Contains("Lighter") or colorString.Contains("Dark"):
			glyph = char('▓')

		else:
			glyph = char('█')
			
		if colorString.Contains("White") or colorString.Contains("Light"):
			backColor = ConsoleColor.White
			
		else:
			backColor = ConsoleColor.Black
			
		if backColor == ConsoleColor.Black:
			if colorString.Contains("Blue"):
				foreColor = ConsoleColor.DarkBlue
				
			elif colorString.Contains("Cyan"):
				foreColor = ConsoleColor.DarkCyan
				
			elif colorString.Contains("Gray"):
				foreColor = ConsoleColor.DarkGray
				
			elif colorString.Contains("Green"):
				foreColor = ConsoleColor.DarkGreen
				
			elif colorString.Contains("Magenta"):
				foreColor = ConsoleColor.DarkMagenta
				
			elif colorString.Contains("Red"):
				foreColor = ConsoleColor.DarkRed
				
			else:
				foreColor = ConsoleColor.DarkYellow
				
		else:
			if colorString.Contains("Blue"):
				foreColor = ConsoleColor.Blue
				
			elif colorString.Contains("Cyan"):
				foreColor = ConsoleColor.Cyan
				
			elif colorString.Contains("Gray"):
				foreColor = ConsoleColor.Gray
				
			elif colorString.Contains("Green"):
				foreColor = ConsoleColor.Green
				
			elif colorString.Contains("Magenta"):
				foreColor = ConsoleColor.Magenta
				
			elif colorString.Contains("Red"):
				foreColor = ConsoleColor.Red
				
			else:
				foreColor = ConsoleColor.Yellow
				
		return ColorChar(backColor, foreColor, glyph)
		
	internal enum CompositeColor:
		White = 15
		WhiteBlue = 30
		WhiteCyan = 31
		WhiteGray = 32
		WhiteGreen = 33 
		WhiteMagenta = 34
		WhiteRed = 35
		WhiteYellow = 36
		LightestBlue = 37
		LightestCyan = 38
		LightestGray = 39
		LightestGreen = 40 
		LightestMagenta = 41
		LightestRed = 42
		LightestYellow = 43
		LighterBlue = 44
		LighterCyan = 45
		LighterGray = 46
		LighterGreen = 47
		LighterMagenta = 48
		LighterRed = 49
		LighterYellow = 50
		LightBlue = 51
		LightCyan = 52
		LightGray = 53
		LightGreen = 54 
		LightMagenta = 55
		LightRed = 56
		LightYellow = 57
		Blue = 9
		Cyan = 11
		Gray = 7
		Green = 10
		Magenta = 13
		Red = 12
		Yellow = 14
		DarkBlue = 1
		DarkCyan = 3
		DarkGray = 8
		DarkGreen = 2
		DarkMagenta = 5
		DarkRed = 4
		DarkYellow = 6
		DarkerBlue = 16
		DarkerCyan = 17
		DarkerGray = 18
		DarkerGreen = 19
		DarkerMagenta = 20
		DarkerRed = 21
		DarkerYellow = 22
		DarkestBlue = 23
		DarkestCyan = 24
		DarkestGray = 25
		DarkestGreen = 26
		DarkestMagenta = 27
		DarkestRed = 28
		DarkestYellow = 29
		Black = 0
		
	enum Color:
		Blue = 9
		Cyan = 11
		Gray = 7
		Green = 10
		Magenta = 13
		Red = 12
		Yellow = 14
		
	# For use in encoding only
	internal enum SimpleColor:
		Blue = 9
		Cyan = 11
		Gray = 7
		Green = 10
		Magenta = 13
		Red = 12
		Yellow = 14
		White = 15
		
	enum DuoColor:
		Cyan_Blue = 9
		Magenta_Red = 12
		Yellow_Green = 10
		
	internal enum Shade:
		None = 1
		Light
		Dark
		Darker
		Darkest
		Lighter
		Lightest
		White