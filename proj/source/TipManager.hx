package ;

import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

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

	public var txtTitle:FlxText;
	public var txtDesc:FlxText;

	private var _firstFrame : Bool;	// fix event skip with same key press

	public var titles:Array<String>;
	public var descs:Array<String>;

	public function new(){
		super();

		titles = [
			"A Tip A Console",
			"Go! Go! Go!",
			"Jump Is Handy",
			"Jump Is Handier",
			"Jump Down",
			"Hold Shoots Faster Than Press",
			"Jump Then Shoot",
			"Shoot At 8-Directions",
			"When Injured",
			"Go-Pro: Shoot And Run",
			"Master Tip: Jump! Move! Shoot!",
			"Use Lifts"
		];

		#if !FLX_NO_TOUCH
		descs = [
			"Press A to poll tip on a console",
			"Use the analog to run around",
			"Press B to jump over things",
			"Run-Jump is usual way to avoid spikes",
			"Hold Down then press B to jump down",
			"Hold A to shoot a decent amount of bullets!",
			"B to Jump then A to Shoot",
			"Hold A with any arrow keys, try it out!",
			"Grub the blue cage to get full repaired",
			"Keep moving to avoid bullets then shoot back",
			"Move in air to avoid bunches of bullets while shooting back",
			"Press A to open gates or get into lifts"
		];
		#else
		descs = [
			"Press C to poll tip on a console",
			"Press Left and Right to run around",
			"Press X to jump over things",
			"Run-Jump is usual way to avoid spikes",
			"Hold Down then press X to jump down",
			"Hold C to shoot a decent amount of bullets!",
			"X to Jump then C to Shoot",
			"Hold C with any arrow keys, try it out!",
			"Grub the blue cage to get full repaired",
			"Keep moving to avoid bullets then shoot back",
			"Move in air to avoid bunches of bullets while shooting back",
			"Press C to open gates or get into lifts"
		];
		#end

		mask = new FlxSprite(0,0);
		mask.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		mask.alpha = 0.8;
		mask.scrollFactor.set(0,0);
		add(mask);

		bg = new SliceShape(FlxG.width * 0.2, FlxG.height * 0.2, FlxG.width * 0.6, FlxG.height * 0.6, ResUtil.IMG_ui_pnl_blue, SliceShape.MODE_BOX, 5);
		bg.scrollFactor.set(0,0);
		add(bg);

		image = new FlxSprite(0,0);
		image.scrollFactor.set(0,0);
		add(image);

		txtTitle = new FlxText(0, FlxG.height * 0.06, FlxG.width, "Title");
		txtTitle.setFormat(ResUtil.FNT_Pixelex, 15, 0xffffff, "center");
		txtTitle.scrollFactor.set(0,0);
		add(txtTitle);

		txtDesc = new FlxText(0, FlxG.height * 0.8, FlxG.width, "Desc");
		txtDesc.setFormat(ResUtil.FNT_Amble, GameStatic.txtSize_desc, 0xffffff, "center");
		txtDesc.scrollFactor.set(0,0);
		add(txtDesc);

		visible = false;
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

		txtTitle.text = titles[id];
		txtDesc.text = descs[id];

		hideCall = call;

		cast(FlxG.state, Level).input.showControl(false);
		cast(FlxG.state, MWState).confirm.ShowConfirm(Confirm.Mode_OK,true,"Dismiss the Tip?","OK", "",false, function(){
			 HideTip();
			 if(hideCall!=null) hideCall();
			 cast(FlxG.state, Level).input.showControl(true);
		});
	}

	private function HideTip(){
		visible = false;
		FlxG.paused = false;
	}
}