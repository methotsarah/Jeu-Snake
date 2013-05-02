part of serpent;

class Nourriture {

  int _x, _y;
  bool redessine = true;
  SerpentEnvironnement serpentEnvironnement;
  
  Nourriture(this.serpentEnvironnement);
  
  int get x => _x;
  set x(int valeur) {
    _x = valeur;
    redessine = true;
  }
  
  int get y => _y;
  set y(int valeur) {
    _y = valeur;
    redessine = true;
  }

  void deplace_nourriture(List<SerpentPoint> evite) {
    
    num suggestionX = _random()*((serpentEnvironnement.largeur / SerpentEnvironnement.ajustement) - 1);
    num suggestionY = _random()*((serpentEnvironnement.hauteur / SerpentEnvironnement.ajustement) - 1);
    
    suggestionX = suggestionX.floor() * SerpentEnvironnement.ajustement;
    suggestionY = suggestionY.floor() * SerpentEnvironnement.ajustement;
    
    bool a = false;
    
    for(final point in evite) {
      if(suggestionX == point.x && suggestionY == point.y) { 
        a=true;
        break;
      }
    }
    
    if(a)
      deplace_nourriture(evite);
    else {
      x = suggestionX.toInt();
      y = suggestionY.toInt();
    }
  }
  static num _random()
  => _rand.nextDouble();
  static final Random _rand = new Random();
  
  void dessine(CanvasRenderingContext2D contexte) {
    double grandeur_petit_rectangle = SerpentEnvironnement.ajustement / 3;

    contexte.beginPath();
    contexte.fillStyle = "";

    contexte.rect(_x + grandeur_petit_rectangle, _y, grandeur_petit_rectangle, grandeur_petit_rectangle);
    
    contexte.rect(_x, _y + grandeur_petit_rectangle, grandeur_petit_rectangle, grandeur_petit_rectangle);
    contexte.rect(_x + (grandeur_petit_rectangle * 2), _y + grandeur_petit_rectangle, grandeur_petit_rectangle, grandeur_petit_rectangle);

    contexte.rect(_x + grandeur_petit_rectangle, _y + (grandeur_petit_rectangle * 2), grandeur_petit_rectangle, grandeur_petit_rectangle);

    contexte.closePath();
    contexte.fill();
  }
  
  String toString() {
    return "$_x, $_y";
  }
}
