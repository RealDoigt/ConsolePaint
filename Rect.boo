namespace ConsolePaint

import System

static class RectanglePainting:
	
	// These must have the same order as BorderType
	final private Verticals as string = "┃│║:|╎┇┋"
	final private Horizontals as string = "━─═.-╌┄┈"
	final private topLeftCorners as string = "┏┌╔.+╭,."
	final private topRightCorners as string = "┓┐╗.+╮,."
	final private bottomLeftCorners as string = "┗└╚:+╰' "
	final private bottomRightCorners as string = "┛┘╝:+╯' "	
	
	public enum BorderType:
		Heavy
		Single
		Double
		Dotted
		Vanilla
		DoubleDashed
		TripleDashed
		QuadrupleDashed
		
	public enum SpecialBorderType:
		Wavy
		Wavish
		Pointy
		Pointish
		Triangles
		CardSuits
		
	private enum SubBorderType:
		Vertical
		Horizontal
		TopLeftCorner
		TopRightCorner
		BottomLeftCorner
		BottomRightCorner
		
	private def ChangeBrush(border as BorderType, sub as SubBorderType):
			
		if sub == SubBorderType.Vertical:
			Painting.brush = Verticals[border cast int]
			
		elif sub == SubBorderType.Horizontal:
			Painting.brush = Horizontals[border cast int]
			
		elif sub == SubBorderType.TopLeftCorner:
			Painting.brush = topLeftCorners[border cast int]
			
		elif sub == SubBorderType.TopRightCorner:
			Painting.brush = topRightCorners[border cast int]
			
		elif sub == SubBorderType.BottomLeftCorner:
			Painting.brush = bottomLeftCorners[border cast int]
			
		else:
			Painting.brush = bottomRightCorners[border cast int]
			
	private def ChangeBrushCS(count as int):
		
			if count % 4 == 0:
				Painting.brush = char('♦')
				
			elif count % 3 == 0:
				Painting.brush = char('♥')
				
			elif count % 2 == 0:
				Painting.brush = char('♣')
				
			else:
				Painting.brush = char('♠')
			
	public def DrawSquare(posX as byte, posY as byte, length as byte, color as ConsoleColor):
		DrawRectangle(posX, posY, length, length, color)
		
	public def DrawSquare(border as BorderType, posX as byte, posY as byte, length as byte, color as ConsoleColor):
		DrawRectangle(border, posX, posY, length, length, color)
		
	public def DrawSquare(border as SpecialBorderType, posX as byte, posY as byte, length as byte, color as ConsoleColor):
		DrawRectangle(border, posX, posY, length, length, color)
	
	public def DrawRectangle(posX as byte, posY as byte, height as byte, width as byte, color as ConsoleColor):
		
		Painting.DrawHorizontalLine(posX, posY, width, color)
		Painting.DrawVerticalLine(posX, posY + 1, height - 2, color)
		Painting.DrawVerticalLine(posX + width - 1, posY + 1, height - 2, color)
		Painting.DrawHorizontalLine(posX, posY + height - 1, width, color)
		
	public def DrawRectangle(border as BorderType, posX as byte, posY as byte, height as byte, width as byte, color as ConsoleColor):
		currentBrush = Painting.brush
		
		ChangeBrush(border, SubBorderType.Horizontal)
		Painting.DrawHorizontalLine(posX, posY, width, color)
		Painting.DrawHorizontalLine(posX, posY + height - 1, width, color)
		
		ChangeBrush(border, SubBorderType.Vertical)
		Painting.DrawVerticalLine(posX, posY + 1, height - 2, color)
		Painting.DrawVerticalLine(posX + width - 1, posY + 1, height - 2, color)
		
		ChangeBrush(border, SubBorderType.TopLeftCorner)
		Painting.DrawCell(posX, posY, color)
		
		ChangeBrush(border, SubBorderType.TopRightCorner)
		Painting.DrawCell(posX + width - 1, posY, color)
		
		ChangeBrush(border, SubBorderType.BottomLeftCorner)
		Painting.DrawCell(posX, posY + height - 1, color)
		
		ChangeBrush(border, SubBorderType.BottomRightCorner)
		Painting.DrawCell(posX + width - 1, posY + height - 1, color)
		
		Painting.brush = currentBrush
	
	private def DrawBracketedRectangle(border as SpecialBorderType, posX as byte, posY as byte, height as byte, width as byte, color as ConsoleColor):
		
		brushes as string = ""
		
		if border == SpecialBorderType.Wavy:
			brushes = "()"
			
		elif border == SpecialBorderType.Pointy:
			brushes = "{}"
			
		else:
			brushes = "[]"
		
		Painting.brush = brushes[0]
		Painting.DrawVerticalLine(posX, posY, height, color)
		
		Painting.brush = brushes[1]
		Painting.DrawVerticalLine(posX + width - 1, posY, height, color)
	
	private def DrawAlternatingRectangle(border as SpecialBorderType, posX as byte, posY as byte, height as byte, width as byte, color as ConsoleColor):
		
		brushes = ""
		
		if border == SpecialBorderType.Wavish:
			brushes = "()"
			
		elif border == SpecialBorderType.Pointish:
			brushes = "{}"
			
		else:
			brushes = "[]"
		
		for count in range(height):
			
			if count % 2 == 0:
				Painting.brush = brushes[1]
				
			else:
				Painting.brush = brushes[0]
				
			Painting.DrawCell(posX, posY + count, color)
			Painting.DrawCell(posX + width, posY + count, color)
	
	private def DrawSuitsRectangle(posX as byte, posY as byte, height as byte, width as byte, color as ConsoleColor):
		
		for count in range(height):
			
			ChangeBrushCS(count)
				
			Painting.DrawCell(posX, posY + count, color)
			Painting.DrawCell(posX + width, posY + count, color)
			
		for count in range(width):
			
			ChangeBrushCS(count)
			Painting.DrawCell(posX + count, posY, color)
			Painting.DrawCell(posX + count, posY + height - 1, color)
	
	public def DrawRectangle(border as SpecialBorderType, posX as byte, posY as byte, height as byte, width as byte, color as ConsoleColor):
		
		currentBrush = Painting.brush
		
		if border == SpecialBorderType.Wavy or border == SpecialBorderType.Pointy:
			DrawBracketedRectangle(border, posX, posY, height, width, color)
			
		elif border == SpecialBorderType.Wavish or border == SpecialBorderType.Pointish:
			DrawAlternatingRectangle(border, posX, posY, height, width, color)
			
		elif border == SpecialBorderType.Triangles:
			
			Painting.brush = "▼"[0]
			Painting.DrawHorizontalLine(posX, posY, width, color)
			Painting.DrawVerticalLine(posX, posY + 1, height - 1, color)
			
			Painting.brush = "▲"[0]
			Painting.DrawVerticalLine(posX + width - 1, posY, height, color)
			Painting.DrawHorizontalLine(posX + 1, posY + height - 1, width - 1, color)
			
		else:
			DrawSuitsRectangle(posX, posY, height, width, color)
			
		Painting.brush = currentBrush