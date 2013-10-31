package ;

import flixel.FlxSprite;
import flixel.system.FlxAssets;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.group.FlxTypedGroup;

// override
class MyGamePad extends FlxTypedGroup<FlxButton>
{
	public var buttonA:FlxButton;
	public var buttonB:FlxButton;

	public function new(){
		super();

		var btnWidth:Int = 0;
		var btnHeight:Int = 0;
		var imgA:String = "";
		var imgB:String = "";
		if(GameStatic.screenDensity == GameStatic.Density_S){
			btnWidth = 44;
			btnHeight = 45;
			imgA = "assets/img/gpAS.png";
			imgB = "assets/img/gpBS.png";
		}
		else if(GameStatic.screenDensity == GameStatic.Density_M || GameStatic.screenDensity == GameStatic.Density_L){
			btnWidth = 88;
			btnHeight = 90;
			imgA = "assets/img/gpAM.png";
			imgB = "assets/img/gpBM.png";
		}
		buttonA = add(createButton(FlxG.width - btnWidth - 5, FlxG.height - btnHeight - 5, btnWidth, btnHeight, imgA));
		buttonB = add(createButton(FlxG.width - btnWidth * 2 - 10, FlxG.height - btnHeight - 5, btnWidth, btnHeight, imgB));
		// buttonA = add(createButton(FlxG.width - btnWidth - 5, FlxG.height - btnHeight - 5, btnWidth, btnHeight, imgA));
		// buttonB = add(createButton(FlxG.width - btnWidth * 2 - 10, FlxG.height - btnHeight - 5, btnWidth, btnHeight, imgB));
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