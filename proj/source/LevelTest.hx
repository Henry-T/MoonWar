package;

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
	}

	public override function update(){
		super.update();
	}

	public override function draw(){
		super.draw();
	}
}