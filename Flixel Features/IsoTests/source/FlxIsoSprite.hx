package ;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author Tiago Ling Alexandre
 */
class FlxIsoSprite extends FlxSprite
{
	//0 - R; 1 - SE; 2 - S; 3 - SW; 4 - L; 5 - NW; 6 - N; 7 - NE
	var isoFacing:Int;
	public var isoRect:IsoRect;
	
	public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		init();
	}
	
	function init() 
	{
		loadGraphic("images/char_3.png", true, false, 48, 48);
		
		animation.add("idle_se", [0], 12, true);
		animation.add("idle_sw", [3], 12, true);
		animation.add("idle_nw", [6], 12, true);
		animation.add("idle_ne", [9], 12, true);
		
		animation.add("walk_se", [0, 1, 2], 12, true);
		animation.add("walk_sw", [3, 4, 5], 12, true);
		animation.add("walk_nw", [6, 7, 8], 12, true);
		animation.add("walk_ne", [9, 10, 11], 12, true);
		
		animation.play("idle_se");
		
		maxVelocity.x = 240;
		maxVelocity.y = 120;
		
		isoRect = new IsoRect(this.x, this.y, this.width, this.height, this);
		isoRect.depthModifier = 1000;
	}
	
	override public function update():Void 
	{
		super.update();
		
		velocity.x = velocity.y = 0;
		
		handleInput();
	}
	
	function handleInput() 
	{
		if (FlxG.keys.pressed.UP) {
			animation.play("walk_ne");
			velocity.x = 120;
			velocity.y = -60;
			isoFacing = 0;
		}
		if (FlxG.keys.pressed.DOWN) {
			animation.play("walk_sw");
			velocity.x = -120;
			velocity.y = 60;
			isoFacing = 1;
		}
		if (FlxG.keys.pressed.LEFT) {
			animation.play("walk_nw");
			velocity.x = -120;
			velocity.y = -60;
			isoFacing = 2;
		}
		if (FlxG.keys.pressed.RIGHT) {
			animation.play("walk_se");
			velocity.x = 120;
			velocity.y = 60;
			isoFacing = 3;
		}
		
		if (FlxG.keys.anyPressed(["UP", "DOWN", "LEFT", "RIGHT"])) {
			var motionDiffX = this.x - last.x;
			var motionDiffY = this.y - last.y;
			var newIsoX = isoRect.isoPos.x + motionDiffX;
			var newIsoY = isoRect.isoPos.y + motionDiffY;
			isoRect.setIso(newIsoX, newIsoY);
			isoRect.depth = Std.int(isoRect.isoPos.y * isoRect.depthModifier + isoRect.isoPos.x);
		}
		
		if (FlxG.keys.anyJustReleased(["UP", "DOWN", "LEFT", "RIGHT"])) {
			switch (isoFacing) {
				case 0:
					animation.play("idle_ne");
				case 1:
					animation.play("idle_sw");
				case 2:
					animation.play("idle_nw");
				case 3:
					animation.play("idle_se");
				default:
					animation.play("idle_ne");
			}
		}
	}
	
}