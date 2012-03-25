class PMath {
  static final double epsilon = 0.00001;
  static final double epsilon_2 = epsilon * epsilon;
  static bool equal(num a, num b) {
    double d = a-b;
    return (d < epsilon && d > -epsilon);
  }
  static num lerp(num a, num b, num t) => a + (b - a)*t;
  static num snap(num p, num grid) => grid != 0 ? ((p + grid*0.5)/grid).floor()*grid : p;
  
  static bool len_not_zero(final num x, final num y, final num z) => len_2(x,y,z) > epsilon_2;
  static num len(final num x, final num y, final num z) => Math.sqrt(len_2(x,y,z));
  static num len4(final num w, final num x, final num y, final num z) => Math.sqrt(len4_2(w,x,y,z));
  static num len_2(final num x, final num y, final num z) => x*x + y*y + z*z;
  static num len4_2(final num w, final num x, final num y, final num z) => w*w + x*x + y*y + z*z; 
}