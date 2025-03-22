// Phi2 (32)a2
p := 3;
F<a, a1, a2> := FreeGroup(3);

// Define the relations explicitly given in the presentation,
// including the trivial commutators that are omitted in a minimal presentation.
Comms := [
    (a1, a)=a1^p,    
    a1^p = a2,                     
    a^(p^3) = 1,             
    a2^p = 1,                      
   (a2, a)=1,
   (a2, a1)=1
   ];

// Define the quotient group from the presentation
Q := quo< F | Comms >;

// Compute the p-quotient of Q to a given class (here, 5)
G, phi := pQuotient(Q, p, 5);

// Define the subgroup H exactly as given in the presentation:
H_0 := sub< G | phi(a), phi(a1^p) >;
H_1 := sub< G | phi(a * a1^-1), phi(a1^p) >;
H_2 := sub< G | phi(a * a1^-2), phi(a1^p) >;
H_3 := sub< G | phi(a^p), phi(a1) >;

S := [ H_0, H_1, H_2, H_3];

// you need more than one subgroup for this case

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

ConstructRep(G, CG[2]);

RationalRepresentation(G, subs[4], CG[95]);