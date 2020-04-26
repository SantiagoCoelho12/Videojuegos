package gameObjects;

import com.gEngine.display.Sprite;
import GlobalGameData.GGD;
import com.collision.platformer.CollisionGroup;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Bullet extends Entity {
	public var collision:CollisionBox;

	var display:Sprite;
	var counter:Float;
	var MAX_COUNTER:Float = 6;
	var BALL_VELOCITY:Float = 700;

	public function new() {
		super();

		display = new Sprite("bullet");
		collision = new CollisionBox();
		collision.width = 27;
		collision.height = 40;

		collision.userData = this;

		display.scaleX = 1;
		display.scaleY = 1;
		display.offsetX = -4;
		display.offsetY = -10;
	}

	override function limboStart() {
		display.removeFromParent();
		collision.removeFromParent();
	}

	override function update(dt:Float) {
		counter += dt;
		if (counter > MAX_COUNTER)
			die();
		collision.update(dt);
		display.x = collision.x;
		display.y = collision.y;

		super.update(dt);
	}

	public function shoot(x:Float, y:Float, dirX:Float, dirY:Float, bulletsCollision:CollisionGroup):Void {
		counter = 0;
		collision.x = x;
		collision.y = y;
		collision.velocityX = BALL_VELOCITY * dirX;
		collision.velocityY = BALL_VELOCITY * dirY;
		bulletsCollision.add(collision);
		GGD.simulationLayer.addChild(display);
	}
}
