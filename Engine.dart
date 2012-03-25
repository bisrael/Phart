#library ('Phart');

#import ('dart:html');
#import ('Phart.dart');
#import ("Cube.dart");

class Game {
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  int _viewH;
  int _viewW;
  int _fps;
  double _ticksize;
  bool going = true;
  Stopwatch timer;
  Stopwatch compare;
  int _frame = 0;
  double _time = 0;
  int _delayHandle;
  double _dt;
  
  int _currentTime;
  double _accumulator;
  List<int> xs;
  List<int> ys;
  
  List<Cube2d> particles;
  
  Game() {
    canvas = document.query("#game");
    context = canvas.getContext("2d");
    _viewH = canvas.height;
    _viewW = canvas.width;
    
    timer = new Stopwatch();
    compare = new Stopwatch();
    
    _dt = 1000000.0/160.0;
    _fps = 60;
    
    xs = new List();
    ys = new List();
    
    generateParticles();
  }
  
  void generateParticles() {
    particles = new List<Cube2d>();
  }
  
  void updateParticles(double t, double dt) {
    particles.forEach((p){ p.update(t, dt); });
    if(particles.length < 150 && !(t%1)) particles.add(new Cube2d.random());
  }
  
  void drawParticles([final double alpha = 1.0]) {
    context.save();
    context.translate(_viewW/2, _viewH/2);
    context.scale(30, 30);
    particles.forEach((p){ p.render2d(context); });
    context.restore();
  }
  
  void start() {
    _currentTime = 0;
    _accumulator = 0.0;
    timer.start();
    _tick();
    canvas.on.click.add(_canvasClickHandler, true);
  }
  
  void _canvasClickHandler(MouseEvent e) {
    xs.addLast(e.offsetX);
    ys.addLast(e.offsetY);
  }
  
  void _tick() {
    int newTime = timer.elapsedInUs();
    int frameUs = newTime - _currentTime;
    _currentTime = newTime;
    
    _accumulator += frameUs; //(frameUs/1000000.0);
    
//    debugger;
    while(_accumulator >= _dt) {
      _clearMainView();
      // Frame Start
      
      updateParticles(_time/1000000.0, _dt/1000000.0);
      
      _lineRect(1,1,_viewW-1, _viewH-1, 0,0,0,1);
      
      _text((_time).toStringAsFixed(6), 50, 50, 0,0,0,1);
      _text((timer.elapsed()).toString(), 50, 75, 0,0,0,1);
      _point(5,5,5,0,0,0,1);
      for(int i = 0; i < xs.length; ++i) {
        _point(xs[i], ys[i],13,0,0,0,1);
      }
      
      drawParticles();
      
      _accumulator -= _dt;
      _time += _dt;
    }
    
    // Frame Over
    ++_frame;
    _delayHandle = window.setTimeout(_tick, 2);
  }
  
  void _point(int x, int y, int size, int r, int g, int b,int a) {
    int w,h = w = size;
    int half = (size/2).toInt();
    if(size.isEven()) {
      half--;
    }
    context.setFillColor(r,g,b,a);
    if(half > 0) {
      x -= half;
      y -= half;
      w -= half;
      h -= half;
    }
    context.fillRect(x,y,w,h);
  }
  
  void _clearMainView() {
    context.clearRect(0,0,_viewW,_viewH);
  }
  
  void _text(String text, int x, int y, int r, int g, int b, int a) {
    context.setFillColor(r,g,b,a);
    context.fillText(text, x, y);
  }
  
  void _lineRect(int x, int y, int x2, int y2, int r, int g, int b, int a) {
    context.setStrokeColor(r,g,b,a);
    context.strokeRect(x,y,x2-x,y2-y,1);
  }
}