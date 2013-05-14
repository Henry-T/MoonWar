package ;

import org.flixel.FlxGroup;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class TipManager extends FlxGroup{

	public static var Tip_Movement	:Int = 0;
	public static var Tip_Jump		:Int = 1;
	public static var Tip_Shoot		:Int = 2;
	public static var Tip_Action	:Int = 3;
	public static var Tip_Health	:Int = 4;


	public var bg:SliceShape;
	public var image:FlxSprite;

	public function new(){
		super();

		bg = new SliceShape(FlxG.width * 0.2, FlxG.height * 0.2, FlxG.width * 0.6, FlxG.height * 0.6, ResUtil.IMG_ui_box_blue, SliceShape.MODE_BOX, 3);
		bg.scrollFactor.make(0,0);
		add(bg);

		image = new FlxSprite(0,0);
		image.scrollFactor.make(0,0);
		add(image);
	}

	public override function update(){
		super.update();
	}

	public override function draw(){
		super.draw();
	}

	public function ShowTip(id:Int){
		image.loadGraphic("assets/img/tip" + id + ".png");
		image.x = FlxG.width * 0.5 - image.width * 0.5;
		image.y = FlxG.height * 0.5 - image.height * 0.5;

		visible = true;
	}

	public function HideTip(){
		visible = false;
	}
}