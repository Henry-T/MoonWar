package ;

import Xml;

class EnemyGroup 
{
public var timeSpan:Float;	// Time Span before this enemy group added
public var enemyDatas:Array<EnemyData>;

public function new(data:Xml) 
{
	timeSpan = Std.parseFloat(data.get("span"));
	enemyDatas = new Array<EnemyData>();

	for (e in data.elementsNamed("EnemyData")) {
		enemyDatas.push(new EnemyData(e));
	}
}

}