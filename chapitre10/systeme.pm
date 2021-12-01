// Chaîne de Markov
dtmc

const double p = 0.9;

module systeme
        // 0 = départ, 1 = envoyer, 2 = succès, 3 = échec
	etat : [0..3] init 0;
	
	[] (etat = 0) -> (etat' = 1);
	[] (etat = 1) -> p : (etat' = 2) + (1 - p) : (etat' = 3);
	[] (etat = 2) -> (etat' = 0);
	[] (etat = 3) -> (etat' = 1);
endmodule

// Incrémente le nombre d'envois chaque fois que «envoyer» est atteint
rewards "nombre_envois"
	(etat = 1) : 1;
	(etat = 0 | etat = 2 | etat = 3) : 0;
endrewards

// Propositions atomiques
label "envoyer" = (etat = 1);
label "succes"  = (etat = 2);

// Requêtes des notes de cours
//  P>=1 [ F "succes" ]
//  P>=1 [ G "envoyer" => P>=0.99 [ F<=3 "succes" ] ]
//  P=?  [ F<=3 "succes" ]
//  R{"nombre_envois"}=? [ F "succes" ]
