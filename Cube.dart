#import ('Phart.dart');
#import ('dart:html');

class Cube2d extends RkIntegrator {
  double size;
  Vector color;
  
  // Constructors:
  Cube2d._internal(final num s, final num m) {
    size = s;
    color = const Vector.zero();
    current = new RkState(new Vector(2, 0, 0), new Vector(0, 0, -10), 
      const Quaternion.identity(), const Vector.zero(), 
      m, m*s*s/6.0);
  }
  Cube2d() : this._internal(1, 1);
  Cube2d.random() {
    size = Math.random();
    color = new Vector.random(1);
    
    double m = Math.random()*2;
    
    Vector pos;
    switch((Math.random()*3).floor()) {
    case 1:
      pos = new Vector.x(Math.random()*2);
      break;
    case 2:
      pos = new Vector.y(Math.random()*2);
      break;
    case 3:
      pos = new Vector.z(Math.random()*2);
      break;
    default:
      pos = new Vector.x(2);
      break;
    }
    
    current = new RkState(new Vector.random(5), new Vector.random(1)*-2, 
      new Quaternion.w(Math.random()*2*Math.PI), new Vector.random(1), 
      m, m*size*size/6.0);
  }
  
  // RkIntegrator implementation:
  RkDerivative forces(final RkState state, final double t) {
    Vector F = (state.x*-10) + new Vector(10.0*Math.sin(t*0.9 + 0.5), 
                                          11.0*Math.sin(t*0.5 + 0.4), 
                                          12.0*Math.sin(t*0.7 + 0.9));
    
    Vector tau = new Vector(1.0*Math.sin(t*0.9 + 0.5), 
                            1.1*Math.sin(t*0.5 + 0.4), 
                            1.2*Math.sin(t*0.7 + 0.9));
    
    return new RkDerivative.forces(state, F, tau);
  }
  
  void render2d(final CanvasRenderingContext2D context, [final double alpha = 1.0]) {
    //final RkState state = previous.interpolate(current, alpha);
    final RkState state = current;
    final double half = size*0.5;
    
    context.save(); // like glPushMatrix
    
    context.translate(state.x.x, state.x.y);
    context.rotate(state.q.angle());
    
    context.setFillColor(color.x, color.y, color.z, state.x.z.abs());
    
    context.fillRect(-half, -half, size, size);
        
    context.restore(); // like glPopMatrix
  }
}
