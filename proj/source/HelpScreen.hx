package;
import flixel.FlxSprite;
import flash.display.BitmapData;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;

class HelpScreen extends MWState
{
	public var bg:FlxBackdrop;

	public var mainPnl:SliceShape;
	public var bottomPnl:SliceShape;
	public var btnGBigNormal:BitmapData;
	public var btnGBigOver:BitmapData;
	public var btnBack:FlxButton;
	public var btnLast:FlxButton;
	public var btnNext:FlxButton;

	public var selector:SliceShape;

	public var txtMusic:FlxText;
	public var txtMusicBy:FlxText;
	public var txtCreated:FlxText;
	public var txtCreatedBy:FlxText;

	public var txtTitle:FlxText;
	public var txtNum:FlxText;
	public var txtDesc:FlxText;

	public var titles:Array<String>;
	public var nums:Array<String>;
	public var descs:Array<String>;
	public var images:Array<FlxSprite>;

	public var curId:Int;

	public function new(){
		super();

		titles = [
			"Movement",
			"Jump",
			"Shoot",
			"Action",
			"Health"
		];

		nums = [
			"1/5",
			"2/5",
			"3/5",
			"4/5",
			"5/5"
		];

		descs = [
			"Press Arrow Left and Right to Walk",
			"Press X to Jump Up, Hold Down and Press X to Jump Down",
			"Hold C to Shoot, Combining with Arrow keys to Shoot At Different Directoins",
			"Use C to Talk, Trigger console and Enter Lift",
			"When In Low Health, Grub the Blue Cage to Get Repaired"
		];
	}

	override public function create():Void 
	{
		super.create();

		this.bgColor = 0xff000000;

		curId = 0;

		images = new Array<FlxSprite>();
		for (i in 0...titles.length) {
			var img:FlxSprite = new FlxSprite("assets/img/help" + i + ".png");
			img.x = FlxG.width * 0.5 - img.width *0.5;
			img.y = FlxG.height * 0.4 - img.height * 0.5;
			images.push(img);
		}

		bg = new FlxBackdrop("assets/img/star2.png", 0, 0, true, true);
		mainPnl = new SliceShape(0,0, 350, 280, ResUtil.IMG_ui_pnl_blue, SliceShape.MODE_BOX, 5);
		mainPnl.x = FlxG.width*0.5 - mainPnl.width*0.5;
		mainPnl.y = FlxG.height*0.4 - mainPnl.height*0.5;

		selector = new SliceShape(0, 0, GameStatic.border_menuWidth, GameStatic.border_menuHeight, "assets/img/ui_boxact_border.png", SliceShape.MODE_BOX, 2);

		bottomPnl = new SliceShape(-5, FlxG.height-50, FlxG.width + 10, 40, "assets/img/ui_barh_b.png", SliceShape.MODE_HERT, 1);
		btnGBigNormal = new SliceShape(0,0, GameStatic.button_menuWidth, GameStatic.button_menuHeight, "assets/img/ui_box_b.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnGBigOver = new SliceShape(0,0, GameStatic.button_menuWidth, GameStatic.button_menuHeight, "assets/img/ui_boxact_b.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnBack = new FlxButton(0, 0, "BACK", function() { FlxG.switchState(new MainMenu()); } );
		btnBack.loadGraphic(btnGBigNormal);
		btnBack.setOnOverCallback(function(){btnBack.loadGraphic(btnGBigOver);});
		btnBack.setOnOutCallback(function(){btnBack.loadGraphic(btnGBigNormal);});
		btnBack.x = FlxG.width * 0.5 - btnBack.width/2;
		btnBack.y = FlxG.height * 0.90;
		btnBack.label.setFormat(ResUtil.FNT_Pixelex, 16, 0xffffff, "center");

		btnLast = new FlxButton(0, 0, "LAST", function() {UpdateDesc(-1);} );
		btnLast.loadGraphic(btnGBigNormal);
		btnLast.setOnOverCallback(function(){btnLast.loadGraphic(btnGBigOver);});
		btnLast.setOnOutCallback(function(){btnLast.loadGraphic(btnGBigNormal);});
		btnLast.x = 20;
		btnLast.y = FlxG.height * 0.90;
		btnLast.label.setFormat(ResUtil.FNT_Pixelex, 16, 0xffffff, "center");

		btnNext= new FlxButton(0, 0, "NEXT", function() {UpdateDesc(1);} );
		btnNext.loadGraphic(btnGBigNormal);
		btnNext.setOnOverCallback(function(){btnNext.loadGraphic(btnGBigOver);});
		btnNext.setOnOutCallback(function(){btnNext.loadGraphic(btnGBigNormal);});
		btnNext.x = FlxG.width - btnNext.width - 20;
		btnNext.y = FlxG.height * 0.90;
		btnNext.label.setFormat(ResUtil.FNT_Pixelex, 16, 0xffffff, "center");

		txtCreated = new FlxText(0,0,120, "Created By");
		txtCreated.setFormat(ResUtil.FNT_Amble, 10, 0xffdddddd, "right");
		txtCreated.x = FlxG.width * 0.5 - txtCreated.width - 10;
		txtCreated.y = FlxG.height * 0.5 - 50;

		txtCreatedBy = new FlxText(0,0,120, "Lolofinil");
		txtCreatedBy.setFormat(ResUtil.FNT_Amble, 10, 0xffffff, "left");
		txtCreatedBy.x = FlxG.width * 0.5 + 10;
		txtCreatedBy.y = FlxG.height * 0.5 - 50;

		txtMusic = new FlxText(0,0,120, "Music By");
		txtMusic.setFormat(ResUtil.FNT_Amble, 10, 0xffdddddd, "right");
		txtMusic.x = FlxG.width * 0.5 - txtMusic.width - 10;
		txtMusic.y = FlxG.height * 0.5 + 50;

		txtMusicBy = new FlxText(0,0, 150, "www.nosoapradio.us");
		txtMusicBy.setFormat(ResUtil.FNT_Amble, 10, 0xffffff, "left");
		txtMusicBy.x = FlxG.width * 0.5 + 10;
		txtMusicBy.y = FlxG.height * 0.5 + 50;

		txtTitle = new FlxText(0, FlxG.height * 0.06, FlxG.width, "Title");
		txtTitle.setFormat(ResUtil.FNT_Pixelex, 15, 0xffffff, "center");
		txtTitle.scrollFactor.set(0,0);

		txtNum = new FlxText(0, FlxG.height * 0.1, FlxG.width, "Num");
		txtNum.setFormat(ResUtil.FNT_Amble, GameStatic.txtSize_dialog, 0xffffff, "center");
		txtNum.scrollFactor.set(0,0);

		txtDesc = new FlxText(0, FlxG.height * 0.8, FlxG.width, "Desc");
		txtDesc.setFormat(ResUtil.FNT_Amble, GameStatic.txtSize_desc, 0xffffff, "center");
		txtDesc.scrollFactor.set(0,0);

		add(bg);
		add(mainPnl);
		//add(txtCreated);
		//add(txtCreatedBy);
		//add(txtMusic);
		//add(txtMusicBy);
		add(bottomPnl);
		if(GameStatic.useKeyboard)
			add(selector);
		add(btnBack);
		if(GameStatic.useTouch){
			add(btnLast);
			add(btnNext);
		}
		add(txtTitle);
		add(txtNum);
		add(txtDesc);
		add(confirm);

		selector.x = btnBack.x + GameStatic.offset_border;
		selector.y = btnBack.y + GameStatic.offset_border;

		UpdateDesc();

		#if !FLX_NO_KEYBOARD
		bottomPnl.visible = false;
		btnBack.visible = false;
		btnLast.visible = false;
		btnNext.visible = false;
		selector.visible = false;
		confirm.ShowConfirm( Confirm.Mode_TextOnly , false , "Left/Right to Navigate, X for Back to Menu" , "", "", false , null, null );
		#end
	}

	public override function update(){
		super.update();

		#if !FLX_NO_KEYBOARD
		if(FlxG.keyboard.justPressed("LEFT"))
			UpdateDesc(-1);
		if(FlxG.keyboard.justPressed("RIGHT"))
			UpdateDesc(1);
		if(FlxG.keyboard.justPressed("X"))
			FlxG.switchState(new MainMenu());
		#end
	}

	public override function draw(){
		super.draw();
		images[curId].draw();
	}

	public function UpdateDesc(deltaId:Int=0){
		curId += deltaId;
		while(curId >= titles.length)
			curId -= titles.length;
		while(curId < 0)
			curId += titles.length;

		txtTitle.text = titles[curId];
		txtNum.text = nums[curId];
		txtDesc.text = descs[curId];
	}
}