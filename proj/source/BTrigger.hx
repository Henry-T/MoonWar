package ;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;



class BTrigger extends FlxObject 
{
	public var gid:Int;
	public var triggered:Bool;

	public function new(X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0) 
	{
		super(X, Y, Width, Height);
		triggered = false;
	}

	public function TryTrigger():Void
	{
		if (!triggered)
		{
			triggered = true;
			var births:FlxGroup = cast(FlxG.state , Level).births;
			for (birth in births.members)
			{
				if(birth==null) continue;
				if (cast(birth , Birth).gid == gid)
				cast(birth , Birth).Start();
			}
		}
	}
}