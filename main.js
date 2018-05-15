// Generated by Haxe 3.4.7
(function () { "use strict";
var Drawable = function() { };
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
Box.__interfaces__ = [Drawable];
Box.prototype = {
	draw: function(context) {
		context.save();
		context.translate(this.position.x,this.position.y);
		context.rotate(this.angle);
		context.fillStyle = this.color;
		context.fillRect(-0.5 * this.width,-0.5 * this.height,this.width,this.height);
		context.restore();
	}
};
var CarAction = { __constructs__ : ["Forward","Reverse","Right","Left"] };
CarAction.Forward = ["Forward",0];
CarAction.Forward.__enum__ = CarAction;
CarAction.Reverse = ["Reverse",1];
CarAction.Reverse.__enum__ = CarAction;
CarAction.Right = ["Right",2];
CarAction.Right.__enum__ = CarAction;
CarAction.Left = ["Left",3];
CarAction.Left.__enum__ = CarAction;
var Car = function() {
	this.color = "";
	this.friction = 0.05;
	this.turnAngle = 0.0;
	this.turnSpeed = 0.01;
	this.reverseAcceleration = 0.3;
	this.forwardAcceleration = 0.5;
	this.velocity = new Vector(0,0);
	this.maxVelocityReverse = 4.0;
	this.maxVelocityForward = 6.5;
	this.angle = 0 * Math.PI;
	this.lengthWheels = 8;
	this.widthWheels = 4;
	this.length = 40;
	this.width = 24;
	this.position = new Vector(0,0);
};
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
	,capSpeed: function(maxVelocity) {
		if(this.velocity.length() > maxVelocity) {
			this.velocity = this.velocity.unityVector().multiply(maxVelocity);
		}
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
		this.capSpeed(this.maxVelocityForward);
	}
	,reverse: function() {
		var accelerationVector = Vector.fromAngle(this.angle + Math.PI).multiply(this.reverseAcceleration);
		this.velocity = this.velocity.add(accelerationVector);
		if(this.velocity.x * accelerationVector.x > 0 && this.velocity.y * accelerationVector.y > 0) {
			this.capSpeed(this.maxVelocityReverse);
		} else {
			this.capSpeed(this.maxVelocityForward);
		}
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
		this.velocity = this.velocity.subtract(this.velocity.unityVector().multiply(this.friction));
		if(this.velocity.length() < this.friction) {
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
};
var CompoundBox = function() {
	this.boxList = [];
	this.angle = 0.0;
	this.position = new Vector(0,0);
};
CompoundBox.__interfaces__ = [Drawable];
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
};
var Environment = function() {
	this.objects = [];
};
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
	,buildRoad: function(position,length,angle,width) {
		if(width == null) {
			width = 100.0;
		}
		this.objects.push(new Box(position,length,width,angle,"#505554"));
		this.objects.push(new Box(position,length,width - 10,angle,"#606665"));
	}
	,buildRoadCorner: function(position,angle,length,width) {
		if(width == null) {
			width = 100.0;
		}
		if(length == null) {
			length = 100.0;
		}
		var compoundBox = new CompoundBox();
		compoundBox.position = position;
		compoundBox.angle = angle;
		compoundBox.boxList.push(new Box(new Vector(0,0),length,width,0,"#505554"));
		compoundBox.boxList.push(new Box(new Vector(-2.5,-2.5),length - 5,width - 5,0,"#606665"));
		compoundBox.boxList.push(new Box(new Vector(-0.5 * length + 2.5,-0.5 * width + 2.5),5,5,0,"#505554"));
		this.objects.push(compoundBox);
	}
};
var Main = function() { };
Main.main = function() {
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
	var car1 = new Car();
	var car2 = new Car();
	car1.color = "#800000";
	car2.color = "#434ea1";
	car1.position = new Vector(400,200);
	car2.position = new Vector(400,240);
	var environment = new Environment();
	environment.buildRoadCorner(new Vector(1275,220),1.5 * Math.PI);
	environment.buildRoadCorner(new Vector(1275,525),0 * Math.PI);
	environment.buildRoadCorner(new Vector(170,525),0.5 * Math.PI);
	environment.buildRoadCorner(new Vector(170,220),Math.PI);
	environment.buildRoad(new Vector(722.5,220),1005,0 * Math.PI);
	environment.buildRoad(new Vector(1275,372.5),205,0.5 * Math.PI);
	environment.buildRoad(new Vector(722.5,525),1005,0 * Math.PI);
	environment.buildRoad(new Vector(170,372.5),205,0.5 * Math.PI);
	environment.objects.push(new Box(new Vector(425,220),4,90,0 * Math.PI,"yellow"));
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
	var controlCar = function(car,up,left,down,right) {
		var actions = [];
		if(__map_reserved[up] != null ? pressedKeys.getReserved(up) : pressedKeys.h[up]) {
			actions.push(CarAction.Forward);
		}
		if(__map_reserved[down] != null ? pressedKeys.getReserved(down) : pressedKeys.h[down]) {
			actions.push(CarAction.Reverse);
		}
		if(__map_reserved[left] != null ? pressedKeys.getReserved(left) : pressedKeys.h[left]) {
			actions.push(CarAction.Left);
		}
		if(__map_reserved[right] != null ? pressedKeys.getReserved(right) : pressedKeys.h[right]) {
			actions.push(CarAction.Right);
		}
		car.controlInput(actions);
	};
	var calculateScaleFactor = function() {
		var carDistance = car1.position.subtract(car2.position);
		var scaleFactor = 1.0;
		var scaleHorisontal = 1.0;
		var scaleVertical = 1.0;
		if(Math.abs(carDistance.y) >= canvas.height - 50) {
			scaleVertical = (canvas.height - 50) / Math.abs(carDistance.y);
		}
		if(Math.abs(carDistance.x) >= canvas.width - 50) {
			scaleHorisontal = (canvas.width - 50) / Math.abs(carDistance.x);
		}
		scaleFactor = Math.min(scaleHorisontal,scaleVertical);
		return scaleFactor;
	};
	var gameLoop = function() {
		controlCar(car1,"ArrowUp","ArrowLeft","ArrowDown","ArrowRight");
		controlCar(car2,"w","a","s","d");
		car1.applyFriction();
		car2.applyFriction();
		car1.updatePosition();
		car2.updatePosition();
		context.clearRect(0,0,canvas.width,canvas.height);
		context.save();
		var scaleFactor1 = calculateScaleFactor();
		var focusPoint = car1.position.add(car2.position).divide(2 / scaleFactor1);
		var midPoint = new Vector(0.5 * canvas.width,0.5 * canvas.height);
		context.translate(midPoint.x - focusPoint.x,midPoint.y - focusPoint.y);
		context.scale(scaleFactor1,scaleFactor1);
		environment.draw(context);
		car1.draw(context);
		car2.draw(context);
		context.restore();
	};
	new haxe_Timer(30).run = gameLoop;
};
var Vector = function(X,Y) {
	this.y = 0.0;
	this.x = 0.0;
	this.x = X;
	this.y = Y;
};
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
};
var haxe_IMap = function() { };
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.prototype = {
	run: function() {
	}
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
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
};
var __map_reserved = {};
Main.main();
})();
