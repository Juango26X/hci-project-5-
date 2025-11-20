import oscP5.*;
import netP5.*;
import oscP5.OscMessage;

OscP5 osc;
NetAddress pd;
Table baseD;

int indice = 0;
int tiempoEntreFiguras = 60;

ArrayList<Figura> figuras = new ArrayList<Figura>();

void setup() {
  size(900, 700);
  frameRate(60);


  baseD = loadTable("pokemon.csv", "header");

  osc = new OscP5(this, 12000);
  pd = new NetAddress("127.0.0.1", 11111);
}

void draw() {
  background(90,10,50);


  if (frameCount % tiempoEntreFiguras == 0 && indice < baseD.getRowCount()) {

    figuras.add(new Figura(baseD.getRow(indice), "pokebola"));   // HP
    figuras.add(new Figura(baseD.getRow(indice), "estrella"));   // Attack
    figuras.add(new Figura(baseD.getRow(indice), "hoja"));       // Defense

    indice++;
  }

  for (int i = figuras.size() - 1; i >= 0; i--) {
    Figura f = figuras.get(i);
    f.update();
    f.display();
    if (f.y < -100) figuras.remove(i);
  }
}

class Figura {
  float x, y;
  float vy;
  float s;

  float hp, atk, def;
  String nombre;
  String tipoPokemon;

  String tipo;
  int c;

  float vibracion = 0;
  float angulo = 0;

  Figura(TableRow row, String tipoFigura) {

    nombre = row.getString("Name");
    tipoPokemon = row.getString("Type");

    hp = row.getFloat("HP");
    atk = row.getFloat("Attack");
    def = row.getFloat("Defense");

    tipo = tipoFigura;
    s = 50;


    x = random(50, width - 50);
    y = height + 50;

    if (tipo.equals("pokebola")) {
      vy = -4;
    }
    else if (tipo.equals("estrella")) {
      c = color(255, 230, 50);
      vy = map(atk, 10, 190, -10, -2);
    }
    else if (tipo.equals("hoja")) {
      c = color(50, 200, 80);
      vibracion = map(def, 5, 230, 15, 0);
      vy = -4;
    }

    enviarSonido();
  }

  void update() {
    y += vy;
    angulo += 0.03;
  }

  void display() {

    if (tipo.equals("pokebola")) {
      dibujarPokebola(x, y, s);
    }
    else if (tipo.equals("estrella")) {
      fill(c);
      dibujarEstrella(x, y, s * 0.6, s * 0.25, 5);
    }
    else if (tipo.equals("hoja")) {
      pushMatrix();
      translate(x, y);
      translate(sin(angulo) * vibracion, cos(angulo * 1.3) * vibracion);
      dibujarHoja(0, 0, s);
      popMatrix();
    }
  }


  void dibujarEstrella(float cx, float cy, float r1, float r2, int puntos) {
    float ang = TWO_PI / (puntos * 2);
    beginShape();
    for (int i = 0; i < puntos * 2; i++) {
      float r = (i % 2 == 0) ? r1 : r2;
      vertex(cx + cos(i * ang) * r, cy + sin(i * ang) * r);
    }
    endShape(CLOSE);
  }

  void dibujarPokebola(float cx, float cy, float s) {
    noStroke();

    fill(255, 0, 0);
    arc(cx, cy, s, s, PI, TWO_PI);

    fill(255);
    arc(cx, cy, s, s, 0, PI);

    stroke(0);
    strokeWeight(4);
    line(cx - s/2, cy, cx + s/2, cy);

    fill(255);
    ellipse(cx, cy, s * 0.35, s * 0.35);

    fill(0);
    ellipse(cx, cy, s * 0.15, s * 0.15);
  }


  void dibujarHoja(float cx, float cy, float s) {
    noStroke();
    fill(50, 200, 80);

    beginShape();
    vertex(cx, cy - s/2);
    bezierVertex(cx + s/2, cy - s/4, cx + s/2, cy + s/4, cx, cy + s/2);
    bezierVertex(cx - s/2, cy + s/4, cx - s/2, cy - s/4, cx, cy - s/2);
    endShape(CLOSE);

    stroke(255);
    strokeWeight(2);
    line(cx, cy - s/2, cx, cy + s/2);
  }

  void enviarSonido() {
    OscMessage m = new OscMessage("/pokemonStats");


    m.add(tipoPokemon);
    m.add(hp);
    m.add(atk);
    m.add(def);

    osc.send(m, pd);
  }
}
