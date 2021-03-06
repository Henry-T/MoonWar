package ;
import flixel.FlxSprite;
import org.flixel.tmx.TmxObject;
import flixel.FlxG;

class Com extends FlxSprite 
{
	public var onTig:Void->Void;
	public var On:Bool;
	public var name:String;
	public var tipId:Int;
	public var AutoReset:Bool;

	public function new(x:Float=0, y:Float=0, on:Bool = false )
	{
		super(x, y);
		
		loadGraphic("assets/img/com.png", true, false, 20, 40);
		animation.add("off", [0], 1, false);
		animation.add("on", [1], 1, false);
		SetOn(on);
	}

	public function make(o:TmxObject)
	{
		reset(o.x, o.y);
		name = o.name;
		if (Std.parseInt(o.custom.resolve("on")) == 0)
			SetOn(false);
		else
			SetOn(true);
	}

	public override function update(){
		super.update();
		if(AutoReset && !FlxG.overlap(this, cast(FlxG.state, Level).bot) && On)
			SetOn(false);
	}

	public function SetOn(on:Bool):Void 
	{
		On = on;
		if (On)
			animation.play("on");
		else
			animation.play("off");
	}

	public function ToggleOn():Void
	{
		if (On == false)
		{
			if (onTig != null)
				onTig();
			SetOn(true);
		}
	}

	// set this com as a tip providers
	public function SetTip(id:Int):Void{
		tipId = id;
		onTig = function(){
			var lvl:Level = cast(FlxG.state, Level);
			lvl.tipManager.ShowTip(tipId);
		}
		// if a console is tip provider, set it as autoreset
		AutoReset = true;

		// load a different image
		loadGraphic("assets/img/comTip.png", true, false, 20, 40);
		animation.add("off", [0], 1, false);
		animation.add("on", [1], 1, false);
	}
}