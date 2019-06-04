include "wikidata";

def cleanup: with_entries(if .value == null then empty else . end);

{id} +
(
.claims | reduceClaims | {
	  P244, 
	  P267,
	  P493,
 	  P494, 
	  P498,
	  P563,
	  P591,
	  P605,
	  P667,
	  P686,
	  P691,
	  P791,
	  P863,
	  P918,
	  P919,
	  P959,
	  P1051,
	  P1055,
	  P1149,
	  P1273,
	  P1402,
	  P1668,
	  P1669,
	  P1796,
	  P1900,
	  P2004,
	  P2167,
	  P2179,
	  P2355,
	  P2357,
	  P2428,
	  P2456,
	  P3633,
	  P4096,
	  P4427,
	  P5081,
	  P5198,
	  P5221
	} | cleanup )