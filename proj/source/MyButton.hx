package ;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxPoint;

class MyButton extends FlxButton {
	public function new(X:Float = 0, Y:Float = 0, Label:String = null, OnClick:Void->Void = null){
		super(X, Y, Label, OnClick);
		if(Label != null)
		{
			label = new FlxText(0, 0, 200, Label);
			label.setFormat(null, 8, 0x333333, "center");
			labelOffset = new FlxPoint( -1, 3);
		}
	}
}