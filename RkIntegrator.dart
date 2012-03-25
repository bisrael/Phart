class RkIntegrator {
  RkState previous, current;
  
  abstract RkDerivative forces(final RkState state, final double t);
  
  // convenience method to do a tad less for the first RK evaluate
  RkDerivative evaluateFirst(final RkState state, final double t) =>
    forces(state, t);
  
  RkDerivative evaluate(final RkState state, final double t, final double dt, final RkDerivative d) =>
    forces(state.step(d, dt), t+dt);
  
  static Vector _integrateVectors(Vector a, Vector b, Vector c, Vector d) =>
    (a + (b + c)*2.0 + d) * (1.0/6.0);
  static Quaternion _integrateQuaternions(Quaternion a, Quaternion b, Quaternion c, Quaternion d) =>
    (a + (b + c)*2.0 + d) * (1.0/6.0);
  
  RkState integrate(RkState state, double t, double dt) {
    // RK4 Integration:
    RkDerivative a = evaluateFirst(state, t);
    RkDerivative b = evaluate(state, t, dt*0.5, a);
    RkDerivative c = evaluate(state, t, dt*0.5, b);
    RkDerivative d = evaluate(state, t, dt, c);
    // Calculate the integrated derivative and use that to step the state foward dt
    return state.step(new RkDerivative(_integrateVectors(a.v, b.v, c.v, d.v),
                                       _integrateQuaternions(a.s, b.s, c.s, d.s),
                                       _integrateVectors(a.F, b.F, c.F, d.F),
                                       _integrateVectors(a.t, b.t, c.t, d.t)), dt);
  }
  
  void update(final double t, final double dt) {
    previous = current;
    current = integrate(previous, t, dt);
  }
}
