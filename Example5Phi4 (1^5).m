// Phi4 (1^5)
 p := 3;
 F<a, a1, a2, b1, b2> := FreeGroup(5);

 // Define the relations explicitly given in the presentation,
 // including the trivial commutators that are omitted in a minimal presentation.
 Comms := [
     (a1, a) = b1,
     (a2, a) = b2,
     (b1, a) = 1,
     a^p = 1,
     a1^p = 1,
     a2^p = 1,
     b1^p = 1,
     b2^p = 1,
    (b2, a)=1,
    (a2, a1)=1,
    (b1, a1)=1,
    (b2, a1)=1,
    (b1, a2)=1,
    (b2, a2)=1,
    (b2, b1)=1
    ];

 // Define the quotient group from the presentation
 Q := quo< F | Comms >;

 // Compute the p-quotient of Q to a given class (here, 5)
 G, phi := pQuotient(Q, p, 5);

 // Define H similarly as explained in Example 13 as per Remark 13
 H_1 := sub< G | phi(a), phi(a1), phi(b1), phi(b2)>;
 H_2 := sub< G | phi(a), phi(a2), phi(b1), phi(b2)>;


 S := [ H_1, H_2];


 G, delta := MyPermRep(G);

subs := [delta (H) : H in S];
IdentifyGroup(G);

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

RationalRepresentation(G, subs[1], CG[36]);

RationalRepresentation(G, subs[2], CG[28]);
