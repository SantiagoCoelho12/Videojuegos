package gameObjects;

import com.gEngine.display.Layer;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import GlobalGameData.GGD;

class Ball extends Entity {
	var display:Sprite;
    var collision:CollisionBox;

	static inline var vel:Float = 100;

	var collisionGroup:CollisionGroup;

	public function new(layer:Layer, collisions:CollisionGroup) {
		super();
		collisionGroup = collisions;
		display = new Sprite("ball");
		layer.addChild(display);
		display.scaleX = display.scaleY = 0.5;
        collision = new CollisionBox();
        display.offsetX = -65; 
        display.offsetY  =0;
		collision.width = (display.width() * 0.5)-3;
		collision.height = (display.height() * 0.5)-3;
		collision.userData = this;
		collisions.add(collision);
        randomPos();
	}

	override public function update(dt:Float):Void {
        super.update(dt);
        collision.update(dt);
	}

	override function render() {
		super.render();
		display.x = collision.x + collision.width * 0.5;
		display.y = collision.y;
	}

	public function explode():Void {
		collision.removeFromParent();
        collisionGroup.remove(collision);
        display.removeFromParent();
	}

	private function randomPos() {
		collisionGroup.add(collision);
		var target:Player = GGD.player;
		var dirX = 1 - Math.random() * 2;
		var dirY = 1 - Math.random() * 2;
		if (dirX == 0 && dirY == 0) {
			dirX += 1;
		}
		var length = Math.sqrt(dirX * dirX + dirY * dirY);
		collision.x = target.x + 500 * dirX / length;
		collision.y = 0;
	}
}
