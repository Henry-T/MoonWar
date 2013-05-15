package ;
import org.flixel.FlxG;
import org.flixel.FlxSprite;


class LDoor extends FlxSprite 
{
public var locked:Bool;
public var open:Bool;

public function new(x:Float=0, y:Float=0, locked:Bool=true) 
{
	super(x, y+2);
	
	loadGraphic("assets/img/lDoor.png", true, false, 40, 40, false);
	addAnimation("g2r", [3, 4], 2, false);
	addAnimation("r2g", [4, 3], 2, false);
	addAnimation("open", [3, 2, 1, 0], 6, false );
	addAnimation("close", [0, 1, 2, 3], 6, false );
	addAnimation("opened", [0], 1, false);
	addAnimation("closed", [4], 1, false);
	addAnimationCallback(onAnim);
	
	if (locked)
	{
	this.locked = true;
	open = false;
	play("closed", true);
	}
	else
	{
	this.locked = false;
	open = true;
	play("opened", true);
	}
}

public function Unlock():Void
{
	if (locked)
	{
	locked = false;
	play("r2g", false);
	}
}

public function Colse(bot:Bot):Void
{
	if (FlxG.overlap(this, bot))
	{
	// first set bot to start pos 
	// then .. close
	play("close");
	}
}

public function onAnim(name:String, f:Int, i:Int):Void
{
	if (name == "r2g" && finished)
	play("open");
	else if (name == "open" && finished)
	open = true;
	else if (name == "close" && finished)
	play("g2r");
	else if (name == "g2r" && finished)
	locked = true;
}
}
