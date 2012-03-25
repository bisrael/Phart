// Immutable Vector Class
class Vector {
  // Values
  final num x, y, z;
  // Constructors
  const Vector(final num this.x, final num this.y, final num this.z);
  const Vector.zero() : this(0, 0, 0);
  const Vector.xy(final num this.x, final num this.y) : z = 0;
  const Vector.x(final num x) : this(x, 0, 0);
  const Vector.y(final num y) : this(0, y, 0);
  const Vector.z(final num z) : this(0, 0, z);
  const Vector.unit(final num x, final num y, final num z) : 
    this(x / PMath.len(x, y, z), y / PMath.len(x, y, z), z / PMath.len(x, y, z));
  const Vector.random(final num s) :
    this(Math.random()*s, Math.random()*s, Math.random()*s);
  // Methods
  // Normal Length (Magnitude)
  num length() => PMath.len(x, y, z);
  // Length Squared (Magnitude^2)
  num length_2() => PMath.len_2(x, y, z);
  num dot(final Vector v) => x*v.x + y*v.y + z*v.z;
  Vector cross(final Vector v) => new Vector(y*v.z - z*v.y, z*v.x - x*v.z, x*v.y - y*v.x);
  Vector unit() => this/length();
  // Operators
  // Unary Operators
  Vector operator negate() => new Vector(-x, -y, -z);
  // Additive Operators
  Vector operator+(final Vector v) => new Vector(x + v.x, y + v.y, z + v.z);
  Vector operator-(final Vector v) => new Vector(x - v.x, y - v.y, z - v.z);
  // Multiplicative Operators
  Vector operator*(final num s) => new Vector(x*s, y*s, z*s);
  Vector operator/(final num s) => this*(1/s);
  Vector operator%(final num s) => new Vector(x%s, y%s, z%s);
  // Equality Operator
  bool operator==(final Vector v) => // TODO: Change this to equals when Dart Editor supports it 
    PMath.equal(x, v.x) && PMath.equal(y, v.y) && PMath.equal(z, v.z);
}