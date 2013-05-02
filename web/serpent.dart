part of serpent;

class Serpent {
  static const int HAUT = -2, BAS = 2, GAUCHE=-1, DROITE=1;
  
  int _direction;
  List<SerpentPoint> corps;
  bool initial = true;
  SerpentEnvironnement serpentEnvironnement;
  
  Serpent(this.serpentEnvironnement) {
    _direction = DROITE;
    corps = [];
    
    for(num i =0; i<3; i++) {
      corps.add(new SerpentPoint(i * SerpentEnvironnement.ajustement,0));
    }
  }
  
  int get direction => _direction;
  
  set direction(int valeur) {
    if((_direction + valeur) != 0) {
      _direction = valeur;
    }
  }
  
  int longueur() {
    return corps.length;
  }
  
  SerpentPoint tete() {
    return corps.last;
  }
  
  SerpentPoint prochain_mouvement() {
    var serpentTete = new SerpentPoint(tete().x, tete().y);
    num ajustement = SerpentEnvironnement.ajustement;
    
    switch(_direction) {
      case HAUT:
        serpentTete.y -= ajustement;
        break;
      case BAS:
        serpentTete.y += ajustement;
        break;
      case GAUCHE:
        serpentTete.x -= ajustement;
        break;
      case DROITE:
        serpentTete.x += ajustement;
        break;
    }
    
    return serpentTete;
  }
  
  SerpentPoint mouvement(SerpentPoint to, bool grandir) {
    var supprime = null; 
    
    if(!grandir) {
      supprime = corps[0];
      corps.removeRange(0, 1);
    }
 
    corps.add(to);
    
    return supprime;
  }
  
  bool agissement(CanvasRenderingContext2D contexte, Nourriture nourriture) {
    
    if(initial) {
      corps.forEach((element) => dessineSerpent(contexte, element, null));
      initial = false;
      return false;
    }
    
    SerpentPoint bouge_vers = prochain_mouvement();
    bool grandir = (bouge_vers.x == nourriture.x && 
        bouge_vers.y == nourriture.y);
    
    var supprime = mouvement(bouge_vers, grandir);
    dessine(contexte, supprime);
    
    return grandir;
  }
  
  void dessine(CanvasRenderingContext2D contexte, SerpentPoint supprime) {    
    dessineSerpent(contexte, corps.last, supprime);
  }
  
  void dessineSerpent(CanvasRenderingContext2D contexte, SerpentPoint point, SerpentPoint supprime) {
    contexte.beginPath();
    contexte.fillStyle = "";

    num ajustement = SerpentEnvironnement.ajustement;

    if(supprime != null) {
      contexte.clearRect(supprime.x, supprime.y, ajustement, ajustement);
    }

    int largeur = SerpentEnvironnement.ajustement;
    int longueur = SerpentEnvironnement.ajustement;
    int rayon = SerpentEnvironnement.ajustement ~/ 3;

    contexte.beginPath();
    contexte.moveTo(point.x + rayon, point.y);
    contexte.lineTo(point.x + largeur - rayon, point.y);
    contexte.quadraticCurveTo(point.x + largeur, point.y, point.x + largeur, 
                             point.y + rayon);
    contexte.lineTo(point.x + largeur, point.y + longueur - rayon);
    contexte.quadraticCurveTo(point.x + largeur, point.y + longueur, 
                             point.x + largeur - rayon, point.y + longueur);
    contexte.lineTo(point.x + rayon, point.y + longueur);
    contexte.quadraticCurveTo(point.x, point.y + longueur, point.x, 
                             point.y + longueur - rayon);
    contexte.lineTo(point.x, point.y + rayon);
    contexte.quadraticCurveTo(point.x, point.y, point.x + rayon, point.y);
    contexte.closePath();
    contexte.fill();
  }
}
