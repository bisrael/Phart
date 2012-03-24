#library ("Phart");

class Vector {
  final double x, y;
  const Vector(double this.x, double this.y);
  const Vector.from(final Vector v) : this(v.x, v.y);
  const Vector.unit(double x, double y) : this(x/Math.sqrt(x*x + y*y), y/Math.sqrt(x*x + y*y));
  const Vector.zero() : this(0.0,0.0);
  Vector operator+(Vector other) => new Vector(this.x + other.x, this.y + other.y);
  Vector operator-(Vector other) => new Vector(this.x - other.x, this.y - other.y);
  Vector operator*(num s) => new Vector(this.x*s, this.y*s);
  
  // Static functions:
}
