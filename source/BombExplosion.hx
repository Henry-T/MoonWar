package;
import org.flixel.FlxSprite;

class BombExplosion extends FlxSprite
{


public function new(X:Float=0, Y:Float=0, SimpleGraphic:Dynamic=null)
{
	super(X, Y, SimpleGraphic);
	
	this.loadGraphic("assets/img/expl.png",true, false, 32,32);
	this.addAnimation("expl", [0,1,2,3,4,5,6,7], 10, false);
	this.addAnimationCallback(checkLiving);
	this.play("expl");
}

override public function reset(X:Float, Y:Float):Void 
{
	super.reset(X, Y);
	play("expl", true);
}

public function checkLiving(anim:String, frame:Int, index:Int):Void
{
	if(frame == 7)
	{
	kill();
	}
}
}