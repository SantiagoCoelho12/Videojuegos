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
	var max_counter:Float = 6;

	public function new() {
		super();
		collision = new CollisionBox();
		collision.width = 5;
		collision.height = 5;
		collision.userData = this;

		display = new Sprite("bullet");
		display.scaleX = 1;
		display.scaleY = 1;
	}

	override function limboStart() {
		display.removeFromParent();
		collision.removeFromParent();
    }
    
    override function update(dt:Float) {
        counter += dt;
		if (counter > max_counter)
			die();
		collision.update(dt);
		display.x = collision.x;
		display.y = collision.y;

		super.update(dt);
    }

    public function shoot(x:Float, y:Float, dirX:Float, dirY:Float, bulletsCollision:CollisionGroup):Void {
		counter =0;
		collision.x = x;
		collision.y = y;
		collision.velocityX = 1000 * dirX;
		collision.velocityY = 1000 * dirY;
		bulletsCollision.add(collision);
		GGD.simulationLayer.addChild(display);
	}
}
