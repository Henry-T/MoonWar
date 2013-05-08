package ;

import org.flixel.FlxSprite;
import org.flixel.FlxAssets;
import org.flixel.FlxG;
import org.flixel.FlxButton;
import org.flixel.FlxTypedGroup;

class MyGamePad extends FlxTypedGroup<FlxButton>
{
	public var buttonA:FlxButton;
	public var buttonB:FlxButton;
	public var actions:FlxTypedGroup<FlxButton>;

	public function new(){
		super();
		actions = new FlxTypedGroup<FlxButton>();
		var mag:Int = GameStatic.screenDensity == 1?1:2;
		actions.add(add(buttonA = createButton(FlxG.width - 44*mag, FlxG.height - 45*mag, 44*mag, 45*mag, (GameStatic.screenDensity==1?"assets/img/gpAM.png":"assets/img/gpAL.png"))));
		actions.add(add(buttonB = createButton(FlxG.width - 96*mag, FlxG.height - 45*mag, 44*mag, 45*mag, (GameStatic.screenDensity==1?"assets/img/gpBM.png":"assets/img/gpBL.png"))));
	}

	public function createButton(X:Float, Y:Float, Width:Int, Height:Int, Image:String, OnClick:Void->Void = null):FlxButton
	{
		var button:FlxButton = new FlxButton(X, Y);
		button.loadGraphic(Image, true, false, Width, Height);
		button.solid = false;
		button.immovable = true;
		button.scrollFactor.x = button.scrollFactor.y = 0;

		#if !FLX_NO_DEBUG
		button.ignoreDrawDebug = true;
		#end
		
		if (OnClick != null)
		{
			button.onDown = OnClick;
		}
		return button;
	}
}