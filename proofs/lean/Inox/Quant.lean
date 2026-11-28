/- Copyright 2009-2026 EPFL, Lausanne -/
import Inox.Reach

/-!
# Quantifiers in the query

The fragment of `HasTy` has no binders: the bodies of the functions are substituted into, which
`eval_subst` (`Inox/Unfold.lean`) proves only of terms without binders. The query may have
universal quantifiers, which Inox translates to the negation of the existential quantifier of the
negation of the body, whose constants of the parameters are the bound variables (`tr`). They
appear as assumptions, which the translation leaves out. This module adds them to the
expressions of the query (`QTy e e'`): the Booleans `e'` of the fragment with assumptions around
Booleans, under conjunctions, disjunctions, negations and the branches of conditionals, where an
assumption is a Boolean of the fragment or the universal quantifier of one parameter, an integer,
a Boolean or a datatype whose fields are such values, whose body is (`Formula`).

The term of such an expression is that of `e'`, and so is its value where it has one
(`tr_of_q`, `eval_of_q`), so what the theorems on the query use of the agreement and of the calls
that the terms reach is that of `e'`. What is left is that the assumptions that its evaluation
goes through hold (`q_holds_of_assumes`), which needs the agreement of the quantifiers
(`ev_forall`). A quantifier is true in a model where its body is true at every value of the type
of its parameter, in the model where the bound variable has that value (`native_eval_exists`),
which is, by `eval_subst`, the body where the constant of the parameter has that value: a model
where the calls and the variables agree, for the environment where the parameter has the value of
Inox of that value. Inox's quantifier is true where its body is true at every value of the type
of its parameter (`Oracle.Sound.forall_result`), and the values of integers and Booleans are
those of the values of Logos of their sorts, as are those of datatypes whose fields are integers,
Booleans or such datatypes: a value of Logos of such a datatype is a constructor applied to values
of the sorts of its fields (`value_of_sort_k`), and Inox gives its values the type exactly when
the bridge does (`has_type_iff_k`). No assumption that the evaluation of the body of a
quantifier goes through is taken to hold, since it is evaluated at values that are not those of
the query.
-/

namespace Inox.Bridge

open Eo
open SmtEval
open Smtm
open Inox.Fresh
open Inox.Extend
open Inox.Model
open Inox.Semantics

/-! ## Terms without binders -/

theorem noBinder_andT : ∀ ts : List SmtTerm, (∀ t ∈ ts, noBinder t = true) →
    noBinder (andT ts) = true
  | [], _ => rfl
  | t :: ts, h => by
    simp only [andT, noBinder, Bool.and_eq_true]
    exact ⟨h t (.head _), noBinder_andT ts fun u hu => h u (.tail _ hu)⟩

theorem noBinder_orT : ∀ ts : List SmtTerm, (∀ t ∈ ts, noBinder t = true) →
    noBinder (orT ts) = true
  | [], _ => rfl
  | t :: ts, h => by
    simp only [orT, noBinder, Bool.and_eq_true]
    exact ⟨h t (.head _), noBinder_orT ts fun u hu => h u (.tail _ hu)⟩

theorem noBinder_spine : ∀ (us : List SmtTerm) (f : SmtTerm), noBinder f = true →
    (∀ u ∈ us, noBinder u = true) → noBinder (spine f us) = true
  | [], _, hf, _ => hf
  | a :: as, f, hf, h =>
    noBinder_spine as (.Apply f a) (by simp [noBinder, hf, h a (.head _)])
      fun u hu => h u (.tail _ hu)

theorem all_of_zip {α β : Type} {Q : α → Prop} : ∀ {l : List α} {m : List β},
    l.length = m.length → (∀ p ∈ l.zip m, Q p.1) → ∀ a ∈ l, Q a
  | [], _, _, _, _, ha => by cases ha
  | _ :: _, [], hl, _, _, _ => by simp at hl
  | a :: l, b :: m, hl, h, x, hx => by
    rcases List.mem_cons.mp hx with rfl | hx
    · exact h (x, b) (.head _)
    · exact all_of_zip (by simpa using hl) (fun p hp => h p (.tail _ hp)) x hx

variable {D : List Data}

/-- The term of an expression of the fragment has no binder. -/
theorem noBinder_tr {S : List Sig} {Γ : List (Id × Ty)} {e : Expr} {T : Ty}
    (h : HasTy D S Γ e T) : noBinder (tr D S Γ e) = true := by
  induction h with
  | var hx hT => simp [tr, hx, noBinder]
  | int i => rfl
  | bool b => rfl
  | @and es _ ih =>
    simp only [tr, trs_eq]
    exact noBinder_andT _ fun t ht => by
      obtain ⟨e, he, rfl⟩ := List.mem_map.mp ht
      exact ih e he
  | @or es _ ih =>
    simp only [tr, trs_eq]
    exact noBinder_orT _ fun t ht => by
      obtain ⟨e, he, rfl⟩ := List.mem_map.mp ht
      exact ih e he
  | @invoke s args hs hl _ ih =>
    simp only [tr, hs, trs_eq]
    refine noBinder_spine _ _ rfl fun t ht => ?_
    obtain ⟨e, he, rfl⟩ := List.mem_map.mp ht
    exact all_of_zip (Q := fun a => noBinder (tr D S Γ a) = true) (by simpa using hl) ih e he
  | assume _ _ _ ihb => simpa [tr] using ihb
  | @adt c d i fs args hc hl _ ih =>
    simp only [tr, hc, trs_eq]
    refine noBinder_spine _ _ rfl fun t ht => ?_
    obtain ⟨e, he, rfl⟩ := List.mem_map.mp ht
    exact all_of_zip (Q := fun a => noBinder (tr D S Γ a) = true) (by simpa using hl) ih e he
  | isCons hc _ ih => simpa [tr, hc, noBinder] using ih
  | sel hx _ ih => simpa [tr, hx, noBinder] using ih
  | frac _ => simp only [tr, lit, noBinder]; split <;> split <;> simp [noBinder]
  | setEmpty _ => simp [tr, trs, noBinder]
  | setOne _ ih => simpa [tr, trs, noBinder] using ih
  | _ => simp only [tr]; (try split) <;> (try split) <;> simp_all [noBinder]

/-! ## Models with a bound variable -/

theorem wf_push {M : SmtModel} (hw : model_wf M) (s : native_String) {T : SmtType}
    {w : SmtValue} (hT : __smtx_typeof_value w = T)
    (hc : __smtx_value_canonical M.usortDom w = true) :
    model_wf (native_model_push M s T w) := by
  obtain ⟨h1, h2, h3, h4⟩ := hw
  refine ⟨?_, ?_, h3, h4⟩
  · intro isVar s' T' hT'
    simp only [native_model_push]
    split
    · next hk =>
      simp only [SmtModelKey.mk.injEq] at hk
      rw [hk.2.2]; exact hT
    · exact h1 _ _ _ hT'
  · intro isVar s' T' hT'
    simp only [native_model_push]
    split
    · exact hc
    · exact h2 _ _ _ hT'

theorem lookup_push (M : SmtModel) (s : native_String) (T : SmtType) (w : SmtValue)
    (a : native_String) (A : SmtType) :
    native_model_lookup (native_model_push M s T w) a A = native_model_lookup M a A := by
  simp [native_model_lookup, native_model_push, model_key]

theorem var_push (M : SmtModel) (s : native_String) (T : SmtType) (w : SmtValue) :
    native_model_var_lookup (native_model_push M s T w) s T = w := by
  simp [native_model_var_lookup, native_model_push]

theorem model_eval_apply_push (M : SmtModel) (s : native_String) (T : SmtType) (w : SmtValue) :
    __smtx_model_eval_apply (native_model_push M s T w) = __smtx_model_eval_apply M := rfl

theorem applyAll_push (M : SmtModel) (s : native_String) (T : SmtType) (w : SmtValue) :
    ∀ fv ws, applyAll (native_model_push M s T w) fv ws = applyAll M fv ws
  | _, [] => rfl
  | fv, u :: ws => by
    simp only [applyAll]
    rw [model_eval_apply_push]
    exact applyAll_push M s T w _ ws

/-- The types that a quantifier may range over, and the fields of the datatypes that it may range
over: integers, Booleans and datatypes. -/
def simpleTy : Ty → Bool
  | .IntegerType | .BooleanType => true
  | .ADTType _ args => args.isEmpty
  | _ => false

/-- The fields of the datatypes `D` are of the types of `simpleTy`. -/
def simpleData (D : List Data) : Bool :=
  D.all fun d => d.ctors.all fun c => c.2.all fun f => simpleTy f.2

theorem simpleTy_field {D : List Data} (h : simpleData D = true) {d : Data} (hd : d ∈ D)
    {c : Id × List (Id × Ty)} (hc : c ∈ d.ctors) {f : Id × Ty} (hf : f ∈ c.2) :
    simpleTy f.2 = true := by
  simp only [simpleData, List.all_eq_true] at h
  exact h d hd c hc f hf

section Agree
variable {O : Oracle} {P : Program} {S : List Sig}

theorem callsOk_push {n : Int} {M : SmtModel} (hc : CallsOk O P D S n M) (s : native_String)
    (T : SmtType) (w : SmtValue) : CallsOk O P D S n (native_model_push M s T w) := by
  intro s' hs' tenv vs v hvs hcall
  have := hc s' hs' tenv vs v hvs hcall
  simp only [__smtx_model_eval] at this ⊢
  rw [applyAll_push, lookup_push]
  exact this

/-- What a quantifier asks of its parameter: an integer, a Boolean or a datatype whose fields, as
those of the datatypes they mention, are such values (`simpleTy`), not named after a function,
with a name that Logos doesn't reserve. -/
structure QBinder (D : List Data) (S : List Sig) (x : Id) (T : Ty) : Prop where
  ty : simpleTy T = true ∧ FragTy D T
  data : T = .IntegerType ∨ T = .BooleanType ∨ simpleData D = true
  fresh : ∀ s ∈ S, x ≠ s.name
  unreserved : Unreserved (nm x)

/-- The model `M` where the bound variable of `x` and the constant of `x` have the value `w`. -/
def boundModel (D : List Data) (M : SmtModel) (x : Id) (T : Ty) (w : SmtValue) : SmtModel :=
  setConsts (native_model_push M (nm x) (trT D T) w) [(nm x, trT D T, w)]

theorem bindingValues_bound (M : SmtModel) (x : Id) (T : Ty) (w : SmtValue) :
    bindingValues (native_model_push M (nm x) (trT D T) w) (boundSubst (ptys D [(x, T)])) =
      [(nm x, trT D T, w)] := by
  simp [bindingValues, boundSubst, ptys, __smtx_model_eval, var_push]

/-- The term of the body of a quantifier, with the bound variable for the constant of its
parameter, has, where the bound variable has the value `w`, the value of the term in the model
where the constant has it. -/
theorem eval_bound {S : List Sig} {x : Id} {T : Ty} (hB : QBinder D S x T) (M : SmtModel)
    (w : SmtValue) {Γ : List (Id × Ty)} {b : Expr} {U : Ty} (hb : HasTy D S ((x, T) :: Γ) b U) :
    __smtx_model_eval (native_model_push M (nm x) (trT D T) w)
        (substSmt (boundSubst (ptys D [(x, T)])) (tr D S ((x, T) :: Γ) b)) =
      __smtx_model_eval (boundModel D M x T w) (tr D S ((x, T) :: Γ) b) := by
  rw [eval_subst _ _ _ (noBinder_tr hb), bindingValues_bound]
  · rfl
  · intro e he
    simp only [boundSubst, ptys, List.map, List.mem_singleton] at he
    subst he
    exact ⟨hB.unreserved, rfl⟩

theorem wf_bound {M : SmtModel} (hw : model_wf M) (x : Id) (T : Ty) {w : SmtValue}
    (hT : __smtx_typeof_value w = trT D T) (hc : __smtx_value_canonical M.usortDom w = true) :
    model_wf (boundModel D M x T w) := by
  refine wf_setConsts (wf_push hw _ hT hc) ?_
  intro e he
  simp only [List.mem_singleton] at he
  subst he
  exact ⟨hT, hc⟩

theorem lookup_bound_other {M : SmtModel} {x : Id} {T : Ty} {w : SmtValue} {a : native_String}
    {A : SmtType} (h : ¬ (a = nm x ∧ A = trT D T)) :
    native_model_lookup (boundModel D M x T w) a A = native_model_lookup M a A := by
  rw [boundModel, lookup_setConsts]
  have : bindingOf [(nm x, trT D T, w)] a A = none := by
    simp only [bindingOf, List.find?_cons, List.find?_nil]
    split
    · next hk =>
      simp only [Bool.and_eq_true, beq_iff_eq] at hk
      exact absurd ⟨hk.1.symm, hk.2.symm⟩ h
    · rfl
  rw [this, lookup_push]

theorem lookup_bound_self (M : SmtModel) (x : Id) (T : Ty) (w : SmtValue) :
    native_model_lookup (boundModel D M x T w) (nm x) (trT D T) = w := by
  rw [boundModel, lookup_setConsts]
  simp [bindingOf]

theorem callsOk_bound {S : List Sig} {x : Id} {T : Ty} (hB : QBinder D S x T) {n : Int}
    {M : SmtModel} (hc : CallsOk O P D S n M) (w : SmtValue) :
    CallsOk O P D S n (boundModel D M x T w) := by
  intro s' hs' tenv vs v hvs hcall
  have := hc s' hs' tenv vs v hvs hcall
  simp only [__smtx_model_eval] at this ⊢
  rw [boundModel, applyAll_setConsts, applyAll_push, ← boundModel,
    lookup_bound_other (fun h => hB.fresh s' hs' (nm_inj h.1).symm)]
  exact this

/-- The environment of the body of a quantifier, at the value `u` of its parameter. -/
theorem envTy_bound {Γ : List (Id × Ty)} {tys : List TypeBinding} {vars : List Binding}
    (hE : EnvTy D Γ (.Env tys vars)) {x : Id} {T : Ty} {u : Value} (hu : HasV D u T) :
    EnvTy D ((x, T) :: Γ) (.Env tys (.Binding x u :: vars)) := by
  intro y U hy v hv
  rw [List.lookup_cons] at hy
  by_cases hyx : y = x
  · subst hyx
    simp only [beq_self_eq_true, Option.some.injEq] at hy
    subst hy
    simp only [env_vars, lookup_var, dite_true] at hv
    cases hv
    exact hu
  · have hne : (y == x) = false := by simp [hyx]
    rw [hne] at hy
    simp only [env_vars, lookup_var, hyx, dite_false] at hv
    exact hE y U hy v hv

theorem varsOk_bound {Γ : List (Id × Ty)} {tys : List TypeBinding} {vars : List Binding}
    {M : SmtModel} (hV : VarsOk D Γ (.Env tys vars) M) (x : Id) (T : Ty) (u : Value) :
    VarsOk D ((x, T) :: Γ) (.Env tys (.Binding x u :: vars)) (boundModel D M x T (trV D u)) := by
  intro y U hy v hv
  rw [List.lookup_cons] at hy
  by_cases hyx : y = x
  · subst hyx
    simp only [beq_self_eq_true, Option.some.injEq] at hy
    subst hy
    simp only [env_vars, lookup_var, dite_true] at hv
    cases hv
    simp only [__smtx_model_eval]
    exact lookup_bound_self _ _ _ _
  · have hne : (y == x) = false := by simp [hyx]
    rw [hne] at hy
    simp only [env_vars, lookup_var, hyx, dite_false] at hv
    simp only [__smtx_model_eval]
    rw [lookup_bound_other (fun h => hyx (nm_inj h.1))]
    exact hV y U hy v hv

end Agree

/-! ## Values of the parameters -/

/-- The sorts of the values of constructors, applied to some of their arguments. -/
def DtcTy : SmtType → Prop
  | .Datatype _ _ => True
  | .None => True
  | .DtcAppType _ U => DtcTy U
  | _ => False

theorem dtcTy_rec (s : native_String) (dd : SmtDatatypeDecl) :
    ∀ (d : SmtDatatype) (n : Nat), DtcTy (__smtx_typeof_dt_cons_value_rec (.Datatype s dd) d n)
  | .null, n => by cases n <;> simp [__smtx_typeof_dt_cons_value_rec, DtcTy]
  | .sum .unit d, 0 => by simp [__smtx_typeof_dt_cons_value_rec, DtcTy]
  | .sum (.cons U c) d, 0 => by
    simp only [__smtx_typeof_dt_cons_value_rec, DtcTy]
    exact dtcTy_rec s dd (.sum c d) 0
  | .sum c d, n + 1 => by
    simp only [__smtx_typeof_dt_cons_value_rec]
    exact dtcTy_rec s dd d n

/-- A value of the sort of a constructor applied to some of its arguments has the sort of a
constructor applied to more of them, or of a datatype. -/
theorem dtcTy_of_app : ∀ (v : SmtValue) {T U : SmtType},
    __smtx_typeof_value v = .DtcAppType T U → DtcTy U
  | .DtCons s dd n, T, U, h => by
    have := dtcTy_rec s dd (__smtx_dt_resolve (__smtx_dd_lookup s dd) dd) n
    simp only [__smtx_typeof_value] at h
    rw [h] at this
    exact this
  | .Apply f a, T, U, h => by
    simp only [__smtx_typeof_value] at h
    generalize hf : __smtx_typeof_value f = F at h
    cases F
    case DtcAppType A B =>
      have ih := dtcTy_of_app f hf
      simp only [__smtx_typeof_apply_value, __smtx_typeof_guard, native_ite, native_Teq] at h
      by_cases h1 : A = SmtType.None
      · simp [h1] at h
      · by_cases h2 : A = __smtx_typeof_value a
        · have h1' : decide (A = SmtType.None) = false := by simpa using h1
          have h2' : decide (A = __smtx_typeof_value a) = true := by simpa using h2
          simp only [h1', h2', Bool.false_eq_true, ↓reduceIte] at h
          subst h; exact ih
        · simp [h1, h2] at h
    all_goals simp [__smtx_typeof_apply_value] at h
  | .Binary w x, T, U, h => by
    simp only [__smtx_typeof_value, native_ite] at h; split at h <;> cases h
  | .Map m, T, U, h => by
    simp only [__smtx_typeof_value] at h
    rcases typeof_map_value_shape m with ⟨_, _, h'⟩ | h' <;> rw [h'] at h <;> cases h
  | .Set m, T, U, h => by
    simp only [__smtx_typeof_value] at h
    rcases typeof_map_value_shape m with ⟨A, B, h'⟩ | h' <;> rw [h'] at h
    · cases B <;> simp [__smtx_map_to_set_type] at h
    · simp [__smtx_map_to_set_type] at h
  | .Seq q, T, U, h => by
    simp only [__smtx_typeof_value] at h
    rcases typeof_seq_value_shape q with ⟨_, h'⟩ | h' <;> rw [h'] at h <;> cases h
  | .Char c, T, U, h => by
    simp only [__smtx_typeof_value, native_ite] at h; split at h <;> cases h
  | .NotValue, _, _, h | .Boolean _, _, _, h | .Numeral _, _, _, h | .Real _, _, _, h
  | .Fun _ _ _, _, _, h | .UValue _ _, _, _, h | .RegLan _, _, _, h => by
    simp [__smtx_typeof_value] at h

theorem dtcTy_apply (f a : SmtValue) : DtcTy (__smtx_typeof_value (.Apply f a)) := by
  simp only [__smtx_typeof_value]
  generalize hf : __smtx_typeof_value f = F
  cases F
  case DtcAppType A B =>
    have := dtcTy_of_app f hf
    simp only [__smtx_typeof_apply_value, __smtx_typeof_guard, native_ite, native_Teq]
    by_cases h1 : A = SmtType.None
    · simp [h1, DtcTy]
    · by_cases h2 : A = __smtx_typeof_value a
      · have h1' : decide (A = SmtType.None) = false := by simpa using h1
        have h2' : decide (A = __smtx_typeof_value a) = true := by simpa using h2
        simp only [h1', h2', Bool.false_eq_true, ↓reduceIte]
        exact this
      · simp [h1, h2, DtcTy]
  all_goals simp [__smtx_typeof_apply_value, DtcTy]

theorem int_of_typeof {w : SmtValue} (h : __smtx_typeof_value w = .Int) : ∃ i, w = .Numeral i := by
  cases w
  case Numeral i => exact ⟨i, rfl⟩
  case Apply f a => have := dtcTy_apply f a; rw [h] at this; exact this.elim
  case DtCons s dd n =>
    have := dtcTy_rec s dd (__smtx_dt_resolve (__smtx_dd_lookup s dd) dd) n
    simp only [__smtx_typeof_value] at h
    rw [h] at this; exact this.elim
  case Binary => simp only [__smtx_typeof_value, native_ite] at h; split at h <;> cases h
  case Map m =>
    simp only [__smtx_typeof_value] at h
    rcases typeof_map_value_shape m with ⟨_, _, h'⟩ | h' <;> rw [h'] at h <;> cases h
  case Set m =>
    simp only [__smtx_typeof_value] at h
    rcases typeof_map_value_shape m with ⟨A, B, h'⟩ | h' <;> rw [h'] at h
    · cases B <;> simp [__smtx_map_to_set_type] at h
    · simp [__smtx_map_to_set_type] at h
  case Seq q =>
    simp only [__smtx_typeof_value] at h
    rcases typeof_seq_value_shape q with ⟨_, h'⟩ | h' <;> rw [h'] at h <;> cases h
  case Char => simp only [__smtx_typeof_value, native_ite] at h; split at h <;> cases h
  all_goals simp [__smtx_typeof_value] at h

theorem bool_of_typeof {w : SmtValue} (h : __smtx_typeof_value w = .Bool) :
    ∃ b, w = .Boolean b := by
  cases w
  case Boolean b => exact ⟨b, rfl⟩
  case Apply f a => have := dtcTy_apply f a; rw [h] at this; exact this.elim
  case DtCons s dd n =>
    have := dtcTy_rec s dd (__smtx_dt_resolve (__smtx_dd_lookup s dd) dd) n
    simp only [__smtx_typeof_value] at h
    rw [h] at this; exact this.elim
  case Binary => simp only [__smtx_typeof_value, native_ite] at h; split at h <;> cases h
  case Map m =>
    simp only [__smtx_typeof_value] at h
    rcases typeof_map_value_shape m with ⟨_, _, h'⟩ | h' <;> rw [h'] at h <;> cases h
  case Set m =>
    simp only [__smtx_typeof_value] at h
    rcases typeof_map_value_shape m with ⟨A, B, h'⟩ | h' <;> rw [h'] at h
    · cases B <;> simp [__smtx_map_to_set_type] at h
    · simp [__smtx_map_to_set_type] at h
  case Seq q =>
    simp only [__smtx_typeof_value] at h
    rcases typeof_seq_value_shape q with ⟨_, h'⟩ | h' <;> rw [h'] at h <;> cases h
  case Char => simp only [__smtx_typeof_value, native_ite] at h; split at h <;> cases h
  all_goals simp [__smtx_typeof_value] at h

/-! ## Values of datatypes -/

theorem chainT_inj {s s' : native_String} {dd dd' : SmtDatatypeDecl} :
    ∀ {Us Vs : List SmtType}, chainT (.Datatype s dd) Us = chainT (.Datatype s' dd') Vs →
      s = s' ∧ dd = dd' ∧ Us = Vs
  | [], [], h => by simp only [chainT, SmtType.Datatype.injEq] at h; exact ⟨h.1, h.2, rfl⟩
  | [], _ :: _, h | _ :: _, [], h => by simp [chainT] at h
  | U :: Us, V :: Vs, h => by
    simp only [chainT, SmtType.DtcAppType.injEq] at h
    obtain ⟨h1, h2, h3⟩ := chainT_inj h.2
    exact ⟨h1, h2, by rw [h.1, h3]⟩

theorem chainT_shape (s : native_String) (dd : SmtDatatypeDecl) (Us : List SmtType) :
    chainT (.Datatype s dd) Us = .Datatype s dd ∨
      ∃ A B, chainT (.Datatype s dd) Us = .DtcAppType A B := by
  cases Us
  · exact .inl rfl
  · exact .inr ⟨_, _, rfl⟩

/-- A value of a datatype, or of a constructor applied to some of its fields, is a constructor
applied to values of the sorts of its fields. -/
theorem spine_of_typeof {s0 : native_String} {dd0 : SmtDatatypeDecl} :
    ∀ (w : SmtValue) (Us : List SmtType),
      __smtx_typeof_value w = chainT (.Datatype s0 dd0) Us →
      ∃ s dd i as Vs, w = applyVs (.DtCons s dd i) as ∧
        __smtx_typeof_value (.DtCons s dd i) = chainT (.Datatype s0 dd0) (Vs ++ Us) ∧
        List.Forall₂ (fun a V => __smtx_typeof_value a = V) as Vs
  | .DtCons s dd i, Us, h => ⟨s, dd, i, [], [], rfl, h, .nil⟩
  | .Apply f a, Us, h => by
    have hne := chainT_ne (T := .Datatype s0 dd0) (by simp) Us
    simp only [__smtx_typeof_value] at h
    generalize hf : __smtx_typeof_value f = F at h
    cases F
    case DtcAppType A B =>
      simp only [__smtx_typeof_apply_value, __smtx_typeof_guard, native_ite, native_Teq] at h
      by_cases h1 : A = SmtType.None
      · simp [h1] at h; exact absurd h.symm hne
      · by_cases h2 : A = __smtx_typeof_value a
        · have h1' : decide (A = SmtType.None) = false := by simpa using h1
          have h2' : decide (A = __smtx_typeof_value a) = true := by simpa using h2
          simp only [h1', h2', Bool.false_eq_true, ↓reduceIte] at h
          subst h
          obtain ⟨s, dd, i, as, Vs, rfl, hc, hs⟩ := spine_of_typeof f (A :: Us) (by rw [hf]; rfl)
          refine ⟨s, dd, i, as ++ [a], Vs ++ [A], (applyVs_snoc _ _ _).symm, ?_, ?_⟩
          · simpa using hc
          · exact forall₂_snoc hs h2.symm
        · simp [h1, h2] at h; exact absurd h.symm hne
    all_goals simp [__smtx_typeof_apply_value] at h; exact absurd h.symm hne
  | .Binary w x, Us, h => by
    simp only [__smtx_typeof_value, native_ite] at h
    rcases chainT_shape s0 dd0 Us with h' | ⟨_, _, h'⟩ <;> rw [h'] at h <;> split at h <;> cases h
  | .Map m, Us, h => by
    simp only [__smtx_typeof_value] at h
    rcases chainT_shape s0 dd0 Us with h' | ⟨_, _, h'⟩ <;> rw [h'] at h <;>
      rcases typeof_map_value_shape m with ⟨_, _, h''⟩ | h'' <;> rw [h''] at h <;> cases h
  | .Set m, Us, h => by
    simp only [__smtx_typeof_value] at h
    rcases chainT_shape s0 dd0 Us with h' | ⟨_, _, h'⟩ <;> rw [h'] at h <;>
      rcases typeof_map_value_shape m with ⟨A, B, h''⟩ | h'' <;> rw [h''] at h <;>
      first | (cases B <;> simp [__smtx_map_to_set_type] at h) | simp [__smtx_map_to_set_type] at h
  | .Seq q, Us, h => by
    simp only [__smtx_typeof_value] at h
    rcases chainT_shape s0 dd0 Us with h' | ⟨_, _, h'⟩ <;> rw [h'] at h <;>
      rcases typeof_seq_value_shape q with ⟨_, h''⟩ | h'' <;> rw [h''] at h <;> cases h
  | .Char c, Us, h => by
    simp only [__smtx_typeof_value, native_ite] at h
    rcases chainT_shape s0 dd0 Us with h' | ⟨_, _, h'⟩ <;> rw [h'] at h <;> split at h <;> cases h
  | .NotValue, Us, h | .Boolean _, Us, h | .Numeral _, Us, h | .Real _, Us, h
  | .Fun _ _ _, Us, h | .UValue _ _, Us, h | .RegLan _, Us, h => by
    simp only [__smtx_typeof_value] at h
    rcases chainT_shape s0 dd0 Us with h' | ⟨_, _, h'⟩ <;> rw [h'] at h <;> cases h

theorem sizeOf_le_applyVs : ∀ (as : List SmtValue) (f : SmtValue), sizeOf f ≤ sizeOf (applyVs f as)
  | [], f => by simp [applyVs]
  | a :: as, f => by
    have := sizeOf_le_applyVs as (.Apply f a)
    simp only [applyVs, List.foldl_cons] at this ⊢
    simp only [SmtValue.Apply.sizeOf_spec] at this
    omega

theorem sizeOf_lt_applyVs : ∀ (as : List SmtValue) (f : SmtValue) {a : SmtValue}, a ∈ as →
    sizeOf a < sizeOf (applyVs f as)
  | [], _, _, h => by cases h
  | b :: as, f, a, h => by
    rcases List.mem_cons.mp h with rfl | h
    · have := sizeOf_le_applyVs as (.Apply f a)
      simp only [applyVs, List.foldl_cons] at this ⊢
      simp only [SmtValue.Apply.sizeOf_spec] at this
      omega
    · exact sizeOf_lt_applyVs as (.Apply f b) h

theorem forall₂_imp_mem2 {α β : Type} {R Q : α → β → Prop} :
    ∀ {l : List α} {m : List β}, List.Forall₂ R l m → (∀ a ∈ l, ∀ b ∈ m, R a b → Q a b) →
      List.Forall₂ Q l m
  | [], [], _, _ => .nil
  | _ :: _, _ :: _, .cons h hs, f =>
    .cons (f _ (.head _) _ (.head _) h)
      (forall₂_imp_mem2 hs fun a ha b hb => f a (.tail _ ha) b (.tail _ hb))

theorem values_of_forall₂ {D : List Data} : ∀ {as : List SmtValue} {Ts : List Ty},
    List.Forall₂ (fun a T => ∃ u, trV D u = a ∧ HasV D u T) as Ts →
    ∃ us, us.map (trV D) = as ∧ List.Forall₂ (HasV D) us Ts
  | [], [], .nil => ⟨[], rfl, .nil⟩
  | _ :: _, _ :: _, .cons ⟨u, hu, hT⟩ hs => by
    obtain ⟨us, rfl, hus⟩ := values_of_forall₂ hs
    exact ⟨u :: us, by simp [hu], .cons hT hus⟩

/-- A value of Logos of the sort of a type of `simpleTy`, in datatypes whose fields are of such
types, is that of a value of Inox of the type. -/
theorem value_of_sort_k {D : List Data} (hD : DataOk D) (hsd : simpleData D = true) :
    ∀ (k : Nat) (w : SmtValue) (T : Ty), sizeOf w < k → simpleTy T = true → FragTy D T →
      __smtx_typeof_value w = trT D T → ∃ u, trV D u = w ∧ HasV D u T
  | 0, _, _, h, _, _, _ => by omega
  | k + 1, w, T, hk, hs, hT, h => by
    cases T <;> simp only [simpleTy, List.isEmpty_iff] at hs <;> try cases hs
    · obtain ⟨i, rfl⟩ := int_of_typeof h
      exact ⟨.IntV i, rfl, trivial⟩
    · obtain ⟨b, rfl⟩ := bool_of_typeof h
      exact ⟨.BoolV b, rfl, trivial⟩
    · rename_i s
      simp only [FragTy, Option.isSome_iff_exists] at hT
      obtain ⟨d, hfd⟩ := hT
      obtain ⟨hd, rfl⟩ := findData_spec hfd
      rw [trT_data hD hd] at h
      obtain ⟨s', dd, i, as, Vs, rfl, hc, has⟩ :=
        spine_of_typeof (s0 := nm d.name) (dd0 := d.decl) w [] h
      simp only [List.append_nil, __smtx_typeof_value, cons_value_rec] at hc
      cases hcf : ctorFields (__smtx_dt_resolve (__smtx_dd_lookup s' dd) dd) i with
      | none =>
        rw [hcf] at hc
        exact absurd hc.symm (chainT_ne (by simp) Vs)
      | some Fs =>
        rw [hcf] at hc
        obtain ⟨rfl, rfl, rfl⟩ := chainT_inj hc
        rw [ctorFields_data hD hd] at hcf
        cases hci : d.ctors[i]? with
        | none => rw [hci] at hcf; cases hcf
        | some cf =>
          obtain ⟨c, fs⟩ := cf
          rw [hci] at hcf
          simp only [Option.map_some, Option.some.injEq] at hcf
          subst hcf
          have hcD := findCtor_of hD hd hci
          have hmem : (c, fs) ∈ d.ctors := List.mem_of_getElem? hci
          have hall : List.Forall₂ (fun a T => ∃ u, trV D u = a ∧ HasV D u T) as
              (fs.map Prod.snd) := by
            rw [List.forall₂_map_right_iff] at has ⊢
            refine forall₂_imp_mem2 has fun a ha f hf hR => ?_
            have := sizeOf_lt_applyVs as (.DtCons (nm d.name) d.decl i) ha
            exact value_of_sort_k hD hsd k a f.2 (by omega) (simpleTy_field hsd hd hmem hf)
              (hD.fields d hd _ hmem f hf) hR
          obtain ⟨us, rfl, hus⟩ := values_of_forall₂ hall
          refine ⟨.ADTV c [] us, ?_, hasV_adt hcD hus⟩
          simp only [trV, hcD, trVs_eq]

theorem pht_iff {O : Oracle} (hO : O.Sound) {P : Program} {D : List Data} {k : Nat}
    (ih : ∀ u T env, sizeOf u < k → simpleTy T = true → FragTy D T →
      (O.has_type P env u T = true ↔ HasV D u T)) :
    ∀ (vs : List Value) (fs : List (Id × Ty)) (env : Env), (∀ v ∈ vs, sizeOf v < k) →
      (∀ f ∈ fs, simpleTy f.2 = true ∧ FragTy D f.2) →
      (O.params_have_types P env vs (fs.map fun f => .Param f.1 f.2) = true ↔
        HasVs D vs (fs.map Prod.snd))
  | [], [], _, _, _ => by simp [hO.params_have_types, HasVs]
  | [], _ :: _, _, _, _ => by simp [hO.params_have_types, HasVs]
  | _ :: _, [], _, _, _ => by simp [hO.params_have_types, HasVs]
  | v :: vs, f :: fs, env, hv, hf => by
    rw [hO.params_have_types]
    simp only [List.map_cons, HasVs, Bool.and_eq_true]
    rw [ih v f.2 env (hv v (.head _)) (hf f (.head _)).1 (hf f (.head _)).2,
      pht_iff hO ih vs fs _ (fun w hw => hv w (.tail _ hw)) (fun g hg => hf g (.tail _ hg))]

/-- The values of Inox of a type of `simpleTy`, in datatypes whose fields are of such types, are
those that the bridge gives the type. -/
theorem has_type_iff_k {O : Oracle} (hO : O.Sound) {D : List Data} (hD : DataOk D)
    (hsd : simpleData D = true) {P : Program} (hPD : ProgData D P) :
    ∀ (k : Nat) (u : Value) (T : Ty) (env : Env), sizeOf u < k → simpleTy T = true →
      FragTy D T → (O.has_type P env u T = true ↔ HasV D u T)
  | 0, _, _, _, h, _, _ => by omega
  | k + 1, u, T, env, hk, hs, hT => by
    cases T <;> simp only [simpleTy, List.isEmpty_iff] at hs <;> try cases hs
    · rw [hO.has_type]; cases u <;> simp [HasV]
    · rw [hO.has_type]; cases u <;> simp [HasV]
    · rename_i s
      cases u
      case ADTV c tps vs =>
        have hv : ∀ v ∈ vs, sizeOf v < k := fun v hv => by
          have := List.sizeOf_lt_of_mem hv
          simp only [Value.ADTV.sizeOf_spec] at hk
          omega
        cases P with
        | Program fns cs ss is eq =>
        rw [hO.has_type]
        simp only [HasV]
        cases hl : lookup_ctor cs c with
        | Ok kc =>
          obtain ⟨d, i, fs, hc⟩ := hPD.2 c kc hl
          obtain ⟨hlc, hls⟩ := hPD.1 c d i fs hc
          obtain ⟨hd, hi⟩ := findCtor_spec hc
          have hmem : (c, fs) ∈ d.ctors := List.mem_of_getElem? hi
          have hf : ∀ f ∈ fs, simpleTy f.2 = true ∧ FragTy D f.2 := fun f hf =>
            ⟨simpleTy_field hsd hd hmem hf, hD.fields d hd _ hmem f hf⟩
          rw [hlc] at hl
          cases hl
          by_cases hsn : s = d.name
          · subst hsn
            simp only [hls, decide_true, Bool.true_and, Bool.and_true, Bool.and_eq_true,
              decide_eq_true_eq, hO.resolve_all]
            rw [pht_iff hO (has_type_iff_k hO hD hsd hPD k) vs fs _ hv hf]
            constructor
            · intro ⟨h1, h2⟩
              exact ⟨h1, d, i, fs, hc, rfl, h2⟩
            · intro ⟨h1, d', i', fs', hc', _, h2⟩
              rw [hc] at hc'
              cases hc'
              exact ⟨h1, h2⟩
          · constructor
            · intro h
              simp only at h
              split at h
              · simp only [hsn, decide_false, Bool.false_and] at h
                cases h
              · cases h
            · intro ⟨_, d', i', fs', hc', hn, _⟩
              rw [hc] at hc'
              cases hc'
              exact absurd hn.symm hsn
        | _ =>
          constructor
          · intro h; simp at h
          · intro ⟨_, d', i', fs', hc', _, _⟩
            obtain ⟨hlc, _⟩ := hPD.1 c d' i' fs' hc'
            rw [hlc] at hl
            cases hl
      all_goals rw [hO.has_type]; simp [HasV]

/-! ## The agreement -/

section Agree
variable {O : Oracle} {P : Program} {S : List Sig}

theorem pht_one (hO : O.Sound) (P : Program) (env : Env) (x : Id) (T : Ty) (vs : List Value) :
    O.params_have_types P env vs [.Param x T] = true ↔
      ∃ u, vs = [u] ∧ O.has_type P env u T = true := by
  rw [hO.params_have_types]
  cases vs with
  | nil => simp
  | cons u rest =>
    cases rest with
    | nil => simp [hO.params_have_types]
    | cons _ _ => simp [hO.params_have_types]

theorem hasV_of_has_type (hO : O.Sound) (hD : DataOk D) {P : Program} (hPD : ProgData D P)
    {env : Env} {x : Id} {T : Ty} (hB : QBinder D S x T) {u : Value}
    (h : O.has_type P env u T = true) : HasV D u T := by
  rcases hB.data with rfl | rfl | hsd
  · rw [hO.has_type] at h; cases u <;> simp_all [HasV]
  · rw [hO.has_type] at h; cases u <;> simp_all [HasV]
  · exact (has_type_iff_k hO hD hsd hPD _ u T env (Nat.lt_succ_self _) hB.ty.1 hB.ty.2).mp h

/-- A value of Logos of the sort of the type of the parameter of a quantifier is that of a value
of Inox of its type. -/
theorem value_of_typeof (hO : O.Sound) (hD : DataOk D) {P : Program} (hPD : ProgData D P)
    (env : Env) {x : Id} {T : Ty} (hB : QBinder D S x T) {w : SmtValue}
    (h : __smtx_typeof_value w = trT D T) :
    ∃ u, trV D u = w ∧ HasV D u T ∧ O.has_type P env u T = true := by
  rcases hB.data with rfl | rfl | hsd
  · obtain ⟨i, rfl⟩ := int_of_typeof h
    exact ⟨.IntV i, rfl, trivial, by rw [hO.has_type]⟩
  · obtain ⟨b, rfl⟩ := bool_of_typeof h
    exact ⟨.BoolV b, rfl, trivial, by rw [hO.has_type]⟩
  · obtain ⟨u, hu, hv⟩ := value_of_sort_k hD hsd _ w T (Nat.lt_succ_self _) hB.ty.1 hB.ty.2 h
    exact ⟨u, hu, hv,
      (has_type_iff_k hO hD hsd hPD _ u T env (Nat.lt_succ_self _) hB.ty.1 hB.ty.2).mpr hv⟩

theorem instance_one (env : Env) (x : Id) (T : Ty) (u : Value) (b : Expr) (n : Int) :
    instance_ O P n env [.Param x T] [u] b =
      eval O P n (.Env (env_types env) (.Binding x u :: env_vars env)) b := by
  cases env
  simp [instance_, param_ids, bind_all, append_env, env_types, env_vars]

theorem tr_forall (Γ : List (Id × Ty)) (x : Id) (T : Ty) (b : Expr) :
    tr D S Γ (.Forall [.Param x T] b) =
      .not (.exists (nm x) (trT D T) (.not (substSmt (boundSubst (ptys D [(x, T)]))
        (tr D S ((x, T) :: Γ) b)))) := by
  simp [tr, paramPairs, exs, ptys]

theorem eval_not_def (M : SmtModel) (t : SmtTerm) :
    __smtx_model_eval M (.not t) = __smtx_model_eval_not (__smtx_model_eval M t) := by
  simp only [__smtx_model_eval]

theorem eval_exists_true {M : SmtModel} {s : native_String} {T : SmtType} {body : SmtTerm}
    (w : SmtValue) (hT : __smtx_typeof_value w = T)
    (hc : __smtx_value_canonical M.usortDom w = true)
    (hv : __smtx_model_eval (native_model_push M s T w) body = .Boolean true) :
    __smtx_model_eval M (.exists s T body) = .Boolean true := by
  classical
  show (if _ : (∃ w : SmtValue, __smtx_typeof_value w = T ∧
      __smtx_value_canonical M.usortDom w = true ∧
      __smtx_model_eval (native_model_push M s T w) body = .Boolean true)
    then SmtValue.Boolean true else SmtValue.Boolean false) = _
  rw [dite_eq_left ⟨w, hT, hc, hv⟩]

theorem eval_exists_false {M : SmtModel} {s : native_String} {T : SmtType} {body : SmtTerm}
    (h : ∀ w, __smtx_typeof_value w = T → __smtx_value_canonical M.usortDom w = true →
      __smtx_model_eval (native_model_push M s T w) body ≠ .Boolean true) :
    __smtx_model_eval M (.exists s T body) = .Boolean false := by
  classical
  show (if _ : (∃ w : SmtValue, __smtx_typeof_value w = T ∧
      __smtx_value_canonical M.usortDom w = true ∧
      __smtx_model_eval (native_model_push M s T w) body = .Boolean true)
    then SmtValue.Boolean true else SmtValue.Boolean false) = _
  rw [dite_eq_right (fun ⟨w, hT, hc, hv⟩ => h w hT hc hv)]

/-- The agreement of a universal quantifier. -/
theorem ev_forall (hO : O.Sound) (hS : SigOk D S) (hPD : ProgData D P) {n : Int}
    {Γ : List (Id × Ty)} {x : Id}
    {T : Ty} {b : Expr} (hB : QBinder D S x T) (hb : HasTy D S ((x, T) :: Γ) b .BooleanType)
    (ih : Ev O P D S n ((x, T) :: Γ) b .BooleanType) :
    Ev O P D S n Γ (.Forall [.Param x T] b) .BooleanType := by
  intro env v hE he
  cases env with
  | Env tys vars =>
  rw [eval, hO.forall_result] at he
  split at he
  · next h1 =>
    simp only [decide_eq_true_eq] at h1
    obtain ⟨vs, hvs⟩ := h1
    simp only [Bool.and_eq_true, decide_eq_true_eq] at hvs
    obtain ⟨hp, hi⟩ := hvs
    obtain ⟨u, rfl, hu⟩ := (pht_one hO P _ x T vs).1 hp
    cases he
    have huT : HasV D u T := hasV_of_has_type hO hS.data hPD hB hu
    rw [instance_one] at hi
    obtain ⟨_, hM⟩ := ih _ _ (envTy_bound hE huT) hi
    refine ⟨trivial, fun M hw hc hV => ?_⟩
    have hty := typed_trV hS.data M (nm x) huT
    rw [tr_forall, eval_not_def, eval_exists_true (trV D u) hty.1 hty.2]
    · rfl
    rw [eval_not_def, eval_bound hB M _ hb, hM _ (wf_bound hw x T hty.1 hty.2)
      (callsOk_bound hB hc _) (varsOk_bound hV x T u)]
    rfl
  · split at he
    · cases he
    split at he
    · next h3 =>
      cases he
      refine ⟨trivial, fun M hw hc hV => ?_⟩
      rw [tr_forall, eval_not_def, eval_exists_false]
      · rfl
      intro w hwT hwc hwv
      obtain ⟨u, rfl, huT, hu⟩ := value_of_typeof hO hS.data hPD (.Env tys vars) hB hwT
      simp only [decide_eq_true_eq] at h3
      have hi := h3 [u]
      rw [(pht_one hO P _ x T [u]).2 ⟨u, rfl, hu⟩] at hi
      simp only [Bool.not_true, Bool.false_or, decide_eq_true_eq] at hi
      rw [instance_one] at hi
      obtain ⟨_, hM⟩ := ih _ _ (envTy_bound hE huT) hi
      rw [eval_not_def, eval_bound hB M _ hb, hM _ (wf_bound hw x T hwT hwc) (callsOk_bound hB hc _)
        (varsOk_bound hV x T u)] at hwv
      simp [trV, __smtx_model_eval_not, native_not] at hwv
    · cases he

end Agree

/-! ## The expressions of the query -/

/-- The assumptions of the query: the Booleans of the fragment, and the universal quantifiers of
one parameter whose bodies are. -/
inductive Formula (D : List Data) (S : List Sig) (Γ : List (Id × Ty)) : Expr → Prop where
  | leaf {p : Expr} : HasTy D S Γ p .BooleanType → Formula D S Γ p
  | forall_ {x : Id} {T : Ty} {b : Expr} : QBinder D S x T →
      HasTy D S ((x, T) :: Γ) b .BooleanType → Formula D S Γ (.Forall [.Param x T] b)

/-- The expressions of the query: `QTy e e'` where `e` is the Boolean `e'` of the fragment with
assumptions (`Formula`) around Booleans, under conjunctions, disjunctions, negations and the
branches of conditionals. The term of `e` is that of `e'`, and so is its value where it has one. -/
inductive QTy (D : List Data) (S : List Sig) (Γ : List (Id × Ty)) : Expr → Expr → Prop where
  | leaf {e : Expr} : HasTy D S Γ e .BooleanType → QTy D S Γ e e
  | assume {p b b' : Expr} : Formula D S Γ p → QTy D S Γ b b' → QTy D S Γ (.Assume p b) b'
  | ite {c a a' b b' : Expr} : HasTy D S Γ c .BooleanType → QTy D S Γ a a' → QTy D S Γ b b' →
      QTy D S Γ (.IfExpr c a b) (.IfExpr c a' b')
  | and {es es' : List Expr} : es.length = es'.length → (∀ q ∈ es.zip es', QTy D S Γ q.1 q.2) →
      QTy D S Γ (.And es) (.And es')
  | or {es es' : List Expr} : es.length = es'.length → (∀ q ∈ es.zip es', QTy D S Γ q.1 q.2) →
      QTy D S Γ (.Or es) (.Or es')
  | not {a a' : Expr} : QTy D S Γ a a' → QTy D S Γ (.Not a) (.Not a')

theorem exists_zip_right {α β : Type} :
    ∀ {l : List α} {m : List β}, l.length = m.length → ∀ {b : β}, b ∈ m → ∃ a, (a, b) ∈ l.zip m
  | [], [], _, _, hb => by simp at hb
  | [], _ :: _, hl, _, _ => by simp at hl
  | _ :: _, [], hl, _, _ => by simp at hl
  | a :: l, b' :: m, hl, b, hb => by
    rcases List.mem_cons.mp hb with rfl | hb
    · exact ⟨a, by simp⟩
    · obtain ⟨a', ha'⟩ := exists_zip_right (l := l) (by simpa using hl) hb
      exact ⟨a', by simp [ha']⟩

theorem exists_zip_left {α β : Type} :
    ∀ {l : List α} {m : List β}, l.length = m.length → ∀ {a : α}, a ∈ l → ∃ b, (a, b) ∈ l.zip m
  | [], [], _, _, ha => by simp at ha
  | [], _ :: _, hl, _, _ => by simp at hl
  | _ :: _, [], hl, _, _ => by simp at hl
  | a' :: l, b :: m, hl, a, ha => by
    rcases List.mem_cons.mp ha with rfl | ha
    · exact ⟨b, by simp⟩
    · obtain ⟨b', hb'⟩ := exists_zip_left (l := l) (m := m) (by simpa using hl) ha
      exact ⟨b', by simp [hb']⟩

theorem map_zip_eq {α β : Type} (f : α → β) :
    ∀ {l m : List α}, l.length = m.length → (∀ p ∈ l.zip m, f p.1 = f p.2) → l.map f = m.map f
  | [], [], _, _ => rfl
  | [], _ :: _, hl, _ => by simp at hl
  | _ :: _, [], hl, _ => by simp at hl
  | a :: l, b :: m, hl, h => by
    simp only [List.map_cons, h (a, b) (by simp),
      map_zip_eq f (l := l) (m := m) (by simpa using hl) (fun p hp => h p (by simp [hp]))]

theorem hasTy_of_q {Γ : List (Id × Ty)} {e e' : Expr} (h : QTy D S Γ e e') :
    HasTy D S Γ e' .BooleanType := by
  induction h with
  | leaf h => exact h
  | assume _ _ ih => exact ih
  | ite hc _ _ iha ihb => exact .ite hc iha ihb
  | and hl _ ih =>
    exact .and fun e he => by
      obtain ⟨a, ha⟩ := exists_zip_right hl he
      exact ih _ ha
  | or hl _ ih =>
    exact .or fun e he => by
      obtain ⟨a, ha⟩ := exists_zip_right hl he
      exact ih _ ha
  | not _ ih => exact .not ih

theorem tr_of_q {Γ : List (Id × Ty)} {e e' : Expr} (h : QTy D S Γ e e') :
    tr D S Γ e = tr D S Γ e' := by
  induction h with
  | leaf => rfl
  | assume _ _ ih => simp only [tr]; exact ih
  | ite _ _ _ iha ihb => simp only [tr, iha, ihb]
  | and hl _ ih => simp only [tr, trs_eq]; rw [map_zip_eq _ hl ih]
  | or hl _ ih => simp only [tr, trs_eq]; rw [map_zip_eq _ hl ih]
  | not _ ih => simp only [tr, ih]

section Eval
variable {O : Oracle} {P : Program} {n : Int}

theorem eval_bool_of {env : Env} {e e' : Expr}
    (h : ∀ v, eval O P n env e = .Ok v → eval O P n env e' = .Ok v) {b : Bool}
    (hb : eval_bool O P n env e = .Ok b) : eval_bool O P n env e' = .Ok b := by
  rw [Semantics.eval_bool, h _ (eval_bool_ok hb)]

theorem eval_and_of {env : Env} :
    ∀ {es es' : List Expr}, es.length = es'.length →
      (∀ q ∈ es.zip es', ∀ v, eval O P n env q.1 = .Ok v → eval O P n env q.2 = .Ok v) →
      ∀ {v}, eval_and O P n env es = .Ok v → eval_and O P n env es' = .Ok v
  | [], [], _, _, _, h => h
  | [], _ :: _, hl, _, _, _ => by simp at hl
  | _ :: _, [], hl, _, _, _ => by simp at hl
  | e :: es, e' :: es', hl, hq, v, h => by
    rw [eval_and] at h ⊢
    ok_split h
    rename_i b hb
    rw [eval_bool_of (hq (e, e') (by simp)) hb]
    dsimp only
    cases b
    · rw [dite_eq_right_of_eq_false (eq_false Bool.false_ne_true)] at h ⊢
      exact h
    · rw [dite_eq_left_of_eq_true (eq_true rfl)] at h ⊢
      exact eval_and_of (by simpa using hl) (fun q hq' => hq q (by simp [hq'])) h

theorem eval_or_of {env : Env} :
    ∀ {es es' : List Expr}, es.length = es'.length →
      (∀ q ∈ es.zip es', ∀ v, eval O P n env q.1 = .Ok v → eval O P n env q.2 = .Ok v) →
      ∀ {v}, eval_or O P n env es = .Ok v → eval_or O P n env es' = .Ok v
  | [], [], _, _, _, h => h
  | [], _ :: _, hl, _, _, _ => by simp at hl
  | _ :: _, [], hl, _, _, _ => by simp at hl
  | e :: es, e' :: es', hl, hq, v, h => by
    rw [eval_or] at h ⊢
    ok_split h
    rename_i b hb
    rw [eval_bool_of (hq (e, e') (by simp)) hb]
    dsimp only
    cases b
    · rw [dite_eq_right_of_eq_false (eq_false Bool.false_ne_true)] at h ⊢
      exact eval_or_of (by simpa using hl) (fun q hq' => hq q (by simp [hq'])) h
    · rw [dite_eq_left_of_eq_true (eq_true rfl)] at h ⊢
      exact h

/-- An expression of the query has the value of its expression of the fragment. -/
theorem eval_of_q {Γ : List (Id × Ty)} {e e' : Expr} (h : QTy D S Γ e e') :
    ∀ env v, eval O P n env e = .Ok v → eval O P n env e' = .Ok v := by
  induction h with
  | leaf => exact fun _ _ h => h
  | assume _ _ ih =>
    intro env v he
    rw [eval] at he
    ok_split he
    rename_i b hb
    cases b
    · rw [dite_eq_right_of_eq_false (eq_false Bool.false_ne_true)] at he
      cases he
    · rw [dite_eq_left_of_eq_true (eq_true rfl)] at he
      exact ih env v he
  | ite _ _ _ iha ihb =>
    intro env v he
    rw [eval] at he ⊢
    ok_split he
    rename_i b hb
    cases b
    · rw [dite_eq_right_of_eq_false (eq_false Bool.false_ne_true)] at he ⊢
      exact ihb env v he
    · rw [dite_eq_left_of_eq_true (eq_true rfl)] at he ⊢
      exact iha env v he
  | and hl _ ih =>
    intro env v he
    rw [eval] at he ⊢
    exact eval_and_of hl (fun q hq => ih q hq env) he
  | or hl _ ih =>
    intro env v he
    rw [eval] at he ⊢
    exact eval_or_of hl (fun q hq => ih q hq env) he
  | not _ ih =>
    intro env v he
    rw [eval] at he ⊢
    ok_split he
    rename_i b hb
    rw [eval_bool_of (ih env) hb]
    exact he

end Eval

section Assumed
variable {O : Oracle} {P : Program} {n : Int}

/-- The agreement of an assumption of the query. -/
theorem ev_formula (hO : O.Sound) (hty : LogosTyping) (hS : SigOk D S) (hPD : ProgData D P)
    (hct : CallTy O P D S n) {Γ : List (Id × Ty)} {p : Expr} (h : Formula D S Γ p) :
    Ev O P D S n Γ p .BooleanType := by
  cases h with
  | leaf h => exact ev hO hty hS hPD hct h
  | forall_ hB hb => exact ev_forall hO hS hPD hB hb (ev hO hty hS hPD hct hb)

/-- What `q_holds_of_assumes` says of `e`: `Assumed` with the terms as they are. -/
def QAssumed (O : Oracle) (P : Program) (D : List Data) (S : List Sig) (n : Int)
    (Γ : List (Id × Ty)) (e : Expr) : Prop :=
  ∀ env v, EnvTy D Γ env → eval O P n env e = .Ok v →
    ∀ M, model_wf M → CallsOk O P D S n M → VarsOk D Γ env M → ∀ K, KSound M K →
      ∀ φ, assumesW D S Γ (fun t => t) K φ e = true → __smtx_model_eval M φ = SmtValue.Boolean true

theorem qAssumed_of (h : Assumed O P D S n Γ e) : QAssumed O P D S n Γ e :=
  fun env v hE he M hw hc hV K hK φ hr =>
    h env v hE he M hw hc hV M (fun t => t) hw (fun _ _ _ => rfl) K hK φ hr

/-- The term of an expression of the query is that of a value of its expression of the fragment,
where it has one. -/
theorem q_agrees (hO : O.Sound) (hty : LogosTyping) (hS : SigOk D S) (hPD : ProgData D P)
    (hct : CallTy O P D S n) {Γ : List (Id × Ty)} {e e' : Expr} (h : QTy D S Γ e e')
    {env : Env} (hE : EnvTy D Γ env) {b : Bool} (hb : eval_bool O P n env e = .Ok b) {M : SmtModel}
    (hw : model_wf M) (hc : CallsOk O P D S n M) (hV : VarsOk D Γ env M) :
    __smtx_model_eval M (tr D S Γ e) = trV D (.BoolV b) := by
  rw [tr_of_q h]
  exact (ev hO hty hS hPD hct (hasTy_of_q h) env _ hE
    (eval_of_q h env _ (eval_bool_ok hb))).2 M hw hc hV

section Lists
variable {Γ : List (Id × Ty)} {env : Env} (hE : EnvTy D Γ env) {M : SmtModel}
  (hw : model_wf M) (hc : CallsOk O P D S n M) (hV : VarsOk D Γ env M)
  {K : List (SmtTerm × Bool)} (hK : KSound M K) {φ : SmtTerm}
include hE hw hc hV hK

theorem q_assumed_and (hO : O.Sound) (hty : LogosTyping) (hS : SigOk D S) (hPD : ProgData D P)
    (hct : CallTy O P D S n) :
    ∀ (es es' : List Expr) (v : Value), es.length = es'.length →
      (∀ q ∈ es.zip es', QTy D S Γ q.1 q.2) → (∀ q ∈ es.zip es', QAssumed O P D S n Γ q.1) →
      eval_and O P n env es = .Ok v →
      assumesAnd D S Γ (fun t => t) K φ es = true → __smtx_model_eval M φ = SmtValue.Boolean true
  | [], _, _, _, _, _, _, hr => by simp [assumesAnd] at hr
  | _ :: _, [], _, hl, _, _, _, _ => by simp at hl
  | e :: es, e' :: es', v, hl, hq, ih, h, hr => by
    rw [eval_and] at h
    ok_split h
    rename_i b hb
    simp only [assumesAnd, Bool.or_eq_true, Bool.and_eq_true, decide_eq_true_eq] at hr
    rcases hr with hr | ⟨hred, hr⟩
    · exact ih (e, e') (by simp) env _ hE (eval_bool_ok hb) M hw hc hV K hK φ hr
    · have hb' := red_agrees hty hw hK
        (q_agrees hO hty hS hPD hct (hq (e, e') (by simp)) hE hb hw hc hV) hred
      subst hb'
      rw [dite_eq_left_of_eq_true (eq_true rfl)] at h
      exact q_assumed_and hO hty hS hPD hct es es' v (by simpa using hl)
        (fun q hq' => hq q (by simp [hq'])) (fun q hq' => ih q (by simp [hq'])) h hr

theorem q_assumed_or (hO : O.Sound) (hty : LogosTyping) (hS : SigOk D S) (hPD : ProgData D P)
    (hct : CallTy O P D S n) :
    ∀ (es es' : List Expr) (v : Value), es.length = es'.length →
      (∀ q ∈ es.zip es', QTy D S Γ q.1 q.2) → (∀ q ∈ es.zip es', QAssumed O P D S n Γ q.1) →
      eval_or O P n env es = .Ok v →
      assumesOr D S Γ (fun t => t) K φ es = true → __smtx_model_eval M φ = SmtValue.Boolean true
  | [], _, _, _, _, _, _, hr => by simp [assumesOr] at hr
  | _ :: _, [], _, hl, _, _, _, _ => by simp at hl
  | e :: es, e' :: es', v, hl, hq, ih, h, hr => by
    rw [eval_or] at h
    ok_split h
    rename_i b hb
    simp only [assumesOr, Bool.or_eq_true, Bool.and_eq_true, decide_eq_true_eq] at hr
    rcases hr with hr | ⟨hred, hr⟩
    · exact ih (e, e') (by simp) env _ hE (eval_bool_ok hb) M hw hc hV K hK φ hr
    · have hb' := red_agrees hty hw hK
        (q_agrees hO hty hS hPD hct (hq (e, e') (by simp)) hE hb hw hc hV) hred
      subst hb'
      rw [dite_eq_right_of_eq_false (eq_false Bool.false_ne_true)] at h
      exact q_assumed_or hO hty hS hPD hct es es' v (by simpa using hl)
        (fun q hq' => hq q (by simp [hq'])) (fun q hq' => ih q (by simp [hq'])) h hr

end Lists

/-- The assumptions that the evaluation of an expression of the query goes through hold, where it
has a value, in the models where the calls and the variables agree: those of its expressions of
the fragment (`holds_of_assumesW`), and its assumptions, which are true there, by the agreement of
their quantifiers. -/
theorem q_holds_of_assumes (hO : O.Sound) (hty : LogosTyping) (hS : SigOk D S)
    (hPD : ProgData D P) (hct : CallTy O P D S n) {Γ : List (Id × Ty)} {e e' : Expr}
    (h : QTy D S Γ e e') : QAssumed O P D S n Γ e := by
  induction h with
  | leaf h => exact qAssumed_of (holds_of_assumesW hO hty hS hPD hct h)
  | @assume p b b' hp _ ih =>
    intro env v hE he M hw hc hV K hK φ hr
    rw [eval] at he
    ok_split he
    rename_i x hx
    cases x
    · rw [dite_eq_right_of_eq_false (eq_false Bool.false_ne_true)] at he
      cases he
    rw [dite_eq_left_of_eq_true (eq_true rfl)] at he
    simp only [assumesW, Bool.or_eq_true, decide_eq_true_eq] at hr
    rcases hr with (hr | hr) | hr
    · subst hr
      exact (ev_formula hO hty hS hPD hct hp env _ hE (eval_bool_ok hx)).2 M hw hc hV
    · cases hp with
      | leaf hp =>
        exact holds_of_assumesW hO hty hS hPD hct hp env _ hE (eval_bool_ok hx) M hw hc hV M
          (fun t => t) hw (fun _ _ _ => rfl) K hK φ hr
      | forall_ => simp [assumesW] at hr
    · exact ih env v hE he M hw hc hV K hK φ hr
  | ite htc _ _ iha ihb =>
    intro env v hE he M hw hc hV K hK φ hr
    rw [eval] at he
    ok_split he
    rename_i b hb
    have hcM := (ev hO hty hS hPD hct htc env _ hE (eval_bool_ok hb)).2 M hw hc hV
    simp only [assumesW, Bool.or_eq_true, Bool.and_eq_true, decide_eq_true_eq] at hr
    rcases hr with ((hr | ⟨hred, hr⟩) | ⟨hred, hr⟩) | ⟨hra, hrb⟩
    · exact holds_of_assumesW hO hty hS hPD hct htc env _ hE (eval_bool_ok hb) M hw hc hV M
        (fun t => t) hw (fun _ _ _ => rfl) K hK φ hr
    · have hb' := red_agrees hty hw hK hcM hred
      subst hb'
      rw [dite_eq_left_of_eq_true (eq_true rfl)] at he
      exact iha env v hE he M hw hc hV K hK φ hr
    · have hb' := red_agrees hty hw hK hcM hred
      subst hb'
      rw [dite_eq_right_of_eq_false (eq_false Bool.false_ne_true)] at he
      exact ihb env v hE he M hw hc hV K hK φ hr
    · cases b
      · rw [dite_eq_right_of_eq_false (eq_false Bool.false_ne_true)] at he
        exact ihb env v hE he M hw hc hV K hK φ hrb
      · rw [dite_eq_left_of_eq_true (eq_true rfl)] at he
        exact iha env v hE he M hw hc hV K hK φ hra
  | @and es es' hl hq ih =>
    intro env v hE he M hw hc hV K hK φ hr
    rw [eval] at he
    simp only [assumesW] at hr
    exact q_assumed_and hE hw hc hV hK hO hty hS hPD hct es es' v hl hq ih he hr
  | @or es es' hl hq ih =>
    intro env v hE he M hw hc hV K hK φ hr
    rw [eval] at he
    simp only [assumesW] at hr
    exact q_assumed_or hE hw hc hV hK hO hty hS hPD hct es es' v hl hq ih he hr
  | not _ ih =>
    intro env v hE he M hw hc hV K hK φ hr
    rw [eval] at he
    ok_split he
    rename_i b hb
    simp only [assumesW] at hr
    exact ih env _ hE (eval_bool_ok hb) M hw hc hV K hK φ hr

end Assumed

end Inox.Bridge
