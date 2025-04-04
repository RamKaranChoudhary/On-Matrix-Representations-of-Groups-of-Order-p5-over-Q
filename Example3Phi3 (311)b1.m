// Phi3 (311)b1
 p := 3;
 F<a, a1, a2, a3> := FreeGroup(4);

 // Define the relations explicitly given in the presentation,
 // including the trivial commutators that are omitted in a minimal presentation.
 Comms := [
     (a1, a) = a2,
     (a2, a) = a3,
     (a3, a) = 1,
     a1^(p^2) = a3,
     a^p = 1,
     a2^p = 1,
     a3^p = 1,
    (a2, a1)=1,
    (a3, a1)=1,
    (a3, a2)=1
    ];

 // Define the quotient group from the presentation
 Q := quo< F | Comms >;

 // Compute the p-quotient of Q to a given class (here, 5)
 G, phi := pQuotient(Q, p, 5);

 // Define H
 D := DerivedGroup(G);
 H := Centraliser(G, D);

 // //the second is defined as per Theorem 19 (3) (b)
 H_1 := sub< G | phi(a), phi(a1^p), phi(a2)>;

 S := [ H, H_1];


 G, delta := MyPermRep(G);

subs := [delta (H) : H in S];
IdentifyGroup(G);
time M := AllInequivalentRepresentations(G, subs);
M;

CG := CharacterTable(G); // Stores the character table without displaying it
#CG; // Shows only the number of characters, not the full table

for i in [1..#CG] do
char := CG[i];

if Degree (char) eq 1 then continue;
end if;

for H in subs do
IsRequiredPair(G, H, char);
end for;
end for;

ConstructRep(G, CG[5]);

RationalRepresentation(G, subs[1], CG[45]);

RationalRepresentation(G, subs[2], CG[31]);

