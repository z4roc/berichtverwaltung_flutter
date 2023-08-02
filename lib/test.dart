class Operators {
  void basicMath() {
    1 + 2 - 3 * 4 / 5;
  }

  void logic() {
    1 == 1;
    1 < 2;
    2 > 1;
    2 >= 1;
  }

  void incrementDecrement() {
    var x = 1;

    ++x;
    --x;
    x++;
    x--;
  }

  void assignment() {
    String? name;

    name ??= "Test"; //assign if Null, otherwise current value
    var z = name ?? "Testo";
  }

  void ternary() {
    String color = "blue";

    var isThisBlue = color == "blue" ? "Yes" : "No";
  }

  void cascade() {
    dynamic Paint;

    var paintCascade = Paint()
      ..color = "black"
      ..stroke = "round";

    // is the same like

    var paint = Paint();
    paint.color = "";
    paint.stroke = "";
  }
}

class Variables {}
