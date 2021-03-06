// Generated by Haxe 3.4.7
(function ($global) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Collidable = function() { };
Collidable.__name__ = true;
Collidable.prototype = {
	__class__: Collidable
};
var Drawable = function() { };
Drawable.__name__ = true;
Drawable.prototype = {
	__class__: Drawable
};
var Box = function(position,width,height,angle,color) {
	this.color = "";
	this.angle = 0.0;
	this.height = 0.0;
	this.width = 0.0;
	this.position = new Vector(0,0);
	this.position = position;
	this.width = width;
	this.height = height;
	this.angle = angle;
	this.color = color;
};
Box.__name__ = true;
Box.__interfaces__ = [Collidable,Drawable];
Box.prototype = {
	draw: function(context) {
		context.save();
		context.translate(this.position.x,this.position.y);
		context.rotate(this.angle);
		context.fillStyle = this.color;
		context.fillRect(-0.5 * this.width,-0.5 * this.height,this.width,this.height);
		context.restore();
	}
	,getCollisionBox: function() {
		return this;
	}
	,__class__: Box
};
var CarAction = { __ename__ : true, __constructs__ : ["Forward","Reverse","Right","Left"] };
CarAction.Forward = ["Forward",0];
CarAction.Forward.__enum__ = CarAction;
CarAction.Reverse = ["Reverse",1];
CarAction.Reverse.__enum__ = CarAction;
CarAction.Right = ["Right",2];
CarAction.Right.__enum__ = CarAction;
CarAction.Left = ["Left",3];
CarAction.Left.__enum__ = CarAction;
var Car = function() {
	this.progress = 0;
	this.lap = 0;
	this.nameColor = "";
	this.name = "";
	this.color = "";
	this.frictionFactor = 0.048;
	this.turnAngle = 0.0;
	this.turnSpeed = 0.01;
	this.reverseAcceleration = 0.3;
	this.forwardAcceleration = 0.5;
	this.baseReverseAcceleration = 0.3;
	this.baseForwardAcceleration = 0.5;
	this.velocity = new Vector(0,0);
	this.angle = 0 * Math.PI;
	this.lengthWheels = 8;
	this.widthWheels = 4;
	this.length = 40;
	this.width = 24;
	this.position = new Vector(0,0);
};
Car.__name__ = true;
Car.prototype = {
	draw: function(context) {
		context.save();
		context.translate(this.position.x,this.position.y);
		context.rotate(this.angle);
		this.drawWheel(context,-0.3 * this.length,-0.5 * this.width,0);
		this.drawWheel(context,-0.3 * this.length,0.5 * this.width,0);
		this.drawWheel(context,0.3 * this.length,-0.5 * this.width,this.turnAngle);
		this.drawWheel(context,0.3 * this.length,0.5 * this.width,this.turnAngle);
		context.fillStyle = this.color;
		context.fillRect(-0.5 * this.length,-0.5 * this.width,this.length,this.width);
		context.fillStyle = this.nameColor;
		context.font = "16px Arial";
		context.textAlign = "center";
		context.textBaseline = "middle";
		context.fillText(Std.string(this.lap),0,1,38);
		context.restore();
	}
	,drawWheel: function(context,x,y,angle) {
		context.save();
		context.translate(x,y);
		context.rotate(angle);
		context.fillStyle = "black";
		context.fillRect(-0.5 * this.lengthWheels,-0.5 * this.widthWheels,this.lengthWheels,this.widthWheels);
		context.restore();
	}
	,updatePosition: function() {
		this.position = this.position.add(this.velocity);
	}
	,controlInput: function(actions) {
		this.turnAngle = 0;
		var _g = 0;
		while(_g < actions.length) {
			var action = actions[_g];
			++_g;
			this.handleAction(action);
		}
	}
	,handleAction: function(action) {
		if(action == CarAction.Forward) {
			this.forward();
		}
		if(action == CarAction.Reverse) {
			this.reverse();
		}
		if(action == CarAction.Left) {
			this.left();
		}
		if(action == CarAction.Right) {
			this.right();
		}
	}
	,forward: function() {
		this.velocity = this.velocity.add(Vector.fromAngle(this.angle).multiply(this.forwardAcceleration));
	}
	,reverse: function() {
		var accelerationVector = Vector.fromAngle(this.angle + Math.PI).multiply(this.reverseAcceleration);
		this.velocity = this.velocity.add(accelerationVector);
	}
	,left: function() {
		this.turnAngle -= 0.3;
		this.turn(-1);
	}
	,right: function() {
		this.turnAngle += 0.3;
		this.turn(1);
	}
	,turn: function(direction) {
		var relativeVelocity = this.getRelativeVelocity();
		if(relativeVelocity.x > 0) {
			this.angle += this.turnSpeed * direction * this.velocity.length();
		}
		if(relativeVelocity.x < 0) {
			this.angle -= this.turnSpeed * direction * this.velocity.length();
		}
		this.velocity = Vector.fromAngle(this.angle).multiply(relativeVelocity.x);
	}
	,applyFriction: function() {
		var friction = this.velocity.length() * this.frictionFactor;
		this.forwardAcceleration = this.baseForwardAcceleration - friction;
		this.reverseAcceleration = this.baseReverseAcceleration - friction;
		this.velocity = this.velocity.subtract(this.velocity.unityVector().multiply(friction));
		if(this.velocity.length() < friction) {
			this.velocity = new Vector(0,0);
		}
	}
	,getRelativeVelocity: function() {
		if(this.velocity.length() == 0) {
			return new Vector(0,0);
		}
		var temp = this.velocity.scalarProduct(Vector.fromAngle(this.angle)) / this.velocity.length();
		if(temp > 1) {
			temp = 1;
		}
		if(temp < -1) {
			temp = -1;
		}
		var relativeVelocity = Vector.fromAngle(Math.acos(temp)).multiply(this.velocity.length());
		if(isNaN(relativeVelocity.x)) {
			console.log("x: " + this.velocity.x + " y: " + this.velocity.y);
			console.log(temp);
		}
		return relativeVelocity;
	}
	,__class__: Car
};
var Checkpoint = function(position,width,height,angle,number,last) {
	this.last = false;
	Box.call(this,position,width,height,angle,"#0c9b7c");
	this.number = number;
	this.last = last;
	if(number == 0) {
		this.color = "yellow";
	}
};
Checkpoint.__name__ = true;
Checkpoint.__super__ = Box;
Checkpoint.prototype = $extend(Box.prototype,{
	__class__: Checkpoint
});
var Collision = function() { };
Collision.__name__ = true;
Collision.collidesWith = function(point,collider) {
	var box = collider.getCollisionBox();
	if(box == null) {
		return false;
	}
	var newVector = box.position.subtract(point).turnAngle(-box.angle);
	if(Math.abs(newVector.x) <= 0.5 * box.width && Math.abs(newVector.y) <= 0.5 * box.height) {
		return true;
	} else {
		return false;
	}
};
var CompoundBox = function() {
	this.boxList = [];
	this.angle = 0.0;
	this.position = new Vector(0,0);
};
CompoundBox.__name__ = true;
CompoundBox.__interfaces__ = [Collidable,Drawable];
CompoundBox.prototype = {
	draw: function(context) {
		context.save();
		context.translate(this.position.x,this.position.y);
		context.rotate(this.angle);
		var _g = 0;
		var _g1 = this.boxList;
		while(_g < _g1.length) {
			var box = _g1[_g];
			++_g;
			box.draw(context);
		}
		context.restore();
	}
	,getCollisionBox: function() {
		return this.collisionBox;
	}
	,addCollisionBox: function(box) {
		box.position = this.position.add(box.position.turnAngle(this.angle));
		box.angle += this.angle;
		this.collisionBox = box;
	}
	,__class__: CompoundBox
};
var Terrain = { __ename__ : true, __constructs__ : ["Grass","Road"] };
Terrain.Grass = ["Grass",0];
Terrain.Grass.__enum__ = Terrain;
Terrain.Road = ["Road",1];
Terrain.Road.__enum__ = Terrain;
var Environment = function() {
	this.startPositions = [];
	this.objects = [];
};
Environment.__name__ = true;
Environment.prototype = {
	draw: function(context) {
		var _g = 0;
		var _g1 = this.objects;
		while(_g < _g1.length) {
			var object = _g1[_g];
			++_g;
			object.draw(context);
		}
	}
	,__class__: Environment
};
var Game = function(canvas,context,pressedKeys) {
	this.environments = [];
	this.cars = [];
	this.pressedKeys = new haxe_ds_StringMap();
	this.canvas = canvas;
	this.context = context;
	this.pressedKeys = pressedKeys;
	var car = new Car();
	car.color = "#800000";
	car.name = "Car1";
	car.nameColor = "black";
	this.cars.push(car);
	car = new Car();
	car.color = "#434ea1";
	car.name = "Car2";
	car.nameColor = "black";
	this.cars.push(car);
	this.addEnvironments();
	this.changeEnvironment(this.environments[0]);
};
Game.__name__ = true;
Game.prototype = {
	addEnvironments: function() {
		var environment = new Environment();
		environment.startPositions.push(new Vector(-24,-20));
		environment.startPositions.push(new Vector(-24,20));
		environment.objects.push(Road.buildRoad(new Vector(0,0),1000,0 * Math.PI));
		environment.objects.push(Road.buildRoad(new Vector(550,150),200,0.5 * Math.PI));
		environment.objects.push(Road.buildRoad(new Vector(0,300),1000,0 * Math.PI));
		environment.objects.push(Road.buildRoad(new Vector(-550,150),200,0.5 * Math.PI));
		environment.objects.push(Road.buildRoadCorner(new Vector(550,0),1.5 * Math.PI));
		environment.objects.push(Road.buildRoadCorner(new Vector(550,300),0 * Math.PI));
		environment.objects.push(Road.buildRoadCorner(new Vector(-550,300),0.5 * Math.PI));
		environment.objects.push(Road.buildRoadCorner(new Vector(-550,0),Math.PI));
		environment.objects.push(new Checkpoint(new Vector(0,0),12,90,0 * Math.PI,0,false));
		environment.objects.push(new Checkpoint(new Vector(450,0),12,90,0 * Math.PI,1,false));
		environment.objects.push(new Checkpoint(new Vector(450,300),12,90,0 * Math.PI,2,false));
		environment.objects.push(new Checkpoint(new Vector(-450,300),12,90,0 * Math.PI,3,false));
		environment.objects.push(new Checkpoint(new Vector(-450,0),12,90,0 * Math.PI,4,true));
		this.environments.push(environment);
		environment = new Environment();
		environment.startPositions.push(new Vector(-24,-20));
		environment.startPositions.push(new Vector(-24,20));
		environment.objects.push(Road.buildRoad(new Vector(0,0),600,0 * Math.PI));
		environment.objects.push(Road.buildRoad(new Vector(350,350),600,0.5 * Math.PI));
		environment.objects.push(Road.buildRoad(new Vector(0,700),600,0 * Math.PI));
		environment.objects.push(Road.buildRoad(new Vector(-350,350),600,0.5 * Math.PI));
		environment.objects.push(Road.buildRoad(new Vector(-350,-350),600,0.5 * Math.PI));
		environment.objects.push(Road.buildRoad(new Vector(-700,-700),600,0 * Math.PI));
		environment.objects.push(Road.buildRoad(new Vector(-1050,-350),600,0.5 * Math.PI));
		environment.objects.push(Road.buildRoad(new Vector(-700,0),600,0 * Math.PI));
		environment.objects.push(Road.buildRoadCorner(new Vector(350,0),1.5 * Math.PI));
		environment.objects.push(Road.buildRoadCorner(new Vector(350,700),0 * Math.PI));
		environment.objects.push(Road.buildRoadCorner(new Vector(-350,700),0.5 * Math.PI));
		environment.objects.push(Road.buildRoadCorner(new Vector(-350,-700),1.5 * Math.PI));
		environment.objects.push(Road.buildRoadCorner(new Vector(-1050,-700),Math.PI));
		environment.objects.push(Road.buildRoadCorner(new Vector(-1050,0),0.5 * Math.PI));
		environment.objects.push(Road.buildCrossroads(new Vector(-350,0),0 * Math.PI));
		environment.objects.push(new Checkpoint(new Vector(0,0),12,90,0 * Math.PI,0,false));
		environment.objects.push(new Checkpoint(new Vector(350,350),12,90,0.5 * Math.PI,1,false));
		environment.objects.push(new Checkpoint(new Vector(0,700),12,90,0 * Math.PI,2,false));
		environment.objects.push(new Checkpoint(new Vector(-350,350),12,90,0.5 * Math.PI,3,false));
		environment.objects.push(new Checkpoint(new Vector(-350,-350),12,90,0.5 * Math.PI,4,false));
		environment.objects.push(new Checkpoint(new Vector(-700,-700),12,90,0 * Math.PI,5,false));
		environment.objects.push(new Checkpoint(new Vector(-1050,-350),12,90,0.5 * Math.PI,6,false));
		environment.objects.push(new Checkpoint(new Vector(-700,0),12,90,0 * Math.PI,7,true));
		this.environments.push(environment);
	}
	,changeEnvironment: function(environment) {
		this.currentEnvironment = environment;
		var n = 0;
		var _g = 0;
		var _g1 = this.cars;
		while(_g < _g1.length) {
			var car = _g1[_g];
			++_g;
			car.lap = 0;
			car.progress = 0;
			car.velocity = new Vector(0,0);
			car.position = this.currentEnvironment.startPositions[n];
			car.angle = 0;
			++n;
			if(n >= this.currentEnvironment.startPositions.length) {
				n = 0;
			}
		}
	}
	,controlCar: function(car,up,left,down,right) {
		var actions = [];
		var _this = this.pressedKeys;
		if(__map_reserved[up] != null ? _this.getReserved(up) : _this.h[up]) {
			actions.push(CarAction.Forward);
		}
		var _this1 = this.pressedKeys;
		if(__map_reserved[down] != null ? _this1.getReserved(down) : _this1.h[down]) {
			actions.push(CarAction.Reverse);
		}
		var _this2 = this.pressedKeys;
		if(__map_reserved[left] != null ? _this2.getReserved(left) : _this2.h[left]) {
			actions.push(CarAction.Left);
		}
		var _this3 = this.pressedKeys;
		if(__map_reserved[right] != null ? _this3.getReserved(right) : _this3.h[right]) {
			actions.push(CarAction.Right);
		}
		car.controlInput(actions);
	}
	,calculateScaleFactor: function() {
		var carDistance = this.cars[0].position.subtract(this.cars[1].position);
		var scaleFactor = 1.0;
		var scaleHorisontal = 1.0;
		var scaleVertical = 1.0;
		if(Math.abs(carDistance.y) >= this.canvas.height - 50) {
			scaleVertical = (this.canvas.height - 50) / Math.abs(carDistance.y);
		}
		if(Math.abs(carDistance.x) >= this.canvas.width - 50) {
			scaleHorisontal = (this.canvas.width - 50) / Math.abs(carDistance.x);
		}
		scaleFactor = Math.min(scaleHorisontal,scaleVertical);
		return scaleFactor;
	}
	,getCollidingObjects: function(point) {
		var collidingObjects = [];
		var _g = 0;
		var _g1 = this.currentEnvironment.objects;
		while(_g < _g1.length) {
			var object = _g1[_g];
			++_g;
			if(js_Boot.__instanceof(object,Collidable)) {
				if(Collision.collidesWith(point,js_Boot.__cast(object , Collidable))) {
					collidingObjects.push(object);
				}
			}
		}
		return collidingObjects;
	}
	,handleRoadCollision: function(car) {
		car.frictionFactor = 0.032;
	}
	,handleCheckpointCollision: function(car,checkpoint) {
		if(checkpoint.number == car.progress && checkpoint.last) {
			car.progress = 0;
		} else if(checkpoint.number == car.progress) {
			car.progress += 1;
			if(car.progress == 1) {
				car.lap += 1;
			}
		}
	}
	,handleCollisions: function(car) {
		var _g = 0;
		var _g1 = this.getCollidingObjects(car.position);
		while(_g < _g1.length) {
			var object = _g1[_g];
			++_g;
			if(js_Boot.__instanceof(object,Checkpoint)) {
				this.handleCheckpointCollision(car,js_Boot.__cast(object , Checkpoint));
			}
			if(js_Boot.__instanceof(object,Road)) {
				this.handleRoadCollision(car);
			}
		}
	}
	,processCar: function(car,up,left,down,right) {
		this.controlCar(car,up,left,down,right);
		car.frictionFactor = 0.048;
		this.handleCollisions(car);
		car.applyFriction();
		car.updatePosition();
	}
	,gameLoop: function() {
		this.processCar(this.cars[0],"ArrowUp","ArrowLeft","ArrowDown","ArrowRight");
		this.processCar(this.cars[1],"w","a","s","d");
		this.context.clearRect(0,0,this.canvas.width,this.canvas.height);
		this.context.save();
		var scaleFactor = this.calculateScaleFactor();
		var focusPoint = this.cars[0].position.add(this.cars[1].position).divide(2 / scaleFactor);
		var midPoint = new Vector(0.5 * this.canvas.width,0.5 * this.canvas.height);
		this.context.translate(midPoint.x - focusPoint.x,midPoint.y - focusPoint.y);
		this.context.scale(scaleFactor,scaleFactor);
		this.currentEnvironment.draw(this.context);
		var _g = 0;
		var _g1 = this.cars;
		while(_g < _g1.length) {
			var car = _g1[_g];
			++_g;
			car.draw(this.context);
		}
		this.context.restore();
	}
	,__class__: Game
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var menuScreen = new MenuScreen();
	var canvas = window.document.createElement("canvas");
	var context = canvas.getContext("2d",null);
	context.fillRect(345,5,657,123);
	window.document.body.appendChild(canvas);
	canvas.width = window.innerWidth;
	canvas.height = window.innerHeight;
	canvas.style.backgroundColor = "olivedrab";
	window.onresize = function() {
		canvas.width = window.innerWidth;
		canvas.height = window.innerHeight;
	};
	var pressedKeys = new haxe_ds_StringMap();
	window.addEventListener("keyup",function(event) {
		var k = event.key;
		if(__map_reserved[k] != null) {
			pressedKeys.setReserved(k,false);
		} else {
			pressedKeys.h[k] = false;
		}
	});
	window.addEventListener("keydown",function(event1) {
		var k1 = event1.key;
		if(__map_reserved[k1] != null) {
			pressedKeys.setReserved(k1,true);
		} else {
			pressedKeys.h[k1] = true;
		}
	});
	window.addEventListener("keypress",function(event2) {
		if(event2.key == "Escape") {
			menuScreen.show();
		}
	});
	var game = new Game(canvas,context,pressedKeys);
	menuScreen.addButton("Map 1",function() {
		game.changeEnvironment(game.environments[0]);
		menuScreen.hide();
	});
	menuScreen.addButton("Map 2",function() {
		game.changeEnvironment(game.environments[1]);
		menuScreen.hide();
	});
	new haxe_Timer(30).run = $bind(game,game.gameLoop);
};
Math.__name__ = true;
var MenuScreen = function() {
	this.root = window.document.createElement("div");
	var _gthis = this;
	window.document.body.appendChild(this.root);
	this.root.style.position = "absolute";
	this.root.style.width = "100vw";
	this.root.style.height = "100vh";
	this.root.style.backgroundColor = "#654321";
	this.root.style.display = "";
	var title = window.document.createElement("div");
	title.innerText = "BILSPILLET";
	title.style.textAlign = "center";
	title.style.fontSize = "64px";
	title.style.fontWeight = "bold";
	title.style.marginTop = "10vh";
	this.root.appendChild(title);
	this.addButton("Start spil",function() {
		if(_gthis.root.style.display == "") {
			_gthis.hide();
		}
	});
};
MenuScreen.__name__ = true;
MenuScreen.prototype = {
	show: function() {
		this.root.style.display = "";
	}
	,hide: function() {
		this.root.style.display = "none";
	}
	,addButton: function(title,callback) {
		var button = window.document.createElement("button");
		button.innerText = title;
		button.onclick = callback;
		button.style.padding = "4px";
		button.style.margin = "8px";
		button.style.backgroundColor = "#606665";
		this.root.appendChild(button);
	}
	,__class__: MenuScreen
};
var Road = function() {
	CompoundBox.call(this);
};
Road.__name__ = true;
Road.buildRoad = function(position,length,angle,width) {
	if(width == null) {
		width = 100.0;
	}
	var road = new Road();
	road.position = position;
	road.angle = angle;
	road.boxList.push(new Box(new Vector(0,0),length,width,0,"#505554"));
	road.boxList.push(new Box(new Vector(0,0),length,width - 10,0,"#606665"));
	road.addCollisionBox(new Box(new Vector(0,0),length,width,0,"#505554"));
	return road;
};
Road.buildRoadCorner = function(position,angle,length,width) {
	if(width == null) {
		width = 100.0;
	}
	if(length == null) {
		length = 100.0;
	}
	var road = new Road();
	road.position = position;
	road.angle = angle;
	road.boxList.push(new Box(new Vector(0,0),length,width,0,"#505554"));
	road.boxList.push(new Box(new Vector(-2.5,-2.5),length - 5,width - 5,0,"#606665"));
	road.boxList.push(new Box(new Vector(-0.5 * length + 2.5,-0.5 * width + 2.5),5,5,0,"#505554"));
	road.addCollisionBox(new Box(new Vector(0,0),length,width,0,"#505554"));
	return road;
};
Road.buildCrossroads = function(position,angle,length,width) {
	if(width == null) {
		width = 100.0;
	}
	if(length == null) {
		length = 100.0;
	}
	var road = new Road();
	road.position = position;
	road.angle = angle;
	road.boxList.push(new Box(new Vector(0,0),length,width,0,"#606665"));
	road.boxList.push(new Box(new Vector(0.5 * length - 2.5,0.5 * width - 2.5),5,5,0,"#505554"));
	road.boxList.push(new Box(new Vector(0.5 * length - 2.5,-0.5 * width + 2.5),5,5,0,"#505554"));
	road.boxList.push(new Box(new Vector(-0.5 * length + 2.5,-0.5 * width + 2.5),5,5,0,"#505554"));
	road.boxList.push(new Box(new Vector(-0.5 * length + 2.5,0.5 * width - 2.5),5,5,0,"#505554"));
	road.addCollisionBox(new Box(new Vector(0,0),length,width,0,"#505554"));
	return road;
};
Road.__super__ = CompoundBox;
Road.prototype = $extend(CompoundBox.prototype,{
	__class__: Road
});
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var Vector = function(X,Y) {
	this.y = 0.0;
	this.x = 0.0;
	this.x = X;
	this.y = Y;
};
Vector.__name__ = true;
Vector.fromAngle = function(angle) {
	var newVector = new Vector(0,0);
	newVector.x = Math.cos(angle);
	newVector.y = Math.sin(angle);
	return newVector;
};
Vector.prototype = {
	add: function(vector) {
		var newVector = new Vector(0,0);
		newVector.x = this.x + vector.x;
		newVector.y = this.y + vector.y;
		return newVector;
	}
	,subtract: function(vector) {
		var newVector = new Vector(0,0);
		newVector.x = this.x - vector.x;
		newVector.y = this.y - vector.y;
		return newVector;
	}
	,multiply: function(scalar) {
		var newVector = new Vector(0,0);
		newVector.x = this.x * scalar;
		newVector.y = this.y * scalar;
		return newVector;
	}
	,divide: function(scalar) {
		var newVector = new Vector(0,0);
		newVector.x = this.x / scalar;
		newVector.y = this.y / scalar;
		return newVector;
	}
	,length: function() {
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	,unityVector: function() {
		if(this.length() == 0) {
			return new Vector(0,0);
		}
		return this.divide(this.length());
	}
	,scalarProduct: function(vector) {
		return this.x * vector.x + this.y * vector.y;
	}
	,turnAngle: function(angle) {
		var newVector = new Vector(0,0);
		newVector = Vector.fromAngle(angle + this.getAngle()).multiply(this.length());
		if(isNaN(newVector.x)) {
			newVector.x = 0;
		}
		if(isNaN(newVector.y)) {
			newVector.y = 0;
		}
		return newVector;
	}
	,getAngle: function() {
		return Math.acos((Math.pow(this.x,2) + Math.pow(this.length(),2) - Math.pow(this.y,2)) / (2 * this.x * this.length()));
	}
	,__class__: Vector
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.__name__ = true;
haxe_Timer.prototype = {
	run: function() {
	}
	,__class__: haxe_Timer
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	setReserved: function(key,value) {
		if(this.rh == null) {
			this.rh = { };
		}
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) {
			return null;
		} else {
			return this.rh["$" + key];
		}
	}
	,__class__: haxe_ds_StringMap
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) {
		Error.captureStackTrace(this,js__$Boot_HaxeError);
	}
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.wrap = function(val) {
	if((val instanceof Error)) {
		return val;
	} else {
		return new js__$Boot_HaxeError(val);
	}
};
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) {
					return o[0];
				}
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) {
						str += "," + js_Boot.__string_rec(o[i],s);
					} else {
						str += js_Boot.__string_rec(o[i],s);
					}
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g11 = 0;
			var _g2 = l;
			while(_g11 < _g2) {
				var i2 = _g11++;
				str1 += (i2 > 0 ? "," : "") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) {
			str2 += ", \n";
		}
		str2 += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = intf[_g1++];
			if(i == cl || js_Boot.__interfLoop(i,cl)) {
				return true;
			}
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		if((o instanceof Array)) {
			return o.__enum__ == null;
		} else {
			return false;
		}
		break;
	case Bool:
		return typeof(o) == "boolean";
	case Dynamic:
		return true;
	case Float:
		return typeof(o) == "number";
	case Int:
		if(typeof(o) == "number") {
			return (o|0) === o;
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					return true;
				}
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == Class ? o.__name__ != null : false) {
			return true;
		}
		if(cl == Enum ? o.__ename__ != null : false) {
			return true;
		}
		return o.__enum__ == cl;
	}
};
js_Boot.__cast = function(o,t) {
	if(js_Boot.__instanceof(o,t)) {
		return o;
	} else {
		throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var __map_reserved = {};
js_Boot.__toStr = ({ }).toString;
Main.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
