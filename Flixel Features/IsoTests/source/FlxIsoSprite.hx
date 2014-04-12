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
		loadGraphic("images/test_char_48w.png", true, false, 48, 56);
		animation.add("idle_down", [0], 12, true);
		animation.add("idle_left", [4], 12, true);
		animation.add("idle_right", [8], 12, true);
		animation.add("idle_up", [12], 12, true);
		animation.add("idle_sw", [16], 12, true);
		animation.add("idle_se", [20], 12, true);
		animation.add("idle_nw", [24], 12, true);
		animation.add("idle_ne", [28], 12, true);
		animation.add("walk_down", [0, 1, 2, 3], 12, true);
		animation.add("walk_left", [4, 5, 6, 7], 12, true);
		animation.add("walk_right", [8, 9, 10, 11], 12, true);
		animation.add("walk_up", [12, 13, 14, 15], 12, true);
		animation.add("walk_sw", [16, 17, 18, 19], 12, true);
		animation.add("walk_se", [20, 21, 22, 23], 12, true);
		animation.add("walk_nw", [24, 25, 26, 27], 12, true);
		animation.add("walk_ne", [28, 29, 30, 31], 12, true);
		animation.play("idle_down");
		
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
			animation.play("walk_up");
			velocity.y = -120;
			isoFacing = 6;
		}
		if (FlxG.keys.pressed.DOWN) {
			animation.play("walk_down");
			velocity.y = 120;
			isoFacing = 2;
		}
		if (FlxG.keys.pressed.LEFT) {
			animation.play("walk_left");
			velocity.x = -120;
			isoFacing = 4;
		}
		if (FlxG.keys.pressed.RIGHT) {
			animation.play("walk_right");
			velocity.x = 120;
			isoFacing = 0;
		}
		
		if (FlxG.keys.pressed.UP && FlxG.keys.pressed.RIGHT) {
			animation.play("walk_ne");
			velocity.x = 120;
			velocity.y = -60;
			isoFacing = 7;
		}
		if (FlxG.keys.pressed.UP && FlxG.keys.pressed.LEFT) {
			animation.play("walk_nw");
			velocity.x = -120;
			velocity.y = -60;
			isoFacing = 5;
		}
		if (FlxG.keys.pressed.DOWN && FlxG.keys.pressed.RIGHT) {
			animation.play("walk_se");
			velocity.x = 120;
			velocity.y = 60;
			isoFacing = 1;
		}
		if (FlxG.keys.pressed.DOWN && FlxG.keys.pressed.LEFT) {
			animation.play("walk_sw");
			velocity.x = -120;
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
					animation.play("idle_right");
				case 1:
					animation.play("idle_se");
				case 2:
					animation.play("idle_down");
				case 3:
					animation.play("idle_sw");
				case 4:
					animation.play("idle_left");
				case 5:
					animation.play("idle_nw");
				case 6:
					animation.play("idle_up");
				case 7:
					animation.play("idle_ne");
				default:
					animation.play("idle_down");
			}
		}
	}
	
}