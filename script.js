"use strict"

var canvas = document.getElementById("kanvas")
var context = canvas.getContext("2d")

canvas.width = window.innerWidth
canvas.height = window.innerHeight

window.onresize = () => {
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
}

var pressedKeys = {}

window.addEventListener("keyup", (event) => {
    pressedKeys[event.key] = false
})
window.addEventListener("keydown", (event) => {
    pressedKeys[event.key] = true
})

function gameLoop() {
    if (pressedKeys["ArrowUp"]) {
        car.y -= 5
    }
    if (pressedKeys["ArrowLeft"]) {
        car.x -= 5
    }
    if (pressedKeys["ArrowDown"]) {
        car.y += 5
    }
    if (pressedKeys["ArrowRight"]) {
        car.x += 5
    }
    context.fillStyle = "black"
    context.fillRect(0, 0, canvas.width, canvas.height)
    car.draw()
}

class Car {
    constructor() {
        this.x = 550
        this.y = 300
    }
    draw() {
        context.fillStyle = "red"
        context.fillRect(this.x, this.y, 20, 20)
    }
}

var car = new Car()
car.draw()
setInterval(gameLoop, 30)