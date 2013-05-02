package;

import org.flixel.tweens.misc.VarTween;
import org.flixel.tweens.FlxTween;
import org.flixel.FlxG;
import org.flixel.tweens.util.Ease;


class LevelTest extends Level{
	public function new(){
		super();
		tileXML = nme.Assets.getText("assets/dat/levelTest.tmx");
	}

	public override function create(){
		super.create();
		AddAll();

		// initial 
		bot.x = this.start.x;
		bot.y = this.end.y;
		bot.On = false;

		// Test : VarTween
		//var camTween:VarTween = new VarTween(null, FlxTween.PERSIST);
		//camTween.tween(FlxG.camera.scroll, "x", 100, 2, Ease.quartInOut);
		//this.addTween(camTween);

		// Test : Camera Tween
		// TweenCamera(100, 0, 1, true, function(){
		// 	TweenCamera(100, 100, 1, true, function(){
		// 		TweenCamera(0, 100, 1, true, function(){
		// 			TweenCamera(0, 0, 1, true, null);
		// 		});
		// 	});
		// });

		// Test : Tips
	}

	public override function update(){
		super.update();
	}

	public override function draw(){
		super.draw();
	}
}