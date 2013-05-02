library serpent;

import 'dart:html';
import 'dart:math';

import 'package:rikulo_commons/util.dart';

import 'package:rikulo_ui/view.dart';
import 'package:rikulo_ui/gesture.dart';
import 'package:rikulo_ui/effect.dart';
import 'package:rikulo_ui/event.dart';

part 'serpentpoint.dart';
part 'serpentmonde.dart';
part 'nourriture.dart';
part 'serpent.dart';

class SerpentCanvas {
  final int LONGUEUR_MINIMUM_DE_TRAINEE = 20;
  final int MISE_A_JOURS = 60;
  final int HAUTEUR = 500, LARGEUR = 800;
  
  int derniercycle = 0;
  SerpentEnvironnement environnement;
  TextView scoreBarre;
  num _score = 0;
  
  CanvasRenderingContext2D ctx2d;
  Canvas canvas;
  Button up, down, left, right;
  
  num get score => _score;
  set score(num score) {
    _score = score;
    scoreBarre.text = "Votre score est: ${score}";
  }
  
  void jeux() {
    final View mainView = new View()..addToDocument();
    mainView.width = 1000;
    mainView.height = 600;
    mainView.style.background = 'lightskyblue';
    
    View vlayout = new View();
    vlayout.layout.type = "linear";
    vlayout.layout.orient = "vertical";
    vlayout.profile.anchorView = mainView;   
    vlayout.profile.location = "center center";

 
    canvas = new Canvas();
    canvas.profile.text = "width: ${LARGEUR}; height: ${HAUTEUR}";
    canvas.style.border = "3px solid black";
    canvas.style.background = 'limegreen';
    vlayout.addChild(canvas);
    
    scoreBarre = new TextView("Votre score est: ${score}");
    scoreBarre.profile.width = "flex";
    scoreBarre.profile.height = "30";
    vlayout.addChild(scoreBarre);
    
    mainView.addChild(vlayout);

    ctx2d = canvas.context2D;

    new SwipeGesture(this.canvas.node, (SwipeGestureState state) {
      final Point tr = state.transition;
      if (max(tr.x.abs(), tr.y.abs()) > LONGUEUR_MINIMUM_DE_TRAINEE) {
        environnement.serpent.direction = 
            tr.x.abs() > tr.y.abs() ?
                (tr.x > 0 ? Serpent.DROITE : Serpent.GAUCHE) :
                (tr.y > 0 ? Serpent.BAS  : Serpent.HAUT);
      }
    });
    
    document.onKeyDown.listen(onKeyDown);
    debutjeux();
  }
  
  void debutjeux() {

    score = 0;

    environnement = new SerpentEnvironnement(HAUTEUR,LARGEUR);

    new Animator().add((int temps) {
      int temps_depuis_debut = temps - derniercycle;
      bool ret = true;
      
      if(temps_depuis_debut > MISE_A_JOURS) {
        int message = environnement.dessine(ctx2d);
        
        switch(message) {
          case SerpentEnvironnement.FINJEUX:
            ret = false;
            finjeux();
            break;
          case SerpentEnvironnement.POINTAGE:
            score += 1;
            break;
        }
        
        derniercycle = temps;
      }
      
      return ret;
    });
  }

  void finjeux() {
    View dlg = new TextView('''Parti terminée!! Votre score est: ${score}
                                    Cliquez ici pour recommencer.''');
    dlg.style.cssText = "text-align: center; padding-top: 30px";
    dlg.profile.text = "location: center center; width: 30%; min-height: 100; min-width: 200";
    dlg.classes.add("v-dialog");
    dlg.on.click.listen((e) {
      dlg.remove();
      
      ctx2d.save();
      ctx2d.setTransform(1,0,0,1,0,0);
      ctx2d.clearRect(0, 0, canvas.width, canvas.height);
      ctx2d.restore();
      
      debutjeux();
    });
    
    dlg.addToDocument(mode: "dialog");
  }

  void onKeyDown(KeyboardEvent event) {
    if(event.keyCode == 37)
      environnement.serpent.direction = Serpent.GAUCHE;
    else if(event.keyCode == 39)
      environnement.serpent.direction = Serpent.DROITE;
    else if(event.keyCode == 38)
      environnement.serpent.direction = Serpent.HAUT;
    else if(event.keyCode == 40)
      environnement.serpent.direction = Serpent.BAS;
  }
}

void main() {
  new SerpentCanvas().jeux();
}
