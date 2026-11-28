/- Copyright 2009-2026 EPFL, Lausanne -/
import Inox.Mono

/-!
# Fuel monotonicity of the generated evaluator, on every expression

`Inox/Mono.lean` proves that more fuel never changes another result than `OutOfFuel` for the
expressions of a first-order fragment. This module proves it of every expression, in every
program (`eval_mono_all`, `apply_mono_all`), where the oracle is sound: a closure applied with
more fuel has the same result, unless it ran out of fuel, whatever its body. A universal
quantifier is evaluated at every instance with the same fuel, so its result is that of its
instances (`Oracle.Sound.forall_result`), and the other answers of the oracle don't depend on the
fuel.
-/

namespace Inox.Bridge
open Inox.Semantics

section
variable {O : Oracle} {P : Program} {n m : Int}

theorem le_int {env : Env} {e : Expr} (h : Le (eval O P n env e) (eval O P m env e)) :
    Le (eval_int O P n env e) (eval_int O P m env e) := by
  rw [eval_int, eval_int]; le_step h; exact Le.refl _

theorem le_rm {env : Env} {e : Expr} (h : Le (eval O P n env e) (eval O P m env e)) :
    Le (eval_rm O P n env e) (eval_rm O P m env e) := by
  rw [eval_rm, eval_rm]; le_step h; exact Le.refl _

theorem le_string {env : Env} {e : Expr} (h : Le (eval O P n env e) (eval O P m env e)) :
    Le (eval_string O P n env e) (eval_string O P m env e) := by
  rw [eval_string, eval_string]; le_step h; exact Le.refl _

theorem le_bag {env : Env} {e : Expr} (h : Le (eval O P n env e) (eval O P m env e)) :
    Le (eval_bag O P n env e) (eval_bag O P m env e) := by
  rw [eval_bag, eval_bag]; le_step h; exact Le.refl _

theorem le_eval_list {env : Env} :
    ∀ {es : List Expr}, (∀ a ∈ es, Le (eval O P n env a) (eval O P m env a)) →
      Le (eval_list O P n env es) (eval_list O P m env es) :=
  fun h => le_list h

theorem le_bag_entries {env : Env} :
    ∀ {es : List ExprPair} (acc : List BagEntry),
      (∀ k c, ExprPair.ExprPair k c ∈ es →
        Le (eval O P n env k) (eval O P m env k) ∧ Le (eval O P n env c) (eval O P m env c)) →
      Le (eval_bag_entries O P n env acc es) (eval_bag_entries O P m env acc es)
  | [], acc, _ => by rw [eval_bag_entries, eval_bag_entries]; exact Le.refl _
  | .ExprPair k c :: rest, acc, h => by
    rw [eval_bag_entries, eval_bag_entries]
    have h1 := h k c List.mem_cons_self
    le_step h1.1
    le_step (le_int h1.2)
    split
    · exact le_bag_entries _ fun k c hm => h k c (List.mem_cons_of_mem _ hm)
    · exact Le.refl _
    · exact Le.refl _

theorem le_map_entries {env : Env} :
    ∀ {es : List ExprPair} (acc : List MapEntry),
      (∀ k c, ExprPair.ExprPair k c ∈ es →
        Le (eval O P n env k) (eval O P m env k) ∧ Le (eval O P n env c) (eval O P m env c)) →
      Le (eval_map_entries O P n env acc es) (eval_map_entries O P m env acc es)
  | [], acc, _ => by rw [eval_map_entries, eval_map_entries]; exact Le.refl _
  | .ExprPair k c :: rest, acc, h => by
    rw [eval_map_entries, eval_map_entries]
    have h1 := h k c List.mem_cons_self
    le_step h1.1
    le_step h1.2
    split
    · exact le_map_entries _ fun k c hm => h k c (List.mem_cons_of_mem _ hm)
    · exact Le.refl _
    · exact Le.refl _

theorem le_instance {env : Env} {ps : List Param} {body : Expr}
    (h : ∀ env', Le (eval O P n env' body) (eval O P m env' body)) (vs : List Value) :
    Le (instance_ O P n env ps vs body) (instance_ O P m env ps vs body) := by
  cases env
  simp only [instance_]
  split
  · exact h _
  · exact Le.refl _
  · exact Le.refl _

theorem le_forall (hO : O.Sound) {env : Env} {ps : List Param} {body : Expr}
    (h : ∀ env', Le (eval O P n env' body) (eval O P m env' body)) :
    Le (O.forall_result P n env ps body) (O.forall_result P m env ps body) := by
  have hi := le_instance (env := env) (ps := ps) h
  rw [hO.forall_result, hO.forall_result]
  split
  · next hA =>
    simp only [decide_eq_true_eq, Bool.and_eq_true] at hA
    obtain ⟨vs, h1, h2⟩ := hA
    split
    · exact Le.refl _
    · next hA' =>
      simp only [decide_eq_true_eq, Bool.and_eq_true] at hA'
      exact absurd ⟨vs, h1, (hi vs).ok h2⟩ hA'
  · next hA =>
    simp only [decide_eq_true_eq, Bool.and_eq_true] at hA
    split
    · exact Or.inl rfl
    · next hB =>
      simp only [decide_eq_true_eq, Bool.and_eq_true] at hB
      -- no instance is false or out of fuel with more fuel either
      have hA' : ¬ ∃ vs, O.params_have_types P env vs ps = true ∧
          instance_ O P m env ps vs body = .Ok (.BoolV false) := by
        intro ⟨vs, h1, h2⟩
        rcases hi vs with h3 | h3
        · exact hB ⟨vs, h1, h3⟩
        · exact hA ⟨vs, h1, h3 ▸ h2⟩
      have hB' : ¬ ∃ vs, O.params_have_types P env vs ps = true ∧
          instance_ O P m env ps vs body = .OutOfFuel := by
        intro ⟨vs, h1, h2⟩
        rcases hi vs with h3 | h3
        · exact hB ⟨vs, h1, h3⟩
        · exact hB ⟨vs, h1, h3 ▸ h2⟩
      have hiff : ∀ vs, O.params_have_types P env vs ps = true →
          instance_ O P m env ps vs body = instance_ O P n env ps vs body := by
        intro vs hp
        rcases hi vs with h3 | h3
        · exact absurd ⟨vs, hp, h3⟩ hB
        · exact h3
      split
      · next hC =>
        simp only [decide_eq_true_eq, Bool.or_eq_true, Bool.not_eq_true'] at hC
        split
        · next hA'' =>
          simp only [decide_eq_true_eq, Bool.and_eq_true] at hA''
          exact absurd hA'' hA'
        · split
          · next hB'' =>
            simp only [decide_eq_true_eq, Bool.and_eq_true] at hB''
            exact absurd hB'' hB'
          · split
            · exact Le.refl _
            · next hC' =>
              simp only [decide_eq_true_eq, Bool.or_eq_true, Bool.not_eq_true'] at hC'
              refine absurd (fun vs => ?_) hC'
              rcases hC vs with h1 | h1
              · exact .inl h1
              · cases hp : O.params_have_types P env vs ps
                · exact .inl rfl
                · exact .inr ((hiff vs hp).trans h1)
      · next hC =>
        simp only [decide_eq_true_eq, Bool.or_eq_true, Bool.not_eq_true'] at hC
        split
        · next hA'' =>
          simp only [decide_eq_true_eq, Bool.and_eq_true] at hA''
          exact absurd hA'' hA'
        · split
          · next hB'' =>
            simp only [decide_eq_true_eq, Bool.and_eq_true] at hB''
            exact absurd hB'' hB'
          · split
            · next hC' =>
              simp only [decide_eq_true_eq, Bool.or_eq_true, Bool.not_eq_true'] at hC'
              refine absurd (fun vs => ?_) hC
              rcases hC' vs with h1 | h1
              · exact .inl h1
              · cases hp : O.params_have_types P env vs ps
                · exact .inl rfl
                · exact .inr ((hiff vs hp).symm.trans h1)
            · exact Le.refl _

theorem le_call_of (hnm : n ≤ m)
    (hpred : 0 < n → ∀ e env, Le (eval O P (n - 1) env e) (eval O P (m - 1) env e))
    (f tps tenv vs) : Le (call O P n f tps tenv vs) (call O P m f tps tenv vs) := by
  by_cases h0 : n ≤ 0
  · exact call_zero h0 _ _ _ _
  have h1 : ¬m ≤ 0 := by omega
  cases P with
  | Program fs cs ss is eq =>
    rw [call, call, dite_eq_right_of_eq_false (eq_false h0),
      dite_eq_right_of_eq_false (eq_false h1)]
    dsimp only
    split
    · rename_i fd _
      obtain ⟨g, tparams, params, body⟩ := fd
      dsimp only
      split
      · exact hpred (by omega) _ _
      · exact Le.refl _
      · exact Le.refl _
    · exact Le.refl _
    · exact Le.refl _

theorem le_apply_of (hnm : n ≤ m)
    (hpred : 0 < n → ∀ e env, Le (eval O P (n - 1) env e) (eval O P (m - 1) env e))
    (f : Value) (vs : List Value) : Le (apply O P n f vs) (apply O P m f vs) := by
  unfold apply
  split
  · by_cases h0 : n ≤ 0
    · rw [dite_eq_left_of_eq_true (eq_true h0)]; exact Or.inl rfl
    · rw [dite_eq_right_of_eq_false (eq_false h0),
        dite_eq_right_of_eq_false (eq_false (by omega))]
      split
      · exact hpred (by omega) _ _
      · exact Le.refl _
      · exact Le.refl _
  · exact Le.refl _

set_option hygiene false in
/-- One step of the monotonicity proof of `eval`: the subexpressions are smaller than `s`. -/
macro "mono_auto" : tactic => `(tactic| repeat' (first
  | exact Le.refl _
  | exact Or.inl rfl
  | le_step (ih _ (by omega) _)
  | le_step (le_bool (ih _ (by omega) _))
  | le_step (le_int (ih _ (by omega) _))
  | le_step (le_set (ih _ (by omega) _))
  | le_step (le_bag (ih _ (by omega) _))
  | le_step (le_rm (ih _ (by omega) _))
  | le_step (le_string (ih _ (by omega) _))
  | le_step (le_list fun a ha => ih a (by have := List.sizeOf_lt_of_mem ha; omega) _)
  | le_step (le_bag_entries _ fun k c hm => by
      have h1 := List.sizeOf_lt_of_mem hm; rw [ExprPair.ExprPair.sizeOf_spec] at h1
      exact ⟨ih k (by omega) _, ih c (by omega) _⟩)
  | le_step (le_map_entries _ fun k c hm => by
      have h1 := List.sizeOf_lt_of_mem hm; rw [ExprPair.ExprPair.sizeOf_spec] at h1
      exact ⟨ih k (by omega) _, ih c (by omega) _⟩)
  | le_step (hpred (by omega) _ _)
  | le_step (hcall _ _ _ _)
  | le_step (happ _ _)
  | exact ih _ (by omega) _
  | exact hpred (by omega) _ _
  | exact hcall _ _ _ _
  | exact happ _ _
  | exact le_and fun a ha => ih a (by have := List.sizeOf_lt_of_mem ha; omega) _
  | exact le_or fun a ha => ih a (by have := List.sizeOf_lt_of_mem ha; omega) _
  | exact le_forall hO fun env' => ih _ (by omega) env'
  | rw [construct, construct]
  | split
  | (exfalso; omega)))

/-- Monotonicity of `eval` at fuels `n ≤ m`, given it at `n - 1` and `m - 1`. -/
theorem eval_step (hO : O.Sound) (hnm : n ≤ m)
    (hpred : 0 < n → ∀ e env, Le (eval O P (n - 1) env e) (eval O P (m - 1) env e)) :
    ∀ e env, Le (eval O P n env e) (eval O P m env e) := by
  have hcall := le_call_of hnm hpred
  have happ := le_apply_of hnm hpred
  suffices h : ∀ s, ∀ e : Expr, sizeOf e < s → ∀ env, Le (eval O P n env e) (eval O P m env e) from
    fun e => h _ e (Nat.lt_succ_self _)
  intro s
  induction s with
  | zero => intro e hs; omega
  | succ s ih =>
    intro e hs env
    cases e <;> (try simp at hs) <;> rw [eval, eval] <;> mono_auto

theorem eval_mono_all_k (hO : O.Sound) :
    ∀ k : Nat, ∀ n m : Int, n.toNat ≤ k → n ≤ m → ∀ e env,
      Le (eval O P n env e) (eval O P m env e)
  | 0 => fun _ _ hn hnm => eval_step hO hnm fun h => absurd h (by omega)
  | k + 1 => fun _ _ hn hnm =>
    eval_step hO hnm fun _ => eval_mono_all_k hO k _ _ (by omega) (by omega)

/-- Fuel monotonicity of `eval`: with more fuel, the result is the same unless it was
`OutOfFuel`. -/
theorem eval_mono_all (hO : O.Sound) (hnm : n ≤ m) (e : Expr) (env : Env) :
    Le (eval O P n env e) (eval O P m env e) :=
  eval_mono_all_k hO _ n m (Nat.le_refl _) hnm e env

theorem pred_mono_all (hO : O.Sound) (hnm : n ≤ m) :
    0 < n → ∀ e env, Le (eval O P (n - 1) env e) (eval O P (m - 1) env e) :=
  fun _ => eval_mono_all hO (by omega)

theorem call_mono_all (hO : O.Sound) (hnm : n ≤ m) (f tps tenv vs) :
    Le (call O P n f tps tenv vs) (call O P m f tps tenv vs) :=
  le_call_of hnm (pred_mono_all hO hnm) f tps tenv vs

theorem apply_mono_all (hO : O.Sound) (hnm : n ≤ m) (f : Value) (vs : List Value) :
    Le (apply O P n f vs) (apply O P m f vs) :=
  le_apply_of hnm (pred_mono_all hO hnm) f vs

/-- A closure applied to values has at most one result, whatever the fuel. -/
theorem apply_ok_unique (hO : O.Sound) {f : Value} {vs : List Value} {v v' : Value}
    (h : apply O P n f vs = .Ok v) (h' : apply O P m f vs = .Ok v') : v = v' := by
  rcases Int.le_total n m with hnm | hnm
  · have := (apply_mono_all hO hnm f vs).ok h; rw [h'] at this; cases this; rfl
  · have := (apply_mono_all hO hnm f vs).ok h'; rw [h] at this; cases this; rfl

end

end Inox.Bridge
