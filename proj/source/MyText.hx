package ;

import org.flixel.FlxText;
import flash.text.TextField;

class MyText extends FlxText {
	public function GetTextWidth():Int{
		return Std.int(_textField.textWidth);
	}

	public function GetTextHeight():Int{
		return Std.int(_textField.textHeight);
	}

}