package gameObjects;

import com.gEngine.helper.Screen;
import kha.math.FastVector2;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import GlobalGameData.GGD;

class Ball extends Entity {
	private static inline var RADIO = 120;
	private static inline var GROUND_LIMIT= 80;
	var display:Sprite;
    var collision:CollisionBox;
	var collisionGroup:CollisionGroup;
	var screenWidth:Int;
	var screenHeight:Int;
	var velocity:FastVector2;

	public function new(layer:Layer, collisions:CollisionGroup) {
		super();
		screenHeight = Screen.getHeight();
		screenWidth = Screen.getWidth();
		velocity = new FastVector2(130,130);
		collisionGroup = collisions;
		display = new Sprite("ball");
        collision = new CollisionBox();
		layer.addChild(display);
        setCollisionsAnddisplay();
		collisions.add(collision);
        randomPos();
	}

	override public function update(dt:Float):Void {
		super.update(dt);
		collision.x += velocity.x*dt;
		collision.y += velocity.y*dt;
		if(collision.x < 0 || collision.x+RADIO > screenWidth){
            velocity.x *= -1;
		}

		if(collision.y+RADIO > screenHeight-GROUND_LIMIT || collision.y < 0){
            velocity.y *= -1;
		}
		
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

	private inline function setCollisionsAnddisplay() {
		display.scaleX = display.scaleY = 0.5;
		display.offsetX = -65; 
        display.offsetY  =0;
		collision.width = (display.width() * 0.5)-3;
		collision.height = (display.height() * 0.5)-3;
		collision.userData = this;
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
