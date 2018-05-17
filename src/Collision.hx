class Collision {
    public static function collidesWith(point: Vector, collider: Collidable) {
        var box = collider.getCollisionBox();
        if(box == null)
            return false;
        var newVector = box.position.subtract(point).turnAngle(-box.angle);

        if (Math.abs(newVector.x) <= 0.5*box.width && Math.abs(newVector.y) <= 0.5*box.height) {
            return true;
        }
        else {
            return false;
        }
    }
}