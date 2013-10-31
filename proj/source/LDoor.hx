package ;
import flixel.FlxG;
import flixel.FlxSprite;


class LDoor extends FlxSprite 
{
public var locked:Bool;
public var open:Bool;

public function new(x:Float=0, y:Float=0, locked:Bool=true) 
{
	super(x, y+2);
	
	loadGraphic("assets/img/lDoor.png", true, false, 40, 40, false);
	animation.add("g2r", [3, 4], 2, false);
	animation.add("r2g", [4, 3], 2, false);
	animation.add("open", [3, 2, 1, 0], 6, false );
	animation.add("close", [0, 1, 2, 3], 6, false );
	animation.add("opened", [0], 1, false);
	animation.add("closed", [4], 1, false);
	animation.callback = onAnim;
	
	if (locked)
	{
	this.locked = true;
	open = false;
	animation.play("closed", true);
	}
	else
	{
	this.locked = false;
	open = true;
	animation.play("opened", true);
	}
}

public function Unlock():Void
{
	if (locked)
	{
	locked = false;
	animation.play("r2g", false);
	}
}

public function Colse(bot:Bot):Void
{
	if (FlxG.overlap(this, bot))
	{
	// first set bot to start pos 
	// then .. close
	animation.play("close");
	}
}

public function onAnim(name:String, f:Int, i:Int):Void
{
	if (name == "r2g" && animation.finished)
	animation.play("open");
	else if (name == "open" && animation.finished)
	open = true;
	else if (name == "close" && animation.finished)
	animation.play("g2r");
	else if (name == "g2r" && animation.finished)
	locked = true;
}
}
