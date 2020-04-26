package states;

import gameObjects.Bullet;
import com.collision.platformer.ICollider;
import com.collision.platformer.CollisionGroup;
import kha.input.KeyCode;
import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import GlobalGameData.GGD;
import com.loading.basicResources.JoinAtlas;
import com.framework.utils.Input;
import com.gEngine.display.Layer;
import com.gEngine.GEngine;
import com.gEngine.display.Sprite;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;
import com.collision.platformer.CollisionEngine;
import gameObjects.Player;
import gameObjects.Ball;

class GameState extends State {
	var screenWidth:Int;
	var screenHeight:Int;
	var background:Sprite;
	var ship:Player;
	var simulationLayer:Layer;
	var count:Int = 1;
	var touchJoystick:VirtualGamepad;
	var ballsColiision:CollisionGroup;

	override function load(resources:Resources) {
		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		var atlas:JoinAtlas = new JoinAtlas(2048, 2048);
		atlas.add(new ImageLoader("background"));
		atlas.add(new ImageLoader("ship"));
		atlas.add(new ImageLoader("ball"));
		atlas.add(new ImageLoader("bullet"));
		resources.add(atlas);
	}

	override function init() {
		loadBackground();
		ballsColiision = new CollisionGroup();
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		ship = new Player(1024 / 2, 570, simulationLayer);
		addChild(ship);

		GGD.player = ship;
		GGD.simulationLayer = simulationLayer;
		GGD.camera = stage.defaultCamera();

		var ball:Ball = new Ball(simulationLayer, ballsColiision);
		addChild(ball);
		createTouchJoystick();
	}

	override function update(dt:Float) {
		super.update(dt);
		CollisionEngine.overlap(ship.collision, ballsColiision, deathPlayer);
		CollisionEngine.overlap(ship.gun.bulletsCollisions, ballsColiision, ballExplodes);
	}

	override function render() {
		super.render();
	}

	inline function loadBackground() {
		var backgraundLayer = new Layer();
		background = new Sprite("background");
		backgraundLayer.addChild(background);
		stage.addChild(backgraundLayer);
	}

	function createTouchJoystick() {
		touchJoystick = new VirtualGamepad();
		touchJoystick.addKeyButton(XboxJoystick.LEFT_DPAD, KeyCode.Left);
		touchJoystick.addKeyButton(XboxJoystick.RIGHT_DPAD, KeyCode.Right);
		touchJoystick.addKeyButton(XboxJoystick.UP_DPAD, KeyCode.Up);
		touchJoystick.addKeyButton(XboxJoystick.A, KeyCode.Space);
		touchJoystick.notify(ship.onAxisChange, ship.onButtonChange);

		var gamepad = Input.i.getGamepad(0);
		gamepad.notify(ship.onAxisChange, ship.onButtonChange);
	}

	public function ballExplodes(a:ICollider, b:ICollider) {
		var ball:Ball = cast b.userData;
		ball.explode();
		var bullet:Bullet = cast a.userData;
		bullet.die();
		count++;
		for (i in 0...2) {
			var ball:Ball = new Ball(simulationLayer, ballsColiision);
			addChild(ball);
		}
	}

	public function deathPlayer(a:ICollider, b:ICollider) {}

	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera = stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer, camera);
	}
	#end
}
