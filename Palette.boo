namespace ConsolePaint

import System

public static class Palette:
	
	internal def ConsoleColorToColor(color as ConsoleColor) as Drawing.Color:
		
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
	
	// Here's an explanation of how bitwise operations work for noobs like me: https://www.alanzucconi.com/2015/07/26/enum-flags-and-bitwise-operators/
	// Original code by Malwyn at https://stackoverflow.com/questions/1988833/converting-color-to-consolecolor/29192463#29192463
	// Basically how it works is it is changing the value of the index at the bit level.
	internal def ColorToConsoleColor(color as Drawing.Color) as ConsoleColor:
		
		index as short
		
		// I took the liberty to have || ("or" in boo) instead of | since | cannot be used like that in boo
		// (or if there is a way, the documentation is lacking)	and secondly it doesn't matter if the other 
		// parts of the condition are not evaluated; the bitwise operations begin after the index is set to 
		// 8 even in the original code. So technically, this is a faster implementation.
		if color.B > 128 or color.G > 128 or color.R > 128:
			index = 8 // 8 is the number of bits in a standard byte or octet
			// Light colour
			
		else:
			index = 0
			// Dark colour
			
		if  color.R > 64: // 64 is half of 128 which can be used as a treshold of sorts
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
		
	internal def ColorToMonochrome(color as Drawing.Color, palette as Color) as ConsoleColor:
		
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
		
	internal def ColorToDuochrome(color as Drawing.Color, palette as DuoColor) as ConsoleColor:
		
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
		
//	internal def ColorToCompositeMonochrome(color as Drawing.Color, palette as CompositeColor):
//		
//		brightness = (color.GetBrightness() * 10) cast byte
		
//	internal def CompositeToShade(palette as ComplexColor, tone as Shade):
//		pass

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
		
	internal enum CompositeColor:
		LightBlue = 30
		LightCyan = 31
		LightGray = 32
		LightGreen = 33 
		LightMagenta = 34
		LightRed = 35
		LightYellow = 36
		White = 15
		Blue = 9
		Cyan = 11
		Gray = 7
		Green = 10
		Magenta = 13
		Red = 12
		Yellow = 14
		DarkBlue = 23
		DarkCyan = 24
		DarkGray = 25
		DarkGreen = 26
		DarkMagenta = 27
		DarkRed = 28
		DarkYellow = 29
		DarkerBlue = 1
		DarkerCyan = 3
		DarkerGray = 8
		DarkerGreen = 2
		DarkerMagenta = 5
		DarkerRed = 4
		DarkerYellow = 6
		Black = 0
		DarkestBlue = 16
		DarkestCyan = 17
		DarkestGray = 18
		DarkestGreen = 19
		DarkestMagenta = 20
		DarkestRed = 21
		DarkestYellow = 22
		
	public enum Color:
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
		
	public enum DuoColor:
		Cyan_Blue = 9
		Magenta_Red = 12
		Yellow_Green = 10
		
	internal enum Shade:
		None = 1
		Light
		Dark
		Darker
		Darkest