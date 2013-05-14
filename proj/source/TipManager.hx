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

	public var mask:FlxSprite;
	public var bg:SliceShape;
	public var image:FlxSprite;

	private var _firstFrame : Bool;	// fix event skip with same key press

	public function new(){
		super();

		mask = new FlxSprite(0,0);
		mask.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		mask.alpha = 0.5;
		mask.scrollFactor.make(0,0);
		add(mask);

		bg = new SliceShape(FlxG.width * 0.2, FlxG.height * 0.2, FlxG.width * 0.6, FlxG.height * 0.6, ResUtil.IMG_ui_box_blue, SliceShape.MODE_BOX, 3);
		bg.scrollFactor.make(0,0);
		add(bg);

		image = new FlxSprite(0,0);
		image.scrollFactor.make(0,0);
		add(image);
	}

	public override function update(){
		if(_firstFrame)
			_firstFrame = false;
		else
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
		_firstFrame = true;
	}

	public function HideTip(){
		visible = false;
	}
}