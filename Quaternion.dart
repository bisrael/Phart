// Immutable Quaternion Class
class Quaternion {
  final num w,x,y,z;
  // Constructors
  const Quaternion(final num this.w, final num this.x, final num this.y, final num this.z);
  const Quaternion.zero() : this.w(0);
  const Quaternion.identity() : this.w(1);
  const Quaternion.w(final num w) : this(w, 0, 0, 0);
  const Quaternion.v(final Vector v) : this.vw(v, 0);
  const Quaternion.vw(final Vector v, final num w) : this(w, v.x, v.y, v.z);
  const Quaternion.aa(final num angle, final Vector axis) :
    this.vw(axis*Math.sin(angle/2), Math.cos(angle/2));
  // Methods
  num length() => PMath.len4(w,x,y,z);
  num norm() => PMath.len4_2(w,x,y,z);
  Vector vpart() => new Vector(x,y,z);
  Quaternion conjugate() => new Quaternion(w, -x, -y, -z);
  Quaternion unit() => length() == 0 ? new Quaternion.identity() : this/length();
  Quaternion inverse() => conjugate()/norm();
  // TODO: Quaternion slerp();
  // Angle-Axis Representation
  num angle() => PMath.len_not_zero(x,y,z) ? 2*Math.acos(w) : 0;
  Vector axis() => PMath.len_not_zero(x,y,z) ? new Vector.unit(x, y, z) : new Vector.x(1);
  // Non-scalar Multiplication
  Quaternion dot(final Quaternion q) => new Quaternion.w(w*q.w + x*q.x + y*q.y + z*q.z);
  Quaternion multiply(final Quaternion q) => 
    new Quaternion(w*q.w - x*q.x + y*q.y - z*q.z,
                   w*q.x + x*q.w + y*q.z - z*q.y,
                   w*q.y - x*q.z + y*q.w + z*q.x,
                   w*q.z + x*q.y - y*q.x + z*q.w);
  // Operators
  // Unary Operators
  Quaternion operator negate() => new Quaternion(-w, -x, -y, -z);
  // Additive Operators
  Quaternion operator+(final Quaternion q) => new Quaternion(w + q.w, x + q.x, y + q.y, z + q.z);
  Quaternion operator-(final Quaternion q) => new Quaternion(w - q.w, x - q.x, y - q.y, z - q.z);
  // Multiplicative Operators
  Quaternion operator*(final num s) => new Quaternion(w*s, x*s, y*s, z*s);
  Quaternion operator/(final num s) => this*(1/s);
  Quaternion operator%(final num s) => new Quaternion(w%s, x%s, y%s, z%s);
  // Equality Operator
  bool operator==(final Quaternion q) => // TODO: Change this to equals when Dart Editor supports it 
    PMath.equal(w, q.w) && PMath.equal(x, q.x) && PMath.equal(y, q.y) && PMath.equal(z, q.z);
    
  static Quaternion slerp(final Quaternion a, final Quaternion b, final double t) {
    double flip = 1.0;
    double cosine = a.w*b.w + a.x*b.x + a.y*b.y + a.z*b.z;
    if(cosine < 0) {
      cosine = -cosine;
      flip = -1.0;
    }
    if(1 - cosine < PMath.epsilon) {
      return a*(1-t) + b*(t*flip);
    } else {
      double theta = Math.acos(cosine);
      double sine = Math.sin(theta);
      double beta = Math.sin(theta*(1-t)) / sine;
      double alpha = Math.sin(t*theta) / sine * flip;
      return a*beta + b*alpha;
    }
  }
}
