/- Copyright 2009-2026 EPFL, Lausanne -/
import Inox.Instances

/-!
# Facts that the clauses before them entail

A fact may follow from the base clauses and the clauses of the fresh-symbol steps alone, by
propositional reasoning that `verify` doesn't do: the value of a constant that a chain of
definitions gives, through the conclusions of implications whose premises hold. `entailed` decides
it by splitting on the values of a few Boolean constants, and, for each assignment, by making known
the literals that the clauses give (`clauseLits`), until the fact reduces to `true` or a clause to
`false`.
-/

namespace Inox

open Eo
open SmtEval
open Smtm
open Inox.Fresh
open Inox.Extend

/-- The literals that a term with the value `b` makes known, and, for an equality, those of one
side when the other side reduces to a Boolean under the literals `K`. -/
def eqLits (K : List (SmtTerm × Bool)) (t : SmtTerm) (b : Bool) : List (SmtTerm × Bool) :=
  lits t b ++ match t, b with
    | .eq x y, true =>
      (match red K y with
        | .Boolean v => lits x v
        | _ => []) ++
      (match red K x with
        | .Boolean v => lits y v
        | _ => [])
    | _, _ => []

/-- The literals that the clause `t`, which holds, makes known under the literals `K`: those of
the conclusion of an implication whose premise reduces to `true`, of the premise of one whose
conclusion reduces to `false`, or those of the clause. -/
def clauseLits (K : List (SmtTerm × Bool)) : SmtTerm → List (SmtTerm × Bool)
  | .imp a q =>
    (if red K a = .Boolean true then eqLits K q true ++ eqLits K (red K q) true else []) ++
      (if red K q = .Boolean false then lits a false else [])
  | t => eqLits K t true ++ eqLits K (red K t) true

/-- The literals `K`, with those that the clauses `C` make known, `n` times over. -/
def propagate (C : List SmtTerm) : Nat → List (SmtTerm × Bool) → List (SmtTerm × Bool)
  | 0, K => K
  | n + 1, K => propagate C n (withUnits (C.flatMap (clauseLits K) ++ K))

/-- The Boolean constants that are premises of implications in `t`. -/
def premises : SmtTerm → List SmtTerm
  | .imp a q => (match a with
      | .UConst s .Bool => [.UConst s .Bool]
      | _ => []) ++ premises a ++ premises q
  | .Apply f a => premises f ++ premises a
  | .and x y | .or x y | .eq x y => premises x ++ premises y
  | .not x => premises x
  | .ite c a b => premises c ++ premises a ++ premises b
  | _ => []

/-- `φ` holds, in the models of the defining equations `eqs` where the clauses `C` hold and the
literals `K` have their values, whatever the values of the Boolean terms `as`: under each of
their assignments, with the literals that the clauses then make known, `verify` accepts `φ` or a
clause reduces to `false`. -/
def entails (eqs : List Equation) (C : List SmtTerm) (n : Nat) (φ : SmtTerm) :
    List SmtTerm → List (SmtTerm × Bool) → Bool
  | [], K =>
    let K' := propagate C n K
    verify eqs K' φ || C.any fun c => decide (red K' c = .Boolean false)
  | a :: as, K =>
    decide (__smtx_typeof a = .Bool) &&
      entails eqs C n φ as ((a, true) :: K) && entails eqs C n φ as ((a, false) :: K)

/-- The fact `φ` follows from the clauses `C`, in the models of the defining equations `eqs`
where the literals `K` have their values, without splitting or by splitting on one of the Boolean
constants that are premises of implications in the clauses. -/
def entailedBy (eqs : List Equation) (C : List SmtTerm) (K : List (SmtTerm × Bool)) (φ : SmtTerm) :
    Bool :=
  let C := C.filter noBinder
  let n := 8
  noBinder φ &&
    (entails eqs C n φ [] K ||
      ((C.flatMap premises).eraseDups.any fun a => entails eqs C n φ [a] K))

/-! ## Soundness -/

/-- An equality that is true, with a side of the value of a Boolean, gives the other side that
value. -/
theorem eval_eq_bool {M : SmtModel} {x y : SmtTerm} {v : Bool}
    (h : __smtx_model_eval M (.eq x y) = SmtValue.Boolean true)
    (hy : __smtx_model_eval M y = SmtValue.Boolean v) :
    __smtx_model_eval M x = SmtValue.Boolean v := by
  simp only [__smtx_model_eval, hy] at h
  unfold __smtx_model_eval_eq at h
  split at h
  · next _ _ h2 => cases h2
  · simp only [native_veq, SmtValue.Boolean.injEq, decide_eq_true_eq] at h
    exact h

theorem eval_eq_symm {M : SmtModel} {x y : SmtTerm}
    (h : __smtx_model_eval M (.eq x y) = SmtValue.Boolean true)
    (hx : ∃ v, __smtx_model_eval M x = SmtValue.Boolean v) :
    __smtx_model_eval M (.eq y x) = SmtValue.Boolean true := by
  obtain ⟨v, hv⟩ := hx
  simp only [__smtx_model_eval, hv] at h ⊢
  unfold __smtx_model_eval_eq at h ⊢
  split at h
  · next _ _ h1 _ => cases h1
  · simp only [native_veq, SmtValue.Boolean.injEq, decide_eq_true_eq] at h
    split
    · next _ _ _ h2 => cases h2
    · simp [native_veq, h]

theorem kSound_eqLits (hty : LogosTyping) {M : SmtModel} (hwf : model_wf M)
    {K : List (SmtTerm × Bool)} (hK : KSound M K) {t : SmtTerm} {b : Bool}
    (h : __smtx_model_eval M t = SmtValue.Boolean b) : KSound M (eqLits K t b) := by
  unfold eqLits
  refine kSound_append (lits_sound t b h) ?_
  split
  · next x y =>
    refine kSound_append ?_ ?_
    · split
      · next v hv =>
        have hy : __smtx_model_eval M y = SmtValue.Boolean v := by
          rw [← eval_red hty hwf hK y, hv]; rfl
        exact lits_sound x v (eval_eq_bool h hy)
      · intro p hp; cases hp
    · split
      · next v hv =>
        have hx : __smtx_model_eval M x = SmtValue.Boolean v := by
          rw [← eval_red hty hwf hK x, hv]; rfl
        exact lits_sound y v (eval_eq_bool (eval_eq_symm h ⟨v, hx⟩) hx)
      · intro p hp; cases hp
  · intro p hp; cases hp

theorem imp_true {x y : SmtValue} (h : __smtx_model_eval_imp x y = SmtValue.Boolean true) :
    x = SmtValue.Boolean false ∨ y = SmtValue.Boolean true := by
  unfold __smtx_model_eval_imp at h
  rcases or_eq_true h with h | h
  · exact .inl (by simpa using not_eq h)
  · exact .inr h

theorem kSound_clauseLits (hty : LogosTyping) {M : SmtModel} (hwf : model_wf M)
    {K : List (SmtTerm × Bool)} (hK : KSound M K) {t : SmtTerm}
    (h : __smtx_model_eval M t = SmtValue.Boolean true) : KSound M (clauseLits K t) := by
  cases t
  case imp a q =>
    simp only [clauseLits]
    simp only [__smtx_model_eval] at h
    have ha := eval_red hty hwf hK a
    have hq := eval_red hty hwf hK q
    refine kSound_append ?_ ?_
    · split
      · next hr =>
        rw [hr] at ha
        have hq' : __smtx_model_eval M q = SmtValue.Boolean true := by
          rcases imp_true h with h' | h'
          · rw [← ha] at h'; cases h'
          · exact h'
        exact kSound_append (kSound_eqLits hty hwf hK hq') (kSound_eqLits hty hwf hK (hq.trans hq'))
      · intro p hp; cases hp
    · split
      · next hr =>
        rw [hr] at hq
        have ha' : __smtx_model_eval M a = SmtValue.Boolean false := by
          rcases imp_true h with h' | h'
          · exact h'
          · rw [← hq] at h'; cases h'
        exact lits_sound a false ha'
      · intro p hp; cases hp
  all_goals
    simp only [clauseLits]
    exact kSound_append (kSound_eqLits hty hwf hK h)
      (kSound_eqLits hty hwf hK ((eval_red hty hwf hK _).trans h))

theorem kSound_propagate (hty : LogosTyping) {M : SmtModel} (hwf : model_wf M) {C : List SmtTerm}
    (hC : ∀ c ∈ C, __smtx_model_eval M c = SmtValue.Boolean true) :
    ∀ (n : Nat) {K : List (SmtTerm × Bool)}, KSound M K → KSound M (propagate C n K)
  | 0, _, hK => hK
  | n + 1, K, hK => by
    refine kSound_propagate hty hwf hC n (kSound_withUnits hty hwf (kSound_append ?_ hK))
    intro p hp
    obtain ⟨c, hc, hp⟩ := List.mem_flatMap.mp hp
    exact kSound_clauseLits hty hwf hK (hC c hc) p hp

/-- What `entails` accepts holds. -/
theorem entails_sound (hty : LogosTyping) {eqs : List Equation} {M : SmtModel} (hM : Good eqs M)
    (hwf : model_wf M) {C : List SmtTerm}
    (hC : ∀ c ∈ C, __smtx_model_eval M c = SmtValue.Boolean true) {n : Nat} {φ : SmtTerm} :
    ∀ (as : List SmtTerm) {K : List (SmtTerm × Bool)}, KSound M K → entails eqs C n φ as K = true →
      __smtx_model_eval M φ = SmtValue.Boolean true
  | [], K, hK, h => by
    simp only [entails, Bool.or_eq_true, List.any_eq_true, decide_eq_true_eq] at h
    have hK' := kSound_propagate hty hwf hC n hK
    rcases h with h | ⟨c, hc, hr⟩
    · exact verify_sound hty hM hwf φ hK' h
    · have := eval_red hty hwf hK' c
      rw [hr, hC c hc] at this
      cases this
  | a :: as, K, hK, h => by
    simp only [entails, Bool.and_eq_true, decide_eq_true_eq] at h
    obtain ⟨⟨ha, ht⟩, hf⟩ := h
    obtain ⟨b, hb⟩ := eval_bool hty hwf ha
    have hK' : KSound M ((a, b) :: K) := by
      intro p hp
      rcases List.mem_cons.mp hp with rfl | hp
      · exact hb
      · exact hK p hp
    cases b
    · exact entails_sound hty hM hwf hC as hK' hf
    · exact entails_sound hty hM hwf hC as hK' ht

/-- What `entailedBy` accepts holds. -/
theorem entailedBy_sound (hty : LogosTyping) {eqs : List Equation} {M : SmtModel}
    (hM : Good eqs M) (hwf : model_wf M) {C : List SmtTerm}
    (hC : ∀ c ∈ C, __smtx_model_eval M c = SmtValue.Boolean true) {K : List (SmtTerm × Bool)}
    (hK : KSound M K) {φ : SmtTerm} (h : entailedBy eqs C K φ = true) :
    __smtx_model_eval M φ = SmtValue.Boolean true := by
  have hC' : ∀ c ∈ C.filter noBinder, __smtx_model_eval M c = SmtValue.Boolean true :=
    fun c hc => hC c (List.mem_of_mem_filter hc)
  simp only [entailedBy, Bool.and_eq_true, Bool.or_eq_true, List.any_eq_true] at h
  rcases h.2 with h | ⟨a, _, h⟩
  · exact entails_sound hty hM hwf hC' [] hK h
  · exact entails_sound hty hM hwf hC' [a] hK h

end Inox
