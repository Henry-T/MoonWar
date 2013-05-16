package ;

import org.flixel.FlxGroup;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class TipManager extends FlxGroup{

	public static var Tip_InterCom 	: Int = 0;
	public static var Tip_BaseMove	: Int = 1;
	public static var Tip_BaseJump	: Int = 2;
	public static var Tip_JumpOver 	: Int = 3;
	public static var Tip_JumpDown 	: Int = 4;
	public static var Tip_HoldShoot	: Int = 5;
	public static var Tip_JumpShoot	: Int = 6;
	public static var Tip_UpShoot	: Int = 7;
	public static var Tip_Repair	: Int = 8;
	public static var Tip_Master1	: Int = 9;
	public static var Tip_Master2	: Int = 10;
	public static var Tip_Door		: Int = 11;
	public static var Tip_Count 	: Int = 12;

	public var mask:FlxSprite;
	public var bg:SliceShape;
	public var image:FlxSprite;

	private var _firstFrame : Bool;	// fix event skip with same key press

	public function new(){
		super();

		mask = new FlxSprite(0,0);
		mask.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		mask.alpha = 0.8;
		mask.scrollFactor.make(0,0);
		add(mask);

		bg = new SliceShape(FlxG.width * 0.2, FlxG.height * 0.2, FlxG.width * 0.6, FlxG.height * 0.6, ResUtil.IMG_ui_pnl_blue, SliceShape.MODE_BOX, 5);
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

	private var  hideCall:Void->Void;
	public function ShowTip(id:Int, call:Void->Void=null){
		image.loadGraphic("assets/img/tip" + id + ".png");
		image.x = FlxG.width * 0.5 - image.width * 0.5;
		image.y = FlxG.height * 0.5 - image.height * 0.5;

		visible = true;
		_firstFrame = true;
		FlxG.paused = true;

		hideCall = call;
		cast(FlxG.state, MWState).confirm.ShowConfirm(Confirm.Mode_OK,true,"Press X to Dismiss","OK", "",false, function(){
			 	HideTip();
			 	if(hideCall!=null) hideCall(); 
			});
	}

	public function HideTip(){
		visible = false;
		FlxG.paused = false;
	}
}