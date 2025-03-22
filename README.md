This repository contains the following preprint, along with related data and code:  

**R. K. Choudhary and S. K. Prajapati,** *On Matrix Representations of Groups of Order* `p^5` *over* `Q`.  

The preprint is available in **`Paper.pdf`**.  

The provided code is designed for use with **Magma**.  

---

### **`RationalRepsReqPairs.m`**  

This Magma script computes rational representations of a finite `p`-group using the linear characters of its subgroups.  

#### **Functions**  

- **`ConstructRep(G, char)`**: Constructs an irreducible rational representation of `G` whose character value equals the Schur index times the sum of the Galois conjugates of `char` over `Q`, where `char` is a degree-one complex character of `G`.  

- **`RationalRepresentation(G, H, chi)`**: Constructs an irreducible rational matrix representation of `G` from its subgroup `H`, where `H` is one component of a required pair for constructing such a representation with a character value equal to the Schur index times the sum of the Galois conjugates of `char` over `Q`.  

- **`AllInequivalentRepresentations(G, subs)`**: Computes all inequivalent irreducible rational representations of `G` using its character table and `subs`, a collection of subgroups of `G` that serve as one component of the required pairs for their construction.  

- **`IsRequiredPair(G, H, char)`**: Checks whether `H` is a component of a required pair for constructing an irreducible rational matrix representation whose character value equals the Schur index times the sum of the Galois conjugates of `char` over `Q`.  
