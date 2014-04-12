package ;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxSprite;

/**
 * ...
 * @author Tiago Ling Alexandre
 */
class IsoRect extends Rectangle
{
	public var isoPos:Point;
	public var depth:Int;
	public var sprite:FlxSprite;
	public var depthModifier:Int;
	
	public function new(x:Float, y:Float, width:Float, height:Float, sprite:FlxSprite) 
	{
		super(x, y, width, height);
		this.sprite = sprite;
		isoPos = new Point( -1, -1);
		depth = -1;
		depthModifier = -1;
	}
	
	public function setIso(x:Float, y:Float):Void
	{
		isoPos.x = x;
		isoPos.y = y;
	}
	
}