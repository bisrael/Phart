class RkState {
  // primary state
  final Vector _position;
  final Vector _momentum;
  final Quaternion _orientation;
  final Vector _angularMomentum;
  // primary state notational getters
  Vector get x() => _position; // Conventional notation
  Vector get p() => _momentum; // Conventional notation
  Quaternion get q() => _orientation; // Conventional notation  
  Vector get L() => _angularMomentum; // Wikipedia notation
  
  // secondary state
  final Vector _velocity;
  final Quaternion _spin;
  final Vector _angularVelocity;
  // notational getters
  Vector get v() => _velocity; // Conventional notation
  Quaternion get s() => _spin; // My notation
  Vector get w() => _angularVelocity; // Conventional notation
  
  // constant state
  final num _mass;
  final num _inverseMass; // For convenience and because division is expensive
  final num _inertiaTensor;
  final num _inverseInertiaTensor;
  // notational getters
  double get m() => _mass; // Conventional notation
  double get inv_m() => _inverseMass; // My notation
  double get i() => _inertiaTensor; // Convention is I, using lowercase to reduce confusion
  double get inv_i() => _inverseInertiaTensor; // My notation
  
  // constructors
  const RkState._internal(final Vector x, final Vector p,
                          final Quaternion q, final Vector L,
                          final num m, final num im,
                          final num i, final num ii) :
    _mass = m, _inverseMass = im,
    _inertiaTensor = i, _inverseInertiaTensor = ii,
    _position = x, _momentum = p,
    _orientation = q.unit(), _angularMomentum = L,
    _velocity = p*im, _angularVelocity = L*ii,
    _spin = new Quaternion.v(L).multiply(q.unit());
  
  const RkState(final Vector x, final Vector p, 
                final Quaternion q, final Vector ap, 
                final num m, final num i) :
    this._internal(x,p,q,ap,m,1/m, i, 1/i); 
  const RkState.copy(final RkState s) :
    this._internal(s.x, s.p, s.q, s.L, s.m, s.inv_m, s.i, s.inv_i);
  
  // Methods
  RkState interpolate(final RkState to, final double alpha) {
    final double beta = 1.0 - alpha;
    return new RkState(x*beta + to.x*alpha, p*beta + to.p*alpha,
      Quaternion.slerp(q, to.q, alpha), L*beta + to.L*alpha, m, i);
  }
  RkState step(final RkDerivative d, final double dt) =>
    new RkState._internal(x + d.v*dt, p + d.F*dt, q + d.s*dt, L + d.t*dt, m, inv_m, i, inv_i);
}