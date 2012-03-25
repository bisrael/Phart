#import('dart:html');
#import('Phart.dart');
#import('Engine.dart');

class PhartTest {
  Game game;
  
  PhartTest() {
    game = new Game();
  }

  void run() {
    game.start();
  }
}

void main() {
  new PhartTest().run();
}