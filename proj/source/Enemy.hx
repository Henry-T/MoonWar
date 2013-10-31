package ;

import flixel.FlxSprite;
import flixel.FlxG;

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
		FlxG.sound.play("hit1");
		flixel.util.FlxSpriteUtil.flicker(this, 0.1);
		super.hurt(dmg);
	}
	
	override public function kill():Void
	{
		if(this.onScreen()){
			FlxG.sound.play("explo1");
			var lvl:Level = cast(FlxG.state, Level);
			lvl.AddExp(getMidpoint().x, getMidpoint().y);
			for (i in 0...4)
				lvl.boomPar.Boom(x, y, width, height);
		}
		super.kill();
	}
}