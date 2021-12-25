/* 	Nom du programmeur: Lexxie Roy
	Date: Le 28 septembre 2018
	Nom du fichier:  INVASION.as
	Description: le joueur a 3 vies apres que 3 ennemi touch le ship tu perdre.

	*/
package {

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.net.SharedObject;

	public class INVASION extends MovieClip {
		
		var score: int = 0;
		var life: int = 3;//Nombre de vie
		var acceleration: Number = 1;
		var movementX: Array = new Array();// un array pour converver la vitess pour chaque ennemi
		var movementY: Array = new Array();

		public function INVASION() {

			var ennemi: Array = new Array();

			var timer: Timer = new Timer(1500);


			timer.addEventListener(TimerEvent.TIMER, time);
			function time(event: TimerEvent): void {

				var bug: EnnemiBleu = new EnnemiBleu();//cree un child, bug, avec EnnemiBleu comme parent

				ennemi.push(bug); // ajouter bug dans le array d'ennemi


				var spawn;
				spawn = Math.ceil(Math.random() * 4) - 1// il est un nombre entre 0 et 3

				switch (spawn) {// le nombre spawn choisira un case pour la position de l'ennemi

					case 0:
						ennemi[ennemi.length - 1].y = Math.ceil(Math.random() * 50) + 700
						ennemi[ennemi.length - 1].x = Math.floor(Math.random() * 970)
						break;

					case 1:
						ennemi[ennemi.length - 1].y = Math.ceil(Math.random() * -60) - 10
						ennemi[ennemi.length - 1].x = Math.floor(Math.random() * 970)
						break;

					case 2:
						ennemi[ennemi.length - 1].y = Math.ceil(Math.random() * 640)
						ennemi[ennemi.length - 1].x = Math.floor(Math.random() * 10) + 980
						break;

					case 3:
						ennemi[ennemi.length - 1].y = Math.ceil(Math.random() * 640)
						ennemi[ennemi.length - 1].x = Math.floor(Math.random() * -60) - 10
						break;
				
				}//Chaque case choisi un position dehors l'ecran

				addChild(ennemi[ennemi.length - 1])// add la dernier ennemi dans le array comme child 

				ennemi[ennemi.length - 1].rotation = (180 * Math.atan2((ennemi[ennemi.length - 1].x - ship.x), (ship.y - ennemi[ennemi.length - 1].y))) / Math.PI;//pivote ennemi pour qu'il est tourner ver le ship

			

				movementX.push((bug.x - ship.x) * (0.01 * acceleration));// Utilise la position de bug pour faire bouger les ennemi de facon alegorique
				movementY.push((bug.y - ship.y) * (0.01 * acceleration));


				ennemi[ennemi.length - 1].addEventListener(MouseEvent.CLICK, kill);
				function kill(e: MouseEvent): void {

					e.target.gotoAndPlay(22)// joue l'animation de mort
					e.target.removeEventListener(MouseEvent.CLICK, kill); // Pour que vous ne pouviez par reclicker
					score++// ajout au score
					txtScore.text = String(score);// affiche le score
					acceleration += 0.1// fait un accelatation au ennemi


				}

			}

			timer.start()
		

			

			var timerBouge: Timer = new Timer(10);
			timerBouge.start()

			timerBouge.addEventListener(TimerEvent.TIMER, bouge);
			function bouge(event: TimerEvent): void {
				for (var i: int = 0; i < ennemi.length - 1; i++) {

					ennemi[i].x -= movementX[i]//faire bouger les ennemi par le numero calculer pour se ennemi
					ennemi[i].y -= movementY[i]

				}
			}
			timerBouge.start()

			stage.addEventListener(Event.EXIT_FRAME, ExitFrame);
			function ExitFrame(e: Event) {

				for (var i: int = 0; i < ennemi.length - 1; i++) {
					if (ennemi[i].hitTestObject(ship)) {// Quand qu'un ennemi touch ship
						life--// un vie est perdu
						removeChild(ennemi[i]);// L'ennemi est retirer
						ennemi.splice(i, 1); //L'ennemi est retire du array
						movementY.splice(i, 1);// La vitesse du ennemi est retirer du array
						movementX.splice(i, 1);
						//trace(life)
					}
					if (life == 0) {// Quand tu perdre tous vos vies

						timer.stop()
						timerBouge.stop()
						MovieClip(root).high = score;//Transmettre la valeur score au reste du program
						stage.removeEventListener(Event.EXIT_FRAME, ExitFrame);// Arrete le event listener
						MovieClip(root).gotoAndStop(3);//Change le frame




					}
				}
			}

			stage.addEventListener(MouseEvent.MOUSE_MOVE, EnterFrame);
			function EnterFrame(e: Event) {

				ship.rotation = (180 * Math.atan2(mouseY - ship.y, mouseX - ship.x)) / Math.PI + 90;// Pivote le ship pour suivre la position du souri

				
			}

		}

	}
}