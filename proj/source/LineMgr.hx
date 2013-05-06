package;

import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxG;
import org.flixel.FlxPoint;

class LineMgr extends FlxSprite
{
	public var heads:Array<FlxSprite>;
	public var line:FlxText;
	public var headBg:SliceShape;
	public var lineBg:SliceShape;
	
	public var pressSpace:FlxText;
	public var roleName:FlxText;

	public var finishCall:Void->Void;

	private var lines:Array<Line>;
	private var curLineId:Int;
	private var curHeadId:Int;
	private var lineCnt:Int;

	private var isEnd:Bool;

	private static var  headPos:FlxPoint = new FlxPoint(8, 62);

	public function new():Void{ 	
		super(0,0,null);

		isEnd = true;

		heads = new Array<FlxSprite>();

		headBg = new SliceShape(0, 50, 90, 90, "assets/img/ui_slice_y.png", SliceShape.MODE_BOX, 5);
		headBg.visible = false;
		headBg.scrollFactor.make(0, 0);

		lineBg = new SliceShape(10, 70, 350, 40, "assets/img/ui_slice_y.png", SliceShape.MODE_BOX, 5);
		lineBg.visible = false;
		lineBg.scrollFactor.make(0, 0);

		line = new FlxText(100, 80, 400, ""); 
		line.setFormat("assets/fnt/pixelex.ttf", 8, 0xff000000);
		line.visible = false;
		line.scrollFactor.make(0, 0);

		var h:FlxSprite;
		h = new FlxSprite(headPos.x,headPos.y);
		h.loadGraphic("assets/img/drHead.png",true, false, 88, 88);
		h.addAnimation("default",[1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1], 10, false); 
		h.scrollFactor = new FlxPoint(0,0);
		h.x = headBg.getMidpoint().x - h.width/2; h.y = headBg.getMidpoint().y - h.height/2;
		heads.push(h);
		h = new FlxSprite(headPos.x,headPos.y,"assets/img/botHead.png");h.scrollFactor = new FlxPoint(0,0);
		h.x = headBg.getMidpoint().x - h.width/2; h.y = headBg.getMidpoint().y - h.height/2;
		heads.push(h);
		h = new FlxSprite(headPos.x,headPos.y,"assets/img/rmHead.png");h.scrollFactor = new FlxPoint(0,0);
		h.x = headBg.getMidpoint().x - h.width/2; h.y = headBg.getMidpoint().y - h.height/2;
		heads.push(h);
		
		pressSpace = new FlxText(100, 94, 80,"PRESS SPACE");
		pressSpace.setFormat("assets/fnt/pixelex.ttf", 8, 0xffffffff);
		pressSpace.visible = false;
		pressSpace.scrollFactor.make(0, 0);

		roleName = new FlxText(0, headBg.y + headBg.height - 13, 90, "");
		roleName.setFormat("assets/fnt/pixelex.ttf", 8, 0xff000000, "center");
		roleName.visible = false;
		roleName.scrollFactor.make(0, 0);
	}

	public function Start(lines:Array<Line>, finCall:Void->Void=null):Void{
		this.lines = lines;
		curLineId = -1;
		lineCnt = lines.length;
		finishCall = finCall;
		isEnd = false;
		Next();
	}

	public function Next():Void{
		curLineId++;
		if(curLineId <= lineCnt-1){
			line.text = lines[curLineId].text;
			curHeadId = lines[curLineId].headId;
			if(curHeadId == 0)
				heads[0].play("default", true);
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
		if(!isEnd && cast(FlxG.state, Level).input.JustDown_Action){
			Next();
		}
		for (hd in heads)
			hd.updateAnimation();

		super.update();
	}

	override public function draw(){
		if(!isEnd){
			var newWidth = 120 + Math.round(line.text.length * 6);
			if(newWidth < 180) newWidth = 180;
			lineBg.setSize(newWidth, 40);
			pressSpace.x = lineBg.x + lineBg.width - 3 - pressSpace.width;
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