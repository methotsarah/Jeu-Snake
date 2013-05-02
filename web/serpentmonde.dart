part of serpent;

class SerpentEnvironnement {
  
  static const int POINTAGE=0, FINJEUX=1, CONTINUER=2;
  static const num ajustement = 10;
  
  num hauteur,largeur;
  Serpent serpent;
  Nourriture nourriture;
  
  SerpentEnvironnement(this.hauteur, this.largeur) {
    
    if((this.hauteur % ajustement != 0) ||
        (this.largeur % ajustement != 0)) {
      throw new ArgumentError(" (${ajustement})");
    }
    
    serpent = new Serpent(this);
    nourriture = new Nourriture(this);
    
    nourriture.deplace_nourriture(serpent.corps);
  }
  
  int dessine(CanvasRenderingContext2D contexte) {
    nourriture.dessine(contexte);
    bool augmente = serpent.agissement(contexte, nourriture);
    
    var tete = serpent.tete();
    if((tete.x >= largeur || tete.x < 0)
        || (tete.y >= hauteur || tete.y < 0)) {
       return FINJEUX;
     }
    
    if(augmente) {
      nourriture.deplace_nourriture(serpent.corps);
      return POINTAGE;
    }
    
    return CONTINUER;
  }
}
