package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tweens.misc.ColorTween;

class LineMgr extends FlxSprite
{
	public var heads:Array<FlxSprite>;
	public var line:MyText;
	public var headBg:SliceShape;
	public var lineBg:SliceShape;
	
	public var pressSpace:MyText;
	public var roleName:FlxText;

	public var finishCall:Void->Void;

	private var lines:Array<Line>;
	private var curLineId:Int;
	private var curHeadId:Int;
	private var lineCnt:Int;

	public var isEnd:Bool;

	private static var  headPos:FlxPoint = new FlxPoint(8, 62);
	private var _pressColor:Int;
	private var _pressTween : ColorTween;

	private var _firstFrame : Bool;

	public function new():Void{ 	
		super(0,0,null);

		isEnd = true;

		heads = new Array<FlxSprite>();

		headBg = new SliceShape(0, 50, 90, 90, "assets/img/ui_slice_y.png", SliceShape.MODE_BOX, 5);
		headBg.visible = false;
		headBg.scrollFactor.set(0, 0);

		lineBg = new SliceShape(80, 70, 350, 40, "assets/img/ui_slice_y.png", SliceShape.MODE_BOX, 5);
		lineBg.visible = false;
		lineBg.scrollFactor.set(0, 0);

		line = new MyText(100, 80, FlxG.width - 150, ""); 
		line.setFormat(ResUtil.FNT_Amble, GameStatic.txtSize_dialog, 0x000000);
		line.visible = false;
		line.scrollFactor.set(0, 0);

		var h:FlxSprite;
		h = new FlxSprite(headPos.x,headPos.y);
		h.loadGraphic("assets/img/drHead.png",true, false, 88, 88);
		h.animation.add("default",[1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1], 10, false); 
		h.scrollFactor = new FlxPoint(0,0);
		h.x = headBg.getMidpoint().x - h.width/2; h.y = headBg.getMidpoint().y - h.height/2;
		heads.push(h);
		h = new FlxSprite(headPos.x,headPos.y,"assets/img/botHead.png");h.scrollFactor = new FlxPoint(0,0);
		h.x = headBg.getMidpoint().x - h.width/2; h.y = headBg.getMidpoint().y - h.height/2;
		heads.push(h);
		h = new FlxSprite(headPos.x,headPos.y,"assets/img/rmHead.png");h.scrollFactor = new FlxPoint(0,0);
		h.x = headBg.getMidpoint().x - h.width/2; h.y = headBg.getMidpoint().y - h.height/2;
		heads.push(h);
		
		#if !FLX_NO_TOUCH
		pressSpace = new MyText(100, 94, 400,"PRESS B");
		#else
		pressSpace = new MyText(100, 94, 400,"PRESS X");
		#end
		pressSpace.setFormat(ResUtil.FNT_Pixelex, 8, 0xaa0000, "right");
		pressSpace.visible = false;
		pressSpace.scrollFactor.set(0, 0);

		roleName = new FlxText(0, headBg.y + headBg.height - 13, 90, "");
		roleName.setFormat(ResUtil.FNT_Amble, 8, 0x000000, "center");
		roleName.visible = false;
		roleName.scrollFactor.set(0, 0);

		_pressTween = FlxTween.color(1, 0x000000, 0x666666, 0, 1, {type:FlxTween.PINGPONG, ease:FlxEase.quadInOut});
		_pressTween.start();
	}

	public function Start(lines:Array<Line>, finCall:Void->Void=null):Void{
		this.lines = lines;
		curLineId = -1;
		lineCnt = lines.length;
		finishCall = finCall;
		isEnd = false;
		_firstFrame = true;
		Next();
	}

	public function Next():Void{
		curLineId++;
		if(curLineId <= lineCnt-1){
			line.text = lines[curLineId].text;
			curHeadId = lines[curLineId].headId;
			if(curHeadId == 0)
				heads[0].animation.play("default", true);
			//lineBg.setSize(90 + Math.round(line.text.length * 4), 30);
		}
		else{
			isEnd = true;
			if(finishCall!=null)
				finishCall();
		}
	}

	public function Skip(){
		isEnd = true;
	}

	override public function update(){
		if(_firstFrame){
			_firstFrame = false;
			return;
		}

		if(!isEnd && cast(FlxG.state, Level).input.JustDown_Jump){
			Next();
			// eat key event
			cast(FlxG.state, Level).input.Jump = false;
		}
		for (hd in heads)
			hd.animation.update();

		_pressColor = _pressTween.color;
		super.update();
	}

	override public function draw(){
		if(!isEnd){
			//var newWidth = 20 + Math.round(line.text.length * 6 * GameStatic.screenDensity);
			var newWidth:Int = 30 + line.GetTextWidth();
			if(newWidth < 180) newWidth = 180;
			if(newWidth > FlxG.width - 90)	newWidth = FlxG.width - 90;
			lineBg.setSize(newWidth, 25 + line.GetTextHeight() + pressSpace.GetTextHeight());
			pressSpace.setFormat(ResUtil.FNT_Pixelex, GameStatic.txtSize_menuButton, _pressColor, "right");
			pressSpace.x = lineBg.x + lineBg.width - 3 - pressSpace.width;
			pressSpace.y = lineBg.y + lineBg.height - pressSpace.GetTextHeight() - 4;
			switch(curHeadId){
				case 0:
					roleName.text = "Dr.Cube";
				case 1:
					roleName.text = "CubeBot";
				case 2:
					roleName.text = "RageMetal";
			}
			
			lineBg.draw();
			headBg.draw();
			line.draw();
			heads[curHeadId].draw();
			pressSpace.draw();
			roleName.draw();
		}
		super.draw();
	}
}