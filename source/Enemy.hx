package ;

import org.flixel.FlxSprite;
import org.flixel.FlxG;

/**
 * ...
 * @author 
 */
class Enemy extends FlxSprite
{
	public var On : Bool;

	public function new(X:Float=0, Y:Float=0, SimpleGraphics:Dynamic=null ) 
	{
		super(X, Y, SimpleGraphics);
		On = true;
	}

	override public function hurt(dmg:Float):Void
	{
		FlxG.play("assets/snd/hit1.mp3");
		super.hurt(dmg);
	}
	
	override public function kill():Void
	{
		FlxG.play("assets/snd/explo1.mp3");
		super.kill();
	}
}