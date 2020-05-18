package gameObjects;

import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;

class Gun extends Entity {
	public var bulletsCollisions:CollisionGroup;

	var bullet:Bullet;

	public function new() {
		super();
		pool = true;
		bulletsCollisions = new CollisionGroup();
	}

	public function shoot(aX:Float, aY:Float, dirX:Float, dirY:Float):Void {
		bullet = cast recycle(Bullet);
		bullet.shoot(aX, aY, dirX, dirY, bulletsCollisions);
	}

	public function reset() {
		bullet = null;
		bullet = cast recycle(Bullet);
	}
}
