package ;

class EnemyData 
{
public var Type:String;
public var CamX:Float;
public var CamY:Float;

public function new(data:Xml) 
{
	Type = data.get("type");
	CamX = Std.parseFloat(data.get("camX"));
	CamY = Std.parseFloat(data.get("camY"));
}

}