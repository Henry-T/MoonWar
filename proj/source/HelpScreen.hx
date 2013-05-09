package;
import org.flixel.FlxSprite;
import nme.display.BitmapData;
import org.flixel.FlxButton;
import org.flixel.FlxText;
import org.flixel.FlxG;

class HelpScreen extends MWState
{
	public var bg:FlxSprite;

	public var mainPnl:SliceShape;
	public var bottomPnl:SliceShape;
	public var btnGBigNormal:BitmapData;
	public var btnGBigOver:BitmapData;
	public var btnBack:FlxButton;
	public var btnLast:FlxButton;
	public var btnNext:FlxButton;

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
			"Press z to Jump Up   Hold Arrow Down and Press z to Jump Down",
			"Press x to Shoot   Combining with Arrow keys to Shoot At Different Directoins",
			"Use x to Talk, Trigger console and Enter Lift",
			"When In Low Health, Grub the Blue Cage to Get Repaired"
		];
	}

	override public function create():Void 
	{
		super.create();

		curId = 0;

		images = new Array<FlxSprite>();
		for (i in 0...titles.length) {
			var img:FlxSprite = new FlxSprite("assets/img/help" + i + ".png");
			img.x = FlxG.width * 0.5 - img.width *0.5;
			img.y = FlxG.height * 0.4 - img.height * 0.5;
			images.push(img);
		}

		bg = new FlxSprite("assets/img/bgStar.png");
		mainPnl = new SliceShape(0,0, 350, 280, "assets/img/ui_box_y.png", SliceShape.MODE_BOX, 3);
		mainPnl.x = FlxG.width*0.5 - mainPnl.width*0.5;
		mainPnl.y = FlxG.height*0.4 - mainPnl.height*0.5;

		bottomPnl = new SliceShape(-5, FlxG.height-50, FlxG.width + 10, 40, "assets/img/ui_barh_y.png", SliceShape.MODE_HERT, 1);
		btnGBigNormal = new SliceShape(0,0, 100, 25, "assets/img/ui_box_y.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnGBigOver = new SliceShape(0,0, 100, 25, "assets/img/ui_boxact_y.png", SliceShape.MODE_BOX, 3).pixels.clone();
		btnBack = new FlxButton(0, 0, "BACK", function() { FlxG.switchState(new MainMenu()); } );
		btnBack.loadGraphic(btnGBigNormal);
		btnBack.onOver = function(){btnBack.loadGraphic(btnGBigOver);};
		btnBack.onOut = function(){btnBack.loadGraphic(btnGBigNormal);};
		btnBack.x = FlxG.width * 0.5 - btnBack.width/2;
		btnBack.y = FlxG.height * 0.90;
		btnBack.label.setFormat("assets/fnt/pixelex.ttf", 16, 0xffffff, "center");

		btnLast = new FlxButton(0, 0, "LAST", function() {UpdateDesc(-1);} );
		btnLast.loadGraphic(btnGBigNormal);
		btnLast.onOver = function(){btnLast.loadGraphic(btnGBigOver);};
		btnLast.onOut = function(){btnLast.loadGraphic(btnGBigNormal);};
		btnLast.x = 20;
		btnLast.y = FlxG.height * 0.90;
		btnLast.label.setFormat("assets/fnt/pixelex.ttf", 16, 0xffffff, "center");

		btnNext= new FlxButton(0, 0, "NEXT", function() {UpdateDesc(1);} );
		btnNext.loadGraphic(btnGBigNormal);
		btnNext.onOver = function(){btnNext.loadGraphic(btnGBigOver);};
		btnNext.onOut = function(){btnNext.loadGraphic(btnGBigNormal);};
		btnNext.x = FlxG.width - btnNext.width - 20;
		btnNext.y = FlxG.height * 0.90;
		btnNext.label.setFormat("assets/fnt/pixelex.ttf", 16, 0xffffff, "center");

		txtCreated = new FlxText(0,0,120, "Created By");
		txtCreated.setFormat("assets/fnt/pixelex.ttf", 10, 0xffdddddd, "right");
		txtCreated.x = FlxG.width * 0.5 - txtCreated.width - 10;
		txtCreated.y = FlxG.height * 0.5 - 50;

		txtCreatedBy = new FlxText(0,0,120, "Lolofinil");
		txtCreatedBy.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "left");
		txtCreatedBy.x = FlxG.width * 0.5 + 10;
		txtCreatedBy.y = FlxG.height * 0.5 - 50;

		txtMusic = new FlxText(0,0,120, "Music By");
		txtMusic.setFormat("assets/fnt/pixelex.ttf", 10, 0xffdddddd, "right");
		txtMusic.x = FlxG.width * 0.5 - txtMusic.width - 10;
		txtMusic.y = FlxG.height * 0.5 + 50;

		txtMusicBy = new FlxText(0,0, 150, "www.nosoapradio.us");
		txtMusicBy.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "left");
		txtMusicBy.x = FlxG.width * 0.5 + 10;
		txtMusicBy.y = FlxG.height * 0.5 + 50;

		txtTitle = new FlxText(0, FlxG.height * 0.06, FlxG.width, "Title");
		txtTitle.setFormat("assets/fnt/pixelex.ttf", 15, 0xffffffff, "center");

		txtNum = new FlxText(0, FlxG.height * 0.1, FlxG.width, "Num");
		txtNum.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "center");

		txtDesc = new FlxText(0, FlxG.height * 0.8, FlxG.width, "Desc");
		txtDesc.setFormat("assets/fnt/pixelex.ttf", 10, 0xffffffff, "center");

		add(bg);
		add(mainPnl);
		//add(txtCreated);
		//add(txtCreatedBy);
		//add(txtMusic);
		//add(txtMusicBy);
		add(bottomPnl);
		add(btnBack);
		add(btnLast);
		add(btnNext);
		add(txtTitle);
		add(txtNum);
		add(txtDesc);

		UpdateDesc();
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