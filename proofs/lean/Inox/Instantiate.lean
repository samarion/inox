/- Copyright 2009-2026 EPFL, Lausanne -/
module

public import Cpc.Proofs.RuleSupport.InstantiateSupport
import all Cpc.Proofs.RuleSupport.InstantiateSupport

/-!
# Instances of universal quantifiers

A fact may be an instance of a universal quantifier: its body, with terms for its variables. Where
the quantifier is true, so is the instance (`instanceOf_sound`), by the theorem of Logos on its
rule `instantiate` (`InstantiateRule.instantiate_sound`), when the terms are of the sorts of the
variables. The terms are found by matching the body with the instance (`instArgs`), and the
instance is checked to be the substitution of Logos of the terms into the body. An instance of a
template of Inox has `(=> true ψ)` for the instance `ψ`, where the template's typing of the
variables was `true`, which is true where `ψ` is.

It is a module, which can import that theorem, a theorem of a module of Logos that isn't public.
-/

public section

namespace Inox.Instantiate

open Eo
open SmtEval
open Smtm
open SubstituteTranslatabilitySupport

set_option linter.internalConstructors false

/-- The elements of the list `t` of Eo. -/
def eoList : Term → List Term
  | .Apply (.Apply .__eo_List_cons t) ts => t :: eoList ts
  | _ => []

/-- The list of Eo of the terms `ts`. -/
def mkList : List Term → Term
  | [] => .__eo_List_nil
  | t :: ts => .Apply (.Apply .__eo_List_cons t) (mkList ts)

/-- The universal quantifiers that `t` has. -/
def foralls : Term → List Term
  | .Apply (.Apply (.UOp .forall) xs) F => .Apply (.Apply (.UOp .forall) xs) F :: foralls F
  | .Apply f a => foralls f ++ foralls a
  | _ => []

/-- The terms for the variables `acc`, with `G` for `F`. -/
def bindVar (acc : List (Term × Term)) (F G : Term) : Option (List (Term × Term)) :=
  match List.lookup F acc with
  | some u => if u = G then some acc else none
  | none => some ((F, G) :: acc)

/-- The terms for the variables `xs` that make `F` be `G`, after those of `acc`, if some do. -/
def eoMatch (xs : List Term) : List (Term × Term) → Term → Term → Option (List (Term × Term))
  | acc, .Apply f a, .Apply g b => (eoMatch xs acc f g).bind fun acc => eoMatch xs acc a b
  | acc, F, G => if F ∈ xs then bindVar acc F G else if F = G then some acc else none

/-- The terms for the variables of the quantifier `Q` of which `ψ` is the instance, if it is one. -/
def instArgs (Q ψ : Term) : Option Term :=
  match Q with
  | .Apply (.Apply (.UOp .forall) xs) F =>
    match eoMatch (eoList xs) [] F ψ with
    | some acc => ((eoList xs).mapM fun x => List.lookup x acc).map mkList
    | none => none
  | _ => none

/-- The terms `ts` are of the sorts of the variables `xs` (`SubstActualsHaveSmtTypes`). -/
def actualsOk : Term → Term → Bool
  | .Apply (.Apply .__eo_List_cons (.Var (.String _) T)) env,
    .Apply (.Apply .__eo_List_cons t) ts =>
    __smtx_type_wf (__eo_to_smt_type T) && decide (__smtx_typeof (__eo_to_smt t) ≠ .None) &&
      decide (__smtx_typeof (__eo_to_smt t) = __eo_to_smt_type T) && actualsOk env ts
  | .__eo_List_nil, _ => true
  | _, _ => false

theorem actualsOk_sound (xs ts : Term) (h : actualsOk xs ts = true) :
    SubstActualsHaveSmtTypes xs ts := by
  unfold actualsOk at h
  split at h
  · next _ T env t ts' =>
    simp only [Bool.and_eq_true, decide_eq_true_eq] at h
    obtain ⟨⟨⟨hw, ht⟩, hT⟩, hr⟩ := h
    exact .cons hw ht hT (actualsOk_sound env ts' hr)
  · exact .nil _
  · cases h
termination_by sizeOf xs

/-- The terms of the list `ts` have translations (`EoListAllHaveSmtTranslation`). -/
def allTranslate : Term → Bool
  | .__eo_List_nil => true
  | .Apply (.Apply .__eo_List_cons t) ts =>
    decide (__smtx_typeof (__eo_to_smt t) ≠ .None) && allTranslate ts
  | _ => false

theorem allTranslate_sound (ts : Term) (h : allTranslate ts = true) :
    EoListAllHaveSmtTranslation ts := by
  unfold allTranslate at h
  split at h
  · simp [EoListAllHaveSmtTranslation]
  · next t ts' =>
    simp only [Bool.and_eq_true, decide_eq_true_eq] at h
    exact ⟨h.1, allTranslate_sound ts' h.2⟩
  · cases h
termination_by sizeOf ts

/-- `ψ`, without the implication of it by `true` that an instance of a template of Inox has. -/
def unguard : Term → Term
  | .Apply (.Apply (.UOp .imp) (.Boolean true)) b => b
  | b => b

/-- `ψ` is an instance of the quantifier `Q`, maybe implied by `true`. -/
def instanceOf (Q ψ : Term) : Bool :=
  match Q with
  | .Apply (.Apply (.UOp .forall) xs) F =>
    match instArgs Q (unguard ψ) with
    | some ts =>
      decide (__smtx_typeof (__eo_to_smt Q) = .Bool) && allTranslate ts && actualsOk xs ts &&
        decide (__smtx_typeof (__eo_to_smt (unguard ψ)) = .Bool) &&
        decide (__substitute_simul_rec (.Boolean false) F xs ts .__eo_List_nil = unguard ψ) &&
        (decide (ψ = unguard ψ) ||
          decide (ψ = .Apply (.Apply (.UOp .imp) (.Boolean true)) (unguard ψ)))
    | none => false
  | _ => false

/-- An instance of a quantifier that is true is true. -/
theorem instanceOf_sound {M : SmtModel} (hM : model_wf M) {Q ψ : Term}
    (h : instanceOf Q ψ = true) (hQ : __smtx_model_eval M (__eo_to_smt Q) = .Boolean true) :
    __smtx_model_eval M (__eo_to_smt ψ) = .Boolean true := by
  unfold instanceOf at h
  split at h
  · rename_i xs F
    split at h
    · rename_i ts _
      simp only [Bool.and_eq_true, Bool.or_eq_true, decide_eq_true_eq] at h
      obtain ⟨⟨⟨⟨⟨hQty, hts⟩, hact⟩, hψty⟩, hsub⟩, hψ⟩ := h
      have hPrem : eo_interprets M (.Apply (.Apply (.UOp .forall) xs) F) true :=
        smt_interprets.intro_true M _ hQty hQ
      have hWf : RuleProofs.eo_has_smt_translation (.Apply (.Apply (.UOp .forall) xs) F) := by
        unfold RuleProofs.eo_has_smt_translation; rw [hQty]; simp
      have hRes : RuleProofs.eo_has_bool_type
          (__substitute_simul_rec (.Boolean false) F xs ts .__eo_List_nil) := by
        unfold RuleProofs.eo_has_bool_type; rw [hsub]; exact hψty
      have hI := InstantiateRule.instantiate_sound M hM xs F ts hPrem hWf
        (allTranslate_sound ts hts) (actualsOk_sound xs ts hact) hRes
      rw [hsub] at hI
      have hv : __smtx_model_eval M (__eo_to_smt (unguard ψ)) = .Boolean true := by
        cases hI; assumption
      rcases hψ with hψ | hψ
      · rw [hψ]; exact hv
      · rw [hψ]
        simp only [__eo_to_smt, __smtx_model_eval, hv]
        rfl
    · cases h
  · cases h

end Inox.Instantiate

end
