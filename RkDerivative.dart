class RkDerivative {
  // First Derivatives
  final Vector _velocity;
  final Quaternion _spin;
  
  Vector get v() => _velocity; // Conventional notation
  Quaternion get s() => _spin;
  
  // derivative of velocity (accelleration)
  final Vector _force;
  final Vector _torque;
  
  Vector get F() => _force; // Conventional notation
  Vector get t() => _torque; // Should be tau, but no one is going to type that 
  
  const RkDerivative(final Vector this._velocity, final Quaternion this._spin,
                     final Vector this._force, final Vector this._torque);
  const RkDerivative.zero() :
    this(const Vector.zero(), const Quaternion.zero(), const Vector.zero(), const Vector.zero());
  
  const RkDerivative.forces(final RkState state, final Vector F, final Vector t) :
    this(state.v, state.s, F, t);
}