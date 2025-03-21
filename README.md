# Magma Code for Rational Representations  

This Magma script computes rational representations of a finite p-group using linear characters of its subgroups.  

### Functions  
 
- **ConstructRep(G, char)**: Constructs an irreducible rational representation of 'G' whose character value equals the Schur index times the sum of the Galois conjugates of 'char' over 'Q', where 'char' is a degree-one complex character of 'G'.  

- **RationalRepresentation(G, H, chi, Verify:=false)**: Constructs an irreducible rational matrix representation of 'G' from its subgroup 'H', where 'H' is one component of a required pair for constructing such a representation with a character value equal to the Schur index times the sum of the Galois conjugates of 'char' over 'Q'.

- **AllInequivalentRepresentations(G, subs, Inequivalent:=true)**: Computes all inequivalent irreducible rational representations of 'G' using its character table and 'subs', a collection of subgroups of 'G' that serve as one component of the required pairs for their construction. 

- **IsRequiredPair(G, H, char)**: Checks whether 'H' is a required constituent for constructing an irreducible rational matrix representation whose character value equals the Schur index times the sum of the Galois conjugates of 'char' over 'Q'.

