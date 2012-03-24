#library ("Phart");
#import ("Vector.dart");

class RkState {
  final Vector p; // position
  double get y() => p.y;
  double get x() => p.x;
  
  final Vector v; // velocity
  double get vx() => v.x;
  double get vy() => v.y;
  
  const RkState(final Vector this.p, final Vector this.v);
  const RkState.from(final RkState s) : this(s.p, s.v);
}

class RkDerivative {
  final Vector dp; // derivative of position (velocity)
  double get dy() => dp.y;
  double get dx() => dp.x;
  
  final Vector dv; // derivative of velocity (accelleration)
  double get dvy() => dv.y;
  double get dvx() => dv.x;
  
  const RkDerivative(final Vector this.dp, final Vector this.dv);
  const RkDerivative.zero() : this(const Vector.zero(), const Vector.zero());
}

class Rk4Integrator {
  static Vector _evalHelper(Vector i, Vector d, double dt) => i + (d*dt);
  
  static Vector acceleration(final RkState state, final double t) {
    final double k = 1.0;
    final double b = 1.0;
    return (state.p*(-k)) - (state.v*b);
  }
  
  static RkDerivative evaluate(final RkState initial, final double t, final double dt, final RkDerivative d) {
    final RkState state = new RkState(_evalHelper(initial.p, d.dp, dt), _evalHelper(initial.v, d.dv, dt));
    return new RkDerivative(state.v, acceleration(state, t + dt));
  }
  
  static Vector _integrateHelper(Vector a, Vector b, Vector c, Vector d) {
    return (a + (b + c)*2.0 + d) * (1.0/6.0);
  }
  
  static RkState integrate(RkState state, double t, double dt) {
    RkDerivative a = evaluate(state, t, 0.0, const RkDerivative.zero());
    RkDerivative b = evaluate(state, t, dt*0.5, a);
    RkDerivative c = evaluate(state, t, dt*0.5, b);
    RkDerivative d = evaluate(state, t, dt, c);
    
    final Vector dpdt = _integrateHelper(a.dp, b.dp, c.dp, d.dp);
    final Vector dvdt = _integrateHelper(a.dv, b.dv, c.dv, d.dv);
    
    return new RkState(state.p + (dpdt * dt), state.v + (dvdt * dt));
  }
}
