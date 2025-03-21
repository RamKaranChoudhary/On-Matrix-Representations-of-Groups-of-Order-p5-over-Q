// min degree perm rep for G 
MyPermRep := function (G)
   gamma, P := MinimalDegreePermutationRepresentation (G);
   return P, gamma;
end function;

// transveral consisting of powers of single element 
MyTransversal := function (G, N)
   n := #G div #N;
   repeat 
      t := Random (G); 
      reps := [t^i: i in [1..n - 1]];
   until forall{r: r in reps | r notin N};
   return [G.0] cat reps;
end function;

// Lemma 2 
// return rep for G which has character value 
// SchurIndex * &+GaloisOrbit of its supplied linear char 

ConstructRep := function (G, char)
   assert Degree (char) eq 1;

   N := Kernel (char);

   T, tau := Transversal (G, N);
   trans := #N eq #G select T else MyTransversal (G, N);
   if #T eq 1 then t := T[1]; else t := trans[2]; end if;

   CL := Classes (G);
   eta := ClassMap (G);
   zeta := char[eta (t)];
   f := AbsoluteMinimalPolynomial (zeta);
   m := CompanionMatrix (f);

   // set up image of Nx for x in transversal
   pos := [Position (T, tau (t)): t in trans];  
   im := [];
   for i in [1..#pos] do
      j := pos[i];
      im[j] := m^(i - 1);
   end for;

   reps := [CL[i][3]: i in [1..#CL]];
   TT := [Position (T, tau (reps[i])): i in [1..#CL]];
   V := [im[TT[i]]: i in [1..#CL]];
   
   si := SchurIndex (char);
   R := ClassFunctionSpace (G);
   psi := R![Trace (x): x in V];
   assert psi eq si * &+GaloisOrbit (char);

   n := #G div #N;
   s := EulerPhi (n);
   TT := [Position (T, tau (G.i)): i in [1..Ngens (G)]];
   images := [im[TT[i]]: i in [1..#TT]];

   M := GModule (G, images);
   Q := Rationals ();
   I := sub<GL(s, Q) | images>;
   I`UserGenerators := images;

   return M, I, psi; 
end function;

// Algorithm 3 
// both G and H are assumed to be permutation groups; 
// H is subgroup of G, one component of required pair;
// use linear character of H to construct rational representation A 
// of G with character equal to SchurIndex * &+GaloisOrbit of chi,
// an irreducible character of G; 
// return true, module, A, character of this representation 

RationalRepresentation := function (G, H, chi: Verify := false)
   CH := CharacterTable (H);
   index := [i : i in [1..#CH] | Degree (CH[i]) eq 1];
   
   // find linear character of H which induces to chi 
   found := false;
   for k in index do 
      char := CH[k];
      ind := Induction (char, G);
      // coefficient fields must coincide 
      if CoefficientField (char) ne CoefficientField (ind) then
         continue; 
      end if;
      if ind eq chi then found := true; break; end if;
   end for;
   if not found then return false, _, _, _; end if;

   M, I, psi := ConstructRep (H, char);
   if Verify then assert psi eq &+GaloisOrbit (char); end if;

   Psi := Induction (psi, G);
   if Verify then assert Psi eq &+GaloisOrbit (chi); end if;

   IM := Induction (M, G);
   act := ActionGenerators (IM);
   A := ActionGroup (IM);
   A`UserGenerators := act;

   if Verify then 
      tau := hom <G -> A | act>;
      K := Kernel (tau);
      assert #A * #K eq #G;
   end if;

   return true, IM, A, Psi;
end function;

// use MyCompare to remove copies which coincide 
DifferentOnes := function (S, MyCompare)
   if #S le 1 then return S, [i : i in [1..#S]]; end if;
   D := [S[1]];
   for i in [2..#S] do
     if forall {j : j in [1..#D] | c eq false where 
             _,c := InternalIsomorphismTest (S[i], D[j], false)} then 
             // IsIsomorphic (S[i], D[j]) eq false}  then 
        Append (~D, S[i]);
     end if;
   end for;
   pos := [Position (S, D[i]) : i in [1..#D]];
   return D, pos;
end function;

// construct all inequivalent rational representations of G;
// subs is collection of subgroups H, each is one component of 
// required pair for some non-linear character; 
// both G and H are perm groups
// if Inequivalent, then reduce up to equivalence 

AllInequivalentRepresentations := function (G, subs: Inequivalent := true)
   CL := Classes (G);
   CT := CharacterTable (G);

   // process linear characters of G 
   index := [i: i in [1..#CT] | Degree (CT[i]) eq 1];
   Mods := [ConstructRep (G, CT[i]): i in index];

   // process non-linear characters of G
   for j in [1..#CT] do
      if not j in index then 
         found := false;
         for ell in [1..#subs] do 
            H := subs[ell];
            found, M, A, Psi := RationalRepresentation (G, H, CT[j]);
            if found then break ell; end if;
         end for;
         if not found then error "No subgroup works for char ", j; end if;
         // assert Psi eq &+GaloisOrbit (CT[j]); 
         Append (~Mods, M);
      end if;
   end for;

   "Before equivalence test: dimensions of irreducible modules are ", 
       Multiset ([Dimension (x): x in Mods]);

   // determine inequivalent modules 
   if Inequivalent then 
      Reps := DifferentOnes (Mods, InternalIsomorphismTest);
      "After equivalence test: dimensions of irreducible modules are ", 
       Multiset ([Dimension (x): x in Reps]);
   else
      "Skip inequivalence tests";
      Reps := Mods;
   end if;

   // assert forall{r: r in Reps | IsIrreducible (r)};
   return Reps;
end function;

// Do H and char provide required pair?
IsRequiredPair := function (G, H, char)
   CL := Classes (G);
   found, M, A, Psi := RationalRepresentation (G, H, char);
   if not found then return false; end if;
   "Found repn of order", #A, "for non-linear irred char";
   tau := hom <G -> A | UserGenerators (A)>;
   tr := [Trace (tau (CL[i][3])): i in [1..#CL]];
   m := SchurIndex (char);
   flag := Psi eq m * &+GaloisOrbit (char);
   return flag;
end function;
