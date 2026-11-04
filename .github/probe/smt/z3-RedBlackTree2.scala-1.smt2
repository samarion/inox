; Options: -in -smt2
(set-option :produce-unsat-assumptions true)

(declare-fun start!12 () Bool)

(assert start!12)

(declare-fun res!150 () Bool)

(declare-fun e!93 () Bool)

(assert (=> start!12 (=> (not res!150) (not e!93))))

(declare-datatypes ((Color!3 0))(
  ( (Red!3) (Black!3) )
))
(declare-datatypes ((Tree!3 0))(
  ( (Empty!3) (Node!3 (color!6 Color!3) (left!8 Tree!3) (value!38 (_ BitVec 32)) (right!8 Tree!3)) )
))
(declare-fun t!78 () Tree!3)

(declare-fun redNodesHaveBlackChildren!0 (Tree!3) Bool)

(assert (=> start!12 (= res!150 (redNodesHaveBlackChildren!0 t!78))))

(assert (=> start!12 e!93))

(assert (=> start!12 true))

(declare-fun b!143 () Bool)

(declare-fun e!94 () Bool)

(assert (=> b!143 (= e!93 e!94)))

(declare-fun res!151 () Bool)

(assert (=> b!143 (=> res!151 e!94)))

(declare-fun x!73 () (_ BitVec 32))

(declare-fun lt!2 () Tree!3)

(define-sort InoxSet (T) (Array T Bool))

(declare-fun content!0 (Tree!3) (InoxSet (_ BitVec 32)))

(assert (=> b!143 (= res!151 (not (= (content!0 lt!2) ((_ map or) (content!0 t!78) (store ((as const (Array (_ BitVec 32) Bool)) false) x!73 true)))))))

(declare-fun ins!0 ((_ BitVec 32) Tree!3) Tree!3)

(assert (=> b!143 (= lt!2 (ins!0 x!73 t!78))))

(declare-fun b!144 () Bool)

(assert (=> b!144 (= e!94 (not (redNodesHaveBlackChildren!0 lt!2)))))

(assert (= (and start!12 res!150) b!143))

(assert (= (and b!143 (not res!151)) b!144))

(declare-fun m!117 () Bool)

(assert (=> start!12 m!117))

(declare-fun m!119 () Bool)

(assert (=> b!143 m!119))

(declare-fun m!121 () Bool)

(assert (=> b!143 m!121))

(declare-fun m!123 () Bool)

(assert (=> b!143 m!123))

(declare-fun m!125 () Bool)

(assert (=> b!143 m!125))

(declare-fun m!127 () Bool)

(assert (=> b!144 m!127))

(check-sat (not b!144) (not start!12) (not b!143))
(check-sat)
(get-model)

(declare-fun b!159 () Bool)

(declare-fun res!166 () Bool)

(declare-fun call!31 () Bool)

(assert (=> b!159 (= res!166 call!31)))

(declare-fun e!105 () Bool)

(assert (=> b!159 (=> (not res!166) (not e!105))))

(declare-fun d!57 () Bool)

(declare-fun res!164 () Bool)

(declare-fun e!106 () Bool)

(assert (=> d!57 (=> res!164 e!106)))

(get-info :version)

(assert (=> d!57 (= res!164 ((_ is Empty!3) lt!2))))

(assert (=> d!57 (= (redNodesHaveBlackChildren!0 lt!2) e!106)))

(declare-fun b!160 () Bool)

(declare-fun call!30 () Bool)

(assert (=> b!160 (= e!105 call!30)))

(declare-fun bm!30 () Bool)

(assert (=> bm!30 (= call!31 (redNodesHaveBlackChildren!0 (left!8 lt!2)))))

(declare-fun bm!31 () Bool)

(assert (=> bm!31 (= call!30 (redNodesHaveBlackChildren!0 (right!8 lt!2)))))

(declare-fun b!161 () Bool)

(declare-fun res!165 () Bool)

(declare-fun isBlack!0 (Tree!3) Bool)

(assert (=> b!161 (= res!165 (isBlack!0 (right!8 lt!2)))))

(assert (=> b!161 (=> (not res!165) (not e!105))))

(declare-fun b!162 () Bool)

(declare-fun e!104 () Bool)

(assert (=> b!162 (= e!104 call!30)))

(declare-fun b!163 () Bool)

(declare-fun e!103 () Bool)

(assert (=> b!163 (= e!103 e!105)))

(declare-fun res!162 () Bool)

(assert (=> b!163 (= res!162 (isBlack!0 (left!8 lt!2)))))

(assert (=> b!163 (=> (not res!162) (not e!105))))

(declare-fun b!164 () Bool)

(assert (=> b!164 (= e!106 e!103)))

(declare-fun c!36 () Bool)

(assert (=> b!164 (= c!36 ((_ is Black!3) (color!6 lt!2)))))

(declare-fun b!165 () Bool)

(assert (=> b!165 (= e!103 e!104)))

(declare-fun res!163 () Bool)

(assert (=> b!165 (= res!163 call!31)))

(assert (=> b!165 (=> (not res!163) (not e!104))))

(assert (= (and d!57 (not res!164)) b!164))

(assert (= (and b!164 c!36) b!165))

(assert (= (and b!164 (not c!36)) b!163))

(assert (= (and b!165 res!163) b!162))

(assert (= (and b!163 res!162) b!161))

(assert (= (and b!161 res!165) b!159))

(assert (= (and b!159 res!166) b!160))

(assert (= (or b!165 b!159) bm!30))

(assert (= (or b!162 b!160) bm!31))

(declare-fun m!129 () Bool)

(assert (=> bm!30 m!129))

(declare-fun m!131 () Bool)

(assert (=> bm!31 m!131))

(declare-fun m!133 () Bool)

(assert (=> b!161 m!133))

(declare-fun m!135 () Bool)

(assert (=> b!163 m!135))

(assert (=> b!144 d!57))

(declare-fun b!166 () Bool)

(declare-fun res!171 () Bool)

(declare-fun call!33 () Bool)

(assert (=> b!166 (= res!171 call!33)))

(declare-fun e!109 () Bool)

(assert (=> b!166 (=> (not res!171) (not e!109))))

(declare-fun d!59 () Bool)

(declare-fun res!169 () Bool)

(declare-fun e!110 () Bool)

(assert (=> d!59 (=> res!169 e!110)))

(assert (=> d!59 (= res!169 ((_ is Empty!3) t!78))))

(assert (=> d!59 (= (redNodesHaveBlackChildren!0 t!78) e!110)))

(declare-fun b!167 () Bool)

(declare-fun call!32 () Bool)

(assert (=> b!167 (= e!109 call!32)))

(declare-fun bm!32 () Bool)

(assert (=> bm!32 (= call!33 (redNodesHaveBlackChildren!0 (left!8 t!78)))))

(declare-fun bm!33 () Bool)

(assert (=> bm!33 (= call!32 (redNodesHaveBlackChildren!0 (right!8 t!78)))))

(declare-fun b!168 () Bool)

(declare-fun res!170 () Bool)

(assert (=> b!168 (= res!170 (isBlack!0 (right!8 t!78)))))

(assert (=> b!168 (=> (not res!170) (not e!109))))

(declare-fun b!169 () Bool)

(declare-fun e!108 () Bool)

(assert (=> b!169 (= e!108 call!32)))

(declare-fun b!170 () Bool)

(declare-fun e!107 () Bool)

(assert (=> b!170 (= e!107 e!109)))

(declare-fun res!167 () Bool)

(assert (=> b!170 (= res!167 (isBlack!0 (left!8 t!78)))))

(assert (=> b!170 (=> (not res!167) (not e!109))))

(declare-fun b!171 () Bool)

(assert (=> b!171 (= e!110 e!107)))

(declare-fun c!37 () Bool)

(assert (=> b!171 (= c!37 ((_ is Black!3) (color!6 t!78)))))

(declare-fun b!172 () Bool)

(assert (=> b!172 (= e!107 e!108)))

(declare-fun res!168 () Bool)

(assert (=> b!172 (= res!168 call!33)))

(assert (=> b!172 (=> (not res!168) (not e!108))))

(assert (= (and d!59 (not res!169)) b!171))

(assert (= (and b!171 c!37) b!172))

(assert (= (and b!171 (not c!37)) b!170))

(assert (= (and b!172 res!168) b!169))

(assert (= (and b!170 res!167) b!168))

(assert (= (and b!168 res!170) b!166))

(assert (= (and b!166 res!171) b!167))

(assert (= (or b!172 b!166) bm!32))

(assert (= (or b!169 b!167) bm!33))

(declare-fun m!137 () Bool)

(assert (=> bm!32 m!137))

(declare-fun m!139 () Bool)

(assert (=> bm!33 m!139))

(declare-fun m!141 () Bool)

(assert (=> b!168 m!141))

(declare-fun m!143 () Bool)

(assert (=> b!170 m!143))

(assert (=> start!12 d!59))

(declare-fun d!61 () Bool)

(declare-fun c!40 () Bool)

(assert (=> d!61 (= c!40 ((_ is Empty!3) lt!2))))

(declare-fun e!113 () (InoxSet (_ BitVec 32)))

(assert (=> d!61 (= (content!0 lt!2) e!113)))

(declare-fun b!177 () Bool)

(assert (=> b!177 (= e!113 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!178 () Bool)

(assert (=> b!178 (= e!113 ((_ map or) ((_ map or) (content!0 (left!8 lt!2)) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 lt!2) true)) (content!0 (right!8 lt!2))))))

(assert (= (and d!61 c!40) b!177))

(assert (= (and d!61 (not c!40)) b!178))

(declare-fun m!145 () Bool)

(assert (=> b!178 m!145))

(declare-fun m!147 () Bool)

(assert (=> b!178 m!147))

(declare-fun m!149 () Bool)

(assert (=> b!178 m!149))

(assert (=> b!143 d!61))

(declare-fun d!63 () Bool)

(declare-fun c!41 () Bool)

(assert (=> d!63 (= c!41 ((_ is Empty!3) t!78))))

(declare-fun e!114 () (InoxSet (_ BitVec 32)))

(assert (=> d!63 (= (content!0 t!78) e!114)))

(declare-fun b!179 () Bool)

(assert (=> b!179 (= e!114 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!180 () Bool)

(assert (=> b!180 (= e!114 ((_ map or) ((_ map or) (content!0 (left!8 t!78)) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 t!78) true)) (content!0 (right!8 t!78))))))

(assert (= (and d!63 c!41) b!179))

(assert (= (and d!63 (not c!41)) b!180))

(declare-fun m!151 () Bool)

(assert (=> b!180 m!151))

(declare-fun m!153 () Bool)

(assert (=> b!180 m!153))

(declare-fun m!155 () Bool)

(assert (=> b!180 m!155))

(assert (=> b!143 d!63))

(declare-fun b!203 () Bool)

(declare-fun res!185 () Bool)

(declare-fun e!129 () Bool)

(assert (=> b!203 (=> (not res!185) (not e!129))))

(declare-fun lt!5 () Tree!3)

(declare-fun size!0 (Tree!3) Int)

(assert (=> b!203 (= res!185 (<= (size!0 t!78) (size!0 lt!5)))))

(declare-fun b!204 () Bool)

(declare-fun e!127 () Tree!3)

(declare-fun call!39 () Tree!3)

(assert (=> b!204 (= e!127 call!39)))

(declare-fun b!205 () Bool)

(declare-fun e!125 () Tree!3)

(assert (=> b!205 (= e!125 call!39)))

(declare-fun b!206 () Bool)

(declare-fun res!183 () Bool)

(assert (=> b!206 (=> (not res!183) (not e!129))))

(assert (=> b!206 (= res!183 (<= (size!0 lt!5) (+ (size!0 t!78) 1)))))

(declare-fun c!50 () Bool)

(declare-fun bm!38 () Bool)

(declare-fun call!38 () Tree!3)

(declare-fun balance!0 (Color!3 Tree!3 (_ BitVec 32) Tree!3) Tree!3)

(assert (=> bm!38 (= call!39 (balance!0 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))))

(declare-fun b!207 () Bool)

(declare-fun e!126 () Tree!3)

(assert (=> b!207 (= e!126 e!125)))

(assert (=> b!207 (= c!50 (bvslt x!73 (value!38 t!78)))))

(declare-fun b!208 () Bool)

(declare-fun c!48 () Bool)

(assert (=> b!208 (= c!48 (= x!73 (value!38 t!78)))))

(assert (=> b!208 (= e!125 e!127)))

(declare-fun b!210 () Bool)

(assert (=> b!210 (= e!126 (Node!3 Red!3 Empty!3 x!73 Empty!3))))

(declare-fun b!211 () Bool)

(declare-fun e!128 () Bool)

(declare-fun blackBalanced!0 (Tree!3) Bool)

(assert (=> b!211 (= e!128 (blackBalanced!0 t!78))))

(declare-fun bm!39 () Bool)

(assert (=> bm!39 (= call!38 (ins!0 x!73 (ite c!50 (left!8 t!78) (right!8 t!78))))))

(declare-fun b!209 () Bool)

(assert (=> b!209 (= e!129 (blackBalanced!0 lt!5))))

(declare-fun d!65 () Bool)

(assert (=> d!65 e!129))

(declare-fun res!182 () Bool)

(assert (=> d!65 (=> (not res!182) (not e!129))))

(assert (=> d!65 (= res!182 (= (content!0 lt!5) ((_ map or) (content!0 t!78) (store ((as const (Array (_ BitVec 32) Bool)) false) x!73 true))))))

(assert (=> d!65 (= lt!5 e!126)))

(declare-fun c!49 () Bool)

(assert (=> d!65 (= c!49 ((_ is Empty!3) t!78))))

(assert (=> d!65 e!128))

(declare-fun res!186 () Bool)

(assert (=> d!65 (=> (not res!186) (not e!128))))

(assert (=> d!65 (= res!186 (redNodesHaveBlackChildren!0 t!78))))

(assert (=> d!65 (= (ins!0 x!73 t!78) lt!5)))

(declare-fun b!212 () Bool)

(declare-fun res!184 () Bool)

(assert (=> b!212 (=> (not res!184) (not e!129))))

(declare-fun redDescHaveBlackChildren!0 (Tree!3) Bool)

(assert (=> b!212 (= res!184 (redDescHaveBlackChildren!0 lt!5))))

(declare-fun b!213 () Bool)

(assert (=> b!213 (= e!127 t!78)))

(assert (= (and d!65 res!186) b!211))

(assert (= (and d!65 c!49) b!210))

(assert (= (and d!65 (not c!49)) b!207))

(assert (= (and b!207 c!50) b!205))

(assert (= (and b!207 (not c!50)) b!208))

(assert (= (and b!208 c!48) b!213))

(assert (= (and b!208 (not c!48)) b!204))

(assert (= (or b!205 b!204) bm!39))

(assert (= (or b!205 b!204) bm!38))

(assert (= (and d!65 res!182) b!203))

(assert (= (and b!203 res!185) b!206))

(assert (= (and b!206 res!183) b!212))

(assert (= (and b!212 res!184) b!209))

(declare-fun m!157 () Bool)

(assert (=> d!65 m!157))

(assert (=> d!65 m!121))

(assert (=> d!65 m!123))

(assert (=> d!65 m!117))

(declare-fun m!159 () Bool)

(assert (=> bm!39 m!159))

(declare-fun m!161 () Bool)

(assert (=> bm!38 m!161))

(declare-fun m!163 () Bool)

(assert (=> b!211 m!163))

(declare-fun m!165 () Bool)

(assert (=> b!203 m!165))

(declare-fun m!167 () Bool)

(assert (=> b!203 m!167))

(assert (=> b!206 m!167))

(assert (=> b!206 m!165))

(declare-fun m!169 () Bool)

(assert (=> b!209 m!169))

(declare-fun m!171 () Bool)

(assert (=> b!212 m!171))

(assert (=> b!143 d!65))

(check-sat (not bm!30) (not b!212) (not b!168) (not bm!38) (not bm!33) (not b!203) (not b!209) (not b!163) (not b!178) (not b!211) (not b!170) (not bm!32) (not bm!31) (not d!65) (not b!161) (not b!180) (not bm!39) (not b!206))
(check-sat)
(get-model)

(declare-fun d!67 () Bool)

(assert (=> d!67 (= (isBlack!0 (left!8 t!78)) (or ((_ is Empty!3) (left!8 t!78)) ((_ is Black!3) (color!6 (left!8 t!78)))))))

(assert (=> b!170 d!67))

(declare-fun d!69 () Bool)

(assert (=> d!69 (= (isBlack!0 (right!8 lt!2)) (or ((_ is Empty!3) (right!8 lt!2)) ((_ is Black!3) (color!6 (right!8 lt!2)))))))

(assert (=> b!161 d!69))

(declare-fun d!71 () Bool)

(declare-fun res!191 () Bool)

(declare-fun e!134 () Bool)

(assert (=> d!71 (=> res!191 e!134)))

(assert (=> d!71 (= res!191 ((_ is Empty!3) lt!5))))

(assert (=> d!71 (= (redDescHaveBlackChildren!0 lt!5) e!134)))

(declare-fun b!218 () Bool)

(declare-fun e!135 () Bool)

(assert (=> b!218 (= e!134 e!135)))

(declare-fun res!192 () Bool)

(assert (=> b!218 (=> (not res!192) (not e!135))))

(assert (=> b!218 (= res!192 (redNodesHaveBlackChildren!0 (left!8 lt!5)))))

(declare-fun b!219 () Bool)

(assert (=> b!219 (= e!135 (redNodesHaveBlackChildren!0 (right!8 lt!5)))))

(assert (= (and d!71 (not res!191)) b!218))

(assert (= (and b!218 res!192) b!219))

(declare-fun m!173 () Bool)

(assert (=> b!218 m!173))

(declare-fun m!175 () Bool)

(assert (=> b!219 m!175))

(assert (=> b!212 d!71))

(declare-fun d!73 () Bool)

(declare-fun lt!8 () Int)

(assert (=> d!73 (>= lt!8 0)))

(declare-fun e!138 () Int)

(assert (=> d!73 (= lt!8 e!138)))

(declare-fun c!53 () Bool)

(assert (=> d!73 (= c!53 ((_ is Empty!3) t!78))))

(assert (=> d!73 (= (size!0 t!78) lt!8)))

(declare-fun b!224 () Bool)

(assert (=> b!224 (= e!138 0)))

(declare-fun b!225 () Bool)

(assert (=> b!225 (= e!138 (+ (size!0 (left!8 t!78)) 1 (size!0 (right!8 t!78))))))

(assert (= (and d!73 c!53) b!224))

(assert (= (and d!73 (not c!53)) b!225))

(declare-fun m!177 () Bool)

(assert (=> b!225 m!177))

(declare-fun m!179 () Bool)

(assert (=> b!225 m!179))

(assert (=> b!203 d!73))

(declare-fun d!75 () Bool)

(declare-fun lt!9 () Int)

(assert (=> d!75 (>= lt!9 0)))

(declare-fun e!139 () Int)

(assert (=> d!75 (= lt!9 e!139)))

(declare-fun c!54 () Bool)

(assert (=> d!75 (= c!54 ((_ is Empty!3) lt!5))))

(assert (=> d!75 (= (size!0 lt!5) lt!9)))

(declare-fun b!226 () Bool)

(assert (=> b!226 (= e!139 0)))

(declare-fun b!227 () Bool)

(assert (=> b!227 (= e!139 (+ (size!0 (left!8 lt!5)) 1 (size!0 (right!8 lt!5))))))

(assert (= (and d!75 c!54) b!226))

(assert (= (and d!75 (not c!54)) b!227))

(declare-fun m!181 () Bool)

(assert (=> b!227 m!181))

(declare-fun m!183 () Bool)

(assert (=> b!227 m!183))

(assert (=> b!203 d!75))

(declare-fun b!228 () Bool)

(declare-fun res!197 () Bool)

(declare-fun call!41 () Bool)

(assert (=> b!228 (= res!197 call!41)))

(declare-fun e!142 () Bool)

(assert (=> b!228 (=> (not res!197) (not e!142))))

(declare-fun d!77 () Bool)

(declare-fun res!195 () Bool)

(declare-fun e!143 () Bool)

(assert (=> d!77 (=> res!195 e!143)))

(assert (=> d!77 (= res!195 ((_ is Empty!3) (right!8 lt!2)))))

(assert (=> d!77 (= (redNodesHaveBlackChildren!0 (right!8 lt!2)) e!143)))

(declare-fun b!229 () Bool)

(declare-fun call!40 () Bool)

(assert (=> b!229 (= e!142 call!40)))

(declare-fun bm!40 () Bool)

(assert (=> bm!40 (= call!41 (redNodesHaveBlackChildren!0 (left!8 (right!8 lt!2))))))

(declare-fun bm!41 () Bool)

(assert (=> bm!41 (= call!40 (redNodesHaveBlackChildren!0 (right!8 (right!8 lt!2))))))

(declare-fun b!230 () Bool)

(declare-fun res!196 () Bool)

(assert (=> b!230 (= res!196 (isBlack!0 (right!8 (right!8 lt!2))))))

(assert (=> b!230 (=> (not res!196) (not e!142))))

(declare-fun b!231 () Bool)

(declare-fun e!141 () Bool)

(assert (=> b!231 (= e!141 call!40)))

(declare-fun b!232 () Bool)

(declare-fun e!140 () Bool)

(assert (=> b!232 (= e!140 e!142)))

(declare-fun res!193 () Bool)

(assert (=> b!232 (= res!193 (isBlack!0 (left!8 (right!8 lt!2))))))

(assert (=> b!232 (=> (not res!193) (not e!142))))

(declare-fun b!233 () Bool)

(assert (=> b!233 (= e!143 e!140)))

(declare-fun c!55 () Bool)

(assert (=> b!233 (= c!55 ((_ is Black!3) (color!6 (right!8 lt!2))))))

(declare-fun b!234 () Bool)

(assert (=> b!234 (= e!140 e!141)))

(declare-fun res!194 () Bool)

(assert (=> b!234 (= res!194 call!41)))

(assert (=> b!234 (=> (not res!194) (not e!141))))

(assert (= (and d!77 (not res!195)) b!233))

(assert (= (and b!233 c!55) b!234))

(assert (= (and b!233 (not c!55)) b!232))

(assert (= (and b!234 res!194) b!231))

(assert (= (and b!232 res!193) b!230))

(assert (= (and b!230 res!196) b!228))

(assert (= (and b!228 res!197) b!229))

(assert (= (or b!234 b!228) bm!40))

(assert (= (or b!231 b!229) bm!41))

(declare-fun m!185 () Bool)

(assert (=> bm!40 m!185))

(declare-fun m!187 () Bool)

(assert (=> bm!41 m!187))

(declare-fun m!189 () Bool)

(assert (=> b!230 m!189))

(declare-fun m!191 () Bool)

(assert (=> b!232 m!191))

(assert (=> bm!31 d!77))

(declare-fun d!79 () Bool)

(assert (=> d!79 (= (isBlack!0 (right!8 t!78)) (or ((_ is Empty!3) (right!8 t!78)) ((_ is Black!3) (color!6 (right!8 t!78)))))))

(assert (=> b!168 d!79))

(declare-fun d!81 () Bool)

(declare-fun lt!12 () Tree!3)

(assert (=> d!81 (= (content!0 lt!12) (content!0 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))

(assert (=> d!81 (= lt!12 (ite (and ((_ is Black!3) (color!6 t!78)) ((_ is Node!3) (ite c!50 call!38 (left!8 t!78))) ((_ is Red!3) (color!6 (ite c!50 call!38 (left!8 t!78)))) ((_ is Node!3) (left!8 (ite c!50 call!38 (left!8 t!78)))) ((_ is Red!3) (color!6 (left!8 (ite c!50 call!38 (left!8 t!78)))))) (Node!3 Red!3 (Node!3 Black!3 (left!8 (left!8 (ite c!50 call!38 (left!8 t!78)))) (value!38 (left!8 (ite c!50 call!38 (left!8 t!78)))) (right!8 (left!8 (ite c!50 call!38 (left!8 t!78))))) (value!38 (ite c!50 call!38 (left!8 t!78))) (Node!3 Black!3 (right!8 (ite c!50 call!38 (left!8 t!78))) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))) (ite (and ((_ is Black!3) (color!6 t!78)) ((_ is Node!3) (ite c!50 call!38 (left!8 t!78))) ((_ is Red!3) (color!6 (ite c!50 call!38 (left!8 t!78)))) ((_ is Node!3) (right!8 (ite c!50 call!38 (left!8 t!78)))) ((_ is Red!3) (color!6 (right!8 (ite c!50 call!38 (left!8 t!78)))))) (Node!3 Red!3 (Node!3 Black!3 (left!8 (ite c!50 call!38 (left!8 t!78))) (value!38 (ite c!50 call!38 (left!8 t!78))) (left!8 (right!8 (ite c!50 call!38 (left!8 t!78))))) (value!38 (right!8 (ite c!50 call!38 (left!8 t!78)))) (Node!3 Black!3 (right!8 (right!8 (ite c!50 call!38 (left!8 t!78)))) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))) (ite (and ((_ is Black!3) (color!6 t!78)) ((_ is Node!3) (ite c!50 (right!8 t!78) call!38)) ((_ is Red!3) (color!6 (ite c!50 (right!8 t!78) call!38))) ((_ is Node!3) (left!8 (ite c!50 (right!8 t!78) call!38))) ((_ is Red!3) (color!6 (left!8 (ite c!50 (right!8 t!78) call!38))))) (Node!3 Red!3 (Node!3 Black!3 (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (left!8 (left!8 (ite c!50 (right!8 t!78) call!38)))) (value!38 (left!8 (ite c!50 (right!8 t!78) call!38))) (Node!3 Black!3 (right!8 (left!8 (ite c!50 (right!8 t!78) call!38))) (value!38 (ite c!50 (right!8 t!78) call!38)) (right!8 (ite c!50 (right!8 t!78) call!38)))) (ite (and ((_ is Black!3) (color!6 t!78)) ((_ is Node!3) (ite c!50 (right!8 t!78) call!38)) ((_ is Red!3) (color!6 (ite c!50 (right!8 t!78) call!38))) ((_ is Node!3) (right!8 (ite c!50 (right!8 t!78) call!38))) ((_ is Red!3) (color!6 (right!8 (ite c!50 (right!8 t!78) call!38))))) (Node!3 Red!3 (Node!3 Black!3 (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (left!8 (ite c!50 (right!8 t!78) call!38))) (value!38 (ite c!50 (right!8 t!78) call!38)) (Node!3 Black!3 (left!8 (right!8 (ite c!50 (right!8 t!78) call!38))) (value!38 (right!8 (ite c!50 (right!8 t!78) call!38))) (right!8 (right!8 (ite c!50 (right!8 t!78) call!38))))) (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))))))))

(assert (=> d!81 (= (balance!0 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)) lt!12)))

(declare-fun bs!2 () Bool)

(assert (= bs!2 d!81))

(declare-fun m!193 () Bool)

(assert (=> bs!2 m!193))

(declare-fun m!195 () Bool)

(assert (=> bs!2 m!195))

(assert (=> bm!38 d!81))

(assert (=> b!206 d!75))

(assert (=> b!206 d!73))

(declare-fun d!83 () Bool)

(assert (=> d!83 (= (isBlack!0 (left!8 lt!2)) (or ((_ is Empty!3) (left!8 lt!2)) ((_ is Black!3) (color!6 (left!8 lt!2)))))))

(assert (=> b!163 d!83))

(declare-fun d!85 () Bool)

(declare-fun res!204 () Bool)

(declare-fun e!148 () Bool)

(assert (=> d!85 (=> res!204 e!148)))

(assert (=> d!85 (= res!204 (not ((_ is Node!3) lt!5)))))

(assert (=> d!85 (= (blackBalanced!0 lt!5) e!148)))

(declare-fun b!242 () Bool)

(declare-fun e!149 () Bool)

(assert (=> b!242 (= e!148 e!149)))

(declare-fun res!206 () Bool)

(assert (=> b!242 (=> (not res!206) (not e!149))))

(assert (=> b!242 (= res!206 (blackBalanced!0 (left!8 lt!5)))))

(declare-fun b!243 () Bool)

(declare-fun res!205 () Bool)

(assert (=> b!243 (=> (not res!205) (not e!149))))

(assert (=> b!243 (= res!205 (blackBalanced!0 (right!8 lt!5)))))

(declare-fun b!244 () Bool)

(declare-fun blackHeight!0 (Tree!3) (_ BitVec 32))

(assert (=> b!244 (= e!149 (= (blackHeight!0 (left!8 lt!5)) (blackHeight!0 (right!8 lt!5))))))

(assert (= (and d!85 (not res!204)) b!242))

(assert (= (and b!242 res!206) b!243))

(assert (= (and b!243 res!205) b!244))

(declare-fun m!197 () Bool)

(assert (=> b!242 m!197))

(declare-fun m!199 () Bool)

(assert (=> b!243 m!199))

(declare-fun m!201 () Bool)

(assert (=> b!244 m!201))

(declare-fun m!203 () Bool)

(assert (=> b!244 m!203))

(assert (=> b!209 d!85))

(declare-fun d!87 () Bool)

(declare-fun c!57 () Bool)

(assert (=> d!87 (= c!57 ((_ is Empty!3) lt!5))))

(declare-fun e!150 () (InoxSet (_ BitVec 32)))

(assert (=> d!87 (= (content!0 lt!5) e!150)))

(declare-fun b!245 () Bool)

(assert (=> b!245 (= e!150 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!246 () Bool)

(assert (=> b!246 (= e!150 ((_ map or) ((_ map or) (content!0 (left!8 lt!5)) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 lt!5) true)) (content!0 (right!8 lt!5))))))

(assert (= (and d!87 c!57) b!245))

(assert (= (and d!87 (not c!57)) b!246))

(declare-fun m!205 () Bool)

(assert (=> b!246 m!205))

(declare-fun m!207 () Bool)

(assert (=> b!246 m!207))

(declare-fun m!209 () Bool)

(assert (=> b!246 m!209))

(assert (=> d!65 d!87))

(assert (=> d!65 d!63))

(assert (=> d!65 d!59))

(declare-fun b!247 () Bool)

(declare-fun res!211 () Bool)

(declare-fun call!43 () Bool)

(assert (=> b!247 (= res!211 call!43)))

(declare-fun e!153 () Bool)

(assert (=> b!247 (=> (not res!211) (not e!153))))

(declare-fun d!89 () Bool)

(declare-fun res!209 () Bool)

(declare-fun e!154 () Bool)

(assert (=> d!89 (=> res!209 e!154)))

(assert (=> d!89 (= res!209 ((_ is Empty!3) (left!8 lt!2)))))

(assert (=> d!89 (= (redNodesHaveBlackChildren!0 (left!8 lt!2)) e!154)))

(declare-fun b!248 () Bool)

(declare-fun call!42 () Bool)

(assert (=> b!248 (= e!153 call!42)))

(declare-fun bm!42 () Bool)

(assert (=> bm!42 (= call!43 (redNodesHaveBlackChildren!0 (left!8 (left!8 lt!2))))))

(declare-fun bm!43 () Bool)

(assert (=> bm!43 (= call!42 (redNodesHaveBlackChildren!0 (right!8 (left!8 lt!2))))))

(declare-fun b!249 () Bool)

(declare-fun res!210 () Bool)

(assert (=> b!249 (= res!210 (isBlack!0 (right!8 (left!8 lt!2))))))

(assert (=> b!249 (=> (not res!210) (not e!153))))

(declare-fun b!250 () Bool)

(declare-fun e!152 () Bool)

(assert (=> b!250 (= e!152 call!42)))

(declare-fun b!251 () Bool)

(declare-fun e!151 () Bool)

(assert (=> b!251 (= e!151 e!153)))

(declare-fun res!207 () Bool)

(assert (=> b!251 (= res!207 (isBlack!0 (left!8 (left!8 lt!2))))))

(assert (=> b!251 (=> (not res!207) (not e!153))))

(declare-fun b!252 () Bool)

(assert (=> b!252 (= e!154 e!151)))

(declare-fun c!58 () Bool)

(assert (=> b!252 (= c!58 ((_ is Black!3) (color!6 (left!8 lt!2))))))

(declare-fun b!253 () Bool)

(assert (=> b!253 (= e!151 e!152)))

(declare-fun res!208 () Bool)

(assert (=> b!253 (= res!208 call!43)))

(assert (=> b!253 (=> (not res!208) (not e!152))))

(assert (= (and d!89 (not res!209)) b!252))

(assert (= (and b!252 c!58) b!253))

(assert (= (and b!252 (not c!58)) b!251))

(assert (= (and b!253 res!208) b!250))

(assert (= (and b!251 res!207) b!249))

(assert (= (and b!249 res!210) b!247))

(assert (= (and b!247 res!211) b!248))

(assert (= (or b!253 b!247) bm!42))

(assert (= (or b!250 b!248) bm!43))

(declare-fun m!211 () Bool)

(assert (=> bm!42 m!211))

(declare-fun m!213 () Bool)

(assert (=> bm!43 m!213))

(declare-fun m!215 () Bool)

(assert (=> b!249 m!215))

(declare-fun m!217 () Bool)

(assert (=> b!251 m!217))

(assert (=> bm!30 d!89))

(declare-fun b!254 () Bool)

(declare-fun res!216 () Bool)

(declare-fun call!45 () Bool)

(assert (=> b!254 (= res!216 call!45)))

(declare-fun e!157 () Bool)

(assert (=> b!254 (=> (not res!216) (not e!157))))

(declare-fun d!91 () Bool)

(declare-fun res!214 () Bool)

(declare-fun e!158 () Bool)

(assert (=> d!91 (=> res!214 e!158)))

(assert (=> d!91 (= res!214 ((_ is Empty!3) (right!8 t!78)))))

(assert (=> d!91 (= (redNodesHaveBlackChildren!0 (right!8 t!78)) e!158)))

(declare-fun b!255 () Bool)

(declare-fun call!44 () Bool)

(assert (=> b!255 (= e!157 call!44)))

(declare-fun bm!44 () Bool)

(assert (=> bm!44 (= call!45 (redNodesHaveBlackChildren!0 (left!8 (right!8 t!78))))))

(declare-fun bm!45 () Bool)

(assert (=> bm!45 (= call!44 (redNodesHaveBlackChildren!0 (right!8 (right!8 t!78))))))

(declare-fun b!256 () Bool)

(declare-fun res!215 () Bool)

(assert (=> b!256 (= res!215 (isBlack!0 (right!8 (right!8 t!78))))))

(assert (=> b!256 (=> (not res!215) (not e!157))))

(declare-fun b!257 () Bool)

(declare-fun e!156 () Bool)

(assert (=> b!257 (= e!156 call!44)))

(declare-fun b!258 () Bool)

(declare-fun e!155 () Bool)

(assert (=> b!258 (= e!155 e!157)))

(declare-fun res!212 () Bool)

(assert (=> b!258 (= res!212 (isBlack!0 (left!8 (right!8 t!78))))))

(assert (=> b!258 (=> (not res!212) (not e!157))))

(declare-fun b!259 () Bool)

(assert (=> b!259 (= e!158 e!155)))

(declare-fun c!59 () Bool)

(assert (=> b!259 (= c!59 ((_ is Black!3) (color!6 (right!8 t!78))))))

(declare-fun b!260 () Bool)

(assert (=> b!260 (= e!155 e!156)))

(declare-fun res!213 () Bool)

(assert (=> b!260 (= res!213 call!45)))

(assert (=> b!260 (=> (not res!213) (not e!156))))

(assert (= (and d!91 (not res!214)) b!259))

(assert (= (and b!259 c!59) b!260))

(assert (= (and b!259 (not c!59)) b!258))

(assert (= (and b!260 res!213) b!257))

(assert (= (and b!258 res!212) b!256))

(assert (= (and b!256 res!215) b!254))

(assert (= (and b!254 res!216) b!255))

(assert (= (or b!260 b!254) bm!44))

(assert (= (or b!257 b!255) bm!45))

(declare-fun m!219 () Bool)

(assert (=> bm!44 m!219))

(declare-fun m!221 () Bool)

(assert (=> bm!45 m!221))

(declare-fun m!223 () Bool)

(assert (=> b!256 m!223))

(declare-fun m!225 () Bool)

(assert (=> b!258 m!225))

(assert (=> bm!33 d!91))

(declare-fun b!261 () Bool)

(declare-fun res!220 () Bool)

(declare-fun e!163 () Bool)

(assert (=> b!261 (=> (not res!220) (not e!163))))

(declare-fun lt!13 () Tree!3)

(assert (=> b!261 (= res!220 (<= (size!0 (ite c!50 (left!8 t!78) (right!8 t!78))) (size!0 lt!13)))))

(declare-fun b!262 () Bool)

(declare-fun e!161 () Tree!3)

(declare-fun call!47 () Tree!3)

(assert (=> b!262 (= e!161 call!47)))

(declare-fun b!263 () Bool)

(declare-fun e!159 () Tree!3)

(assert (=> b!263 (= e!159 call!47)))

(declare-fun b!264 () Bool)

(declare-fun res!218 () Bool)

(assert (=> b!264 (=> (not res!218) (not e!163))))

(assert (=> b!264 (= res!218 (<= (size!0 lt!13) (+ (size!0 (ite c!50 (left!8 t!78) (right!8 t!78))) 1)))))

(declare-fun call!46 () Tree!3)

(declare-fun bm!46 () Bool)

(declare-fun c!62 () Bool)

(assert (=> bm!46 (= call!47 (balance!0 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))))

(declare-fun b!265 () Bool)

(declare-fun e!160 () Tree!3)

(assert (=> b!265 (= e!160 e!159)))

(assert (=> b!265 (= c!62 (bvslt x!73 (value!38 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(declare-fun b!266 () Bool)

(declare-fun c!60 () Bool)

(assert (=> b!266 (= c!60 (= x!73 (value!38 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(assert (=> b!266 (= e!159 e!161)))

(declare-fun b!268 () Bool)

(assert (=> b!268 (= e!160 (Node!3 Red!3 Empty!3 x!73 Empty!3))))

(declare-fun b!269 () Bool)

(declare-fun e!162 () Bool)

(assert (=> b!269 (= e!162 (blackBalanced!0 (ite c!50 (left!8 t!78) (right!8 t!78))))))

(declare-fun bm!47 () Bool)

(assert (=> bm!47 (= call!46 (ins!0 x!73 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!267 () Bool)

(assert (=> b!267 (= e!163 (blackBalanced!0 lt!13))))

(declare-fun d!93 () Bool)

(assert (=> d!93 e!163))

(declare-fun res!217 () Bool)

(assert (=> d!93 (=> (not res!217) (not e!163))))

(assert (=> d!93 (= res!217 (= (content!0 lt!13) ((_ map or) (content!0 (ite c!50 (left!8 t!78) (right!8 t!78))) (store ((as const (Array (_ BitVec 32) Bool)) false) x!73 true))))))

(assert (=> d!93 (= lt!13 e!160)))

(declare-fun c!61 () Bool)

(assert (=> d!93 (= c!61 ((_ is Empty!3) (ite c!50 (left!8 t!78) (right!8 t!78))))))

(assert (=> d!93 e!162))

(declare-fun res!221 () Bool)

(assert (=> d!93 (=> (not res!221) (not e!162))))

(assert (=> d!93 (= res!221 (redNodesHaveBlackChildren!0 (ite c!50 (left!8 t!78) (right!8 t!78))))))

(assert (=> d!93 (= (ins!0 x!73 (ite c!50 (left!8 t!78) (right!8 t!78))) lt!13)))

(declare-fun b!270 () Bool)

(declare-fun res!219 () Bool)

(assert (=> b!270 (=> (not res!219) (not e!163))))

(assert (=> b!270 (= res!219 (redDescHaveBlackChildren!0 lt!13))))

(declare-fun b!271 () Bool)

(assert (=> b!271 (= e!161 (ite c!50 (left!8 t!78) (right!8 t!78)))))

(assert (= (and d!93 res!221) b!269))

(assert (= (and d!93 c!61) b!268))

(assert (= (and d!93 (not c!61)) b!265))

(assert (= (and b!265 c!62) b!263))

(assert (= (and b!265 (not c!62)) b!266))

(assert (= (and b!266 c!60) b!271))

(assert (= (and b!266 (not c!60)) b!262))

(assert (= (or b!263 b!262) bm!47))

(assert (= (or b!263 b!262) bm!46))

(assert (= (and d!93 res!217) b!261))

(assert (= (and b!261 res!220) b!264))

(assert (= (and b!264 res!218) b!270))

(assert (= (and b!270 res!219) b!267))

(declare-fun m!227 () Bool)

(assert (=> d!93 m!227))

(declare-fun m!229 () Bool)

(assert (=> d!93 m!229))

(assert (=> d!93 m!123))

(declare-fun m!231 () Bool)

(assert (=> d!93 m!231))

(declare-fun m!233 () Bool)

(assert (=> bm!47 m!233))

(declare-fun m!235 () Bool)

(assert (=> bm!46 m!235))

(declare-fun m!237 () Bool)

(assert (=> b!269 m!237))

(declare-fun m!239 () Bool)

(assert (=> b!261 m!239))

(declare-fun m!241 () Bool)

(assert (=> b!261 m!241))

(assert (=> b!264 m!241))

(assert (=> b!264 m!239))

(declare-fun m!243 () Bool)

(assert (=> b!267 m!243))

(declare-fun m!245 () Bool)

(assert (=> b!270 m!245))

(assert (=> bm!39 d!93))

(declare-fun d!95 () Bool)

(declare-fun c!63 () Bool)

(assert (=> d!95 (= c!63 ((_ is Empty!3) (left!8 t!78)))))

(declare-fun e!164 () (InoxSet (_ BitVec 32)))

(assert (=> d!95 (= (content!0 (left!8 t!78)) e!164)))

(declare-fun b!272 () Bool)

(assert (=> b!272 (= e!164 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!273 () Bool)

(assert (=> b!273 (= e!164 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 t!78))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 t!78)) true)) (content!0 (right!8 (left!8 t!78)))))))

(assert (= (and d!95 c!63) b!272))

(assert (= (and d!95 (not c!63)) b!273))

(declare-fun m!247 () Bool)

(assert (=> b!273 m!247))

(declare-fun m!249 () Bool)

(assert (=> b!273 m!249))

(declare-fun m!251 () Bool)

(assert (=> b!273 m!251))

(assert (=> b!180 d!95))

(declare-fun d!97 () Bool)

(declare-fun c!64 () Bool)

(assert (=> d!97 (= c!64 ((_ is Empty!3) (right!8 t!78)))))

(declare-fun e!165 () (InoxSet (_ BitVec 32)))

(assert (=> d!97 (= (content!0 (right!8 t!78)) e!165)))

(declare-fun b!274 () Bool)

(assert (=> b!274 (= e!165 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!275 () Bool)

(assert (=> b!275 (= e!165 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 t!78))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 t!78)) true)) (content!0 (right!8 (right!8 t!78)))))))

(assert (= (and d!97 c!64) b!274))

(assert (= (and d!97 (not c!64)) b!275))

(declare-fun m!253 () Bool)

(assert (=> b!275 m!253))

(declare-fun m!255 () Bool)

(assert (=> b!275 m!255))

(declare-fun m!257 () Bool)

(assert (=> b!275 m!257))

(assert (=> b!180 d!97))

(declare-fun d!99 () Bool)

(declare-fun res!222 () Bool)

(declare-fun e!166 () Bool)

(assert (=> d!99 (=> res!222 e!166)))

(assert (=> d!99 (= res!222 (not ((_ is Node!3) t!78)))))

(assert (=> d!99 (= (blackBalanced!0 t!78) e!166)))

(declare-fun b!276 () Bool)

(declare-fun e!167 () Bool)

(assert (=> b!276 (= e!166 e!167)))

(declare-fun res!224 () Bool)

(assert (=> b!276 (=> (not res!224) (not e!167))))

(assert (=> b!276 (= res!224 (blackBalanced!0 (left!8 t!78)))))

(declare-fun b!277 () Bool)

(declare-fun res!223 () Bool)

(assert (=> b!277 (=> (not res!223) (not e!167))))

(assert (=> b!277 (= res!223 (blackBalanced!0 (right!8 t!78)))))

(declare-fun b!278 () Bool)

(assert (=> b!278 (= e!167 (= (blackHeight!0 (left!8 t!78)) (blackHeight!0 (right!8 t!78))))))

(assert (= (and d!99 (not res!222)) b!276))

(assert (= (and b!276 res!224) b!277))

(assert (= (and b!277 res!223) b!278))

(declare-fun m!259 () Bool)

(assert (=> b!276 m!259))

(declare-fun m!261 () Bool)

(assert (=> b!277 m!261))

(declare-fun m!263 () Bool)

(assert (=> b!278 m!263))

(declare-fun m!265 () Bool)

(assert (=> b!278 m!265))

(assert (=> b!211 d!99))

(declare-fun b!279 () Bool)

(declare-fun res!229 () Bool)

(declare-fun call!49 () Bool)

(assert (=> b!279 (= res!229 call!49)))

(declare-fun e!170 () Bool)

(assert (=> b!279 (=> (not res!229) (not e!170))))

(declare-fun d!101 () Bool)

(declare-fun res!227 () Bool)

(declare-fun e!171 () Bool)

(assert (=> d!101 (=> res!227 e!171)))

(assert (=> d!101 (= res!227 ((_ is Empty!3) (left!8 t!78)))))

(assert (=> d!101 (= (redNodesHaveBlackChildren!0 (left!8 t!78)) e!171)))

(declare-fun b!280 () Bool)

(declare-fun call!48 () Bool)

(assert (=> b!280 (= e!170 call!48)))

(declare-fun bm!48 () Bool)

(assert (=> bm!48 (= call!49 (redNodesHaveBlackChildren!0 (left!8 (left!8 t!78))))))

(declare-fun bm!49 () Bool)

(assert (=> bm!49 (= call!48 (redNodesHaveBlackChildren!0 (right!8 (left!8 t!78))))))

(declare-fun b!281 () Bool)

(declare-fun res!228 () Bool)

(assert (=> b!281 (= res!228 (isBlack!0 (right!8 (left!8 t!78))))))

(assert (=> b!281 (=> (not res!228) (not e!170))))

(declare-fun b!282 () Bool)

(declare-fun e!169 () Bool)

(assert (=> b!282 (= e!169 call!48)))

(declare-fun b!283 () Bool)

(declare-fun e!168 () Bool)

(assert (=> b!283 (= e!168 e!170)))

(declare-fun res!225 () Bool)

(assert (=> b!283 (= res!225 (isBlack!0 (left!8 (left!8 t!78))))))

(assert (=> b!283 (=> (not res!225) (not e!170))))

(declare-fun b!284 () Bool)

(assert (=> b!284 (= e!171 e!168)))

(declare-fun c!65 () Bool)

(assert (=> b!284 (= c!65 ((_ is Black!3) (color!6 (left!8 t!78))))))

(declare-fun b!285 () Bool)

(assert (=> b!285 (= e!168 e!169)))

(declare-fun res!226 () Bool)

(assert (=> b!285 (= res!226 call!49)))

(assert (=> b!285 (=> (not res!226) (not e!169))))

(assert (= (and d!101 (not res!227)) b!284))

(assert (= (and b!284 c!65) b!285))

(assert (= (and b!284 (not c!65)) b!283))

(assert (= (and b!285 res!226) b!282))

(assert (= (and b!283 res!225) b!281))

(assert (= (and b!281 res!228) b!279))

(assert (= (and b!279 res!229) b!280))

(assert (= (or b!285 b!279) bm!48))

(assert (= (or b!282 b!280) bm!49))

(declare-fun m!267 () Bool)

(assert (=> bm!48 m!267))

(declare-fun m!269 () Bool)

(assert (=> bm!49 m!269))

(declare-fun m!271 () Bool)

(assert (=> b!281 m!271))

(declare-fun m!273 () Bool)

(assert (=> b!283 m!273))

(assert (=> bm!32 d!101))

(declare-fun d!103 () Bool)

(declare-fun c!66 () Bool)

(assert (=> d!103 (= c!66 ((_ is Empty!3) (left!8 lt!2)))))

(declare-fun e!172 () (InoxSet (_ BitVec 32)))

(assert (=> d!103 (= (content!0 (left!8 lt!2)) e!172)))

(declare-fun b!286 () Bool)

(assert (=> b!286 (= e!172 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!287 () Bool)

(assert (=> b!287 (= e!172 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 lt!2))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 lt!2)) true)) (content!0 (right!8 (left!8 lt!2)))))))

(assert (= (and d!103 c!66) b!286))

(assert (= (and d!103 (not c!66)) b!287))

(declare-fun m!275 () Bool)

(assert (=> b!287 m!275))

(declare-fun m!277 () Bool)

(assert (=> b!287 m!277))

(declare-fun m!279 () Bool)

(assert (=> b!287 m!279))

(assert (=> b!178 d!103))

(declare-fun d!105 () Bool)

(declare-fun c!67 () Bool)

(assert (=> d!105 (= c!67 ((_ is Empty!3) (right!8 lt!2)))))

(declare-fun e!173 () (InoxSet (_ BitVec 32)))

(assert (=> d!105 (= (content!0 (right!8 lt!2)) e!173)))

(declare-fun b!288 () Bool)

(assert (=> b!288 (= e!173 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!289 () Bool)

(assert (=> b!289 (= e!173 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 lt!2))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 lt!2)) true)) (content!0 (right!8 (right!8 lt!2)))))))

(assert (= (and d!105 c!67) b!288))

(assert (= (and d!105 (not c!67)) b!289))

(declare-fun m!281 () Bool)

(assert (=> b!289 m!281))

(declare-fun m!283 () Bool)

(assert (=> b!289 m!283))

(declare-fun m!285 () Bool)

(assert (=> b!289 m!285))

(assert (=> b!178 d!105))

(check-sat (not b!246) (not bm!47) (not b!275) (not b!227) (not b!283) (not b!289) (not b!251) (not bm!43) (not bm!45) (not b!232) (not b!276) (not b!261) (not bm!41) (not b!256) (not b!225) (not b!273) (not b!218) (not b!269) (not b!277) (not bm!46) (not b!278) (not b!270) (not b!242) (not b!243) (not b!287) (not b!219) (not b!249) (not b!244) (not bm!44) (not b!258) (not bm!42) (not b!267) (not d!93) (not bm!49) (not bm!48) (not bm!40) (not b!264) (not b!230) (not b!281) (not d!81))
(check-sat)
(get-model)

(declare-fun d!107 () Bool)

(declare-fun res!230 () Bool)

(declare-fun e!174 () Bool)

(assert (=> d!107 (=> res!230 e!174)))

(assert (=> d!107 (= res!230 (not ((_ is Node!3) (right!8 t!78))))))

(assert (=> d!107 (= (blackBalanced!0 (right!8 t!78)) e!174)))

(declare-fun b!290 () Bool)

(declare-fun e!175 () Bool)

(assert (=> b!290 (= e!174 e!175)))

(declare-fun res!232 () Bool)

(assert (=> b!290 (=> (not res!232) (not e!175))))

(assert (=> b!290 (= res!232 (blackBalanced!0 (left!8 (right!8 t!78))))))

(declare-fun b!291 () Bool)

(declare-fun res!231 () Bool)

(assert (=> b!291 (=> (not res!231) (not e!175))))

(assert (=> b!291 (= res!231 (blackBalanced!0 (right!8 (right!8 t!78))))))

(declare-fun b!292 () Bool)

(assert (=> b!292 (= e!175 (= (blackHeight!0 (left!8 (right!8 t!78))) (blackHeight!0 (right!8 (right!8 t!78)))))))

(assert (= (and d!107 (not res!230)) b!290))

(assert (= (and b!290 res!232) b!291))

(assert (= (and b!291 res!231) b!292))

(declare-fun m!287 () Bool)

(assert (=> b!290 m!287))

(declare-fun m!289 () Bool)

(assert (=> b!291 m!289))

(declare-fun m!291 () Bool)

(assert (=> b!292 m!291))

(declare-fun m!293 () Bool)

(assert (=> b!292 m!293))

(assert (=> b!277 d!107))

(declare-fun b!293 () Bool)

(declare-fun res!237 () Bool)

(declare-fun call!51 () Bool)

(assert (=> b!293 (= res!237 call!51)))

(declare-fun e!178 () Bool)

(assert (=> b!293 (=> (not res!237) (not e!178))))

(declare-fun d!109 () Bool)

(declare-fun res!235 () Bool)

(declare-fun e!179 () Bool)

(assert (=> d!109 (=> res!235 e!179)))

(assert (=> d!109 (= res!235 ((_ is Empty!3) (right!8 (left!8 lt!2))))))

(assert (=> d!109 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 lt!2))) e!179)))

(declare-fun b!294 () Bool)

(declare-fun call!50 () Bool)

(assert (=> b!294 (= e!178 call!50)))

(declare-fun bm!50 () Bool)

(assert (=> bm!50 (= call!51 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 lt!2)))))))

(declare-fun bm!51 () Bool)

(assert (=> bm!51 (= call!50 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 lt!2)))))))

(declare-fun b!295 () Bool)

(declare-fun res!236 () Bool)

(assert (=> b!295 (= res!236 (isBlack!0 (right!8 (right!8 (left!8 lt!2)))))))

(assert (=> b!295 (=> (not res!236) (not e!178))))

(declare-fun b!296 () Bool)

(declare-fun e!177 () Bool)

(assert (=> b!296 (= e!177 call!50)))

(declare-fun b!297 () Bool)

(declare-fun e!176 () Bool)

(assert (=> b!297 (= e!176 e!178)))

(declare-fun res!233 () Bool)

(assert (=> b!297 (= res!233 (isBlack!0 (left!8 (right!8 (left!8 lt!2)))))))

(assert (=> b!297 (=> (not res!233) (not e!178))))

(declare-fun b!298 () Bool)

(assert (=> b!298 (= e!179 e!176)))

(declare-fun c!68 () Bool)

(assert (=> b!298 (= c!68 ((_ is Black!3) (color!6 (right!8 (left!8 lt!2)))))))

(declare-fun b!299 () Bool)

(assert (=> b!299 (= e!176 e!177)))

(declare-fun res!234 () Bool)

(assert (=> b!299 (= res!234 call!51)))

(assert (=> b!299 (=> (not res!234) (not e!177))))

(assert (= (and d!109 (not res!235)) b!298))

(assert (= (and b!298 c!68) b!299))

(assert (= (and b!298 (not c!68)) b!297))

(assert (= (and b!299 res!234) b!296))

(assert (= (and b!297 res!233) b!295))

(assert (= (and b!295 res!236) b!293))

(assert (= (and b!293 res!237) b!294))

(assert (= (or b!299 b!293) bm!50))

(assert (= (or b!296 b!294) bm!51))

(declare-fun m!295 () Bool)

(assert (=> bm!50 m!295))

(declare-fun m!297 () Bool)

(assert (=> bm!51 m!297))

(declare-fun m!299 () Bool)

(assert (=> b!295 m!299))

(declare-fun m!301 () Bool)

(assert (=> b!297 m!301))

(assert (=> bm!43 d!109))

(declare-fun d!111 () Bool)

(declare-fun res!238 () Bool)

(declare-fun e!180 () Bool)

(assert (=> d!111 (=> res!238 e!180)))

(assert (=> d!111 (= res!238 (not ((_ is Node!3) (left!8 t!78))))))

(assert (=> d!111 (= (blackBalanced!0 (left!8 t!78)) e!180)))

(declare-fun b!300 () Bool)

(declare-fun e!181 () Bool)

(assert (=> b!300 (= e!180 e!181)))

(declare-fun res!240 () Bool)

(assert (=> b!300 (=> (not res!240) (not e!181))))

(assert (=> b!300 (= res!240 (blackBalanced!0 (left!8 (left!8 t!78))))))

(declare-fun b!301 () Bool)

(declare-fun res!239 () Bool)

(assert (=> b!301 (=> (not res!239) (not e!181))))

(assert (=> b!301 (= res!239 (blackBalanced!0 (right!8 (left!8 t!78))))))

(declare-fun b!302 () Bool)

(assert (=> b!302 (= e!181 (= (blackHeight!0 (left!8 (left!8 t!78))) (blackHeight!0 (right!8 (left!8 t!78)))))))

(assert (= (and d!111 (not res!238)) b!300))

(assert (= (and b!300 res!240) b!301))

(assert (= (and b!301 res!239) b!302))

(declare-fun m!303 () Bool)

(assert (=> b!300 m!303))

(declare-fun m!305 () Bool)

(assert (=> b!301 m!305))

(declare-fun m!307 () Bool)

(assert (=> b!302 m!307))

(declare-fun m!309 () Bool)

(assert (=> b!302 m!309))

(assert (=> b!276 d!111))

(declare-fun b!303 () Bool)

(declare-fun res!245 () Bool)

(declare-fun call!53 () Bool)

(assert (=> b!303 (= res!245 call!53)))

(declare-fun e!184 () Bool)

(assert (=> b!303 (=> (not res!245) (not e!184))))

(declare-fun d!113 () Bool)

(declare-fun res!243 () Bool)

(declare-fun e!185 () Bool)

(assert (=> d!113 (=> res!243 e!185)))

(assert (=> d!113 (= res!243 ((_ is Empty!3) (left!8 (left!8 lt!2))))))

(assert (=> d!113 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 lt!2))) e!185)))

(declare-fun b!304 () Bool)

(declare-fun call!52 () Bool)

(assert (=> b!304 (= e!184 call!52)))

(declare-fun bm!52 () Bool)

(assert (=> bm!52 (= call!53 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 lt!2)))))))

(declare-fun bm!53 () Bool)

(assert (=> bm!53 (= call!52 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 lt!2)))))))

(declare-fun b!305 () Bool)

(declare-fun res!244 () Bool)

(assert (=> b!305 (= res!244 (isBlack!0 (right!8 (left!8 (left!8 lt!2)))))))

(assert (=> b!305 (=> (not res!244) (not e!184))))

(declare-fun b!306 () Bool)

(declare-fun e!183 () Bool)

(assert (=> b!306 (= e!183 call!52)))

(declare-fun b!307 () Bool)

(declare-fun e!182 () Bool)

(assert (=> b!307 (= e!182 e!184)))

(declare-fun res!241 () Bool)

(assert (=> b!307 (= res!241 (isBlack!0 (left!8 (left!8 (left!8 lt!2)))))))

(assert (=> b!307 (=> (not res!241) (not e!184))))

(declare-fun b!308 () Bool)

(assert (=> b!308 (= e!185 e!182)))

(declare-fun c!69 () Bool)

(assert (=> b!308 (= c!69 ((_ is Black!3) (color!6 (left!8 (left!8 lt!2)))))))

(declare-fun b!309 () Bool)

(assert (=> b!309 (= e!182 e!183)))

(declare-fun res!242 () Bool)

(assert (=> b!309 (= res!242 call!53)))

(assert (=> b!309 (=> (not res!242) (not e!183))))

(assert (= (and d!113 (not res!243)) b!308))

(assert (= (and b!308 c!69) b!309))

(assert (= (and b!308 (not c!69)) b!307))

(assert (= (and b!309 res!242) b!306))

(assert (= (and b!307 res!241) b!305))

(assert (= (and b!305 res!244) b!303))

(assert (= (and b!303 res!245) b!304))

(assert (= (or b!309 b!303) bm!52))

(assert (= (or b!306 b!304) bm!53))

(declare-fun m!311 () Bool)

(assert (=> bm!52 m!311))

(declare-fun m!313 () Bool)

(assert (=> bm!53 m!313))

(declare-fun m!315 () Bool)

(assert (=> b!305 m!315))

(declare-fun m!317 () Bool)

(assert (=> b!307 m!317))

(assert (=> bm!42 d!113))

(declare-fun d!115 () Bool)

(declare-fun lt!14 () Int)

(assert (=> d!115 (>= lt!14 0)))

(declare-fun e!186 () Int)

(assert (=> d!115 (= lt!14 e!186)))

(declare-fun c!70 () Bool)

(assert (=> d!115 (= c!70 ((_ is Empty!3) (ite c!50 (left!8 t!78) (right!8 t!78))))))

(assert (=> d!115 (= (size!0 (ite c!50 (left!8 t!78) (right!8 t!78))) lt!14)))

(declare-fun b!310 () Bool)

(assert (=> b!310 (= e!186 0)))

(declare-fun b!311 () Bool)

(assert (=> b!311 (= e!186 (+ (size!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) 1 (size!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (= (and d!115 c!70) b!310))

(assert (= (and d!115 (not c!70)) b!311))

(declare-fun m!319 () Bool)

(assert (=> b!311 m!319))

(declare-fun m!321 () Bool)

(assert (=> b!311 m!321))

(assert (=> b!261 d!115))

(declare-fun d!117 () Bool)

(declare-fun lt!15 () Int)

(assert (=> d!117 (>= lt!15 0)))

(declare-fun e!187 () Int)

(assert (=> d!117 (= lt!15 e!187)))

(declare-fun c!71 () Bool)

(assert (=> d!117 (= c!71 ((_ is Empty!3) lt!13))))

(assert (=> d!117 (= (size!0 lt!13) lt!15)))

(declare-fun b!312 () Bool)

(assert (=> b!312 (= e!187 0)))

(declare-fun b!313 () Bool)

(assert (=> b!313 (= e!187 (+ (size!0 (left!8 lt!13)) 1 (size!0 (right!8 lt!13))))))

(assert (= (and d!117 c!71) b!312))

(assert (= (and d!117 (not c!71)) b!313))

(declare-fun m!323 () Bool)

(assert (=> b!313 m!323))

(declare-fun m!325 () Bool)

(assert (=> b!313 m!325))

(assert (=> b!261 d!117))

(assert (=> b!264 d!117))

(assert (=> b!264 d!115))

(declare-fun d!119 () Bool)

(assert (=> d!119 (= (isBlack!0 (left!8 (left!8 lt!2))) (or ((_ is Empty!3) (left!8 (left!8 lt!2))) ((_ is Black!3) (color!6 (left!8 (left!8 lt!2))))))))

(assert (=> b!251 d!119))

(declare-fun d!121 () Bool)

(declare-fun lt!16 () Tree!3)

(assert (=> d!121 (= (content!0 lt!16) (content!0 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))))))

(assert (=> d!121 (= lt!16 (ite (and ((_ is Black!3) (color!6 (ite c!50 (left!8 t!78) (right!8 t!78)))) ((_ is Node!3) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) ((_ is Red!3) (color!6 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) ((_ is Node!3) (left!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) ((_ is Red!3) (color!6 (left!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (Node!3 Red!3 (Node!3 Black!3 (left!8 (left!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (left!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (right!8 (left!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (value!38 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (Node!3 Black!3 (right!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) (ite (and ((_ is Black!3) (color!6 (ite c!50 (left!8 t!78) (right!8 t!78)))) ((_ is Node!3) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) ((_ is Red!3) (color!6 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) ((_ is Node!3) (right!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) ((_ is Red!3) (color!6 (right!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (Node!3 Red!3 (Node!3 Black!3 (left!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (value!38 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (left!8 (right!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (value!38 (right!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (Node!3 Black!3 (right!8 (right!8 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) (ite (and ((_ is Black!3) (color!6 (ite c!50 (left!8 t!78) (right!8 t!78)))) ((_ is Node!3) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)) ((_ is Red!3) (color!6 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) ((_ is Node!3) (left!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) ((_ is Red!3) (color!6 (left!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))))) (Node!3 Red!3 (Node!3 Black!3 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (left!8 (left!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))) (value!38 (left!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) (Node!3 Black!3 (right!8 (left!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) (value!38 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)) (right!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))) (ite (and ((_ is Black!3) (color!6 (ite c!50 (left!8 t!78) (right!8 t!78)))) ((_ is Node!3) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)) ((_ is Red!3) (color!6 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) ((_ is Node!3) (right!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) ((_ is Red!3) (color!6 (right!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))))) (Node!3 Red!3 (Node!3 Black!3 (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (left!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) (value!38 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)) (Node!3 Black!3 (left!8 (right!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) (value!38 (right!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) (right!8 (right!8 (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))))) (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))))))))

(assert (=> d!121 (= (balance!0 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)) lt!16)))

(declare-fun bs!3 () Bool)

(assert (= bs!3 d!121))

(declare-fun m!327 () Bool)

(assert (=> bs!3 m!327))

(declare-fun m!329 () Bool)

(assert (=> bs!3 m!329))

(assert (=> bm!46 d!121))

(declare-fun d!123 () Bool)

(declare-fun c!72 () Bool)

(assert (=> d!123 (= c!72 ((_ is Empty!3) lt!12))))

(declare-fun e!188 () (InoxSet (_ BitVec 32)))

(assert (=> d!123 (= (content!0 lt!12) e!188)))

(declare-fun b!314 () Bool)

(assert (=> b!314 (= e!188 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!315 () Bool)

(assert (=> b!315 (= e!188 ((_ map or) ((_ map or) (content!0 (left!8 lt!12)) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 lt!12) true)) (content!0 (right!8 lt!12))))))

(assert (= (and d!123 c!72) b!314))

(assert (= (and d!123 (not c!72)) b!315))

(declare-fun m!331 () Bool)

(assert (=> b!315 m!331))

(declare-fun m!333 () Bool)

(assert (=> b!315 m!333))

(declare-fun m!335 () Bool)

(assert (=> b!315 m!335))

(assert (=> d!81 d!123))

(declare-fun c!73 () Bool)

(declare-fun d!125 () Bool)

(assert (=> d!125 (= c!73 ((_ is Empty!3) (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))

(declare-fun e!189 () (InoxSet (_ BitVec 32)))

(assert (=> d!125 (= (content!0 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))) e!189)))

(declare-fun b!316 () Bool)

(assert (=> b!316 (= e!189 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!317 () Bool)

(assert (=> b!317 (= e!189 ((_ map or) ((_ map or) (content!0 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))) true)) (content!0 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))))

(assert (= (and d!125 c!73) b!316))

(assert (= (and d!125 (not c!73)) b!317))

(declare-fun m!337 () Bool)

(assert (=> b!317 m!337))

(declare-fun m!339 () Bool)

(assert (=> b!317 m!339))

(declare-fun m!341 () Bool)

(assert (=> b!317 m!341))

(assert (=> d!81 d!125))

(declare-fun d!127 () Bool)

(declare-fun res!246 () Bool)

(declare-fun e!190 () Bool)

(assert (=> d!127 (=> res!246 e!190)))

(assert (=> d!127 (= res!246 (not ((_ is Node!3) (left!8 lt!5))))))

(assert (=> d!127 (= (blackBalanced!0 (left!8 lt!5)) e!190)))

(declare-fun b!318 () Bool)

(declare-fun e!191 () Bool)

(assert (=> b!318 (= e!190 e!191)))

(declare-fun res!248 () Bool)

(assert (=> b!318 (=> (not res!248) (not e!191))))

(assert (=> b!318 (= res!248 (blackBalanced!0 (left!8 (left!8 lt!5))))))

(declare-fun b!319 () Bool)

(declare-fun res!247 () Bool)

(assert (=> b!319 (=> (not res!247) (not e!191))))

(assert (=> b!319 (= res!247 (blackBalanced!0 (right!8 (left!8 lt!5))))))

(declare-fun b!320 () Bool)

(assert (=> b!320 (= e!191 (= (blackHeight!0 (left!8 (left!8 lt!5))) (blackHeight!0 (right!8 (left!8 lt!5)))))))

(assert (= (and d!127 (not res!246)) b!318))

(assert (= (and b!318 res!248) b!319))

(assert (= (and b!319 res!247) b!320))

(declare-fun m!343 () Bool)

(assert (=> b!318 m!343))

(declare-fun m!345 () Bool)

(assert (=> b!319 m!345))

(declare-fun m!347 () Bool)

(assert (=> b!320 m!347))

(declare-fun m!349 () Bool)

(assert (=> b!320 m!349))

(assert (=> b!242 d!127))

(declare-fun d!129 () Bool)

(declare-fun c!78 () Bool)

(assert (=> d!129 (= c!78 ((_ is Empty!3) (left!8 t!78)))))

(declare-fun e!196 () (_ BitVec 32))

(assert (=> d!129 (= (blackHeight!0 (left!8 t!78)) e!196)))

(declare-fun b!329 () Bool)

(declare-fun e!197 () (_ BitVec 32))

(declare-fun call!56 () (_ BitVec 32))

(assert (=> b!329 (= e!197 (bvadd call!56 #b00000000000000000000000000000001))))

(declare-fun bm!56 () Bool)

(assert (=> bm!56 (= call!56 (blackHeight!0 (left!8 (left!8 t!78))))))

(declare-fun b!330 () Bool)

(assert (=> b!330 (= e!197 call!56)))

(declare-fun b!331 () Bool)

(assert (=> b!331 (= e!196 e!197)))

(declare-fun c!79 () Bool)

(assert (=> b!331 (= c!79 ((_ is Black!3) (color!6 (left!8 t!78))))))

(declare-fun b!332 () Bool)

(assert (=> b!332 (= e!196 #b00000000000000000000000000000001)))

(assert (= (and d!129 c!78) b!332))

(assert (= (and d!129 (not c!78)) b!331))

(assert (= (and b!331 c!79) b!329))

(assert (= (and b!331 (not c!79)) b!330))

(assert (= (or b!329 b!330) bm!56))

(assert (=> bm!56 m!307))

(assert (=> b!278 d!129))

(declare-fun d!131 () Bool)

(declare-fun c!80 () Bool)

(assert (=> d!131 (= c!80 ((_ is Empty!3) (right!8 t!78)))))

(declare-fun e!198 () (_ BitVec 32))

(assert (=> d!131 (= (blackHeight!0 (right!8 t!78)) e!198)))

(declare-fun b!333 () Bool)

(declare-fun e!199 () (_ BitVec 32))

(declare-fun call!57 () (_ BitVec 32))

(assert (=> b!333 (= e!199 (bvadd call!57 #b00000000000000000000000000000001))))

(declare-fun bm!57 () Bool)

(assert (=> bm!57 (= call!57 (blackHeight!0 (left!8 (right!8 t!78))))))

(declare-fun b!334 () Bool)

(assert (=> b!334 (= e!199 call!57)))

(declare-fun b!335 () Bool)

(assert (=> b!335 (= e!198 e!199)))

(declare-fun c!81 () Bool)

(assert (=> b!335 (= c!81 ((_ is Black!3) (color!6 (right!8 t!78))))))

(declare-fun b!336 () Bool)

(assert (=> b!336 (= e!198 #b00000000000000000000000000000001)))

(assert (= (and d!131 c!80) b!336))

(assert (= (and d!131 (not c!80)) b!335))

(assert (= (and b!335 c!81) b!333))

(assert (= (and b!335 (not c!81)) b!334))

(assert (= (or b!333 b!334) bm!57))

(assert (=> bm!57 m!291))

(assert (=> b!278 d!131))

(declare-fun d!133 () Bool)

(assert (=> d!133 (= (isBlack!0 (right!8 (left!8 lt!2))) (or ((_ is Empty!3) (right!8 (left!8 lt!2))) ((_ is Black!3) (color!6 (right!8 (left!8 lt!2))))))))

(assert (=> b!249 d!133))

(declare-fun d!135 () Bool)

(declare-fun c!82 () Bool)

(assert (=> d!135 (= c!82 ((_ is Empty!3) (left!8 (left!8 t!78))))))

(declare-fun e!200 () (InoxSet (_ BitVec 32)))

(assert (=> d!135 (= (content!0 (left!8 (left!8 t!78))) e!200)))

(declare-fun b!337 () Bool)

(assert (=> b!337 (= e!200 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!338 () Bool)

(assert (=> b!338 (= e!200 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 t!78)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 t!78))) true)) (content!0 (right!8 (left!8 (left!8 t!78))))))))

(assert (= (and d!135 c!82) b!337))

(assert (= (and d!135 (not c!82)) b!338))

(declare-fun m!351 () Bool)

(assert (=> b!338 m!351))

(declare-fun m!353 () Bool)

(assert (=> b!338 m!353))

(declare-fun m!355 () Bool)

(assert (=> b!338 m!355))

(assert (=> b!273 d!135))

(declare-fun d!137 () Bool)

(declare-fun c!83 () Bool)

(assert (=> d!137 (= c!83 ((_ is Empty!3) (right!8 (left!8 t!78))))))

(declare-fun e!201 () (InoxSet (_ BitVec 32)))

(assert (=> d!137 (= (content!0 (right!8 (left!8 t!78))) e!201)))

(declare-fun b!339 () Bool)

(assert (=> b!339 (= e!201 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!340 () Bool)

(assert (=> b!340 (= e!201 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 t!78)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 t!78))) true)) (content!0 (right!8 (right!8 (left!8 t!78))))))))

(assert (= (and d!137 c!83) b!339))

(assert (= (and d!137 (not c!83)) b!340))

(declare-fun m!357 () Bool)

(assert (=> b!340 m!357))

(declare-fun m!359 () Bool)

(assert (=> b!340 m!359))

(declare-fun m!361 () Bool)

(assert (=> b!340 m!361))

(assert (=> b!273 d!137))

(declare-fun d!139 () Bool)

(declare-fun lt!17 () Int)

(assert (=> d!139 (>= lt!17 0)))

(declare-fun e!202 () Int)

(assert (=> d!139 (= lt!17 e!202)))

(declare-fun c!84 () Bool)

(assert (=> d!139 (= c!84 ((_ is Empty!3) (left!8 t!78)))))

(assert (=> d!139 (= (size!0 (left!8 t!78)) lt!17)))

(declare-fun b!341 () Bool)

(assert (=> b!341 (= e!202 0)))

(declare-fun b!342 () Bool)

(assert (=> b!342 (= e!202 (+ (size!0 (left!8 (left!8 t!78))) 1 (size!0 (right!8 (left!8 t!78)))))))

(assert (= (and d!139 c!84) b!341))

(assert (= (and d!139 (not c!84)) b!342))

(declare-fun m!363 () Bool)

(assert (=> b!342 m!363))

(declare-fun m!365 () Bool)

(assert (=> b!342 m!365))

(assert (=> b!225 d!139))

(declare-fun d!141 () Bool)

(declare-fun lt!18 () Int)

(assert (=> d!141 (>= lt!18 0)))

(declare-fun e!203 () Int)

(assert (=> d!141 (= lt!18 e!203)))

(declare-fun c!85 () Bool)

(assert (=> d!141 (= c!85 ((_ is Empty!3) (right!8 t!78)))))

(assert (=> d!141 (= (size!0 (right!8 t!78)) lt!18)))

(declare-fun b!343 () Bool)

(assert (=> b!343 (= e!203 0)))

(declare-fun b!344 () Bool)

(assert (=> b!344 (= e!203 (+ (size!0 (left!8 (right!8 t!78))) 1 (size!0 (right!8 (right!8 t!78)))))))

(assert (= (and d!141 c!85) b!343))

(assert (= (and d!141 (not c!85)) b!344))

(declare-fun m!367 () Bool)

(assert (=> b!344 m!367))

(declare-fun m!369 () Bool)

(assert (=> b!344 m!369))

(assert (=> b!225 d!141))

(declare-fun d!143 () Bool)

(declare-fun c!86 () Bool)

(assert (=> d!143 (= c!86 ((_ is Empty!3) (left!8 (right!8 lt!2))))))

(declare-fun e!204 () (InoxSet (_ BitVec 32)))

(assert (=> d!143 (= (content!0 (left!8 (right!8 lt!2))) e!204)))

(declare-fun b!345 () Bool)

(assert (=> b!345 (= e!204 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!346 () Bool)

(assert (=> b!346 (= e!204 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 lt!2)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 lt!2))) true)) (content!0 (right!8 (left!8 (right!8 lt!2))))))))

(assert (= (and d!143 c!86) b!345))

(assert (= (and d!143 (not c!86)) b!346))

(declare-fun m!371 () Bool)

(assert (=> b!346 m!371))

(declare-fun m!373 () Bool)

(assert (=> b!346 m!373))

(declare-fun m!375 () Bool)

(assert (=> b!346 m!375))

(assert (=> b!289 d!143))

(declare-fun d!145 () Bool)

(declare-fun c!87 () Bool)

(assert (=> d!145 (= c!87 ((_ is Empty!3) (right!8 (right!8 lt!2))))))

(declare-fun e!205 () (InoxSet (_ BitVec 32)))

(assert (=> d!145 (= (content!0 (right!8 (right!8 lt!2))) e!205)))

(declare-fun b!347 () Bool)

(assert (=> b!347 (= e!205 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!348 () Bool)

(assert (=> b!348 (= e!205 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 lt!2)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 lt!2))) true)) (content!0 (right!8 (right!8 (right!8 lt!2))))))))

(assert (= (and d!145 c!87) b!347))

(assert (= (and d!145 (not c!87)) b!348))

(declare-fun m!377 () Bool)

(assert (=> b!348 m!377))

(declare-fun m!379 () Bool)

(assert (=> b!348 m!379))

(declare-fun m!381 () Bool)

(assert (=> b!348 m!381))

(assert (=> b!289 d!145))

(declare-fun d!147 () Bool)

(declare-fun c!88 () Bool)

(assert (=> d!147 (= c!88 ((_ is Empty!3) (left!8 lt!5)))))

(declare-fun e!206 () (InoxSet (_ BitVec 32)))

(assert (=> d!147 (= (content!0 (left!8 lt!5)) e!206)))

(declare-fun b!349 () Bool)

(assert (=> b!349 (= e!206 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!350 () Bool)

(assert (=> b!350 (= e!206 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 lt!5))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 lt!5)) true)) (content!0 (right!8 (left!8 lt!5)))))))

(assert (= (and d!147 c!88) b!349))

(assert (= (and d!147 (not c!88)) b!350))

(declare-fun m!383 () Bool)

(assert (=> b!350 m!383))

(declare-fun m!385 () Bool)

(assert (=> b!350 m!385))

(declare-fun m!387 () Bool)

(assert (=> b!350 m!387))

(assert (=> b!246 d!147))

(declare-fun d!149 () Bool)

(declare-fun c!89 () Bool)

(assert (=> d!149 (= c!89 ((_ is Empty!3) (right!8 lt!5)))))

(declare-fun e!207 () (InoxSet (_ BitVec 32)))

(assert (=> d!149 (= (content!0 (right!8 lt!5)) e!207)))

(declare-fun b!351 () Bool)

(assert (=> b!351 (= e!207 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!352 () Bool)

(assert (=> b!352 (= e!207 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 lt!5))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 lt!5)) true)) (content!0 (right!8 (right!8 lt!5)))))))

(assert (= (and d!149 c!89) b!351))

(assert (= (and d!149 (not c!89)) b!352))

(declare-fun m!389 () Bool)

(assert (=> b!352 m!389))

(declare-fun m!391 () Bool)

(assert (=> b!352 m!391))

(declare-fun m!393 () Bool)

(assert (=> b!352 m!393))

(assert (=> b!246 d!149))

(declare-fun d!151 () Bool)

(declare-fun res!249 () Bool)

(declare-fun e!208 () Bool)

(assert (=> d!151 (=> res!249 e!208)))

(assert (=> d!151 (= res!249 ((_ is Empty!3) lt!13))))

(assert (=> d!151 (= (redDescHaveBlackChildren!0 lt!13) e!208)))

(declare-fun b!353 () Bool)

(declare-fun e!209 () Bool)

(assert (=> b!353 (= e!208 e!209)))

(declare-fun res!250 () Bool)

(assert (=> b!353 (=> (not res!250) (not e!209))))

(assert (=> b!353 (= res!250 (redNodesHaveBlackChildren!0 (left!8 lt!13)))))

(declare-fun b!354 () Bool)

(assert (=> b!354 (= e!209 (redNodesHaveBlackChildren!0 (right!8 lt!13)))))

(assert (= (and d!151 (not res!249)) b!353))

(assert (= (and b!353 res!250) b!354))

(declare-fun m!395 () Bool)

(assert (=> b!353 m!395))

(declare-fun m!397 () Bool)

(assert (=> b!354 m!397))

(assert (=> b!270 d!151))

(declare-fun d!153 () Bool)

(assert (=> d!153 (= (isBlack!0 (right!8 (right!8 t!78))) (or ((_ is Empty!3) (right!8 (right!8 t!78))) ((_ is Black!3) (color!6 (right!8 (right!8 t!78))))))))

(assert (=> b!256 d!153))

(declare-fun b!355 () Bool)

(declare-fun res!254 () Bool)

(declare-fun e!214 () Bool)

(assert (=> b!355 (=> (not res!254) (not e!214))))

(declare-fun lt!19 () Tree!3)

(assert (=> b!355 (= res!254 (<= (size!0 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (size!0 lt!19)))))

(declare-fun b!356 () Bool)

(declare-fun e!212 () Tree!3)

(declare-fun call!59 () Tree!3)

(assert (=> b!356 (= e!212 call!59)))

(declare-fun b!357 () Bool)

(declare-fun e!210 () Tree!3)

(assert (=> b!357 (= e!210 call!59)))

(declare-fun b!358 () Bool)

(declare-fun res!252 () Bool)

(assert (=> b!358 (=> (not res!252) (not e!214))))

(assert (=> b!358 (= res!252 (<= (size!0 lt!19) (+ (size!0 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) 1)))))

(declare-fun bm!58 () Bool)

(declare-fun call!58 () Tree!3)

(declare-fun c!92 () Bool)

(assert (=> bm!58 (= call!59 (balance!0 (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58)))))

(declare-fun b!359 () Bool)

(declare-fun e!211 () Tree!3)

(assert (=> b!359 (= e!211 e!210)))

(assert (=> b!359 (= c!92 (bvslt x!73 (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun c!90 () Bool)

(declare-fun b!360 () Bool)

(assert (=> b!360 (= c!90 (= x!73 (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!360 (= e!210 e!212)))

(declare-fun b!362 () Bool)

(assert (=> b!362 (= e!211 (Node!3 Red!3 Empty!3 x!73 Empty!3))))

(declare-fun b!363 () Bool)

(declare-fun e!213 () Bool)

(assert (=> b!363 (= e!213 (blackBalanced!0 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun bm!59 () Bool)

(assert (=> bm!59 (= call!58 (ins!0 x!73 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!361 () Bool)

(assert (=> b!361 (= e!214 (blackBalanced!0 lt!19))))

(declare-fun d!155 () Bool)

(assert (=> d!155 e!214))

(declare-fun res!251 () Bool)

(assert (=> d!155 (=> (not res!251) (not e!214))))

(assert (=> d!155 (= res!251 (= (content!0 lt!19) ((_ map or) (content!0 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) x!73 true))))))

(assert (=> d!155 (= lt!19 e!211)))

(declare-fun c!91 () Bool)

(assert (=> d!155 (= c!91 ((_ is Empty!3) (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!155 e!213))

(declare-fun res!255 () Bool)

(assert (=> d!155 (=> (not res!255) (not e!213))))

(assert (=> d!155 (= res!255 (redNodesHaveBlackChildren!0 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!155 (= (ins!0 x!73 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) lt!19)))

(declare-fun b!364 () Bool)

(declare-fun res!253 () Bool)

(assert (=> b!364 (=> (not res!253) (not e!214))))

(assert (=> b!364 (= res!253 (redDescHaveBlackChildren!0 lt!19))))

(declare-fun b!365 () Bool)

(assert (=> b!365 (= e!212 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(assert (= (and d!155 res!255) b!363))

(assert (= (and d!155 c!91) b!362))

(assert (= (and d!155 (not c!91)) b!359))

(assert (= (and b!359 c!92) b!357))

(assert (= (and b!359 (not c!92)) b!360))

(assert (= (and b!360 c!90) b!365))

(assert (= (and b!360 (not c!90)) b!356))

(assert (= (or b!357 b!356) bm!59))

(assert (= (or b!357 b!356) bm!58))

(assert (= (and d!155 res!251) b!355))

(assert (= (and b!355 res!254) b!358))

(assert (= (and b!358 res!252) b!364))

(assert (= (and b!364 res!253) b!361))

(declare-fun m!399 () Bool)

(assert (=> d!155 m!399))

(declare-fun m!401 () Bool)

(assert (=> d!155 m!401))

(assert (=> d!155 m!123))

(declare-fun m!403 () Bool)

(assert (=> d!155 m!403))

(declare-fun m!405 () Bool)

(assert (=> bm!59 m!405))

(declare-fun m!407 () Bool)

(assert (=> bm!58 m!407))

(declare-fun m!409 () Bool)

(assert (=> b!363 m!409))

(declare-fun m!411 () Bool)

(assert (=> b!355 m!411))

(declare-fun m!413 () Bool)

(assert (=> b!355 m!413))

(assert (=> b!358 m!413))

(assert (=> b!358 m!411))

(declare-fun m!415 () Bool)

(assert (=> b!361 m!415))

(declare-fun m!417 () Bool)

(assert (=> b!364 m!417))

(assert (=> bm!47 d!155))

(declare-fun d!157 () Bool)

(assert (=> d!157 (= (isBlack!0 (left!8 (right!8 lt!2))) (or ((_ is Empty!3) (left!8 (right!8 lt!2))) ((_ is Black!3) (color!6 (left!8 (right!8 lt!2))))))))

(assert (=> b!232 d!157))

(declare-fun d!159 () Bool)

(assert (=> d!159 (= (isBlack!0 (left!8 (left!8 t!78))) (or ((_ is Empty!3) (left!8 (left!8 t!78))) ((_ is Black!3) (color!6 (left!8 (left!8 t!78))))))))

(assert (=> b!283 d!159))

(declare-fun b!366 () Bool)

(declare-fun res!260 () Bool)

(declare-fun call!61 () Bool)

(assert (=> b!366 (= res!260 call!61)))

(declare-fun e!217 () Bool)

(assert (=> b!366 (=> (not res!260) (not e!217))))

(declare-fun d!161 () Bool)

(declare-fun res!258 () Bool)

(declare-fun e!218 () Bool)

(assert (=> d!161 (=> res!258 e!218)))

(assert (=> d!161 (= res!258 ((_ is Empty!3) (left!8 (right!8 t!78))))))

(assert (=> d!161 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 t!78))) e!218)))

(declare-fun b!367 () Bool)

(declare-fun call!60 () Bool)

(assert (=> b!367 (= e!217 call!60)))

(declare-fun bm!60 () Bool)

(assert (=> bm!60 (= call!61 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 t!78)))))))

(declare-fun bm!61 () Bool)

(assert (=> bm!61 (= call!60 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 t!78)))))))

(declare-fun b!368 () Bool)

(declare-fun res!259 () Bool)

(assert (=> b!368 (= res!259 (isBlack!0 (right!8 (left!8 (right!8 t!78)))))))

(assert (=> b!368 (=> (not res!259) (not e!217))))

(declare-fun b!369 () Bool)

(declare-fun e!216 () Bool)

(assert (=> b!369 (= e!216 call!60)))

(declare-fun b!370 () Bool)

(declare-fun e!215 () Bool)

(assert (=> b!370 (= e!215 e!217)))

(declare-fun res!256 () Bool)

(assert (=> b!370 (= res!256 (isBlack!0 (left!8 (left!8 (right!8 t!78)))))))

(assert (=> b!370 (=> (not res!256) (not e!217))))

(declare-fun b!371 () Bool)

(assert (=> b!371 (= e!218 e!215)))

(declare-fun c!93 () Bool)

(assert (=> b!371 (= c!93 ((_ is Black!3) (color!6 (left!8 (right!8 t!78)))))))

(declare-fun b!372 () Bool)

(assert (=> b!372 (= e!215 e!216)))

(declare-fun res!257 () Bool)

(assert (=> b!372 (= res!257 call!61)))

(assert (=> b!372 (=> (not res!257) (not e!216))))

(assert (= (and d!161 (not res!258)) b!371))

(assert (= (and b!371 c!93) b!372))

(assert (= (and b!371 (not c!93)) b!370))

(assert (= (and b!372 res!257) b!369))

(assert (= (and b!370 res!256) b!368))

(assert (= (and b!368 res!259) b!366))

(assert (= (and b!366 res!260) b!367))

(assert (= (or b!372 b!366) bm!60))

(assert (= (or b!369 b!367) bm!61))

(declare-fun m!419 () Bool)

(assert (=> bm!60 m!419))

(declare-fun m!421 () Bool)

(assert (=> bm!61 m!421))

(declare-fun m!423 () Bool)

(assert (=> b!368 m!423))

(declare-fun m!425 () Bool)

(assert (=> b!370 m!425))

(assert (=> bm!44 d!161))

(declare-fun b!373 () Bool)

(declare-fun res!265 () Bool)

(declare-fun call!63 () Bool)

(assert (=> b!373 (= res!265 call!63)))

(declare-fun e!221 () Bool)

(assert (=> b!373 (=> (not res!265) (not e!221))))

(declare-fun d!163 () Bool)

(declare-fun res!263 () Bool)

(declare-fun e!222 () Bool)

(assert (=> d!163 (=> res!263 e!222)))

(assert (=> d!163 (= res!263 ((_ is Empty!3) (right!8 (right!8 t!78))))))

(assert (=> d!163 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 t!78))) e!222)))

(declare-fun b!374 () Bool)

(declare-fun call!62 () Bool)

(assert (=> b!374 (= e!221 call!62)))

(declare-fun bm!62 () Bool)

(assert (=> bm!62 (= call!63 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 t!78)))))))

(declare-fun bm!63 () Bool)

(assert (=> bm!63 (= call!62 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 t!78)))))))

(declare-fun b!375 () Bool)

(declare-fun res!264 () Bool)

(assert (=> b!375 (= res!264 (isBlack!0 (right!8 (right!8 (right!8 t!78)))))))

(assert (=> b!375 (=> (not res!264) (not e!221))))

(declare-fun b!376 () Bool)

(declare-fun e!220 () Bool)

(assert (=> b!376 (= e!220 call!62)))

(declare-fun b!377 () Bool)

(declare-fun e!219 () Bool)

(assert (=> b!377 (= e!219 e!221)))

(declare-fun res!261 () Bool)

(assert (=> b!377 (= res!261 (isBlack!0 (left!8 (right!8 (right!8 t!78)))))))

(assert (=> b!377 (=> (not res!261) (not e!221))))

(declare-fun b!378 () Bool)

(assert (=> b!378 (= e!222 e!219)))

(declare-fun c!94 () Bool)

(assert (=> b!378 (= c!94 ((_ is Black!3) (color!6 (right!8 (right!8 t!78)))))))

(declare-fun b!379 () Bool)

(assert (=> b!379 (= e!219 e!220)))

(declare-fun res!262 () Bool)

(assert (=> b!379 (= res!262 call!63)))

(assert (=> b!379 (=> (not res!262) (not e!220))))

(assert (= (and d!163 (not res!263)) b!378))

(assert (= (and b!378 c!94) b!379))

(assert (= (and b!378 (not c!94)) b!377))

(assert (= (and b!379 res!262) b!376))

(assert (= (and b!377 res!261) b!375))

(assert (= (and b!375 res!264) b!373))

(assert (= (and b!373 res!265) b!374))

(assert (= (or b!379 b!373) bm!62))

(assert (= (or b!376 b!374) bm!63))

(declare-fun m!427 () Bool)

(assert (=> bm!62 m!427))

(declare-fun m!429 () Bool)

(assert (=> bm!63 m!429))

(declare-fun m!431 () Bool)

(assert (=> b!375 m!431))

(declare-fun m!433 () Bool)

(assert (=> b!377 m!433))

(assert (=> bm!45 d!163))

(declare-fun b!380 () Bool)

(declare-fun res!270 () Bool)

(declare-fun call!65 () Bool)

(assert (=> b!380 (= res!270 call!65)))

(declare-fun e!225 () Bool)

(assert (=> b!380 (=> (not res!270) (not e!225))))

(declare-fun d!165 () Bool)

(declare-fun res!268 () Bool)

(declare-fun e!226 () Bool)

(assert (=> d!165 (=> res!268 e!226)))

(assert (=> d!165 (= res!268 ((_ is Empty!3) (right!8 lt!5)))))

(assert (=> d!165 (= (redNodesHaveBlackChildren!0 (right!8 lt!5)) e!226)))

(declare-fun b!381 () Bool)

(declare-fun call!64 () Bool)

(assert (=> b!381 (= e!225 call!64)))

(declare-fun bm!64 () Bool)

(assert (=> bm!64 (= call!65 (redNodesHaveBlackChildren!0 (left!8 (right!8 lt!5))))))

(declare-fun bm!65 () Bool)

(assert (=> bm!65 (= call!64 (redNodesHaveBlackChildren!0 (right!8 (right!8 lt!5))))))

(declare-fun b!382 () Bool)

(declare-fun res!269 () Bool)

(assert (=> b!382 (= res!269 (isBlack!0 (right!8 (right!8 lt!5))))))

(assert (=> b!382 (=> (not res!269) (not e!225))))

(declare-fun b!383 () Bool)

(declare-fun e!224 () Bool)

(assert (=> b!383 (= e!224 call!64)))

(declare-fun b!384 () Bool)

(declare-fun e!223 () Bool)

(assert (=> b!384 (= e!223 e!225)))

(declare-fun res!266 () Bool)

(assert (=> b!384 (= res!266 (isBlack!0 (left!8 (right!8 lt!5))))))

(assert (=> b!384 (=> (not res!266) (not e!225))))

(declare-fun b!385 () Bool)

(assert (=> b!385 (= e!226 e!223)))

(declare-fun c!95 () Bool)

(assert (=> b!385 (= c!95 ((_ is Black!3) (color!6 (right!8 lt!5))))))

(declare-fun b!386 () Bool)

(assert (=> b!386 (= e!223 e!224)))

(declare-fun res!267 () Bool)

(assert (=> b!386 (= res!267 call!65)))

(assert (=> b!386 (=> (not res!267) (not e!224))))

(assert (= (and d!165 (not res!268)) b!385))

(assert (= (and b!385 c!95) b!386))

(assert (= (and b!385 (not c!95)) b!384))

(assert (= (and b!386 res!267) b!383))

(assert (= (and b!384 res!266) b!382))

(assert (= (and b!382 res!269) b!380))

(assert (= (and b!380 res!270) b!381))

(assert (= (or b!386 b!380) bm!64))

(assert (= (or b!383 b!381) bm!65))

(declare-fun m!435 () Bool)

(assert (=> bm!64 m!435))

(declare-fun m!437 () Bool)

(assert (=> bm!65 m!437))

(declare-fun m!439 () Bool)

(assert (=> b!382 m!439))

(declare-fun m!441 () Bool)

(assert (=> b!384 m!441))

(assert (=> b!219 d!165))

(declare-fun d!167 () Bool)

(assert (=> d!167 (= (isBlack!0 (left!8 (right!8 t!78))) (or ((_ is Empty!3) (left!8 (right!8 t!78))) ((_ is Black!3) (color!6 (left!8 (right!8 t!78))))))))

(assert (=> b!258 d!167))

(declare-fun b!387 () Bool)

(declare-fun res!275 () Bool)

(declare-fun call!67 () Bool)

(assert (=> b!387 (= res!275 call!67)))

(declare-fun e!229 () Bool)

(assert (=> b!387 (=> (not res!275) (not e!229))))

(declare-fun d!169 () Bool)

(declare-fun res!273 () Bool)

(declare-fun e!230 () Bool)

(assert (=> d!169 (=> res!273 e!230)))

(assert (=> d!169 (= res!273 ((_ is Empty!3) (left!8 lt!5)))))

(assert (=> d!169 (= (redNodesHaveBlackChildren!0 (left!8 lt!5)) e!230)))

(declare-fun b!388 () Bool)

(declare-fun call!66 () Bool)

(assert (=> b!388 (= e!229 call!66)))

(declare-fun bm!66 () Bool)

(assert (=> bm!66 (= call!67 (redNodesHaveBlackChildren!0 (left!8 (left!8 lt!5))))))

(declare-fun bm!67 () Bool)

(assert (=> bm!67 (= call!66 (redNodesHaveBlackChildren!0 (right!8 (left!8 lt!5))))))

(declare-fun b!389 () Bool)

(declare-fun res!274 () Bool)

(assert (=> b!389 (= res!274 (isBlack!0 (right!8 (left!8 lt!5))))))

(assert (=> b!389 (=> (not res!274) (not e!229))))

(declare-fun b!390 () Bool)

(declare-fun e!228 () Bool)

(assert (=> b!390 (= e!228 call!66)))

(declare-fun b!391 () Bool)

(declare-fun e!227 () Bool)

(assert (=> b!391 (= e!227 e!229)))

(declare-fun res!271 () Bool)

(assert (=> b!391 (= res!271 (isBlack!0 (left!8 (left!8 lt!5))))))

(assert (=> b!391 (=> (not res!271) (not e!229))))

(declare-fun b!392 () Bool)

(assert (=> b!392 (= e!230 e!227)))

(declare-fun c!96 () Bool)

(assert (=> b!392 (= c!96 ((_ is Black!3) (color!6 (left!8 lt!5))))))

(declare-fun b!393 () Bool)

(assert (=> b!393 (= e!227 e!228)))

(declare-fun res!272 () Bool)

(assert (=> b!393 (= res!272 call!67)))

(assert (=> b!393 (=> (not res!272) (not e!228))))

(assert (= (and d!169 (not res!273)) b!392))

(assert (= (and b!392 c!96) b!393))

(assert (= (and b!392 (not c!96)) b!391))

(assert (= (and b!393 res!272) b!390))

(assert (= (and b!391 res!271) b!389))

(assert (= (and b!389 res!274) b!387))

(assert (= (and b!387 res!275) b!388))

(assert (= (or b!393 b!387) bm!66))

(assert (= (or b!390 b!388) bm!67))

(declare-fun m!443 () Bool)

(assert (=> bm!66 m!443))

(declare-fun m!445 () Bool)

(assert (=> bm!67 m!445))

(declare-fun m!447 () Bool)

(assert (=> b!389 m!447))

(declare-fun m!449 () Bool)

(assert (=> b!391 m!449))

(assert (=> b!218 d!169))

(declare-fun b!394 () Bool)

(declare-fun res!280 () Bool)

(declare-fun call!69 () Bool)

(assert (=> b!394 (= res!280 call!69)))

(declare-fun e!233 () Bool)

(assert (=> b!394 (=> (not res!280) (not e!233))))

(declare-fun d!171 () Bool)

(declare-fun res!278 () Bool)

(declare-fun e!234 () Bool)

(assert (=> d!171 (=> res!278 e!234)))

(assert (=> d!171 (= res!278 ((_ is Empty!3) (left!8 (right!8 lt!2))))))

(assert (=> d!171 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 lt!2))) e!234)))

(declare-fun b!395 () Bool)

(declare-fun call!68 () Bool)

(assert (=> b!395 (= e!233 call!68)))

(declare-fun bm!68 () Bool)

(assert (=> bm!68 (= call!69 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 lt!2)))))))

(declare-fun bm!69 () Bool)

(assert (=> bm!69 (= call!68 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 lt!2)))))))

(declare-fun b!396 () Bool)

(declare-fun res!279 () Bool)

(assert (=> b!396 (= res!279 (isBlack!0 (right!8 (left!8 (right!8 lt!2)))))))

(assert (=> b!396 (=> (not res!279) (not e!233))))

(declare-fun b!397 () Bool)

(declare-fun e!232 () Bool)

(assert (=> b!397 (= e!232 call!68)))

(declare-fun b!398 () Bool)

(declare-fun e!231 () Bool)

(assert (=> b!398 (= e!231 e!233)))

(declare-fun res!276 () Bool)

(assert (=> b!398 (= res!276 (isBlack!0 (left!8 (left!8 (right!8 lt!2)))))))

(assert (=> b!398 (=> (not res!276) (not e!233))))

(declare-fun b!399 () Bool)

(assert (=> b!399 (= e!234 e!231)))

(declare-fun c!97 () Bool)

(assert (=> b!399 (= c!97 ((_ is Black!3) (color!6 (left!8 (right!8 lt!2)))))))

(declare-fun b!400 () Bool)

(assert (=> b!400 (= e!231 e!232)))

(declare-fun res!277 () Bool)

(assert (=> b!400 (= res!277 call!69)))

(assert (=> b!400 (=> (not res!277) (not e!232))))

(assert (= (and d!171 (not res!278)) b!399))

(assert (= (and b!399 c!97) b!400))

(assert (= (and b!399 (not c!97)) b!398))

(assert (= (and b!400 res!277) b!397))

(assert (= (and b!398 res!276) b!396))

(assert (= (and b!396 res!279) b!394))

(assert (= (and b!394 res!280) b!395))

(assert (= (or b!400 b!394) bm!68))

(assert (= (or b!397 b!395) bm!69))

(declare-fun m!451 () Bool)

(assert (=> bm!68 m!451))

(declare-fun m!453 () Bool)

(assert (=> bm!69 m!453))

(declare-fun m!455 () Bool)

(assert (=> b!396 m!455))

(declare-fun m!457 () Bool)

(assert (=> b!398 m!457))

(assert (=> bm!40 d!171))

(declare-fun b!401 () Bool)

(declare-fun res!285 () Bool)

(declare-fun call!71 () Bool)

(assert (=> b!401 (= res!285 call!71)))

(declare-fun e!237 () Bool)

(assert (=> b!401 (=> (not res!285) (not e!237))))

(declare-fun d!173 () Bool)

(declare-fun res!283 () Bool)

(declare-fun e!238 () Bool)

(assert (=> d!173 (=> res!283 e!238)))

(assert (=> d!173 (= res!283 ((_ is Empty!3) (left!8 (left!8 t!78))))))

(assert (=> d!173 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 t!78))) e!238)))

(declare-fun b!402 () Bool)

(declare-fun call!70 () Bool)

(assert (=> b!402 (= e!237 call!70)))

(declare-fun bm!70 () Bool)

(assert (=> bm!70 (= call!71 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 t!78)))))))

(declare-fun bm!71 () Bool)

(assert (=> bm!71 (= call!70 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 t!78)))))))

(declare-fun b!403 () Bool)

(declare-fun res!284 () Bool)

(assert (=> b!403 (= res!284 (isBlack!0 (right!8 (left!8 (left!8 t!78)))))))

(assert (=> b!403 (=> (not res!284) (not e!237))))

(declare-fun b!404 () Bool)

(declare-fun e!236 () Bool)

(assert (=> b!404 (= e!236 call!70)))

(declare-fun b!405 () Bool)

(declare-fun e!235 () Bool)

(assert (=> b!405 (= e!235 e!237)))

(declare-fun res!281 () Bool)

(assert (=> b!405 (= res!281 (isBlack!0 (left!8 (left!8 (left!8 t!78)))))))

(assert (=> b!405 (=> (not res!281) (not e!237))))

(declare-fun b!406 () Bool)

(assert (=> b!406 (= e!238 e!235)))

(declare-fun c!98 () Bool)

(assert (=> b!406 (= c!98 ((_ is Black!3) (color!6 (left!8 (left!8 t!78)))))))

(declare-fun b!407 () Bool)

(assert (=> b!407 (= e!235 e!236)))

(declare-fun res!282 () Bool)

(assert (=> b!407 (= res!282 call!71)))

(assert (=> b!407 (=> (not res!282) (not e!236))))

(assert (= (and d!173 (not res!283)) b!406))

(assert (= (and b!406 c!98) b!407))

(assert (= (and b!406 (not c!98)) b!405))

(assert (= (and b!407 res!282) b!404))

(assert (= (and b!405 res!281) b!403))

(assert (= (and b!403 res!284) b!401))

(assert (= (and b!401 res!285) b!402))

(assert (= (or b!407 b!401) bm!70))

(assert (= (or b!404 b!402) bm!71))

(declare-fun m!459 () Bool)

(assert (=> bm!70 m!459))

(declare-fun m!461 () Bool)

(assert (=> bm!71 m!461))

(declare-fun m!463 () Bool)

(assert (=> b!403 m!463))

(declare-fun m!465 () Bool)

(assert (=> b!405 m!465))

(assert (=> bm!48 d!173))

(declare-fun d!175 () Bool)

(declare-fun c!99 () Bool)

(assert (=> d!175 (= c!99 ((_ is Empty!3) (left!8 lt!5)))))

(declare-fun e!239 () (_ BitVec 32))

(assert (=> d!175 (= (blackHeight!0 (left!8 lt!5)) e!239)))

(declare-fun b!408 () Bool)

(declare-fun e!240 () (_ BitVec 32))

(declare-fun call!72 () (_ BitVec 32))

(assert (=> b!408 (= e!240 (bvadd call!72 #b00000000000000000000000000000001))))

(declare-fun bm!72 () Bool)

(assert (=> bm!72 (= call!72 (blackHeight!0 (left!8 (left!8 lt!5))))))

(declare-fun b!409 () Bool)

(assert (=> b!409 (= e!240 call!72)))

(declare-fun b!410 () Bool)

(assert (=> b!410 (= e!239 e!240)))

(declare-fun c!100 () Bool)

(assert (=> b!410 (= c!100 ((_ is Black!3) (color!6 (left!8 lt!5))))))

(declare-fun b!411 () Bool)

(assert (=> b!411 (= e!239 #b00000000000000000000000000000001)))

(assert (= (and d!175 c!99) b!411))

(assert (= (and d!175 (not c!99)) b!410))

(assert (= (and b!410 c!100) b!408))

(assert (= (and b!410 (not c!100)) b!409))

(assert (= (or b!408 b!409) bm!72))

(assert (=> bm!72 m!347))

(assert (=> b!244 d!175))

(declare-fun d!177 () Bool)

(declare-fun c!101 () Bool)

(assert (=> d!177 (= c!101 ((_ is Empty!3) (right!8 lt!5)))))

(declare-fun e!241 () (_ BitVec 32))

(assert (=> d!177 (= (blackHeight!0 (right!8 lt!5)) e!241)))

(declare-fun b!412 () Bool)

(declare-fun e!242 () (_ BitVec 32))

(declare-fun call!73 () (_ BitVec 32))

(assert (=> b!412 (= e!242 (bvadd call!73 #b00000000000000000000000000000001))))

(declare-fun bm!73 () Bool)

(assert (=> bm!73 (= call!73 (blackHeight!0 (left!8 (right!8 lt!5))))))

(declare-fun b!413 () Bool)

(assert (=> b!413 (= e!242 call!73)))

(declare-fun b!414 () Bool)

(assert (=> b!414 (= e!241 e!242)))

(declare-fun c!102 () Bool)

(assert (=> b!414 (= c!102 ((_ is Black!3) (color!6 (right!8 lt!5))))))

(declare-fun b!415 () Bool)

(assert (=> b!415 (= e!241 #b00000000000000000000000000000001)))

(assert (= (and d!177 c!101) b!415))

(assert (= (and d!177 (not c!101)) b!414))

(assert (= (and b!414 c!102) b!412))

(assert (= (and b!414 (not c!102)) b!413))

(assert (= (or b!412 b!413) bm!73))

(declare-fun m!467 () Bool)

(assert (=> bm!73 m!467))

(assert (=> b!244 d!177))

(declare-fun b!416 () Bool)

(declare-fun res!290 () Bool)

(declare-fun call!75 () Bool)

(assert (=> b!416 (= res!290 call!75)))

(declare-fun e!245 () Bool)

(assert (=> b!416 (=> (not res!290) (not e!245))))

(declare-fun d!179 () Bool)

(declare-fun res!288 () Bool)

(declare-fun e!246 () Bool)

(assert (=> d!179 (=> res!288 e!246)))

(assert (=> d!179 (= res!288 ((_ is Empty!3) (right!8 (left!8 t!78))))))

(assert (=> d!179 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 t!78))) e!246)))

(declare-fun b!417 () Bool)

(declare-fun call!74 () Bool)

(assert (=> b!417 (= e!245 call!74)))

(declare-fun bm!74 () Bool)

(assert (=> bm!74 (= call!75 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 t!78)))))))

(declare-fun bm!75 () Bool)

(assert (=> bm!75 (= call!74 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 t!78)))))))

(declare-fun b!418 () Bool)

(declare-fun res!289 () Bool)

(assert (=> b!418 (= res!289 (isBlack!0 (right!8 (right!8 (left!8 t!78)))))))

(assert (=> b!418 (=> (not res!289) (not e!245))))

(declare-fun b!419 () Bool)

(declare-fun e!244 () Bool)

(assert (=> b!419 (= e!244 call!74)))

(declare-fun b!420 () Bool)

(declare-fun e!243 () Bool)

(assert (=> b!420 (= e!243 e!245)))

(declare-fun res!286 () Bool)

(assert (=> b!420 (= res!286 (isBlack!0 (left!8 (right!8 (left!8 t!78)))))))

(assert (=> b!420 (=> (not res!286) (not e!245))))

(declare-fun b!421 () Bool)

(assert (=> b!421 (= e!246 e!243)))

(declare-fun c!103 () Bool)

(assert (=> b!421 (= c!103 ((_ is Black!3) (color!6 (right!8 (left!8 t!78)))))))

(declare-fun b!422 () Bool)

(assert (=> b!422 (= e!243 e!244)))

(declare-fun res!287 () Bool)

(assert (=> b!422 (= res!287 call!75)))

(assert (=> b!422 (=> (not res!287) (not e!244))))

(assert (= (and d!179 (not res!288)) b!421))

(assert (= (and b!421 c!103) b!422))

(assert (= (and b!421 (not c!103)) b!420))

(assert (= (and b!422 res!287) b!419))

(assert (= (and b!420 res!286) b!418))

(assert (= (and b!418 res!289) b!416))

(assert (= (and b!416 res!290) b!417))

(assert (= (or b!422 b!416) bm!74))

(assert (= (or b!419 b!417) bm!75))

(declare-fun m!469 () Bool)

(assert (=> bm!74 m!469))

(declare-fun m!471 () Bool)

(assert (=> bm!75 m!471))

(declare-fun m!473 () Bool)

(assert (=> b!418 m!473))

(declare-fun m!475 () Bool)

(assert (=> b!420 m!475))

(assert (=> bm!49 d!179))

(declare-fun d!181 () Bool)

(declare-fun res!291 () Bool)

(declare-fun e!247 () Bool)

(assert (=> d!181 (=> res!291 e!247)))

(assert (=> d!181 (= res!291 (not ((_ is Node!3) (right!8 lt!5))))))

(assert (=> d!181 (= (blackBalanced!0 (right!8 lt!5)) e!247)))

(declare-fun b!423 () Bool)

(declare-fun e!248 () Bool)

(assert (=> b!423 (= e!247 e!248)))

(declare-fun res!293 () Bool)

(assert (=> b!423 (=> (not res!293) (not e!248))))

(assert (=> b!423 (= res!293 (blackBalanced!0 (left!8 (right!8 lt!5))))))

(declare-fun b!424 () Bool)

(declare-fun res!292 () Bool)

(assert (=> b!424 (=> (not res!292) (not e!248))))

(assert (=> b!424 (= res!292 (blackBalanced!0 (right!8 (right!8 lt!5))))))

(declare-fun b!425 () Bool)

(assert (=> b!425 (= e!248 (= (blackHeight!0 (left!8 (right!8 lt!5))) (blackHeight!0 (right!8 (right!8 lt!5)))))))

(assert (= (and d!181 (not res!291)) b!423))

(assert (= (and b!423 res!293) b!424))

(assert (= (and b!424 res!292) b!425))

(declare-fun m!477 () Bool)

(assert (=> b!423 m!477))

(declare-fun m!479 () Bool)

(assert (=> b!424 m!479))

(assert (=> b!425 m!467))

(declare-fun m!481 () Bool)

(assert (=> b!425 m!481))

(assert (=> b!243 d!181))

(declare-fun d!183 () Bool)

(declare-fun c!104 () Bool)

(assert (=> d!183 (= c!104 ((_ is Empty!3) (left!8 (left!8 lt!2))))))

(declare-fun e!249 () (InoxSet (_ BitVec 32)))

(assert (=> d!183 (= (content!0 (left!8 (left!8 lt!2))) e!249)))

(declare-fun b!426 () Bool)

(assert (=> b!426 (= e!249 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!427 () Bool)

(assert (=> b!427 (= e!249 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 lt!2)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 lt!2))) true)) (content!0 (right!8 (left!8 (left!8 lt!2))))))))

(assert (= (and d!183 c!104) b!426))

(assert (= (and d!183 (not c!104)) b!427))

(declare-fun m!483 () Bool)

(assert (=> b!427 m!483))

(declare-fun m!485 () Bool)

(assert (=> b!427 m!485))

(declare-fun m!487 () Bool)

(assert (=> b!427 m!487))

(assert (=> b!287 d!183))

(declare-fun d!185 () Bool)

(declare-fun c!105 () Bool)

(assert (=> d!185 (= c!105 ((_ is Empty!3) (right!8 (left!8 lt!2))))))

(declare-fun e!250 () (InoxSet (_ BitVec 32)))

(assert (=> d!185 (= (content!0 (right!8 (left!8 lt!2))) e!250)))

(declare-fun b!428 () Bool)

(assert (=> b!428 (= e!250 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!429 () Bool)

(assert (=> b!429 (= e!250 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 lt!2)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 lt!2))) true)) (content!0 (right!8 (right!8 (left!8 lt!2))))))))

(assert (= (and d!185 c!105) b!428))

(assert (= (and d!185 (not c!105)) b!429))

(declare-fun m!489 () Bool)

(assert (=> b!429 m!489))

(declare-fun m!491 () Bool)

(assert (=> b!429 m!491))

(declare-fun m!493 () Bool)

(assert (=> b!429 m!493))

(assert (=> b!287 d!185))

(declare-fun d!187 () Bool)

(declare-fun c!106 () Bool)

(assert (=> d!187 (= c!106 ((_ is Empty!3) lt!13))))

(declare-fun e!251 () (InoxSet (_ BitVec 32)))

(assert (=> d!187 (= (content!0 lt!13) e!251)))

(declare-fun b!430 () Bool)

(assert (=> b!430 (= e!251 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!431 () Bool)

(assert (=> b!431 (= e!251 ((_ map or) ((_ map or) (content!0 (left!8 lt!13)) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 lt!13) true)) (content!0 (right!8 lt!13))))))

(assert (= (and d!187 c!106) b!430))

(assert (= (and d!187 (not c!106)) b!431))

(declare-fun m!495 () Bool)

(assert (=> b!431 m!495))

(declare-fun m!497 () Bool)

(assert (=> b!431 m!497))

(declare-fun m!499 () Bool)

(assert (=> b!431 m!499))

(assert (=> d!93 d!187))

(declare-fun d!189 () Bool)

(declare-fun c!107 () Bool)

(assert (=> d!189 (= c!107 ((_ is Empty!3) (ite c!50 (left!8 t!78) (right!8 t!78))))))

(declare-fun e!252 () (InoxSet (_ BitVec 32)))

(assert (=> d!189 (= (content!0 (ite c!50 (left!8 t!78) (right!8 t!78))) e!252)))

(declare-fun b!432 () Bool)

(assert (=> b!432 (= e!252 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!433 () Bool)

(assert (=> b!433 (= e!252 ((_ map or) ((_ map or) (content!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) true)) (content!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (= (and d!189 c!107) b!432))

(assert (= (and d!189 (not c!107)) b!433))

(declare-fun m!501 () Bool)

(assert (=> b!433 m!501))

(declare-fun m!503 () Bool)

(assert (=> b!433 m!503))

(declare-fun m!505 () Bool)

(assert (=> b!433 m!505))

(assert (=> d!93 d!189))

(declare-fun b!434 () Bool)

(declare-fun res!298 () Bool)

(declare-fun call!77 () Bool)

(assert (=> b!434 (= res!298 call!77)))

(declare-fun e!255 () Bool)

(assert (=> b!434 (=> (not res!298) (not e!255))))

(declare-fun d!191 () Bool)

(declare-fun res!296 () Bool)

(declare-fun e!256 () Bool)

(assert (=> d!191 (=> res!296 e!256)))

(assert (=> d!191 (= res!296 ((_ is Empty!3) (ite c!50 (left!8 t!78) (right!8 t!78))))))

(assert (=> d!191 (= (redNodesHaveBlackChildren!0 (ite c!50 (left!8 t!78) (right!8 t!78))) e!256)))

(declare-fun b!435 () Bool)

(declare-fun call!76 () Bool)

(assert (=> b!435 (= e!255 call!76)))

(declare-fun bm!76 () Bool)

(assert (=> bm!76 (= call!77 (redNodesHaveBlackChildren!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(declare-fun bm!77 () Bool)

(assert (=> bm!77 (= call!76 (redNodesHaveBlackChildren!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(declare-fun b!436 () Bool)

(declare-fun res!297 () Bool)

(assert (=> b!436 (= res!297 (isBlack!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(assert (=> b!436 (=> (not res!297) (not e!255))))

(declare-fun b!437 () Bool)

(declare-fun e!254 () Bool)

(assert (=> b!437 (= e!254 call!76)))

(declare-fun b!438 () Bool)

(declare-fun e!253 () Bool)

(assert (=> b!438 (= e!253 e!255)))

(declare-fun res!294 () Bool)

(assert (=> b!438 (= res!294 (isBlack!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(assert (=> b!438 (=> (not res!294) (not e!255))))

(declare-fun b!439 () Bool)

(assert (=> b!439 (= e!256 e!253)))

(declare-fun c!108 () Bool)

(assert (=> b!439 (= c!108 ((_ is Black!3) (color!6 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(declare-fun b!440 () Bool)

(assert (=> b!440 (= e!253 e!254)))

(declare-fun res!295 () Bool)

(assert (=> b!440 (= res!295 call!77)))

(assert (=> b!440 (=> (not res!295) (not e!254))))

(assert (= (and d!191 (not res!296)) b!439))

(assert (= (and b!439 c!108) b!440))

(assert (= (and b!439 (not c!108)) b!438))

(assert (= (and b!440 res!295) b!437))

(assert (= (and b!438 res!294) b!436))

(assert (= (and b!436 res!297) b!434))

(assert (= (and b!434 res!298) b!435))

(assert (= (or b!440 b!434) bm!76))

(assert (= (or b!437 b!435) bm!77))

(declare-fun m!507 () Bool)

(assert (=> bm!76 m!507))

(declare-fun m!509 () Bool)

(assert (=> bm!77 m!509))

(declare-fun m!511 () Bool)

(assert (=> b!436 m!511))

(declare-fun m!513 () Bool)

(assert (=> b!438 m!513))

(assert (=> d!93 d!191))

(declare-fun d!193 () Bool)

(assert (=> d!193 (= (isBlack!0 (right!8 (right!8 lt!2))) (or ((_ is Empty!3) (right!8 (right!8 lt!2))) ((_ is Black!3) (color!6 (right!8 (right!8 lt!2))))))))

(assert (=> b!230 d!193))

(declare-fun d!195 () Bool)

(declare-fun res!299 () Bool)

(declare-fun e!257 () Bool)

(assert (=> d!195 (=> res!299 e!257)))

(assert (=> d!195 (= res!299 (not ((_ is Node!3) (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(assert (=> d!195 (= (blackBalanced!0 (ite c!50 (left!8 t!78) (right!8 t!78))) e!257)))

(declare-fun b!441 () Bool)

(declare-fun e!258 () Bool)

(assert (=> b!441 (= e!257 e!258)))

(declare-fun res!301 () Bool)

(assert (=> b!441 (=> (not res!301) (not e!258))))

(assert (=> b!441 (= res!301 (blackBalanced!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(declare-fun b!442 () Bool)

(declare-fun res!300 () Bool)

(assert (=> b!442 (=> (not res!300) (not e!258))))

(assert (=> b!442 (= res!300 (blackBalanced!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(declare-fun b!443 () Bool)

(assert (=> b!443 (= e!258 (= (blackHeight!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (blackHeight!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (= (and d!195 (not res!299)) b!441))

(assert (= (and b!441 res!301) b!442))

(assert (= (and b!442 res!300) b!443))

(declare-fun m!515 () Bool)

(assert (=> b!441 m!515))

(declare-fun m!517 () Bool)

(assert (=> b!442 m!517))

(declare-fun m!519 () Bool)

(assert (=> b!443 m!519))

(declare-fun m!521 () Bool)

(assert (=> b!443 m!521))

(assert (=> b!269 d!195))

(declare-fun b!444 () Bool)

(declare-fun res!306 () Bool)

(declare-fun call!79 () Bool)

(assert (=> b!444 (= res!306 call!79)))

(declare-fun e!261 () Bool)

(assert (=> b!444 (=> (not res!306) (not e!261))))

(declare-fun d!197 () Bool)

(declare-fun res!304 () Bool)

(declare-fun e!262 () Bool)

(assert (=> d!197 (=> res!304 e!262)))

(assert (=> d!197 (= res!304 ((_ is Empty!3) (right!8 (right!8 lt!2))))))

(assert (=> d!197 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 lt!2))) e!262)))

(declare-fun b!445 () Bool)

(declare-fun call!78 () Bool)

(assert (=> b!445 (= e!261 call!78)))

(declare-fun bm!78 () Bool)

(assert (=> bm!78 (= call!79 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 lt!2)))))))

(declare-fun bm!79 () Bool)

(assert (=> bm!79 (= call!78 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 lt!2)))))))

(declare-fun b!446 () Bool)

(declare-fun res!305 () Bool)

(assert (=> b!446 (= res!305 (isBlack!0 (right!8 (right!8 (right!8 lt!2)))))))

(assert (=> b!446 (=> (not res!305) (not e!261))))

(declare-fun b!447 () Bool)

(declare-fun e!260 () Bool)

(assert (=> b!447 (= e!260 call!78)))

(declare-fun b!448 () Bool)

(declare-fun e!259 () Bool)

(assert (=> b!448 (= e!259 e!261)))

(declare-fun res!302 () Bool)

(assert (=> b!448 (= res!302 (isBlack!0 (left!8 (right!8 (right!8 lt!2)))))))

(assert (=> b!448 (=> (not res!302) (not e!261))))

(declare-fun b!449 () Bool)

(assert (=> b!449 (= e!262 e!259)))

(declare-fun c!109 () Bool)

(assert (=> b!449 (= c!109 ((_ is Black!3) (color!6 (right!8 (right!8 lt!2)))))))

(declare-fun b!450 () Bool)

(assert (=> b!450 (= e!259 e!260)))

(declare-fun res!303 () Bool)

(assert (=> b!450 (= res!303 call!79)))

(assert (=> b!450 (=> (not res!303) (not e!260))))

(assert (= (and d!197 (not res!304)) b!449))

(assert (= (and b!449 c!109) b!450))

(assert (= (and b!449 (not c!109)) b!448))

(assert (= (and b!450 res!303) b!447))

(assert (= (and b!448 res!302) b!446))

(assert (= (and b!446 res!305) b!444))

(assert (= (and b!444 res!306) b!445))

(assert (= (or b!450 b!444) bm!78))

(assert (= (or b!447 b!445) bm!79))

(declare-fun m!523 () Bool)

(assert (=> bm!78 m!523))

(declare-fun m!525 () Bool)

(assert (=> bm!79 m!525))

(declare-fun m!527 () Bool)

(assert (=> b!446 m!527))

(declare-fun m!529 () Bool)

(assert (=> b!448 m!529))

(assert (=> bm!41 d!197))

(declare-fun d!199 () Bool)

(declare-fun c!110 () Bool)

(assert (=> d!199 (= c!110 ((_ is Empty!3) (left!8 (right!8 t!78))))))

(declare-fun e!263 () (InoxSet (_ BitVec 32)))

(assert (=> d!199 (= (content!0 (left!8 (right!8 t!78))) e!263)))

(declare-fun b!451 () Bool)

(assert (=> b!451 (= e!263 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!452 () Bool)

(assert (=> b!452 (= e!263 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 t!78)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 t!78))) true)) (content!0 (right!8 (left!8 (right!8 t!78))))))))

(assert (= (and d!199 c!110) b!451))

(assert (= (and d!199 (not c!110)) b!452))

(declare-fun m!531 () Bool)

(assert (=> b!452 m!531))

(declare-fun m!533 () Bool)

(assert (=> b!452 m!533))

(declare-fun m!535 () Bool)

(assert (=> b!452 m!535))

(assert (=> b!275 d!199))

(declare-fun d!201 () Bool)

(declare-fun c!111 () Bool)

(assert (=> d!201 (= c!111 ((_ is Empty!3) (right!8 (right!8 t!78))))))

(declare-fun e!264 () (InoxSet (_ BitVec 32)))

(assert (=> d!201 (= (content!0 (right!8 (right!8 t!78))) e!264)))

(declare-fun b!453 () Bool)

(assert (=> b!453 (= e!264 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!454 () Bool)

(assert (=> b!454 (= e!264 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 t!78)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 t!78))) true)) (content!0 (right!8 (right!8 (right!8 t!78))))))))

(assert (= (and d!201 c!111) b!453))

(assert (= (and d!201 (not c!111)) b!454))

(declare-fun m!537 () Bool)

(assert (=> b!454 m!537))

(declare-fun m!539 () Bool)

(assert (=> b!454 m!539))

(declare-fun m!541 () Bool)

(assert (=> b!454 m!541))

(assert (=> b!275 d!201))

(declare-fun d!203 () Bool)

(declare-fun res!307 () Bool)

(declare-fun e!265 () Bool)

(assert (=> d!203 (=> res!307 e!265)))

(assert (=> d!203 (= res!307 (not ((_ is Node!3) lt!13)))))

(assert (=> d!203 (= (blackBalanced!0 lt!13) e!265)))

(declare-fun b!455 () Bool)

(declare-fun e!266 () Bool)

(assert (=> b!455 (= e!265 e!266)))

(declare-fun res!309 () Bool)

(assert (=> b!455 (=> (not res!309) (not e!266))))

(assert (=> b!455 (= res!309 (blackBalanced!0 (left!8 lt!13)))))

(declare-fun b!456 () Bool)

(declare-fun res!308 () Bool)

(assert (=> b!456 (=> (not res!308) (not e!266))))

(assert (=> b!456 (= res!308 (blackBalanced!0 (right!8 lt!13)))))

(declare-fun b!457 () Bool)

(assert (=> b!457 (= e!266 (= (blackHeight!0 (left!8 lt!13)) (blackHeight!0 (right!8 lt!13))))))

(assert (= (and d!203 (not res!307)) b!455))

(assert (= (and b!455 res!309) b!456))

(assert (= (and b!456 res!308) b!457))

(declare-fun m!543 () Bool)

(assert (=> b!455 m!543))

(declare-fun m!545 () Bool)

(assert (=> b!456 m!545))

(declare-fun m!547 () Bool)

(assert (=> b!457 m!547))

(declare-fun m!549 () Bool)

(assert (=> b!457 m!549))

(assert (=> b!267 d!203))

(declare-fun d!205 () Bool)

(declare-fun lt!20 () Int)

(assert (=> d!205 (>= lt!20 0)))

(declare-fun e!267 () Int)

(assert (=> d!205 (= lt!20 e!267)))

(declare-fun c!112 () Bool)

(assert (=> d!205 (= c!112 ((_ is Empty!3) (left!8 lt!5)))))

(assert (=> d!205 (= (size!0 (left!8 lt!5)) lt!20)))

(declare-fun b!458 () Bool)

(assert (=> b!458 (= e!267 0)))

(declare-fun b!459 () Bool)

(assert (=> b!459 (= e!267 (+ (size!0 (left!8 (left!8 lt!5))) 1 (size!0 (right!8 (left!8 lt!5)))))))

(assert (= (and d!205 c!112) b!458))

(assert (= (and d!205 (not c!112)) b!459))

(declare-fun m!551 () Bool)

(assert (=> b!459 m!551))

(declare-fun m!553 () Bool)

(assert (=> b!459 m!553))

(assert (=> b!227 d!205))

(declare-fun d!207 () Bool)

(declare-fun lt!21 () Int)

(assert (=> d!207 (>= lt!21 0)))

(declare-fun e!268 () Int)

(assert (=> d!207 (= lt!21 e!268)))

(declare-fun c!113 () Bool)

(assert (=> d!207 (= c!113 ((_ is Empty!3) (right!8 lt!5)))))

(assert (=> d!207 (= (size!0 (right!8 lt!5)) lt!21)))

(declare-fun b!460 () Bool)

(assert (=> b!460 (= e!268 0)))

(declare-fun b!461 () Bool)

(assert (=> b!461 (= e!268 (+ (size!0 (left!8 (right!8 lt!5))) 1 (size!0 (right!8 (right!8 lt!5)))))))

(assert (= (and d!207 c!113) b!460))

(assert (= (and d!207 (not c!113)) b!461))

(declare-fun m!555 () Bool)

(assert (=> b!461 m!555))

(declare-fun m!557 () Bool)

(assert (=> b!461 m!557))

(assert (=> b!227 d!207))

(declare-fun d!209 () Bool)

(assert (=> d!209 (= (isBlack!0 (right!8 (left!8 t!78))) (or ((_ is Empty!3) (right!8 (left!8 t!78))) ((_ is Black!3) (color!6 (right!8 (left!8 t!78))))))))

(assert (=> b!281 d!209))

(check-sat (not bm!72) (not b!291) (not b!441) (not b!297) (not d!121) (not bm!71) (not b!448) (not bm!62) (not bm!65) (not b!429) (not b!318) (not b!456) (not b!420) (not b!292) (not bm!68) (not b!319) (not b!454) (not bm!79) (not b!377) (not b!398) (not b!352) (not bm!57) (not b!363) (not bm!64) (not b!424) (not b!361) (not b!427) (not bm!52) (not b!384) (not bm!76) (not b!436) (not b!442) (not bm!77) (not b!317) (not b!302) (not b!396) (not b!433) (not b!438) (not b!340) (not b!290) (not b!452) (not b!418) (not b!350) (not b!431) (not b!425) (not b!353) (not bm!78) (not b!358) (not b!305) (not b!368) (not b!457) (not b!370) (not bm!59) (not b!364) (not b!295) (not b!382) (not b!313) (not bm!51) (not b!391) (not b!355) (not b!375) (not b!315) (not b!338) (not bm!50) (not b!354) (not bm!75) (not bm!70) (not bm!56) (not b!455) (not b!403) (not b!300) (not b!389) (not bm!66) (not bm!61) (not b!459) (not b!405) (not b!342) (not b!320) (not bm!69) (not bm!58) (not b!346) (not b!301) (not b!446) (not bm!73) (not bm!63) (not b!348) (not bm!74) (not b!461) (not bm!67) (not d!155) (not b!307) (not b!344) (not b!311) (not bm!53) (not b!443) (not b!423) (not bm!60))
(check-sat)
(get-model)

(declare-fun d!211 () Bool)

(assert (=> d!211 (= (isBlack!0 (right!8 (right!8 (left!8 t!78)))) (or ((_ is Empty!3) (right!8 (right!8 (left!8 t!78)))) ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 t!78)))))))))

(assert (=> b!418 d!211))

(declare-fun d!213 () Bool)

(declare-fun lt!22 () Int)

(assert (=> d!213 (>= lt!22 0)))

(declare-fun e!269 () Int)

(assert (=> d!213 (= lt!22 e!269)))

(declare-fun c!114 () Bool)

(assert (=> d!213 (= c!114 ((_ is Empty!3) (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(assert (=> d!213 (= (size!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) lt!22)))

(declare-fun b!462 () Bool)

(assert (=> b!462 (= e!269 0)))

(declare-fun b!463 () Bool)

(assert (=> b!463 (= e!269 (+ (size!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) 1 (size!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (= (and d!213 c!114) b!462))

(assert (= (and d!213 (not c!114)) b!463))

(declare-fun m!559 () Bool)

(assert (=> b!463 m!559))

(declare-fun m!561 () Bool)

(assert (=> b!463 m!561))

(assert (=> b!311 d!213))

(declare-fun d!215 () Bool)

(declare-fun lt!23 () Int)

(assert (=> d!215 (>= lt!23 0)))

(declare-fun e!270 () Int)

(assert (=> d!215 (= lt!23 e!270)))

(declare-fun c!115 () Bool)

(assert (=> d!215 (= c!115 ((_ is Empty!3) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(assert (=> d!215 (= (size!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) lt!23)))

(declare-fun b!464 () Bool)

(assert (=> b!464 (= e!270 0)))

(declare-fun b!465 () Bool)

(assert (=> b!465 (= e!270 (+ (size!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) 1 (size!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (= (and d!215 c!115) b!464))

(assert (= (and d!215 (not c!115)) b!465))

(declare-fun m!563 () Bool)

(assert (=> b!465 m!563))

(declare-fun m!565 () Bool)

(assert (=> b!465 m!565))

(assert (=> b!311 d!215))

(declare-fun d!217 () Bool)

(declare-fun res!310 () Bool)

(declare-fun e!271 () Bool)

(assert (=> d!217 (=> res!310 e!271)))

(assert (=> d!217 (= res!310 (not ((_ is Node!3) (right!8 (right!8 lt!5)))))))

(assert (=> d!217 (= (blackBalanced!0 (right!8 (right!8 lt!5))) e!271)))

(declare-fun b!466 () Bool)

(declare-fun e!272 () Bool)

(assert (=> b!466 (= e!271 e!272)))

(declare-fun res!312 () Bool)

(assert (=> b!466 (=> (not res!312) (not e!272))))

(assert (=> b!466 (= res!312 (blackBalanced!0 (left!8 (right!8 (right!8 lt!5)))))))

(declare-fun b!467 () Bool)

(declare-fun res!311 () Bool)

(assert (=> b!467 (=> (not res!311) (not e!272))))

(assert (=> b!467 (= res!311 (blackBalanced!0 (right!8 (right!8 (right!8 lt!5)))))))

(declare-fun b!468 () Bool)

(assert (=> b!468 (= e!272 (= (blackHeight!0 (left!8 (right!8 (right!8 lt!5)))) (blackHeight!0 (right!8 (right!8 (right!8 lt!5))))))))

(assert (= (and d!217 (not res!310)) b!466))

(assert (= (and b!466 res!312) b!467))

(assert (= (and b!467 res!311) b!468))

(declare-fun m!567 () Bool)

(assert (=> b!466 m!567))

(declare-fun m!569 () Bool)

(assert (=> b!467 m!569))

(declare-fun m!571 () Bool)

(assert (=> b!468 m!571))

(declare-fun m!573 () Bool)

(assert (=> b!468 m!573))

(assert (=> b!424 d!217))

(declare-fun b!469 () Bool)

(declare-fun res!317 () Bool)

(declare-fun call!81 () Bool)

(assert (=> b!469 (= res!317 call!81)))

(declare-fun e!275 () Bool)

(assert (=> b!469 (=> (not res!317) (not e!275))))

(declare-fun d!219 () Bool)

(declare-fun res!315 () Bool)

(declare-fun e!276 () Bool)

(assert (=> d!219 (=> res!315 e!276)))

(assert (=> d!219 (= res!315 ((_ is Empty!3) (left!8 (left!8 (left!8 lt!2)))))))

(assert (=> d!219 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 lt!2)))) e!276)))

(declare-fun b!470 () Bool)

(declare-fun call!80 () Bool)

(assert (=> b!470 (= e!275 call!80)))

(declare-fun bm!80 () Bool)

(assert (=> bm!80 (= call!81 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (left!8 lt!2))))))))

(declare-fun bm!81 () Bool)

(assert (=> bm!81 (= call!80 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (left!8 lt!2))))))))

(declare-fun b!471 () Bool)

(declare-fun res!316 () Bool)

(assert (=> b!471 (= res!316 (isBlack!0 (right!8 (left!8 (left!8 (left!8 lt!2))))))))

(assert (=> b!471 (=> (not res!316) (not e!275))))

(declare-fun b!472 () Bool)

(declare-fun e!274 () Bool)

(assert (=> b!472 (= e!274 call!80)))

(declare-fun b!473 () Bool)

(declare-fun e!273 () Bool)

(assert (=> b!473 (= e!273 e!275)))

(declare-fun res!313 () Bool)

(assert (=> b!473 (= res!313 (isBlack!0 (left!8 (left!8 (left!8 (left!8 lt!2))))))))

(assert (=> b!473 (=> (not res!313) (not e!275))))

(declare-fun b!474 () Bool)

(assert (=> b!474 (= e!276 e!273)))

(declare-fun c!116 () Bool)

(assert (=> b!474 (= c!116 ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 lt!2))))))))

(declare-fun b!475 () Bool)

(assert (=> b!475 (= e!273 e!274)))

(declare-fun res!314 () Bool)

(assert (=> b!475 (= res!314 call!81)))

(assert (=> b!475 (=> (not res!314) (not e!274))))

(assert (= (and d!219 (not res!315)) b!474))

(assert (= (and b!474 c!116) b!475))

(assert (= (and b!474 (not c!116)) b!473))

(assert (= (and b!475 res!314) b!472))

(assert (= (and b!473 res!313) b!471))

(assert (= (and b!471 res!316) b!469))

(assert (= (and b!469 res!317) b!470))

(assert (= (or b!475 b!469) bm!80))

(assert (= (or b!472 b!470) bm!81))

(declare-fun m!575 () Bool)

(assert (=> bm!80 m!575))

(declare-fun m!577 () Bool)

(assert (=> bm!81 m!577))

(declare-fun m!579 () Bool)

(assert (=> b!471 m!579))

(declare-fun m!581 () Bool)

(assert (=> b!473 m!581))

(assert (=> bm!52 d!219))

(declare-fun d!221 () Bool)

(declare-fun lt!24 () Int)

(assert (=> d!221 (>= lt!24 0)))

(declare-fun e!277 () Int)

(assert (=> d!221 (= lt!24 e!277)))

(declare-fun c!117 () Bool)

(assert (=> d!221 (= c!117 ((_ is Empty!3) (left!8 (right!8 lt!5))))))

(assert (=> d!221 (= (size!0 (left!8 (right!8 lt!5))) lt!24)))

(declare-fun b!476 () Bool)

(assert (=> b!476 (= e!277 0)))

(declare-fun b!477 () Bool)

(assert (=> b!477 (= e!277 (+ (size!0 (left!8 (left!8 (right!8 lt!5)))) 1 (size!0 (right!8 (left!8 (right!8 lt!5))))))))

(assert (= (and d!221 c!117) b!476))

(assert (= (and d!221 (not c!117)) b!477))

(declare-fun m!583 () Bool)

(assert (=> b!477 m!583))

(declare-fun m!585 () Bool)

(assert (=> b!477 m!585))

(assert (=> b!461 d!221))

(declare-fun d!223 () Bool)

(declare-fun lt!25 () Int)

(assert (=> d!223 (>= lt!25 0)))

(declare-fun e!278 () Int)

(assert (=> d!223 (= lt!25 e!278)))

(declare-fun c!118 () Bool)

(assert (=> d!223 (= c!118 ((_ is Empty!3) (right!8 (right!8 lt!5))))))

(assert (=> d!223 (= (size!0 (right!8 (right!8 lt!5))) lt!25)))

(declare-fun b!478 () Bool)

(assert (=> b!478 (= e!278 0)))

(declare-fun b!479 () Bool)

(assert (=> b!479 (= e!278 (+ (size!0 (left!8 (right!8 (right!8 lt!5)))) 1 (size!0 (right!8 (right!8 (right!8 lt!5))))))))

(assert (= (and d!223 c!118) b!478))

(assert (= (and d!223 (not c!118)) b!479))

(declare-fun m!587 () Bool)

(assert (=> b!479 m!587))

(declare-fun m!589 () Bool)

(assert (=> b!479 m!589))

(assert (=> b!461 d!223))

(declare-fun b!480 () Bool)

(declare-fun res!322 () Bool)

(declare-fun call!83 () Bool)

(assert (=> b!480 (= res!322 call!83)))

(declare-fun e!281 () Bool)

(assert (=> b!480 (=> (not res!322) (not e!281))))

(declare-fun d!225 () Bool)

(declare-fun res!320 () Bool)

(declare-fun e!282 () Bool)

(assert (=> d!225 (=> res!320 e!282)))

(assert (=> d!225 (= res!320 ((_ is Empty!3) (right!8 lt!13)))))

(assert (=> d!225 (= (redNodesHaveBlackChildren!0 (right!8 lt!13)) e!282)))

(declare-fun b!481 () Bool)

(declare-fun call!82 () Bool)

(assert (=> b!481 (= e!281 call!82)))

(declare-fun bm!82 () Bool)

(assert (=> bm!82 (= call!83 (redNodesHaveBlackChildren!0 (left!8 (right!8 lt!13))))))

(declare-fun bm!83 () Bool)

(assert (=> bm!83 (= call!82 (redNodesHaveBlackChildren!0 (right!8 (right!8 lt!13))))))

(declare-fun b!482 () Bool)

(declare-fun res!321 () Bool)

(assert (=> b!482 (= res!321 (isBlack!0 (right!8 (right!8 lt!13))))))

(assert (=> b!482 (=> (not res!321) (not e!281))))

(declare-fun b!483 () Bool)

(declare-fun e!280 () Bool)

(assert (=> b!483 (= e!280 call!82)))

(declare-fun b!484 () Bool)

(declare-fun e!279 () Bool)

(assert (=> b!484 (= e!279 e!281)))

(declare-fun res!318 () Bool)

(assert (=> b!484 (= res!318 (isBlack!0 (left!8 (right!8 lt!13))))))

(assert (=> b!484 (=> (not res!318) (not e!281))))

(declare-fun b!485 () Bool)

(assert (=> b!485 (= e!282 e!279)))

(declare-fun c!119 () Bool)

(assert (=> b!485 (= c!119 ((_ is Black!3) (color!6 (right!8 lt!13))))))

(declare-fun b!486 () Bool)

(assert (=> b!486 (= e!279 e!280)))

(declare-fun res!319 () Bool)

(assert (=> b!486 (= res!319 call!83)))

(assert (=> b!486 (=> (not res!319) (not e!280))))

(assert (= (and d!225 (not res!320)) b!485))

(assert (= (and b!485 c!119) b!486))

(assert (= (and b!485 (not c!119)) b!484))

(assert (= (and b!486 res!319) b!483))

(assert (= (and b!484 res!318) b!482))

(assert (= (and b!482 res!321) b!480))

(assert (= (and b!480 res!322) b!481))

(assert (= (or b!486 b!480) bm!82))

(assert (= (or b!483 b!481) bm!83))

(declare-fun m!591 () Bool)

(assert (=> bm!82 m!591))

(declare-fun m!593 () Bool)

(assert (=> bm!83 m!593))

(declare-fun m!595 () Bool)

(assert (=> b!482 m!595))

(declare-fun m!597 () Bool)

(assert (=> b!484 m!597))

(assert (=> b!354 d!225))

(declare-fun d!227 () Bool)

(assert (=> d!227 (= (isBlack!0 (left!8 (left!8 (left!8 lt!2)))) (or ((_ is Empty!3) (left!8 (left!8 (left!8 lt!2)))) ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 lt!2)))))))))

(assert (=> b!307 d!227))

(declare-fun d!229 () Bool)

(declare-fun c!120 () Bool)

(assert (=> d!229 (= c!120 ((_ is Empty!3) (left!8 (right!8 (left!8 lt!2)))))))

(declare-fun e!283 () (InoxSet (_ BitVec 32)))

(assert (=> d!229 (= (content!0 (left!8 (right!8 (left!8 lt!2)))) e!283)))

(declare-fun b!487 () Bool)

(assert (=> b!487 (= e!283 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!488 () Bool)

(assert (=> b!488 (= e!283 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (left!8 lt!2))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (left!8 lt!2)))) true)) (content!0 (right!8 (left!8 (right!8 (left!8 lt!2)))))))))

(assert (= (and d!229 c!120) b!487))

(assert (= (and d!229 (not c!120)) b!488))

(declare-fun m!599 () Bool)

(assert (=> b!488 m!599))

(declare-fun m!601 () Bool)

(assert (=> b!488 m!601))

(declare-fun m!603 () Bool)

(assert (=> b!488 m!603))

(assert (=> b!429 d!229))

(declare-fun d!231 () Bool)

(declare-fun c!121 () Bool)

(assert (=> d!231 (= c!121 ((_ is Empty!3) (right!8 (right!8 (left!8 lt!2)))))))

(declare-fun e!284 () (InoxSet (_ BitVec 32)))

(assert (=> d!231 (= (content!0 (right!8 (right!8 (left!8 lt!2)))) e!284)))

(declare-fun b!489 () Bool)

(assert (=> b!489 (= e!284 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!490 () Bool)

(assert (=> b!490 (= e!284 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (left!8 lt!2))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (left!8 lt!2)))) true)) (content!0 (right!8 (right!8 (right!8 (left!8 lt!2)))))))))

(assert (= (and d!231 c!121) b!489))

(assert (= (and d!231 (not c!121)) b!490))

(declare-fun m!605 () Bool)

(assert (=> b!490 m!605))

(declare-fun m!607 () Bool)

(assert (=> b!490 m!607))

(declare-fun m!609 () Bool)

(assert (=> b!490 m!609))

(assert (=> b!429 d!231))

(declare-fun d!233 () Bool)

(declare-fun res!323 () Bool)

(declare-fun e!285 () Bool)

(assert (=> d!233 (=> res!323 e!285)))

(assert (=> d!233 (= res!323 (not ((_ is Node!3) (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> d!233 (= (blackBalanced!0 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!285)))

(declare-fun b!491 () Bool)

(declare-fun e!286 () Bool)

(assert (=> b!491 (= e!285 e!286)))

(declare-fun res!325 () Bool)

(assert (=> b!491 (=> (not res!325) (not e!286))))

(assert (=> b!491 (= res!325 (blackBalanced!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!492 () Bool)

(declare-fun res!324 () Bool)

(assert (=> b!492 (=> (not res!324) (not e!286))))

(assert (=> b!492 (= res!324 (blackBalanced!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!493 () Bool)

(assert (=> b!493 (= e!286 (= (blackHeight!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (blackHeight!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!233 (not res!323)) b!491))

(assert (= (and b!491 res!325) b!492))

(assert (= (and b!492 res!324) b!493))

(declare-fun m!611 () Bool)

(assert (=> b!491 m!611))

(declare-fun m!613 () Bool)

(assert (=> b!492 m!613))

(declare-fun m!615 () Bool)

(assert (=> b!493 m!615))

(declare-fun m!617 () Bool)

(assert (=> b!493 m!617))

(assert (=> b!363 d!233))

(declare-fun d!235 () Bool)

(declare-fun c!122 () Bool)

(assert (=> d!235 (= c!122 ((_ is Empty!3) (left!8 (left!8 t!78))))))

(declare-fun e!287 () (_ BitVec 32))

(assert (=> d!235 (= (blackHeight!0 (left!8 (left!8 t!78))) e!287)))

(declare-fun b!494 () Bool)

(declare-fun e!288 () (_ BitVec 32))

(declare-fun call!84 () (_ BitVec 32))

(assert (=> b!494 (= e!288 (bvadd call!84 #b00000000000000000000000000000001))))

(declare-fun bm!84 () Bool)

(assert (=> bm!84 (= call!84 (blackHeight!0 (left!8 (left!8 (left!8 t!78)))))))

(declare-fun b!495 () Bool)

(assert (=> b!495 (= e!288 call!84)))

(declare-fun b!496 () Bool)

(assert (=> b!496 (= e!287 e!288)))

(declare-fun c!123 () Bool)

(assert (=> b!496 (= c!123 ((_ is Black!3) (color!6 (left!8 (left!8 t!78)))))))

(declare-fun b!497 () Bool)

(assert (=> b!497 (= e!287 #b00000000000000000000000000000001)))

(assert (= (and d!235 c!122) b!497))

(assert (= (and d!235 (not c!122)) b!496))

(assert (= (and b!496 c!123) b!494))

(assert (= (and b!496 (not c!123)) b!495))

(assert (= (or b!494 b!495) bm!84))

(declare-fun m!619 () Bool)

(assert (=> bm!84 m!619))

(assert (=> b!302 d!235))

(declare-fun d!237 () Bool)

(declare-fun c!124 () Bool)

(assert (=> d!237 (= c!124 ((_ is Empty!3) (right!8 (left!8 t!78))))))

(declare-fun e!289 () (_ BitVec 32))

(assert (=> d!237 (= (blackHeight!0 (right!8 (left!8 t!78))) e!289)))

(declare-fun b!498 () Bool)

(declare-fun e!290 () (_ BitVec 32))

(declare-fun call!85 () (_ BitVec 32))

(assert (=> b!498 (= e!290 (bvadd call!85 #b00000000000000000000000000000001))))

(declare-fun bm!85 () Bool)

(assert (=> bm!85 (= call!85 (blackHeight!0 (left!8 (right!8 (left!8 t!78)))))))

(declare-fun b!499 () Bool)

(assert (=> b!499 (= e!290 call!85)))

(declare-fun b!500 () Bool)

(assert (=> b!500 (= e!289 e!290)))

(declare-fun c!125 () Bool)

(assert (=> b!500 (= c!125 ((_ is Black!3) (color!6 (right!8 (left!8 t!78)))))))

(declare-fun b!501 () Bool)

(assert (=> b!501 (= e!289 #b00000000000000000000000000000001)))

(assert (= (and d!237 c!124) b!501))

(assert (= (and d!237 (not c!124)) b!500))

(assert (= (and b!500 c!125) b!498))

(assert (= (and b!500 (not c!125)) b!499))

(assert (= (or b!498 b!499) bm!85))

(declare-fun m!621 () Bool)

(assert (=> bm!85 m!621))

(assert (=> b!302 d!237))

(declare-fun d!239 () Bool)

(declare-fun c!126 () Bool)

(assert (=> d!239 (= c!126 ((_ is Empty!3) (left!8 (left!8 lt!5))))))

(declare-fun e!291 () (_ BitVec 32))

(assert (=> d!239 (= (blackHeight!0 (left!8 (left!8 lt!5))) e!291)))

(declare-fun b!502 () Bool)

(declare-fun e!292 () (_ BitVec 32))

(declare-fun call!86 () (_ BitVec 32))

(assert (=> b!502 (= e!292 (bvadd call!86 #b00000000000000000000000000000001))))

(declare-fun bm!86 () Bool)

(assert (=> bm!86 (= call!86 (blackHeight!0 (left!8 (left!8 (left!8 lt!5)))))))

(declare-fun b!503 () Bool)

(assert (=> b!503 (= e!292 call!86)))

(declare-fun b!504 () Bool)

(assert (=> b!504 (= e!291 e!292)))

(declare-fun c!127 () Bool)

(assert (=> b!504 (= c!127 ((_ is Black!3) (color!6 (left!8 (left!8 lt!5)))))))

(declare-fun b!505 () Bool)

(assert (=> b!505 (= e!291 #b00000000000000000000000000000001)))

(assert (= (and d!239 c!126) b!505))

(assert (= (and d!239 (not c!126)) b!504))

(assert (= (and b!504 c!127) b!502))

(assert (= (and b!504 (not c!127)) b!503))

(assert (= (or b!502 b!503) bm!86))

(declare-fun m!623 () Bool)

(assert (=> bm!86 m!623))

(assert (=> b!320 d!239))

(declare-fun d!241 () Bool)

(declare-fun c!128 () Bool)

(assert (=> d!241 (= c!128 ((_ is Empty!3) (right!8 (left!8 lt!5))))))

(declare-fun e!293 () (_ BitVec 32))

(assert (=> d!241 (= (blackHeight!0 (right!8 (left!8 lt!5))) e!293)))

(declare-fun b!506 () Bool)

(declare-fun e!294 () (_ BitVec 32))

(declare-fun call!87 () (_ BitVec 32))

(assert (=> b!506 (= e!294 (bvadd call!87 #b00000000000000000000000000000001))))

(declare-fun bm!87 () Bool)

(assert (=> bm!87 (= call!87 (blackHeight!0 (left!8 (right!8 (left!8 lt!5)))))))

(declare-fun b!507 () Bool)

(assert (=> b!507 (= e!294 call!87)))

(declare-fun b!508 () Bool)

(assert (=> b!508 (= e!293 e!294)))

(declare-fun c!129 () Bool)

(assert (=> b!508 (= c!129 ((_ is Black!3) (color!6 (right!8 (left!8 lt!5)))))))

(declare-fun b!509 () Bool)

(assert (=> b!509 (= e!293 #b00000000000000000000000000000001)))

(assert (= (and d!241 c!128) b!509))

(assert (= (and d!241 (not c!128)) b!508))

(assert (= (and b!508 c!129) b!506))

(assert (= (and b!508 (not c!129)) b!507))

(assert (= (or b!506 b!507) bm!87))

(declare-fun m!625 () Bool)

(assert (=> bm!87 m!625))

(assert (=> b!320 d!241))

(declare-fun d!243 () Bool)

(assert (=> d!243 (= (isBlack!0 (right!8 (left!8 (right!8 t!78)))) (or ((_ is Empty!3) (right!8 (left!8 (right!8 t!78)))) ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 t!78)))))))))

(assert (=> b!368 d!243))

(declare-fun d!245 () Bool)

(assert (=> d!245 (= (isBlack!0 (right!8 (left!8 (right!8 lt!2)))) (or ((_ is Empty!3) (right!8 (left!8 (right!8 lt!2)))) ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 lt!2)))))))))

(assert (=> b!396 d!245))

(declare-fun d!247 () Bool)

(declare-fun c!130 () Bool)

(assert (=> d!247 (= c!130 ((_ is Empty!3) (left!8 (left!8 (right!8 lt!2)))))))

(declare-fun e!295 () (InoxSet (_ BitVec 32)))

(assert (=> d!247 (= (content!0 (left!8 (left!8 (right!8 lt!2)))) e!295)))

(declare-fun b!510 () Bool)

(assert (=> b!510 (= e!295 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!511 () Bool)

(assert (=> b!511 (= e!295 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (right!8 lt!2))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (right!8 lt!2)))) true)) (content!0 (right!8 (left!8 (left!8 (right!8 lt!2)))))))))

(assert (= (and d!247 c!130) b!510))

(assert (= (and d!247 (not c!130)) b!511))

(declare-fun m!627 () Bool)

(assert (=> b!511 m!627))

(declare-fun m!629 () Bool)

(assert (=> b!511 m!629))

(declare-fun m!631 () Bool)

(assert (=> b!511 m!631))

(assert (=> b!346 d!247))

(declare-fun d!249 () Bool)

(declare-fun c!131 () Bool)

(assert (=> d!249 (= c!131 ((_ is Empty!3) (right!8 (left!8 (right!8 lt!2)))))))

(declare-fun e!296 () (InoxSet (_ BitVec 32)))

(assert (=> d!249 (= (content!0 (right!8 (left!8 (right!8 lt!2)))) e!296)))

(declare-fun b!512 () Bool)

(assert (=> b!512 (= e!296 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!513 () Bool)

(assert (=> b!513 (= e!296 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (right!8 lt!2))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (right!8 lt!2)))) true)) (content!0 (right!8 (right!8 (left!8 (right!8 lt!2)))))))))

(assert (= (and d!249 c!131) b!512))

(assert (= (and d!249 (not c!131)) b!513))

(declare-fun m!633 () Bool)

(assert (=> b!513 m!633))

(declare-fun m!635 () Bool)

(assert (=> b!513 m!635))

(declare-fun m!637 () Bool)

(assert (=> b!513 m!637))

(assert (=> b!346 d!249))

(declare-fun d!251 () Bool)

(declare-fun lt!26 () Int)

(assert (=> d!251 (>= lt!26 0)))

(declare-fun e!297 () Int)

(assert (=> d!251 (= lt!26 e!297)))

(declare-fun c!132 () Bool)

(assert (=> d!251 (= c!132 ((_ is Empty!3) (left!8 (left!8 t!78))))))

(assert (=> d!251 (= (size!0 (left!8 (left!8 t!78))) lt!26)))

(declare-fun b!514 () Bool)

(assert (=> b!514 (= e!297 0)))

(declare-fun b!515 () Bool)

(assert (=> b!515 (= e!297 (+ (size!0 (left!8 (left!8 (left!8 t!78)))) 1 (size!0 (right!8 (left!8 (left!8 t!78))))))))

(assert (= (and d!251 c!132) b!514))

(assert (= (and d!251 (not c!132)) b!515))

(declare-fun m!639 () Bool)

(assert (=> b!515 m!639))

(declare-fun m!641 () Bool)

(assert (=> b!515 m!641))

(assert (=> b!342 d!251))

(declare-fun d!253 () Bool)

(declare-fun lt!27 () Int)

(assert (=> d!253 (>= lt!27 0)))

(declare-fun e!298 () Int)

(assert (=> d!253 (= lt!27 e!298)))

(declare-fun c!133 () Bool)

(assert (=> d!253 (= c!133 ((_ is Empty!3) (right!8 (left!8 t!78))))))

(assert (=> d!253 (= (size!0 (right!8 (left!8 t!78))) lt!27)))

(declare-fun b!516 () Bool)

(assert (=> b!516 (= e!298 0)))

(declare-fun b!517 () Bool)

(assert (=> b!517 (= e!298 (+ (size!0 (left!8 (right!8 (left!8 t!78)))) 1 (size!0 (right!8 (right!8 (left!8 t!78))))))))

(assert (= (and d!253 c!133) b!516))

(assert (= (and d!253 (not c!133)) b!517))

(declare-fun m!643 () Bool)

(assert (=> b!517 m!643))

(declare-fun m!645 () Bool)

(assert (=> b!517 m!645))

(assert (=> b!342 d!253))

(declare-fun d!255 () Bool)

(assert (=> d!255 (= (isBlack!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (or ((_ is Empty!3) (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) ((_ is Black!3) (color!6 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!438 d!255))

(declare-fun d!257 () Bool)

(declare-fun c!134 () Bool)

(assert (=> d!257 (= c!134 ((_ is Empty!3) (left!8 (left!8 (left!8 lt!2)))))))

(declare-fun e!299 () (InoxSet (_ BitVec 32)))

(assert (=> d!257 (= (content!0 (left!8 (left!8 (left!8 lt!2)))) e!299)))

(declare-fun b!518 () Bool)

(assert (=> b!518 (= e!299 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!519 () Bool)

(assert (=> b!519 (= e!299 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (left!8 lt!2))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (left!8 lt!2)))) true)) (content!0 (right!8 (left!8 (left!8 (left!8 lt!2)))))))))

(assert (= (and d!257 c!134) b!518))

(assert (= (and d!257 (not c!134)) b!519))

(declare-fun m!647 () Bool)

(assert (=> b!519 m!647))

(declare-fun m!649 () Bool)

(assert (=> b!519 m!649))

(declare-fun m!651 () Bool)

(assert (=> b!519 m!651))

(assert (=> b!427 d!257))

(declare-fun d!259 () Bool)

(declare-fun c!135 () Bool)

(assert (=> d!259 (= c!135 ((_ is Empty!3) (right!8 (left!8 (left!8 lt!2)))))))

(declare-fun e!300 () (InoxSet (_ BitVec 32)))

(assert (=> d!259 (= (content!0 (right!8 (left!8 (left!8 lt!2)))) e!300)))

(declare-fun b!520 () Bool)

(assert (=> b!520 (= e!300 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!521 () Bool)

(assert (=> b!521 (= e!300 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (left!8 lt!2))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (left!8 lt!2)))) true)) (content!0 (right!8 (right!8 (left!8 (left!8 lt!2)))))))))

(assert (= (and d!259 c!135) b!520))

(assert (= (and d!259 (not c!135)) b!521))

(declare-fun m!653 () Bool)

(assert (=> b!521 m!653))

(declare-fun m!655 () Bool)

(assert (=> b!521 m!655))

(declare-fun m!657 () Bool)

(assert (=> b!521 m!657))

(assert (=> b!427 d!259))

(declare-fun d!261 () Bool)

(declare-fun res!326 () Bool)

(declare-fun e!301 () Bool)

(assert (=> d!261 (=> res!326 e!301)))

(assert (=> d!261 (= res!326 (not ((_ is Node!3) (right!8 (right!8 t!78)))))))

(assert (=> d!261 (= (blackBalanced!0 (right!8 (right!8 t!78))) e!301)))

(declare-fun b!522 () Bool)

(declare-fun e!302 () Bool)

(assert (=> b!522 (= e!301 e!302)))

(declare-fun res!328 () Bool)

(assert (=> b!522 (=> (not res!328) (not e!302))))

(assert (=> b!522 (= res!328 (blackBalanced!0 (left!8 (right!8 (right!8 t!78)))))))

(declare-fun b!523 () Bool)

(declare-fun res!327 () Bool)

(assert (=> b!523 (=> (not res!327) (not e!302))))

(assert (=> b!523 (= res!327 (blackBalanced!0 (right!8 (right!8 (right!8 t!78)))))))

(declare-fun b!524 () Bool)

(assert (=> b!524 (= e!302 (= (blackHeight!0 (left!8 (right!8 (right!8 t!78)))) (blackHeight!0 (right!8 (right!8 (right!8 t!78))))))))

(assert (= (and d!261 (not res!326)) b!522))

(assert (= (and b!522 res!328) b!523))

(assert (= (and b!523 res!327) b!524))

(declare-fun m!659 () Bool)

(assert (=> b!522 m!659))

(declare-fun m!661 () Bool)

(assert (=> b!523 m!661))

(declare-fun m!663 () Bool)

(assert (=> b!524 m!663))

(declare-fun m!665 () Bool)

(assert (=> b!524 m!665))

(assert (=> b!291 d!261))

(declare-fun d!263 () Bool)

(declare-fun res!329 () Bool)

(declare-fun e!303 () Bool)

(assert (=> d!263 (=> res!329 e!303)))

(assert (=> d!263 (= res!329 (not ((_ is Node!3) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!263 (= (blackBalanced!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) e!303)))

(declare-fun b!525 () Bool)

(declare-fun e!304 () Bool)

(assert (=> b!525 (= e!303 e!304)))

(declare-fun res!331 () Bool)

(assert (=> b!525 (=> (not res!331) (not e!304))))

(assert (=> b!525 (= res!331 (blackBalanced!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!526 () Bool)

(declare-fun res!330 () Bool)

(assert (=> b!526 (=> (not res!330) (not e!304))))

(assert (=> b!526 (= res!330 (blackBalanced!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!527 () Bool)

(assert (=> b!527 (= e!304 (= (blackHeight!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (blackHeight!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (= (and d!263 (not res!329)) b!525))

(assert (= (and b!525 res!331) b!526))

(assert (= (and b!526 res!330) b!527))

(declare-fun m!667 () Bool)

(assert (=> b!525 m!667))

(declare-fun m!669 () Bool)

(assert (=> b!526 m!669))

(declare-fun m!671 () Bool)

(assert (=> b!527 m!671))

(declare-fun m!673 () Bool)

(assert (=> b!527 m!673))

(assert (=> b!442 d!263))

(declare-fun d!265 () Bool)

(assert (=> d!265 (= (isBlack!0 (left!8 (left!8 lt!5))) (or ((_ is Empty!3) (left!8 (left!8 lt!5))) ((_ is Black!3) (color!6 (left!8 (left!8 lt!5))))))))

(assert (=> b!391 d!265))

(declare-fun d!267 () Bool)

(declare-fun c!136 () Bool)

(assert (=> d!267 (= c!136 ((_ is Empty!3) (left!8 (left!8 (right!8 t!78)))))))

(declare-fun e!305 () (InoxSet (_ BitVec 32)))

(assert (=> d!267 (= (content!0 (left!8 (left!8 (right!8 t!78)))) e!305)))

(declare-fun b!528 () Bool)

(assert (=> b!528 (= e!305 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!529 () Bool)

(assert (=> b!529 (= e!305 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (right!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (right!8 t!78)))) true)) (content!0 (right!8 (left!8 (left!8 (right!8 t!78)))))))))

(assert (= (and d!267 c!136) b!528))

(assert (= (and d!267 (not c!136)) b!529))

(declare-fun m!675 () Bool)

(assert (=> b!529 m!675))

(declare-fun m!677 () Bool)

(assert (=> b!529 m!677))

(declare-fun m!679 () Bool)

(assert (=> b!529 m!679))

(assert (=> b!452 d!267))

(declare-fun d!269 () Bool)

(declare-fun c!137 () Bool)

(assert (=> d!269 (= c!137 ((_ is Empty!3) (right!8 (left!8 (right!8 t!78)))))))

(declare-fun e!306 () (InoxSet (_ BitVec 32)))

(assert (=> d!269 (= (content!0 (right!8 (left!8 (right!8 t!78)))) e!306)))

(declare-fun b!530 () Bool)

(assert (=> b!530 (= e!306 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!531 () Bool)

(assert (=> b!531 (= e!306 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (right!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (right!8 t!78)))) true)) (content!0 (right!8 (right!8 (left!8 (right!8 t!78)))))))))

(assert (= (and d!269 c!137) b!530))

(assert (= (and d!269 (not c!137)) b!531))

(declare-fun m!681 () Bool)

(assert (=> b!531 m!681))

(declare-fun m!683 () Bool)

(assert (=> b!531 m!683))

(declare-fun m!685 () Bool)

(assert (=> b!531 m!685))

(assert (=> b!452 d!269))

(declare-fun d!271 () Bool)

(declare-fun c!138 () Bool)

(assert (=> d!271 (= c!138 ((_ is Empty!3) (left!8 (left!8 (left!8 t!78)))))))

(declare-fun e!307 () (InoxSet (_ BitVec 32)))

(assert (=> d!271 (= (content!0 (left!8 (left!8 (left!8 t!78)))) e!307)))

(declare-fun b!532 () Bool)

(assert (=> b!532 (= e!307 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!533 () Bool)

(assert (=> b!533 (= e!307 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (left!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (left!8 t!78)))) true)) (content!0 (right!8 (left!8 (left!8 (left!8 t!78)))))))))

(assert (= (and d!271 c!138) b!532))

(assert (= (and d!271 (not c!138)) b!533))

(declare-fun m!687 () Bool)

(assert (=> b!533 m!687))

(declare-fun m!689 () Bool)

(assert (=> b!533 m!689))

(declare-fun m!691 () Bool)

(assert (=> b!533 m!691))

(assert (=> b!338 d!271))

(declare-fun d!273 () Bool)

(declare-fun c!139 () Bool)

(assert (=> d!273 (= c!139 ((_ is Empty!3) (right!8 (left!8 (left!8 t!78)))))))

(declare-fun e!308 () (InoxSet (_ BitVec 32)))

(assert (=> d!273 (= (content!0 (right!8 (left!8 (left!8 t!78)))) e!308)))

(declare-fun b!534 () Bool)

(assert (=> b!534 (= e!308 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!535 () Bool)

(assert (=> b!535 (= e!308 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (left!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (left!8 t!78)))) true)) (content!0 (right!8 (right!8 (left!8 (left!8 t!78)))))))))

(assert (= (and d!273 c!139) b!534))

(assert (= (and d!273 (not c!139)) b!535))

(declare-fun m!693 () Bool)

(assert (=> b!535 m!693))

(declare-fun m!695 () Bool)

(assert (=> b!535 m!695))

(declare-fun m!697 () Bool)

(assert (=> b!535 m!697))

(assert (=> b!338 d!273))

(declare-fun b!536 () Bool)

(declare-fun res!336 () Bool)

(declare-fun call!89 () Bool)

(assert (=> b!536 (= res!336 call!89)))

(declare-fun e!311 () Bool)

(assert (=> b!536 (=> (not res!336) (not e!311))))

(declare-fun d!275 () Bool)

(declare-fun res!334 () Bool)

(declare-fun e!312 () Bool)

(assert (=> d!275 (=> res!334 e!312)))

(assert (=> d!275 (= res!334 ((_ is Empty!3) (left!8 (left!8 lt!5))))))

(assert (=> d!275 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 lt!5))) e!312)))

(declare-fun b!537 () Bool)

(declare-fun call!88 () Bool)

(assert (=> b!537 (= e!311 call!88)))

(declare-fun bm!88 () Bool)

(assert (=> bm!88 (= call!89 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 lt!5)))))))

(declare-fun bm!89 () Bool)

(assert (=> bm!89 (= call!88 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 lt!5)))))))

(declare-fun b!538 () Bool)

(declare-fun res!335 () Bool)

(assert (=> b!538 (= res!335 (isBlack!0 (right!8 (left!8 (left!8 lt!5)))))))

(assert (=> b!538 (=> (not res!335) (not e!311))))

(declare-fun b!539 () Bool)

(declare-fun e!310 () Bool)

(assert (=> b!539 (= e!310 call!88)))

(declare-fun b!540 () Bool)

(declare-fun e!309 () Bool)

(assert (=> b!540 (= e!309 e!311)))

(declare-fun res!332 () Bool)

(assert (=> b!540 (= res!332 (isBlack!0 (left!8 (left!8 (left!8 lt!5)))))))

(assert (=> b!540 (=> (not res!332) (not e!311))))

(declare-fun b!541 () Bool)

(assert (=> b!541 (= e!312 e!309)))

(declare-fun c!140 () Bool)

(assert (=> b!541 (= c!140 ((_ is Black!3) (color!6 (left!8 (left!8 lt!5)))))))

(declare-fun b!542 () Bool)

(assert (=> b!542 (= e!309 e!310)))

(declare-fun res!333 () Bool)

(assert (=> b!542 (= res!333 call!89)))

(assert (=> b!542 (=> (not res!333) (not e!310))))

(assert (= (and d!275 (not res!334)) b!541))

(assert (= (and b!541 c!140) b!542))

(assert (= (and b!541 (not c!140)) b!540))

(assert (= (and b!542 res!333) b!539))

(assert (= (and b!540 res!332) b!538))

(assert (= (and b!538 res!335) b!536))

(assert (= (and b!536 res!336) b!537))

(assert (= (or b!542 b!536) bm!88))

(assert (= (or b!539 b!537) bm!89))

(declare-fun m!699 () Bool)

(assert (=> bm!88 m!699))

(declare-fun m!701 () Bool)

(assert (=> bm!89 m!701))

(declare-fun m!703 () Bool)

(assert (=> b!538 m!703))

(declare-fun m!705 () Bool)

(assert (=> b!540 m!705))

(assert (=> bm!66 d!275))

(declare-fun b!543 () Bool)

(declare-fun res!341 () Bool)

(declare-fun call!91 () Bool)

(assert (=> b!543 (= res!341 call!91)))

(declare-fun e!315 () Bool)

(assert (=> b!543 (=> (not res!341) (not e!315))))

(declare-fun d!277 () Bool)

(declare-fun res!339 () Bool)

(declare-fun e!316 () Bool)

(assert (=> d!277 (=> res!339 e!316)))

(assert (=> d!277 (= res!339 ((_ is Empty!3) (right!8 (left!8 (left!8 t!78)))))))

(assert (=> d!277 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 t!78)))) e!316)))

(declare-fun b!544 () Bool)

(declare-fun call!90 () Bool)

(assert (=> b!544 (= e!315 call!90)))

(declare-fun bm!90 () Bool)

(assert (=> bm!90 (= call!91 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (left!8 t!78))))))))

(declare-fun bm!91 () Bool)

(assert (=> bm!91 (= call!90 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (left!8 t!78))))))))

(declare-fun b!545 () Bool)

(declare-fun res!340 () Bool)

(assert (=> b!545 (= res!340 (isBlack!0 (right!8 (right!8 (left!8 (left!8 t!78))))))))

(assert (=> b!545 (=> (not res!340) (not e!315))))

(declare-fun b!546 () Bool)

(declare-fun e!314 () Bool)

(assert (=> b!546 (= e!314 call!90)))

(declare-fun b!547 () Bool)

(declare-fun e!313 () Bool)

(assert (=> b!547 (= e!313 e!315)))

(declare-fun res!337 () Bool)

(assert (=> b!547 (= res!337 (isBlack!0 (left!8 (right!8 (left!8 (left!8 t!78))))))))

(assert (=> b!547 (=> (not res!337) (not e!315))))

(declare-fun b!548 () Bool)

(assert (=> b!548 (= e!316 e!313)))

(declare-fun c!141 () Bool)

(assert (=> b!548 (= c!141 ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 t!78))))))))

(declare-fun b!549 () Bool)

(assert (=> b!549 (= e!313 e!314)))

(declare-fun res!338 () Bool)

(assert (=> b!549 (= res!338 call!91)))

(assert (=> b!549 (=> (not res!338) (not e!314))))

(assert (= (and d!277 (not res!339)) b!548))

(assert (= (and b!548 c!141) b!549))

(assert (= (and b!548 (not c!141)) b!547))

(assert (= (and b!549 res!338) b!546))

(assert (= (and b!547 res!337) b!545))

(assert (= (and b!545 res!340) b!543))

(assert (= (and b!543 res!341) b!544))

(assert (= (or b!549 b!543) bm!90))

(assert (= (or b!546 b!544) bm!91))

(declare-fun m!707 () Bool)

(assert (=> bm!90 m!707))

(declare-fun m!709 () Bool)

(assert (=> bm!91 m!709))

(declare-fun m!711 () Bool)

(assert (=> b!545 m!711))

(declare-fun m!713 () Bool)

(assert (=> b!547 m!713))

(assert (=> bm!71 d!277))

(declare-fun b!550 () Bool)

(declare-fun res!346 () Bool)

(declare-fun call!93 () Bool)

(assert (=> b!550 (= res!346 call!93)))

(declare-fun e!319 () Bool)

(assert (=> b!550 (=> (not res!346) (not e!319))))

(declare-fun d!279 () Bool)

(declare-fun res!344 () Bool)

(declare-fun e!320 () Bool)

(assert (=> d!279 (=> res!344 e!320)))

(assert (=> d!279 (= res!344 ((_ is Empty!3) (right!8 (right!8 (right!8 t!78)))))))

(assert (=> d!279 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 t!78)))) e!320)))

(declare-fun b!551 () Bool)

(declare-fun call!92 () Bool)

(assert (=> b!551 (= e!319 call!92)))

(declare-fun bm!92 () Bool)

(assert (=> bm!92 (= call!93 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (right!8 t!78))))))))

(declare-fun bm!93 () Bool)

(assert (=> bm!93 (= call!92 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (right!8 t!78))))))))

(declare-fun b!552 () Bool)

(declare-fun res!345 () Bool)

(assert (=> b!552 (= res!345 (isBlack!0 (right!8 (right!8 (right!8 (right!8 t!78))))))))

(assert (=> b!552 (=> (not res!345) (not e!319))))

(declare-fun b!553 () Bool)

(declare-fun e!318 () Bool)

(assert (=> b!553 (= e!318 call!92)))

(declare-fun b!554 () Bool)

(declare-fun e!317 () Bool)

(assert (=> b!554 (= e!317 e!319)))

(declare-fun res!342 () Bool)

(assert (=> b!554 (= res!342 (isBlack!0 (left!8 (right!8 (right!8 (right!8 t!78))))))))

(assert (=> b!554 (=> (not res!342) (not e!319))))

(declare-fun b!555 () Bool)

(assert (=> b!555 (= e!320 e!317)))

(declare-fun c!142 () Bool)

(assert (=> b!555 (= c!142 ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 t!78))))))))

(declare-fun b!556 () Bool)

(assert (=> b!556 (= e!317 e!318)))

(declare-fun res!343 () Bool)

(assert (=> b!556 (= res!343 call!93)))

(assert (=> b!556 (=> (not res!343) (not e!318))))

(assert (= (and d!279 (not res!344)) b!555))

(assert (= (and b!555 c!142) b!556))

(assert (= (and b!555 (not c!142)) b!554))

(assert (= (and b!556 res!343) b!553))

(assert (= (and b!554 res!342) b!552))

(assert (= (and b!552 res!345) b!550))

(assert (= (and b!550 res!346) b!551))

(assert (= (or b!556 b!550) bm!92))

(assert (= (or b!553 b!551) bm!93))

(declare-fun m!715 () Bool)

(assert (=> bm!92 m!715))

(declare-fun m!717 () Bool)

(assert (=> bm!93 m!717))

(declare-fun m!719 () Bool)

(assert (=> b!552 m!719))

(declare-fun m!721 () Bool)

(assert (=> b!554 m!721))

(assert (=> bm!63 d!279))

(declare-fun b!557 () Bool)

(declare-fun res!351 () Bool)

(declare-fun call!95 () Bool)

(assert (=> b!557 (= res!351 call!95)))

(declare-fun e!323 () Bool)

(assert (=> b!557 (=> (not res!351) (not e!323))))

(declare-fun d!281 () Bool)

(declare-fun res!349 () Bool)

(declare-fun e!324 () Bool)

(assert (=> d!281 (=> res!349 e!324)))

(assert (=> d!281 (= res!349 ((_ is Empty!3) (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(assert (=> d!281 (= (redNodesHaveBlackChildren!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) e!324)))

(declare-fun b!558 () Bool)

(declare-fun call!94 () Bool)

(assert (=> b!558 (= e!323 call!94)))

(declare-fun bm!94 () Bool)

(assert (=> bm!94 (= call!95 (redNodesHaveBlackChildren!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun bm!95 () Bool)

(assert (=> bm!95 (= call!94 (redNodesHaveBlackChildren!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!559 () Bool)

(declare-fun res!350 () Bool)

(assert (=> b!559 (= res!350 (isBlack!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> b!559 (=> (not res!350) (not e!323))))

(declare-fun b!560 () Bool)

(declare-fun e!322 () Bool)

(assert (=> b!560 (= e!322 call!94)))

(declare-fun b!561 () Bool)

(declare-fun e!321 () Bool)

(assert (=> b!561 (= e!321 e!323)))

(declare-fun res!347 () Bool)

(assert (=> b!561 (= res!347 (isBlack!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> b!561 (=> (not res!347) (not e!323))))

(declare-fun b!562 () Bool)

(assert (=> b!562 (= e!324 e!321)))

(declare-fun c!143 () Bool)

(assert (=> b!562 (= c!143 ((_ is Black!3) (color!6 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!563 () Bool)

(assert (=> b!563 (= e!321 e!322)))

(declare-fun res!348 () Bool)

(assert (=> b!563 (= res!348 call!95)))

(assert (=> b!563 (=> (not res!348) (not e!322))))

(assert (= (and d!281 (not res!349)) b!562))

(assert (= (and b!562 c!143) b!563))

(assert (= (and b!562 (not c!143)) b!561))

(assert (= (and b!563 res!348) b!560))

(assert (= (and b!561 res!347) b!559))

(assert (= (and b!559 res!350) b!557))

(assert (= (and b!557 res!351) b!558))

(assert (= (or b!563 b!557) bm!94))

(assert (= (or b!560 b!558) bm!95))

(declare-fun m!723 () Bool)

(assert (=> bm!94 m!723))

(declare-fun m!725 () Bool)

(assert (=> bm!95 m!725))

(declare-fun m!727 () Bool)

(assert (=> b!559 m!727))

(declare-fun m!729 () Bool)

(assert (=> b!561 m!729))

(assert (=> bm!76 d!281))

(declare-fun b!564 () Bool)

(declare-fun res!356 () Bool)

(declare-fun call!97 () Bool)

(assert (=> b!564 (= res!356 call!97)))

(declare-fun e!327 () Bool)

(assert (=> b!564 (=> (not res!356) (not e!327))))

(declare-fun d!283 () Bool)

(declare-fun res!354 () Bool)

(declare-fun e!328 () Bool)

(assert (=> d!283 (=> res!354 e!328)))

(assert (=> d!283 (= res!354 ((_ is Empty!3) (right!8 (left!8 (left!8 lt!2)))))))

(assert (=> d!283 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 lt!2)))) e!328)))

(declare-fun b!565 () Bool)

(declare-fun call!96 () Bool)

(assert (=> b!565 (= e!327 call!96)))

(declare-fun bm!96 () Bool)

(assert (=> bm!96 (= call!97 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (left!8 lt!2))))))))

(declare-fun bm!97 () Bool)

(assert (=> bm!97 (= call!96 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (left!8 lt!2))))))))

(declare-fun b!566 () Bool)

(declare-fun res!355 () Bool)

(assert (=> b!566 (= res!355 (isBlack!0 (right!8 (right!8 (left!8 (left!8 lt!2))))))))

(assert (=> b!566 (=> (not res!355) (not e!327))))

(declare-fun b!567 () Bool)

(declare-fun e!326 () Bool)

(assert (=> b!567 (= e!326 call!96)))

(declare-fun b!568 () Bool)

(declare-fun e!325 () Bool)

(assert (=> b!568 (= e!325 e!327)))

(declare-fun res!352 () Bool)

(assert (=> b!568 (= res!352 (isBlack!0 (left!8 (right!8 (left!8 (left!8 lt!2))))))))

(assert (=> b!568 (=> (not res!352) (not e!327))))

(declare-fun b!569 () Bool)

(assert (=> b!569 (= e!328 e!325)))

(declare-fun c!144 () Bool)

(assert (=> b!569 (= c!144 ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 lt!2))))))))

(declare-fun b!570 () Bool)

(assert (=> b!570 (= e!325 e!326)))

(declare-fun res!353 () Bool)

(assert (=> b!570 (= res!353 call!97)))

(assert (=> b!570 (=> (not res!353) (not e!326))))

(assert (= (and d!283 (not res!354)) b!569))

(assert (= (and b!569 c!144) b!570))

(assert (= (and b!569 (not c!144)) b!568))

(assert (= (and b!570 res!353) b!567))

(assert (= (and b!568 res!352) b!566))

(assert (= (and b!566 res!355) b!564))

(assert (= (and b!564 res!356) b!565))

(assert (= (or b!570 b!564) bm!96))

(assert (= (or b!567 b!565) bm!97))

(declare-fun m!731 () Bool)

(assert (=> bm!96 m!731))

(declare-fun m!733 () Bool)

(assert (=> bm!97 m!733))

(declare-fun m!735 () Bool)

(assert (=> b!566 m!735))

(declare-fun m!737 () Bool)

(assert (=> b!568 m!737))

(assert (=> bm!53 d!283))

(declare-fun d!285 () Bool)

(declare-fun c!145 () Bool)

(assert (=> d!285 (= c!145 ((_ is Empty!3) (left!8 (right!8 lt!5))))))

(declare-fun e!329 () (_ BitVec 32))

(assert (=> d!285 (= (blackHeight!0 (left!8 (right!8 lt!5))) e!329)))

(declare-fun b!571 () Bool)

(declare-fun e!330 () (_ BitVec 32))

(declare-fun call!98 () (_ BitVec 32))

(assert (=> b!571 (= e!330 (bvadd call!98 #b00000000000000000000000000000001))))

(declare-fun bm!98 () Bool)

(assert (=> bm!98 (= call!98 (blackHeight!0 (left!8 (left!8 (right!8 lt!5)))))))

(declare-fun b!572 () Bool)

(assert (=> b!572 (= e!330 call!98)))

(declare-fun b!573 () Bool)

(assert (=> b!573 (= e!329 e!330)))

(declare-fun c!146 () Bool)

(assert (=> b!573 (= c!146 ((_ is Black!3) (color!6 (left!8 (right!8 lt!5)))))))

(declare-fun b!574 () Bool)

(assert (=> b!574 (= e!329 #b00000000000000000000000000000001)))

(assert (= (and d!285 c!145) b!574))

(assert (= (and d!285 (not c!145)) b!573))

(assert (= (and b!573 c!146) b!571))

(assert (= (and b!573 (not c!146)) b!572))

(assert (= (or b!571 b!572) bm!98))

(declare-fun m!739 () Bool)

(assert (=> bm!98 m!739))

(assert (=> b!425 d!285))

(declare-fun d!287 () Bool)

(declare-fun c!147 () Bool)

(assert (=> d!287 (= c!147 ((_ is Empty!3) (right!8 (right!8 lt!5))))))

(declare-fun e!331 () (_ BitVec 32))

(assert (=> d!287 (= (blackHeight!0 (right!8 (right!8 lt!5))) e!331)))

(declare-fun b!575 () Bool)

(declare-fun e!332 () (_ BitVec 32))

(declare-fun call!99 () (_ BitVec 32))

(assert (=> b!575 (= e!332 (bvadd call!99 #b00000000000000000000000000000001))))

(declare-fun bm!99 () Bool)

(assert (=> bm!99 (= call!99 (blackHeight!0 (left!8 (right!8 (right!8 lt!5)))))))

(declare-fun b!576 () Bool)

(assert (=> b!576 (= e!332 call!99)))

(declare-fun b!577 () Bool)

(assert (=> b!577 (= e!331 e!332)))

(declare-fun c!148 () Bool)

(assert (=> b!577 (= c!148 ((_ is Black!3) (color!6 (right!8 (right!8 lt!5)))))))

(declare-fun b!578 () Bool)

(assert (=> b!578 (= e!331 #b00000000000000000000000000000001)))

(assert (= (and d!287 c!147) b!578))

(assert (= (and d!287 (not c!147)) b!577))

(assert (= (and b!577 c!148) b!575))

(assert (= (and b!577 (not c!148)) b!576))

(assert (= (or b!575 b!576) bm!99))

(assert (=> bm!99 m!571))

(assert (=> b!425 d!287))

(declare-fun d!289 () Bool)

(declare-fun c!149 () Bool)

(assert (=> d!289 (= c!149 ((_ is Empty!3) (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))))))

(declare-fun e!333 () (InoxSet (_ BitVec 32)))

(assert (=> d!289 (= (content!0 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))) e!333)))

(declare-fun b!579 () Bool)

(assert (=> b!579 (= e!333 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!580 () Bool)

(assert (=> b!580 (= e!333 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))) true)) (content!0 (right!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))))))))

(assert (= (and d!289 c!149) b!579))

(assert (= (and d!289 (not c!149)) b!580))

(declare-fun m!741 () Bool)

(assert (=> b!580 m!741))

(declare-fun m!743 () Bool)

(assert (=> b!580 m!743))

(declare-fun m!745 () Bool)

(assert (=> b!580 m!745))

(assert (=> b!317 d!289))

(declare-fun c!150 () Bool)

(declare-fun d!291 () Bool)

(assert (=> d!291 (= c!150 ((_ is Empty!3) (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))))))

(declare-fun e!334 () (InoxSet (_ BitVec 32)))

(assert (=> d!291 (= (content!0 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))) e!334)))

(declare-fun b!581 () Bool)

(assert (=> b!581 (= e!334 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!582 () Bool)

(assert (=> b!582 (= e!334 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))) true)) (content!0 (right!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))))))))

(assert (= (and d!291 c!150) b!581))

(assert (= (and d!291 (not c!150)) b!582))

(declare-fun m!747 () Bool)

(assert (=> b!582 m!747))

(declare-fun m!749 () Bool)

(assert (=> b!582 m!749))

(declare-fun m!751 () Bool)

(assert (=> b!582 m!751))

(assert (=> b!317 d!291))

(declare-fun b!583 () Bool)

(declare-fun res!361 () Bool)

(declare-fun call!101 () Bool)

(assert (=> b!583 (= res!361 call!101)))

(declare-fun e!337 () Bool)

(assert (=> b!583 (=> (not res!361) (not e!337))))

(declare-fun d!293 () Bool)

(declare-fun res!359 () Bool)

(declare-fun e!338 () Bool)

(assert (=> d!293 (=> res!359 e!338)))

(assert (=> d!293 (= res!359 ((_ is Empty!3) (left!8 (right!8 (right!8 lt!2)))))))

(assert (=> d!293 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 lt!2)))) e!338)))

(declare-fun b!584 () Bool)

(declare-fun call!100 () Bool)

(assert (=> b!584 (= e!337 call!100)))

(declare-fun bm!100 () Bool)

(assert (=> bm!100 (= call!101 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (right!8 lt!2))))))))

(declare-fun bm!101 () Bool)

(assert (=> bm!101 (= call!100 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (right!8 lt!2))))))))

(declare-fun b!585 () Bool)

(declare-fun res!360 () Bool)

(assert (=> b!585 (= res!360 (isBlack!0 (right!8 (left!8 (right!8 (right!8 lt!2))))))))

(assert (=> b!585 (=> (not res!360) (not e!337))))

(declare-fun b!586 () Bool)

(declare-fun e!336 () Bool)

(assert (=> b!586 (= e!336 call!100)))

(declare-fun b!587 () Bool)

(declare-fun e!335 () Bool)

(assert (=> b!587 (= e!335 e!337)))

(declare-fun res!357 () Bool)

(assert (=> b!587 (= res!357 (isBlack!0 (left!8 (left!8 (right!8 (right!8 lt!2))))))))

(assert (=> b!587 (=> (not res!357) (not e!337))))

(declare-fun b!588 () Bool)

(assert (=> b!588 (= e!338 e!335)))

(declare-fun c!151 () Bool)

(assert (=> b!588 (= c!151 ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 lt!2))))))))

(declare-fun b!589 () Bool)

(assert (=> b!589 (= e!335 e!336)))

(declare-fun res!358 () Bool)

(assert (=> b!589 (= res!358 call!101)))

(assert (=> b!589 (=> (not res!358) (not e!336))))

(assert (= (and d!293 (not res!359)) b!588))

(assert (= (and b!588 c!151) b!589))

(assert (= (and b!588 (not c!151)) b!587))

(assert (= (and b!589 res!358) b!586))

(assert (= (and b!587 res!357) b!585))

(assert (= (and b!585 res!360) b!583))

(assert (= (and b!583 res!361) b!584))

(assert (= (or b!589 b!583) bm!100))

(assert (= (or b!586 b!584) bm!101))

(declare-fun m!753 () Bool)

(assert (=> bm!100 m!753))

(declare-fun m!755 () Bool)

(assert (=> bm!101 m!755))

(declare-fun m!757 () Bool)

(assert (=> b!585 m!757))

(declare-fun m!759 () Bool)

(assert (=> b!587 m!759))

(assert (=> bm!78 d!293))

(declare-fun b!590 () Bool)

(declare-fun res!366 () Bool)

(declare-fun call!103 () Bool)

(assert (=> b!590 (= res!366 call!103)))

(declare-fun e!341 () Bool)

(assert (=> b!590 (=> (not res!366) (not e!341))))

(declare-fun d!295 () Bool)

(declare-fun res!364 () Bool)

(declare-fun e!342 () Bool)

(assert (=> d!295 (=> res!364 e!342)))

(assert (=> d!295 (= res!364 ((_ is Empty!3) (left!8 (right!8 lt!5))))))

(assert (=> d!295 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 lt!5))) e!342)))

(declare-fun b!591 () Bool)

(declare-fun call!102 () Bool)

(assert (=> b!591 (= e!341 call!102)))

(declare-fun bm!102 () Bool)

(assert (=> bm!102 (= call!103 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 lt!5)))))))

(declare-fun bm!103 () Bool)

(assert (=> bm!103 (= call!102 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 lt!5)))))))

(declare-fun b!592 () Bool)

(declare-fun res!365 () Bool)

(assert (=> b!592 (= res!365 (isBlack!0 (right!8 (left!8 (right!8 lt!5)))))))

(assert (=> b!592 (=> (not res!365) (not e!341))))

(declare-fun b!593 () Bool)

(declare-fun e!340 () Bool)

(assert (=> b!593 (= e!340 call!102)))

(declare-fun b!594 () Bool)

(declare-fun e!339 () Bool)

(assert (=> b!594 (= e!339 e!341)))

(declare-fun res!362 () Bool)

(assert (=> b!594 (= res!362 (isBlack!0 (left!8 (left!8 (right!8 lt!5)))))))

(assert (=> b!594 (=> (not res!362) (not e!341))))

(declare-fun b!595 () Bool)

(assert (=> b!595 (= e!342 e!339)))

(declare-fun c!152 () Bool)

(assert (=> b!595 (= c!152 ((_ is Black!3) (color!6 (left!8 (right!8 lt!5)))))))

(declare-fun b!596 () Bool)

(assert (=> b!596 (= e!339 e!340)))

(declare-fun res!363 () Bool)

(assert (=> b!596 (= res!363 call!103)))

(assert (=> b!596 (=> (not res!363) (not e!340))))

(assert (= (and d!295 (not res!364)) b!595))

(assert (= (and b!595 c!152) b!596))

(assert (= (and b!595 (not c!152)) b!594))

(assert (= (and b!596 res!363) b!593))

(assert (= (and b!594 res!362) b!592))

(assert (= (and b!592 res!365) b!590))

(assert (= (and b!590 res!366) b!591))

(assert (= (or b!596 b!590) bm!102))

(assert (= (or b!593 b!591) bm!103))

(declare-fun m!761 () Bool)

(assert (=> bm!102 m!761))

(declare-fun m!763 () Bool)

(assert (=> bm!103 m!763))

(declare-fun m!765 () Bool)

(assert (=> b!592 m!765))

(declare-fun m!767 () Bool)

(assert (=> b!594 m!767))

(assert (=> bm!64 d!295))

(declare-fun d!297 () Bool)

(assert (=> d!297 (= (isBlack!0 (left!8 (right!8 (right!8 lt!2)))) (or ((_ is Empty!3) (left!8 (right!8 (right!8 lt!2)))) ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 lt!2)))))))))

(assert (=> b!448 d!297))

(declare-fun d!299 () Bool)

(assert (=> d!299 (= (isBlack!0 (left!8 (right!8 lt!5))) (or ((_ is Empty!3) (left!8 (right!8 lt!5))) ((_ is Black!3) (color!6 (left!8 (right!8 lt!5))))))))

(assert (=> b!384 d!299))

(assert (=> bm!73 d!285))

(declare-fun b!597 () Bool)

(declare-fun res!370 () Bool)

(declare-fun e!347 () Bool)

(assert (=> b!597 (=> (not res!370) (not e!347))))

(declare-fun lt!28 () Tree!3)

(assert (=> b!597 (= res!370 (<= (size!0 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (size!0 lt!28)))))

(declare-fun b!598 () Bool)

(declare-fun e!345 () Tree!3)

(declare-fun call!105 () Tree!3)

(assert (=> b!598 (= e!345 call!105)))

(declare-fun b!599 () Bool)

(declare-fun e!343 () Tree!3)

(assert (=> b!599 (= e!343 call!105)))

(declare-fun b!600 () Bool)

(declare-fun res!368 () Bool)

(assert (=> b!600 (=> (not res!368) (not e!347))))

(assert (=> b!600 (= res!368 (<= (size!0 lt!28) (+ (size!0 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) 1)))))

(declare-fun call!104 () Tree!3)

(declare-fun bm!104 () Bool)

(declare-fun c!155 () Bool)

(assert (=> bm!104 (= call!105 (balance!0 (color!6 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104)))))

(declare-fun b!601 () Bool)

(declare-fun e!344 () Tree!3)

(assert (=> b!601 (= e!344 e!343)))

(assert (=> b!601 (= c!155 (bvslt x!73 (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(declare-fun c!153 () Bool)

(declare-fun b!602 () Bool)

(assert (=> b!602 (= c!153 (= x!73 (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (=> b!602 (= e!343 e!345)))

(declare-fun b!604 () Bool)

(assert (=> b!604 (= e!344 (Node!3 Red!3 Empty!3 x!73 Empty!3))))

(declare-fun b!605 () Bool)

(declare-fun e!346 () Bool)

(assert (=> b!605 (= e!346 (blackBalanced!0 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun bm!105 () Bool)

(assert (=> bm!105 (= call!104 (ins!0 x!73 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))))

(declare-fun b!603 () Bool)

(assert (=> b!603 (= e!347 (blackBalanced!0 lt!28))))

(declare-fun d!301 () Bool)

(assert (=> d!301 e!347))

(declare-fun res!367 () Bool)

(assert (=> d!301 (=> (not res!367) (not e!347))))

(assert (=> d!301 (= res!367 (= (content!0 lt!28) ((_ map or) (content!0 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (store ((as const (Array (_ BitVec 32) Bool)) false) x!73 true))))))

(assert (=> d!301 (= lt!28 e!344)))

(declare-fun c!154 () Bool)

(assert (=> d!301 (= c!154 ((_ is Empty!3) (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> d!301 e!346))

(declare-fun res!371 () Bool)

(assert (=> d!301 (=> (not res!371) (not e!346))))

(assert (=> d!301 (= res!371 (redNodesHaveBlackChildren!0 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> d!301 (= (ins!0 x!73 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) lt!28)))

(declare-fun b!606 () Bool)

(declare-fun res!369 () Bool)

(assert (=> b!606 (=> (not res!369) (not e!347))))

(assert (=> b!606 (= res!369 (redDescHaveBlackChildren!0 lt!28))))

(declare-fun b!607 () Bool)

(assert (=> b!607 (= e!345 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (= (and d!301 res!371) b!605))

(assert (= (and d!301 c!154) b!604))

(assert (= (and d!301 (not c!154)) b!601))

(assert (= (and b!601 c!155) b!599))

(assert (= (and b!601 (not c!155)) b!602))

(assert (= (and b!602 c!153) b!607))

(assert (= (and b!602 (not c!153)) b!598))

(assert (= (or b!599 b!598) bm!105))

(assert (= (or b!599 b!598) bm!104))

(assert (= (and d!301 res!367) b!597))

(assert (= (and b!597 res!370) b!600))

(assert (= (and b!600 res!368) b!606))

(assert (= (and b!606 res!369) b!603))

(declare-fun m!769 () Bool)

(assert (=> d!301 m!769))

(declare-fun m!771 () Bool)

(assert (=> d!301 m!771))

(assert (=> d!301 m!123))

(declare-fun m!773 () Bool)

(assert (=> d!301 m!773))

(declare-fun m!775 () Bool)

(assert (=> bm!105 m!775))

(declare-fun m!777 () Bool)

(assert (=> bm!104 m!777))

(declare-fun m!779 () Bool)

(assert (=> b!605 m!779))

(declare-fun m!781 () Bool)

(assert (=> b!597 m!781))

(declare-fun m!783 () Bool)

(assert (=> b!597 m!783))

(assert (=> b!600 m!783))

(assert (=> b!600 m!781))

(declare-fun m!785 () Bool)

(assert (=> b!603 m!785))

(declare-fun m!787 () Bool)

(assert (=> b!606 m!787))

(assert (=> bm!59 d!301))

(declare-fun d!303 () Bool)

(declare-fun res!372 () Bool)

(declare-fun e!348 () Bool)

(assert (=> d!303 (=> res!372 e!348)))

(assert (=> d!303 (= res!372 (not ((_ is Node!3) (left!8 lt!13))))))

(assert (=> d!303 (= (blackBalanced!0 (left!8 lt!13)) e!348)))

(declare-fun b!608 () Bool)

(declare-fun e!349 () Bool)

(assert (=> b!608 (= e!348 e!349)))

(declare-fun res!374 () Bool)

(assert (=> b!608 (=> (not res!374) (not e!349))))

(assert (=> b!608 (= res!374 (blackBalanced!0 (left!8 (left!8 lt!13))))))

(declare-fun b!609 () Bool)

(declare-fun res!373 () Bool)

(assert (=> b!609 (=> (not res!373) (not e!349))))

(assert (=> b!609 (= res!373 (blackBalanced!0 (right!8 (left!8 lt!13))))))

(declare-fun b!610 () Bool)

(assert (=> b!610 (= e!349 (= (blackHeight!0 (left!8 (left!8 lt!13))) (blackHeight!0 (right!8 (left!8 lt!13)))))))

(assert (= (and d!303 (not res!372)) b!608))

(assert (= (and b!608 res!374) b!609))

(assert (= (and b!609 res!373) b!610))

(declare-fun m!789 () Bool)

(assert (=> b!608 m!789))

(declare-fun m!791 () Bool)

(assert (=> b!609 m!791))

(declare-fun m!793 () Bool)

(assert (=> b!610 m!793))

(declare-fun m!795 () Bool)

(assert (=> b!610 m!795))

(assert (=> b!455 d!303))

(declare-fun d!305 () Bool)

(assert (=> d!305 (= (isBlack!0 (left!8 (right!8 (left!8 lt!2)))) (or ((_ is Empty!3) (left!8 (right!8 (left!8 lt!2)))) ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 lt!2)))))))))

(assert (=> b!297 d!305))

(declare-fun d!307 () Bool)

(declare-fun c!156 () Bool)

(assert (=> d!307 (= c!156 ((_ is Empty!3) (left!8 (right!8 t!78))))))

(declare-fun e!350 () (_ BitVec 32))

(assert (=> d!307 (= (blackHeight!0 (left!8 (right!8 t!78))) e!350)))

(declare-fun b!611 () Bool)

(declare-fun e!351 () (_ BitVec 32))

(declare-fun call!106 () (_ BitVec 32))

(assert (=> b!611 (= e!351 (bvadd call!106 #b00000000000000000000000000000001))))

(declare-fun bm!106 () Bool)

(assert (=> bm!106 (= call!106 (blackHeight!0 (left!8 (left!8 (right!8 t!78)))))))

(declare-fun b!612 () Bool)

(assert (=> b!612 (= e!351 call!106)))

(declare-fun b!613 () Bool)

(assert (=> b!613 (= e!350 e!351)))

(declare-fun c!157 () Bool)

(assert (=> b!613 (= c!157 ((_ is Black!3) (color!6 (left!8 (right!8 t!78)))))))

(declare-fun b!614 () Bool)

(assert (=> b!614 (= e!350 #b00000000000000000000000000000001)))

(assert (= (and d!307 c!156) b!614))

(assert (= (and d!307 (not c!156)) b!613))

(assert (= (and b!613 c!157) b!611))

(assert (= (and b!613 (not c!157)) b!612))

(assert (= (or b!611 b!612) bm!106))

(declare-fun m!797 () Bool)

(assert (=> bm!106 m!797))

(assert (=> b!292 d!307))

(declare-fun d!309 () Bool)

(declare-fun c!158 () Bool)

(assert (=> d!309 (= c!158 ((_ is Empty!3) (right!8 (right!8 t!78))))))

(declare-fun e!352 () (_ BitVec 32))

(assert (=> d!309 (= (blackHeight!0 (right!8 (right!8 t!78))) e!352)))

(declare-fun b!615 () Bool)

(declare-fun e!353 () (_ BitVec 32))

(declare-fun call!107 () (_ BitVec 32))

(assert (=> b!615 (= e!353 (bvadd call!107 #b00000000000000000000000000000001))))

(declare-fun bm!107 () Bool)

(assert (=> bm!107 (= call!107 (blackHeight!0 (left!8 (right!8 (right!8 t!78)))))))

(declare-fun b!616 () Bool)

(assert (=> b!616 (= e!353 call!107)))

(declare-fun b!617 () Bool)

(assert (=> b!617 (= e!352 e!353)))

(declare-fun c!159 () Bool)

(assert (=> b!617 (= c!159 ((_ is Black!3) (color!6 (right!8 (right!8 t!78)))))))

(declare-fun b!618 () Bool)

(assert (=> b!618 (= e!352 #b00000000000000000000000000000001)))

(assert (= (and d!309 c!158) b!618))

(assert (= (and d!309 (not c!158)) b!617))

(assert (= (and b!617 c!159) b!615))

(assert (= (and b!617 (not c!159)) b!616))

(assert (= (or b!615 b!616) bm!107))

(assert (=> bm!107 m!663))

(assert (=> b!292 d!309))

(declare-fun d!311 () Bool)

(declare-fun c!160 () Bool)

(assert (=> d!311 (= c!160 ((_ is Empty!3) (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(declare-fun e!354 () (_ BitVec 32))

(assert (=> d!311 (= (blackHeight!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) e!354)))

(declare-fun b!619 () Bool)

(declare-fun e!355 () (_ BitVec 32))

(declare-fun call!108 () (_ BitVec 32))

(assert (=> b!619 (= e!355 (bvadd call!108 #b00000000000000000000000000000001))))

(declare-fun bm!108 () Bool)

(assert (=> bm!108 (= call!108 (blackHeight!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!620 () Bool)

(assert (=> b!620 (= e!355 call!108)))

(declare-fun b!621 () Bool)

(assert (=> b!621 (= e!354 e!355)))

(declare-fun c!161 () Bool)

(assert (=> b!621 (= c!161 ((_ is Black!3) (color!6 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!622 () Bool)

(assert (=> b!622 (= e!354 #b00000000000000000000000000000001)))

(assert (= (and d!311 c!160) b!622))

(assert (= (and d!311 (not c!160)) b!621))

(assert (= (and b!621 c!161) b!619))

(assert (= (and b!621 (not c!161)) b!620))

(assert (= (or b!619 b!620) bm!108))

(declare-fun m!799 () Bool)

(assert (=> bm!108 m!799))

(assert (=> b!443 d!311))

(declare-fun d!313 () Bool)

(declare-fun c!162 () Bool)

(assert (=> d!313 (= c!162 ((_ is Empty!3) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(declare-fun e!356 () (_ BitVec 32))

(assert (=> d!313 (= (blackHeight!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) e!356)))

(declare-fun b!623 () Bool)

(declare-fun e!357 () (_ BitVec 32))

(declare-fun call!109 () (_ BitVec 32))

(assert (=> b!623 (= e!357 (bvadd call!109 #b00000000000000000000000000000001))))

(declare-fun bm!109 () Bool)

(assert (=> bm!109 (= call!109 (blackHeight!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!624 () Bool)

(assert (=> b!624 (= e!357 call!109)))

(declare-fun b!625 () Bool)

(assert (=> b!625 (= e!356 e!357)))

(declare-fun c!163 () Bool)

(assert (=> b!625 (= c!163 ((_ is Black!3) (color!6 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!626 () Bool)

(assert (=> b!626 (= e!356 #b00000000000000000000000000000001)))

(assert (= (and d!313 c!162) b!626))

(assert (= (and d!313 (not c!162)) b!625))

(assert (= (and b!625 c!163) b!623))

(assert (= (and b!625 (not c!163)) b!624))

(assert (= (or b!623 b!624) bm!109))

(assert (=> bm!109 m!671))

(assert (=> b!443 d!313))

(declare-fun b!627 () Bool)

(declare-fun res!379 () Bool)

(declare-fun call!111 () Bool)

(assert (=> b!627 (= res!379 call!111)))

(declare-fun e!360 () Bool)

(assert (=> b!627 (=> (not res!379) (not e!360))))

(declare-fun d!315 () Bool)

(declare-fun res!377 () Bool)

(declare-fun e!361 () Bool)

(assert (=> d!315 (=> res!377 e!361)))

(assert (=> d!315 (= res!377 ((_ is Empty!3) (left!8 (right!8 (left!8 lt!2)))))))

(assert (=> d!315 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 lt!2)))) e!361)))

(declare-fun b!628 () Bool)

(declare-fun call!110 () Bool)

(assert (=> b!628 (= e!360 call!110)))

(declare-fun bm!110 () Bool)

(assert (=> bm!110 (= call!111 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (left!8 lt!2))))))))

(declare-fun bm!111 () Bool)

(assert (=> bm!111 (= call!110 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (left!8 lt!2))))))))

(declare-fun b!629 () Bool)

(declare-fun res!378 () Bool)

(assert (=> b!629 (= res!378 (isBlack!0 (right!8 (left!8 (right!8 (left!8 lt!2))))))))

(assert (=> b!629 (=> (not res!378) (not e!360))))

(declare-fun b!630 () Bool)

(declare-fun e!359 () Bool)

(assert (=> b!630 (= e!359 call!110)))

(declare-fun b!631 () Bool)

(declare-fun e!358 () Bool)

(assert (=> b!631 (= e!358 e!360)))

(declare-fun res!375 () Bool)

(assert (=> b!631 (= res!375 (isBlack!0 (left!8 (left!8 (right!8 (left!8 lt!2))))))))

(assert (=> b!631 (=> (not res!375) (not e!360))))

(declare-fun b!632 () Bool)

(assert (=> b!632 (= e!361 e!358)))

(declare-fun c!164 () Bool)

(assert (=> b!632 (= c!164 ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 lt!2))))))))

(declare-fun b!633 () Bool)

(assert (=> b!633 (= e!358 e!359)))

(declare-fun res!376 () Bool)

(assert (=> b!633 (= res!376 call!111)))

(assert (=> b!633 (=> (not res!376) (not e!359))))

(assert (= (and d!315 (not res!377)) b!632))

(assert (= (and b!632 c!164) b!633))

(assert (= (and b!632 (not c!164)) b!631))

(assert (= (and b!633 res!376) b!630))

(assert (= (and b!631 res!375) b!629))

(assert (= (and b!629 res!378) b!627))

(assert (= (and b!627 res!379) b!628))

(assert (= (or b!633 b!627) bm!110))

(assert (= (or b!630 b!628) bm!111))

(declare-fun m!801 () Bool)

(assert (=> bm!110 m!801))

(declare-fun m!803 () Bool)

(assert (=> bm!111 m!803))

(declare-fun m!805 () Bool)

(assert (=> b!629 m!805))

(declare-fun m!807 () Bool)

(assert (=> b!631 m!807))

(assert (=> bm!50 d!315))

(declare-fun d!317 () Bool)

(declare-fun lt!29 () Int)

(assert (=> d!317 (>= lt!29 0)))

(declare-fun e!362 () Int)

(assert (=> d!317 (= lt!29 e!362)))

(declare-fun c!165 () Bool)

(assert (=> d!317 (= c!165 ((_ is Empty!3) (left!8 (left!8 lt!5))))))

(assert (=> d!317 (= (size!0 (left!8 (left!8 lt!5))) lt!29)))

(declare-fun b!634 () Bool)

(assert (=> b!634 (= e!362 0)))

(declare-fun b!635 () Bool)

(assert (=> b!635 (= e!362 (+ (size!0 (left!8 (left!8 (left!8 lt!5)))) 1 (size!0 (right!8 (left!8 (left!8 lt!5))))))))

(assert (= (and d!317 c!165) b!634))

(assert (= (and d!317 (not c!165)) b!635))

(declare-fun m!809 () Bool)

(assert (=> b!635 m!809))

(declare-fun m!811 () Bool)

(assert (=> b!635 m!811))

(assert (=> b!459 d!317))

(declare-fun d!319 () Bool)

(declare-fun lt!30 () Int)

(assert (=> d!319 (>= lt!30 0)))

(declare-fun e!363 () Int)

(assert (=> d!319 (= lt!30 e!363)))

(declare-fun c!166 () Bool)

(assert (=> d!319 (= c!166 ((_ is Empty!3) (right!8 (left!8 lt!5))))))

(assert (=> d!319 (= (size!0 (right!8 (left!8 lt!5))) lt!30)))

(declare-fun b!636 () Bool)

(assert (=> b!636 (= e!363 0)))

(declare-fun b!637 () Bool)

(assert (=> b!637 (= e!363 (+ (size!0 (left!8 (right!8 (left!8 lt!5)))) 1 (size!0 (right!8 (right!8 (left!8 lt!5))))))))

(assert (= (and d!319 c!166) b!636))

(assert (= (and d!319 (not c!166)) b!637))

(declare-fun m!813 () Bool)

(assert (=> b!637 m!813))

(declare-fun m!815 () Bool)

(assert (=> b!637 m!815))

(assert (=> b!459 d!319))

(assert (=> bm!72 d!239))

(declare-fun d!321 () Bool)

(assert (=> d!321 (= (isBlack!0 (right!8 (left!8 (left!8 t!78)))) (or ((_ is Empty!3) (right!8 (left!8 (left!8 t!78)))) ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 t!78)))))))))

(assert (=> b!403 d!321))

(declare-fun d!323 () Bool)

(assert (=> d!323 (= (isBlack!0 (right!8 (right!8 (right!8 t!78)))) (or ((_ is Empty!3) (right!8 (right!8 (right!8 t!78)))) ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 t!78)))))))))

(assert (=> b!375 d!323))

(declare-fun d!325 () Bool)

(declare-fun c!167 () Bool)

(assert (=> d!325 (= c!167 ((_ is Empty!3) (left!8 lt!12)))))

(declare-fun e!364 () (InoxSet (_ BitVec 32)))

(assert (=> d!325 (= (content!0 (left!8 lt!12)) e!364)))

(declare-fun b!638 () Bool)

(assert (=> b!638 (= e!364 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!639 () Bool)

(assert (=> b!639 (= e!364 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 lt!12))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 lt!12)) true)) (content!0 (right!8 (left!8 lt!12)))))))

(assert (= (and d!325 c!167) b!638))

(assert (= (and d!325 (not c!167)) b!639))

(declare-fun m!817 () Bool)

(assert (=> b!639 m!817))

(declare-fun m!819 () Bool)

(assert (=> b!639 m!819))

(declare-fun m!821 () Bool)

(assert (=> b!639 m!821))

(assert (=> b!315 d!325))

(declare-fun d!327 () Bool)

(declare-fun c!168 () Bool)

(assert (=> d!327 (= c!168 ((_ is Empty!3) (right!8 lt!12)))))

(declare-fun e!365 () (InoxSet (_ BitVec 32)))

(assert (=> d!327 (= (content!0 (right!8 lt!12)) e!365)))

(declare-fun b!640 () Bool)

(assert (=> b!640 (= e!365 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!641 () Bool)

(assert (=> b!641 (= e!365 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 lt!12))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 lt!12)) true)) (content!0 (right!8 (right!8 lt!12)))))))

(assert (= (and d!327 c!168) b!640))

(assert (= (and d!327 (not c!168)) b!641))

(declare-fun m!823 () Bool)

(assert (=> b!641 m!823))

(declare-fun m!825 () Bool)

(assert (=> b!641 m!825))

(declare-fun m!827 () Bool)

(assert (=> b!641 m!827))

(assert (=> b!315 d!327))

(declare-fun b!642 () Bool)

(declare-fun res!384 () Bool)

(declare-fun call!113 () Bool)

(assert (=> b!642 (= res!384 call!113)))

(declare-fun e!368 () Bool)

(assert (=> b!642 (=> (not res!384) (not e!368))))

(declare-fun d!329 () Bool)

(declare-fun res!382 () Bool)

(declare-fun e!369 () Bool)

(assert (=> d!329 (=> res!382 e!369)))

(assert (=> d!329 (= res!382 ((_ is Empty!3) (right!8 (left!8 lt!5))))))

(assert (=> d!329 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 lt!5))) e!369)))

(declare-fun b!643 () Bool)

(declare-fun call!112 () Bool)

(assert (=> b!643 (= e!368 call!112)))

(declare-fun bm!112 () Bool)

(assert (=> bm!112 (= call!113 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 lt!5)))))))

(declare-fun bm!113 () Bool)

(assert (=> bm!113 (= call!112 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 lt!5)))))))

(declare-fun b!644 () Bool)

(declare-fun res!383 () Bool)

(assert (=> b!644 (= res!383 (isBlack!0 (right!8 (right!8 (left!8 lt!5)))))))

(assert (=> b!644 (=> (not res!383) (not e!368))))

(declare-fun b!645 () Bool)

(declare-fun e!367 () Bool)

(assert (=> b!645 (= e!367 call!112)))

(declare-fun b!646 () Bool)

(declare-fun e!366 () Bool)

(assert (=> b!646 (= e!366 e!368)))

(declare-fun res!380 () Bool)

(assert (=> b!646 (= res!380 (isBlack!0 (left!8 (right!8 (left!8 lt!5)))))))

(assert (=> b!646 (=> (not res!380) (not e!368))))

(declare-fun b!647 () Bool)

(assert (=> b!647 (= e!369 e!366)))

(declare-fun c!169 () Bool)

(assert (=> b!647 (= c!169 ((_ is Black!3) (color!6 (right!8 (left!8 lt!5)))))))

(declare-fun b!648 () Bool)

(assert (=> b!648 (= e!366 e!367)))

(declare-fun res!381 () Bool)

(assert (=> b!648 (= res!381 call!113)))

(assert (=> b!648 (=> (not res!381) (not e!367))))

(assert (= (and d!329 (not res!382)) b!647))

(assert (= (and b!647 c!169) b!648))

(assert (= (and b!647 (not c!169)) b!646))

(assert (= (and b!648 res!381) b!645))

(assert (= (and b!646 res!380) b!644))

(assert (= (and b!644 res!383) b!642))

(assert (= (and b!642 res!384) b!643))

(assert (= (or b!648 b!642) bm!112))

(assert (= (or b!645 b!643) bm!113))

(declare-fun m!829 () Bool)

(assert (=> bm!112 m!829))

(declare-fun m!831 () Bool)

(assert (=> bm!113 m!831))

(declare-fun m!833 () Bool)

(assert (=> b!644 m!833))

(declare-fun m!835 () Bool)

(assert (=> b!646 m!835))

(assert (=> bm!67 d!329))

(declare-fun b!649 () Bool)

(declare-fun res!389 () Bool)

(declare-fun call!115 () Bool)

(assert (=> b!649 (= res!389 call!115)))

(declare-fun e!372 () Bool)

(assert (=> b!649 (=> (not res!389) (not e!372))))

(declare-fun d!331 () Bool)

(declare-fun res!387 () Bool)

(declare-fun e!373 () Bool)

(assert (=> d!331 (=> res!387 e!373)))

(assert (=> d!331 (= res!387 ((_ is Empty!3) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(assert (=> d!331 (= (redNodesHaveBlackChildren!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) e!373)))

(declare-fun b!650 () Bool)

(declare-fun call!114 () Bool)

(assert (=> b!650 (= e!372 call!114)))

(declare-fun bm!114 () Bool)

(assert (=> bm!114 (= call!115 (redNodesHaveBlackChildren!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun bm!115 () Bool)

(assert (=> bm!115 (= call!114 (redNodesHaveBlackChildren!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!651 () Bool)

(declare-fun res!388 () Bool)

(assert (=> b!651 (= res!388 (isBlack!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> b!651 (=> (not res!388) (not e!372))))

(declare-fun b!652 () Bool)

(declare-fun e!371 () Bool)

(assert (=> b!652 (= e!371 call!114)))

(declare-fun b!653 () Bool)

(declare-fun e!370 () Bool)

(assert (=> b!653 (= e!370 e!372)))

(declare-fun res!385 () Bool)

(assert (=> b!653 (= res!385 (isBlack!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> b!653 (=> (not res!385) (not e!372))))

(declare-fun b!654 () Bool)

(assert (=> b!654 (= e!373 e!370)))

(declare-fun c!170 () Bool)

(assert (=> b!654 (= c!170 ((_ is Black!3) (color!6 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!655 () Bool)

(assert (=> b!655 (= e!370 e!371)))

(declare-fun res!386 () Bool)

(assert (=> b!655 (= res!386 call!115)))

(assert (=> b!655 (=> (not res!386) (not e!371))))

(assert (= (and d!331 (not res!387)) b!654))

(assert (= (and b!654 c!170) b!655))

(assert (= (and b!654 (not c!170)) b!653))

(assert (= (and b!655 res!386) b!652))

(assert (= (and b!653 res!385) b!651))

(assert (= (and b!651 res!388) b!649))

(assert (= (and b!649 res!389) b!650))

(assert (= (or b!655 b!649) bm!114))

(assert (= (or b!652 b!650) bm!115))

(declare-fun m!837 () Bool)

(assert (=> bm!114 m!837))

(declare-fun m!839 () Bool)

(assert (=> bm!115 m!839))

(declare-fun m!841 () Bool)

(assert (=> b!651 m!841))

(declare-fun m!843 () Bool)

(assert (=> b!653 m!843))

(assert (=> bm!77 d!331))

(declare-fun d!333 () Bool)

(assert (=> d!333 (= (isBlack!0 (left!8 (left!8 (right!8 t!78)))) (or ((_ is Empty!3) (left!8 (left!8 (right!8 t!78)))) ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 t!78)))))))))

(assert (=> b!370 d!333))

(declare-fun d!335 () Bool)

(assert (=> d!335 (= (isBlack!0 (left!8 (right!8 (left!8 t!78)))) (or ((_ is Empty!3) (left!8 (right!8 (left!8 t!78)))) ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 t!78)))))))))

(assert (=> b!420 d!335))

(assert (=> bm!57 d!307))

(declare-fun d!337 () Bool)

(assert (=> d!337 (= (isBlack!0 (right!8 (left!8 (left!8 lt!2)))) (or ((_ is Empty!3) (right!8 (left!8 (left!8 lt!2)))) ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 lt!2)))))))))

(assert (=> b!305 d!337))

(declare-fun b!656 () Bool)

(declare-fun res!394 () Bool)

(declare-fun call!117 () Bool)

(assert (=> b!656 (= res!394 call!117)))

(declare-fun e!376 () Bool)

(assert (=> b!656 (=> (not res!394) (not e!376))))

(declare-fun d!339 () Bool)

(declare-fun res!392 () Bool)

(declare-fun e!377 () Bool)

(assert (=> d!339 (=> res!392 e!377)))

(assert (=> d!339 (= res!392 ((_ is Empty!3) (right!8 (right!8 (right!8 lt!2)))))))

(assert (=> d!339 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 lt!2)))) e!377)))

(declare-fun b!657 () Bool)

(declare-fun call!116 () Bool)

(assert (=> b!657 (= e!376 call!116)))

(declare-fun bm!116 () Bool)

(assert (=> bm!116 (= call!117 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (right!8 lt!2))))))))

(declare-fun bm!117 () Bool)

(assert (=> bm!117 (= call!116 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (right!8 lt!2))))))))

(declare-fun b!658 () Bool)

(declare-fun res!393 () Bool)

(assert (=> b!658 (= res!393 (isBlack!0 (right!8 (right!8 (right!8 (right!8 lt!2))))))))

(assert (=> b!658 (=> (not res!393) (not e!376))))

(declare-fun b!659 () Bool)

(declare-fun e!375 () Bool)

(assert (=> b!659 (= e!375 call!116)))

(declare-fun b!660 () Bool)

(declare-fun e!374 () Bool)

(assert (=> b!660 (= e!374 e!376)))

(declare-fun res!390 () Bool)

(assert (=> b!660 (= res!390 (isBlack!0 (left!8 (right!8 (right!8 (right!8 lt!2))))))))

(assert (=> b!660 (=> (not res!390) (not e!376))))

(declare-fun b!661 () Bool)

(assert (=> b!661 (= e!377 e!374)))

(declare-fun c!171 () Bool)

(assert (=> b!661 (= c!171 ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 lt!2))))))))

(declare-fun b!662 () Bool)

(assert (=> b!662 (= e!374 e!375)))

(declare-fun res!391 () Bool)

(assert (=> b!662 (= res!391 call!117)))

(assert (=> b!662 (=> (not res!391) (not e!375))))

(assert (= (and d!339 (not res!392)) b!661))

(assert (= (and b!661 c!171) b!662))

(assert (= (and b!661 (not c!171)) b!660))

(assert (= (and b!662 res!391) b!659))

(assert (= (and b!660 res!390) b!658))

(assert (= (and b!658 res!393) b!656))

(assert (= (and b!656 res!394) b!657))

(assert (= (or b!662 b!656) bm!116))

(assert (= (or b!659 b!657) bm!117))

(declare-fun m!845 () Bool)

(assert (=> bm!116 m!845))

(declare-fun m!847 () Bool)

(assert (=> bm!117 m!847))

(declare-fun m!849 () Bool)

(assert (=> b!658 m!849))

(declare-fun m!851 () Bool)

(assert (=> b!660 m!851))

(assert (=> bm!79 d!339))

(declare-fun b!663 () Bool)

(declare-fun res!399 () Bool)

(declare-fun call!119 () Bool)

(assert (=> b!663 (= res!399 call!119)))

(declare-fun e!380 () Bool)

(assert (=> b!663 (=> (not res!399) (not e!380))))

(declare-fun d!341 () Bool)

(declare-fun res!397 () Bool)

(declare-fun e!381 () Bool)

(assert (=> d!341 (=> res!397 e!381)))

(assert (=> d!341 (= res!397 ((_ is Empty!3) (right!8 (right!8 lt!5))))))

(assert (=> d!341 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 lt!5))) e!381)))

(declare-fun b!664 () Bool)

(declare-fun call!118 () Bool)

(assert (=> b!664 (= e!380 call!118)))

(declare-fun bm!118 () Bool)

(assert (=> bm!118 (= call!119 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 lt!5)))))))

(declare-fun bm!119 () Bool)

(assert (=> bm!119 (= call!118 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 lt!5)))))))

(declare-fun b!665 () Bool)

(declare-fun res!398 () Bool)

(assert (=> b!665 (= res!398 (isBlack!0 (right!8 (right!8 (right!8 lt!5)))))))

(assert (=> b!665 (=> (not res!398) (not e!380))))

(declare-fun b!666 () Bool)

(declare-fun e!379 () Bool)

(assert (=> b!666 (= e!379 call!118)))

(declare-fun b!667 () Bool)

(declare-fun e!378 () Bool)

(assert (=> b!667 (= e!378 e!380)))

(declare-fun res!395 () Bool)

(assert (=> b!667 (= res!395 (isBlack!0 (left!8 (right!8 (right!8 lt!5)))))))

(assert (=> b!667 (=> (not res!395) (not e!380))))

(declare-fun b!668 () Bool)

(assert (=> b!668 (= e!381 e!378)))

(declare-fun c!172 () Bool)

(assert (=> b!668 (= c!172 ((_ is Black!3) (color!6 (right!8 (right!8 lt!5)))))))

(declare-fun b!669 () Bool)

(assert (=> b!669 (= e!378 e!379)))

(declare-fun res!396 () Bool)

(assert (=> b!669 (= res!396 call!119)))

(assert (=> b!669 (=> (not res!396) (not e!379))))

(assert (= (and d!341 (not res!397)) b!668))

(assert (= (and b!668 c!172) b!669))

(assert (= (and b!668 (not c!172)) b!667))

(assert (= (and b!669 res!396) b!666))

(assert (= (and b!667 res!395) b!665))

(assert (= (and b!665 res!398) b!663))

(assert (= (and b!663 res!399) b!664))

(assert (= (or b!669 b!663) bm!118))

(assert (= (or b!666 b!664) bm!119))

(declare-fun m!853 () Bool)

(assert (=> bm!118 m!853))

(declare-fun m!855 () Bool)

(assert (=> bm!119 m!855))

(declare-fun m!857 () Bool)

(assert (=> b!665 m!857))

(declare-fun m!859 () Bool)

(assert (=> b!667 m!859))

(assert (=> bm!65 d!341))

(declare-fun d!343 () Bool)

(declare-fun res!400 () Bool)

(declare-fun e!382 () Bool)

(assert (=> d!343 (=> res!400 e!382)))

(assert (=> d!343 (= res!400 (not ((_ is Node!3) (left!8 (left!8 t!78)))))))

(assert (=> d!343 (= (blackBalanced!0 (left!8 (left!8 t!78))) e!382)))

(declare-fun b!670 () Bool)

(declare-fun e!383 () Bool)

(assert (=> b!670 (= e!382 e!383)))

(declare-fun res!402 () Bool)

(assert (=> b!670 (=> (not res!402) (not e!383))))

(assert (=> b!670 (= res!402 (blackBalanced!0 (left!8 (left!8 (left!8 t!78)))))))

(declare-fun b!671 () Bool)

(declare-fun res!401 () Bool)

(assert (=> b!671 (=> (not res!401) (not e!383))))

(assert (=> b!671 (= res!401 (blackBalanced!0 (right!8 (left!8 (left!8 t!78)))))))

(declare-fun b!672 () Bool)

(assert (=> b!672 (= e!383 (= (blackHeight!0 (left!8 (left!8 (left!8 t!78)))) (blackHeight!0 (right!8 (left!8 (left!8 t!78))))))))

(assert (= (and d!343 (not res!400)) b!670))

(assert (= (and b!670 res!402) b!671))

(assert (= (and b!671 res!401) b!672))

(declare-fun m!861 () Bool)

(assert (=> b!670 m!861))

(declare-fun m!863 () Bool)

(assert (=> b!671 m!863))

(assert (=> b!672 m!619))

(declare-fun m!865 () Bool)

(assert (=> b!672 m!865))

(assert (=> b!300 d!343))

(declare-fun b!673 () Bool)

(declare-fun res!407 () Bool)

(declare-fun call!121 () Bool)

(assert (=> b!673 (= res!407 call!121)))

(declare-fun e!386 () Bool)

(assert (=> b!673 (=> (not res!407) (not e!386))))

(declare-fun d!345 () Bool)

(declare-fun res!405 () Bool)

(declare-fun e!387 () Bool)

(assert (=> d!345 (=> res!405 e!387)))

(assert (=> d!345 (= res!405 ((_ is Empty!3) (left!8 (left!8 (right!8 lt!2)))))))

(assert (=> d!345 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 lt!2)))) e!387)))

(declare-fun b!674 () Bool)

(declare-fun call!120 () Bool)

(assert (=> b!674 (= e!386 call!120)))

(declare-fun bm!120 () Bool)

(assert (=> bm!120 (= call!121 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (right!8 lt!2))))))))

(declare-fun bm!121 () Bool)

(assert (=> bm!121 (= call!120 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (right!8 lt!2))))))))

(declare-fun b!675 () Bool)

(declare-fun res!406 () Bool)

(assert (=> b!675 (= res!406 (isBlack!0 (right!8 (left!8 (left!8 (right!8 lt!2))))))))

(assert (=> b!675 (=> (not res!406) (not e!386))))

(declare-fun b!676 () Bool)

(declare-fun e!385 () Bool)

(assert (=> b!676 (= e!385 call!120)))

(declare-fun b!677 () Bool)

(declare-fun e!384 () Bool)

(assert (=> b!677 (= e!384 e!386)))

(declare-fun res!403 () Bool)

(assert (=> b!677 (= res!403 (isBlack!0 (left!8 (left!8 (left!8 (right!8 lt!2))))))))

(assert (=> b!677 (=> (not res!403) (not e!386))))

(declare-fun b!678 () Bool)

(assert (=> b!678 (= e!387 e!384)))

(declare-fun c!173 () Bool)

(assert (=> b!678 (= c!173 ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 lt!2))))))))

(declare-fun b!679 () Bool)

(assert (=> b!679 (= e!384 e!385)))

(declare-fun res!404 () Bool)

(assert (=> b!679 (= res!404 call!121)))

(assert (=> b!679 (=> (not res!404) (not e!385))))

(assert (= (and d!345 (not res!405)) b!678))

(assert (= (and b!678 c!173) b!679))

(assert (= (and b!678 (not c!173)) b!677))

(assert (= (and b!679 res!404) b!676))

(assert (= (and b!677 res!403) b!675))

(assert (= (and b!675 res!406) b!673))

(assert (= (and b!673 res!407) b!674))

(assert (= (or b!679 b!673) bm!120))

(assert (= (or b!676 b!674) bm!121))

(declare-fun m!867 () Bool)

(assert (=> bm!120 m!867))

(declare-fun m!869 () Bool)

(assert (=> bm!121 m!869))

(declare-fun m!871 () Bool)

(assert (=> b!675 m!871))

(declare-fun m!873 () Bool)

(assert (=> b!677 m!873))

(assert (=> bm!68 d!345))

(declare-fun b!680 () Bool)

(declare-fun res!412 () Bool)

(declare-fun call!123 () Bool)

(assert (=> b!680 (= res!412 call!123)))

(declare-fun e!390 () Bool)

(assert (=> b!680 (=> (not res!412) (not e!390))))

(declare-fun d!347 () Bool)

(declare-fun res!410 () Bool)

(declare-fun e!391 () Bool)

(assert (=> d!347 (=> res!410 e!391)))

(assert (=> d!347 (= res!410 ((_ is Empty!3) (right!8 (right!8 (left!8 lt!2)))))))

(assert (=> d!347 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 lt!2)))) e!391)))

(declare-fun b!681 () Bool)

(declare-fun call!122 () Bool)

(assert (=> b!681 (= e!390 call!122)))

(declare-fun bm!122 () Bool)

(assert (=> bm!122 (= call!123 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (left!8 lt!2))))))))

(declare-fun bm!123 () Bool)

(assert (=> bm!123 (= call!122 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (left!8 lt!2))))))))

(declare-fun b!682 () Bool)

(declare-fun res!411 () Bool)

(assert (=> b!682 (= res!411 (isBlack!0 (right!8 (right!8 (right!8 (left!8 lt!2))))))))

(assert (=> b!682 (=> (not res!411) (not e!390))))

(declare-fun b!683 () Bool)

(declare-fun e!389 () Bool)

(assert (=> b!683 (= e!389 call!122)))

(declare-fun b!684 () Bool)

(declare-fun e!388 () Bool)

(assert (=> b!684 (= e!388 e!390)))

(declare-fun res!408 () Bool)

(assert (=> b!684 (= res!408 (isBlack!0 (left!8 (right!8 (right!8 (left!8 lt!2))))))))

(assert (=> b!684 (=> (not res!408) (not e!390))))

(declare-fun b!685 () Bool)

(assert (=> b!685 (= e!391 e!388)))

(declare-fun c!174 () Bool)

(assert (=> b!685 (= c!174 ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 lt!2))))))))

(declare-fun b!686 () Bool)

(assert (=> b!686 (= e!388 e!389)))

(declare-fun res!409 () Bool)

(assert (=> b!686 (= res!409 call!123)))

(assert (=> b!686 (=> (not res!409) (not e!389))))

(assert (= (and d!347 (not res!410)) b!685))

(assert (= (and b!685 c!174) b!686))

(assert (= (and b!685 (not c!174)) b!684))

(assert (= (and b!686 res!409) b!683))

(assert (= (and b!684 res!408) b!682))

(assert (= (and b!682 res!411) b!680))

(assert (= (and b!680 res!412) b!681))

(assert (= (or b!686 b!680) bm!122))

(assert (= (or b!683 b!681) bm!123))

(declare-fun m!875 () Bool)

(assert (=> bm!122 m!875))

(declare-fun m!877 () Bool)

(assert (=> bm!123 m!877))

(declare-fun m!879 () Bool)

(assert (=> b!682 m!879))

(declare-fun m!881 () Bool)

(assert (=> b!684 m!881))

(assert (=> bm!51 d!347))

(declare-fun d!349 () Bool)

(assert (=> d!349 (= (isBlack!0 (left!8 (left!8 (right!8 lt!2)))) (or ((_ is Empty!3) (left!8 (left!8 (right!8 lt!2)))) ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 lt!2)))))))))

(assert (=> b!398 d!349))

(declare-fun d!351 () Bool)

(declare-fun res!413 () Bool)

(declare-fun e!392 () Bool)

(assert (=> d!351 (=> res!413 e!392)))

(assert (=> d!351 (= res!413 (not ((_ is Node!3) (right!8 lt!13))))))

(assert (=> d!351 (= (blackBalanced!0 (right!8 lt!13)) e!392)))

(declare-fun b!687 () Bool)

(declare-fun e!393 () Bool)

(assert (=> b!687 (= e!392 e!393)))

(declare-fun res!415 () Bool)

(assert (=> b!687 (=> (not res!415) (not e!393))))

(assert (=> b!687 (= res!415 (blackBalanced!0 (left!8 (right!8 lt!13))))))

(declare-fun b!688 () Bool)

(declare-fun res!414 () Bool)

(assert (=> b!688 (=> (not res!414) (not e!393))))

(assert (=> b!688 (= res!414 (blackBalanced!0 (right!8 (right!8 lt!13))))))

(declare-fun b!689 () Bool)

(assert (=> b!689 (= e!393 (= (blackHeight!0 (left!8 (right!8 lt!13))) (blackHeight!0 (right!8 (right!8 lt!13)))))))

(assert (= (and d!351 (not res!413)) b!687))

(assert (= (and b!687 res!415) b!688))

(assert (= (and b!688 res!414) b!689))

(declare-fun m!883 () Bool)

(assert (=> b!687 m!883))

(declare-fun m!885 () Bool)

(assert (=> b!688 m!885))

(declare-fun m!887 () Bool)

(assert (=> b!689 m!887))

(declare-fun m!889 () Bool)

(assert (=> b!689 m!889))

(assert (=> b!456 d!351))

(declare-fun b!690 () Bool)

(declare-fun res!420 () Bool)

(declare-fun call!125 () Bool)

(assert (=> b!690 (= res!420 call!125)))

(declare-fun e!396 () Bool)

(assert (=> b!690 (=> (not res!420) (not e!396))))

(declare-fun d!353 () Bool)

(declare-fun res!418 () Bool)

(declare-fun e!397 () Bool)

(assert (=> d!353 (=> res!418 e!397)))

(assert (=> d!353 (= res!418 ((_ is Empty!3) (left!8 (left!8 (right!8 t!78)))))))

(assert (=> d!353 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 t!78)))) e!397)))

(declare-fun b!691 () Bool)

(declare-fun call!124 () Bool)

(assert (=> b!691 (= e!396 call!124)))

(declare-fun bm!124 () Bool)

(assert (=> bm!124 (= call!125 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (right!8 t!78))))))))

(declare-fun bm!125 () Bool)

(assert (=> bm!125 (= call!124 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (right!8 t!78))))))))

(declare-fun b!692 () Bool)

(declare-fun res!419 () Bool)

(assert (=> b!692 (= res!419 (isBlack!0 (right!8 (left!8 (left!8 (right!8 t!78))))))))

(assert (=> b!692 (=> (not res!419) (not e!396))))

(declare-fun b!693 () Bool)

(declare-fun e!395 () Bool)

(assert (=> b!693 (= e!395 call!124)))

(declare-fun b!694 () Bool)

(declare-fun e!394 () Bool)

(assert (=> b!694 (= e!394 e!396)))

(declare-fun res!416 () Bool)

(assert (=> b!694 (= res!416 (isBlack!0 (left!8 (left!8 (left!8 (right!8 t!78))))))))

(assert (=> b!694 (=> (not res!416) (not e!396))))

(declare-fun b!695 () Bool)

(assert (=> b!695 (= e!397 e!394)))

(declare-fun c!175 () Bool)

(assert (=> b!695 (= c!175 ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 t!78))))))))

(declare-fun b!696 () Bool)

(assert (=> b!696 (= e!394 e!395)))

(declare-fun res!417 () Bool)

(assert (=> b!696 (= res!417 call!125)))

(assert (=> b!696 (=> (not res!417) (not e!395))))

(assert (= (and d!353 (not res!418)) b!695))

(assert (= (and b!695 c!175) b!696))

(assert (= (and b!695 (not c!175)) b!694))

(assert (= (and b!696 res!417) b!693))

(assert (= (and b!694 res!416) b!692))

(assert (= (and b!692 res!419) b!690))

(assert (= (and b!690 res!420) b!691))

(assert (= (or b!696 b!690) bm!124))

(assert (= (or b!693 b!691) bm!125))

(declare-fun m!891 () Bool)

(assert (=> bm!124 m!891))

(declare-fun m!893 () Bool)

(assert (=> bm!125 m!893))

(declare-fun m!895 () Bool)

(assert (=> b!692 m!895))

(declare-fun m!897 () Bool)

(assert (=> b!694 m!897))

(assert (=> bm!60 d!353))

(declare-fun b!697 () Bool)

(declare-fun res!425 () Bool)

(declare-fun call!127 () Bool)

(assert (=> b!697 (= res!425 call!127)))

(declare-fun e!400 () Bool)

(assert (=> b!697 (=> (not res!425) (not e!400))))

(declare-fun d!355 () Bool)

(declare-fun res!423 () Bool)

(declare-fun e!401 () Bool)

(assert (=> d!355 (=> res!423 e!401)))

(assert (=> d!355 (= res!423 ((_ is Empty!3) (left!8 (right!8 (left!8 t!78)))))))

(assert (=> d!355 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 t!78)))) e!401)))

(declare-fun b!698 () Bool)

(declare-fun call!126 () Bool)

(assert (=> b!698 (= e!400 call!126)))

(declare-fun bm!126 () Bool)

(assert (=> bm!126 (= call!127 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (left!8 t!78))))))))

(declare-fun bm!127 () Bool)

(assert (=> bm!127 (= call!126 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (left!8 t!78))))))))

(declare-fun b!699 () Bool)

(declare-fun res!424 () Bool)

(assert (=> b!699 (= res!424 (isBlack!0 (right!8 (left!8 (right!8 (left!8 t!78))))))))

(assert (=> b!699 (=> (not res!424) (not e!400))))

(declare-fun b!700 () Bool)

(declare-fun e!399 () Bool)

(assert (=> b!700 (= e!399 call!126)))

(declare-fun b!701 () Bool)

(declare-fun e!398 () Bool)

(assert (=> b!701 (= e!398 e!400)))

(declare-fun res!421 () Bool)

(assert (=> b!701 (= res!421 (isBlack!0 (left!8 (left!8 (right!8 (left!8 t!78))))))))

(assert (=> b!701 (=> (not res!421) (not e!400))))

(declare-fun b!702 () Bool)

(assert (=> b!702 (= e!401 e!398)))

(declare-fun c!176 () Bool)

(assert (=> b!702 (= c!176 ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 t!78))))))))

(declare-fun b!703 () Bool)

(assert (=> b!703 (= e!398 e!399)))

(declare-fun res!422 () Bool)

(assert (=> b!703 (= res!422 call!127)))

(assert (=> b!703 (=> (not res!422) (not e!399))))

(assert (= (and d!355 (not res!423)) b!702))

(assert (= (and b!702 c!176) b!703))

(assert (= (and b!702 (not c!176)) b!701))

(assert (= (and b!703 res!422) b!700))

(assert (= (and b!701 res!421) b!699))

(assert (= (and b!699 res!424) b!697))

(assert (= (and b!697 res!425) b!698))

(assert (= (or b!703 b!697) bm!126))

(assert (= (or b!700 b!698) bm!127))

(declare-fun m!899 () Bool)

(assert (=> bm!126 m!899))

(declare-fun m!901 () Bool)

(assert (=> bm!127 m!901))

(declare-fun m!903 () Bool)

(assert (=> b!699 m!903))

(declare-fun m!905 () Bool)

(assert (=> b!701 m!905))

(assert (=> bm!74 d!355))

(declare-fun d!357 () Bool)

(declare-fun res!426 () Bool)

(declare-fun e!402 () Bool)

(assert (=> d!357 (=> res!426 e!402)))

(assert (=> d!357 (= res!426 ((_ is Empty!3) lt!19))))

(assert (=> d!357 (= (redDescHaveBlackChildren!0 lt!19) e!402)))

(declare-fun b!704 () Bool)

(declare-fun e!403 () Bool)

(assert (=> b!704 (= e!402 e!403)))

(declare-fun res!427 () Bool)

(assert (=> b!704 (=> (not res!427) (not e!403))))

(assert (=> b!704 (= res!427 (redNodesHaveBlackChildren!0 (left!8 lt!19)))))

(declare-fun b!705 () Bool)

(assert (=> b!705 (= e!403 (redNodesHaveBlackChildren!0 (right!8 lt!19)))))

(assert (= (and d!357 (not res!426)) b!704))

(assert (= (and b!704 res!427) b!705))

(declare-fun m!907 () Bool)

(assert (=> b!704 m!907))

(declare-fun m!909 () Bool)

(assert (=> b!705 m!909))

(assert (=> b!364 d!357))

(declare-fun d!359 () Bool)

(declare-fun c!177 () Bool)

(assert (=> d!359 (= c!177 ((_ is Empty!3) lt!16))))

(declare-fun e!404 () (InoxSet (_ BitVec 32)))

(assert (=> d!359 (= (content!0 lt!16) e!404)))

(declare-fun b!706 () Bool)

(assert (=> b!706 (= e!404 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!707 () Bool)

(assert (=> b!707 (= e!404 ((_ map or) ((_ map or) (content!0 (left!8 lt!16)) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 lt!16) true)) (content!0 (right!8 lt!16))))))

(assert (= (and d!359 c!177) b!706))

(assert (= (and d!359 (not c!177)) b!707))

(declare-fun m!911 () Bool)

(assert (=> b!707 m!911))

(declare-fun m!913 () Bool)

(assert (=> b!707 m!913))

(declare-fun m!915 () Bool)

(assert (=> b!707 m!915))

(assert (=> d!121 d!359))

(declare-fun c!178 () Bool)

(declare-fun d!361 () Bool)

(assert (=> d!361 (= c!178 ((_ is Empty!3) (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))))))

(declare-fun e!405 () (InoxSet (_ BitVec 32)))

(assert (=> d!361 (= (content!0 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) e!405)))

(declare-fun b!708 () Bool)

(assert (=> b!708 (= e!405 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!709 () Bool)

(assert (=> b!709 (= e!405 ((_ map or) ((_ map or) (content!0 (left!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))) true)) (content!0 (right!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))))))))

(assert (= (and d!361 c!178) b!708))

(assert (= (and d!361 (not c!178)) b!709))

(declare-fun m!917 () Bool)

(assert (=> b!709 m!917))

(declare-fun m!919 () Bool)

(assert (=> b!709 m!919))

(declare-fun m!921 () Bool)

(assert (=> b!709 m!921))

(assert (=> d!121 d!361))

(declare-fun d!363 () Bool)

(declare-fun c!179 () Bool)

(assert (=> d!363 (= c!179 ((_ is Empty!3) (left!8 (right!8 lt!5))))))

(declare-fun e!406 () (InoxSet (_ BitVec 32)))

(assert (=> d!363 (= (content!0 (left!8 (right!8 lt!5))) e!406)))

(declare-fun b!710 () Bool)

(assert (=> b!710 (= e!406 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!711 () Bool)

(assert (=> b!711 (= e!406 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 lt!5)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 lt!5))) true)) (content!0 (right!8 (left!8 (right!8 lt!5))))))))

(assert (= (and d!363 c!179) b!710))

(assert (= (and d!363 (not c!179)) b!711))

(declare-fun m!923 () Bool)

(assert (=> b!711 m!923))

(declare-fun m!925 () Bool)

(assert (=> b!711 m!925))

(declare-fun m!927 () Bool)

(assert (=> b!711 m!927))

(assert (=> b!352 d!363))

(declare-fun d!365 () Bool)

(declare-fun c!180 () Bool)

(assert (=> d!365 (= c!180 ((_ is Empty!3) (right!8 (right!8 lt!5))))))

(declare-fun e!407 () (InoxSet (_ BitVec 32)))

(assert (=> d!365 (= (content!0 (right!8 (right!8 lt!5))) e!407)))

(declare-fun b!712 () Bool)

(assert (=> b!712 (= e!407 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!713 () Bool)

(assert (=> b!713 (= e!407 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 lt!5)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 lt!5))) true)) (content!0 (right!8 (right!8 (right!8 lt!5))))))))

(assert (= (and d!365 c!180) b!712))

(assert (= (and d!365 (not c!180)) b!713))

(declare-fun m!929 () Bool)

(assert (=> b!713 m!929))

(declare-fun m!931 () Bool)

(assert (=> b!713 m!931))

(declare-fun m!933 () Bool)

(assert (=> b!713 m!933))

(assert (=> b!352 d!365))

(declare-fun d!367 () Bool)

(declare-fun lt!31 () Int)

(assert (=> d!367 (>= lt!31 0)))

(declare-fun e!408 () Int)

(assert (=> d!367 (= lt!31 e!408)))

(declare-fun c!181 () Bool)

(assert (=> d!367 (= c!181 ((_ is Empty!3) lt!19))))

(assert (=> d!367 (= (size!0 lt!19) lt!31)))

(declare-fun b!714 () Bool)

(assert (=> b!714 (= e!408 0)))

(declare-fun b!715 () Bool)

(assert (=> b!715 (= e!408 (+ (size!0 (left!8 lt!19)) 1 (size!0 (right!8 lt!19))))))

(assert (= (and d!367 c!181) b!714))

(assert (= (and d!367 (not c!181)) b!715))

(declare-fun m!935 () Bool)

(assert (=> b!715 m!935))

(declare-fun m!937 () Bool)

(assert (=> b!715 m!937))

(assert (=> b!358 d!367))

(declare-fun d!369 () Bool)

(declare-fun lt!32 () Int)

(assert (=> d!369 (>= lt!32 0)))

(declare-fun e!409 () Int)

(assert (=> d!369 (= lt!32 e!409)))

(declare-fun c!182 () Bool)

(assert (=> d!369 (= c!182 ((_ is Empty!3) (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!369 (= (size!0 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) lt!32)))

(declare-fun b!716 () Bool)

(assert (=> b!716 (= e!409 0)))

(declare-fun b!717 () Bool)

(assert (=> b!717 (= e!409 (+ (size!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) 1 (size!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!369 c!182) b!716))

(assert (= (and d!369 (not c!182)) b!717))

(declare-fun m!939 () Bool)

(assert (=> b!717 m!939))

(declare-fun m!941 () Bool)

(assert (=> b!717 m!941))

(assert (=> b!358 d!369))

(declare-fun d!371 () Bool)

(declare-fun lt!33 () Int)

(assert (=> d!371 (>= lt!33 0)))

(declare-fun e!410 () Int)

(assert (=> d!371 (= lt!33 e!410)))

(declare-fun c!183 () Bool)

(assert (=> d!371 (= c!183 ((_ is Empty!3) (left!8 lt!13)))))

(assert (=> d!371 (= (size!0 (left!8 lt!13)) lt!33)))

(declare-fun b!718 () Bool)

(assert (=> b!718 (= e!410 0)))

(declare-fun b!719 () Bool)

(assert (=> b!719 (= e!410 (+ (size!0 (left!8 (left!8 lt!13))) 1 (size!0 (right!8 (left!8 lt!13)))))))

(assert (= (and d!371 c!183) b!718))

(assert (= (and d!371 (not c!183)) b!719))

(declare-fun m!943 () Bool)

(assert (=> b!719 m!943))

(declare-fun m!945 () Bool)

(assert (=> b!719 m!945))

(assert (=> b!313 d!371))

(declare-fun d!373 () Bool)

(declare-fun lt!34 () Int)

(assert (=> d!373 (>= lt!34 0)))

(declare-fun e!411 () Int)

(assert (=> d!373 (= lt!34 e!411)))

(declare-fun c!184 () Bool)

(assert (=> d!373 (= c!184 ((_ is Empty!3) (right!8 lt!13)))))

(assert (=> d!373 (= (size!0 (right!8 lt!13)) lt!34)))

(declare-fun b!720 () Bool)

(assert (=> b!720 (= e!411 0)))

(declare-fun b!721 () Bool)

(assert (=> b!721 (= e!411 (+ (size!0 (left!8 (right!8 lt!13))) 1 (size!0 (right!8 (right!8 lt!13)))))))

(assert (= (and d!373 c!184) b!720))

(assert (= (and d!373 (not c!184)) b!721))

(declare-fun m!947 () Bool)

(assert (=> b!721 m!947))

(declare-fun m!949 () Bool)

(assert (=> b!721 m!949))

(assert (=> b!313 d!373))

(declare-fun d!375 () Bool)

(declare-fun res!428 () Bool)

(declare-fun e!412 () Bool)

(assert (=> d!375 (=> res!428 e!412)))

(assert (=> d!375 (= res!428 (not ((_ is Node!3) (left!8 (left!8 lt!5)))))))

(assert (=> d!375 (= (blackBalanced!0 (left!8 (left!8 lt!5))) e!412)))

(declare-fun b!722 () Bool)

(declare-fun e!413 () Bool)

(assert (=> b!722 (= e!412 e!413)))

(declare-fun res!430 () Bool)

(assert (=> b!722 (=> (not res!430) (not e!413))))

(assert (=> b!722 (= res!430 (blackBalanced!0 (left!8 (left!8 (left!8 lt!5)))))))

(declare-fun b!723 () Bool)

(declare-fun res!429 () Bool)

(assert (=> b!723 (=> (not res!429) (not e!413))))

(assert (=> b!723 (= res!429 (blackBalanced!0 (right!8 (left!8 (left!8 lt!5)))))))

(declare-fun b!724 () Bool)

(assert (=> b!724 (= e!413 (= (blackHeight!0 (left!8 (left!8 (left!8 lt!5)))) (blackHeight!0 (right!8 (left!8 (left!8 lt!5))))))))

(assert (= (and d!375 (not res!428)) b!722))

(assert (= (and b!722 res!430) b!723))

(assert (= (and b!723 res!429) b!724))

(declare-fun m!951 () Bool)

(assert (=> b!722 m!951))

(declare-fun m!953 () Bool)

(assert (=> b!723 m!953))

(assert (=> b!724 m!623))

(declare-fun m!955 () Bool)

(assert (=> b!724 m!955))

(assert (=> b!318 d!375))

(declare-fun d!377 () Bool)

(declare-fun res!431 () Bool)

(declare-fun e!414 () Bool)

(assert (=> d!377 (=> res!431 e!414)))

(assert (=> d!377 (= res!431 (not ((_ is Node!3) lt!19)))))

(assert (=> d!377 (= (blackBalanced!0 lt!19) e!414)))

(declare-fun b!725 () Bool)

(declare-fun e!415 () Bool)

(assert (=> b!725 (= e!414 e!415)))

(declare-fun res!433 () Bool)

(assert (=> b!725 (=> (not res!433) (not e!415))))

(assert (=> b!725 (= res!433 (blackBalanced!0 (left!8 lt!19)))))

(declare-fun b!726 () Bool)

(declare-fun res!432 () Bool)

(assert (=> b!726 (=> (not res!432) (not e!415))))

(assert (=> b!726 (= res!432 (blackBalanced!0 (right!8 lt!19)))))

(declare-fun b!727 () Bool)

(assert (=> b!727 (= e!415 (= (blackHeight!0 (left!8 lt!19)) (blackHeight!0 (right!8 lt!19))))))

(assert (= (and d!377 (not res!431)) b!725))

(assert (= (and b!725 res!433) b!726))

(assert (= (and b!726 res!432) b!727))

(declare-fun m!957 () Bool)

(assert (=> b!725 m!957))

(declare-fun m!959 () Bool)

(assert (=> b!726 m!959))

(declare-fun m!961 () Bool)

(assert (=> b!727 m!961))

(declare-fun m!963 () Bool)

(assert (=> b!727 m!963))

(assert (=> b!361 d!377))

(assert (=> bm!56 d!235))

(declare-fun d!379 () Bool)

(declare-fun c!185 () Bool)

(assert (=> d!379 (= c!185 ((_ is Empty!3) (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(declare-fun e!416 () (InoxSet (_ BitVec 32)))

(assert (=> d!379 (= (content!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) e!416)))

(declare-fun b!728 () Bool)

(assert (=> b!728 (= e!416 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!729 () Bool)

(assert (=> b!729 (= e!416 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) true)) (content!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (= (and d!379 c!185) b!728))

(assert (= (and d!379 (not c!185)) b!729))

(declare-fun m!965 () Bool)

(assert (=> b!729 m!965))

(declare-fun m!967 () Bool)

(assert (=> b!729 m!967))

(declare-fun m!969 () Bool)

(assert (=> b!729 m!969))

(assert (=> b!433 d!379))

(declare-fun d!381 () Bool)

(declare-fun c!186 () Bool)

(assert (=> d!381 (= c!186 ((_ is Empty!3) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))

(declare-fun e!417 () (InoxSet (_ BitVec 32)))

(assert (=> d!381 (= (content!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) e!417)))

(declare-fun b!730 () Bool)

(assert (=> b!730 (= e!417 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!731 () Bool)

(assert (=> b!731 (= e!417 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) true)) (content!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (= (and d!381 c!186) b!730))

(assert (= (and d!381 (not c!186)) b!731))

(declare-fun m!971 () Bool)

(assert (=> b!731 m!971))

(declare-fun m!973 () Bool)

(assert (=> b!731 m!973))

(declare-fun m!975 () Bool)

(assert (=> b!731 m!975))

(assert (=> b!433 d!381))

(declare-fun d!383 () Bool)

(assert (=> d!383 (= (isBlack!0 (right!8 (left!8 lt!5))) (or ((_ is Empty!3) (right!8 (left!8 lt!5))) ((_ is Black!3) (color!6 (right!8 (left!8 lt!5))))))))

(assert (=> b!389 d!383))

(declare-fun d!385 () Bool)

(assert (=> d!385 (= (isBlack!0 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (or ((_ is Empty!3) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) ((_ is Black!3) (color!6 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!436 d!385))

(declare-fun d!387 () Bool)

(declare-fun lt!35 () Int)

(assert (=> d!387 (>= lt!35 0)))

(declare-fun e!418 () Int)

(assert (=> d!387 (= lt!35 e!418)))

(declare-fun c!187 () Bool)

(assert (=> d!387 (= c!187 ((_ is Empty!3) (left!8 (right!8 t!78))))))

(assert (=> d!387 (= (size!0 (left!8 (right!8 t!78))) lt!35)))

(declare-fun b!732 () Bool)

(assert (=> b!732 (= e!418 0)))

(declare-fun b!733 () Bool)

(assert (=> b!733 (= e!418 (+ (size!0 (left!8 (left!8 (right!8 t!78)))) 1 (size!0 (right!8 (left!8 (right!8 t!78))))))))

(assert (= (and d!387 c!187) b!732))

(assert (= (and d!387 (not c!187)) b!733))

(declare-fun m!977 () Bool)

(assert (=> b!733 m!977))

(declare-fun m!979 () Bool)

(assert (=> b!733 m!979))

(assert (=> b!344 d!387))

(declare-fun d!389 () Bool)

(declare-fun lt!36 () Int)

(assert (=> d!389 (>= lt!36 0)))

(declare-fun e!419 () Int)

(assert (=> d!389 (= lt!36 e!419)))

(declare-fun c!188 () Bool)

(assert (=> d!389 (= c!188 ((_ is Empty!3) (right!8 (right!8 t!78))))))

(assert (=> d!389 (= (size!0 (right!8 (right!8 t!78))) lt!36)))

(declare-fun b!734 () Bool)

(assert (=> b!734 (= e!419 0)))

(declare-fun b!735 () Bool)

(assert (=> b!735 (= e!419 (+ (size!0 (left!8 (right!8 (right!8 t!78)))) 1 (size!0 (right!8 (right!8 (right!8 t!78))))))))

(assert (= (and d!389 c!188) b!734))

(assert (= (and d!389 (not c!188)) b!735))

(declare-fun m!981 () Bool)

(assert (=> b!735 m!981))

(declare-fun m!983 () Bool)

(assert (=> b!735 m!983))

(assert (=> b!344 d!389))

(declare-fun d!391 () Bool)

(declare-fun c!189 () Bool)

(assert (=> d!391 (= c!189 ((_ is Empty!3) (left!8 lt!13)))))

(declare-fun e!420 () (_ BitVec 32))

(assert (=> d!391 (= (blackHeight!0 (left!8 lt!13)) e!420)))

(declare-fun b!736 () Bool)

(declare-fun e!421 () (_ BitVec 32))

(declare-fun call!128 () (_ BitVec 32))

(assert (=> b!736 (= e!421 (bvadd call!128 #b00000000000000000000000000000001))))

(declare-fun bm!128 () Bool)

(assert (=> bm!128 (= call!128 (blackHeight!0 (left!8 (left!8 lt!13))))))

(declare-fun b!737 () Bool)

(assert (=> b!737 (= e!421 call!128)))

(declare-fun b!738 () Bool)

(assert (=> b!738 (= e!420 e!421)))

(declare-fun c!190 () Bool)

(assert (=> b!738 (= c!190 ((_ is Black!3) (color!6 (left!8 lt!13))))))

(declare-fun b!739 () Bool)

(assert (=> b!739 (= e!420 #b00000000000000000000000000000001)))

(assert (= (and d!391 c!189) b!739))

(assert (= (and d!391 (not c!189)) b!738))

(assert (= (and b!738 c!190) b!736))

(assert (= (and b!738 (not c!190)) b!737))

(assert (= (or b!736 b!737) bm!128))

(assert (=> bm!128 m!793))

(assert (=> b!457 d!391))

(declare-fun d!393 () Bool)

(declare-fun c!191 () Bool)

(assert (=> d!393 (= c!191 ((_ is Empty!3) (right!8 lt!13)))))

(declare-fun e!422 () (_ BitVec 32))

(assert (=> d!393 (= (blackHeight!0 (right!8 lt!13)) e!422)))

(declare-fun b!740 () Bool)

(declare-fun e!423 () (_ BitVec 32))

(declare-fun call!129 () (_ BitVec 32))

(assert (=> b!740 (= e!423 (bvadd call!129 #b00000000000000000000000000000001))))

(declare-fun bm!129 () Bool)

(assert (=> bm!129 (= call!129 (blackHeight!0 (left!8 (right!8 lt!13))))))

(declare-fun b!741 () Bool)

(assert (=> b!741 (= e!423 call!129)))

(declare-fun b!742 () Bool)

(assert (=> b!742 (= e!422 e!423)))

(declare-fun c!192 () Bool)

(assert (=> b!742 (= c!192 ((_ is Black!3) (color!6 (right!8 lt!13))))))

(declare-fun b!743 () Bool)

(assert (=> b!743 (= e!422 #b00000000000000000000000000000001)))

(assert (= (and d!393 c!191) b!743))

(assert (= (and d!393 (not c!191)) b!742))

(assert (= (and b!742 c!192) b!740))

(assert (= (and b!742 (not c!192)) b!741))

(assert (= (or b!740 b!741) bm!129))

(assert (=> bm!129 m!887))

(assert (=> b!457 d!393))

(declare-fun d!395 () Bool)

(declare-fun c!193 () Bool)

(assert (=> d!395 (= c!193 ((_ is Empty!3) (left!8 (left!8 lt!5))))))

(declare-fun e!424 () (InoxSet (_ BitVec 32)))

(assert (=> d!395 (= (content!0 (left!8 (left!8 lt!5))) e!424)))

(declare-fun b!744 () Bool)

(assert (=> b!744 (= e!424 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!745 () Bool)

(assert (=> b!745 (= e!424 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 lt!5)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 lt!5))) true)) (content!0 (right!8 (left!8 (left!8 lt!5))))))))

(assert (= (and d!395 c!193) b!744))

(assert (= (and d!395 (not c!193)) b!745))

(declare-fun m!985 () Bool)

(assert (=> b!745 m!985))

(declare-fun m!987 () Bool)

(assert (=> b!745 m!987))

(declare-fun m!989 () Bool)

(assert (=> b!745 m!989))

(assert (=> b!350 d!395))

(declare-fun d!397 () Bool)

(declare-fun c!194 () Bool)

(assert (=> d!397 (= c!194 ((_ is Empty!3) (right!8 (left!8 lt!5))))))

(declare-fun e!425 () (InoxSet (_ BitVec 32)))

(assert (=> d!397 (= (content!0 (right!8 (left!8 lt!5))) e!425)))

(declare-fun b!746 () Bool)

(assert (=> b!746 (= e!425 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!747 () Bool)

(assert (=> b!747 (= e!425 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 lt!5)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 lt!5))) true)) (content!0 (right!8 (right!8 (left!8 lt!5))))))))

(assert (= (and d!397 c!194) b!746))

(assert (= (and d!397 (not c!194)) b!747))

(declare-fun m!991 () Bool)

(assert (=> b!747 m!991))

(declare-fun m!993 () Bool)

(assert (=> b!747 m!993))

(declare-fun m!995 () Bool)

(assert (=> b!747 m!995))

(assert (=> b!350 d!397))

(declare-fun b!748 () Bool)

(declare-fun res!438 () Bool)

(declare-fun call!131 () Bool)

(assert (=> b!748 (= res!438 call!131)))

(declare-fun e!428 () Bool)

(assert (=> b!748 (=> (not res!438) (not e!428))))

(declare-fun d!399 () Bool)

(declare-fun res!436 () Bool)

(declare-fun e!429 () Bool)

(assert (=> d!399 (=> res!436 e!429)))

(assert (=> d!399 (= res!436 ((_ is Empty!3) (left!8 lt!13)))))

(assert (=> d!399 (= (redNodesHaveBlackChildren!0 (left!8 lt!13)) e!429)))

(declare-fun b!749 () Bool)

(declare-fun call!130 () Bool)

(assert (=> b!749 (= e!428 call!130)))

(declare-fun bm!130 () Bool)

(assert (=> bm!130 (= call!131 (redNodesHaveBlackChildren!0 (left!8 (left!8 lt!13))))))

(declare-fun bm!131 () Bool)

(assert (=> bm!131 (= call!130 (redNodesHaveBlackChildren!0 (right!8 (left!8 lt!13))))))

(declare-fun b!750 () Bool)

(declare-fun res!437 () Bool)

(assert (=> b!750 (= res!437 (isBlack!0 (right!8 (left!8 lt!13))))))

(assert (=> b!750 (=> (not res!437) (not e!428))))

(declare-fun b!751 () Bool)

(declare-fun e!427 () Bool)

(assert (=> b!751 (= e!427 call!130)))

(declare-fun b!752 () Bool)

(declare-fun e!426 () Bool)

(assert (=> b!752 (= e!426 e!428)))

(declare-fun res!434 () Bool)

(assert (=> b!752 (= res!434 (isBlack!0 (left!8 (left!8 lt!13))))))

(assert (=> b!752 (=> (not res!434) (not e!428))))

(declare-fun b!753 () Bool)

(assert (=> b!753 (= e!429 e!426)))

(declare-fun c!195 () Bool)

(assert (=> b!753 (= c!195 ((_ is Black!3) (color!6 (left!8 lt!13))))))

(declare-fun b!754 () Bool)

(assert (=> b!754 (= e!426 e!427)))

(declare-fun res!435 () Bool)

(assert (=> b!754 (= res!435 call!131)))

(assert (=> b!754 (=> (not res!435) (not e!427))))

(assert (= (and d!399 (not res!436)) b!753))

(assert (= (and b!753 c!195) b!754))

(assert (= (and b!753 (not c!195)) b!752))

(assert (= (and b!754 res!435) b!751))

(assert (= (and b!752 res!434) b!750))

(assert (= (and b!750 res!437) b!748))

(assert (= (and b!748 res!438) b!749))

(assert (= (or b!754 b!748) bm!130))

(assert (= (or b!751 b!749) bm!131))

(declare-fun m!997 () Bool)

(assert (=> bm!130 m!997))

(declare-fun m!999 () Bool)

(assert (=> bm!131 m!999))

(declare-fun m!1001 () Bool)

(assert (=> b!750 m!1001))

(declare-fun m!1003 () Bool)

(assert (=> b!752 m!1003))

(assert (=> b!353 d!399))

(declare-fun d!401 () Bool)

(assert (=> d!401 (= (isBlack!0 (right!8 (right!8 (left!8 lt!2)))) (or ((_ is Empty!3) (right!8 (right!8 (left!8 lt!2)))) ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 lt!2)))))))))

(assert (=> b!295 d!401))

(declare-fun d!403 () Bool)

(declare-fun res!439 () Bool)

(declare-fun e!430 () Bool)

(assert (=> d!403 (=> res!439 e!430)))

(assert (=> d!403 (= res!439 (not ((_ is Node!3) (right!8 (left!8 t!78)))))))

(assert (=> d!403 (= (blackBalanced!0 (right!8 (left!8 t!78))) e!430)))

(declare-fun b!755 () Bool)

(declare-fun e!431 () Bool)

(assert (=> b!755 (= e!430 e!431)))

(declare-fun res!441 () Bool)

(assert (=> b!755 (=> (not res!441) (not e!431))))

(assert (=> b!755 (= res!441 (blackBalanced!0 (left!8 (right!8 (left!8 t!78)))))))

(declare-fun b!756 () Bool)

(declare-fun res!440 () Bool)

(assert (=> b!756 (=> (not res!440) (not e!431))))

(assert (=> b!756 (= res!440 (blackBalanced!0 (right!8 (right!8 (left!8 t!78)))))))

(declare-fun b!757 () Bool)

(assert (=> b!757 (= e!431 (= (blackHeight!0 (left!8 (right!8 (left!8 t!78)))) (blackHeight!0 (right!8 (right!8 (left!8 t!78))))))))

(assert (= (and d!403 (not res!439)) b!755))

(assert (= (and b!755 res!441) b!756))

(assert (= (and b!756 res!440) b!757))

(declare-fun m!1005 () Bool)

(assert (=> b!755 m!1005))

(declare-fun m!1007 () Bool)

(assert (=> b!756 m!1007))

(assert (=> b!757 m!621))

(declare-fun m!1009 () Bool)

(assert (=> b!757 m!1009))

(assert (=> b!301 d!403))

(declare-fun d!405 () Bool)

(assert (=> d!405 (= (isBlack!0 (right!8 (right!8 (right!8 lt!2)))) (or ((_ is Empty!3) (right!8 (right!8 (right!8 lt!2)))) ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 lt!2)))))))))

(assert (=> b!446 d!405))

(declare-fun b!758 () Bool)

(declare-fun res!446 () Bool)

(declare-fun call!133 () Bool)

(assert (=> b!758 (= res!446 call!133)))

(declare-fun e!434 () Bool)

(assert (=> b!758 (=> (not res!446) (not e!434))))

(declare-fun d!407 () Bool)

(declare-fun res!444 () Bool)

(declare-fun e!435 () Bool)

(assert (=> d!407 (=> res!444 e!435)))

(assert (=> d!407 (= res!444 ((_ is Empty!3) (right!8 (left!8 (right!8 lt!2)))))))

(assert (=> d!407 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 lt!2)))) e!435)))

(declare-fun b!759 () Bool)

(declare-fun call!132 () Bool)

(assert (=> b!759 (= e!434 call!132)))

(declare-fun bm!132 () Bool)

(assert (=> bm!132 (= call!133 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (right!8 lt!2))))))))

(declare-fun bm!133 () Bool)

(assert (=> bm!133 (= call!132 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (right!8 lt!2))))))))

(declare-fun b!760 () Bool)

(declare-fun res!445 () Bool)

(assert (=> b!760 (= res!445 (isBlack!0 (right!8 (right!8 (left!8 (right!8 lt!2))))))))

(assert (=> b!760 (=> (not res!445) (not e!434))))

(declare-fun b!761 () Bool)

(declare-fun e!433 () Bool)

(assert (=> b!761 (= e!433 call!132)))

(declare-fun b!762 () Bool)

(declare-fun e!432 () Bool)

(assert (=> b!762 (= e!432 e!434)))

(declare-fun res!442 () Bool)

(assert (=> b!762 (= res!442 (isBlack!0 (left!8 (right!8 (left!8 (right!8 lt!2))))))))

(assert (=> b!762 (=> (not res!442) (not e!434))))

(declare-fun b!763 () Bool)

(assert (=> b!763 (= e!435 e!432)))

(declare-fun c!196 () Bool)

(assert (=> b!763 (= c!196 ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 lt!2))))))))

(declare-fun b!764 () Bool)

(assert (=> b!764 (= e!432 e!433)))

(declare-fun res!443 () Bool)

(assert (=> b!764 (= res!443 call!133)))

(assert (=> b!764 (=> (not res!443) (not e!433))))

(assert (= (and d!407 (not res!444)) b!763))

(assert (= (and b!763 c!196) b!764))

(assert (= (and b!763 (not c!196)) b!762))

(assert (= (and b!764 res!443) b!761))

(assert (= (and b!762 res!442) b!760))

(assert (= (and b!760 res!445) b!758))

(assert (= (and b!758 res!446) b!759))

(assert (= (or b!764 b!758) bm!132))

(assert (= (or b!761 b!759) bm!133))

(declare-fun m!1011 () Bool)

(assert (=> bm!132 m!1011))

(declare-fun m!1013 () Bool)

(assert (=> bm!133 m!1013))

(declare-fun m!1015 () Bool)

(assert (=> b!760 m!1015))

(declare-fun m!1017 () Bool)

(assert (=> b!762 m!1017))

(assert (=> bm!69 d!407))

(declare-fun d!409 () Bool)

(declare-fun res!447 () Bool)

(declare-fun e!436 () Bool)

(assert (=> d!409 (=> res!447 e!436)))

(assert (=> d!409 (= res!447 (not ((_ is Node!3) (left!8 (right!8 lt!5)))))))

(assert (=> d!409 (= (blackBalanced!0 (left!8 (right!8 lt!5))) e!436)))

(declare-fun b!765 () Bool)

(declare-fun e!437 () Bool)

(assert (=> b!765 (= e!436 e!437)))

(declare-fun res!449 () Bool)

(assert (=> b!765 (=> (not res!449) (not e!437))))

(assert (=> b!765 (= res!449 (blackBalanced!0 (left!8 (left!8 (right!8 lt!5)))))))

(declare-fun b!766 () Bool)

(declare-fun res!448 () Bool)

(assert (=> b!766 (=> (not res!448) (not e!437))))

(assert (=> b!766 (= res!448 (blackBalanced!0 (right!8 (left!8 (right!8 lt!5)))))))

(declare-fun b!767 () Bool)

(assert (=> b!767 (= e!437 (= (blackHeight!0 (left!8 (left!8 (right!8 lt!5)))) (blackHeight!0 (right!8 (left!8 (right!8 lt!5))))))))

(assert (= (and d!409 (not res!447)) b!765))

(assert (= (and b!765 res!449) b!766))

(assert (= (and b!766 res!448) b!767))

(declare-fun m!1019 () Bool)

(assert (=> b!765 m!1019))

(declare-fun m!1021 () Bool)

(assert (=> b!766 m!1021))

(assert (=> b!767 m!739))

(declare-fun m!1023 () Bool)

(assert (=> b!767 m!1023))

(assert (=> b!423 d!409))

(declare-fun b!768 () Bool)

(declare-fun res!454 () Bool)

(declare-fun call!135 () Bool)

(assert (=> b!768 (= res!454 call!135)))

(declare-fun e!440 () Bool)

(assert (=> b!768 (=> (not res!454) (not e!440))))

(declare-fun d!411 () Bool)

(declare-fun res!452 () Bool)

(declare-fun e!441 () Bool)

(assert (=> d!411 (=> res!452 e!441)))

(assert (=> d!411 (= res!452 ((_ is Empty!3) (right!8 (left!8 (right!8 t!78)))))))

(assert (=> d!411 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 t!78)))) e!441)))

(declare-fun b!769 () Bool)

(declare-fun call!134 () Bool)

(assert (=> b!769 (= e!440 call!134)))

(declare-fun bm!134 () Bool)

(assert (=> bm!134 (= call!135 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (right!8 t!78))))))))

(declare-fun bm!135 () Bool)

(assert (=> bm!135 (= call!134 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (right!8 t!78))))))))

(declare-fun b!770 () Bool)

(declare-fun res!453 () Bool)

(assert (=> b!770 (= res!453 (isBlack!0 (right!8 (right!8 (left!8 (right!8 t!78))))))))

(assert (=> b!770 (=> (not res!453) (not e!440))))

(declare-fun b!771 () Bool)

(declare-fun e!439 () Bool)

(assert (=> b!771 (= e!439 call!134)))

(declare-fun b!772 () Bool)

(declare-fun e!438 () Bool)

(assert (=> b!772 (= e!438 e!440)))

(declare-fun res!450 () Bool)

(assert (=> b!772 (= res!450 (isBlack!0 (left!8 (right!8 (left!8 (right!8 t!78))))))))

(assert (=> b!772 (=> (not res!450) (not e!440))))

(declare-fun b!773 () Bool)

(assert (=> b!773 (= e!441 e!438)))

(declare-fun c!197 () Bool)

(assert (=> b!773 (= c!197 ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 t!78))))))))

(declare-fun b!774 () Bool)

(assert (=> b!774 (= e!438 e!439)))

(declare-fun res!451 () Bool)

(assert (=> b!774 (= res!451 call!135)))

(assert (=> b!774 (=> (not res!451) (not e!439))))

(assert (= (and d!411 (not res!452)) b!773))

(assert (= (and b!773 c!197) b!774))

(assert (= (and b!773 (not c!197)) b!772))

(assert (= (and b!774 res!451) b!771))

(assert (= (and b!772 res!450) b!770))

(assert (= (and b!770 res!453) b!768))

(assert (= (and b!768 res!454) b!769))

(assert (= (or b!774 b!768) bm!134))

(assert (= (or b!771 b!769) bm!135))

(declare-fun m!1025 () Bool)

(assert (=> bm!134 m!1025))

(declare-fun m!1027 () Bool)

(assert (=> bm!135 m!1027))

(declare-fun m!1029 () Bool)

(assert (=> b!770 m!1029))

(declare-fun m!1031 () Bool)

(assert (=> b!772 m!1031))

(assert (=> bm!61 d!411))

(declare-fun b!775 () Bool)

(declare-fun res!459 () Bool)

(declare-fun call!137 () Bool)

(assert (=> b!775 (= res!459 call!137)))

(declare-fun e!444 () Bool)

(assert (=> b!775 (=> (not res!459) (not e!444))))

(declare-fun d!413 () Bool)

(declare-fun res!457 () Bool)

(declare-fun e!445 () Bool)

(assert (=> d!413 (=> res!457 e!445)))

(assert (=> d!413 (= res!457 ((_ is Empty!3) (right!8 (right!8 (left!8 t!78)))))))

(assert (=> d!413 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 t!78)))) e!445)))

(declare-fun b!776 () Bool)

(declare-fun call!136 () Bool)

(assert (=> b!776 (= e!444 call!136)))

(declare-fun bm!136 () Bool)

(assert (=> bm!136 (= call!137 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (left!8 t!78))))))))

(declare-fun bm!137 () Bool)

(assert (=> bm!137 (= call!136 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (left!8 t!78))))))))

(declare-fun b!777 () Bool)

(declare-fun res!458 () Bool)

(assert (=> b!777 (= res!458 (isBlack!0 (right!8 (right!8 (right!8 (left!8 t!78))))))))

(assert (=> b!777 (=> (not res!458) (not e!444))))

(declare-fun b!778 () Bool)

(declare-fun e!443 () Bool)

(assert (=> b!778 (= e!443 call!136)))

(declare-fun b!779 () Bool)

(declare-fun e!442 () Bool)

(assert (=> b!779 (= e!442 e!444)))

(declare-fun res!455 () Bool)

(assert (=> b!779 (= res!455 (isBlack!0 (left!8 (right!8 (right!8 (left!8 t!78))))))))

(assert (=> b!779 (=> (not res!455) (not e!444))))

(declare-fun b!780 () Bool)

(assert (=> b!780 (= e!445 e!442)))

(declare-fun c!198 () Bool)

(assert (=> b!780 (= c!198 ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 t!78))))))))

(declare-fun b!781 () Bool)

(assert (=> b!781 (= e!442 e!443)))

(declare-fun res!456 () Bool)

(assert (=> b!781 (= res!456 call!137)))

(assert (=> b!781 (=> (not res!456) (not e!443))))

(assert (= (and d!413 (not res!457)) b!780))

(assert (= (and b!780 c!198) b!781))

(assert (= (and b!780 (not c!198)) b!779))

(assert (= (and b!781 res!456) b!778))

(assert (= (and b!779 res!455) b!777))

(assert (= (and b!777 res!458) b!775))

(assert (= (and b!775 res!459) b!776))

(assert (= (or b!781 b!775) bm!136))

(assert (= (or b!778 b!776) bm!137))

(declare-fun m!1033 () Bool)

(assert (=> bm!136 m!1033))

(declare-fun m!1035 () Bool)

(assert (=> bm!137 m!1035))

(declare-fun m!1037 () Bool)

(assert (=> b!777 m!1037))

(declare-fun m!1039 () Bool)

(assert (=> b!779 m!1039))

(assert (=> bm!75 d!413))

(declare-fun d!415 () Bool)

(assert (=> d!415 (= (isBlack!0 (right!8 (right!8 lt!5))) (or ((_ is Empty!3) (right!8 (right!8 lt!5))) ((_ is Black!3) (color!6 (right!8 (right!8 lt!5))))))))

(assert (=> b!382 d!415))

(declare-fun d!417 () Bool)

(declare-fun c!199 () Bool)

(assert (=> d!417 (= c!199 ((_ is Empty!3) lt!19))))

(declare-fun e!446 () (InoxSet (_ BitVec 32)))

(assert (=> d!417 (= (content!0 lt!19) e!446)))

(declare-fun b!782 () Bool)

(assert (=> b!782 (= e!446 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!783 () Bool)

(assert (=> b!783 (= e!446 ((_ map or) ((_ map or) (content!0 (left!8 lt!19)) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 lt!19) true)) (content!0 (right!8 lt!19))))))

(assert (= (and d!417 c!199) b!782))

(assert (= (and d!417 (not c!199)) b!783))

(declare-fun m!1041 () Bool)

(assert (=> b!783 m!1041))

(declare-fun m!1043 () Bool)

(assert (=> b!783 m!1043))

(declare-fun m!1045 () Bool)

(assert (=> b!783 m!1045))

(assert (=> d!155 d!417))

(declare-fun c!200 () Bool)

(declare-fun d!419 () Bool)

(assert (=> d!419 (= c!200 ((_ is Empty!3) (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun e!447 () (InoxSet (_ BitVec 32)))

(assert (=> d!419 (= (content!0 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!447)))

(declare-fun b!784 () Bool)

(assert (=> b!784 (= e!447 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!785 () Bool)

(assert (=> b!785 (= e!447 ((_ map or) ((_ map or) (content!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) true)) (content!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!419 c!200) b!784))

(assert (= (and d!419 (not c!200)) b!785))

(declare-fun m!1047 () Bool)

(assert (=> b!785 m!1047))

(declare-fun m!1049 () Bool)

(assert (=> b!785 m!1049))

(declare-fun m!1051 () Bool)

(assert (=> b!785 m!1051))

(assert (=> d!155 d!419))

(declare-fun b!786 () Bool)

(declare-fun res!464 () Bool)

(declare-fun call!139 () Bool)

(assert (=> b!786 (= res!464 call!139)))

(declare-fun e!450 () Bool)

(assert (=> b!786 (=> (not res!464) (not e!450))))

(declare-fun d!421 () Bool)

(declare-fun res!462 () Bool)

(declare-fun e!451 () Bool)

(assert (=> d!421 (=> res!462 e!451)))

(assert (=> d!421 (= res!462 ((_ is Empty!3) (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!421 (= (redNodesHaveBlackChildren!0 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!451)))

(declare-fun b!787 () Bool)

(declare-fun call!138 () Bool)

(assert (=> b!787 (= e!450 call!138)))

(declare-fun bm!138 () Bool)

(assert (=> bm!138 (= call!139 (redNodesHaveBlackChildren!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun bm!139 () Bool)

(assert (=> bm!139 (= call!138 (redNodesHaveBlackChildren!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun res!463 () Bool)

(declare-fun b!788 () Bool)

(assert (=> b!788 (= res!463 (isBlack!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!788 (=> (not res!463) (not e!450))))

(declare-fun b!789 () Bool)

(declare-fun e!449 () Bool)

(assert (=> b!789 (= e!449 call!138)))

(declare-fun b!790 () Bool)

(declare-fun e!448 () Bool)

(assert (=> b!790 (= e!448 e!450)))

(declare-fun res!460 () Bool)

(assert (=> b!790 (= res!460 (isBlack!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!790 (=> (not res!460) (not e!450))))

(declare-fun b!791 () Bool)

(assert (=> b!791 (= e!451 e!448)))

(declare-fun c!201 () Bool)

(assert (=> b!791 (= c!201 ((_ is Black!3) (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!792 () Bool)

(assert (=> b!792 (= e!448 e!449)))

(declare-fun res!461 () Bool)

(assert (=> b!792 (= res!461 call!139)))

(assert (=> b!792 (=> (not res!461) (not e!449))))

(assert (= (and d!421 (not res!462)) b!791))

(assert (= (and b!791 c!201) b!792))

(assert (= (and b!791 (not c!201)) b!790))

(assert (= (and b!792 res!461) b!789))

(assert (= (and b!790 res!460) b!788))

(assert (= (and b!788 res!463) b!786))

(assert (= (and b!786 res!464) b!787))

(assert (= (or b!792 b!786) bm!138))

(assert (= (or b!789 b!787) bm!139))

(declare-fun m!1053 () Bool)

(assert (=> bm!138 m!1053))

(declare-fun m!1055 () Bool)

(assert (=> bm!139 m!1055))

(declare-fun m!1057 () Bool)

(assert (=> b!788 m!1057))

(declare-fun m!1059 () Bool)

(assert (=> b!790 m!1059))

(assert (=> d!155 d!421))

(declare-fun d!423 () Bool)

(declare-fun lt!37 () Tree!3)

(assert (=> d!423 (= (content!0 lt!37) (content!0 (Node!3 (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))))))

(assert (=> d!423 (= lt!37 (ite (and ((_ is Black!3) (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) ((_ is Node!3) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) ((_ is Red!3) (color!6 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) ((_ is Node!3) (left!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) ((_ is Red!3) (color!6 (left!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) (Node!3 Red!3 (Node!3 Black!3 (left!8 (left!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (value!38 (left!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (right!8 (left!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (value!38 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (Node!3 Black!3 (right!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) (ite (and ((_ is Black!3) (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) ((_ is Node!3) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) ((_ is Red!3) (color!6 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) ((_ is Node!3) (right!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) ((_ is Red!3) (color!6 (right!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) (Node!3 Red!3 (Node!3 Black!3 (left!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (value!38 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (left!8 (right!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (value!38 (right!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (Node!3 Black!3 (right!8 (right!8 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) (ite (and ((_ is Black!3) (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) ((_ is Node!3) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58)) ((_ is Red!3) (color!6 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) ((_ is Node!3) (left!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) ((_ is Red!3) (color!6 (left!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))))) (Node!3 Red!3 (Node!3 Black!3 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (left!8 (left!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58)))) (value!38 (left!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) (Node!3 Black!3 (right!8 (left!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) (value!38 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58)) (right!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58)))) (ite (and ((_ is Black!3) (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) ((_ is Node!3) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58)) ((_ is Red!3) (color!6 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) ((_ is Node!3) (right!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) ((_ is Red!3) (color!6 (right!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))))) (Node!3 Red!3 (Node!3 Black!3 (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (left!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) (value!38 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58)) (Node!3 Black!3 (left!8 (right!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) (value!38 (right!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) (right!8 (right!8 (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))))) (Node!3 (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58)))))))))

(assert (=> d!423 (= (balance!0 (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58)) lt!37)))

(declare-fun bs!4 () Bool)

(assert (= bs!4 d!423))

(declare-fun m!1061 () Bool)

(assert (=> bs!4 m!1061))

(declare-fun m!1063 () Bool)

(assert (=> bs!4 m!1063))

(assert (=> bm!58 d!423))

(declare-fun d!425 () Bool)

(declare-fun res!465 () Bool)

(declare-fun e!452 () Bool)

(assert (=> d!425 (=> res!465 e!452)))

(assert (=> d!425 (= res!465 (not ((_ is Node!3) (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!425 (= (blackBalanced!0 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) e!452)))

(declare-fun b!793 () Bool)

(declare-fun e!453 () Bool)

(assert (=> b!793 (= e!452 e!453)))

(declare-fun res!467 () Bool)

(assert (=> b!793 (=> (not res!467) (not e!453))))

(assert (=> b!793 (= res!467 (blackBalanced!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!794 () Bool)

(declare-fun res!466 () Bool)

(assert (=> b!794 (=> (not res!466) (not e!453))))

(assert (=> b!794 (= res!466 (blackBalanced!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun b!795 () Bool)

(assert (=> b!795 (= e!453 (= (blackHeight!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (blackHeight!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (= (and d!425 (not res!465)) b!793))

(assert (= (and b!793 res!467) b!794))

(assert (= (and b!794 res!466) b!795))

(declare-fun m!1065 () Bool)

(assert (=> b!793 m!1065))

(declare-fun m!1067 () Bool)

(assert (=> b!794 m!1067))

(assert (=> b!795 m!799))

(declare-fun m!1069 () Bool)

(assert (=> b!795 m!1069))

(assert (=> b!441 d!425))

(declare-fun d!427 () Bool)

(assert (=> d!427 (= (isBlack!0 (left!8 (right!8 (right!8 t!78)))) (or ((_ is Empty!3) (left!8 (right!8 (right!8 t!78)))) ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 t!78)))))))))

(assert (=> b!377 d!427))

(declare-fun d!429 () Bool)

(declare-fun c!202 () Bool)

(assert (=> d!429 (= c!202 ((_ is Empty!3) (left!8 lt!13)))))

(declare-fun e!454 () (InoxSet (_ BitVec 32)))

(assert (=> d!429 (= (content!0 (left!8 lt!13)) e!454)))

(declare-fun b!796 () Bool)

(assert (=> b!796 (= e!454 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!797 () Bool)

(assert (=> b!797 (= e!454 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 lt!13))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 lt!13)) true)) (content!0 (right!8 (left!8 lt!13)))))))

(assert (= (and d!429 c!202) b!796))

(assert (= (and d!429 (not c!202)) b!797))

(declare-fun m!1071 () Bool)

(assert (=> b!797 m!1071))

(declare-fun m!1073 () Bool)

(assert (=> b!797 m!1073))

(declare-fun m!1075 () Bool)

(assert (=> b!797 m!1075))

(assert (=> b!431 d!429))

(declare-fun d!431 () Bool)

(declare-fun c!203 () Bool)

(assert (=> d!431 (= c!203 ((_ is Empty!3) (right!8 lt!13)))))

(declare-fun e!455 () (InoxSet (_ BitVec 32)))

(assert (=> d!431 (= (content!0 (right!8 lt!13)) e!455)))

(declare-fun b!798 () Bool)

(assert (=> b!798 (= e!455 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!799 () Bool)

(assert (=> b!799 (= e!455 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 lt!13))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 lt!13)) true)) (content!0 (right!8 (right!8 lt!13)))))))

(assert (= (and d!431 c!203) b!798))

(assert (= (and d!431 (not c!203)) b!799))

(declare-fun m!1077 () Bool)

(assert (=> b!799 m!1077))

(declare-fun m!1079 () Bool)

(assert (=> b!799 m!1079))

(declare-fun m!1081 () Bool)

(assert (=> b!799 m!1081))

(assert (=> b!431 d!431))

(declare-fun d!433 () Bool)

(declare-fun res!468 () Bool)

(declare-fun e!456 () Bool)

(assert (=> d!433 (=> res!468 e!456)))

(assert (=> d!433 (= res!468 (not ((_ is Node!3) (right!8 (left!8 lt!5)))))))

(assert (=> d!433 (= (blackBalanced!0 (right!8 (left!8 lt!5))) e!456)))

(declare-fun b!800 () Bool)

(declare-fun e!457 () Bool)

(assert (=> b!800 (= e!456 e!457)))

(declare-fun res!470 () Bool)

(assert (=> b!800 (=> (not res!470) (not e!457))))

(assert (=> b!800 (= res!470 (blackBalanced!0 (left!8 (right!8 (left!8 lt!5)))))))

(declare-fun b!801 () Bool)

(declare-fun res!469 () Bool)

(assert (=> b!801 (=> (not res!469) (not e!457))))

(assert (=> b!801 (= res!469 (blackBalanced!0 (right!8 (right!8 (left!8 lt!5)))))))

(declare-fun b!802 () Bool)

(assert (=> b!802 (= e!457 (= (blackHeight!0 (left!8 (right!8 (left!8 lt!5)))) (blackHeight!0 (right!8 (right!8 (left!8 lt!5))))))))

(assert (= (and d!433 (not res!468)) b!800))

(assert (= (and b!800 res!470) b!801))

(assert (= (and b!801 res!469) b!802))

(declare-fun m!1083 () Bool)

(assert (=> b!800 m!1083))

(declare-fun m!1085 () Bool)

(assert (=> b!801 m!1085))

(assert (=> b!802 m!625))

(declare-fun m!1087 () Bool)

(assert (=> b!802 m!1087))

(assert (=> b!319 d!433))

(declare-fun b!803 () Bool)

(declare-fun res!475 () Bool)

(declare-fun call!141 () Bool)

(assert (=> b!803 (= res!475 call!141)))

(declare-fun e!460 () Bool)

(assert (=> b!803 (=> (not res!475) (not e!460))))

(declare-fun d!435 () Bool)

(declare-fun res!473 () Bool)

(declare-fun e!461 () Bool)

(assert (=> d!435 (=> res!473 e!461)))

(assert (=> d!435 (= res!473 ((_ is Empty!3) (left!8 (right!8 (right!8 t!78)))))))

(assert (=> d!435 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 t!78)))) e!461)))

(declare-fun b!804 () Bool)

(declare-fun call!140 () Bool)

(assert (=> b!804 (= e!460 call!140)))

(declare-fun bm!140 () Bool)

(assert (=> bm!140 (= call!141 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (right!8 t!78))))))))

(declare-fun bm!141 () Bool)

(assert (=> bm!141 (= call!140 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (right!8 t!78))))))))

(declare-fun b!805 () Bool)

(declare-fun res!474 () Bool)

(assert (=> b!805 (= res!474 (isBlack!0 (right!8 (left!8 (right!8 (right!8 t!78))))))))

(assert (=> b!805 (=> (not res!474) (not e!460))))

(declare-fun b!806 () Bool)

(declare-fun e!459 () Bool)

(assert (=> b!806 (= e!459 call!140)))

(declare-fun b!807 () Bool)

(declare-fun e!458 () Bool)

(assert (=> b!807 (= e!458 e!460)))

(declare-fun res!471 () Bool)

(assert (=> b!807 (= res!471 (isBlack!0 (left!8 (left!8 (right!8 (right!8 t!78))))))))

(assert (=> b!807 (=> (not res!471) (not e!460))))

(declare-fun b!808 () Bool)

(assert (=> b!808 (= e!461 e!458)))

(declare-fun c!204 () Bool)

(assert (=> b!808 (= c!204 ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 t!78))))))))

(declare-fun b!809 () Bool)

(assert (=> b!809 (= e!458 e!459)))

(declare-fun res!472 () Bool)

(assert (=> b!809 (= res!472 call!141)))

(assert (=> b!809 (=> (not res!472) (not e!459))))

(assert (= (and d!435 (not res!473)) b!808))

(assert (= (and b!808 c!204) b!809))

(assert (= (and b!808 (not c!204)) b!807))

(assert (= (and b!809 res!472) b!806))

(assert (= (and b!807 res!471) b!805))

(assert (= (and b!805 res!474) b!803))

(assert (= (and b!803 res!475) b!804))

(assert (= (or b!809 b!803) bm!140))

(assert (= (or b!806 b!804) bm!141))

(declare-fun m!1089 () Bool)

(assert (=> bm!140 m!1089))

(declare-fun m!1091 () Bool)

(assert (=> bm!141 m!1091))

(declare-fun m!1093 () Bool)

(assert (=> b!805 m!1093))

(declare-fun m!1095 () Bool)

(assert (=> b!807 m!1095))

(assert (=> bm!62 d!435))

(declare-fun d!437 () Bool)

(declare-fun c!205 () Bool)

(assert (=> d!437 (= c!205 ((_ is Empty!3) (left!8 (right!8 (right!8 t!78)))))))

(declare-fun e!462 () (InoxSet (_ BitVec 32)))

(assert (=> d!437 (= (content!0 (left!8 (right!8 (right!8 t!78)))) e!462)))

(declare-fun b!810 () Bool)

(assert (=> b!810 (= e!462 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!811 () Bool)

(assert (=> b!811 (= e!462 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (right!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (right!8 t!78)))) true)) (content!0 (right!8 (left!8 (right!8 (right!8 t!78)))))))))

(assert (= (and d!437 c!205) b!810))

(assert (= (and d!437 (not c!205)) b!811))

(declare-fun m!1097 () Bool)

(assert (=> b!811 m!1097))

(declare-fun m!1099 () Bool)

(assert (=> b!811 m!1099))

(declare-fun m!1101 () Bool)

(assert (=> b!811 m!1101))

(assert (=> b!454 d!437))

(declare-fun d!439 () Bool)

(declare-fun c!206 () Bool)

(assert (=> d!439 (= c!206 ((_ is Empty!3) (right!8 (right!8 (right!8 t!78)))))))

(declare-fun e!463 () (InoxSet (_ BitVec 32)))

(assert (=> d!439 (= (content!0 (right!8 (right!8 (right!8 t!78)))) e!463)))

(declare-fun b!812 () Bool)

(assert (=> b!812 (= e!463 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!813 () Bool)

(assert (=> b!813 (= e!463 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (right!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (right!8 t!78)))) true)) (content!0 (right!8 (right!8 (right!8 (right!8 t!78)))))))))

(assert (= (and d!439 c!206) b!812))

(assert (= (and d!439 (not c!206)) b!813))

(declare-fun m!1103 () Bool)

(assert (=> b!813 m!1103))

(declare-fun m!1105 () Bool)

(assert (=> b!813 m!1105))

(declare-fun m!1107 () Bool)

(assert (=> b!813 m!1107))

(assert (=> b!454 d!439))

(declare-fun b!814 () Bool)

(declare-fun res!480 () Bool)

(declare-fun call!143 () Bool)

(assert (=> b!814 (= res!480 call!143)))

(declare-fun e!466 () Bool)

(assert (=> b!814 (=> (not res!480) (not e!466))))

(declare-fun d!441 () Bool)

(declare-fun res!478 () Bool)

(declare-fun e!467 () Bool)

(assert (=> d!441 (=> res!478 e!467)))

(assert (=> d!441 (= res!478 ((_ is Empty!3) (left!8 (left!8 (left!8 t!78)))))))

(assert (=> d!441 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 t!78)))) e!467)))

(declare-fun b!815 () Bool)

(declare-fun call!142 () Bool)

(assert (=> b!815 (= e!466 call!142)))

(declare-fun bm!142 () Bool)

(assert (=> bm!142 (= call!143 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (left!8 t!78))))))))

(declare-fun bm!143 () Bool)

(assert (=> bm!143 (= call!142 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (left!8 t!78))))))))

(declare-fun b!816 () Bool)

(declare-fun res!479 () Bool)

(assert (=> b!816 (= res!479 (isBlack!0 (right!8 (left!8 (left!8 (left!8 t!78))))))))

(assert (=> b!816 (=> (not res!479) (not e!466))))

(declare-fun b!817 () Bool)

(declare-fun e!465 () Bool)

(assert (=> b!817 (= e!465 call!142)))

(declare-fun b!818 () Bool)

(declare-fun e!464 () Bool)

(assert (=> b!818 (= e!464 e!466)))

(declare-fun res!476 () Bool)

(assert (=> b!818 (= res!476 (isBlack!0 (left!8 (left!8 (left!8 (left!8 t!78))))))))

(assert (=> b!818 (=> (not res!476) (not e!466))))

(declare-fun b!819 () Bool)

(assert (=> b!819 (= e!467 e!464)))

(declare-fun c!207 () Bool)

(assert (=> b!819 (= c!207 ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 t!78))))))))

(declare-fun b!820 () Bool)

(assert (=> b!820 (= e!464 e!465)))

(declare-fun res!477 () Bool)

(assert (=> b!820 (= res!477 call!143)))

(assert (=> b!820 (=> (not res!477) (not e!465))))

(assert (= (and d!441 (not res!478)) b!819))

(assert (= (and b!819 c!207) b!820))

(assert (= (and b!819 (not c!207)) b!818))

(assert (= (and b!820 res!477) b!817))

(assert (= (and b!818 res!476) b!816))

(assert (= (and b!816 res!479) b!814))

(assert (= (and b!814 res!480) b!815))

(assert (= (or b!820 b!814) bm!142))

(assert (= (or b!817 b!815) bm!143))

(declare-fun m!1109 () Bool)

(assert (=> bm!142 m!1109))

(declare-fun m!1111 () Bool)

(assert (=> bm!143 m!1111))

(declare-fun m!1113 () Bool)

(assert (=> b!816 m!1113))

(declare-fun m!1115 () Bool)

(assert (=> b!818 m!1115))

(assert (=> bm!70 d!441))

(declare-fun d!443 () Bool)

(declare-fun c!208 () Bool)

(assert (=> d!443 (= c!208 ((_ is Empty!3) (left!8 (right!8 (left!8 t!78)))))))

(declare-fun e!468 () (InoxSet (_ BitVec 32)))

(assert (=> d!443 (= (content!0 (left!8 (right!8 (left!8 t!78)))) e!468)))

(declare-fun b!821 () Bool)

(assert (=> b!821 (= e!468 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!822 () Bool)

(assert (=> b!822 (= e!468 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (left!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (left!8 t!78)))) true)) (content!0 (right!8 (left!8 (right!8 (left!8 t!78)))))))))

(assert (= (and d!443 c!208) b!821))

(assert (= (and d!443 (not c!208)) b!822))

(declare-fun m!1117 () Bool)

(assert (=> b!822 m!1117))

(declare-fun m!1119 () Bool)

(assert (=> b!822 m!1119))

(declare-fun m!1121 () Bool)

(assert (=> b!822 m!1121))

(assert (=> b!340 d!443))

(declare-fun d!445 () Bool)

(declare-fun c!209 () Bool)

(assert (=> d!445 (= c!209 ((_ is Empty!3) (right!8 (right!8 (left!8 t!78)))))))

(declare-fun e!469 () (InoxSet (_ BitVec 32)))

(assert (=> d!445 (= (content!0 (right!8 (right!8 (left!8 t!78)))) e!469)))

(declare-fun b!823 () Bool)

(assert (=> b!823 (= e!469 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!824 () Bool)

(assert (=> b!824 (= e!469 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (left!8 t!78))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (left!8 t!78)))) true)) (content!0 (right!8 (right!8 (right!8 (left!8 t!78)))))))))

(assert (= (and d!445 c!209) b!823))

(assert (= (and d!445 (not c!209)) b!824))

(declare-fun m!1123 () Bool)

(assert (=> b!824 m!1123))

(declare-fun m!1125 () Bool)

(assert (=> b!824 m!1125))

(declare-fun m!1127 () Bool)

(assert (=> b!824 m!1127))

(assert (=> b!340 d!445))

(declare-fun d!447 () Bool)

(declare-fun c!210 () Bool)

(assert (=> d!447 (= c!210 ((_ is Empty!3) (left!8 (right!8 (right!8 lt!2)))))))

(declare-fun e!470 () (InoxSet (_ BitVec 32)))

(assert (=> d!447 (= (content!0 (left!8 (right!8 (right!8 lt!2)))) e!470)))

(declare-fun b!825 () Bool)

(assert (=> b!825 (= e!470 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!826 () Bool)

(assert (=> b!826 (= e!470 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (right!8 lt!2))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (right!8 lt!2)))) true)) (content!0 (right!8 (left!8 (right!8 (right!8 lt!2)))))))))

(assert (= (and d!447 c!210) b!825))

(assert (= (and d!447 (not c!210)) b!826))

(declare-fun m!1129 () Bool)

(assert (=> b!826 m!1129))

(declare-fun m!1131 () Bool)

(assert (=> b!826 m!1131))

(declare-fun m!1133 () Bool)

(assert (=> b!826 m!1133))

(assert (=> b!348 d!447))

(declare-fun d!449 () Bool)

(declare-fun c!211 () Bool)

(assert (=> d!449 (= c!211 ((_ is Empty!3) (right!8 (right!8 (right!8 lt!2)))))))

(declare-fun e!471 () (InoxSet (_ BitVec 32)))

(assert (=> d!449 (= (content!0 (right!8 (right!8 (right!8 lt!2)))) e!471)))

(declare-fun b!827 () Bool)

(assert (=> b!827 (= e!471 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!828 () Bool)

(assert (=> b!828 (= e!471 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (right!8 lt!2))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (right!8 lt!2)))) true)) (content!0 (right!8 (right!8 (right!8 (right!8 lt!2)))))))))

(assert (= (and d!449 c!211) b!827))

(assert (= (and d!449 (not c!211)) b!828))

(declare-fun m!1135 () Bool)

(assert (=> b!828 m!1135))

(declare-fun m!1137 () Bool)

(assert (=> b!828 m!1137))

(declare-fun m!1139 () Bool)

(assert (=> b!828 m!1139))

(assert (=> b!348 d!449))

(declare-fun d!451 () Bool)

(assert (=> d!451 (= (isBlack!0 (left!8 (left!8 (left!8 t!78)))) (or ((_ is Empty!3) (left!8 (left!8 (left!8 t!78)))) ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 t!78)))))))))

(assert (=> b!405 d!451))

(declare-fun d!453 () Bool)

(declare-fun res!481 () Bool)

(declare-fun e!472 () Bool)

(assert (=> d!453 (=> res!481 e!472)))

(assert (=> d!453 (= res!481 (not ((_ is Node!3) (left!8 (right!8 t!78)))))))

(assert (=> d!453 (= (blackBalanced!0 (left!8 (right!8 t!78))) e!472)))

(declare-fun b!829 () Bool)

(declare-fun e!473 () Bool)

(assert (=> b!829 (= e!472 e!473)))

(declare-fun res!483 () Bool)

(assert (=> b!829 (=> (not res!483) (not e!473))))

(assert (=> b!829 (= res!483 (blackBalanced!0 (left!8 (left!8 (right!8 t!78)))))))

(declare-fun b!830 () Bool)

(declare-fun res!482 () Bool)

(assert (=> b!830 (=> (not res!482) (not e!473))))

(assert (=> b!830 (= res!482 (blackBalanced!0 (right!8 (left!8 (right!8 t!78)))))))

(declare-fun b!831 () Bool)

(assert (=> b!831 (= e!473 (= (blackHeight!0 (left!8 (left!8 (right!8 t!78)))) (blackHeight!0 (right!8 (left!8 (right!8 t!78))))))))

(assert (= (and d!453 (not res!481)) b!829))

(assert (= (and b!829 res!483) b!830))

(assert (= (and b!830 res!482) b!831))

(declare-fun m!1141 () Bool)

(assert (=> b!829 m!1141))

(declare-fun m!1143 () Bool)

(assert (=> b!830 m!1143))

(assert (=> b!831 m!797))

(declare-fun m!1145 () Bool)

(assert (=> b!831 m!1145))

(assert (=> b!290 d!453))

(assert (=> b!355 d!369))

(assert (=> b!355 d!367))

(check-sat (not bm!116) (not b!609) (not bm!111) (not b!725) (not b!561) (not bm!124) (not b!552) (not bm!108) (not bm!88) (not b!608) (not b!721) (not b!644) (not b!491) (not b!641) (not b!772) (not b!765) (not b!822) (not bm!137) (not b!665) (not b!671) (not bm!102) (not bm!84) (not b!631) (not b!492) (not b!794) (not bm!139) (not b!709) (not b!477) (not bm!132) (not b!799) (not b!692) (not b!733) (not b!824) (not b!493) (not b!566) (not b!490) (not bm!103) (not b!629) (not b!729) (not bm!96) (not b!526) (not b!675) (not bm!115) (not b!660) (not b!705) (not b!540) (not b!606) (not b!797) (not b!463) (not b!545) (not bm!130) (not b!637) (not b!521) (not b!800) (not bm!90) (not b!711) (not bm!93) (not b!482) (not b!646) (not b!592) (not bm!109) (not bm!123) (not bm!81) (not b!755) (not b!701) (not b!760) (not bm!92) (not b!793) (not bm!100) (not bm!106) (not b!670) (not bm!89) (not b!587) (not b!468) (not b!735) (not b!651) (not b!805) (not b!727) (not b!517) (not bm!101) (not b!779) (not b!788) (not b!756) (not b!594) (not b!717) (not b!635) (not bm!143) (not b!750) (not b!605) (not b!582) (not b!527) (not bm!140) (not bm!117) (not b!785) (not b!597) (not b!818) (not bm!127) (not b!667) (not bm!142) (not bm!122) (not bm!107) (not b!813) (not bm!85) (not bm!128) (not bm!133) (not d!423) (not b!724) (not bm!82) (not b!816) (not b!807) (not b!828) (not b!684) (not b!523) (not b!704) (not b!488) (not b!473) (not b!677) (not b!762) (not b!554) (not b!538) (not b!511) (not b!777) (not b!653) (not bm!91) (not bm!105) (not bm!126) (not b!731) (not bm!119) (not bm!120) (not b!585) (not b!467) (not b!726) (not bm!94) (not b!639) (not b!524) (not b!802) (not b!519) (not b!568) (not bm!114) (not b!672) (not b!747) (not b!790) (not bm!83) (not b!529) (not b!688) (not b!707) (not bm!135) (not bm!129) (not b!513) (not b!770) (not b!767) (not b!694) (not b!535) (not b!722) (not b!471) (not b!757) (not b!484) (not bm!141) (not b!600) (not bm!95) (not b!658) (not bm!134) (not b!699) (not b!682) (not b!515) (not bm!118) (not b!795) (not b!766) (not b!687) (not b!533) (not bm!87) (not b!826) (not b!801) (not b!719) (not b!752) (not b!466) (not bm!113) (not bm!131) (not b!531) (not bm!80) (not b!559) (not b!522) (not b!829) (not b!830) (not b!603) (not b!610) (not b!465) (not bm!138) (not d!301) (not bm!110) (not bm!136) (not bm!86) (not b!525) (not b!547) (not bm!98) (not b!783) (not b!745) (not b!811) (not b!723) (not bm!97) (not b!580) (not b!479) (not bm!121) (not b!713) (not bm!112) (not b!715) (not bm!99) (not b!831) (not bm!104) (not b!689) (not bm!125))
(check-sat)
(get-model)

(declare-fun d!455 () Bool)

(declare-fun c!212 () Bool)

(assert (=> d!455 (= c!212 ((_ is Empty!3) (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun e!474 () (_ BitVec 32))

(assert (=> d!455 (= (blackHeight!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) e!474)))

(declare-fun b!832 () Bool)

(declare-fun e!475 () (_ BitVec 32))

(declare-fun call!144 () (_ BitVec 32))

(assert (=> b!832 (= e!475 (bvadd call!144 #b00000000000000000000000000000001))))

(declare-fun bm!144 () Bool)

(assert (=> bm!144 (= call!144 (blackHeight!0 (left!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!833 () Bool)

(assert (=> b!833 (= e!475 call!144)))

(declare-fun b!834 () Bool)

(assert (=> b!834 (= e!474 e!475)))

(declare-fun c!213 () Bool)

(assert (=> b!834 (= c!213 ((_ is Black!3) (color!6 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!835 () Bool)

(assert (=> b!835 (= e!474 #b00000000000000000000000000000001)))

(assert (= (and d!455 c!212) b!835))

(assert (= (and d!455 (not c!212)) b!834))

(assert (= (and b!834 c!213) b!832))

(assert (= (and b!834 (not c!213)) b!833))

(assert (= (or b!832 b!833) bm!144))

(declare-fun m!1147 () Bool)

(assert (=> bm!144 m!1147))

(assert (=> b!493 d!455))

(declare-fun d!457 () Bool)

(declare-fun c!214 () Bool)

(assert (=> d!457 (= c!214 ((_ is Empty!3) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun e!476 () (_ BitVec 32))

(assert (=> d!457 (= (blackHeight!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) e!476)))

(declare-fun b!836 () Bool)

(declare-fun e!477 () (_ BitVec 32))

(declare-fun call!145 () (_ BitVec 32))

(assert (=> b!836 (= e!477 (bvadd call!145 #b00000000000000000000000000000001))))

(declare-fun bm!145 () Bool)

(assert (=> bm!145 (= call!145 (blackHeight!0 (left!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!837 () Bool)

(assert (=> b!837 (= e!477 call!145)))

(declare-fun b!838 () Bool)

(assert (=> b!838 (= e!476 e!477)))

(declare-fun c!215 () Bool)

(assert (=> b!838 (= c!215 ((_ is Black!3) (color!6 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!839 () Bool)

(assert (=> b!839 (= e!476 #b00000000000000000000000000000001)))

(assert (= (and d!457 c!214) b!839))

(assert (= (and d!457 (not c!214)) b!838))

(assert (= (and b!838 c!215) b!836))

(assert (= (and b!838 (not c!215)) b!837))

(assert (= (or b!836 b!837) bm!145))

(declare-fun m!1149 () Bool)

(assert (=> bm!145 m!1149))

(assert (=> b!493 d!457))

(declare-fun b!840 () Bool)

(declare-fun res!488 () Bool)

(declare-fun call!147 () Bool)

(assert (=> b!840 (= res!488 call!147)))

(declare-fun e!480 () Bool)

(assert (=> b!840 (=> (not res!488) (not e!480))))

(declare-fun d!459 () Bool)

(declare-fun res!486 () Bool)

(declare-fun e!481 () Bool)

(assert (=> d!459 (=> res!486 e!481)))

(assert (=> d!459 (= res!486 ((_ is Empty!3) (right!8 (left!8 (right!8 (left!8 lt!2))))))))

(assert (=> d!459 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (left!8 lt!2))))) e!481)))

(declare-fun b!841 () Bool)

(declare-fun call!146 () Bool)

(assert (=> b!841 (= e!480 call!146)))

(declare-fun bm!146 () Bool)

(assert (=> bm!146 (= call!147 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (right!8 (left!8 lt!2)))))))))

(declare-fun bm!147 () Bool)

(assert (=> bm!147 (= call!146 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (right!8 (left!8 lt!2)))))))))

(declare-fun b!842 () Bool)

(declare-fun res!487 () Bool)

(assert (=> b!842 (= res!487 (isBlack!0 (right!8 (right!8 (left!8 (right!8 (left!8 lt!2)))))))))

(assert (=> b!842 (=> (not res!487) (not e!480))))

(declare-fun b!843 () Bool)

(declare-fun e!479 () Bool)

(assert (=> b!843 (= e!479 call!146)))

(declare-fun b!844 () Bool)

(declare-fun e!478 () Bool)

(assert (=> b!844 (= e!478 e!480)))

(declare-fun res!484 () Bool)

(assert (=> b!844 (= res!484 (isBlack!0 (left!8 (right!8 (left!8 (right!8 (left!8 lt!2)))))))))

(assert (=> b!844 (=> (not res!484) (not e!480))))

(declare-fun b!845 () Bool)

(assert (=> b!845 (= e!481 e!478)))

(declare-fun c!216 () Bool)

(assert (=> b!845 (= c!216 ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 (left!8 lt!2)))))))))

(declare-fun b!846 () Bool)

(assert (=> b!846 (= e!478 e!479)))

(declare-fun res!485 () Bool)

(assert (=> b!846 (= res!485 call!147)))

(assert (=> b!846 (=> (not res!485) (not e!479))))

(assert (= (and d!459 (not res!486)) b!845))

(assert (= (and b!845 c!216) b!846))

(assert (= (and b!845 (not c!216)) b!844))

(assert (= (and b!846 res!485) b!843))

(assert (= (and b!844 res!484) b!842))

(assert (= (and b!842 res!487) b!840))

(assert (= (and b!840 res!488) b!841))

(assert (= (or b!846 b!840) bm!146))

(assert (= (or b!843 b!841) bm!147))

(declare-fun m!1151 () Bool)

(assert (=> bm!146 m!1151))

(declare-fun m!1153 () Bool)

(assert (=> bm!147 m!1153))

(declare-fun m!1155 () Bool)

(assert (=> b!842 m!1155))

(declare-fun m!1157 () Bool)

(assert (=> b!844 m!1157))

(assert (=> bm!111 d!459))

(declare-fun b!847 () Bool)

(declare-fun res!493 () Bool)

(declare-fun call!149 () Bool)

(assert (=> b!847 (= res!493 call!149)))

(declare-fun e!484 () Bool)

(assert (=> b!847 (=> (not res!493) (not e!484))))

(declare-fun d!461 () Bool)

(declare-fun res!491 () Bool)

(declare-fun e!485 () Bool)

(assert (=> d!461 (=> res!491 e!485)))

(assert (=> d!461 (= res!491 ((_ is Empty!3) (right!8 (right!8 (left!8 (right!8 t!78))))))))

(assert (=> d!461 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (right!8 t!78))))) e!485)))

(declare-fun b!848 () Bool)

(declare-fun call!148 () Bool)

(assert (=> b!848 (= e!484 call!148)))

(declare-fun bm!148 () Bool)

(assert (=> bm!148 (= call!149 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (left!8 (right!8 t!78)))))))))

(declare-fun bm!149 () Bool)

(assert (=> bm!149 (= call!148 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (left!8 (right!8 t!78)))))))))

(declare-fun b!849 () Bool)

(declare-fun res!492 () Bool)

(assert (=> b!849 (= res!492 (isBlack!0 (right!8 (right!8 (right!8 (left!8 (right!8 t!78)))))))))

(assert (=> b!849 (=> (not res!492) (not e!484))))

(declare-fun b!850 () Bool)

(declare-fun e!483 () Bool)

(assert (=> b!850 (= e!483 call!148)))

(declare-fun b!851 () Bool)

(declare-fun e!482 () Bool)

(assert (=> b!851 (= e!482 e!484)))

(declare-fun res!489 () Bool)

(assert (=> b!851 (= res!489 (isBlack!0 (left!8 (right!8 (right!8 (left!8 (right!8 t!78)))))))))

(assert (=> b!851 (=> (not res!489) (not e!484))))

(declare-fun b!852 () Bool)

(assert (=> b!852 (= e!485 e!482)))

(declare-fun c!217 () Bool)

(assert (=> b!852 (= c!217 ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 (right!8 t!78)))))))))

(declare-fun b!853 () Bool)

(assert (=> b!853 (= e!482 e!483)))

(declare-fun res!490 () Bool)

(assert (=> b!853 (= res!490 call!149)))

(assert (=> b!853 (=> (not res!490) (not e!483))))

(assert (= (and d!461 (not res!491)) b!852))

(assert (= (and b!852 c!217) b!853))

(assert (= (and b!852 (not c!217)) b!851))

(assert (= (and b!853 res!490) b!850))

(assert (= (and b!851 res!489) b!849))

(assert (= (and b!849 res!492) b!847))

(assert (= (and b!847 res!493) b!848))

(assert (= (or b!853 b!847) bm!148))

(assert (= (or b!850 b!848) bm!149))

(declare-fun m!1159 () Bool)

(assert (=> bm!148 m!1159))

(declare-fun m!1161 () Bool)

(assert (=> bm!149 m!1161))

(declare-fun m!1163 () Bool)

(assert (=> b!849 m!1163))

(declare-fun m!1165 () Bool)

(assert (=> b!851 m!1165))

(assert (=> bm!135 d!461))

(declare-fun d!463 () Bool)

(declare-fun lt!38 () Int)

(assert (=> d!463 (>= lt!38 0)))

(declare-fun e!486 () Int)

(assert (=> d!463 (= lt!38 e!486)))

(declare-fun c!218 () Bool)

(assert (=> d!463 (= c!218 ((_ is Empty!3) (left!8 (right!8 (right!8 t!78)))))))

(assert (=> d!463 (= (size!0 (left!8 (right!8 (right!8 t!78)))) lt!38)))

(declare-fun b!854 () Bool)

(assert (=> b!854 (= e!486 0)))

(declare-fun b!855 () Bool)

(assert (=> b!855 (= e!486 (+ (size!0 (left!8 (left!8 (right!8 (right!8 t!78))))) 1 (size!0 (right!8 (left!8 (right!8 (right!8 t!78)))))))))

(assert (= (and d!463 c!218) b!854))

(assert (= (and d!463 (not c!218)) b!855))

(declare-fun m!1167 () Bool)

(assert (=> b!855 m!1167))

(declare-fun m!1169 () Bool)

(assert (=> b!855 m!1169))

(assert (=> b!735 d!463))

(declare-fun d!465 () Bool)

(declare-fun lt!39 () Int)

(assert (=> d!465 (>= lt!39 0)))

(declare-fun e!487 () Int)

(assert (=> d!465 (= lt!39 e!487)))

(declare-fun c!219 () Bool)

(assert (=> d!465 (= c!219 ((_ is Empty!3) (right!8 (right!8 (right!8 t!78)))))))

(assert (=> d!465 (= (size!0 (right!8 (right!8 (right!8 t!78)))) lt!39)))

(declare-fun b!856 () Bool)

(assert (=> b!856 (= e!487 0)))

(declare-fun b!857 () Bool)

(assert (=> b!857 (= e!487 (+ (size!0 (left!8 (right!8 (right!8 (right!8 t!78))))) 1 (size!0 (right!8 (right!8 (right!8 (right!8 t!78)))))))))

(assert (= (and d!465 c!219) b!856))

(assert (= (and d!465 (not c!219)) b!857))

(declare-fun m!1171 () Bool)

(assert (=> b!857 m!1171))

(declare-fun m!1173 () Bool)

(assert (=> b!857 m!1173))

(assert (=> b!735 d!465))

(declare-fun d!467 () Bool)

(declare-fun c!220 () Bool)

(assert (=> d!467 (= c!220 ((_ is Empty!3) (left!8 (left!8 (left!8 lt!5)))))))

(declare-fun e!488 () (InoxSet (_ BitVec 32)))

(assert (=> d!467 (= (content!0 (left!8 (left!8 (left!8 lt!5)))) e!488)))

(declare-fun b!858 () Bool)

(assert (=> b!858 (= e!488 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!859 () Bool)

(assert (=> b!859 (= e!488 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (left!8 lt!5))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (left!8 lt!5)))) true)) (content!0 (right!8 (left!8 (left!8 (left!8 lt!5)))))))))

(assert (= (and d!467 c!220) b!858))

(assert (= (and d!467 (not c!220)) b!859))

(declare-fun m!1175 () Bool)

(assert (=> b!859 m!1175))

(declare-fun m!1177 () Bool)

(assert (=> b!859 m!1177))

(declare-fun m!1179 () Bool)

(assert (=> b!859 m!1179))

(assert (=> b!745 d!467))

(declare-fun d!469 () Bool)

(declare-fun c!221 () Bool)

(assert (=> d!469 (= c!221 ((_ is Empty!3) (right!8 (left!8 (left!8 lt!5)))))))

(declare-fun e!489 () (InoxSet (_ BitVec 32)))

(assert (=> d!469 (= (content!0 (right!8 (left!8 (left!8 lt!5)))) e!489)))

(declare-fun b!860 () Bool)

(assert (=> b!860 (= e!489 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!861 () Bool)

(assert (=> b!861 (= e!489 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (left!8 lt!5))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (left!8 lt!5)))) true)) (content!0 (right!8 (right!8 (left!8 (left!8 lt!5)))))))))

(assert (= (and d!469 c!221) b!860))

(assert (= (and d!469 (not c!221)) b!861))

(declare-fun m!1181 () Bool)

(assert (=> b!861 m!1181))

(declare-fun m!1183 () Bool)

(assert (=> b!861 m!1183))

(declare-fun m!1185 () Bool)

(assert (=> b!861 m!1185))

(assert (=> b!745 d!469))

(declare-fun b!862 () Bool)

(declare-fun res!498 () Bool)

(declare-fun call!151 () Bool)

(assert (=> b!862 (= res!498 call!151)))

(declare-fun e!492 () Bool)

(assert (=> b!862 (=> (not res!498) (not e!492))))

(declare-fun d!471 () Bool)

(declare-fun res!496 () Bool)

(declare-fun e!493 () Bool)

(assert (=> d!471 (=> res!496 e!493)))

(assert (=> d!471 (= res!496 ((_ is Empty!3) (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!471 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!493)))

(declare-fun b!863 () Bool)

(declare-fun call!150 () Bool)

(assert (=> b!863 (= e!492 call!150)))

(declare-fun bm!150 () Bool)

(assert (=> bm!150 (= call!151 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun bm!151 () Bool)

(assert (=> bm!151 (= call!150 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!864 () Bool)

(declare-fun res!497 () Bool)

(assert (=> b!864 (= res!497 (isBlack!0 (right!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!864 (=> (not res!497) (not e!492))))

(declare-fun b!865 () Bool)

(declare-fun e!491 () Bool)

(assert (=> b!865 (= e!491 call!150)))

(declare-fun b!866 () Bool)

(declare-fun e!490 () Bool)

(assert (=> b!866 (= e!490 e!492)))

(declare-fun res!494 () Bool)

(assert (=> b!866 (= res!494 (isBlack!0 (left!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!866 (=> (not res!494) (not e!492))))

(declare-fun b!867 () Bool)

(assert (=> b!867 (= e!493 e!490)))

(declare-fun c!222 () Bool)

(assert (=> b!867 (= c!222 ((_ is Black!3) (color!6 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!868 () Bool)

(assert (=> b!868 (= e!490 e!491)))

(declare-fun res!495 () Bool)

(assert (=> b!868 (= res!495 call!151)))

(assert (=> b!868 (=> (not res!495) (not e!491))))

(assert (= (and d!471 (not res!496)) b!867))

(assert (= (and b!867 c!222) b!868))

(assert (= (and b!867 (not c!222)) b!866))

(assert (= (and b!868 res!495) b!865))

(assert (= (and b!866 res!494) b!864))

(assert (= (and b!864 res!497) b!862))

(assert (= (and b!862 res!498) b!863))

(assert (= (or b!868 b!862) bm!150))

(assert (= (or b!865 b!863) bm!151))

(declare-fun m!1187 () Bool)

(assert (=> bm!150 m!1187))

(declare-fun m!1189 () Bool)

(assert (=> bm!151 m!1189))

(declare-fun m!1191 () Bool)

(assert (=> b!864 m!1191))

(declare-fun m!1193 () Bool)

(assert (=> b!866 m!1193))

(assert (=> bm!94 d!471))

(declare-fun b!869 () Bool)

(declare-fun res!503 () Bool)

(declare-fun call!153 () Bool)

(assert (=> b!869 (= res!503 call!153)))

(declare-fun e!496 () Bool)

(assert (=> b!869 (=> (not res!503) (not e!496))))

(declare-fun d!473 () Bool)

(declare-fun res!501 () Bool)

(declare-fun e!497 () Bool)

(assert (=> d!473 (=> res!501 e!497)))

(assert (=> d!473 (= res!501 ((_ is Empty!3) (left!8 (right!8 lt!13))))))

(assert (=> d!473 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 lt!13))) e!497)))

(declare-fun b!870 () Bool)

(declare-fun call!152 () Bool)

(assert (=> b!870 (= e!496 call!152)))

(declare-fun bm!152 () Bool)

(assert (=> bm!152 (= call!153 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 lt!13)))))))

(declare-fun bm!153 () Bool)

(assert (=> bm!153 (= call!152 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 lt!13)))))))

(declare-fun b!871 () Bool)

(declare-fun res!502 () Bool)

(assert (=> b!871 (= res!502 (isBlack!0 (right!8 (left!8 (right!8 lt!13)))))))

(assert (=> b!871 (=> (not res!502) (not e!496))))

(declare-fun b!872 () Bool)

(declare-fun e!495 () Bool)

(assert (=> b!872 (= e!495 call!152)))

(declare-fun b!873 () Bool)

(declare-fun e!494 () Bool)

(assert (=> b!873 (= e!494 e!496)))

(declare-fun res!499 () Bool)

(assert (=> b!873 (= res!499 (isBlack!0 (left!8 (left!8 (right!8 lt!13)))))))

(assert (=> b!873 (=> (not res!499) (not e!496))))

(declare-fun b!874 () Bool)

(assert (=> b!874 (= e!497 e!494)))

(declare-fun c!223 () Bool)

(assert (=> b!874 (= c!223 ((_ is Black!3) (color!6 (left!8 (right!8 lt!13)))))))

(declare-fun b!875 () Bool)

(assert (=> b!875 (= e!494 e!495)))

(declare-fun res!500 () Bool)

(assert (=> b!875 (= res!500 call!153)))

(assert (=> b!875 (=> (not res!500) (not e!495))))

(assert (= (and d!473 (not res!501)) b!874))

(assert (= (and b!874 c!223) b!875))

(assert (= (and b!874 (not c!223)) b!873))

(assert (= (and b!875 res!500) b!872))

(assert (= (and b!873 res!499) b!871))

(assert (= (and b!871 res!502) b!869))

(assert (= (and b!869 res!503) b!870))

(assert (= (or b!875 b!869) bm!152))

(assert (= (or b!872 b!870) bm!153))

(declare-fun m!1195 () Bool)

(assert (=> bm!152 m!1195))

(declare-fun m!1197 () Bool)

(assert (=> bm!153 m!1197))

(declare-fun m!1199 () Bool)

(assert (=> b!871 m!1199))

(declare-fun m!1201 () Bool)

(assert (=> b!873 m!1201))

(assert (=> bm!82 d!473))

(declare-fun d!475 () Bool)

(assert (=> d!475 (= (isBlack!0 (left!8 (right!8 (left!8 lt!5)))) (or ((_ is Empty!3) (left!8 (right!8 (left!8 lt!5)))) ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 lt!5)))))))))

(assert (=> b!646 d!475))

(declare-fun d!477 () Bool)

(declare-fun res!504 () Bool)

(declare-fun e!498 () Bool)

(assert (=> d!477 (=> res!504 e!498)))

(assert (=> d!477 (= res!504 (not ((_ is Node!3) (right!8 (left!8 (right!8 lt!5))))))))

(assert (=> d!477 (= (blackBalanced!0 (right!8 (left!8 (right!8 lt!5)))) e!498)))

(declare-fun b!876 () Bool)

(declare-fun e!499 () Bool)

(assert (=> b!876 (= e!498 e!499)))

(declare-fun res!506 () Bool)

(assert (=> b!876 (=> (not res!506) (not e!499))))

(assert (=> b!876 (= res!506 (blackBalanced!0 (left!8 (right!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!877 () Bool)

(declare-fun res!505 () Bool)

(assert (=> b!877 (=> (not res!505) (not e!499))))

(assert (=> b!877 (= res!505 (blackBalanced!0 (right!8 (right!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!878 () Bool)

(assert (=> b!878 (= e!499 (= (blackHeight!0 (left!8 (right!8 (left!8 (right!8 lt!5))))) (blackHeight!0 (right!8 (right!8 (left!8 (right!8 lt!5)))))))))

(assert (= (and d!477 (not res!504)) b!876))

(assert (= (and b!876 res!506) b!877))

(assert (= (and b!877 res!505) b!878))

(declare-fun m!1203 () Bool)

(assert (=> b!876 m!1203))

(declare-fun m!1205 () Bool)

(assert (=> b!877 m!1205))

(declare-fun m!1207 () Bool)

(assert (=> b!878 m!1207))

(declare-fun m!1209 () Bool)

(assert (=> b!878 m!1209))

(assert (=> b!766 d!477))

(declare-fun d!479 () Bool)

(declare-fun c!224 () Bool)

(assert (=> d!479 (= c!224 ((_ is Empty!3) (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun e!500 () (_ BitVec 32))

(assert (=> d!479 (= (blackHeight!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!500)))

(declare-fun b!879 () Bool)

(declare-fun e!501 () (_ BitVec 32))

(declare-fun call!154 () (_ BitVec 32))

(assert (=> b!879 (= e!501 (bvadd call!154 #b00000000000000000000000000000001))))

(declare-fun bm!154 () Bool)

(assert (=> bm!154 (= call!154 (blackHeight!0 (left!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!880 () Bool)

(assert (=> b!880 (= e!501 call!154)))

(declare-fun b!881 () Bool)

(assert (=> b!881 (= e!500 e!501)))

(declare-fun c!225 () Bool)

(assert (=> b!881 (= c!225 ((_ is Black!3) (color!6 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!882 () Bool)

(assert (=> b!882 (= e!500 #b00000000000000000000000000000001)))

(assert (= (and d!479 c!224) b!882))

(assert (= (and d!479 (not c!224)) b!881))

(assert (= (and b!881 c!225) b!879))

(assert (= (and b!881 (not c!225)) b!880))

(assert (= (or b!879 b!880) bm!154))

(declare-fun m!1211 () Bool)

(assert (=> bm!154 m!1211))

(assert (=> b!527 d!479))

(declare-fun d!481 () Bool)

(declare-fun c!226 () Bool)

(assert (=> d!481 (= c!226 ((_ is Empty!3) (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun e!502 () (_ BitVec 32))

(assert (=> d!481 (= (blackHeight!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!502)))

(declare-fun b!883 () Bool)

(declare-fun e!503 () (_ BitVec 32))

(declare-fun call!155 () (_ BitVec 32))

(assert (=> b!883 (= e!503 (bvadd call!155 #b00000000000000000000000000000001))))

(declare-fun bm!155 () Bool)

(assert (=> bm!155 (= call!155 (blackHeight!0 (left!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!884 () Bool)

(assert (=> b!884 (= e!503 call!155)))

(declare-fun b!885 () Bool)

(assert (=> b!885 (= e!502 e!503)))

(declare-fun c!227 () Bool)

(assert (=> b!885 (= c!227 ((_ is Black!3) (color!6 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!886 () Bool)

(assert (=> b!886 (= e!502 #b00000000000000000000000000000001)))

(assert (= (and d!481 c!226) b!886))

(assert (= (and d!481 (not c!226)) b!885))

(assert (= (and b!885 c!227) b!883))

(assert (= (and b!885 (not c!227)) b!884))

(assert (= (or b!883 b!884) bm!155))

(declare-fun m!1213 () Bool)

(assert (=> bm!155 m!1213))

(assert (=> b!527 d!481))

(declare-fun d!483 () Bool)

(declare-fun c!228 () Bool)

(assert (=> d!483 (= c!228 ((_ is Empty!3) (left!8 (right!8 (left!8 lt!5)))))))

(declare-fun e!504 () (_ BitVec 32))

(assert (=> d!483 (= (blackHeight!0 (left!8 (right!8 (left!8 lt!5)))) e!504)))

(declare-fun b!887 () Bool)

(declare-fun e!505 () (_ BitVec 32))

(declare-fun call!156 () (_ BitVec 32))

(assert (=> b!887 (= e!505 (bvadd call!156 #b00000000000000000000000000000001))))

(declare-fun bm!156 () Bool)

(assert (=> bm!156 (= call!156 (blackHeight!0 (left!8 (left!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!888 () Bool)

(assert (=> b!888 (= e!505 call!156)))

(declare-fun b!889 () Bool)

(assert (=> b!889 (= e!504 e!505)))

(declare-fun c!229 () Bool)

(assert (=> b!889 (= c!229 ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!890 () Bool)

(assert (=> b!890 (= e!504 #b00000000000000000000000000000001)))

(assert (= (and d!483 c!228) b!890))

(assert (= (and d!483 (not c!228)) b!889))

(assert (= (and b!889 c!229) b!887))

(assert (= (and b!889 (not c!229)) b!888))

(assert (= (or b!887 b!888) bm!156))

(declare-fun m!1215 () Bool)

(assert (=> bm!156 m!1215))

(assert (=> bm!87 d!483))

(declare-fun d!485 () Bool)

(declare-fun c!230 () Bool)

(assert (=> d!485 (= c!230 ((_ is Empty!3) (left!8 (left!8 (left!8 t!78)))))))

(declare-fun e!506 () (_ BitVec 32))

(assert (=> d!485 (= (blackHeight!0 (left!8 (left!8 (left!8 t!78)))) e!506)))

(declare-fun b!891 () Bool)

(declare-fun e!507 () (_ BitVec 32))

(declare-fun call!157 () (_ BitVec 32))

(assert (=> b!891 (= e!507 (bvadd call!157 #b00000000000000000000000000000001))))

(declare-fun bm!157 () Bool)

(assert (=> bm!157 (= call!157 (blackHeight!0 (left!8 (left!8 (left!8 (left!8 t!78))))))))

(declare-fun b!892 () Bool)

(assert (=> b!892 (= e!507 call!157)))

(declare-fun b!893 () Bool)

(assert (=> b!893 (= e!506 e!507)))

(declare-fun c!231 () Bool)

(assert (=> b!893 (= c!231 ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 t!78))))))))

(declare-fun b!894 () Bool)

(assert (=> b!894 (= e!506 #b00000000000000000000000000000001)))

(assert (= (and d!485 c!230) b!894))

(assert (= (and d!485 (not c!230)) b!893))

(assert (= (and b!893 c!231) b!891))

(assert (= (and b!893 (not c!231)) b!892))

(assert (= (or b!891 b!892) bm!157))

(declare-fun m!1217 () Bool)

(assert (=> bm!157 m!1217))

(assert (=> bm!84 d!485))

(declare-fun b!895 () Bool)

(declare-fun res!511 () Bool)

(declare-fun call!159 () Bool)

(assert (=> b!895 (= res!511 call!159)))

(declare-fun e!510 () Bool)

(assert (=> b!895 (=> (not res!511) (not e!510))))

(declare-fun d!487 () Bool)

(declare-fun res!509 () Bool)

(declare-fun e!511 () Bool)

(assert (=> d!487 (=> res!509 e!511)))

(assert (=> d!487 (= res!509 ((_ is Empty!3) (right!8 lt!19)))))

(assert (=> d!487 (= (redNodesHaveBlackChildren!0 (right!8 lt!19)) e!511)))

(declare-fun b!896 () Bool)

(declare-fun call!158 () Bool)

(assert (=> b!896 (= e!510 call!158)))

(declare-fun bm!158 () Bool)

(assert (=> bm!158 (= call!159 (redNodesHaveBlackChildren!0 (left!8 (right!8 lt!19))))))

(declare-fun bm!159 () Bool)

(assert (=> bm!159 (= call!158 (redNodesHaveBlackChildren!0 (right!8 (right!8 lt!19))))))

(declare-fun b!897 () Bool)

(declare-fun res!510 () Bool)

(assert (=> b!897 (= res!510 (isBlack!0 (right!8 (right!8 lt!19))))))

(assert (=> b!897 (=> (not res!510) (not e!510))))

(declare-fun b!898 () Bool)

(declare-fun e!509 () Bool)

(assert (=> b!898 (= e!509 call!158)))

(declare-fun b!899 () Bool)

(declare-fun e!508 () Bool)

(assert (=> b!899 (= e!508 e!510)))

(declare-fun res!507 () Bool)

(assert (=> b!899 (= res!507 (isBlack!0 (left!8 (right!8 lt!19))))))

(assert (=> b!899 (=> (not res!507) (not e!510))))

(declare-fun b!900 () Bool)

(assert (=> b!900 (= e!511 e!508)))

(declare-fun c!232 () Bool)

(assert (=> b!900 (= c!232 ((_ is Black!3) (color!6 (right!8 lt!19))))))

(declare-fun b!901 () Bool)

(assert (=> b!901 (= e!508 e!509)))

(declare-fun res!508 () Bool)

(assert (=> b!901 (= res!508 call!159)))

(assert (=> b!901 (=> (not res!508) (not e!509))))

(assert (= (and d!487 (not res!509)) b!900))

(assert (= (and b!900 c!232) b!901))

(assert (= (and b!900 (not c!232)) b!899))

(assert (= (and b!901 res!508) b!898))

(assert (= (and b!899 res!507) b!897))

(assert (= (and b!897 res!510) b!895))

(assert (= (and b!895 res!511) b!896))

(assert (= (or b!901 b!895) bm!158))

(assert (= (or b!898 b!896) bm!159))

(declare-fun m!1219 () Bool)

(assert (=> bm!158 m!1219))

(declare-fun m!1221 () Bool)

(assert (=> bm!159 m!1221))

(declare-fun m!1223 () Bool)

(assert (=> b!897 m!1223))

(declare-fun m!1225 () Bool)

(assert (=> b!899 m!1225))

(assert (=> b!705 d!487))

(declare-fun b!902 () Bool)

(declare-fun res!516 () Bool)

(declare-fun call!161 () Bool)

(assert (=> b!902 (= res!516 call!161)))

(declare-fun e!514 () Bool)

(assert (=> b!902 (=> (not res!516) (not e!514))))

(declare-fun d!489 () Bool)

(declare-fun res!514 () Bool)

(declare-fun e!515 () Bool)

(assert (=> d!489 (=> res!514 e!515)))

(assert (=> d!489 (= res!514 ((_ is Empty!3) (left!8 (left!8 (right!8 lt!5)))))))

(assert (=> d!489 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 lt!5)))) e!515)))

(declare-fun b!903 () Bool)

(declare-fun call!160 () Bool)

(assert (=> b!903 (= e!514 call!160)))

(declare-fun bm!160 () Bool)

(assert (=> bm!160 (= call!161 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (right!8 lt!5))))))))

(declare-fun bm!161 () Bool)

(assert (=> bm!161 (= call!160 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!904 () Bool)

(declare-fun res!515 () Bool)

(assert (=> b!904 (= res!515 (isBlack!0 (right!8 (left!8 (left!8 (right!8 lt!5))))))))

(assert (=> b!904 (=> (not res!515) (not e!514))))

(declare-fun b!905 () Bool)

(declare-fun e!513 () Bool)

(assert (=> b!905 (= e!513 call!160)))

(declare-fun b!906 () Bool)

(declare-fun e!512 () Bool)

(assert (=> b!906 (= e!512 e!514)))

(declare-fun res!512 () Bool)

(assert (=> b!906 (= res!512 (isBlack!0 (left!8 (left!8 (left!8 (right!8 lt!5))))))))

(assert (=> b!906 (=> (not res!512) (not e!514))))

(declare-fun b!907 () Bool)

(assert (=> b!907 (= e!515 e!512)))

(declare-fun c!233 () Bool)

(assert (=> b!907 (= c!233 ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!908 () Bool)

(assert (=> b!908 (= e!512 e!513)))

(declare-fun res!513 () Bool)

(assert (=> b!908 (= res!513 call!161)))

(assert (=> b!908 (=> (not res!513) (not e!513))))

(assert (= (and d!489 (not res!514)) b!907))

(assert (= (and b!907 c!233) b!908))

(assert (= (and b!907 (not c!233)) b!906))

(assert (= (and b!908 res!513) b!905))

(assert (= (and b!906 res!512) b!904))

(assert (= (and b!904 res!515) b!902))

(assert (= (and b!902 res!516) b!903))

(assert (= (or b!908 b!902) bm!160))

(assert (= (or b!905 b!903) bm!161))

(declare-fun m!1227 () Bool)

(assert (=> bm!160 m!1227))

(declare-fun m!1229 () Bool)

(assert (=> bm!161 m!1229))

(declare-fun m!1231 () Bool)

(assert (=> b!904 m!1231))

(declare-fun m!1233 () Bool)

(assert (=> b!906 m!1233))

(assert (=> bm!102 d!489))

(declare-fun d!491 () Bool)

(declare-fun res!517 () Bool)

(declare-fun e!516 () Bool)

(assert (=> d!491 (=> res!517 e!516)))

(assert (=> d!491 (= res!517 (not ((_ is Node!3) (left!8 (right!8 (left!8 t!78))))))))

(assert (=> d!491 (= (blackBalanced!0 (left!8 (right!8 (left!8 t!78)))) e!516)))

(declare-fun b!909 () Bool)

(declare-fun e!517 () Bool)

(assert (=> b!909 (= e!516 e!517)))

(declare-fun res!519 () Bool)

(assert (=> b!909 (=> (not res!519) (not e!517))))

(assert (=> b!909 (= res!519 (blackBalanced!0 (left!8 (left!8 (right!8 (left!8 t!78))))))))

(declare-fun b!910 () Bool)

(declare-fun res!518 () Bool)

(assert (=> b!910 (=> (not res!518) (not e!517))))

(assert (=> b!910 (= res!518 (blackBalanced!0 (right!8 (left!8 (right!8 (left!8 t!78))))))))

(declare-fun b!911 () Bool)

(assert (=> b!911 (= e!517 (= (blackHeight!0 (left!8 (left!8 (right!8 (left!8 t!78))))) (blackHeight!0 (right!8 (left!8 (right!8 (left!8 t!78)))))))))

(assert (= (and d!491 (not res!517)) b!909))

(assert (= (and b!909 res!519) b!910))

(assert (= (and b!910 res!518) b!911))

(declare-fun m!1235 () Bool)

(assert (=> b!909 m!1235))

(declare-fun m!1237 () Bool)

(assert (=> b!910 m!1237))

(declare-fun m!1239 () Bool)

(assert (=> b!911 m!1239))

(declare-fun m!1241 () Bool)

(assert (=> b!911 m!1241))

(assert (=> b!755 d!491))

(declare-fun d!493 () Bool)

(declare-fun c!234 () Bool)

(assert (=> d!493 (= c!234 ((_ is Empty!3) (left!8 (left!8 (right!8 lt!5)))))))

(declare-fun e!518 () (InoxSet (_ BitVec 32)))

(assert (=> d!493 (= (content!0 (left!8 (left!8 (right!8 lt!5)))) e!518)))

(declare-fun b!912 () Bool)

(assert (=> b!912 (= e!518 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!913 () Bool)

(assert (=> b!913 (= e!518 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (right!8 lt!5))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (right!8 lt!5)))) true)) (content!0 (right!8 (left!8 (left!8 (right!8 lt!5)))))))))

(assert (= (and d!493 c!234) b!912))

(assert (= (and d!493 (not c!234)) b!913))

(declare-fun m!1243 () Bool)

(assert (=> b!913 m!1243))

(declare-fun m!1245 () Bool)

(assert (=> b!913 m!1245))

(declare-fun m!1247 () Bool)

(assert (=> b!913 m!1247))

(assert (=> b!711 d!493))

(declare-fun d!495 () Bool)

(declare-fun c!235 () Bool)

(assert (=> d!495 (= c!235 ((_ is Empty!3) (right!8 (left!8 (right!8 lt!5)))))))

(declare-fun e!519 () (InoxSet (_ BitVec 32)))

(assert (=> d!495 (= (content!0 (right!8 (left!8 (right!8 lt!5)))) e!519)))

(declare-fun b!914 () Bool)

(assert (=> b!914 (= e!519 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!915 () Bool)

(assert (=> b!915 (= e!519 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (right!8 lt!5))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (right!8 lt!5)))) true)) (content!0 (right!8 (right!8 (left!8 (right!8 lt!5)))))))))

(assert (= (and d!495 c!235) b!914))

(assert (= (and d!495 (not c!235)) b!915))

(declare-fun m!1249 () Bool)

(assert (=> b!915 m!1249))

(declare-fun m!1251 () Bool)

(assert (=> b!915 m!1251))

(declare-fun m!1253 () Bool)

(assert (=> b!915 m!1253))

(assert (=> b!711 d!495))

(declare-fun d!497 () Bool)

(declare-fun res!520 () Bool)

(declare-fun e!520 () Bool)

(assert (=> d!497 (=> res!520 e!520)))

(assert (=> d!497 (= res!520 (not ((_ is Node!3) (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> d!497 (= (blackBalanced!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!520)))

(declare-fun b!916 () Bool)

(declare-fun e!521 () Bool)

(assert (=> b!916 (= e!520 e!521)))

(declare-fun res!522 () Bool)

(assert (=> b!916 (=> (not res!522) (not e!521))))

(assert (=> b!916 (= res!522 (blackBalanced!0 (left!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!917 () Bool)

(declare-fun res!521 () Bool)

(assert (=> b!917 (=> (not res!521) (not e!521))))

(assert (=> b!917 (= res!521 (blackBalanced!0 (right!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!918 () Bool)

(assert (=> b!918 (= e!521 (= (blackHeight!0 (left!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (blackHeight!0 (right!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!497 (not res!520)) b!916))

(assert (= (and b!916 res!522) b!917))

(assert (= (and b!917 res!521) b!918))

(declare-fun m!1255 () Bool)

(assert (=> b!916 m!1255))

(declare-fun m!1257 () Bool)

(assert (=> b!917 m!1257))

(declare-fun m!1259 () Bool)

(assert (=> b!918 m!1259))

(declare-fun m!1261 () Bool)

(assert (=> b!918 m!1261))

(assert (=> b!794 d!497))

(declare-fun b!919 () Bool)

(declare-fun res!527 () Bool)

(declare-fun call!163 () Bool)

(assert (=> b!919 (= res!527 call!163)))

(declare-fun e!524 () Bool)

(assert (=> b!919 (=> (not res!527) (not e!524))))

(declare-fun d!499 () Bool)

(declare-fun res!525 () Bool)

(declare-fun e!525 () Bool)

(assert (=> d!499 (=> res!525 e!525)))

(assert (=> d!499 (= res!525 ((_ is Empty!3) (right!8 (left!8 (left!8 lt!5)))))))

(assert (=> d!499 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 lt!5)))) e!525)))

(declare-fun b!920 () Bool)

(declare-fun call!162 () Bool)

(assert (=> b!920 (= e!524 call!162)))

(declare-fun bm!162 () Bool)

(assert (=> bm!162 (= call!163 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (left!8 lt!5))))))))

(declare-fun bm!163 () Bool)

(assert (=> bm!163 (= call!162 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!921 () Bool)

(declare-fun res!526 () Bool)

(assert (=> b!921 (= res!526 (isBlack!0 (right!8 (right!8 (left!8 (left!8 lt!5))))))))

(assert (=> b!921 (=> (not res!526) (not e!524))))

(declare-fun b!922 () Bool)

(declare-fun e!523 () Bool)

(assert (=> b!922 (= e!523 call!162)))

(declare-fun b!923 () Bool)

(declare-fun e!522 () Bool)

(assert (=> b!923 (= e!522 e!524)))

(declare-fun res!523 () Bool)

(assert (=> b!923 (= res!523 (isBlack!0 (left!8 (right!8 (left!8 (left!8 lt!5))))))))

(assert (=> b!923 (=> (not res!523) (not e!524))))

(declare-fun b!924 () Bool)

(assert (=> b!924 (= e!525 e!522)))

(declare-fun c!236 () Bool)

(assert (=> b!924 (= c!236 ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!925 () Bool)

(assert (=> b!925 (= e!522 e!523)))

(declare-fun res!524 () Bool)

(assert (=> b!925 (= res!524 call!163)))

(assert (=> b!925 (=> (not res!524) (not e!523))))

(assert (= (and d!499 (not res!525)) b!924))

(assert (= (and b!924 c!236) b!925))

(assert (= (and b!924 (not c!236)) b!923))

(assert (= (and b!925 res!524) b!922))

(assert (= (and b!923 res!523) b!921))

(assert (= (and b!921 res!526) b!919))

(assert (= (and b!919 res!527) b!920))

(assert (= (or b!925 b!919) bm!162))

(assert (= (or b!922 b!920) bm!163))

(declare-fun m!1263 () Bool)

(assert (=> bm!162 m!1263))

(declare-fun m!1265 () Bool)

(assert (=> bm!163 m!1265))

(declare-fun m!1267 () Bool)

(assert (=> b!921 m!1267))

(declare-fun m!1269 () Bool)

(assert (=> b!923 m!1269))

(assert (=> bm!89 d!499))

(declare-fun d!501 () Bool)

(declare-fun res!528 () Bool)

(declare-fun e!526 () Bool)

(assert (=> d!501 (=> res!528 e!526)))

(assert (=> d!501 (= res!528 (not ((_ is Node!3) (right!8 (right!8 (left!8 lt!5))))))))

(assert (=> d!501 (= (blackBalanced!0 (right!8 (right!8 (left!8 lt!5)))) e!526)))

(declare-fun b!926 () Bool)

(declare-fun e!527 () Bool)

(assert (=> b!926 (= e!526 e!527)))

(declare-fun res!530 () Bool)

(assert (=> b!926 (=> (not res!530) (not e!527))))

(assert (=> b!926 (= res!530 (blackBalanced!0 (left!8 (right!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!927 () Bool)

(declare-fun res!529 () Bool)

(assert (=> b!927 (=> (not res!529) (not e!527))))

(assert (=> b!927 (= res!529 (blackBalanced!0 (right!8 (right!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!928 () Bool)

(assert (=> b!928 (= e!527 (= (blackHeight!0 (left!8 (right!8 (right!8 (left!8 lt!5))))) (blackHeight!0 (right!8 (right!8 (right!8 (left!8 lt!5)))))))))

(assert (= (and d!501 (not res!528)) b!926))

(assert (= (and b!926 res!530) b!927))

(assert (= (and b!927 res!529) b!928))

(declare-fun m!1271 () Bool)

(assert (=> b!926 m!1271))

(declare-fun m!1273 () Bool)

(assert (=> b!927 m!1273))

(declare-fun m!1275 () Bool)

(assert (=> b!928 m!1275))

(declare-fun m!1277 () Bool)

(assert (=> b!928 m!1277))

(assert (=> b!801 d!501))

(declare-fun d!503 () Bool)

(assert (=> d!503 (= (isBlack!0 (left!8 (right!8 (right!8 (left!8 t!78))))) (or ((_ is Empty!3) (left!8 (right!8 (right!8 (left!8 t!78))))) ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 (left!8 t!78))))))))))

(assert (=> b!779 d!503))

(declare-fun d!505 () Bool)

(declare-fun res!531 () Bool)

(declare-fun e!528 () Bool)

(assert (=> d!505 (=> res!531 e!528)))

(assert (=> d!505 (= res!531 (not ((_ is Node!3) (left!8 (left!8 (right!8 t!78))))))))

(assert (=> d!505 (= (blackBalanced!0 (left!8 (left!8 (right!8 t!78)))) e!528)))

(declare-fun b!929 () Bool)

(declare-fun e!529 () Bool)

(assert (=> b!929 (= e!528 e!529)))

(declare-fun res!533 () Bool)

(assert (=> b!929 (=> (not res!533) (not e!529))))

(assert (=> b!929 (= res!533 (blackBalanced!0 (left!8 (left!8 (left!8 (right!8 t!78))))))))

(declare-fun b!930 () Bool)

(declare-fun res!532 () Bool)

(assert (=> b!930 (=> (not res!532) (not e!529))))

(assert (=> b!930 (= res!532 (blackBalanced!0 (right!8 (left!8 (left!8 (right!8 t!78))))))))

(declare-fun b!931 () Bool)

(assert (=> b!931 (= e!529 (= (blackHeight!0 (left!8 (left!8 (left!8 (right!8 t!78))))) (blackHeight!0 (right!8 (left!8 (left!8 (right!8 t!78)))))))))

(assert (= (and d!505 (not res!531)) b!929))

(assert (= (and b!929 res!533) b!930))

(assert (= (and b!930 res!532) b!931))

(declare-fun m!1279 () Bool)

(assert (=> b!929 m!1279))

(declare-fun m!1281 () Bool)

(assert (=> b!930 m!1281))

(declare-fun m!1283 () Bool)

(assert (=> b!931 m!1283))

(declare-fun m!1285 () Bool)

(assert (=> b!931 m!1285))

(assert (=> b!829 d!505))

(declare-fun b!932 () Bool)

(declare-fun res!538 () Bool)

(declare-fun call!165 () Bool)

(assert (=> b!932 (= res!538 call!165)))

(declare-fun e!532 () Bool)

(assert (=> b!932 (=> (not res!538) (not e!532))))

(declare-fun d!507 () Bool)

(declare-fun res!536 () Bool)

(declare-fun e!533 () Bool)

(assert (=> d!507 (=> res!536 e!533)))

(assert (=> d!507 (= res!536 ((_ is Empty!3) (right!8 (left!8 (right!8 (right!8 t!78))))))))

(assert (=> d!507 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (right!8 t!78))))) e!533)))

(declare-fun b!933 () Bool)

(declare-fun call!164 () Bool)

(assert (=> b!933 (= e!532 call!164)))

(declare-fun bm!164 () Bool)

(assert (=> bm!164 (= call!165 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (right!8 (right!8 t!78)))))))))

(declare-fun bm!165 () Bool)

(assert (=> bm!165 (= call!164 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (right!8 (right!8 t!78)))))))))

(declare-fun b!934 () Bool)

(declare-fun res!537 () Bool)

(assert (=> b!934 (= res!537 (isBlack!0 (right!8 (right!8 (left!8 (right!8 (right!8 t!78)))))))))

(assert (=> b!934 (=> (not res!537) (not e!532))))

(declare-fun b!935 () Bool)

(declare-fun e!531 () Bool)

(assert (=> b!935 (= e!531 call!164)))

(declare-fun b!936 () Bool)

(declare-fun e!530 () Bool)

(assert (=> b!936 (= e!530 e!532)))

(declare-fun res!534 () Bool)

(assert (=> b!936 (= res!534 (isBlack!0 (left!8 (right!8 (left!8 (right!8 (right!8 t!78)))))))))

(assert (=> b!936 (=> (not res!534) (not e!532))))

(declare-fun b!937 () Bool)

(assert (=> b!937 (= e!533 e!530)))

(declare-fun c!237 () Bool)

(assert (=> b!937 (= c!237 ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 (right!8 t!78)))))))))

(declare-fun b!938 () Bool)

(assert (=> b!938 (= e!530 e!531)))

(declare-fun res!535 () Bool)

(assert (=> b!938 (= res!535 call!165)))

(assert (=> b!938 (=> (not res!535) (not e!531))))

(assert (= (and d!507 (not res!536)) b!937))

(assert (= (and b!937 c!237) b!938))

(assert (= (and b!937 (not c!237)) b!936))

(assert (= (and b!938 res!535) b!935))

(assert (= (and b!936 res!534) b!934))

(assert (= (and b!934 res!537) b!932))

(assert (= (and b!932 res!538) b!933))

(assert (= (or b!938 b!932) bm!164))

(assert (= (or b!935 b!933) bm!165))

(declare-fun m!1287 () Bool)

(assert (=> bm!164 m!1287))

(declare-fun m!1289 () Bool)

(assert (=> bm!165 m!1289))

(declare-fun m!1291 () Bool)

(assert (=> b!934 m!1291))

(declare-fun m!1293 () Bool)

(assert (=> b!936 m!1293))

(assert (=> bm!141 d!507))

(declare-fun b!939 () Bool)

(declare-fun res!543 () Bool)

(declare-fun call!167 () Bool)

(assert (=> b!939 (= res!543 call!167)))

(declare-fun e!536 () Bool)

(assert (=> b!939 (=> (not res!543) (not e!536))))

(declare-fun d!509 () Bool)

(declare-fun res!541 () Bool)

(declare-fun e!537 () Bool)

(assert (=> d!509 (=> res!541 e!537)))

(assert (=> d!509 (= res!541 ((_ is Empty!3) (right!8 (left!8 (left!8 (right!8 lt!2))))))))

(assert (=> d!509 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (right!8 lt!2))))) e!537)))

(declare-fun b!940 () Bool)

(declare-fun call!166 () Bool)

(assert (=> b!940 (= e!536 call!166)))

(declare-fun bm!166 () Bool)

(assert (=> bm!166 (= call!167 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (left!8 (right!8 lt!2)))))))))

(declare-fun bm!167 () Bool)

(assert (=> bm!167 (= call!166 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (left!8 (right!8 lt!2)))))))))

(declare-fun b!941 () Bool)

(declare-fun res!542 () Bool)

(assert (=> b!941 (= res!542 (isBlack!0 (right!8 (right!8 (left!8 (left!8 (right!8 lt!2)))))))))

(assert (=> b!941 (=> (not res!542) (not e!536))))

(declare-fun b!942 () Bool)

(declare-fun e!535 () Bool)

(assert (=> b!942 (= e!535 call!166)))

(declare-fun b!943 () Bool)

(declare-fun e!534 () Bool)

(assert (=> b!943 (= e!534 e!536)))

(declare-fun res!539 () Bool)

(assert (=> b!943 (= res!539 (isBlack!0 (left!8 (right!8 (left!8 (left!8 (right!8 lt!2)))))))))

(assert (=> b!943 (=> (not res!539) (not e!536))))

(declare-fun b!944 () Bool)

(assert (=> b!944 (= e!537 e!534)))

(declare-fun c!238 () Bool)

(assert (=> b!944 (= c!238 ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 (right!8 lt!2)))))))))

(declare-fun b!945 () Bool)

(assert (=> b!945 (= e!534 e!535)))

(declare-fun res!540 () Bool)

(assert (=> b!945 (= res!540 call!167)))

(assert (=> b!945 (=> (not res!540) (not e!535))))

(assert (= (and d!509 (not res!541)) b!944))

(assert (= (and b!944 c!238) b!945))

(assert (= (and b!944 (not c!238)) b!943))

(assert (= (and b!945 res!540) b!942))

(assert (= (and b!943 res!539) b!941))

(assert (= (and b!941 res!542) b!939))

(assert (= (and b!939 res!543) b!940))

(assert (= (or b!945 b!939) bm!166))

(assert (= (or b!942 b!940) bm!167))

(declare-fun m!1295 () Bool)

(assert (=> bm!166 m!1295))

(declare-fun m!1297 () Bool)

(assert (=> bm!167 m!1297))

(declare-fun m!1299 () Bool)

(assert (=> b!941 m!1299))

(declare-fun m!1301 () Bool)

(assert (=> b!943 m!1301))

(assert (=> bm!121 d!509))

(declare-fun d!511 () Bool)

(declare-fun lt!40 () Int)

(assert (=> d!511 (>= lt!40 0)))

(declare-fun e!538 () Int)

(assert (=> d!511 (= lt!40 e!538)))

(declare-fun c!239 () Bool)

(assert (=> d!511 (= c!239 ((_ is Empty!3) (left!8 lt!19)))))

(assert (=> d!511 (= (size!0 (left!8 lt!19)) lt!40)))

(declare-fun b!946 () Bool)

(assert (=> b!946 (= e!538 0)))

(declare-fun b!947 () Bool)

(assert (=> b!947 (= e!538 (+ (size!0 (left!8 (left!8 lt!19))) 1 (size!0 (right!8 (left!8 lt!19)))))))

(assert (= (and d!511 c!239) b!946))

(assert (= (and d!511 (not c!239)) b!947))

(declare-fun m!1303 () Bool)

(assert (=> b!947 m!1303))

(declare-fun m!1305 () Bool)

(assert (=> b!947 m!1305))

(assert (=> b!715 d!511))

(declare-fun d!513 () Bool)

(declare-fun lt!41 () Int)

(assert (=> d!513 (>= lt!41 0)))

(declare-fun e!539 () Int)

(assert (=> d!513 (= lt!41 e!539)))

(declare-fun c!240 () Bool)

(assert (=> d!513 (= c!240 ((_ is Empty!3) (right!8 lt!19)))))

(assert (=> d!513 (= (size!0 (right!8 lt!19)) lt!41)))

(declare-fun b!948 () Bool)

(assert (=> b!948 (= e!539 0)))

(declare-fun b!949 () Bool)

(assert (=> b!949 (= e!539 (+ (size!0 (left!8 (right!8 lt!19))) 1 (size!0 (right!8 (right!8 lt!19)))))))

(assert (= (and d!513 c!240) b!948))

(assert (= (and d!513 (not c!240)) b!949))

(declare-fun m!1307 () Bool)

(assert (=> b!949 m!1307))

(declare-fun m!1309 () Bool)

(assert (=> b!949 m!1309))

(assert (=> b!715 d!513))

(declare-fun d!515 () Bool)

(declare-fun c!241 () Bool)

(assert (=> d!515 (= c!241 ((_ is Empty!3) (left!8 (right!8 (right!8 (left!8 lt!2))))))))

(declare-fun e!540 () (InoxSet (_ BitVec 32)))

(assert (=> d!515 (= (content!0 (left!8 (right!8 (right!8 (left!8 lt!2))))) e!540)))

(declare-fun b!950 () Bool)

(assert (=> b!950 (= e!540 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!951 () Bool)

(assert (=> b!951 (= e!540 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (right!8 (left!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (right!8 (left!8 lt!2))))) true)) (content!0 (right!8 (left!8 (right!8 (right!8 (left!8 lt!2))))))))))

(assert (= (and d!515 c!241) b!950))

(assert (= (and d!515 (not c!241)) b!951))

(declare-fun m!1311 () Bool)

(assert (=> b!951 m!1311))

(declare-fun m!1313 () Bool)

(assert (=> b!951 m!1313))

(declare-fun m!1315 () Bool)

(assert (=> b!951 m!1315))

(assert (=> b!490 d!515))

(declare-fun d!517 () Bool)

(declare-fun c!242 () Bool)

(assert (=> d!517 (= c!242 ((_ is Empty!3) (right!8 (right!8 (right!8 (left!8 lt!2))))))))

(declare-fun e!541 () (InoxSet (_ BitVec 32)))

(assert (=> d!517 (= (content!0 (right!8 (right!8 (right!8 (left!8 lt!2))))) e!541)))

(declare-fun b!952 () Bool)

(assert (=> b!952 (= e!541 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!953 () Bool)

(assert (=> b!953 (= e!541 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (right!8 (left!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (right!8 (left!8 lt!2))))) true)) (content!0 (right!8 (right!8 (right!8 (right!8 (left!8 lt!2))))))))))

(assert (= (and d!517 c!242) b!952))

(assert (= (and d!517 (not c!242)) b!953))

(declare-fun m!1317 () Bool)

(assert (=> b!953 m!1317))

(declare-fun m!1319 () Bool)

(assert (=> b!953 m!1319))

(declare-fun m!1321 () Bool)

(assert (=> b!953 m!1321))

(assert (=> b!490 d!517))

(declare-fun d!519 () Bool)

(assert (=> d!519 (= (isBlack!0 (left!8 (right!8 (right!8 (left!8 lt!2))))) (or ((_ is Empty!3) (left!8 (right!8 (right!8 (left!8 lt!2))))) ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 (left!8 lt!2))))))))))

(assert (=> b!684 d!519))

(declare-fun d!521 () Bool)

(declare-fun lt!42 () Int)

(assert (=> d!521 (>= lt!42 0)))

(declare-fun e!542 () Int)

(assert (=> d!521 (= lt!42 e!542)))

(declare-fun c!243 () Bool)

(assert (=> d!521 (= c!243 ((_ is Empty!3) (left!8 (right!8 (left!8 t!78)))))))

(assert (=> d!521 (= (size!0 (left!8 (right!8 (left!8 t!78)))) lt!42)))

(declare-fun b!954 () Bool)

(assert (=> b!954 (= e!542 0)))

(declare-fun b!955 () Bool)

(assert (=> b!955 (= e!542 (+ (size!0 (left!8 (left!8 (right!8 (left!8 t!78))))) 1 (size!0 (right!8 (left!8 (right!8 (left!8 t!78)))))))))

(assert (= (and d!521 c!243) b!954))

(assert (= (and d!521 (not c!243)) b!955))

(declare-fun m!1323 () Bool)

(assert (=> b!955 m!1323))

(declare-fun m!1325 () Bool)

(assert (=> b!955 m!1325))

(assert (=> b!517 d!521))

(declare-fun d!523 () Bool)

(declare-fun lt!43 () Int)

(assert (=> d!523 (>= lt!43 0)))

(declare-fun e!543 () Int)

(assert (=> d!523 (= lt!43 e!543)))

(declare-fun c!244 () Bool)

(assert (=> d!523 (= c!244 ((_ is Empty!3) (right!8 (right!8 (left!8 t!78)))))))

(assert (=> d!523 (= (size!0 (right!8 (right!8 (left!8 t!78)))) lt!43)))

(declare-fun b!956 () Bool)

(assert (=> b!956 (= e!543 0)))

(declare-fun b!957 () Bool)

(assert (=> b!957 (= e!543 (+ (size!0 (left!8 (right!8 (right!8 (left!8 t!78))))) 1 (size!0 (right!8 (right!8 (right!8 (left!8 t!78)))))))))

(assert (= (and d!523 c!244) b!956))

(assert (= (and d!523 (not c!244)) b!957))

(declare-fun m!1327 () Bool)

(assert (=> b!957 m!1327))

(declare-fun m!1329 () Bool)

(assert (=> b!957 m!1329))

(assert (=> b!517 d!523))

(declare-fun d!525 () Bool)

(declare-fun lt!44 () Int)

(assert (=> d!525 (>= lt!44 0)))

(declare-fun e!544 () Int)

(assert (=> d!525 (= lt!44 e!544)))

(declare-fun c!245 () Bool)

(assert (=> d!525 (= c!245 ((_ is Empty!3) (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!525 (= (size!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) lt!44)))

(declare-fun b!958 () Bool)

(assert (=> b!958 (= e!544 0)))

(declare-fun b!959 () Bool)

(assert (=> b!959 (= e!544 (+ (size!0 (left!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) 1 (size!0 (right!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!525 c!245) b!958))

(assert (= (and d!525 (not c!245)) b!959))

(declare-fun m!1331 () Bool)

(assert (=> b!959 m!1331))

(declare-fun m!1333 () Bool)

(assert (=> b!959 m!1333))

(assert (=> b!465 d!525))

(declare-fun d!527 () Bool)

(declare-fun lt!45 () Int)

(assert (=> d!527 (>= lt!45 0)))

(declare-fun e!545 () Int)

(assert (=> d!527 (= lt!45 e!545)))

(declare-fun c!246 () Bool)

(assert (=> d!527 (= c!246 ((_ is Empty!3) (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!527 (= (size!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) lt!45)))

(declare-fun b!960 () Bool)

(assert (=> b!960 (= e!545 0)))

(declare-fun b!961 () Bool)

(assert (=> b!961 (= e!545 (+ (size!0 (left!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) 1 (size!0 (right!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!527 c!246) b!960))

(assert (= (and d!527 (not c!246)) b!961))

(declare-fun m!1335 () Bool)

(assert (=> b!961 m!1335))

(declare-fun m!1337 () Bool)

(assert (=> b!961 m!1337))

(assert (=> b!465 d!527))

(declare-fun d!529 () Bool)

(declare-fun res!544 () Bool)

(declare-fun e!546 () Bool)

(assert (=> d!529 (=> res!544 e!546)))

(assert (=> d!529 (= res!544 (not ((_ is Node!3) (right!8 (left!8 (left!8 t!78))))))))

(assert (=> d!529 (= (blackBalanced!0 (right!8 (left!8 (left!8 t!78)))) e!546)))

(declare-fun b!962 () Bool)

(declare-fun e!547 () Bool)

(assert (=> b!962 (= e!546 e!547)))

(declare-fun res!546 () Bool)

(assert (=> b!962 (=> (not res!546) (not e!547))))

(assert (=> b!962 (= res!546 (blackBalanced!0 (left!8 (right!8 (left!8 (left!8 t!78))))))))

(declare-fun b!963 () Bool)

(declare-fun res!545 () Bool)

(assert (=> b!963 (=> (not res!545) (not e!547))))

(assert (=> b!963 (= res!545 (blackBalanced!0 (right!8 (right!8 (left!8 (left!8 t!78))))))))

(declare-fun b!964 () Bool)

(assert (=> b!964 (= e!547 (= (blackHeight!0 (left!8 (right!8 (left!8 (left!8 t!78))))) (blackHeight!0 (right!8 (right!8 (left!8 (left!8 t!78)))))))))

(assert (= (and d!529 (not res!544)) b!962))

(assert (= (and b!962 res!546) b!963))

(assert (= (and b!963 res!545) b!964))

(declare-fun m!1339 () Bool)

(assert (=> b!962 m!1339))

(declare-fun m!1341 () Bool)

(assert (=> b!963 m!1341))

(declare-fun m!1343 () Bool)

(assert (=> b!964 m!1343))

(declare-fun m!1345 () Bool)

(assert (=> b!964 m!1345))

(assert (=> b!671 d!529))

(declare-fun d!531 () Bool)

(assert (=> d!531 (= (isBlack!0 (right!8 (left!8 (right!8 (left!8 lt!2))))) (or ((_ is Empty!3) (right!8 (left!8 (right!8 (left!8 lt!2))))) ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 (left!8 lt!2))))))))))

(assert (=> b!629 d!531))

(declare-fun d!533 () Bool)

(assert (=> d!533 (= (isBlack!0 (right!8 (right!8 (left!8 (right!8 t!78))))) (or ((_ is Empty!3) (right!8 (right!8 (left!8 (right!8 t!78))))) ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 (right!8 t!78))))))))))

(assert (=> b!770 d!533))

(declare-fun d!535 () Bool)

(declare-fun c!247 () Bool)

(assert (=> d!535 (= c!247 ((_ is Empty!3) (left!8 (right!8 (right!8 lt!5)))))))

(declare-fun e!548 () (_ BitVec 32))

(assert (=> d!535 (= (blackHeight!0 (left!8 (right!8 (right!8 lt!5)))) e!548)))

(declare-fun b!965 () Bool)

(declare-fun e!549 () (_ BitVec 32))

(declare-fun call!168 () (_ BitVec 32))

(assert (=> b!965 (= e!549 (bvadd call!168 #b00000000000000000000000000000001))))

(declare-fun bm!168 () Bool)

(assert (=> bm!168 (= call!168 (blackHeight!0 (left!8 (left!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!966 () Bool)

(assert (=> b!966 (= e!549 call!168)))

(declare-fun b!967 () Bool)

(assert (=> b!967 (= e!548 e!549)))

(declare-fun c!248 () Bool)

(assert (=> b!967 (= c!248 ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!968 () Bool)

(assert (=> b!968 (= e!548 #b00000000000000000000000000000001)))

(assert (= (and d!535 c!247) b!968))

(assert (= (and d!535 (not c!247)) b!967))

(assert (= (and b!967 c!248) b!965))

(assert (= (and b!967 (not c!248)) b!966))

(assert (= (or b!965 b!966) bm!168))

(declare-fun m!1347 () Bool)

(assert (=> bm!168 m!1347))

(assert (=> bm!99 d!535))

(declare-fun d!537 () Bool)

(assert (=> d!537 (= (isBlack!0 (left!8 (right!8 (right!8 (right!8 lt!2))))) (or ((_ is Empty!3) (left!8 (right!8 (right!8 (right!8 lt!2))))) ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 (right!8 lt!2))))))))))

(assert (=> b!660 d!537))

(declare-fun d!539 () Bool)

(assert (=> d!539 (= (isBlack!0 (left!8 (right!8 (left!8 (left!8 t!78))))) (or ((_ is Empty!3) (left!8 (right!8 (left!8 (left!8 t!78))))) ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 (left!8 t!78))))))))))

(assert (=> b!547 d!539))

(declare-fun b!969 () Bool)

(declare-fun res!551 () Bool)

(declare-fun call!170 () Bool)

(assert (=> b!969 (= res!551 call!170)))

(declare-fun e!552 () Bool)

(assert (=> b!969 (=> (not res!551) (not e!552))))

(declare-fun d!541 () Bool)

(declare-fun res!549 () Bool)

(declare-fun e!553 () Bool)

(assert (=> d!541 (=> res!549 e!553)))

(assert (=> d!541 (= res!549 ((_ is Empty!3) (right!8 (right!8 lt!13))))))

(assert (=> d!541 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 lt!13))) e!553)))

(declare-fun b!970 () Bool)

(declare-fun call!169 () Bool)

(assert (=> b!970 (= e!552 call!169)))

(declare-fun bm!169 () Bool)

(assert (=> bm!169 (= call!170 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 lt!13)))))))

(declare-fun bm!170 () Bool)

(assert (=> bm!170 (= call!169 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 lt!13)))))))

(declare-fun b!971 () Bool)

(declare-fun res!550 () Bool)

(assert (=> b!971 (= res!550 (isBlack!0 (right!8 (right!8 (right!8 lt!13)))))))

(assert (=> b!971 (=> (not res!550) (not e!552))))

(declare-fun b!972 () Bool)

(declare-fun e!551 () Bool)

(assert (=> b!972 (= e!551 call!169)))

(declare-fun b!973 () Bool)

(declare-fun e!550 () Bool)

(assert (=> b!973 (= e!550 e!552)))

(declare-fun res!547 () Bool)

(assert (=> b!973 (= res!547 (isBlack!0 (left!8 (right!8 (right!8 lt!13)))))))

(assert (=> b!973 (=> (not res!547) (not e!552))))

(declare-fun b!974 () Bool)

(assert (=> b!974 (= e!553 e!550)))

(declare-fun c!249 () Bool)

(assert (=> b!974 (= c!249 ((_ is Black!3) (color!6 (right!8 (right!8 lt!13)))))))

(declare-fun b!975 () Bool)

(assert (=> b!975 (= e!550 e!551)))

(declare-fun res!548 () Bool)

(assert (=> b!975 (= res!548 call!170)))

(assert (=> b!975 (=> (not res!548) (not e!551))))

(assert (= (and d!541 (not res!549)) b!974))

(assert (= (and b!974 c!249) b!975))

(assert (= (and b!974 (not c!249)) b!973))

(assert (= (and b!975 res!548) b!972))

(assert (= (and b!973 res!547) b!971))

(assert (= (and b!971 res!550) b!969))

(assert (= (and b!969 res!551) b!970))

(assert (= (or b!975 b!969) bm!169))

(assert (= (or b!972 b!970) bm!170))

(declare-fun m!1349 () Bool)

(assert (=> bm!169 m!1349))

(declare-fun m!1351 () Bool)

(assert (=> bm!170 m!1351))

(declare-fun m!1353 () Bool)

(assert (=> b!971 m!1353))

(declare-fun m!1355 () Bool)

(assert (=> b!973 m!1355))

(assert (=> bm!83 d!541))

(declare-fun d!543 () Bool)

(assert (=> d!543 (= (isBlack!0 (right!8 (left!8 (right!8 (right!8 t!78))))) (or ((_ is Empty!3) (right!8 (left!8 (right!8 (right!8 t!78))))) ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 (right!8 t!78))))))))))

(assert (=> b!805 d!543))

(declare-fun d!545 () Bool)

(declare-fun c!250 () Bool)

(assert (=> d!545 (= c!250 ((_ is Empty!3) (left!8 (right!8 (right!8 (right!8 lt!2))))))))

(declare-fun e!554 () (InoxSet (_ BitVec 32)))

(assert (=> d!545 (= (content!0 (left!8 (right!8 (right!8 (right!8 lt!2))))) e!554)))

(declare-fun b!976 () Bool)

(assert (=> b!976 (= e!554 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!977 () Bool)

(assert (=> b!977 (= e!554 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (right!8 (right!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (right!8 (right!8 lt!2))))) true)) (content!0 (right!8 (left!8 (right!8 (right!8 (right!8 lt!2))))))))))

(assert (= (and d!545 c!250) b!976))

(assert (= (and d!545 (not c!250)) b!977))

(declare-fun m!1357 () Bool)

(assert (=> b!977 m!1357))

(declare-fun m!1359 () Bool)

(assert (=> b!977 m!1359))

(declare-fun m!1361 () Bool)

(assert (=> b!977 m!1361))

(assert (=> b!828 d!545))

(declare-fun d!547 () Bool)

(declare-fun c!251 () Bool)

(assert (=> d!547 (= c!251 ((_ is Empty!3) (right!8 (right!8 (right!8 (right!8 lt!2))))))))

(declare-fun e!555 () (InoxSet (_ BitVec 32)))

(assert (=> d!547 (= (content!0 (right!8 (right!8 (right!8 (right!8 lt!2))))) e!555)))

(declare-fun b!978 () Bool)

(assert (=> b!978 (= e!555 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!979 () Bool)

(assert (=> b!979 (= e!555 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (right!8 (right!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (right!8 (right!8 lt!2))))) true)) (content!0 (right!8 (right!8 (right!8 (right!8 (right!8 lt!2))))))))))

(assert (= (and d!547 c!251) b!978))

(assert (= (and d!547 (not c!251)) b!979))

(declare-fun m!1363 () Bool)

(assert (=> b!979 m!1363))

(declare-fun m!1365 () Bool)

(assert (=> b!979 m!1365))

(declare-fun m!1367 () Bool)

(assert (=> b!979 m!1367))

(assert (=> b!828 d!547))

(declare-fun b!980 () Bool)

(declare-fun res!556 () Bool)

(declare-fun call!172 () Bool)

(assert (=> b!980 (= res!556 call!172)))

(declare-fun e!558 () Bool)

(assert (=> b!980 (=> (not res!556) (not e!558))))

(declare-fun d!549 () Bool)

(declare-fun res!554 () Bool)

(declare-fun e!559 () Bool)

(assert (=> d!549 (=> res!554 e!559)))

(assert (=> d!549 (= res!554 ((_ is Empty!3) (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!549 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!559)))

(declare-fun b!981 () Bool)

(declare-fun call!171 () Bool)

(assert (=> b!981 (= e!558 call!171)))

(declare-fun bm!171 () Bool)

(assert (=> bm!171 (= call!172 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun bm!172 () Bool)

(assert (=> bm!172 (= call!171 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!982 () Bool)

(declare-fun res!555 () Bool)

(assert (=> b!982 (= res!555 (isBlack!0 (right!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!982 (=> (not res!555) (not e!558))))

(declare-fun b!983 () Bool)

(declare-fun e!557 () Bool)

(assert (=> b!983 (= e!557 call!171)))

(declare-fun b!984 () Bool)

(declare-fun e!556 () Bool)

(assert (=> b!984 (= e!556 e!558)))

(declare-fun res!552 () Bool)

(assert (=> b!984 (= res!552 (isBlack!0 (left!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!984 (=> (not res!552) (not e!558))))

(declare-fun b!985 () Bool)

(assert (=> b!985 (= e!559 e!556)))

(declare-fun c!252 () Bool)

(assert (=> b!985 (= c!252 ((_ is Black!3) (color!6 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!986 () Bool)

(assert (=> b!986 (= e!556 e!557)))

(declare-fun res!553 () Bool)

(assert (=> b!986 (= res!553 call!172)))

(assert (=> b!986 (=> (not res!553) (not e!557))))

(assert (= (and d!549 (not res!554)) b!985))

(assert (= (and b!985 c!252) b!986))

(assert (= (and b!985 (not c!252)) b!984))

(assert (= (and b!986 res!553) b!983))

(assert (= (and b!984 res!552) b!982))

(assert (= (and b!982 res!555) b!980))

(assert (= (and b!980 res!556) b!981))

(assert (= (or b!986 b!980) bm!171))

(assert (= (or b!983 b!981) bm!172))

(declare-fun m!1369 () Bool)

(assert (=> bm!171 m!1369))

(declare-fun m!1371 () Bool)

(assert (=> bm!172 m!1371))

(declare-fun m!1373 () Bool)

(assert (=> b!982 m!1373))

(declare-fun m!1375 () Bool)

(assert (=> b!984 m!1375))

(assert (=> bm!95 d!549))

(declare-fun d!551 () Bool)

(declare-fun c!253 () Bool)

(assert (=> d!551 (= c!253 ((_ is Empty!3) (left!8 (left!8 (right!8 lt!5)))))))

(declare-fun e!560 () (_ BitVec 32))

(assert (=> d!551 (= (blackHeight!0 (left!8 (left!8 (right!8 lt!5)))) e!560)))

(declare-fun b!987 () Bool)

(declare-fun e!561 () (_ BitVec 32))

(declare-fun call!173 () (_ BitVec 32))

(assert (=> b!987 (= e!561 (bvadd call!173 #b00000000000000000000000000000001))))

(declare-fun bm!173 () Bool)

(assert (=> bm!173 (= call!173 (blackHeight!0 (left!8 (left!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!988 () Bool)

(assert (=> b!988 (= e!561 call!173)))

(declare-fun b!989 () Bool)

(assert (=> b!989 (= e!560 e!561)))

(declare-fun c!254 () Bool)

(assert (=> b!989 (= c!254 ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!990 () Bool)

(assert (=> b!990 (= e!560 #b00000000000000000000000000000001)))

(assert (= (and d!551 c!253) b!990))

(assert (= (and d!551 (not c!253)) b!989))

(assert (= (and b!989 c!254) b!987))

(assert (= (and b!989 (not c!254)) b!988))

(assert (= (or b!987 b!988) bm!173))

(declare-fun m!1377 () Bool)

(assert (=> bm!173 m!1377))

(assert (=> b!767 d!551))

(declare-fun d!553 () Bool)

(declare-fun c!255 () Bool)

(assert (=> d!553 (= c!255 ((_ is Empty!3) (right!8 (left!8 (right!8 lt!5)))))))

(declare-fun e!562 () (_ BitVec 32))

(assert (=> d!553 (= (blackHeight!0 (right!8 (left!8 (right!8 lt!5)))) e!562)))

(declare-fun b!991 () Bool)

(declare-fun e!563 () (_ BitVec 32))

(declare-fun call!174 () (_ BitVec 32))

(assert (=> b!991 (= e!563 (bvadd call!174 #b00000000000000000000000000000001))))

(declare-fun bm!174 () Bool)

(assert (=> bm!174 (= call!174 (blackHeight!0 (left!8 (right!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!992 () Bool)

(assert (=> b!992 (= e!563 call!174)))

(declare-fun b!993 () Bool)

(assert (=> b!993 (= e!562 e!563)))

(declare-fun c!256 () Bool)

(assert (=> b!993 (= c!256 ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!994 () Bool)

(assert (=> b!994 (= e!562 #b00000000000000000000000000000001)))

(assert (= (and d!553 c!255) b!994))

(assert (= (and d!553 (not c!255)) b!993))

(assert (= (and b!993 c!256) b!991))

(assert (= (and b!993 (not c!256)) b!992))

(assert (= (or b!991 b!992) bm!174))

(assert (=> bm!174 m!1207))

(assert (=> b!767 d!553))

(declare-fun d!555 () Bool)

(assert (=> d!555 (= (isBlack!0 (right!8 (left!8 (left!8 lt!5)))) (or ((_ is Empty!3) (right!8 (left!8 (left!8 lt!5)))) ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 lt!5)))))))))

(assert (=> b!538 d!555))

(declare-fun b!995 () Bool)

(declare-fun res!561 () Bool)

(declare-fun call!176 () Bool)

(assert (=> b!995 (= res!561 call!176)))

(declare-fun e!566 () Bool)

(assert (=> b!995 (=> (not res!561) (not e!566))))

(declare-fun d!557 () Bool)

(declare-fun res!559 () Bool)

(declare-fun e!567 () Bool)

(assert (=> d!557 (=> res!559 e!567)))

(assert (=> d!557 (= res!559 ((_ is Empty!3) (right!8 (left!8 (right!8 lt!5)))))))

(assert (=> d!557 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 lt!5)))) e!567)))

(declare-fun b!996 () Bool)

(declare-fun call!175 () Bool)

(assert (=> b!996 (= e!566 call!175)))

(declare-fun bm!175 () Bool)

(assert (=> bm!175 (= call!176 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (right!8 lt!5))))))))

(declare-fun bm!176 () Bool)

(assert (=> bm!176 (= call!175 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!997 () Bool)

(declare-fun res!560 () Bool)

(assert (=> b!997 (= res!560 (isBlack!0 (right!8 (right!8 (left!8 (right!8 lt!5))))))))

(assert (=> b!997 (=> (not res!560) (not e!566))))

(declare-fun b!998 () Bool)

(declare-fun e!565 () Bool)

(assert (=> b!998 (= e!565 call!175)))

(declare-fun b!999 () Bool)

(declare-fun e!564 () Bool)

(assert (=> b!999 (= e!564 e!566)))

(declare-fun res!557 () Bool)

(assert (=> b!999 (= res!557 (isBlack!0 (left!8 (right!8 (left!8 (right!8 lt!5))))))))

(assert (=> b!999 (=> (not res!557) (not e!566))))

(declare-fun b!1000 () Bool)

(assert (=> b!1000 (= e!567 e!564)))

(declare-fun c!257 () Bool)

(assert (=> b!1000 (= c!257 ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!1001 () Bool)

(assert (=> b!1001 (= e!564 e!565)))

(declare-fun res!558 () Bool)

(assert (=> b!1001 (= res!558 call!176)))

(assert (=> b!1001 (=> (not res!558) (not e!565))))

(assert (= (and d!557 (not res!559)) b!1000))

(assert (= (and b!1000 c!257) b!1001))

(assert (= (and b!1000 (not c!257)) b!999))

(assert (= (and b!1001 res!558) b!998))

(assert (= (and b!999 res!557) b!997))

(assert (= (and b!997 res!560) b!995))

(assert (= (and b!995 res!561) b!996))

(assert (= (or b!1001 b!995) bm!175))

(assert (= (or b!998 b!996) bm!176))

(declare-fun m!1379 () Bool)

(assert (=> bm!175 m!1379))

(declare-fun m!1381 () Bool)

(assert (=> bm!176 m!1381))

(declare-fun m!1383 () Bool)

(assert (=> b!997 m!1383))

(declare-fun m!1385 () Bool)

(assert (=> b!999 m!1385))

(assert (=> bm!103 d!557))

(declare-fun d!559 () Bool)

(declare-fun c!258 () Bool)

(assert (=> d!559 (= c!258 ((_ is Empty!3) (left!8 lt!19)))))

(declare-fun e!568 () (InoxSet (_ BitVec 32)))

(assert (=> d!559 (= (content!0 (left!8 lt!19)) e!568)))

(declare-fun b!1002 () Bool)

(assert (=> b!1002 (= e!568 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1003 () Bool)

(assert (=> b!1003 (= e!568 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 lt!19))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 lt!19)) true)) (content!0 (right!8 (left!8 lt!19)))))))

(assert (= (and d!559 c!258) b!1002))

(assert (= (and d!559 (not c!258)) b!1003))

(declare-fun m!1387 () Bool)

(assert (=> b!1003 m!1387))

(declare-fun m!1389 () Bool)

(assert (=> b!1003 m!1389))

(declare-fun m!1391 () Bool)

(assert (=> b!1003 m!1391))

(assert (=> b!783 d!559))

(declare-fun d!561 () Bool)

(declare-fun c!259 () Bool)

(assert (=> d!561 (= c!259 ((_ is Empty!3) (right!8 lt!19)))))

(declare-fun e!569 () (InoxSet (_ BitVec 32)))

(assert (=> d!561 (= (content!0 (right!8 lt!19)) e!569)))

(declare-fun b!1004 () Bool)

(assert (=> b!1004 (= e!569 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1005 () Bool)

(assert (=> b!1005 (= e!569 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 lt!19))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 lt!19)) true)) (content!0 (right!8 (right!8 lt!19)))))))

(assert (= (and d!561 c!259) b!1004))

(assert (= (and d!561 (not c!259)) b!1005))

(declare-fun m!1393 () Bool)

(assert (=> b!1005 m!1393))

(declare-fun m!1395 () Bool)

(assert (=> b!1005 m!1395))

(declare-fun m!1397 () Bool)

(assert (=> b!1005 m!1397))

(assert (=> b!783 d!561))

(declare-fun d!563 () Bool)

(assert (=> d!563 (= (isBlack!0 (left!8 (right!8 (left!8 (left!8 lt!2))))) (or ((_ is Empty!3) (left!8 (right!8 (left!8 (left!8 lt!2))))) ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 (left!8 lt!2))))))))))

(assert (=> b!568 d!563))

(assert (=> b!802 d!483))

(declare-fun d!565 () Bool)

(declare-fun c!260 () Bool)

(assert (=> d!565 (= c!260 ((_ is Empty!3) (right!8 (right!8 (left!8 lt!5)))))))

(declare-fun e!570 () (_ BitVec 32))

(assert (=> d!565 (= (blackHeight!0 (right!8 (right!8 (left!8 lt!5)))) e!570)))

(declare-fun b!1006 () Bool)

(declare-fun e!571 () (_ BitVec 32))

(declare-fun call!177 () (_ BitVec 32))

(assert (=> b!1006 (= e!571 (bvadd call!177 #b00000000000000000000000000000001))))

(declare-fun bm!177 () Bool)

(assert (=> bm!177 (= call!177 (blackHeight!0 (left!8 (right!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!1007 () Bool)

(assert (=> b!1007 (= e!571 call!177)))

(declare-fun b!1008 () Bool)

(assert (=> b!1008 (= e!570 e!571)))

(declare-fun c!261 () Bool)

(assert (=> b!1008 (= c!261 ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!1009 () Bool)

(assert (=> b!1009 (= e!570 #b00000000000000000000000000000001)))

(assert (= (and d!565 c!260) b!1009))

(assert (= (and d!565 (not c!260)) b!1008))

(assert (= (and b!1008 c!261) b!1006))

(assert (= (and b!1008 (not c!261)) b!1007))

(assert (= (or b!1006 b!1007) bm!177))

(assert (=> bm!177 m!1275))

(assert (=> b!802 d!565))

(declare-fun d!567 () Bool)

(declare-fun res!562 () Bool)

(declare-fun e!572 () Bool)

(assert (=> d!567 (=> res!562 e!572)))

(assert (=> d!567 (= res!562 (not ((_ is Node!3) (right!8 (right!8 (left!8 t!78))))))))

(assert (=> d!567 (= (blackBalanced!0 (right!8 (right!8 (left!8 t!78)))) e!572)))

(declare-fun b!1010 () Bool)

(declare-fun e!573 () Bool)

(assert (=> b!1010 (= e!572 e!573)))

(declare-fun res!564 () Bool)

(assert (=> b!1010 (=> (not res!564) (not e!573))))

(assert (=> b!1010 (= res!564 (blackBalanced!0 (left!8 (right!8 (right!8 (left!8 t!78))))))))

(declare-fun b!1011 () Bool)

(declare-fun res!563 () Bool)

(assert (=> b!1011 (=> (not res!563) (not e!573))))

(assert (=> b!1011 (= res!563 (blackBalanced!0 (right!8 (right!8 (right!8 (left!8 t!78))))))))

(declare-fun b!1012 () Bool)

(assert (=> b!1012 (= e!573 (= (blackHeight!0 (left!8 (right!8 (right!8 (left!8 t!78))))) (blackHeight!0 (right!8 (right!8 (right!8 (left!8 t!78)))))))))

(assert (= (and d!567 (not res!562)) b!1010))

(assert (= (and b!1010 res!564) b!1011))

(assert (= (and b!1011 res!563) b!1012))

(declare-fun m!1399 () Bool)

(assert (=> b!1010 m!1399))

(declare-fun m!1401 () Bool)

(assert (=> b!1011 m!1401))

(declare-fun m!1403 () Bool)

(assert (=> b!1012 m!1403))

(declare-fun m!1405 () Bool)

(assert (=> b!1012 m!1405))

(assert (=> b!756 d!567))

(assert (=> b!672 d!485))

(declare-fun d!569 () Bool)

(declare-fun c!262 () Bool)

(assert (=> d!569 (= c!262 ((_ is Empty!3) (right!8 (left!8 (left!8 t!78)))))))

(declare-fun e!574 () (_ BitVec 32))

(assert (=> d!569 (= (blackHeight!0 (right!8 (left!8 (left!8 t!78)))) e!574)))

(declare-fun b!1013 () Bool)

(declare-fun e!575 () (_ BitVec 32))

(declare-fun call!178 () (_ BitVec 32))

(assert (=> b!1013 (= e!575 (bvadd call!178 #b00000000000000000000000000000001))))

(declare-fun bm!178 () Bool)

(assert (=> bm!178 (= call!178 (blackHeight!0 (left!8 (right!8 (left!8 (left!8 t!78))))))))

(declare-fun b!1014 () Bool)

(assert (=> b!1014 (= e!575 call!178)))

(declare-fun b!1015 () Bool)

(assert (=> b!1015 (= e!574 e!575)))

(declare-fun c!263 () Bool)

(assert (=> b!1015 (= c!263 ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 t!78))))))))

(declare-fun b!1016 () Bool)

(assert (=> b!1016 (= e!574 #b00000000000000000000000000000001)))

(assert (= (and d!569 c!262) b!1016))

(assert (= (and d!569 (not c!262)) b!1015))

(assert (= (and b!1015 c!263) b!1013))

(assert (= (and b!1015 (not c!263)) b!1014))

(assert (= (or b!1013 b!1014) bm!178))

(assert (=> bm!178 m!1343))

(assert (=> b!672 d!569))

(declare-fun d!571 () Bool)

(assert (=> d!571 (= (isBlack!0 (right!8 (left!8 (left!8 (right!8 lt!2))))) (or ((_ is Empty!3) (right!8 (left!8 (left!8 (right!8 lt!2))))) ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 (right!8 lt!2))))))))))

(assert (=> b!675 d!571))

(declare-fun d!573 () Bool)

(declare-fun c!264 () Bool)

(assert (=> d!573 (= c!264 ((_ is Empty!3) (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun e!576 () (_ BitVec 32))

(assert (=> d!573 (= (blackHeight!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!576)))

(declare-fun b!1017 () Bool)

(declare-fun e!577 () (_ BitVec 32))

(declare-fun call!179 () (_ BitVec 32))

(assert (=> b!1017 (= e!577 (bvadd call!179 #b00000000000000000000000000000001))))

(declare-fun bm!179 () Bool)

(assert (=> bm!179 (= call!179 (blackHeight!0 (left!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1018 () Bool)

(assert (=> b!1018 (= e!577 call!179)))

(declare-fun b!1019 () Bool)

(assert (=> b!1019 (= e!576 e!577)))

(declare-fun c!265 () Bool)

(assert (=> b!1019 (= c!265 ((_ is Black!3) (color!6 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1020 () Bool)

(assert (=> b!1020 (= e!576 #b00000000000000000000000000000001)))

(assert (= (and d!573 c!264) b!1020))

(assert (= (and d!573 (not c!264)) b!1019))

(assert (= (and b!1019 c!265) b!1017))

(assert (= (and b!1019 (not c!265)) b!1018))

(assert (= (or b!1017 b!1018) bm!179))

(declare-fun m!1407 () Bool)

(assert (=> bm!179 m!1407))

(assert (=> b!795 d!573))

(declare-fun d!575 () Bool)

(declare-fun c!266 () Bool)

(assert (=> d!575 (= c!266 ((_ is Empty!3) (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun e!578 () (_ BitVec 32))

(assert (=> d!575 (= (blackHeight!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!578)))

(declare-fun b!1021 () Bool)

(declare-fun e!579 () (_ BitVec 32))

(declare-fun call!180 () (_ BitVec 32))

(assert (=> b!1021 (= e!579 (bvadd call!180 #b00000000000000000000000000000001))))

(declare-fun bm!180 () Bool)

(assert (=> bm!180 (= call!180 (blackHeight!0 (left!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1022 () Bool)

(assert (=> b!1022 (= e!579 call!180)))

(declare-fun b!1023 () Bool)

(assert (=> b!1023 (= e!578 e!579)))

(declare-fun c!267 () Bool)

(assert (=> b!1023 (= c!267 ((_ is Black!3) (color!6 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1024 () Bool)

(assert (=> b!1024 (= e!578 #b00000000000000000000000000000001)))

(assert (= (and d!575 c!266) b!1024))

(assert (= (and d!575 (not c!266)) b!1023))

(assert (= (and b!1023 c!267) b!1021))

(assert (= (and b!1023 (not c!267)) b!1022))

(assert (= (or b!1021 b!1022) bm!180))

(assert (=> bm!180 m!1259))

(assert (=> b!795 d!575))

(declare-fun d!577 () Bool)

(assert (=> d!577 (= (isBlack!0 (left!8 (left!8 (left!8 (right!8 t!78))))) (or ((_ is Empty!3) (left!8 (left!8 (left!8 (right!8 t!78))))) ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 (right!8 t!78))))))))))

(assert (=> b!694 d!577))

(declare-fun d!579 () Bool)

(declare-fun res!565 () Bool)

(declare-fun e!580 () Bool)

(assert (=> d!579 (=> res!565 e!580)))

(assert (=> d!579 (= res!565 (not ((_ is Node!3) (right!8 (left!8 (right!8 t!78))))))))

(assert (=> d!579 (= (blackBalanced!0 (right!8 (left!8 (right!8 t!78)))) e!580)))

(declare-fun b!1025 () Bool)

(declare-fun e!581 () Bool)

(assert (=> b!1025 (= e!580 e!581)))

(declare-fun res!567 () Bool)

(assert (=> b!1025 (=> (not res!567) (not e!581))))

(assert (=> b!1025 (= res!567 (blackBalanced!0 (left!8 (right!8 (left!8 (right!8 t!78))))))))

(declare-fun b!1026 () Bool)

(declare-fun res!566 () Bool)

(assert (=> b!1026 (=> (not res!566) (not e!581))))

(assert (=> b!1026 (= res!566 (blackBalanced!0 (right!8 (right!8 (left!8 (right!8 t!78))))))))

(declare-fun b!1027 () Bool)

(assert (=> b!1027 (= e!581 (= (blackHeight!0 (left!8 (right!8 (left!8 (right!8 t!78))))) (blackHeight!0 (right!8 (right!8 (left!8 (right!8 t!78)))))))))

(assert (= (and d!579 (not res!565)) b!1025))

(assert (= (and b!1025 res!567) b!1026))

(assert (= (and b!1026 res!566) b!1027))

(declare-fun m!1409 () Bool)

(assert (=> b!1025 m!1409))

(declare-fun m!1411 () Bool)

(assert (=> b!1026 m!1411))

(declare-fun m!1413 () Bool)

(assert (=> b!1027 m!1413))

(declare-fun m!1415 () Bool)

(assert (=> b!1027 m!1415))

(assert (=> b!830 d!579))

(declare-fun d!581 () Bool)

(declare-fun lt!46 () Int)

(assert (=> d!581 (>= lt!46 0)))

(declare-fun e!582 () Int)

(assert (=> d!581 (= lt!46 e!582)))

(declare-fun c!268 () Bool)

(assert (=> d!581 (= c!268 ((_ is Empty!3) (left!8 (left!8 (right!8 lt!5)))))))

(assert (=> d!581 (= (size!0 (left!8 (left!8 (right!8 lt!5)))) lt!46)))

(declare-fun b!1028 () Bool)

(assert (=> b!1028 (= e!582 0)))

(declare-fun b!1029 () Bool)

(assert (=> b!1029 (= e!582 (+ (size!0 (left!8 (left!8 (left!8 (right!8 lt!5))))) 1 (size!0 (right!8 (left!8 (left!8 (right!8 lt!5)))))))))

(assert (= (and d!581 c!268) b!1028))

(assert (= (and d!581 (not c!268)) b!1029))

(declare-fun m!1417 () Bool)

(assert (=> b!1029 m!1417))

(declare-fun m!1419 () Bool)

(assert (=> b!1029 m!1419))

(assert (=> b!477 d!581))

(declare-fun d!583 () Bool)

(declare-fun lt!47 () Int)

(assert (=> d!583 (>= lt!47 0)))

(declare-fun e!583 () Int)

(assert (=> d!583 (= lt!47 e!583)))

(declare-fun c!269 () Bool)

(assert (=> d!583 (= c!269 ((_ is Empty!3) (right!8 (left!8 (right!8 lt!5)))))))

(assert (=> d!583 (= (size!0 (right!8 (left!8 (right!8 lt!5)))) lt!47)))

(declare-fun b!1030 () Bool)

(assert (=> b!1030 (= e!583 0)))

(declare-fun b!1031 () Bool)

(assert (=> b!1031 (= e!583 (+ (size!0 (left!8 (right!8 (left!8 (right!8 lt!5))))) 1 (size!0 (right!8 (right!8 (left!8 (right!8 lt!5)))))))))

(assert (= (and d!583 c!269) b!1030))

(assert (= (and d!583 (not c!269)) b!1031))

(declare-fun m!1421 () Bool)

(assert (=> b!1031 m!1421))

(declare-fun m!1423 () Bool)

(assert (=> b!1031 m!1423))

(assert (=> b!477 d!583))

(declare-fun d!585 () Bool)

(declare-fun c!270 () Bool)

(assert (=> d!585 (= c!270 ((_ is Empty!3) (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun e!584 () (InoxSet (_ BitVec 32)))

(assert (=> d!585 (= (content!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!584)))

(declare-fun b!1032 () Bool)

(assert (=> b!1032 (= e!584 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1033 () Bool)

(assert (=> b!1033 (= e!584 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) true)) (content!0 (right!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!585 c!270) b!1032))

(assert (= (and d!585 (not c!270)) b!1033))

(declare-fun m!1425 () Bool)

(assert (=> b!1033 m!1425))

(declare-fun m!1427 () Bool)

(assert (=> b!1033 m!1427))

(declare-fun m!1429 () Bool)

(assert (=> b!1033 m!1429))

(assert (=> b!729 d!585))

(declare-fun d!587 () Bool)

(declare-fun c!271 () Bool)

(assert (=> d!587 (= c!271 ((_ is Empty!3) (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun e!585 () (InoxSet (_ BitVec 32)))

(assert (=> d!587 (= (content!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!585)))

(declare-fun b!1034 () Bool)

(assert (=> b!1034 (= e!585 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1035 () Bool)

(assert (=> b!1035 (= e!585 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) true)) (content!0 (right!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!587 c!271) b!1034))

(assert (= (and d!587 (not c!271)) b!1035))

(declare-fun m!1431 () Bool)

(assert (=> b!1035 m!1431))

(declare-fun m!1433 () Bool)

(assert (=> b!1035 m!1433))

(declare-fun m!1435 () Bool)

(assert (=> b!1035 m!1435))

(assert (=> b!729 d!587))

(declare-fun b!1036 () Bool)

(declare-fun res!572 () Bool)

(declare-fun call!182 () Bool)

(assert (=> b!1036 (= res!572 call!182)))

(declare-fun e!588 () Bool)

(assert (=> b!1036 (=> (not res!572) (not e!588))))

(declare-fun d!589 () Bool)

(declare-fun res!570 () Bool)

(declare-fun e!589 () Bool)

(assert (=> d!589 (=> res!570 e!589)))

(assert (=> d!589 (= res!570 ((_ is Empty!3) (left!8 (left!8 lt!13))))))

(assert (=> d!589 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 lt!13))) e!589)))

(declare-fun b!1037 () Bool)

(declare-fun call!181 () Bool)

(assert (=> b!1037 (= e!588 call!181)))

(declare-fun bm!181 () Bool)

(assert (=> bm!181 (= call!182 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 lt!13)))))))

(declare-fun bm!182 () Bool)

(assert (=> bm!182 (= call!181 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 lt!13)))))))

(declare-fun b!1038 () Bool)

(declare-fun res!571 () Bool)

(assert (=> b!1038 (= res!571 (isBlack!0 (right!8 (left!8 (left!8 lt!13)))))))

(assert (=> b!1038 (=> (not res!571) (not e!588))))

(declare-fun b!1039 () Bool)

(declare-fun e!587 () Bool)

(assert (=> b!1039 (= e!587 call!181)))

(declare-fun b!1040 () Bool)

(declare-fun e!586 () Bool)

(assert (=> b!1040 (= e!586 e!588)))

(declare-fun res!568 () Bool)

(assert (=> b!1040 (= res!568 (isBlack!0 (left!8 (left!8 (left!8 lt!13)))))))

(assert (=> b!1040 (=> (not res!568) (not e!588))))

(declare-fun b!1041 () Bool)

(assert (=> b!1041 (= e!589 e!586)))

(declare-fun c!272 () Bool)

(assert (=> b!1041 (= c!272 ((_ is Black!3) (color!6 (left!8 (left!8 lt!13)))))))

(declare-fun b!1042 () Bool)

(assert (=> b!1042 (= e!586 e!587)))

(declare-fun res!569 () Bool)

(assert (=> b!1042 (= res!569 call!182)))

(assert (=> b!1042 (=> (not res!569) (not e!587))))

(assert (= (and d!589 (not res!570)) b!1041))

(assert (= (and b!1041 c!272) b!1042))

(assert (= (and b!1041 (not c!272)) b!1040))

(assert (= (and b!1042 res!569) b!1039))

(assert (= (and b!1040 res!568) b!1038))

(assert (= (and b!1038 res!571) b!1036))

(assert (= (and b!1036 res!572) b!1037))

(assert (= (or b!1042 b!1036) bm!181))

(assert (= (or b!1039 b!1037) bm!182))

(declare-fun m!1437 () Bool)

(assert (=> bm!181 m!1437))

(declare-fun m!1439 () Bool)

(assert (=> bm!182 m!1439))

(declare-fun m!1441 () Bool)

(assert (=> b!1038 m!1441))

(declare-fun m!1443 () Bool)

(assert (=> b!1040 m!1443))

(assert (=> bm!130 d!589))

(declare-fun d!591 () Bool)

(declare-fun c!273 () Bool)

(assert (=> d!591 (= c!273 ((_ is Empty!3) (left!8 lt!16)))))

(declare-fun e!590 () (InoxSet (_ BitVec 32)))

(assert (=> d!591 (= (content!0 (left!8 lt!16)) e!590)))

(declare-fun b!1043 () Bool)

(assert (=> b!1043 (= e!590 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1044 () Bool)

(assert (=> b!1044 (= e!590 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 lt!16))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 lt!16)) true)) (content!0 (right!8 (left!8 lt!16)))))))

(assert (= (and d!591 c!273) b!1043))

(assert (= (and d!591 (not c!273)) b!1044))

(declare-fun m!1445 () Bool)

(assert (=> b!1044 m!1445))

(declare-fun m!1447 () Bool)

(assert (=> b!1044 m!1447))

(declare-fun m!1449 () Bool)

(assert (=> b!1044 m!1449))

(assert (=> b!707 d!591))

(declare-fun d!593 () Bool)

(declare-fun c!274 () Bool)

(assert (=> d!593 (= c!274 ((_ is Empty!3) (right!8 lt!16)))))

(declare-fun e!591 () (InoxSet (_ BitVec 32)))

(assert (=> d!593 (= (content!0 (right!8 lt!16)) e!591)))

(declare-fun b!1045 () Bool)

(assert (=> b!1045 (= e!591 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1046 () Bool)

(assert (=> b!1046 (= e!591 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 lt!16))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 lt!16)) true)) (content!0 (right!8 (right!8 lt!16)))))))

(assert (= (and d!593 c!274) b!1045))

(assert (= (and d!593 (not c!274)) b!1046))

(declare-fun m!1451 () Bool)

(assert (=> b!1046 m!1451))

(declare-fun m!1453 () Bool)

(assert (=> b!1046 m!1453))

(declare-fun m!1455 () Bool)

(assert (=> b!1046 m!1455))

(assert (=> b!707 d!593))

(declare-fun c!275 () Bool)

(declare-fun d!595 () Bool)

(assert (=> d!595 (= c!275 ((_ is Empty!3) (left!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))))

(declare-fun e!592 () (InoxSet (_ BitVec 32)))

(assert (=> d!595 (= (content!0 (left!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))) e!592)))

(declare-fun b!1047 () Bool)

(assert (=> b!1047 (= e!592 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1048 () Bool)

(assert (=> b!1048 (= e!592 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))) true)) (content!0 (right!8 (left!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))))))

(assert (= (and d!595 c!275) b!1047))

(assert (= (and d!595 (not c!275)) b!1048))

(declare-fun m!1457 () Bool)

(assert (=> b!1048 m!1457))

(declare-fun m!1459 () Bool)

(assert (=> b!1048 m!1459))

(declare-fun m!1461 () Bool)

(assert (=> b!1048 m!1461))

(assert (=> b!580 d!595))

(declare-fun d!597 () Bool)

(declare-fun c!276 () Bool)

(assert (=> d!597 (= c!276 ((_ is Empty!3) (right!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))))

(declare-fun e!593 () (InoxSet (_ BitVec 32)))

(assert (=> d!597 (= (content!0 (right!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))) e!593)))

(declare-fun b!1049 () Bool)

(assert (=> b!1049 (= e!593 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1050 () Bool)

(assert (=> b!1050 (= e!593 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))) true)) (content!0 (right!8 (right!8 (left!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))))))

(assert (= (and d!597 c!276) b!1049))

(assert (= (and d!597 (not c!276)) b!1050))

(declare-fun m!1463 () Bool)

(assert (=> b!1050 m!1463))

(declare-fun m!1465 () Bool)

(assert (=> b!1050 m!1465))

(declare-fun m!1467 () Bool)

(assert (=> b!1050 m!1467))

(assert (=> b!580 d!597))

(declare-fun d!599 () Bool)

(assert (=> d!599 (= (isBlack!0 (left!8 (left!8 (left!8 (left!8 lt!2))))) (or ((_ is Empty!3) (left!8 (left!8 (left!8 (left!8 lt!2))))) ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 (left!8 lt!2))))))))))

(assert (=> b!473 d!599))

(declare-fun d!601 () Bool)

(declare-fun c!277 () Bool)

(assert (=> d!601 (= c!277 ((_ is Empty!3) (left!8 (right!8 (left!8 (left!8 t!78))))))))

(declare-fun e!594 () (InoxSet (_ BitVec 32)))

(assert (=> d!601 (= (content!0 (left!8 (right!8 (left!8 (left!8 t!78))))) e!594)))

(declare-fun b!1051 () Bool)

(assert (=> b!1051 (= e!594 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1052 () Bool)

(assert (=> b!1052 (= e!594 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (left!8 (left!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (left!8 (left!8 t!78))))) true)) (content!0 (right!8 (left!8 (right!8 (left!8 (left!8 t!78))))))))))

(assert (= (and d!601 c!277) b!1051))

(assert (= (and d!601 (not c!277)) b!1052))

(declare-fun m!1469 () Bool)

(assert (=> b!1052 m!1469))

(declare-fun m!1471 () Bool)

(assert (=> b!1052 m!1471))

(declare-fun m!1473 () Bool)

(assert (=> b!1052 m!1473))

(assert (=> b!535 d!601))

(declare-fun d!603 () Bool)

(declare-fun c!278 () Bool)

(assert (=> d!603 (= c!278 ((_ is Empty!3) (right!8 (right!8 (left!8 (left!8 t!78))))))))

(declare-fun e!595 () (InoxSet (_ BitVec 32)))

(assert (=> d!603 (= (content!0 (right!8 (right!8 (left!8 (left!8 t!78))))) e!595)))

(declare-fun b!1053 () Bool)

(assert (=> b!1053 (= e!595 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1054 () Bool)

(assert (=> b!1054 (= e!595 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (left!8 (left!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (left!8 (left!8 t!78))))) true)) (content!0 (right!8 (right!8 (right!8 (left!8 (left!8 t!78))))))))))

(assert (= (and d!603 c!278) b!1053))

(assert (= (and d!603 (not c!278)) b!1054))

(declare-fun m!1475 () Bool)

(assert (=> b!1054 m!1475))

(declare-fun m!1477 () Bool)

(assert (=> b!1054 m!1477))

(declare-fun m!1479 () Bool)

(assert (=> b!1054 m!1479))

(assert (=> b!535 d!603))

(declare-fun d!605 () Bool)

(declare-fun res!573 () Bool)

(declare-fun e!596 () Bool)

(assert (=> d!605 (=> res!573 e!596)))

(assert (=> d!605 (= res!573 (not ((_ is Node!3) (right!8 (right!8 (right!8 t!78))))))))

(assert (=> d!605 (= (blackBalanced!0 (right!8 (right!8 (right!8 t!78)))) e!596)))

(declare-fun b!1055 () Bool)

(declare-fun e!597 () Bool)

(assert (=> b!1055 (= e!596 e!597)))

(declare-fun res!575 () Bool)

(assert (=> b!1055 (=> (not res!575) (not e!597))))

(assert (=> b!1055 (= res!575 (blackBalanced!0 (left!8 (right!8 (right!8 (right!8 t!78))))))))

(declare-fun b!1056 () Bool)

(declare-fun res!574 () Bool)

(assert (=> b!1056 (=> (not res!574) (not e!597))))

(assert (=> b!1056 (= res!574 (blackBalanced!0 (right!8 (right!8 (right!8 (right!8 t!78))))))))

(declare-fun b!1057 () Bool)

(assert (=> b!1057 (= e!597 (= (blackHeight!0 (left!8 (right!8 (right!8 (right!8 t!78))))) (blackHeight!0 (right!8 (right!8 (right!8 (right!8 t!78)))))))))

(assert (= (and d!605 (not res!573)) b!1055))

(assert (= (and b!1055 res!575) b!1056))

(assert (= (and b!1056 res!574) b!1057))

(declare-fun m!1481 () Bool)

(assert (=> b!1055 m!1481))

(declare-fun m!1483 () Bool)

(assert (=> b!1056 m!1483))

(declare-fun m!1485 () Bool)

(assert (=> b!1057 m!1485))

(declare-fun m!1487 () Bool)

(assert (=> b!1057 m!1487))

(assert (=> b!523 d!605))

(declare-fun b!1058 () Bool)

(declare-fun res!580 () Bool)

(declare-fun call!184 () Bool)

(assert (=> b!1058 (= res!580 call!184)))

(declare-fun e!600 () Bool)

(assert (=> b!1058 (=> (not res!580) (not e!600))))

(declare-fun d!607 () Bool)

(declare-fun res!578 () Bool)

(declare-fun e!601 () Bool)

(assert (=> d!607 (=> res!578 e!601)))

(assert (=> d!607 (= res!578 ((_ is Empty!3) (right!8 (right!8 (right!8 (left!8 lt!2))))))))

(assert (=> d!607 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (left!8 lt!2))))) e!601)))

(declare-fun b!1059 () Bool)

(declare-fun call!183 () Bool)

(assert (=> b!1059 (= e!600 call!183)))

(declare-fun bm!183 () Bool)

(assert (=> bm!183 (= call!184 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (right!8 (left!8 lt!2)))))))))

(declare-fun bm!184 () Bool)

(assert (=> bm!184 (= call!183 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (right!8 (left!8 lt!2)))))))))

(declare-fun b!1060 () Bool)

(declare-fun res!579 () Bool)

(assert (=> b!1060 (= res!579 (isBlack!0 (right!8 (right!8 (right!8 (right!8 (left!8 lt!2)))))))))

(assert (=> b!1060 (=> (not res!579) (not e!600))))

(declare-fun b!1061 () Bool)

(declare-fun e!599 () Bool)

(assert (=> b!1061 (= e!599 call!183)))

(declare-fun b!1062 () Bool)

(declare-fun e!598 () Bool)

(assert (=> b!1062 (= e!598 e!600)))

(declare-fun res!576 () Bool)

(assert (=> b!1062 (= res!576 (isBlack!0 (left!8 (right!8 (right!8 (right!8 (left!8 lt!2)))))))))

(assert (=> b!1062 (=> (not res!576) (not e!600))))

(declare-fun b!1063 () Bool)

(assert (=> b!1063 (= e!601 e!598)))

(declare-fun c!279 () Bool)

(assert (=> b!1063 (= c!279 ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 (left!8 lt!2)))))))))

(declare-fun b!1064 () Bool)

(assert (=> b!1064 (= e!598 e!599)))

(declare-fun res!577 () Bool)

(assert (=> b!1064 (= res!577 call!184)))

(assert (=> b!1064 (=> (not res!577) (not e!599))))

(assert (= (and d!607 (not res!578)) b!1063))

(assert (= (and b!1063 c!279) b!1064))

(assert (= (and b!1063 (not c!279)) b!1062))

(assert (= (and b!1064 res!577) b!1061))

(assert (= (and b!1062 res!576) b!1060))

(assert (= (and b!1060 res!579) b!1058))

(assert (= (and b!1058 res!580) b!1059))

(assert (= (or b!1064 b!1058) bm!183))

(assert (= (or b!1061 b!1059) bm!184))

(declare-fun m!1489 () Bool)

(assert (=> bm!183 m!1489))

(declare-fun m!1491 () Bool)

(assert (=> bm!184 m!1491))

(declare-fun m!1493 () Bool)

(assert (=> b!1060 m!1493))

(declare-fun m!1495 () Bool)

(assert (=> b!1062 m!1495))

(assert (=> bm!123 d!607))

(assert (=> b!468 d!535))

(declare-fun d!609 () Bool)

(declare-fun c!280 () Bool)

(assert (=> d!609 (= c!280 ((_ is Empty!3) (right!8 (right!8 (right!8 lt!5)))))))

(declare-fun e!602 () (_ BitVec 32))

(assert (=> d!609 (= (blackHeight!0 (right!8 (right!8 (right!8 lt!5)))) e!602)))

(declare-fun b!1065 () Bool)

(declare-fun e!603 () (_ BitVec 32))

(declare-fun call!185 () (_ BitVec 32))

(assert (=> b!1065 (= e!603 (bvadd call!185 #b00000000000000000000000000000001))))

(declare-fun bm!185 () Bool)

(assert (=> bm!185 (= call!185 (blackHeight!0 (left!8 (right!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!1066 () Bool)

(assert (=> b!1066 (= e!603 call!185)))

(declare-fun b!1067 () Bool)

(assert (=> b!1067 (= e!602 e!603)))

(declare-fun c!281 () Bool)

(assert (=> b!1067 (= c!281 ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!1068 () Bool)

(assert (=> b!1068 (= e!602 #b00000000000000000000000000000001)))

(assert (= (and d!609 c!280) b!1068))

(assert (= (and d!609 (not c!280)) b!1067))

(assert (= (and b!1067 c!281) b!1065))

(assert (= (and b!1067 (not c!281)) b!1066))

(assert (= (or b!1065 b!1066) bm!185))

(declare-fun m!1497 () Bool)

(assert (=> bm!185 m!1497))

(assert (=> b!468 d!609))

(declare-fun d!611 () Bool)

(assert (=> d!611 (= (isBlack!0 (left!8 (right!8 (left!8 (right!8 lt!2))))) (or ((_ is Empty!3) (left!8 (right!8 (left!8 (right!8 lt!2))))) ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 (right!8 lt!2))))))))))

(assert (=> b!762 d!611))

(declare-fun b!1069 () Bool)

(declare-fun res!585 () Bool)

(declare-fun call!187 () Bool)

(assert (=> b!1069 (= res!585 call!187)))

(declare-fun e!606 () Bool)

(assert (=> b!1069 (=> (not res!585) (not e!606))))

(declare-fun d!613 () Bool)

(declare-fun res!583 () Bool)

(declare-fun e!607 () Bool)

(assert (=> d!613 (=> res!583 e!607)))

(assert (=> d!613 (= res!583 ((_ is Empty!3) (right!8 (right!8 (right!8 (right!8 lt!2))))))))

(assert (=> d!613 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (right!8 lt!2))))) e!607)))

(declare-fun b!1070 () Bool)

(declare-fun call!186 () Bool)

(assert (=> b!1070 (= e!606 call!186)))

(declare-fun bm!186 () Bool)

(assert (=> bm!186 (= call!187 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (right!8 (right!8 lt!2)))))))))

(declare-fun bm!187 () Bool)

(assert (=> bm!187 (= call!186 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (right!8 (right!8 lt!2)))))))))

(declare-fun b!1071 () Bool)

(declare-fun res!584 () Bool)

(assert (=> b!1071 (= res!584 (isBlack!0 (right!8 (right!8 (right!8 (right!8 (right!8 lt!2)))))))))

(assert (=> b!1071 (=> (not res!584) (not e!606))))

(declare-fun b!1072 () Bool)

(declare-fun e!605 () Bool)

(assert (=> b!1072 (= e!605 call!186)))

(declare-fun b!1073 () Bool)

(declare-fun e!604 () Bool)

(assert (=> b!1073 (= e!604 e!606)))

(declare-fun res!581 () Bool)

(assert (=> b!1073 (= res!581 (isBlack!0 (left!8 (right!8 (right!8 (right!8 (right!8 lt!2)))))))))

(assert (=> b!1073 (=> (not res!581) (not e!606))))

(declare-fun b!1074 () Bool)

(assert (=> b!1074 (= e!607 e!604)))

(declare-fun c!282 () Bool)

(assert (=> b!1074 (= c!282 ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 (right!8 lt!2)))))))))

(declare-fun b!1075 () Bool)

(assert (=> b!1075 (= e!604 e!605)))

(declare-fun res!582 () Bool)

(assert (=> b!1075 (= res!582 call!187)))

(assert (=> b!1075 (=> (not res!582) (not e!605))))

(assert (= (and d!613 (not res!583)) b!1074))

(assert (= (and b!1074 c!282) b!1075))

(assert (= (and b!1074 (not c!282)) b!1073))

(assert (= (and b!1075 res!582) b!1072))

(assert (= (and b!1073 res!581) b!1071))

(assert (= (and b!1071 res!584) b!1069))

(assert (= (and b!1069 res!585) b!1070))

(assert (= (or b!1075 b!1069) bm!186))

(assert (= (or b!1072 b!1070) bm!187))

(declare-fun m!1499 () Bool)

(assert (=> bm!186 m!1499))

(declare-fun m!1501 () Bool)

(assert (=> bm!187 m!1501))

(declare-fun m!1503 () Bool)

(assert (=> b!1071 m!1503))

(declare-fun m!1505 () Bool)

(assert (=> b!1073 m!1505))

(assert (=> bm!117 d!613))

(declare-fun b!1076 () Bool)

(declare-fun res!590 () Bool)

(declare-fun call!189 () Bool)

(assert (=> b!1076 (= res!590 call!189)))

(declare-fun e!610 () Bool)

(assert (=> b!1076 (=> (not res!590) (not e!610))))

(declare-fun d!615 () Bool)

(declare-fun res!588 () Bool)

(declare-fun e!611 () Bool)

(assert (=> d!615 (=> res!588 e!611)))

(assert (=> d!615 (= res!588 ((_ is Empty!3) (right!8 (right!8 (left!8 (left!8 t!78))))))))

(assert (=> d!615 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (left!8 t!78))))) e!611)))

(declare-fun b!1077 () Bool)

(declare-fun call!188 () Bool)

(assert (=> b!1077 (= e!610 call!188)))

(declare-fun bm!188 () Bool)

(assert (=> bm!188 (= call!189 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (left!8 (left!8 t!78)))))))))

(declare-fun bm!189 () Bool)

(assert (=> bm!189 (= call!188 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (left!8 (left!8 t!78)))))))))

(declare-fun b!1078 () Bool)

(declare-fun res!589 () Bool)

(assert (=> b!1078 (= res!589 (isBlack!0 (right!8 (right!8 (right!8 (left!8 (left!8 t!78)))))))))

(assert (=> b!1078 (=> (not res!589) (not e!610))))

(declare-fun b!1079 () Bool)

(declare-fun e!609 () Bool)

(assert (=> b!1079 (= e!609 call!188)))

(declare-fun b!1080 () Bool)

(declare-fun e!608 () Bool)

(assert (=> b!1080 (= e!608 e!610)))

(declare-fun res!586 () Bool)

(assert (=> b!1080 (= res!586 (isBlack!0 (left!8 (right!8 (right!8 (left!8 (left!8 t!78)))))))))

(assert (=> b!1080 (=> (not res!586) (not e!610))))

(declare-fun b!1081 () Bool)

(assert (=> b!1081 (= e!611 e!608)))

(declare-fun c!283 () Bool)

(assert (=> b!1081 (= c!283 ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 (left!8 t!78)))))))))

(declare-fun b!1082 () Bool)

(assert (=> b!1082 (= e!608 e!609)))

(declare-fun res!587 () Bool)

(assert (=> b!1082 (= res!587 call!189)))

(assert (=> b!1082 (=> (not res!587) (not e!609))))

(assert (= (and d!615 (not res!588)) b!1081))

(assert (= (and b!1081 c!283) b!1082))

(assert (= (and b!1081 (not c!283)) b!1080))

(assert (= (and b!1082 res!587) b!1079))

(assert (= (and b!1080 res!586) b!1078))

(assert (= (and b!1078 res!589) b!1076))

(assert (= (and b!1076 res!590) b!1077))

(assert (= (or b!1082 b!1076) bm!188))

(assert (= (or b!1079 b!1077) bm!189))

(declare-fun m!1507 () Bool)

(assert (=> bm!188 m!1507))

(declare-fun m!1509 () Bool)

(assert (=> bm!189 m!1509))

(declare-fun m!1511 () Bool)

(assert (=> b!1078 m!1511))

(declare-fun m!1513 () Bool)

(assert (=> b!1080 m!1513))

(assert (=> bm!91 d!615))

(declare-fun d!617 () Bool)

(declare-fun res!591 () Bool)

(declare-fun e!612 () Bool)

(assert (=> d!617 (=> res!591 e!612)))

(assert (=> d!617 (= res!591 (not ((_ is Node!3) (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> d!617 (= (blackBalanced!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) e!612)))

(declare-fun b!1083 () Bool)

(declare-fun e!613 () Bool)

(assert (=> b!1083 (= e!612 e!613)))

(declare-fun res!593 () Bool)

(assert (=> b!1083 (=> (not res!593) (not e!613))))

(assert (=> b!1083 (= res!593 (blackBalanced!0 (left!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!1084 () Bool)

(declare-fun res!592 () Bool)

(assert (=> b!1084 (=> (not res!592) (not e!613))))

(assert (=> b!1084 (= res!592 (blackBalanced!0 (right!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!1085 () Bool)

(assert (=> b!1085 (= e!613 (= (blackHeight!0 (left!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (blackHeight!0 (right!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (= (and d!617 (not res!591)) b!1083))

(assert (= (and b!1083 res!593) b!1084))

(assert (= (and b!1084 res!592) b!1085))

(declare-fun m!1515 () Bool)

(assert (=> b!1083 m!1515))

(declare-fun m!1517 () Bool)

(assert (=> b!1084 m!1517))

(assert (=> b!1085 m!1147))

(declare-fun m!1519 () Bool)

(assert (=> b!1085 m!1519))

(assert (=> b!491 d!617))

(declare-fun d!619 () Bool)

(declare-fun c!284 () Bool)

(assert (=> d!619 (= c!284 ((_ is Empty!3) (left!8 (left!8 (right!8 t!78)))))))

(declare-fun e!614 () (_ BitVec 32))

(assert (=> d!619 (= (blackHeight!0 (left!8 (left!8 (right!8 t!78)))) e!614)))

(declare-fun b!1086 () Bool)

(declare-fun e!615 () (_ BitVec 32))

(declare-fun call!190 () (_ BitVec 32))

(assert (=> b!1086 (= e!615 (bvadd call!190 #b00000000000000000000000000000001))))

(declare-fun bm!190 () Bool)

(assert (=> bm!190 (= call!190 (blackHeight!0 (left!8 (left!8 (left!8 (right!8 t!78))))))))

(declare-fun b!1087 () Bool)

(assert (=> b!1087 (= e!615 call!190)))

(declare-fun b!1088 () Bool)

(assert (=> b!1088 (= e!614 e!615)))

(declare-fun c!285 () Bool)

(assert (=> b!1088 (= c!285 ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 t!78))))))))

(declare-fun b!1089 () Bool)

(assert (=> b!1089 (= e!614 #b00000000000000000000000000000001)))

(assert (= (and d!619 c!284) b!1089))

(assert (= (and d!619 (not c!284)) b!1088))

(assert (= (and b!1088 c!285) b!1086))

(assert (= (and b!1088 (not c!285)) b!1087))

(assert (= (or b!1086 b!1087) bm!190))

(assert (=> bm!190 m!1283))

(assert (=> bm!106 d!619))

(declare-fun d!621 () Bool)

(declare-fun c!286 () Bool)

(assert (=> d!621 (= c!286 ((_ is Empty!3) (left!8 (right!8 (right!8 (right!8 t!78))))))))

(declare-fun e!616 () (InoxSet (_ BitVec 32)))

(assert (=> d!621 (= (content!0 (left!8 (right!8 (right!8 (right!8 t!78))))) e!616)))

(declare-fun b!1090 () Bool)

(assert (=> b!1090 (= e!616 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1091 () Bool)

(assert (=> b!1091 (= e!616 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (right!8 (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (right!8 (right!8 t!78))))) true)) (content!0 (right!8 (left!8 (right!8 (right!8 (right!8 t!78))))))))))

(assert (= (and d!621 c!286) b!1090))

(assert (= (and d!621 (not c!286)) b!1091))

(declare-fun m!1521 () Bool)

(assert (=> b!1091 m!1521))

(declare-fun m!1523 () Bool)

(assert (=> b!1091 m!1523))

(declare-fun m!1525 () Bool)

(assert (=> b!1091 m!1525))

(assert (=> b!813 d!621))

(declare-fun d!623 () Bool)

(declare-fun c!287 () Bool)

(assert (=> d!623 (= c!287 ((_ is Empty!3) (right!8 (right!8 (right!8 (right!8 t!78))))))))

(declare-fun e!617 () (InoxSet (_ BitVec 32)))

(assert (=> d!623 (= (content!0 (right!8 (right!8 (right!8 (right!8 t!78))))) e!617)))

(declare-fun b!1092 () Bool)

(assert (=> b!1092 (= e!617 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1093 () Bool)

(assert (=> b!1093 (= e!617 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (right!8 (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (right!8 (right!8 t!78))))) true)) (content!0 (right!8 (right!8 (right!8 (right!8 (right!8 t!78))))))))))

(assert (= (and d!623 c!287) b!1092))

(assert (= (and d!623 (not c!287)) b!1093))

(declare-fun m!1527 () Bool)

(assert (=> b!1093 m!1527))

(declare-fun m!1529 () Bool)

(assert (=> b!1093 m!1529))

(declare-fun m!1531 () Bool)

(assert (=> b!1093 m!1531))

(assert (=> b!813 d!623))

(declare-fun d!625 () Bool)

(declare-fun res!594 () Bool)

(declare-fun e!618 () Bool)

(assert (=> d!625 (=> res!594 e!618)))

(assert (=> d!625 (= res!594 ((_ is Empty!3) lt!28))))

(assert (=> d!625 (= (redDescHaveBlackChildren!0 lt!28) e!618)))

(declare-fun b!1094 () Bool)

(declare-fun e!619 () Bool)

(assert (=> b!1094 (= e!618 e!619)))

(declare-fun res!595 () Bool)

(assert (=> b!1094 (=> (not res!595) (not e!619))))

(assert (=> b!1094 (= res!595 (redNodesHaveBlackChildren!0 (left!8 lt!28)))))

(declare-fun b!1095 () Bool)

(assert (=> b!1095 (= e!619 (redNodesHaveBlackChildren!0 (right!8 lt!28)))))

(assert (= (and d!625 (not res!594)) b!1094))

(assert (= (and b!1094 res!595) b!1095))

(declare-fun m!1533 () Bool)

(assert (=> b!1094 m!1533))

(declare-fun m!1535 () Bool)

(assert (=> b!1095 m!1535))

(assert (=> b!606 d!625))

(declare-fun d!627 () Bool)

(assert (=> d!627 (= (isBlack!0 (right!8 (right!8 (left!8 lt!5)))) (or ((_ is Empty!3) (right!8 (right!8 (left!8 lt!5)))) ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 lt!5)))))))))

(assert (=> b!644 d!627))

(declare-fun d!629 () Bool)

(declare-fun c!288 () Bool)

(assert (=> d!629 (= c!288 ((_ is Empty!3) (left!8 (left!8 (left!8 (left!8 t!78))))))))

(declare-fun e!620 () (InoxSet (_ BitVec 32)))

(assert (=> d!629 (= (content!0 (left!8 (left!8 (left!8 (left!8 t!78))))) e!620)))

(declare-fun b!1096 () Bool)

(assert (=> b!1096 (= e!620 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1097 () Bool)

(assert (=> b!1097 (= e!620 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (left!8 (left!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (left!8 (left!8 t!78))))) true)) (content!0 (right!8 (left!8 (left!8 (left!8 (left!8 t!78))))))))))

(assert (= (and d!629 c!288) b!1096))

(assert (= (and d!629 (not c!288)) b!1097))

(declare-fun m!1537 () Bool)

(assert (=> b!1097 m!1537))

(declare-fun m!1539 () Bool)

(assert (=> b!1097 m!1539))

(declare-fun m!1541 () Bool)

(assert (=> b!1097 m!1541))

(assert (=> b!533 d!629))

(declare-fun d!631 () Bool)

(declare-fun c!289 () Bool)

(assert (=> d!631 (= c!289 ((_ is Empty!3) (right!8 (left!8 (left!8 (left!8 t!78))))))))

(declare-fun e!621 () (InoxSet (_ BitVec 32)))

(assert (=> d!631 (= (content!0 (right!8 (left!8 (left!8 (left!8 t!78))))) e!621)))

(declare-fun b!1098 () Bool)

(assert (=> b!1098 (= e!621 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1099 () Bool)

(assert (=> b!1099 (= e!621 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (left!8 (left!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (left!8 (left!8 t!78))))) true)) (content!0 (right!8 (right!8 (left!8 (left!8 (left!8 t!78))))))))))

(assert (= (and d!631 c!289) b!1098))

(assert (= (and d!631 (not c!289)) b!1099))

(declare-fun m!1543 () Bool)

(assert (=> b!1099 m!1543))

(declare-fun m!1545 () Bool)

(assert (=> b!1099 m!1545))

(declare-fun m!1547 () Bool)

(assert (=> b!1099 m!1547))

(assert (=> b!533 d!631))

(declare-fun d!633 () Bool)

(declare-fun lt!48 () Int)

(assert (=> d!633 (>= lt!48 0)))

(declare-fun e!622 () Int)

(assert (=> d!633 (= lt!48 e!622)))

(declare-fun c!290 () Bool)

(assert (=> d!633 (= c!290 ((_ is Empty!3) (left!8 (left!8 (left!8 t!78)))))))

(assert (=> d!633 (= (size!0 (left!8 (left!8 (left!8 t!78)))) lt!48)))

(declare-fun b!1100 () Bool)

(assert (=> b!1100 (= e!622 0)))

(declare-fun b!1101 () Bool)

(assert (=> b!1101 (= e!622 (+ (size!0 (left!8 (left!8 (left!8 (left!8 t!78))))) 1 (size!0 (right!8 (left!8 (left!8 (left!8 t!78)))))))))

(assert (= (and d!633 c!290) b!1100))

(assert (= (and d!633 (not c!290)) b!1101))

(declare-fun m!1549 () Bool)

(assert (=> b!1101 m!1549))

(declare-fun m!1551 () Bool)

(assert (=> b!1101 m!1551))

(assert (=> b!515 d!633))

(declare-fun d!635 () Bool)

(declare-fun lt!49 () Int)

(assert (=> d!635 (>= lt!49 0)))

(declare-fun e!623 () Int)

(assert (=> d!635 (= lt!49 e!623)))

(declare-fun c!291 () Bool)

(assert (=> d!635 (= c!291 ((_ is Empty!3) (right!8 (left!8 (left!8 t!78)))))))

(assert (=> d!635 (= (size!0 (right!8 (left!8 (left!8 t!78)))) lt!49)))

(declare-fun b!1102 () Bool)

(assert (=> b!1102 (= e!623 0)))

(declare-fun b!1103 () Bool)

(assert (=> b!1103 (= e!623 (+ (size!0 (left!8 (right!8 (left!8 (left!8 t!78))))) 1 (size!0 (right!8 (right!8 (left!8 (left!8 t!78)))))))))

(assert (= (and d!635 c!291) b!1102))

(assert (= (and d!635 (not c!291)) b!1103))

(declare-fun m!1553 () Bool)

(assert (=> b!1103 m!1553))

(declare-fun m!1555 () Bool)

(assert (=> b!1103 m!1555))

(assert (=> b!515 d!635))

(declare-fun d!637 () Bool)

(declare-fun lt!50 () Int)

(assert (=> d!637 (>= lt!50 0)))

(declare-fun e!624 () Int)

(assert (=> d!637 (= lt!50 e!624)))

(declare-fun c!292 () Bool)

(assert (=> d!637 (= c!292 ((_ is Empty!3) (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!637 (= (size!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) lt!50)))

(declare-fun b!1104 () Bool)

(assert (=> b!1104 (= e!624 0)))

(declare-fun b!1105 () Bool)

(assert (=> b!1105 (= e!624 (+ (size!0 (left!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) 1 (size!0 (right!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!637 c!292) b!1104))

(assert (= (and d!637 (not c!292)) b!1105))

(declare-fun m!1557 () Bool)

(assert (=> b!1105 m!1557))

(declare-fun m!1559 () Bool)

(assert (=> b!1105 m!1559))

(assert (=> b!463 d!637))

(declare-fun d!639 () Bool)

(declare-fun lt!51 () Int)

(assert (=> d!639 (>= lt!51 0)))

(declare-fun e!625 () Int)

(assert (=> d!639 (= lt!51 e!625)))

(declare-fun c!293 () Bool)

(assert (=> d!639 (= c!293 ((_ is Empty!3) (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!639 (= (size!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) lt!51)))

(declare-fun b!1106 () Bool)

(assert (=> b!1106 (= e!625 0)))

(declare-fun b!1107 () Bool)

(assert (=> b!1107 (= e!625 (+ (size!0 (left!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) 1 (size!0 (right!8 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!639 c!293) b!1106))

(assert (= (and d!639 (not c!293)) b!1107))

(declare-fun m!1561 () Bool)

(assert (=> b!1107 m!1561))

(declare-fun m!1563 () Bool)

(assert (=> b!1107 m!1563))

(assert (=> b!463 d!639))

(declare-fun d!641 () Bool)

(declare-fun res!596 () Bool)

(declare-fun e!626 () Bool)

(assert (=> d!641 (=> res!596 e!626)))

(assert (=> d!641 (= res!596 (not ((_ is Node!3) (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> d!641 (= (blackBalanced!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!626)))

(declare-fun b!1108 () Bool)

(declare-fun e!627 () Bool)

(assert (=> b!1108 (= e!626 e!627)))

(declare-fun res!598 () Bool)

(assert (=> b!1108 (=> (not res!598) (not e!627))))

(assert (=> b!1108 (= res!598 (blackBalanced!0 (left!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1109 () Bool)

(declare-fun res!597 () Bool)

(assert (=> b!1109 (=> (not res!597) (not e!627))))

(assert (=> b!1109 (= res!597 (blackBalanced!0 (right!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1110 () Bool)

(assert (=> b!1110 (= e!627 (= (blackHeight!0 (left!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (blackHeight!0 (right!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!641 (not res!596)) b!1108))

(assert (= (and b!1108 res!598) b!1109))

(assert (= (and b!1109 res!597) b!1110))

(declare-fun m!1565 () Bool)

(assert (=> b!1108 m!1565))

(declare-fun m!1567 () Bool)

(assert (=> b!1109 m!1567))

(assert (=> b!1110 m!1211))

(declare-fun m!1569 () Bool)

(assert (=> b!1110 m!1569))

(assert (=> b!525 d!641))

(declare-fun d!643 () Bool)

(declare-fun c!294 () Bool)

(assert (=> d!643 (= c!294 ((_ is Empty!3) (left!8 (left!8 (left!8 (right!8 lt!2))))))))

(declare-fun e!628 () (InoxSet (_ BitVec 32)))

(assert (=> d!643 (= (content!0 (left!8 (left!8 (left!8 (right!8 lt!2))))) e!628)))

(declare-fun b!1111 () Bool)

(assert (=> b!1111 (= e!628 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1112 () Bool)

(assert (=> b!1112 (= e!628 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (left!8 (right!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (left!8 (right!8 lt!2))))) true)) (content!0 (right!8 (left!8 (left!8 (left!8 (right!8 lt!2))))))))))

(assert (= (and d!643 c!294) b!1111))

(assert (= (and d!643 (not c!294)) b!1112))

(declare-fun m!1571 () Bool)

(assert (=> b!1112 m!1571))

(declare-fun m!1573 () Bool)

(assert (=> b!1112 m!1573))

(declare-fun m!1575 () Bool)

(assert (=> b!1112 m!1575))

(assert (=> b!511 d!643))

(declare-fun d!645 () Bool)

(declare-fun c!295 () Bool)

(assert (=> d!645 (= c!295 ((_ is Empty!3) (right!8 (left!8 (left!8 (right!8 lt!2))))))))

(declare-fun e!629 () (InoxSet (_ BitVec 32)))

(assert (=> d!645 (= (content!0 (right!8 (left!8 (left!8 (right!8 lt!2))))) e!629)))

(declare-fun b!1113 () Bool)

(assert (=> b!1113 (= e!629 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1114 () Bool)

(assert (=> b!1114 (= e!629 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (left!8 (right!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (left!8 (right!8 lt!2))))) true)) (content!0 (right!8 (right!8 (left!8 (left!8 (right!8 lt!2))))))))))

(assert (= (and d!645 c!295) b!1113))

(assert (= (and d!645 (not c!295)) b!1114))

(declare-fun m!1577 () Bool)

(assert (=> b!1114 m!1577))

(declare-fun m!1579 () Bool)

(assert (=> b!1114 m!1579))

(declare-fun m!1581 () Bool)

(assert (=> b!1114 m!1581))

(assert (=> b!511 d!645))

(declare-fun d!647 () Bool)

(assert (=> d!647 (= (isBlack!0 (left!8 (right!8 (right!8 lt!5)))) (or ((_ is Empty!3) (left!8 (right!8 (right!8 lt!5)))) ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 lt!5)))))))))

(assert (=> b!667 d!647))

(declare-fun d!649 () Bool)

(assert (=> d!649 (= (isBlack!0 (left!8 (right!8 (right!8 (right!8 t!78))))) (or ((_ is Empty!3) (left!8 (right!8 (right!8 (right!8 t!78))))) ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 (right!8 t!78))))))))))

(assert (=> b!554 d!649))

(declare-fun b!1115 () Bool)

(declare-fun res!603 () Bool)

(declare-fun call!192 () Bool)

(assert (=> b!1115 (= res!603 call!192)))

(declare-fun e!632 () Bool)

(assert (=> b!1115 (=> (not res!603) (not e!632))))

(declare-fun d!651 () Bool)

(declare-fun res!601 () Bool)

(declare-fun e!633 () Bool)

(assert (=> d!651 (=> res!601 e!633)))

(assert (=> d!651 (= res!601 ((_ is Empty!3) (right!8 (left!8 (left!8 (right!8 t!78))))))))

(assert (=> d!651 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (right!8 t!78))))) e!633)))

(declare-fun b!1116 () Bool)

(declare-fun call!191 () Bool)

(assert (=> b!1116 (= e!632 call!191)))

(declare-fun bm!191 () Bool)

(assert (=> bm!191 (= call!192 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (left!8 (right!8 t!78)))))))))

(declare-fun bm!192 () Bool)

(assert (=> bm!192 (= call!191 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (left!8 (right!8 t!78)))))))))

(declare-fun b!1117 () Bool)

(declare-fun res!602 () Bool)

(assert (=> b!1117 (= res!602 (isBlack!0 (right!8 (right!8 (left!8 (left!8 (right!8 t!78)))))))))

(assert (=> b!1117 (=> (not res!602) (not e!632))))

(declare-fun b!1118 () Bool)

(declare-fun e!631 () Bool)

(assert (=> b!1118 (= e!631 call!191)))

(declare-fun b!1119 () Bool)

(declare-fun e!630 () Bool)

(assert (=> b!1119 (= e!630 e!632)))

(declare-fun res!599 () Bool)

(assert (=> b!1119 (= res!599 (isBlack!0 (left!8 (right!8 (left!8 (left!8 (right!8 t!78)))))))))

(assert (=> b!1119 (=> (not res!599) (not e!632))))

(declare-fun b!1120 () Bool)

(assert (=> b!1120 (= e!633 e!630)))

(declare-fun c!296 () Bool)

(assert (=> b!1120 (= c!296 ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 (right!8 t!78)))))))))

(declare-fun b!1121 () Bool)

(assert (=> b!1121 (= e!630 e!631)))

(declare-fun res!600 () Bool)

(assert (=> b!1121 (= res!600 call!192)))

(assert (=> b!1121 (=> (not res!600) (not e!631))))

(assert (= (and d!651 (not res!601)) b!1120))

(assert (= (and b!1120 c!296) b!1121))

(assert (= (and b!1120 (not c!296)) b!1119))

(assert (= (and b!1121 res!600) b!1118))

(assert (= (and b!1119 res!599) b!1117))

(assert (= (and b!1117 res!602) b!1115))

(assert (= (and b!1115 res!603) b!1116))

(assert (= (or b!1121 b!1115) bm!191))

(assert (= (or b!1118 b!1116) bm!192))

(declare-fun m!1583 () Bool)

(assert (=> bm!191 m!1583))

(declare-fun m!1585 () Bool)

(assert (=> bm!192 m!1585))

(declare-fun m!1587 () Bool)

(assert (=> b!1117 m!1587))

(declare-fun m!1589 () Bool)

(assert (=> b!1119 m!1589))

(assert (=> bm!125 d!651))

(declare-fun d!653 () Bool)

(assert (=> d!653 (= (isBlack!0 (right!8 (right!8 (right!8 (left!8 t!78))))) (or ((_ is Empty!3) (right!8 (right!8 (right!8 (left!8 t!78))))) ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 (left!8 t!78))))))))))

(assert (=> b!777 d!653))

(declare-fun d!655 () Bool)

(declare-fun c!297 () Bool)

(assert (=> d!655 (= c!297 ((_ is Empty!3) (left!8 (right!8 lt!12))))))

(declare-fun e!634 () (InoxSet (_ BitVec 32)))

(assert (=> d!655 (= (content!0 (left!8 (right!8 lt!12))) e!634)))

(declare-fun b!1122 () Bool)

(assert (=> b!1122 (= e!634 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1123 () Bool)

(assert (=> b!1123 (= e!634 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 lt!12)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 lt!12))) true)) (content!0 (right!8 (left!8 (right!8 lt!12))))))))

(assert (= (and d!655 c!297) b!1122))

(assert (= (and d!655 (not c!297)) b!1123))

(declare-fun m!1591 () Bool)

(assert (=> b!1123 m!1591))

(declare-fun m!1593 () Bool)

(assert (=> b!1123 m!1593))

(declare-fun m!1595 () Bool)

(assert (=> b!1123 m!1595))

(assert (=> b!641 d!655))

(declare-fun d!657 () Bool)

(declare-fun c!298 () Bool)

(assert (=> d!657 (= c!298 ((_ is Empty!3) (right!8 (right!8 lt!12))))))

(declare-fun e!635 () (InoxSet (_ BitVec 32)))

(assert (=> d!657 (= (content!0 (right!8 (right!8 lt!12))) e!635)))

(declare-fun b!1124 () Bool)

(assert (=> b!1124 (= e!635 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1125 () Bool)

(assert (=> b!1125 (= e!635 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 lt!12)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 lt!12))) true)) (content!0 (right!8 (right!8 (right!8 lt!12))))))))

(assert (= (and d!657 c!298) b!1124))

(assert (= (and d!657 (not c!298)) b!1125))

(declare-fun m!1597 () Bool)

(assert (=> b!1125 m!1597))

(declare-fun m!1599 () Bool)

(assert (=> b!1125 m!1599))

(declare-fun m!1601 () Bool)

(assert (=> b!1125 m!1601))

(assert (=> b!641 d!657))

(declare-fun d!659 () Bool)

(declare-fun c!299 () Bool)

(assert (=> d!659 (= c!299 ((_ is Empty!3) (left!8 (left!8 lt!13))))))

(declare-fun e!636 () (InoxSet (_ BitVec 32)))

(assert (=> d!659 (= (content!0 (left!8 (left!8 lt!13))) e!636)))

(declare-fun b!1126 () Bool)

(assert (=> b!1126 (= e!636 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1127 () Bool)

(assert (=> b!1127 (= e!636 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 lt!13)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 lt!13))) true)) (content!0 (right!8 (left!8 (left!8 lt!13))))))))

(assert (= (and d!659 c!299) b!1126))

(assert (= (and d!659 (not c!299)) b!1127))

(declare-fun m!1603 () Bool)

(assert (=> b!1127 m!1603))

(declare-fun m!1605 () Bool)

(assert (=> b!1127 m!1605))

(declare-fun m!1607 () Bool)

(assert (=> b!1127 m!1607))

(assert (=> b!797 d!659))

(declare-fun d!661 () Bool)

(declare-fun c!300 () Bool)

(assert (=> d!661 (= c!300 ((_ is Empty!3) (right!8 (left!8 lt!13))))))

(declare-fun e!637 () (InoxSet (_ BitVec 32)))

(assert (=> d!661 (= (content!0 (right!8 (left!8 lt!13))) e!637)))

(declare-fun b!1128 () Bool)

(assert (=> b!1128 (= e!637 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1129 () Bool)

(assert (=> b!1129 (= e!637 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 lt!13)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 lt!13))) true)) (content!0 (right!8 (right!8 (left!8 lt!13))))))))

(assert (= (and d!661 c!300) b!1128))

(assert (= (and d!661 (not c!300)) b!1129))

(declare-fun m!1609 () Bool)

(assert (=> b!1129 m!1609))

(declare-fun m!1611 () Bool)

(assert (=> b!1129 m!1611))

(declare-fun m!1613 () Bool)

(assert (=> b!1129 m!1613))

(assert (=> b!797 d!661))

(declare-fun b!1130 () Bool)

(declare-fun res!608 () Bool)

(declare-fun call!194 () Bool)

(assert (=> b!1130 (= res!608 call!194)))

(declare-fun e!640 () Bool)

(assert (=> b!1130 (=> (not res!608) (not e!640))))

(declare-fun d!663 () Bool)

(declare-fun res!606 () Bool)

(declare-fun e!641 () Bool)

(assert (=> d!663 (=> res!606 e!641)))

(assert (=> d!663 (= res!606 ((_ is Empty!3) (right!8 (left!8 (left!8 (left!8 lt!2))))))))

(assert (=> d!663 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (left!8 lt!2))))) e!641)))

(declare-fun b!1131 () Bool)

(declare-fun call!193 () Bool)

(assert (=> b!1131 (= e!640 call!193)))

(declare-fun bm!193 () Bool)

(assert (=> bm!193 (= call!194 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (left!8 (left!8 lt!2)))))))))

(declare-fun bm!194 () Bool)

(assert (=> bm!194 (= call!193 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (left!8 (left!8 lt!2)))))))))

(declare-fun b!1132 () Bool)

(declare-fun res!607 () Bool)

(assert (=> b!1132 (= res!607 (isBlack!0 (right!8 (right!8 (left!8 (left!8 (left!8 lt!2)))))))))

(assert (=> b!1132 (=> (not res!607) (not e!640))))

(declare-fun b!1133 () Bool)

(declare-fun e!639 () Bool)

(assert (=> b!1133 (= e!639 call!193)))

(declare-fun b!1134 () Bool)

(declare-fun e!638 () Bool)

(assert (=> b!1134 (= e!638 e!640)))

(declare-fun res!604 () Bool)

(assert (=> b!1134 (= res!604 (isBlack!0 (left!8 (right!8 (left!8 (left!8 (left!8 lt!2)))))))))

(assert (=> b!1134 (=> (not res!604) (not e!640))))

(declare-fun b!1135 () Bool)

(assert (=> b!1135 (= e!641 e!638)))

(declare-fun c!301 () Bool)

(assert (=> b!1135 (= c!301 ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 (left!8 lt!2)))))))))

(declare-fun b!1136 () Bool)

(assert (=> b!1136 (= e!638 e!639)))

(declare-fun res!605 () Bool)

(assert (=> b!1136 (= res!605 call!194)))

(assert (=> b!1136 (=> (not res!605) (not e!639))))

(assert (= (and d!663 (not res!606)) b!1135))

(assert (= (and b!1135 c!301) b!1136))

(assert (= (and b!1135 (not c!301)) b!1134))

(assert (= (and b!1136 res!605) b!1133))

(assert (= (and b!1134 res!604) b!1132))

(assert (= (and b!1132 res!607) b!1130))

(assert (= (and b!1130 res!608) b!1131))

(assert (= (or b!1136 b!1130) bm!193))

(assert (= (or b!1133 b!1131) bm!194))

(declare-fun m!1615 () Bool)

(assert (=> bm!193 m!1615))

(declare-fun m!1617 () Bool)

(assert (=> bm!194 m!1617))

(declare-fun m!1619 () Bool)

(assert (=> b!1132 m!1619))

(declare-fun m!1621 () Bool)

(assert (=> b!1134 m!1621))

(assert (=> bm!81 d!663))

(declare-fun b!1137 () Bool)

(declare-fun res!613 () Bool)

(declare-fun call!196 () Bool)

(assert (=> b!1137 (= res!613 call!196)))

(declare-fun e!644 () Bool)

(assert (=> b!1137 (=> (not res!613) (not e!644))))

(declare-fun d!665 () Bool)

(declare-fun res!611 () Bool)

(declare-fun e!645 () Bool)

(assert (=> d!665 (=> res!611 e!645)))

(assert (=> d!665 (= res!611 ((_ is Empty!3) (right!8 (right!8 (left!8 (left!8 lt!2))))))))

(assert (=> d!665 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (left!8 lt!2))))) e!645)))

(declare-fun b!1138 () Bool)

(declare-fun call!195 () Bool)

(assert (=> b!1138 (= e!644 call!195)))

(declare-fun bm!195 () Bool)

(assert (=> bm!195 (= call!196 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (left!8 (left!8 lt!2)))))))))

(declare-fun bm!196 () Bool)

(assert (=> bm!196 (= call!195 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (left!8 (left!8 lt!2)))))))))

(declare-fun b!1139 () Bool)

(declare-fun res!612 () Bool)

(assert (=> b!1139 (= res!612 (isBlack!0 (right!8 (right!8 (right!8 (left!8 (left!8 lt!2)))))))))

(assert (=> b!1139 (=> (not res!612) (not e!644))))

(declare-fun b!1140 () Bool)

(declare-fun e!643 () Bool)

(assert (=> b!1140 (= e!643 call!195)))

(declare-fun b!1141 () Bool)

(declare-fun e!642 () Bool)

(assert (=> b!1141 (= e!642 e!644)))

(declare-fun res!609 () Bool)

(assert (=> b!1141 (= res!609 (isBlack!0 (left!8 (right!8 (right!8 (left!8 (left!8 lt!2)))))))))

(assert (=> b!1141 (=> (not res!609) (not e!644))))

(declare-fun b!1142 () Bool)

(assert (=> b!1142 (= e!645 e!642)))

(declare-fun c!302 () Bool)

(assert (=> b!1142 (= c!302 ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 (left!8 lt!2)))))))))

(declare-fun b!1143 () Bool)

(assert (=> b!1143 (= e!642 e!643)))

(declare-fun res!610 () Bool)

(assert (=> b!1143 (= res!610 call!196)))

(assert (=> b!1143 (=> (not res!610) (not e!643))))

(assert (= (and d!665 (not res!611)) b!1142))

(assert (= (and b!1142 c!302) b!1143))

(assert (= (and b!1142 (not c!302)) b!1141))

(assert (= (and b!1143 res!610) b!1140))

(assert (= (and b!1141 res!609) b!1139))

(assert (= (and b!1139 res!612) b!1137))

(assert (= (and b!1137 res!613) b!1138))

(assert (= (or b!1143 b!1137) bm!195))

(assert (= (or b!1140 b!1138) bm!196))

(declare-fun m!1623 () Bool)

(assert (=> bm!195 m!1623))

(declare-fun m!1625 () Bool)

(assert (=> bm!196 m!1625))

(declare-fun m!1627 () Bool)

(assert (=> b!1139 m!1627))

(declare-fun m!1629 () Bool)

(assert (=> b!1141 m!1629))

(assert (=> bm!97 d!665))

(declare-fun d!667 () Bool)

(assert (=> d!667 (= (isBlack!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (or ((_ is Empty!3) (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) ((_ is Black!3) (color!6 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (=> b!790 d!667))

(declare-fun d!669 () Bool)

(assert (=> d!669 (= (isBlack!0 (left!8 (left!8 (right!8 (right!8 lt!2))))) (or ((_ is Empty!3) (left!8 (left!8 (right!8 (right!8 lt!2))))) ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 (right!8 lt!2))))))))))

(assert (=> b!587 d!669))

(declare-fun d!671 () Bool)

(declare-fun lt!52 () Int)

(assert (=> d!671 (>= lt!52 0)))

(declare-fun e!646 () Int)

(assert (=> d!671 (= lt!52 e!646)))

(declare-fun c!303 () Bool)

(assert (=> d!671 (= c!303 ((_ is Empty!3) lt!28))))

(assert (=> d!671 (= (size!0 lt!28) lt!52)))

(declare-fun b!1144 () Bool)

(assert (=> b!1144 (= e!646 0)))

(declare-fun b!1145 () Bool)

(assert (=> b!1145 (= e!646 (+ (size!0 (left!8 lt!28)) 1 (size!0 (right!8 lt!28))))))

(assert (= (and d!671 c!303) b!1144))

(assert (= (and d!671 (not c!303)) b!1145))

(declare-fun m!1631 () Bool)

(assert (=> b!1145 m!1631))

(declare-fun m!1633 () Bool)

(assert (=> b!1145 m!1633))

(assert (=> b!600 d!671))

(declare-fun d!673 () Bool)

(declare-fun lt!53 () Int)

(assert (=> d!673 (>= lt!53 0)))

(declare-fun e!647 () Int)

(assert (=> d!673 (= lt!53 e!647)))

(declare-fun c!304 () Bool)

(assert (=> d!673 (= c!304 ((_ is Empty!3) (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> d!673 (= (size!0 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) lt!53)))

(declare-fun b!1146 () Bool)

(assert (=> b!1146 (= e!647 0)))

(declare-fun b!1147 () Bool)

(assert (=> b!1147 (= e!647 (+ (size!0 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) 1 (size!0 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))))

(assert (= (and d!673 c!304) b!1146))

(assert (= (and d!673 (not c!304)) b!1147))

(declare-fun m!1635 () Bool)

(assert (=> b!1147 m!1635))

(declare-fun m!1637 () Bool)

(assert (=> b!1147 m!1637))

(assert (=> b!600 d!673))

(assert (=> bm!108 d!573))

(declare-fun d!675 () Bool)

(declare-fun res!614 () Bool)

(declare-fun e!648 () Bool)

(assert (=> d!675 (=> res!614 e!648)))

(assert (=> d!675 (= res!614 (not ((_ is Node!3) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> d!675 (= (blackBalanced!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) e!648)))

(declare-fun b!1148 () Bool)

(declare-fun e!649 () Bool)

(assert (=> b!1148 (= e!648 e!649)))

(declare-fun res!616 () Bool)

(assert (=> b!1148 (=> (not res!616) (not e!649))))

(assert (=> b!1148 (= res!616 (blackBalanced!0 (left!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!1149 () Bool)

(declare-fun res!615 () Bool)

(assert (=> b!1149 (=> (not res!615) (not e!649))))

(assert (=> b!1149 (= res!615 (blackBalanced!0 (right!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!1150 () Bool)

(assert (=> b!1150 (= e!649 (= (blackHeight!0 (left!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (blackHeight!0 (right!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (= (and d!675 (not res!614)) b!1148))

(assert (= (and b!1148 res!616) b!1149))

(assert (= (and b!1149 res!615) b!1150))

(declare-fun m!1639 () Bool)

(assert (=> b!1148 m!1639))

(declare-fun m!1641 () Bool)

(assert (=> b!1149 m!1641))

(assert (=> b!1150 m!1149))

(declare-fun m!1643 () Bool)

(assert (=> b!1150 m!1643))

(assert (=> b!492 d!675))

(declare-fun b!1151 () Bool)

(declare-fun res!621 () Bool)

(declare-fun call!198 () Bool)

(assert (=> b!1151 (= res!621 call!198)))

(declare-fun e!652 () Bool)

(assert (=> b!1151 (=> (not res!621) (not e!652))))

(declare-fun d!677 () Bool)

(declare-fun res!619 () Bool)

(declare-fun e!653 () Bool)

(assert (=> d!677 (=> res!619 e!653)))

(assert (=> d!677 (= res!619 ((_ is Empty!3) (left!8 (right!8 (left!8 (right!8 t!78))))))))

(assert (=> d!677 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (right!8 t!78))))) e!653)))

(declare-fun b!1152 () Bool)

(declare-fun call!197 () Bool)

(assert (=> b!1152 (= e!652 call!197)))

(declare-fun bm!197 () Bool)

(assert (=> bm!197 (= call!198 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (left!8 (right!8 t!78)))))))))

(declare-fun bm!198 () Bool)

(assert (=> bm!198 (= call!197 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (left!8 (right!8 t!78)))))))))

(declare-fun b!1153 () Bool)

(declare-fun res!620 () Bool)

(assert (=> b!1153 (= res!620 (isBlack!0 (right!8 (left!8 (right!8 (left!8 (right!8 t!78)))))))))

(assert (=> b!1153 (=> (not res!620) (not e!652))))

(declare-fun b!1154 () Bool)

(declare-fun e!651 () Bool)

(assert (=> b!1154 (= e!651 call!197)))

(declare-fun b!1155 () Bool)

(declare-fun e!650 () Bool)

(assert (=> b!1155 (= e!650 e!652)))

(declare-fun res!617 () Bool)

(assert (=> b!1155 (= res!617 (isBlack!0 (left!8 (left!8 (right!8 (left!8 (right!8 t!78)))))))))

(assert (=> b!1155 (=> (not res!617) (not e!652))))

(declare-fun b!1156 () Bool)

(assert (=> b!1156 (= e!653 e!650)))

(declare-fun c!305 () Bool)

(assert (=> b!1156 (= c!305 ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 (right!8 t!78)))))))))

(declare-fun b!1157 () Bool)

(assert (=> b!1157 (= e!650 e!651)))

(declare-fun res!618 () Bool)

(assert (=> b!1157 (= res!618 call!198)))

(assert (=> b!1157 (=> (not res!618) (not e!651))))

(assert (= (and d!677 (not res!619)) b!1156))

(assert (= (and b!1156 c!305) b!1157))

(assert (= (and b!1156 (not c!305)) b!1155))

(assert (= (and b!1157 res!618) b!1154))

(assert (= (and b!1155 res!617) b!1153))

(assert (= (and b!1153 res!620) b!1151))

(assert (= (and b!1151 res!621) b!1152))

(assert (= (or b!1157 b!1151) bm!197))

(assert (= (or b!1154 b!1152) bm!198))

(declare-fun m!1645 () Bool)

(assert (=> bm!197 m!1645))

(declare-fun m!1647 () Bool)

(assert (=> bm!198 m!1647))

(declare-fun m!1649 () Bool)

(assert (=> b!1153 m!1649))

(declare-fun m!1651 () Bool)

(assert (=> b!1155 m!1651))

(assert (=> bm!134 d!677))

(declare-fun d!679 () Bool)

(assert (=> d!679 (= (isBlack!0 (left!8 (left!8 (right!8 (left!8 t!78))))) (or ((_ is Empty!3) (left!8 (left!8 (right!8 (left!8 t!78))))) ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 (left!8 t!78))))))))))

(assert (=> b!701 d!679))

(declare-fun d!681 () Bool)

(assert (=> d!681 (= (isBlack!0 (right!8 (right!8 (right!8 (right!8 lt!2))))) (or ((_ is Empty!3) (right!8 (right!8 (right!8 (right!8 lt!2))))) ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 (right!8 lt!2))))))))))

(assert (=> b!658 d!681))

(declare-fun d!683 () Bool)

(assert (=> d!683 (= (isBlack!0 (right!8 (right!8 (left!8 (left!8 t!78))))) (or ((_ is Empty!3) (right!8 (right!8 (left!8 (left!8 t!78))))) ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 (left!8 t!78))))))))))

(assert (=> b!545 d!683))

(declare-fun d!685 () Bool)

(declare-fun c!306 () Bool)

(assert (=> d!685 (= c!306 ((_ is Empty!3) (left!8 (right!8 (right!8 t!78)))))))

(declare-fun e!654 () (_ BitVec 32))

(assert (=> d!685 (= (blackHeight!0 (left!8 (right!8 (right!8 t!78)))) e!654)))

(declare-fun b!1158 () Bool)

(declare-fun e!655 () (_ BitVec 32))

(declare-fun call!199 () (_ BitVec 32))

(assert (=> b!1158 (= e!655 (bvadd call!199 #b00000000000000000000000000000001))))

(declare-fun bm!199 () Bool)

(assert (=> bm!199 (= call!199 (blackHeight!0 (left!8 (left!8 (right!8 (right!8 t!78))))))))

(declare-fun b!1159 () Bool)

(assert (=> b!1159 (= e!655 call!199)))

(declare-fun b!1160 () Bool)

(assert (=> b!1160 (= e!654 e!655)))

(declare-fun c!307 () Bool)

(assert (=> b!1160 (= c!307 ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 t!78))))))))

(declare-fun b!1161 () Bool)

(assert (=> b!1161 (= e!654 #b00000000000000000000000000000001)))

(assert (= (and d!685 c!306) b!1161))

(assert (= (and d!685 (not c!306)) b!1160))

(assert (= (and b!1160 c!307) b!1158))

(assert (= (and b!1160 (not c!307)) b!1159))

(assert (= (or b!1158 b!1159) bm!199))

(declare-fun m!1653 () Bool)

(assert (=> bm!199 m!1653))

(assert (=> b!524 d!685))

(declare-fun d!687 () Bool)

(declare-fun c!308 () Bool)

(assert (=> d!687 (= c!308 ((_ is Empty!3) (right!8 (right!8 (right!8 t!78)))))))

(declare-fun e!656 () (_ BitVec 32))

(assert (=> d!687 (= (blackHeight!0 (right!8 (right!8 (right!8 t!78)))) e!656)))

(declare-fun b!1162 () Bool)

(declare-fun e!657 () (_ BitVec 32))

(declare-fun call!200 () (_ BitVec 32))

(assert (=> b!1162 (= e!657 (bvadd call!200 #b00000000000000000000000000000001))))

(declare-fun bm!200 () Bool)

(assert (=> bm!200 (= call!200 (blackHeight!0 (left!8 (right!8 (right!8 (right!8 t!78))))))))

(declare-fun b!1163 () Bool)

(assert (=> b!1163 (= e!657 call!200)))

(declare-fun b!1164 () Bool)

(assert (=> b!1164 (= e!656 e!657)))

(declare-fun c!309 () Bool)

(assert (=> b!1164 (= c!309 ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 t!78))))))))

(declare-fun b!1165 () Bool)

(assert (=> b!1165 (= e!656 #b00000000000000000000000000000001)))

(assert (= (and d!687 c!308) b!1165))

(assert (= (and d!687 (not c!308)) b!1164))

(assert (= (and b!1164 c!309) b!1162))

(assert (= (and b!1164 (not c!309)) b!1163))

(assert (= (or b!1162 b!1163) bm!200))

(assert (=> bm!200 m!1485))

(assert (=> b!524 d!687))

(declare-fun d!689 () Bool)

(assert (=> d!689 (= (isBlack!0 (right!8 (right!8 (right!8 (left!8 lt!2))))) (or ((_ is Empty!3) (right!8 (right!8 (right!8 (left!8 lt!2))))) ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 (left!8 lt!2))))))))))

(assert (=> b!682 d!689))

(declare-fun d!691 () Bool)

(declare-fun c!310 () Bool)

(assert (=> d!691 (= c!310 ((_ is Empty!3) (left!8 (left!8 (right!8 (left!8 t!78))))))))

(declare-fun e!658 () (InoxSet (_ BitVec 32)))

(assert (=> d!691 (= (content!0 (left!8 (left!8 (right!8 (left!8 t!78))))) e!658)))

(declare-fun b!1166 () Bool)

(assert (=> b!1166 (= e!658 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1167 () Bool)

(assert (=> b!1167 (= e!658 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (right!8 (left!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (right!8 (left!8 t!78))))) true)) (content!0 (right!8 (left!8 (left!8 (right!8 (left!8 t!78))))))))))

(assert (= (and d!691 c!310) b!1166))

(assert (= (and d!691 (not c!310)) b!1167))

(declare-fun m!1655 () Bool)

(assert (=> b!1167 m!1655))

(declare-fun m!1657 () Bool)

(assert (=> b!1167 m!1657))

(declare-fun m!1659 () Bool)

(assert (=> b!1167 m!1659))

(assert (=> b!822 d!691))

(declare-fun d!693 () Bool)

(declare-fun c!311 () Bool)

(assert (=> d!693 (= c!311 ((_ is Empty!3) (right!8 (left!8 (right!8 (left!8 t!78))))))))

(declare-fun e!659 () (InoxSet (_ BitVec 32)))

(assert (=> d!693 (= (content!0 (right!8 (left!8 (right!8 (left!8 t!78))))) e!659)))

(declare-fun b!1168 () Bool)

(assert (=> b!1168 (= e!659 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1169 () Bool)

(assert (=> b!1169 (= e!659 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (right!8 (left!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (right!8 (left!8 t!78))))) true)) (content!0 (right!8 (right!8 (left!8 (right!8 (left!8 t!78))))))))))

(assert (= (and d!693 c!311) b!1168))

(assert (= (and d!693 (not c!311)) b!1169))

(declare-fun m!1661 () Bool)

(assert (=> b!1169 m!1661))

(declare-fun m!1663 () Bool)

(assert (=> b!1169 m!1663))

(declare-fun m!1665 () Bool)

(assert (=> b!1169 m!1665))

(assert (=> b!822 d!693))

(declare-fun d!695 () Bool)

(declare-fun res!622 () Bool)

(declare-fun e!660 () Bool)

(assert (=> d!695 (=> res!622 e!660)))

(assert (=> d!695 (= res!622 (not ((_ is Node!3) (left!8 (left!8 (right!8 lt!5))))))))

(assert (=> d!695 (= (blackBalanced!0 (left!8 (left!8 (right!8 lt!5)))) e!660)))

(declare-fun b!1170 () Bool)

(declare-fun e!661 () Bool)

(assert (=> b!1170 (= e!660 e!661)))

(declare-fun res!624 () Bool)

(assert (=> b!1170 (=> (not res!624) (not e!661))))

(assert (=> b!1170 (= res!624 (blackBalanced!0 (left!8 (left!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!1171 () Bool)

(declare-fun res!623 () Bool)

(assert (=> b!1171 (=> (not res!623) (not e!661))))

(assert (=> b!1171 (= res!623 (blackBalanced!0 (right!8 (left!8 (left!8 (right!8 lt!5))))))))

(declare-fun b!1172 () Bool)

(assert (=> b!1172 (= e!661 (= (blackHeight!0 (left!8 (left!8 (left!8 (right!8 lt!5))))) (blackHeight!0 (right!8 (left!8 (left!8 (right!8 lt!5)))))))))

(assert (= (and d!695 (not res!622)) b!1170))

(assert (= (and b!1170 res!624) b!1171))

(assert (= (and b!1171 res!623) b!1172))

(declare-fun m!1667 () Bool)

(assert (=> b!1170 m!1667))

(declare-fun m!1669 () Bool)

(assert (=> b!1171 m!1669))

(assert (=> b!1172 m!1377))

(declare-fun m!1671 () Bool)

(assert (=> b!1172 m!1671))

(assert (=> b!765 d!695))

(declare-fun d!697 () Bool)

(declare-fun res!625 () Bool)

(declare-fun e!662 () Bool)

(assert (=> d!697 (=> res!625 e!662)))

(assert (=> d!697 (= res!625 (not ((_ is Node!3) (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> d!697 (= (blackBalanced!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!662)))

(declare-fun b!1173 () Bool)

(declare-fun e!663 () Bool)

(assert (=> b!1173 (= e!662 e!663)))

(declare-fun res!627 () Bool)

(assert (=> b!1173 (=> (not res!627) (not e!663))))

(assert (=> b!1173 (= res!627 (blackBalanced!0 (left!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1174 () Bool)

(declare-fun res!626 () Bool)

(assert (=> b!1174 (=> (not res!626) (not e!663))))

(assert (=> b!1174 (= res!626 (blackBalanced!0 (right!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1175 () Bool)

(assert (=> b!1175 (= e!663 (= (blackHeight!0 (left!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (blackHeight!0 (right!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!697 (not res!625)) b!1173))

(assert (= (and b!1173 res!627) b!1174))

(assert (= (and b!1174 res!626) b!1175))

(declare-fun m!1673 () Bool)

(assert (=> b!1173 m!1673))

(declare-fun m!1675 () Bool)

(assert (=> b!1174 m!1675))

(assert (=> b!1175 m!1213))

(declare-fun m!1677 () Bool)

(assert (=> b!1175 m!1677))

(assert (=> b!526 d!697))

(declare-fun b!1176 () Bool)

(declare-fun res!632 () Bool)

(declare-fun call!202 () Bool)

(assert (=> b!1176 (= res!632 call!202)))

(declare-fun e!666 () Bool)

(assert (=> b!1176 (=> (not res!632) (not e!666))))

(declare-fun d!699 () Bool)

(declare-fun res!630 () Bool)

(declare-fun e!667 () Bool)

(assert (=> d!699 (=> res!630 e!667)))

(assert (=> d!699 (= res!630 ((_ is Empty!3) (left!8 (left!8 (right!8 (left!8 lt!2))))))))

(assert (=> d!699 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (left!8 lt!2))))) e!667)))

(declare-fun b!1177 () Bool)

(declare-fun call!201 () Bool)

(assert (=> b!1177 (= e!666 call!201)))

(declare-fun bm!201 () Bool)

(assert (=> bm!201 (= call!202 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (right!8 (left!8 lt!2)))))))))

(declare-fun bm!202 () Bool)

(assert (=> bm!202 (= call!201 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (right!8 (left!8 lt!2)))))))))

(declare-fun b!1178 () Bool)

(declare-fun res!631 () Bool)

(assert (=> b!1178 (= res!631 (isBlack!0 (right!8 (left!8 (left!8 (right!8 (left!8 lt!2)))))))))

(assert (=> b!1178 (=> (not res!631) (not e!666))))

(declare-fun b!1179 () Bool)

(declare-fun e!665 () Bool)

(assert (=> b!1179 (= e!665 call!201)))

(declare-fun b!1180 () Bool)

(declare-fun e!664 () Bool)

(assert (=> b!1180 (= e!664 e!666)))

(declare-fun res!628 () Bool)

(assert (=> b!1180 (= res!628 (isBlack!0 (left!8 (left!8 (left!8 (right!8 (left!8 lt!2)))))))))

(assert (=> b!1180 (=> (not res!628) (not e!666))))

(declare-fun b!1181 () Bool)

(assert (=> b!1181 (= e!667 e!664)))

(declare-fun c!312 () Bool)

(assert (=> b!1181 (= c!312 ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 (left!8 lt!2)))))))))

(declare-fun b!1182 () Bool)

(assert (=> b!1182 (= e!664 e!665)))

(declare-fun res!629 () Bool)

(assert (=> b!1182 (= res!629 call!202)))

(assert (=> b!1182 (=> (not res!629) (not e!665))))

(assert (= (and d!699 (not res!630)) b!1181))

(assert (= (and b!1181 c!312) b!1182))

(assert (= (and b!1181 (not c!312)) b!1180))

(assert (= (and b!1182 res!629) b!1179))

(assert (= (and b!1180 res!628) b!1178))

(assert (= (and b!1178 res!631) b!1176))

(assert (= (and b!1176 res!632) b!1177))

(assert (= (or b!1182 b!1176) bm!201))

(assert (= (or b!1179 b!1177) bm!202))

(declare-fun m!1679 () Bool)

(assert (=> bm!201 m!1679))

(declare-fun m!1681 () Bool)

(assert (=> bm!202 m!1681))

(declare-fun m!1683 () Bool)

(assert (=> b!1178 m!1683))

(declare-fun m!1685 () Bool)

(assert (=> b!1180 m!1685))

(assert (=> bm!110 d!699))

(declare-fun b!1183 () Bool)

(declare-fun res!637 () Bool)

(declare-fun call!204 () Bool)

(assert (=> b!1183 (= res!637 call!204)))

(declare-fun e!670 () Bool)

(assert (=> b!1183 (=> (not res!637) (not e!670))))

(declare-fun d!701 () Bool)

(declare-fun res!635 () Bool)

(declare-fun e!671 () Bool)

(assert (=> d!701 (=> res!635 e!671)))

(assert (=> d!701 (= res!635 ((_ is Empty!3) (left!8 lt!19)))))

(assert (=> d!701 (= (redNodesHaveBlackChildren!0 (left!8 lt!19)) e!671)))

(declare-fun b!1184 () Bool)

(declare-fun call!203 () Bool)

(assert (=> b!1184 (= e!670 call!203)))

(declare-fun bm!203 () Bool)

(assert (=> bm!203 (= call!204 (redNodesHaveBlackChildren!0 (left!8 (left!8 lt!19))))))

(declare-fun bm!204 () Bool)

(assert (=> bm!204 (= call!203 (redNodesHaveBlackChildren!0 (right!8 (left!8 lt!19))))))

(declare-fun b!1185 () Bool)

(declare-fun res!636 () Bool)

(assert (=> b!1185 (= res!636 (isBlack!0 (right!8 (left!8 lt!19))))))

(assert (=> b!1185 (=> (not res!636) (not e!670))))

(declare-fun b!1186 () Bool)

(declare-fun e!669 () Bool)

(assert (=> b!1186 (= e!669 call!203)))

(declare-fun b!1187 () Bool)

(declare-fun e!668 () Bool)

(assert (=> b!1187 (= e!668 e!670)))

(declare-fun res!633 () Bool)

(assert (=> b!1187 (= res!633 (isBlack!0 (left!8 (left!8 lt!19))))))

(assert (=> b!1187 (=> (not res!633) (not e!670))))

(declare-fun b!1188 () Bool)

(assert (=> b!1188 (= e!671 e!668)))

(declare-fun c!313 () Bool)

(assert (=> b!1188 (= c!313 ((_ is Black!3) (color!6 (left!8 lt!19))))))

(declare-fun b!1189 () Bool)

(assert (=> b!1189 (= e!668 e!669)))

(declare-fun res!634 () Bool)

(assert (=> b!1189 (= res!634 call!204)))

(assert (=> b!1189 (=> (not res!634) (not e!669))))

(assert (= (and d!701 (not res!635)) b!1188))

(assert (= (and b!1188 c!313) b!1189))

(assert (= (and b!1188 (not c!313)) b!1187))

(assert (= (and b!1189 res!634) b!1186))

(assert (= (and b!1187 res!633) b!1185))

(assert (= (and b!1185 res!636) b!1183))

(assert (= (and b!1183 res!637) b!1184))

(assert (= (or b!1189 b!1183) bm!203))

(assert (= (or b!1186 b!1184) bm!204))

(declare-fun m!1687 () Bool)

(assert (=> bm!203 m!1687))

(declare-fun m!1689 () Bool)

(assert (=> bm!204 m!1689))

(declare-fun m!1691 () Bool)

(assert (=> b!1185 m!1691))

(declare-fun m!1693 () Bool)

(assert (=> b!1187 m!1693))

(assert (=> b!704 d!701))

(declare-fun d!703 () Bool)

(declare-fun res!638 () Bool)

(declare-fun e!672 () Bool)

(assert (=> d!703 (=> res!638 e!672)))

(assert (=> d!703 (= res!638 (not ((_ is Node!3) (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> d!703 (= (blackBalanced!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!672)))

(declare-fun b!1190 () Bool)

(declare-fun e!673 () Bool)

(assert (=> b!1190 (= e!672 e!673)))

(declare-fun res!640 () Bool)

(assert (=> b!1190 (=> (not res!640) (not e!673))))

(assert (=> b!1190 (= res!640 (blackBalanced!0 (left!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1191 () Bool)

(declare-fun res!639 () Bool)

(assert (=> b!1191 (=> (not res!639) (not e!673))))

(assert (=> b!1191 (= res!639 (blackBalanced!0 (right!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1192 () Bool)

(assert (=> b!1192 (= e!673 (= (blackHeight!0 (left!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (blackHeight!0 (right!8 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!703 (not res!638)) b!1190))

(assert (= (and b!1190 res!640) b!1191))

(assert (= (and b!1191 res!639) b!1192))

(declare-fun m!1695 () Bool)

(assert (=> b!1190 m!1695))

(declare-fun m!1697 () Bool)

(assert (=> b!1191 m!1697))

(assert (=> b!1192 m!1407))

(declare-fun m!1699 () Bool)

(assert (=> b!1192 m!1699))

(assert (=> b!793 d!703))

(declare-fun d!705 () Bool)

(assert (=> d!705 (= (isBlack!0 (right!8 (left!8 (left!8 (right!8 t!78))))) (or ((_ is Empty!3) (right!8 (left!8 (left!8 (right!8 t!78))))) ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 (right!8 t!78))))))))))

(assert (=> b!692 d!705))

(declare-fun d!707 () Bool)

(declare-fun res!641 () Bool)

(declare-fun e!674 () Bool)

(assert (=> d!707 (=> res!641 e!674)))

(assert (=> d!707 (= res!641 (not ((_ is Node!3) (left!8 (right!8 (left!8 lt!5))))))))

(assert (=> d!707 (= (blackBalanced!0 (left!8 (right!8 (left!8 lt!5)))) e!674)))

(declare-fun b!1193 () Bool)

(declare-fun e!675 () Bool)

(assert (=> b!1193 (= e!674 e!675)))

(declare-fun res!643 () Bool)

(assert (=> b!1193 (=> (not res!643) (not e!675))))

(assert (=> b!1193 (= res!643 (blackBalanced!0 (left!8 (left!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!1194 () Bool)

(declare-fun res!642 () Bool)

(assert (=> b!1194 (=> (not res!642) (not e!675))))

(assert (=> b!1194 (= res!642 (blackBalanced!0 (right!8 (left!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!1195 () Bool)

(assert (=> b!1195 (= e!675 (= (blackHeight!0 (left!8 (left!8 (right!8 (left!8 lt!5))))) (blackHeight!0 (right!8 (left!8 (right!8 (left!8 lt!5)))))))))

(assert (= (and d!707 (not res!641)) b!1193))

(assert (= (and b!1193 res!643) b!1194))

(assert (= (and b!1194 res!642) b!1195))

(declare-fun m!1701 () Bool)

(assert (=> b!1193 m!1701))

(declare-fun m!1703 () Bool)

(assert (=> b!1194 m!1703))

(assert (=> b!1195 m!1215))

(declare-fun m!1705 () Bool)

(assert (=> b!1195 m!1705))

(assert (=> b!800 d!707))

(declare-fun b!1196 () Bool)

(declare-fun res!648 () Bool)

(declare-fun call!206 () Bool)

(assert (=> b!1196 (= res!648 call!206)))

(declare-fun e!678 () Bool)

(assert (=> b!1196 (=> (not res!648) (not e!678))))

(declare-fun d!709 () Bool)

(declare-fun res!646 () Bool)

(declare-fun e!679 () Bool)

(assert (=> d!709 (=> res!646 e!679)))

(assert (=> d!709 (= res!646 ((_ is Empty!3) (left!8 (left!8 (left!8 (right!8 lt!2))))))))

(assert (=> d!709 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (right!8 lt!2))))) e!679)))

(declare-fun b!1197 () Bool)

(declare-fun call!205 () Bool)

(assert (=> b!1197 (= e!678 call!205)))

(declare-fun bm!205 () Bool)

(assert (=> bm!205 (= call!206 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (left!8 (right!8 lt!2)))))))))

(declare-fun bm!206 () Bool)

(assert (=> bm!206 (= call!205 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (left!8 (right!8 lt!2)))))))))

(declare-fun b!1198 () Bool)

(declare-fun res!647 () Bool)

(assert (=> b!1198 (= res!647 (isBlack!0 (right!8 (left!8 (left!8 (left!8 (right!8 lt!2)))))))))

(assert (=> b!1198 (=> (not res!647) (not e!678))))

(declare-fun b!1199 () Bool)

(declare-fun e!677 () Bool)

(assert (=> b!1199 (= e!677 call!205)))

(declare-fun b!1200 () Bool)

(declare-fun e!676 () Bool)

(assert (=> b!1200 (= e!676 e!678)))

(declare-fun res!644 () Bool)

(assert (=> b!1200 (= res!644 (isBlack!0 (left!8 (left!8 (left!8 (left!8 (right!8 lt!2)))))))))

(assert (=> b!1200 (=> (not res!644) (not e!678))))

(declare-fun b!1201 () Bool)

(assert (=> b!1201 (= e!679 e!676)))

(declare-fun c!314 () Bool)

(assert (=> b!1201 (= c!314 ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 (right!8 lt!2)))))))))

(declare-fun b!1202 () Bool)

(assert (=> b!1202 (= e!676 e!677)))

(declare-fun res!645 () Bool)

(assert (=> b!1202 (= res!645 call!206)))

(assert (=> b!1202 (=> (not res!645) (not e!677))))

(assert (= (and d!709 (not res!646)) b!1201))

(assert (= (and b!1201 c!314) b!1202))

(assert (= (and b!1201 (not c!314)) b!1200))

(assert (= (and b!1202 res!645) b!1199))

(assert (= (and b!1200 res!644) b!1198))

(assert (= (and b!1198 res!647) b!1196))

(assert (= (and b!1196 res!648) b!1197))

(assert (= (or b!1202 b!1196) bm!205))

(assert (= (or b!1199 b!1197) bm!206))

(declare-fun m!1707 () Bool)

(assert (=> bm!205 m!1707))

(declare-fun m!1709 () Bool)

(assert (=> bm!206 m!1709))

(declare-fun m!1711 () Bool)

(assert (=> b!1198 m!1711))

(declare-fun m!1713 () Bool)

(assert (=> b!1200 m!1713))

(assert (=> bm!120 d!709))

(declare-fun b!1203 () Bool)

(declare-fun res!653 () Bool)

(declare-fun call!208 () Bool)

(assert (=> b!1203 (= res!653 call!208)))

(declare-fun e!682 () Bool)

(assert (=> b!1203 (=> (not res!653) (not e!682))))

(declare-fun d!711 () Bool)

(declare-fun res!651 () Bool)

(declare-fun e!683 () Bool)

(assert (=> d!711 (=> res!651 e!683)))

(assert (=> d!711 (= res!651 ((_ is Empty!3) (left!8 (left!8 (left!8 lt!5)))))))

(assert (=> d!711 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 lt!5)))) e!683)))

(declare-fun b!1204 () Bool)

(declare-fun call!207 () Bool)

(assert (=> b!1204 (= e!682 call!207)))

(declare-fun bm!207 () Bool)

(assert (=> bm!207 (= call!208 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (left!8 lt!5))))))))

(declare-fun bm!208 () Bool)

(assert (=> bm!208 (= call!207 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!1205 () Bool)

(declare-fun res!652 () Bool)

(assert (=> b!1205 (= res!652 (isBlack!0 (right!8 (left!8 (left!8 (left!8 lt!5))))))))

(assert (=> b!1205 (=> (not res!652) (not e!682))))

(declare-fun b!1206 () Bool)

(declare-fun e!681 () Bool)

(assert (=> b!1206 (= e!681 call!207)))

(declare-fun b!1207 () Bool)

(declare-fun e!680 () Bool)

(assert (=> b!1207 (= e!680 e!682)))

(declare-fun res!649 () Bool)

(assert (=> b!1207 (= res!649 (isBlack!0 (left!8 (left!8 (left!8 (left!8 lt!5))))))))

(assert (=> b!1207 (=> (not res!649) (not e!682))))

(declare-fun b!1208 () Bool)

(assert (=> b!1208 (= e!683 e!680)))

(declare-fun c!315 () Bool)

(assert (=> b!1208 (= c!315 ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!1209 () Bool)

(assert (=> b!1209 (= e!680 e!681)))

(declare-fun res!650 () Bool)

(assert (=> b!1209 (= res!650 call!208)))

(assert (=> b!1209 (=> (not res!650) (not e!681))))

(assert (= (and d!711 (not res!651)) b!1208))

(assert (= (and b!1208 c!315) b!1209))

(assert (= (and b!1208 (not c!315)) b!1207))

(assert (= (and b!1209 res!650) b!1206))

(assert (= (and b!1207 res!649) b!1205))

(assert (= (and b!1205 res!652) b!1203))

(assert (= (and b!1203 res!653) b!1204))

(assert (= (or b!1209 b!1203) bm!207))

(assert (= (or b!1206 b!1204) bm!208))

(declare-fun m!1715 () Bool)

(assert (=> bm!207 m!1715))

(declare-fun m!1717 () Bool)

(assert (=> bm!208 m!1717))

(declare-fun m!1719 () Bool)

(assert (=> b!1205 m!1719))

(declare-fun m!1721 () Bool)

(assert (=> b!1207 m!1721))

(assert (=> bm!88 d!711))

(declare-fun d!713 () Bool)

(declare-fun c!316 () Bool)

(assert (=> d!713 (= c!316 ((_ is Empty!3) (left!8 (left!8 (left!8 (right!8 t!78))))))))

(declare-fun e!684 () (InoxSet (_ BitVec 32)))

(assert (=> d!713 (= (content!0 (left!8 (left!8 (left!8 (right!8 t!78))))) e!684)))

(declare-fun b!1210 () Bool)

(assert (=> b!1210 (= e!684 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1211 () Bool)

(assert (=> b!1211 (= e!684 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (left!8 (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (left!8 (right!8 t!78))))) true)) (content!0 (right!8 (left!8 (left!8 (left!8 (right!8 t!78))))))))))

(assert (= (and d!713 c!316) b!1210))

(assert (= (and d!713 (not c!316)) b!1211))

(declare-fun m!1723 () Bool)

(assert (=> b!1211 m!1723))

(declare-fun m!1725 () Bool)

(assert (=> b!1211 m!1725))

(declare-fun m!1727 () Bool)

(assert (=> b!1211 m!1727))

(assert (=> b!529 d!713))

(declare-fun d!715 () Bool)

(declare-fun c!317 () Bool)

(assert (=> d!715 (= c!317 ((_ is Empty!3) (right!8 (left!8 (left!8 (right!8 t!78))))))))

(declare-fun e!685 () (InoxSet (_ BitVec 32)))

(assert (=> d!715 (= (content!0 (right!8 (left!8 (left!8 (right!8 t!78))))) e!685)))

(declare-fun b!1212 () Bool)

(assert (=> b!1212 (= e!685 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1213 () Bool)

(assert (=> b!1213 (= e!685 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (left!8 (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (left!8 (right!8 t!78))))) true)) (content!0 (right!8 (right!8 (left!8 (left!8 (right!8 t!78))))))))))

(assert (= (and d!715 c!317) b!1212))

(assert (= (and d!715 (not c!317)) b!1213))

(declare-fun m!1729 () Bool)

(assert (=> b!1213 m!1729))

(declare-fun m!1731 () Bool)

(assert (=> b!1213 m!1731))

(declare-fun m!1733 () Bool)

(assert (=> b!1213 m!1733))

(assert (=> b!529 d!715))

(declare-fun b!1214 () Bool)

(declare-fun res!658 () Bool)

(declare-fun call!210 () Bool)

(assert (=> b!1214 (= res!658 call!210)))

(declare-fun e!688 () Bool)

(assert (=> b!1214 (=> (not res!658) (not e!688))))

(declare-fun d!717 () Bool)

(declare-fun res!656 () Bool)

(declare-fun e!689 () Bool)

(assert (=> d!717 (=> res!656 e!689)))

(assert (=> d!717 (= res!656 ((_ is Empty!3) (left!8 (left!8 (right!8 (right!8 t!78))))))))

(assert (=> d!717 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (right!8 t!78))))) e!689)))

(declare-fun b!1215 () Bool)

(declare-fun call!209 () Bool)

(assert (=> b!1215 (= e!688 call!209)))

(declare-fun bm!209 () Bool)

(assert (=> bm!209 (= call!210 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (right!8 (right!8 t!78)))))))))

(declare-fun bm!210 () Bool)

(assert (=> bm!210 (= call!209 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (right!8 (right!8 t!78)))))))))

(declare-fun b!1216 () Bool)

(declare-fun res!657 () Bool)

(assert (=> b!1216 (= res!657 (isBlack!0 (right!8 (left!8 (left!8 (right!8 (right!8 t!78)))))))))

(assert (=> b!1216 (=> (not res!657) (not e!688))))

(declare-fun b!1217 () Bool)

(declare-fun e!687 () Bool)

(assert (=> b!1217 (= e!687 call!209)))

(declare-fun b!1218 () Bool)

(declare-fun e!686 () Bool)

(assert (=> b!1218 (= e!686 e!688)))

(declare-fun res!654 () Bool)

(assert (=> b!1218 (= res!654 (isBlack!0 (left!8 (left!8 (left!8 (right!8 (right!8 t!78)))))))))

(assert (=> b!1218 (=> (not res!654) (not e!688))))

(declare-fun b!1219 () Bool)

(assert (=> b!1219 (= e!689 e!686)))

(declare-fun c!318 () Bool)

(assert (=> b!1219 (= c!318 ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 (right!8 t!78)))))))))

(declare-fun b!1220 () Bool)

(assert (=> b!1220 (= e!686 e!687)))

(declare-fun res!655 () Bool)

(assert (=> b!1220 (= res!655 call!210)))

(assert (=> b!1220 (=> (not res!655) (not e!687))))

(assert (= (and d!717 (not res!656)) b!1219))

(assert (= (and b!1219 c!318) b!1220))

(assert (= (and b!1219 (not c!318)) b!1218))

(assert (= (and b!1220 res!655) b!1217))

(assert (= (and b!1218 res!654) b!1216))

(assert (= (and b!1216 res!657) b!1214))

(assert (= (and b!1214 res!658) b!1215))

(assert (= (or b!1220 b!1214) bm!209))

(assert (= (or b!1217 b!1215) bm!210))

(declare-fun m!1735 () Bool)

(assert (=> bm!209 m!1735))

(declare-fun m!1737 () Bool)

(assert (=> bm!210 m!1737))

(declare-fun m!1739 () Bool)

(assert (=> b!1216 m!1739))

(declare-fun m!1741 () Bool)

(assert (=> b!1218 m!1741))

(assert (=> bm!140 d!717))

(declare-fun d!719 () Bool)

(declare-fun lt!54 () Int)

(assert (=> d!719 (>= lt!54 0)))

(declare-fun e!690 () Int)

(assert (=> d!719 (= lt!54 e!690)))

(declare-fun c!319 () Bool)

(assert (=> d!719 (= c!319 ((_ is Empty!3) (left!8 (right!8 lt!13))))))

(assert (=> d!719 (= (size!0 (left!8 (right!8 lt!13))) lt!54)))

(declare-fun b!1221 () Bool)

(assert (=> b!1221 (= e!690 0)))

(declare-fun b!1222 () Bool)

(assert (=> b!1222 (= e!690 (+ (size!0 (left!8 (left!8 (right!8 lt!13)))) 1 (size!0 (right!8 (left!8 (right!8 lt!13))))))))

(assert (= (and d!719 c!319) b!1221))

(assert (= (and d!719 (not c!319)) b!1222))

(declare-fun m!1743 () Bool)

(assert (=> b!1222 m!1743))

(declare-fun m!1745 () Bool)

(assert (=> b!1222 m!1745))

(assert (=> b!721 d!719))

(declare-fun d!721 () Bool)

(declare-fun lt!55 () Int)

(assert (=> d!721 (>= lt!55 0)))

(declare-fun e!691 () Int)

(assert (=> d!721 (= lt!55 e!691)))

(declare-fun c!320 () Bool)

(assert (=> d!721 (= c!320 ((_ is Empty!3) (right!8 (right!8 lt!13))))))

(assert (=> d!721 (= (size!0 (right!8 (right!8 lt!13))) lt!55)))

(declare-fun b!1223 () Bool)

(assert (=> b!1223 (= e!691 0)))

(declare-fun b!1224 () Bool)

(assert (=> b!1224 (= e!691 (+ (size!0 (left!8 (right!8 (right!8 lt!13)))) 1 (size!0 (right!8 (right!8 (right!8 lt!13))))))))

(assert (= (and d!721 c!320) b!1223))

(assert (= (and d!721 (not c!320)) b!1224))

(declare-fun m!1747 () Bool)

(assert (=> b!1224 m!1747))

(declare-fun m!1749 () Bool)

(assert (=> b!1224 m!1749))

(assert (=> b!721 d!721))

(declare-fun d!723 () Bool)

(declare-fun c!321 () Bool)

(assert (=> d!723 (= c!321 ((_ is Empty!3) (left!8 (right!8 lt!13))))))

(declare-fun e!692 () (_ BitVec 32))

(assert (=> d!723 (= (blackHeight!0 (left!8 (right!8 lt!13))) e!692)))

(declare-fun b!1225 () Bool)

(declare-fun e!693 () (_ BitVec 32))

(declare-fun call!211 () (_ BitVec 32))

(assert (=> b!1225 (= e!693 (bvadd call!211 #b00000000000000000000000000000001))))

(declare-fun bm!211 () Bool)

(assert (=> bm!211 (= call!211 (blackHeight!0 (left!8 (left!8 (right!8 lt!13)))))))

(declare-fun b!1226 () Bool)

(assert (=> b!1226 (= e!693 call!211)))

(declare-fun b!1227 () Bool)

(assert (=> b!1227 (= e!692 e!693)))

(declare-fun c!322 () Bool)

(assert (=> b!1227 (= c!322 ((_ is Black!3) (color!6 (left!8 (right!8 lt!13)))))))

(declare-fun b!1228 () Bool)

(assert (=> b!1228 (= e!692 #b00000000000000000000000000000001)))

(assert (= (and d!723 c!321) b!1228))

(assert (= (and d!723 (not c!321)) b!1227))

(assert (= (and b!1227 c!322) b!1225))

(assert (= (and b!1227 (not c!322)) b!1226))

(assert (= (or b!1225 b!1226) bm!211))

(declare-fun m!1751 () Bool)

(assert (=> bm!211 m!1751))

(assert (=> bm!129 d!723))

(declare-fun d!725 () Bool)

(declare-fun res!659 () Bool)

(declare-fun e!694 () Bool)

(assert (=> d!725 (=> res!659 e!694)))

(assert (=> d!725 (= res!659 (not ((_ is Node!3) (left!8 (left!8 (left!8 t!78))))))))

(assert (=> d!725 (= (blackBalanced!0 (left!8 (left!8 (left!8 t!78)))) e!694)))

(declare-fun b!1229 () Bool)

(declare-fun e!695 () Bool)

(assert (=> b!1229 (= e!694 e!695)))

(declare-fun res!661 () Bool)

(assert (=> b!1229 (=> (not res!661) (not e!695))))

(assert (=> b!1229 (= res!661 (blackBalanced!0 (left!8 (left!8 (left!8 (left!8 t!78))))))))

(declare-fun b!1230 () Bool)

(declare-fun res!660 () Bool)

(assert (=> b!1230 (=> (not res!660) (not e!695))))

(assert (=> b!1230 (= res!660 (blackBalanced!0 (right!8 (left!8 (left!8 (left!8 t!78))))))))

(declare-fun b!1231 () Bool)

(assert (=> b!1231 (= e!695 (= (blackHeight!0 (left!8 (left!8 (left!8 (left!8 t!78))))) (blackHeight!0 (right!8 (left!8 (left!8 (left!8 t!78)))))))))

(assert (= (and d!725 (not res!659)) b!1229))

(assert (= (and b!1229 res!661) b!1230))

(assert (= (and b!1230 res!660) b!1231))

(declare-fun m!1753 () Bool)

(assert (=> b!1229 m!1753))

(declare-fun m!1755 () Bool)

(assert (=> b!1230 m!1755))

(assert (=> b!1231 m!1217))

(declare-fun m!1757 () Bool)

(assert (=> b!1231 m!1757))

(assert (=> b!670 d!725))

(declare-fun lt!56 () Tree!3)

(declare-fun d!727 () Bool)

(assert (=> d!727 (= (content!0 lt!56) (content!0 (Node!3 (color!6 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))))))

(assert (=> d!727 (= lt!56 (ite (and ((_ is Black!3) (color!6 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) ((_ is Node!3) (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) ((_ is Red!3) (color!6 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) ((_ is Node!3) (left!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) ((_ is Red!3) (color!6 (left!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))) (Node!3 Red!3 (Node!3 Black!3 (left!8 (left!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) (value!38 (left!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) (right!8 (left!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))) (value!38 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (Node!3 Black!3 (right!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) (ite (and ((_ is Black!3) (color!6 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) ((_ is Node!3) (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) ((_ is Red!3) (color!6 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) ((_ is Node!3) (right!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) ((_ is Red!3) (color!6 (right!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))) (Node!3 Red!3 (Node!3 Black!3 (left!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (value!38 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (left!8 (right!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))) (value!38 (right!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) (Node!3 Black!3 (right!8 (right!8 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) (ite (and ((_ is Black!3) (color!6 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) ((_ is Node!3) (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104)) ((_ is Red!3) (color!6 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) ((_ is Node!3) (left!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) ((_ is Red!3) (color!6 (left!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))))) (Node!3 Red!3 (Node!3 Black!3 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (left!8 (left!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104)))) (value!38 (left!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) (Node!3 Black!3 (right!8 (left!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) (value!38 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104)) (right!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104)))) (ite (and ((_ is Black!3) (color!6 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) ((_ is Node!3) (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104)) ((_ is Red!3) (color!6 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) ((_ is Node!3) (right!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) ((_ is Red!3) (color!6 (right!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))))) (Node!3 Red!3 (Node!3 Black!3 (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (left!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) (value!38 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104)) (Node!3 Black!3 (left!8 (right!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) (value!38 (right!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))) (right!8 (right!8 (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104))))) (Node!3 (color!6 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104)))))))))

(assert (=> d!727 (= (balance!0 (color!6 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (ite c!155 call!104 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (ite c!155 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) call!104)) lt!56)))

(declare-fun bs!5 () Bool)

(assert (= bs!5 d!727))

(declare-fun m!1759 () Bool)

(assert (=> bs!5 m!1759))

(declare-fun m!1761 () Bool)

(assert (=> bs!5 m!1761))

(assert (=> bm!104 d!727))

(declare-fun d!729 () Bool)

(assert (=> d!729 (= (isBlack!0 (right!8 (left!8 (left!8 (left!8 lt!2))))) (or ((_ is Empty!3) (right!8 (left!8 (left!8 (left!8 lt!2))))) ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 (left!8 lt!2))))))))))

(assert (=> b!471 d!729))

(declare-fun d!731 () Bool)

(declare-fun c!323 () Bool)

(assert (=> d!731 (= c!323 ((_ is Empty!3) (left!8 (right!8 (left!8 (left!8 lt!2))))))))

(declare-fun e!696 () (InoxSet (_ BitVec 32)))

(assert (=> d!731 (= (content!0 (left!8 (right!8 (left!8 (left!8 lt!2))))) e!696)))

(declare-fun b!1232 () Bool)

(assert (=> b!1232 (= e!696 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1233 () Bool)

(assert (=> b!1233 (= e!696 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (left!8 (left!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (left!8 (left!8 lt!2))))) true)) (content!0 (right!8 (left!8 (right!8 (left!8 (left!8 lt!2))))))))))

(assert (= (and d!731 c!323) b!1232))

(assert (= (and d!731 (not c!323)) b!1233))

(declare-fun m!1763 () Bool)

(assert (=> b!1233 m!1763))

(declare-fun m!1765 () Bool)

(assert (=> b!1233 m!1765))

(declare-fun m!1767 () Bool)

(assert (=> b!1233 m!1767))

(assert (=> b!521 d!731))

(declare-fun d!733 () Bool)

(declare-fun c!324 () Bool)

(assert (=> d!733 (= c!324 ((_ is Empty!3) (right!8 (right!8 (left!8 (left!8 lt!2))))))))

(declare-fun e!697 () (InoxSet (_ BitVec 32)))

(assert (=> d!733 (= (content!0 (right!8 (right!8 (left!8 (left!8 lt!2))))) e!697)))

(declare-fun b!1234 () Bool)

(assert (=> b!1234 (= e!697 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1235 () Bool)

(assert (=> b!1235 (= e!697 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (left!8 (left!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (left!8 (left!8 lt!2))))) true)) (content!0 (right!8 (right!8 (right!8 (left!8 (left!8 lt!2))))))))))

(assert (= (and d!733 c!324) b!1234))

(assert (= (and d!733 (not c!324)) b!1235))

(declare-fun m!1769 () Bool)

(assert (=> b!1235 m!1769))

(declare-fun m!1771 () Bool)

(assert (=> b!1235 m!1771))

(declare-fun m!1773 () Bool)

(assert (=> b!1235 m!1773))

(assert (=> b!521 d!733))

(declare-fun d!735 () Bool)

(assert (=> d!735 (= (isBlack!0 (right!8 (right!8 (left!8 (left!8 lt!2))))) (or ((_ is Empty!3) (right!8 (right!8 (left!8 (left!8 lt!2))))) ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 (left!8 lt!2))))))))))

(assert (=> b!566 d!735))

(declare-fun d!737 () Bool)

(assert (=> d!737 (= (isBlack!0 (left!8 (left!8 (left!8 (left!8 t!78))))) (or ((_ is Empty!3) (left!8 (left!8 (left!8 (left!8 t!78))))) ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 (left!8 t!78))))))))))

(assert (=> b!818 d!737))

(declare-fun d!739 () Bool)

(declare-fun res!662 () Bool)

(declare-fun e!698 () Bool)

(assert (=> d!739 (=> res!662 e!698)))

(assert (=> d!739 (= res!662 (not ((_ is Node!3) (left!8 (right!8 (right!8 lt!5))))))))

(assert (=> d!739 (= (blackBalanced!0 (left!8 (right!8 (right!8 lt!5)))) e!698)))

(declare-fun b!1236 () Bool)

(declare-fun e!699 () Bool)

(assert (=> b!1236 (= e!698 e!699)))

(declare-fun res!664 () Bool)

(assert (=> b!1236 (=> (not res!664) (not e!699))))

(assert (=> b!1236 (= res!664 (blackBalanced!0 (left!8 (left!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!1237 () Bool)

(declare-fun res!663 () Bool)

(assert (=> b!1237 (=> (not res!663) (not e!699))))

(assert (=> b!1237 (= res!663 (blackBalanced!0 (right!8 (left!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!1238 () Bool)

(assert (=> b!1238 (= e!699 (= (blackHeight!0 (left!8 (left!8 (right!8 (right!8 lt!5))))) (blackHeight!0 (right!8 (left!8 (right!8 (right!8 lt!5)))))))))

(assert (= (and d!739 (not res!662)) b!1236))

(assert (= (and b!1236 res!664) b!1237))

(assert (= (and b!1237 res!663) b!1238))

(declare-fun m!1775 () Bool)

(assert (=> b!1236 m!1775))

(declare-fun m!1777 () Bool)

(assert (=> b!1237 m!1777))

(assert (=> b!1238 m!1347))

(declare-fun m!1779 () Bool)

(assert (=> b!1238 m!1779))

(assert (=> b!466 d!739))

(declare-fun d!741 () Bool)

(declare-fun c!325 () Bool)

(assert (=> d!741 (= c!325 ((_ is Empty!3) (left!8 (right!8 (right!8 lt!5)))))))

(declare-fun e!700 () (InoxSet (_ BitVec 32)))

(assert (=> d!741 (= (content!0 (left!8 (right!8 (right!8 lt!5)))) e!700)))

(declare-fun b!1239 () Bool)

(assert (=> b!1239 (= e!700 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1240 () Bool)

(assert (=> b!1240 (= e!700 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (right!8 lt!5))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (right!8 lt!5)))) true)) (content!0 (right!8 (left!8 (right!8 (right!8 lt!5)))))))))

(assert (= (and d!741 c!325) b!1239))

(assert (= (and d!741 (not c!325)) b!1240))

(declare-fun m!1781 () Bool)

(assert (=> b!1240 m!1781))

(declare-fun m!1783 () Bool)

(assert (=> b!1240 m!1783))

(declare-fun m!1785 () Bool)

(assert (=> b!1240 m!1785))

(assert (=> b!713 d!741))

(declare-fun d!743 () Bool)

(declare-fun c!326 () Bool)

(assert (=> d!743 (= c!326 ((_ is Empty!3) (right!8 (right!8 (right!8 lt!5)))))))

(declare-fun e!701 () (InoxSet (_ BitVec 32)))

(assert (=> d!743 (= (content!0 (right!8 (right!8 (right!8 lt!5)))) e!701)))

(declare-fun b!1241 () Bool)

(assert (=> b!1241 (= e!701 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1242 () Bool)

(assert (=> b!1242 (= e!701 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (right!8 lt!5))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (right!8 lt!5)))) true)) (content!0 (right!8 (right!8 (right!8 (right!8 lt!5)))))))))

(assert (= (and d!743 c!326) b!1241))

(assert (= (and d!743 (not c!326)) b!1242))

(declare-fun m!1787 () Bool)

(assert (=> b!1242 m!1787))

(declare-fun m!1789 () Bool)

(assert (=> b!1242 m!1789))

(declare-fun m!1791 () Bool)

(assert (=> b!1242 m!1791))

(assert (=> b!713 d!743))

(assert (=> bm!109 d!479))

(declare-fun d!745 () Bool)

(assert (=> d!745 (= (isBlack!0 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (or ((_ is Empty!3) (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) ((_ is Black!3) (color!6 (left!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> b!561 d!745))

(declare-fun b!1243 () Bool)

(declare-fun res!669 () Bool)

(declare-fun call!213 () Bool)

(assert (=> b!1243 (= res!669 call!213)))

(declare-fun e!704 () Bool)

(assert (=> b!1243 (=> (not res!669) (not e!704))))

(declare-fun d!747 () Bool)

(declare-fun res!667 () Bool)

(declare-fun e!705 () Bool)

(assert (=> d!747 (=> res!667 e!705)))

(assert (=> d!747 (= res!667 ((_ is Empty!3) (right!8 (left!8 (right!8 (right!8 lt!2))))))))

(assert (=> d!747 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (right!8 lt!2))))) e!705)))

(declare-fun b!1244 () Bool)

(declare-fun call!212 () Bool)

(assert (=> b!1244 (= e!704 call!212)))

(declare-fun bm!212 () Bool)

(assert (=> bm!212 (= call!213 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (right!8 (right!8 lt!2)))))))))

(declare-fun bm!213 () Bool)

(assert (=> bm!213 (= call!212 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (right!8 (right!8 lt!2)))))))))

(declare-fun b!1245 () Bool)

(declare-fun res!668 () Bool)

(assert (=> b!1245 (= res!668 (isBlack!0 (right!8 (right!8 (left!8 (right!8 (right!8 lt!2)))))))))

(assert (=> b!1245 (=> (not res!668) (not e!704))))

(declare-fun b!1246 () Bool)

(declare-fun e!703 () Bool)

(assert (=> b!1246 (= e!703 call!212)))

(declare-fun b!1247 () Bool)

(declare-fun e!702 () Bool)

(assert (=> b!1247 (= e!702 e!704)))

(declare-fun res!665 () Bool)

(assert (=> b!1247 (= res!665 (isBlack!0 (left!8 (right!8 (left!8 (right!8 (right!8 lt!2)))))))))

(assert (=> b!1247 (=> (not res!665) (not e!704))))

(declare-fun b!1248 () Bool)

(assert (=> b!1248 (= e!705 e!702)))

(declare-fun c!327 () Bool)

(assert (=> b!1248 (= c!327 ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 (right!8 lt!2)))))))))

(declare-fun b!1249 () Bool)

(assert (=> b!1249 (= e!702 e!703)))

(declare-fun res!666 () Bool)

(assert (=> b!1249 (= res!666 call!213)))

(assert (=> b!1249 (=> (not res!666) (not e!703))))

(assert (= (and d!747 (not res!667)) b!1248))

(assert (= (and b!1248 c!327) b!1249))

(assert (= (and b!1248 (not c!327)) b!1247))

(assert (= (and b!1249 res!666) b!1246))

(assert (= (and b!1247 res!665) b!1245))

(assert (= (and b!1245 res!668) b!1243))

(assert (= (and b!1243 res!669) b!1244))

(assert (= (or b!1249 b!1243) bm!212))

(assert (= (or b!1246 b!1244) bm!213))

(declare-fun m!1793 () Bool)

(assert (=> bm!212 m!1793))

(declare-fun m!1795 () Bool)

(assert (=> bm!213 m!1795))

(declare-fun m!1797 () Bool)

(assert (=> b!1245 m!1797))

(declare-fun m!1799 () Bool)

(assert (=> b!1247 m!1799))

(assert (=> bm!101 d!747))

(declare-fun b!1250 () Bool)

(declare-fun res!674 () Bool)

(declare-fun call!215 () Bool)

(assert (=> b!1250 (= res!674 call!215)))

(declare-fun e!708 () Bool)

(assert (=> b!1250 (=> (not res!674) (not e!708))))

(declare-fun d!749 () Bool)

(declare-fun res!672 () Bool)

(declare-fun e!709 () Bool)

(assert (=> d!749 (=> res!672 e!709)))

(assert (=> d!749 (= res!672 ((_ is Empty!3) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> d!749 (= (redNodesHaveBlackChildren!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) e!709)))

(declare-fun b!1251 () Bool)

(declare-fun call!214 () Bool)

(assert (=> b!1251 (= e!708 call!214)))

(declare-fun bm!214 () Bool)

(assert (=> bm!214 (= call!215 (redNodesHaveBlackChildren!0 (left!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun bm!215 () Bool)

(assert (=> bm!215 (= call!214 (redNodesHaveBlackChildren!0 (right!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun res!673 () Bool)

(declare-fun b!1252 () Bool)

(assert (=> b!1252 (= res!673 (isBlack!0 (right!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> b!1252 (=> (not res!673) (not e!708))))

(declare-fun b!1253 () Bool)

(declare-fun e!707 () Bool)

(assert (=> b!1253 (= e!707 call!214)))

(declare-fun b!1254 () Bool)

(declare-fun e!706 () Bool)

(assert (=> b!1254 (= e!706 e!708)))

(declare-fun res!670 () Bool)

(assert (=> b!1254 (= res!670 (isBlack!0 (left!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> b!1254 (=> (not res!670) (not e!708))))

(declare-fun b!1255 () Bool)

(assert (=> b!1255 (= e!709 e!706)))

(declare-fun c!328 () Bool)

(assert (=> b!1255 (= c!328 ((_ is Black!3) (color!6 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!1256 () Bool)

(assert (=> b!1256 (= e!706 e!707)))

(declare-fun res!671 () Bool)

(assert (=> b!1256 (= res!671 call!215)))

(assert (=> b!1256 (=> (not res!671) (not e!707))))

(assert (= (and d!749 (not res!672)) b!1255))

(assert (= (and b!1255 c!328) b!1256))

(assert (= (and b!1255 (not c!328)) b!1254))

(assert (= (and b!1256 res!671) b!1253))

(assert (= (and b!1254 res!670) b!1252))

(assert (= (and b!1252 res!673) b!1250))

(assert (= (and b!1250 res!674) b!1251))

(assert (= (or b!1256 b!1250) bm!214))

(assert (= (or b!1253 b!1251) bm!215))

(declare-fun m!1801 () Bool)

(assert (=> bm!214 m!1801))

(declare-fun m!1803 () Bool)

(assert (=> bm!215 m!1803))

(declare-fun m!1805 () Bool)

(assert (=> b!1252 m!1805))

(declare-fun m!1807 () Bool)

(assert (=> b!1254 m!1807))

(assert (=> bm!139 d!749))

(declare-fun d!751 () Bool)

(declare-fun res!675 () Bool)

(declare-fun e!710 () Bool)

(assert (=> d!751 (=> res!675 e!710)))

(assert (=> d!751 (= res!675 (not ((_ is Node!3) (left!8 (right!8 lt!13)))))))

(assert (=> d!751 (= (blackBalanced!0 (left!8 (right!8 lt!13))) e!710)))

(declare-fun b!1257 () Bool)

(declare-fun e!711 () Bool)

(assert (=> b!1257 (= e!710 e!711)))

(declare-fun res!677 () Bool)

(assert (=> b!1257 (=> (not res!677) (not e!711))))

(assert (=> b!1257 (= res!677 (blackBalanced!0 (left!8 (left!8 (right!8 lt!13)))))))

(declare-fun b!1258 () Bool)

(declare-fun res!676 () Bool)

(assert (=> b!1258 (=> (not res!676) (not e!711))))

(assert (=> b!1258 (= res!676 (blackBalanced!0 (right!8 (left!8 (right!8 lt!13)))))))

(declare-fun b!1259 () Bool)

(assert (=> b!1259 (= e!711 (= (blackHeight!0 (left!8 (left!8 (right!8 lt!13)))) (blackHeight!0 (right!8 (left!8 (right!8 lt!13))))))))

(assert (= (and d!751 (not res!675)) b!1257))

(assert (= (and b!1257 res!677) b!1258))

(assert (= (and b!1258 res!676) b!1259))

(declare-fun m!1809 () Bool)

(assert (=> b!1257 m!1809))

(declare-fun m!1811 () Bool)

(assert (=> b!1258 m!1811))

(assert (=> b!1259 m!1751))

(declare-fun m!1813 () Bool)

(assert (=> b!1259 m!1813))

(assert (=> b!687 d!751))

(declare-fun d!753 () Bool)

(declare-fun c!329 () Bool)

(assert (=> d!753 (= c!329 ((_ is Empty!3) (left!8 (left!8 lt!13))))))

(declare-fun e!712 () (_ BitVec 32))

(assert (=> d!753 (= (blackHeight!0 (left!8 (left!8 lt!13))) e!712)))

(declare-fun b!1260 () Bool)

(declare-fun e!713 () (_ BitVec 32))

(declare-fun call!216 () (_ BitVec 32))

(assert (=> b!1260 (= e!713 (bvadd call!216 #b00000000000000000000000000000001))))

(declare-fun bm!216 () Bool)

(assert (=> bm!216 (= call!216 (blackHeight!0 (left!8 (left!8 (left!8 lt!13)))))))

(declare-fun b!1261 () Bool)

(assert (=> b!1261 (= e!713 call!216)))

(declare-fun b!1262 () Bool)

(assert (=> b!1262 (= e!712 e!713)))

(declare-fun c!330 () Bool)

(assert (=> b!1262 (= c!330 ((_ is Black!3) (color!6 (left!8 (left!8 lt!13)))))))

(declare-fun b!1263 () Bool)

(assert (=> b!1263 (= e!712 #b00000000000000000000000000000001)))

(assert (= (and d!753 c!329) b!1263))

(assert (= (and d!753 (not c!329)) b!1262))

(assert (= (and b!1262 c!330) b!1260))

(assert (= (and b!1262 (not c!330)) b!1261))

(assert (= (or b!1260 b!1261) bm!216))

(declare-fun m!1815 () Bool)

(assert (=> bm!216 m!1815))

(assert (=> bm!128 d!753))

(declare-fun d!755 () Bool)

(declare-fun c!331 () Bool)

(assert (=> d!755 (= c!331 ((_ is Empty!3) (left!8 (left!8 (left!8 (left!8 lt!2))))))))

(declare-fun e!714 () (InoxSet (_ BitVec 32)))

(assert (=> d!755 (= (content!0 (left!8 (left!8 (left!8 (left!8 lt!2))))) e!714)))

(declare-fun b!1264 () Bool)

(assert (=> b!1264 (= e!714 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1265 () Bool)

(assert (=> b!1265 (= e!714 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (left!8 (left!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (left!8 (left!8 lt!2))))) true)) (content!0 (right!8 (left!8 (left!8 (left!8 (left!8 lt!2))))))))))

(assert (= (and d!755 c!331) b!1264))

(assert (= (and d!755 (not c!331)) b!1265))

(declare-fun m!1817 () Bool)

(assert (=> b!1265 m!1817))

(declare-fun m!1819 () Bool)

(assert (=> b!1265 m!1819))

(declare-fun m!1821 () Bool)

(assert (=> b!1265 m!1821))

(assert (=> b!519 d!755))

(declare-fun d!757 () Bool)

(declare-fun c!332 () Bool)

(assert (=> d!757 (= c!332 ((_ is Empty!3) (right!8 (left!8 (left!8 (left!8 lt!2))))))))

(declare-fun e!715 () (InoxSet (_ BitVec 32)))

(assert (=> d!757 (= (content!0 (right!8 (left!8 (left!8 (left!8 lt!2))))) e!715)))

(declare-fun b!1266 () Bool)

(assert (=> b!1266 (= e!715 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1267 () Bool)

(assert (=> b!1267 (= e!715 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (left!8 (left!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (left!8 (left!8 lt!2))))) true)) (content!0 (right!8 (right!8 (left!8 (left!8 (left!8 lt!2))))))))))

(assert (= (and d!757 c!332) b!1266))

(assert (= (and d!757 (not c!332)) b!1267))

(declare-fun m!1823 () Bool)

(assert (=> b!1267 m!1823))

(declare-fun m!1825 () Bool)

(assert (=> b!1267 m!1825))

(declare-fun m!1827 () Bool)

(assert (=> b!1267 m!1827))

(assert (=> b!519 d!757))

(declare-fun d!759 () Bool)

(assert (=> d!759 (= (isBlack!0 (left!8 (left!8 (right!8 lt!5)))) (or ((_ is Empty!3) (left!8 (left!8 (right!8 lt!5)))) ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 lt!5)))))))))

(assert (=> b!594 d!759))

(declare-fun d!761 () Bool)

(declare-fun res!678 () Bool)

(declare-fun e!716 () Bool)

(assert (=> d!761 (=> res!678 e!716)))

(assert (=> d!761 (= res!678 (not ((_ is Node!3) (right!8 (left!8 (left!8 lt!5))))))))

(assert (=> d!761 (= (blackBalanced!0 (right!8 (left!8 (left!8 lt!5)))) e!716)))

(declare-fun b!1268 () Bool)

(declare-fun e!717 () Bool)

(assert (=> b!1268 (= e!716 e!717)))

(declare-fun res!680 () Bool)

(assert (=> b!1268 (=> (not res!680) (not e!717))))

(assert (=> b!1268 (= res!680 (blackBalanced!0 (left!8 (right!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!1269 () Bool)

(declare-fun res!679 () Bool)

(assert (=> b!1269 (=> (not res!679) (not e!717))))

(assert (=> b!1269 (= res!679 (blackBalanced!0 (right!8 (right!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!1270 () Bool)

(assert (=> b!1270 (= e!717 (= (blackHeight!0 (left!8 (right!8 (left!8 (left!8 lt!5))))) (blackHeight!0 (right!8 (right!8 (left!8 (left!8 lt!5)))))))))

(assert (= (and d!761 (not res!678)) b!1268))

(assert (= (and b!1268 res!680) b!1269))

(assert (= (and b!1269 res!679) b!1270))

(declare-fun m!1829 () Bool)

(assert (=> b!1268 m!1829))

(declare-fun m!1831 () Bool)

(assert (=> b!1269 m!1831))

(declare-fun m!1833 () Bool)

(assert (=> b!1270 m!1833))

(declare-fun m!1835 () Bool)

(assert (=> b!1270 m!1835))

(assert (=> b!723 d!761))

(declare-fun b!1271 () Bool)

(declare-fun res!685 () Bool)

(declare-fun call!218 () Bool)

(assert (=> b!1271 (= res!685 call!218)))

(declare-fun e!720 () Bool)

(assert (=> b!1271 (=> (not res!685) (not e!720))))

(declare-fun d!763 () Bool)

(declare-fun res!683 () Bool)

(declare-fun e!721 () Bool)

(assert (=> d!763 (=> res!683 e!721)))

(assert (=> d!763 (= res!683 ((_ is Empty!3) (left!8 (right!8 (left!8 lt!5)))))))

(assert (=> d!763 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 lt!5)))) e!721)))

(declare-fun b!1272 () Bool)

(declare-fun call!217 () Bool)

(assert (=> b!1272 (= e!720 call!217)))

(declare-fun bm!217 () Bool)

(assert (=> bm!217 (= call!218 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (left!8 lt!5))))))))

(declare-fun bm!218 () Bool)

(assert (=> bm!218 (= call!217 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!1273 () Bool)

(declare-fun res!684 () Bool)

(assert (=> b!1273 (= res!684 (isBlack!0 (right!8 (left!8 (right!8 (left!8 lt!5))))))))

(assert (=> b!1273 (=> (not res!684) (not e!720))))

(declare-fun b!1274 () Bool)

(declare-fun e!719 () Bool)

(assert (=> b!1274 (= e!719 call!217)))

(declare-fun b!1275 () Bool)

(declare-fun e!718 () Bool)

(assert (=> b!1275 (= e!718 e!720)))

(declare-fun res!681 () Bool)

(assert (=> b!1275 (= res!681 (isBlack!0 (left!8 (left!8 (right!8 (left!8 lt!5))))))))

(assert (=> b!1275 (=> (not res!681) (not e!720))))

(declare-fun b!1276 () Bool)

(assert (=> b!1276 (= e!721 e!718)))

(declare-fun c!333 () Bool)

(assert (=> b!1276 (= c!333 ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!1277 () Bool)

(assert (=> b!1277 (= e!718 e!719)))

(declare-fun res!682 () Bool)

(assert (=> b!1277 (= res!682 call!218)))

(assert (=> b!1277 (=> (not res!682) (not e!719))))

(assert (= (and d!763 (not res!683)) b!1276))

(assert (= (and b!1276 c!333) b!1277))

(assert (= (and b!1276 (not c!333)) b!1275))

(assert (= (and b!1277 res!682) b!1274))

(assert (= (and b!1275 res!681) b!1273))

(assert (= (and b!1273 res!684) b!1271))

(assert (= (and b!1271 res!685) b!1272))

(assert (= (or b!1277 b!1271) bm!217))

(assert (= (or b!1274 b!1272) bm!218))

(declare-fun m!1837 () Bool)

(assert (=> bm!217 m!1837))

(declare-fun m!1839 () Bool)

(assert (=> bm!218 m!1839))

(declare-fun m!1841 () Bool)

(assert (=> b!1273 m!1841))

(declare-fun m!1843 () Bool)

(assert (=> b!1275 m!1843))

(assert (=> bm!112 d!763))

(declare-fun d!765 () Bool)

(declare-fun lt!57 () Int)

(assert (=> d!765 (>= lt!57 0)))

(declare-fun e!722 () Int)

(assert (=> d!765 (= lt!57 e!722)))

(declare-fun c!334 () Bool)

(assert (=> d!765 (= c!334 ((_ is Empty!3) (left!8 (right!8 (right!8 lt!5)))))))

(assert (=> d!765 (= (size!0 (left!8 (right!8 (right!8 lt!5)))) lt!57)))

(declare-fun b!1278 () Bool)

(assert (=> b!1278 (= e!722 0)))

(declare-fun b!1279 () Bool)

(assert (=> b!1279 (= e!722 (+ (size!0 (left!8 (left!8 (right!8 (right!8 lt!5))))) 1 (size!0 (right!8 (left!8 (right!8 (right!8 lt!5)))))))))

(assert (= (and d!765 c!334) b!1278))

(assert (= (and d!765 (not c!334)) b!1279))

(declare-fun m!1845 () Bool)

(assert (=> b!1279 m!1845))

(declare-fun m!1847 () Bool)

(assert (=> b!1279 m!1847))

(assert (=> b!479 d!765))

(declare-fun d!767 () Bool)

(declare-fun lt!58 () Int)

(assert (=> d!767 (>= lt!58 0)))

(declare-fun e!723 () Int)

(assert (=> d!767 (= lt!58 e!723)))

(declare-fun c!335 () Bool)

(assert (=> d!767 (= c!335 ((_ is Empty!3) (right!8 (right!8 (right!8 lt!5)))))))

(assert (=> d!767 (= (size!0 (right!8 (right!8 (right!8 lt!5)))) lt!58)))

(declare-fun b!1280 () Bool)

(assert (=> b!1280 (= e!723 0)))

(declare-fun b!1281 () Bool)

(assert (=> b!1281 (= e!723 (+ (size!0 (left!8 (right!8 (right!8 (right!8 lt!5))))) 1 (size!0 (right!8 (right!8 (right!8 (right!8 lt!5)))))))))

(assert (= (and d!767 c!335) b!1280))

(assert (= (and d!767 (not c!335)) b!1281))

(declare-fun m!1849 () Bool)

(assert (=> b!1281 m!1849))

(declare-fun m!1851 () Bool)

(assert (=> b!1281 m!1851))

(assert (=> b!479 d!767))

(declare-fun d!769 () Bool)

(assert (=> d!769 (= (isBlack!0 (left!8 (right!8 lt!13))) (or ((_ is Empty!3) (left!8 (right!8 lt!13))) ((_ is Black!3) (color!6 (left!8 (right!8 lt!13))))))))

(assert (=> b!484 d!769))

(declare-fun d!771 () Bool)

(assert (=> d!771 (= (isBlack!0 (right!8 (right!8 (left!8 (right!8 lt!2))))) (or ((_ is Empty!3) (right!8 (right!8 (left!8 (right!8 lt!2))))) ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 (right!8 lt!2))))))))))

(assert (=> b!760 d!771))

(declare-fun b!1282 () Bool)

(declare-fun res!690 () Bool)

(declare-fun call!220 () Bool)

(assert (=> b!1282 (= res!690 call!220)))

(declare-fun e!726 () Bool)

(assert (=> b!1282 (=> (not res!690) (not e!726))))

(declare-fun d!773 () Bool)

(declare-fun res!688 () Bool)

(declare-fun e!727 () Bool)

(assert (=> d!773 (=> res!688 e!727)))

(assert (=> d!773 (= res!688 ((_ is Empty!3) (right!8 (left!8 (right!8 (left!8 t!78))))))))

(assert (=> d!773 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (left!8 t!78))))) e!727)))

(declare-fun b!1283 () Bool)

(declare-fun call!219 () Bool)

(assert (=> b!1283 (= e!726 call!219)))

(declare-fun bm!219 () Bool)

(assert (=> bm!219 (= call!220 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (right!8 (left!8 t!78)))))))))

(declare-fun bm!220 () Bool)

(assert (=> bm!220 (= call!219 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (right!8 (left!8 t!78)))))))))

(declare-fun b!1284 () Bool)

(declare-fun res!689 () Bool)

(assert (=> b!1284 (= res!689 (isBlack!0 (right!8 (right!8 (left!8 (right!8 (left!8 t!78)))))))))

(assert (=> b!1284 (=> (not res!689) (not e!726))))

(declare-fun b!1285 () Bool)

(declare-fun e!725 () Bool)

(assert (=> b!1285 (= e!725 call!219)))

(declare-fun b!1286 () Bool)

(declare-fun e!724 () Bool)

(assert (=> b!1286 (= e!724 e!726)))

(declare-fun res!686 () Bool)

(assert (=> b!1286 (= res!686 (isBlack!0 (left!8 (right!8 (left!8 (right!8 (left!8 t!78)))))))))

(assert (=> b!1286 (=> (not res!686) (not e!726))))

(declare-fun b!1287 () Bool)

(assert (=> b!1287 (= e!727 e!724)))

(declare-fun c!336 () Bool)

(assert (=> b!1287 (= c!336 ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 (left!8 t!78)))))))))

(declare-fun b!1288 () Bool)

(assert (=> b!1288 (= e!724 e!725)))

(declare-fun res!687 () Bool)

(assert (=> b!1288 (= res!687 call!220)))

(assert (=> b!1288 (=> (not res!687) (not e!725))))

(assert (= (and d!773 (not res!688)) b!1287))

(assert (= (and b!1287 c!336) b!1288))

(assert (= (and b!1287 (not c!336)) b!1286))

(assert (= (and b!1288 res!687) b!1285))

(assert (= (and b!1286 res!686) b!1284))

(assert (= (and b!1284 res!689) b!1282))

(assert (= (and b!1282 res!690) b!1283))

(assert (= (or b!1288 b!1282) bm!219))

(assert (= (or b!1285 b!1283) bm!220))

(declare-fun m!1853 () Bool)

(assert (=> bm!219 m!1853))

(declare-fun m!1855 () Bool)

(assert (=> bm!220 m!1855))

(declare-fun m!1857 () Bool)

(assert (=> b!1284 m!1857))

(declare-fun m!1859 () Bool)

(assert (=> b!1286 m!1859))

(assert (=> bm!127 d!773))

(declare-fun d!775 () Bool)

(assert (=> d!775 (= (isBlack!0 (right!8 (right!8 (right!8 lt!5)))) (or ((_ is Empty!3) (right!8 (right!8 (right!8 lt!5)))) ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 lt!5)))))))))

(assert (=> b!665 d!775))

(declare-fun d!777 () Bool)

(assert (=> d!777 (= (isBlack!0 (right!8 (right!8 (right!8 (right!8 t!78))))) (or ((_ is Empty!3) (right!8 (right!8 (right!8 (right!8 t!78))))) ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 (right!8 t!78))))))))))

(assert (=> b!552 d!777))

(declare-fun d!779 () Bool)

(declare-fun c!337 () Bool)

(assert (=> d!779 (= c!337 ((_ is Empty!3) (left!8 lt!19)))))

(declare-fun e!728 () (_ BitVec 32))

(assert (=> d!779 (= (blackHeight!0 (left!8 lt!19)) e!728)))

(declare-fun b!1289 () Bool)

(declare-fun e!729 () (_ BitVec 32))

(declare-fun call!221 () (_ BitVec 32))

(assert (=> b!1289 (= e!729 (bvadd call!221 #b00000000000000000000000000000001))))

(declare-fun bm!221 () Bool)

(assert (=> bm!221 (= call!221 (blackHeight!0 (left!8 (left!8 lt!19))))))

(declare-fun b!1290 () Bool)

(assert (=> b!1290 (= e!729 call!221)))

(declare-fun b!1291 () Bool)

(assert (=> b!1291 (= e!728 e!729)))

(declare-fun c!338 () Bool)

(assert (=> b!1291 (= c!338 ((_ is Black!3) (color!6 (left!8 lt!19))))))

(declare-fun b!1292 () Bool)

(assert (=> b!1292 (= e!728 #b00000000000000000000000000000001)))

(assert (= (and d!779 c!337) b!1292))

(assert (= (and d!779 (not c!337)) b!1291))

(assert (= (and b!1291 c!338) b!1289))

(assert (= (and b!1291 (not c!338)) b!1290))

(assert (= (or b!1289 b!1290) bm!221))

(declare-fun m!1861 () Bool)

(assert (=> bm!221 m!1861))

(assert (=> b!727 d!779))

(declare-fun d!781 () Bool)

(declare-fun c!339 () Bool)

(assert (=> d!781 (= c!339 ((_ is Empty!3) (right!8 lt!19)))))

(declare-fun e!730 () (_ BitVec 32))

(assert (=> d!781 (= (blackHeight!0 (right!8 lt!19)) e!730)))

(declare-fun b!1293 () Bool)

(declare-fun e!731 () (_ BitVec 32))

(declare-fun call!222 () (_ BitVec 32))

(assert (=> b!1293 (= e!731 (bvadd call!222 #b00000000000000000000000000000001))))

(declare-fun bm!222 () Bool)

(assert (=> bm!222 (= call!222 (blackHeight!0 (left!8 (right!8 lt!19))))))

(declare-fun b!1294 () Bool)

(assert (=> b!1294 (= e!731 call!222)))

(declare-fun b!1295 () Bool)

(assert (=> b!1295 (= e!730 e!731)))

(declare-fun c!340 () Bool)

(assert (=> b!1295 (= c!340 ((_ is Black!3) (color!6 (right!8 lt!19))))))

(declare-fun b!1296 () Bool)

(assert (=> b!1296 (= e!730 #b00000000000000000000000000000001)))

(assert (= (and d!781 c!339) b!1296))

(assert (= (and d!781 (not c!339)) b!1295))

(assert (= (and b!1295 c!340) b!1293))

(assert (= (and b!1295 (not c!340)) b!1294))

(assert (= (or b!1293 b!1294) bm!222))

(declare-fun m!1863 () Bool)

(assert (=> bm!222 m!1863))

(assert (=> b!727 d!781))

(declare-fun d!783 () Bool)

(declare-fun res!691 () Bool)

(declare-fun e!732 () Bool)

(assert (=> d!783 (=> res!691 e!732)))

(assert (=> d!783 (= res!691 (not ((_ is Node!3) (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (=> d!783 (= (blackBalanced!0 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) e!732)))

(declare-fun b!1297 () Bool)

(declare-fun e!733 () Bool)

(assert (=> b!1297 (= e!732 e!733)))

(declare-fun res!693 () Bool)

(assert (=> b!1297 (=> (not res!693) (not e!733))))

(assert (=> b!1297 (= res!693 (blackBalanced!0 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(declare-fun b!1298 () Bool)

(declare-fun res!692 () Bool)

(assert (=> b!1298 (=> (not res!692) (not e!733))))

(assert (=> b!1298 (= res!692 (blackBalanced!0 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(declare-fun b!1299 () Bool)

(assert (=> b!1299 (= e!733 (= (blackHeight!0 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (blackHeight!0 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))))

(assert (= (and d!783 (not res!691)) b!1297))

(assert (= (and b!1297 res!693) b!1298))

(assert (= (and b!1298 res!692) b!1299))

(declare-fun m!1865 () Bool)

(assert (=> b!1297 m!1865))

(declare-fun m!1867 () Bool)

(assert (=> b!1298 m!1867))

(declare-fun m!1869 () Bool)

(assert (=> b!1299 m!1869))

(declare-fun m!1871 () Bool)

(assert (=> b!1299 m!1871))

(assert (=> b!605 d!783))

(declare-fun b!1300 () Bool)

(declare-fun res!698 () Bool)

(declare-fun call!224 () Bool)

(assert (=> b!1300 (= res!698 call!224)))

(declare-fun e!736 () Bool)

(assert (=> b!1300 (=> (not res!698) (not e!736))))

(declare-fun d!785 () Bool)

(declare-fun res!696 () Bool)

(declare-fun e!737 () Bool)

(assert (=> d!785 (=> res!696 e!737)))

(assert (=> d!785 (= res!696 ((_ is Empty!3) (right!8 (left!8 (left!8 (left!8 t!78))))))))

(assert (=> d!785 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (left!8 t!78))))) e!737)))

(declare-fun b!1301 () Bool)

(declare-fun call!223 () Bool)

(assert (=> b!1301 (= e!736 call!223)))

(declare-fun bm!223 () Bool)

(assert (=> bm!223 (= call!224 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (left!8 (left!8 t!78)))))))))

(declare-fun bm!224 () Bool)

(assert (=> bm!224 (= call!223 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (left!8 (left!8 t!78)))))))))

(declare-fun b!1302 () Bool)

(declare-fun res!697 () Bool)

(assert (=> b!1302 (= res!697 (isBlack!0 (right!8 (right!8 (left!8 (left!8 (left!8 t!78)))))))))

(assert (=> b!1302 (=> (not res!697) (not e!736))))

(declare-fun b!1303 () Bool)

(declare-fun e!735 () Bool)

(assert (=> b!1303 (= e!735 call!223)))

(declare-fun b!1304 () Bool)

(declare-fun e!734 () Bool)

(assert (=> b!1304 (= e!734 e!736)))

(declare-fun res!694 () Bool)

(assert (=> b!1304 (= res!694 (isBlack!0 (left!8 (right!8 (left!8 (left!8 (left!8 t!78)))))))))

(assert (=> b!1304 (=> (not res!694) (not e!736))))

(declare-fun b!1305 () Bool)

(assert (=> b!1305 (= e!737 e!734)))

(declare-fun c!341 () Bool)

(assert (=> b!1305 (= c!341 ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 (left!8 t!78)))))))))

(declare-fun b!1306 () Bool)

(assert (=> b!1306 (= e!734 e!735)))

(declare-fun res!695 () Bool)

(assert (=> b!1306 (= res!695 call!224)))

(assert (=> b!1306 (=> (not res!695) (not e!735))))

(assert (= (and d!785 (not res!696)) b!1305))

(assert (= (and b!1305 c!341) b!1306))

(assert (= (and b!1305 (not c!341)) b!1304))

(assert (= (and b!1306 res!695) b!1303))

(assert (= (and b!1304 res!694) b!1302))

(assert (= (and b!1302 res!697) b!1300))

(assert (= (and b!1300 res!698) b!1301))

(assert (= (or b!1306 b!1300) bm!223))

(assert (= (or b!1303 b!1301) bm!224))

(declare-fun m!1873 () Bool)

(assert (=> bm!223 m!1873))

(declare-fun m!1875 () Bool)

(assert (=> bm!224 m!1875))

(declare-fun m!1877 () Bool)

(assert (=> b!1302 m!1877))

(declare-fun m!1879 () Bool)

(assert (=> b!1304 m!1879))

(assert (=> bm!143 d!785))

(declare-fun b!1307 () Bool)

(declare-fun res!703 () Bool)

(declare-fun call!226 () Bool)

(assert (=> b!1307 (= res!703 call!226)))

(declare-fun e!740 () Bool)

(assert (=> b!1307 (=> (not res!703) (not e!740))))

(declare-fun d!787 () Bool)

(declare-fun res!701 () Bool)

(declare-fun e!741 () Bool)

(assert (=> d!787 (=> res!701 e!741)))

(assert (=> d!787 (= res!701 ((_ is Empty!3) (left!8 (right!8 (right!8 (left!8 t!78))))))))

(assert (=> d!787 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (left!8 t!78))))) e!741)))

(declare-fun b!1308 () Bool)

(declare-fun call!225 () Bool)

(assert (=> b!1308 (= e!740 call!225)))

(declare-fun bm!225 () Bool)

(assert (=> bm!225 (= call!226 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (right!8 (left!8 t!78)))))))))

(declare-fun bm!226 () Bool)

(assert (=> bm!226 (= call!225 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (right!8 (left!8 t!78)))))))))

(declare-fun b!1309 () Bool)

(declare-fun res!702 () Bool)

(assert (=> b!1309 (= res!702 (isBlack!0 (right!8 (left!8 (right!8 (right!8 (left!8 t!78)))))))))

(assert (=> b!1309 (=> (not res!702) (not e!740))))

(declare-fun b!1310 () Bool)

(declare-fun e!739 () Bool)

(assert (=> b!1310 (= e!739 call!225)))

(declare-fun b!1311 () Bool)

(declare-fun e!738 () Bool)

(assert (=> b!1311 (= e!738 e!740)))

(declare-fun res!699 () Bool)

(assert (=> b!1311 (= res!699 (isBlack!0 (left!8 (left!8 (right!8 (right!8 (left!8 t!78)))))))))

(assert (=> b!1311 (=> (not res!699) (not e!740))))

(declare-fun b!1312 () Bool)

(assert (=> b!1312 (= e!741 e!738)))

(declare-fun c!342 () Bool)

(assert (=> b!1312 (= c!342 ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 (left!8 t!78)))))))))

(declare-fun b!1313 () Bool)

(assert (=> b!1313 (= e!738 e!739)))

(declare-fun res!700 () Bool)

(assert (=> b!1313 (= res!700 call!226)))

(assert (=> b!1313 (=> (not res!700) (not e!739))))

(assert (= (and d!787 (not res!701)) b!1312))

(assert (= (and b!1312 c!342) b!1313))

(assert (= (and b!1312 (not c!342)) b!1311))

(assert (= (and b!1313 res!700) b!1310))

(assert (= (and b!1311 res!699) b!1309))

(assert (= (and b!1309 res!702) b!1307))

(assert (= (and b!1307 res!703) b!1308))

(assert (= (or b!1313 b!1307) bm!225))

(assert (= (or b!1310 b!1308) bm!226))

(declare-fun m!1881 () Bool)

(assert (=> bm!225 m!1881))

(declare-fun m!1883 () Bool)

(assert (=> bm!226 m!1883))

(declare-fun m!1885 () Bool)

(assert (=> b!1309 m!1885))

(declare-fun m!1887 () Bool)

(assert (=> b!1311 m!1887))

(assert (=> bm!136 d!787))

(declare-fun b!1314 () Bool)

(declare-fun res!708 () Bool)

(declare-fun call!228 () Bool)

(assert (=> b!1314 (= res!708 call!228)))

(declare-fun e!744 () Bool)

(assert (=> b!1314 (=> (not res!708) (not e!744))))

(declare-fun d!789 () Bool)

(declare-fun res!706 () Bool)

(declare-fun e!745 () Bool)

(assert (=> d!789 (=> res!706 e!745)))

(assert (=> d!789 (= res!706 ((_ is Empty!3) (left!8 (right!8 (right!8 (left!8 lt!2))))))))

(assert (=> d!789 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (left!8 lt!2))))) e!745)))

(declare-fun b!1315 () Bool)

(declare-fun call!227 () Bool)

(assert (=> b!1315 (= e!744 call!227)))

(declare-fun bm!227 () Bool)

(assert (=> bm!227 (= call!228 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (right!8 (left!8 lt!2)))))))))

(declare-fun bm!228 () Bool)

(assert (=> bm!228 (= call!227 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (right!8 (left!8 lt!2)))))))))

(declare-fun b!1316 () Bool)

(declare-fun res!707 () Bool)

(assert (=> b!1316 (= res!707 (isBlack!0 (right!8 (left!8 (right!8 (right!8 (left!8 lt!2)))))))))

(assert (=> b!1316 (=> (not res!707) (not e!744))))

(declare-fun b!1317 () Bool)

(declare-fun e!743 () Bool)

(assert (=> b!1317 (= e!743 call!227)))

(declare-fun b!1318 () Bool)

(declare-fun e!742 () Bool)

(assert (=> b!1318 (= e!742 e!744)))

(declare-fun res!704 () Bool)

(assert (=> b!1318 (= res!704 (isBlack!0 (left!8 (left!8 (right!8 (right!8 (left!8 lt!2)))))))))

(assert (=> b!1318 (=> (not res!704) (not e!744))))

(declare-fun b!1319 () Bool)

(assert (=> b!1319 (= e!745 e!742)))

(declare-fun c!343 () Bool)

(assert (=> b!1319 (= c!343 ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 (left!8 lt!2)))))))))

(declare-fun b!1320 () Bool)

(assert (=> b!1320 (= e!742 e!743)))

(declare-fun res!705 () Bool)

(assert (=> b!1320 (= res!705 call!228)))

(assert (=> b!1320 (=> (not res!705) (not e!743))))

(assert (= (and d!789 (not res!706)) b!1319))

(assert (= (and b!1319 c!343) b!1320))

(assert (= (and b!1319 (not c!343)) b!1318))

(assert (= (and b!1320 res!705) b!1317))

(assert (= (and b!1318 res!704) b!1316))

(assert (= (and b!1316 res!707) b!1314))

(assert (= (and b!1314 res!708) b!1315))

(assert (= (or b!1320 b!1314) bm!227))

(assert (= (or b!1317 b!1315) bm!228))

(declare-fun m!1889 () Bool)

(assert (=> bm!227 m!1889))

(declare-fun m!1891 () Bool)

(assert (=> bm!228 m!1891))

(declare-fun m!1893 () Bool)

(assert (=> b!1316 m!1893))

(declare-fun m!1895 () Bool)

(assert (=> b!1318 m!1895))

(assert (=> bm!122 d!789))

(declare-fun d!791 () Bool)

(declare-fun res!709 () Bool)

(declare-fun e!746 () Bool)

(assert (=> d!791 (=> res!709 e!746)))

(assert (=> d!791 (= res!709 (not ((_ is Node!3) (right!8 (right!8 (right!8 lt!5))))))))

(assert (=> d!791 (= (blackBalanced!0 (right!8 (right!8 (right!8 lt!5)))) e!746)))

(declare-fun b!1321 () Bool)

(declare-fun e!747 () Bool)

(assert (=> b!1321 (= e!746 e!747)))

(declare-fun res!711 () Bool)

(assert (=> b!1321 (=> (not res!711) (not e!747))))

(assert (=> b!1321 (= res!711 (blackBalanced!0 (left!8 (right!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!1322 () Bool)

(declare-fun res!710 () Bool)

(assert (=> b!1322 (=> (not res!710) (not e!747))))

(assert (=> b!1322 (= res!710 (blackBalanced!0 (right!8 (right!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!1323 () Bool)

(assert (=> b!1323 (= e!747 (= (blackHeight!0 (left!8 (right!8 (right!8 (right!8 lt!5))))) (blackHeight!0 (right!8 (right!8 (right!8 (right!8 lt!5)))))))))

(assert (= (and d!791 (not res!709)) b!1321))

(assert (= (and b!1321 res!711) b!1322))

(assert (= (and b!1322 res!710) b!1323))

(declare-fun m!1897 () Bool)

(assert (=> b!1321 m!1897))

(declare-fun m!1899 () Bool)

(assert (=> b!1322 m!1899))

(assert (=> b!1323 m!1497))

(declare-fun m!1901 () Bool)

(assert (=> b!1323 m!1901))

(assert (=> b!467 d!791))

(declare-fun d!793 () Bool)

(assert (=> d!793 (= (isBlack!0 (right!8 (left!8 (right!8 (left!8 t!78))))) (or ((_ is Empty!3) (right!8 (left!8 (right!8 (left!8 t!78))))) ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 (left!8 t!78))))))))))

(assert (=> b!699 d!793))

(declare-fun c!344 () Bool)

(declare-fun d!795 () Bool)

(assert (=> d!795 (= c!344 ((_ is Empty!3) (left!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))))

(declare-fun e!748 () (InoxSet (_ BitVec 32)))

(assert (=> d!795 (= (content!0 (left!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))) e!748)))

(declare-fun b!1324 () Bool)

(assert (=> b!1324 (= e!748 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1325 () Bool)

(assert (=> b!1325 (= e!748 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))) true)) (content!0 (right!8 (left!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))))))

(assert (= (and d!795 c!344) b!1324))

(assert (= (and d!795 (not c!344)) b!1325))

(declare-fun m!1903 () Bool)

(assert (=> b!1325 m!1903))

(declare-fun m!1905 () Bool)

(assert (=> b!1325 m!1905))

(declare-fun m!1907 () Bool)

(assert (=> b!1325 m!1907))

(assert (=> b!582 d!795))

(declare-fun c!345 () Bool)

(declare-fun d!797 () Bool)

(assert (=> d!797 (= c!345 ((_ is Empty!3) (right!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))))

(declare-fun e!749 () (InoxSet (_ BitVec 32)))

(assert (=> d!797 (= (content!0 (right!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))) e!749)))

(declare-fun b!1326 () Bool)

(assert (=> b!1326 (= e!749 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1327 () Bool)

(assert (=> b!1327 (= e!749 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))) true)) (content!0 (right!8 (right!8 (right!8 (Node!3 (color!6 t!78) (ite c!50 call!38 (left!8 t!78)) (value!38 t!78) (ite c!50 (right!8 t!78) call!38))))))))))

(assert (= (and d!797 c!345) b!1326))

(assert (= (and d!797 (not c!345)) b!1327))

(declare-fun m!1909 () Bool)

(assert (=> b!1327 m!1909))

(declare-fun m!1911 () Bool)

(assert (=> b!1327 m!1911))

(declare-fun m!1913 () Bool)

(assert (=> b!1327 m!1913))

(assert (=> b!582 d!797))

(declare-fun d!799 () Bool)

(declare-fun res!712 () Bool)

(declare-fun e!750 () Bool)

(assert (=> d!799 (=> res!712 e!750)))

(assert (=> d!799 (= res!712 (not ((_ is Node!3) (left!8 (right!8 (right!8 t!78))))))))

(assert (=> d!799 (= (blackBalanced!0 (left!8 (right!8 (right!8 t!78)))) e!750)))

(declare-fun b!1328 () Bool)

(declare-fun e!751 () Bool)

(assert (=> b!1328 (= e!750 e!751)))

(declare-fun res!714 () Bool)

(assert (=> b!1328 (=> (not res!714) (not e!751))))

(assert (=> b!1328 (= res!714 (blackBalanced!0 (left!8 (left!8 (right!8 (right!8 t!78))))))))

(declare-fun b!1329 () Bool)

(declare-fun res!713 () Bool)

(assert (=> b!1329 (=> (not res!713) (not e!751))))

(assert (=> b!1329 (= res!713 (blackBalanced!0 (right!8 (left!8 (right!8 (right!8 t!78))))))))

(declare-fun b!1330 () Bool)

(assert (=> b!1330 (= e!751 (= (blackHeight!0 (left!8 (left!8 (right!8 (right!8 t!78))))) (blackHeight!0 (right!8 (left!8 (right!8 (right!8 t!78)))))))))

(assert (= (and d!799 (not res!712)) b!1328))

(assert (= (and b!1328 res!714) b!1329))

(assert (= (and b!1329 res!713) b!1330))

(declare-fun m!1915 () Bool)

(assert (=> b!1328 m!1915))

(declare-fun m!1917 () Bool)

(assert (=> b!1329 m!1917))

(assert (=> b!1330 m!1653))

(declare-fun m!1919 () Bool)

(assert (=> b!1330 m!1919))

(assert (=> b!522 d!799))

(declare-fun c!346 () Bool)

(declare-fun d!801 () Bool)

(assert (=> d!801 (= c!346 ((_ is Empty!3) (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun e!752 () (InoxSet (_ BitVec 32)))

(assert (=> d!801 (= (content!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) e!752)))

(declare-fun b!1331 () Bool)

(assert (=> b!1331 (= e!752 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1332 () Bool)

(assert (=> b!1332 (= e!752 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) true)) (content!0 (right!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (= (and d!801 c!346) b!1331))

(assert (= (and d!801 (not c!346)) b!1332))

(declare-fun m!1921 () Bool)

(assert (=> b!1332 m!1921))

(declare-fun m!1923 () Bool)

(assert (=> b!1332 m!1923))

(declare-fun m!1925 () Bool)

(assert (=> b!1332 m!1925))

(assert (=> b!785 d!801))

(declare-fun d!803 () Bool)

(declare-fun c!347 () Bool)

(assert (=> d!803 (= c!347 ((_ is Empty!3) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun e!753 () (InoxSet (_ BitVec 32)))

(assert (=> d!803 (= (content!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) e!753)))

(declare-fun b!1333 () Bool)

(assert (=> b!1333 (= e!753 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1334 () Bool)

(assert (=> b!1334 (= e!753 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) true)) (content!0 (right!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (= (and d!803 c!347) b!1333))

(assert (= (and d!803 (not c!347)) b!1334))

(declare-fun m!1927 () Bool)

(assert (=> b!1334 m!1927))

(declare-fun m!1929 () Bool)

(assert (=> b!1334 m!1929))

(declare-fun m!1931 () Bool)

(assert (=> b!1334 m!1931))

(assert (=> b!785 d!803))

(declare-fun d!805 () Bool)

(assert (=> d!805 (= (isBlack!0 (right!8 (left!8 (right!8 (right!8 lt!2))))) (or ((_ is Empty!3) (right!8 (left!8 (right!8 (right!8 lt!2))))) ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 (right!8 lt!2))))))))))

(assert (=> b!585 d!805))

(declare-fun d!807 () Bool)

(assert (=> d!807 (= (isBlack!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (or ((_ is Empty!3) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) ((_ is Black!3) (color!6 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (=> b!788 d!807))

(declare-fun d!809 () Bool)

(declare-fun res!715 () Bool)

(declare-fun e!754 () Bool)

(assert (=> d!809 (=> res!715 e!754)))

(assert (=> d!809 (= res!715 (not ((_ is Node!3) (right!8 (right!8 lt!13)))))))

(assert (=> d!809 (= (blackBalanced!0 (right!8 (right!8 lt!13))) e!754)))

(declare-fun b!1335 () Bool)

(declare-fun e!755 () Bool)

(assert (=> b!1335 (= e!754 e!755)))

(declare-fun res!717 () Bool)

(assert (=> b!1335 (=> (not res!717) (not e!755))))

(assert (=> b!1335 (= res!717 (blackBalanced!0 (left!8 (right!8 (right!8 lt!13)))))))

(declare-fun b!1336 () Bool)

(declare-fun res!716 () Bool)

(assert (=> b!1336 (=> (not res!716) (not e!755))))

(assert (=> b!1336 (= res!716 (blackBalanced!0 (right!8 (right!8 (right!8 lt!13)))))))

(declare-fun b!1337 () Bool)

(assert (=> b!1337 (= e!755 (= (blackHeight!0 (left!8 (right!8 (right!8 lt!13)))) (blackHeight!0 (right!8 (right!8 (right!8 lt!13))))))))

(assert (= (and d!809 (not res!715)) b!1335))

(assert (= (and b!1335 res!717) b!1336))

(assert (= (and b!1336 res!716) b!1337))

(declare-fun m!1933 () Bool)

(assert (=> b!1335 m!1933))

(declare-fun m!1935 () Bool)

(assert (=> b!1336 m!1935))

(declare-fun m!1937 () Bool)

(assert (=> b!1337 m!1937))

(declare-fun m!1939 () Bool)

(assert (=> b!1337 m!1939))

(assert (=> b!688 d!809))

(declare-fun b!1338 () Bool)

(declare-fun res!722 () Bool)

(declare-fun call!230 () Bool)

(assert (=> b!1338 (= res!722 call!230)))

(declare-fun e!758 () Bool)

(assert (=> b!1338 (=> (not res!722) (not e!758))))

(declare-fun d!811 () Bool)

(declare-fun res!720 () Bool)

(declare-fun e!759 () Bool)

(assert (=> d!811 (=> res!720 e!759)))

(assert (=> d!811 (= res!720 ((_ is Empty!3) (right!8 (right!8 (left!8 lt!5)))))))

(assert (=> d!811 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 lt!5)))) e!759)))

(declare-fun b!1339 () Bool)

(declare-fun call!229 () Bool)

(assert (=> b!1339 (= e!758 call!229)))

(declare-fun bm!229 () Bool)

(assert (=> bm!229 (= call!230 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (left!8 lt!5))))))))

(declare-fun bm!230 () Bool)

(assert (=> bm!230 (= call!229 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!1340 () Bool)

(declare-fun res!721 () Bool)

(assert (=> b!1340 (= res!721 (isBlack!0 (right!8 (right!8 (right!8 (left!8 lt!5))))))))

(assert (=> b!1340 (=> (not res!721) (not e!758))))

(declare-fun b!1341 () Bool)

(declare-fun e!757 () Bool)

(assert (=> b!1341 (= e!757 call!229)))

(declare-fun b!1342 () Bool)

(declare-fun e!756 () Bool)

(assert (=> b!1342 (= e!756 e!758)))

(declare-fun res!718 () Bool)

(assert (=> b!1342 (= res!718 (isBlack!0 (left!8 (right!8 (right!8 (left!8 lt!5))))))))

(assert (=> b!1342 (=> (not res!718) (not e!758))))

(declare-fun b!1343 () Bool)

(assert (=> b!1343 (= e!759 e!756)))

(declare-fun c!348 () Bool)

(assert (=> b!1343 (= c!348 ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 lt!5))))))))

(declare-fun b!1344 () Bool)

(assert (=> b!1344 (= e!756 e!757)))

(declare-fun res!719 () Bool)

(assert (=> b!1344 (= res!719 call!230)))

(assert (=> b!1344 (=> (not res!719) (not e!757))))

(assert (= (and d!811 (not res!720)) b!1343))

(assert (= (and b!1343 c!348) b!1344))

(assert (= (and b!1343 (not c!348)) b!1342))

(assert (= (and b!1344 res!719) b!1341))

(assert (= (and b!1342 res!718) b!1340))

(assert (= (and b!1340 res!721) b!1338))

(assert (= (and b!1338 res!722) b!1339))

(assert (= (or b!1344 b!1338) bm!229))

(assert (= (or b!1341 b!1339) bm!230))

(declare-fun m!1941 () Bool)

(assert (=> bm!229 m!1941))

(declare-fun m!1943 () Bool)

(assert (=> bm!230 m!1943))

(declare-fun m!1945 () Bool)

(assert (=> b!1340 m!1945))

(declare-fun m!1947 () Bool)

(assert (=> b!1342 m!1947))

(assert (=> bm!113 d!811))

(declare-fun b!1345 () Bool)

(declare-fun res!726 () Bool)

(declare-fun e!764 () Bool)

(assert (=> b!1345 (=> (not res!726) (not e!764))))

(declare-fun lt!59 () Tree!3)

(assert (=> b!1345 (= res!726 (<= (size!0 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (size!0 lt!59)))))

(declare-fun b!1346 () Bool)

(declare-fun e!762 () Tree!3)

(declare-fun call!232 () Tree!3)

(assert (=> b!1346 (= e!762 call!232)))

(declare-fun b!1347 () Bool)

(declare-fun e!760 () Tree!3)

(assert (=> b!1347 (= e!760 call!232)))

(declare-fun b!1348 () Bool)

(declare-fun res!724 () Bool)

(assert (=> b!1348 (=> (not res!724) (not e!764))))

(assert (=> b!1348 (= res!724 (<= (size!0 lt!59) (+ (size!0 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) 1)))))

(declare-fun bm!231 () Bool)

(declare-fun call!231 () Tree!3)

(declare-fun c!351 () Bool)

(assert (=> bm!231 (= call!232 (balance!0 (color!6 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (ite c!351 call!231 (left!8 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))) (value!38 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (ite c!351 (right!8 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) call!231)))))

(declare-fun b!1349 () Bool)

(declare-fun e!761 () Tree!3)

(assert (=> b!1349 (= e!761 e!760)))

(assert (=> b!1349 (= c!351 (bvslt x!73 (value!38 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))))

(declare-fun c!349 () Bool)

(declare-fun b!1350 () Bool)

(assert (=> b!1350 (= c!349 (= x!73 (value!38 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))))

(assert (=> b!1350 (= e!760 e!762)))

(declare-fun b!1352 () Bool)

(assert (=> b!1352 (= e!761 (Node!3 Red!3 Empty!3 x!73 Empty!3))))

(declare-fun b!1353 () Bool)

(declare-fun e!763 () Bool)

(assert (=> b!1353 (= e!763 (blackBalanced!0 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))))

(declare-fun bm!232 () Bool)

(assert (=> bm!232 (= call!231 (ins!0 x!73 (ite c!351 (left!8 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (right!8 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))))))

(declare-fun b!1351 () Bool)

(assert (=> b!1351 (= e!764 (blackBalanced!0 lt!59))))

(declare-fun d!813 () Bool)

(assert (=> d!813 e!764))

(declare-fun res!723 () Bool)

(assert (=> d!813 (=> (not res!723) (not e!764))))

(assert (=> d!813 (= res!723 (= (content!0 lt!59) ((_ map or) (content!0 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) (store ((as const (Array (_ BitVec 32) Bool)) false) x!73 true))))))

(assert (=> d!813 (= lt!59 e!761)))

(declare-fun c!350 () Bool)

(assert (=> d!813 (= c!350 ((_ is Empty!3) (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))))

(assert (=> d!813 e!763))

(declare-fun res!727 () Bool)

(assert (=> d!813 (=> (not res!727) (not e!763))))

(assert (=> d!813 (= res!727 (redNodesHaveBlackChildren!0 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))))

(assert (=> d!813 (= (ins!0 x!73 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))) lt!59)))

(declare-fun b!1354 () Bool)

(declare-fun res!725 () Bool)

(assert (=> b!1354 (=> (not res!725) (not e!764))))

(assert (=> b!1354 (= res!725 (redDescHaveBlackChildren!0 lt!59))))

(declare-fun b!1355 () Bool)

(assert (=> b!1355 (= e!762 (ite c!155 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (= (and d!813 res!727) b!1353))

(assert (= (and d!813 c!350) b!1352))

(assert (= (and d!813 (not c!350)) b!1349))

(assert (= (and b!1349 c!351) b!1347))

(assert (= (and b!1349 (not c!351)) b!1350))

(assert (= (and b!1350 c!349) b!1355))

(assert (= (and b!1350 (not c!349)) b!1346))

(assert (= (or b!1347 b!1346) bm!232))

(assert (= (or b!1347 b!1346) bm!231))

(assert (= (and d!813 res!723) b!1345))

(assert (= (and b!1345 res!726) b!1348))

(assert (= (and b!1348 res!724) b!1354))

(assert (= (and b!1354 res!725) b!1351))

(declare-fun m!1949 () Bool)

(assert (=> d!813 m!1949))

(declare-fun m!1951 () Bool)

(assert (=> d!813 m!1951))

(assert (=> d!813 m!123))

(declare-fun m!1953 () Bool)

(assert (=> d!813 m!1953))

(declare-fun m!1955 () Bool)

(assert (=> bm!232 m!1955))

(declare-fun m!1957 () Bool)

(assert (=> bm!231 m!1957))

(declare-fun m!1959 () Bool)

(assert (=> b!1353 m!1959))

(declare-fun m!1961 () Bool)

(assert (=> b!1345 m!1961))

(declare-fun m!1963 () Bool)

(assert (=> b!1345 m!1963))

(assert (=> b!1348 m!1963))

(assert (=> b!1348 m!1961))

(declare-fun m!1965 () Bool)

(assert (=> b!1351 m!1965))

(declare-fun m!1967 () Bool)

(assert (=> b!1354 m!1967))

(assert (=> bm!105 d!813))

(declare-fun d!815 () Bool)

(declare-fun c!352 () Bool)

(assert (=> d!815 (= c!352 ((_ is Empty!3) (left!8 (left!8 (right!8 (left!8 lt!2))))))))

(declare-fun e!765 () (InoxSet (_ BitVec 32)))

(assert (=> d!815 (= (content!0 (left!8 (left!8 (right!8 (left!8 lt!2))))) e!765)))

(declare-fun b!1356 () Bool)

(assert (=> b!1356 (= e!765 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1357 () Bool)

(assert (=> b!1357 (= e!765 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (right!8 (left!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (right!8 (left!8 lt!2))))) true)) (content!0 (right!8 (left!8 (left!8 (right!8 (left!8 lt!2))))))))))

(assert (= (and d!815 c!352) b!1356))

(assert (= (and d!815 (not c!352)) b!1357))

(declare-fun m!1969 () Bool)

(assert (=> b!1357 m!1969))

(declare-fun m!1971 () Bool)

(assert (=> b!1357 m!1971))

(declare-fun m!1973 () Bool)

(assert (=> b!1357 m!1973))

(assert (=> b!488 d!815))

(declare-fun d!817 () Bool)

(declare-fun c!353 () Bool)

(assert (=> d!817 (= c!353 ((_ is Empty!3) (right!8 (left!8 (right!8 (left!8 lt!2))))))))

(declare-fun e!766 () (InoxSet (_ BitVec 32)))

(assert (=> d!817 (= (content!0 (right!8 (left!8 (right!8 (left!8 lt!2))))) e!766)))

(declare-fun b!1358 () Bool)

(assert (=> b!1358 (= e!766 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1359 () Bool)

(assert (=> b!1359 (= e!766 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (right!8 (left!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (right!8 (left!8 lt!2))))) true)) (content!0 (right!8 (right!8 (left!8 (right!8 (left!8 lt!2))))))))))

(assert (= (and d!817 c!353) b!1358))

(assert (= (and d!817 (not c!353)) b!1359))

(declare-fun m!1975 () Bool)

(assert (=> b!1359 m!1975))

(declare-fun m!1977 () Bool)

(assert (=> b!1359 m!1977))

(declare-fun m!1979 () Bool)

(assert (=> b!1359 m!1979))

(assert (=> b!488 d!817))

(declare-fun b!1360 () Bool)

(declare-fun res!732 () Bool)

(declare-fun call!234 () Bool)

(assert (=> b!1360 (= res!732 call!234)))

(declare-fun e!769 () Bool)

(assert (=> b!1360 (=> (not res!732) (not e!769))))

(declare-fun d!819 () Bool)

(declare-fun res!730 () Bool)

(declare-fun e!770 () Bool)

(assert (=> d!819 (=> res!730 e!770)))

(assert (=> d!819 (= res!730 ((_ is Empty!3) (left!8 (right!8 (right!8 (right!8 lt!2))))))))

(assert (=> d!819 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (right!8 lt!2))))) e!770)))

(declare-fun b!1361 () Bool)

(declare-fun call!233 () Bool)

(assert (=> b!1361 (= e!769 call!233)))

(declare-fun bm!233 () Bool)

(assert (=> bm!233 (= call!234 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (right!8 (right!8 lt!2)))))))))

(declare-fun bm!234 () Bool)

(assert (=> bm!234 (= call!233 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (right!8 (right!8 lt!2)))))))))

(declare-fun b!1362 () Bool)

(declare-fun res!731 () Bool)

(assert (=> b!1362 (= res!731 (isBlack!0 (right!8 (left!8 (right!8 (right!8 (right!8 lt!2)))))))))

(assert (=> b!1362 (=> (not res!731) (not e!769))))

(declare-fun b!1363 () Bool)

(declare-fun e!768 () Bool)

(assert (=> b!1363 (= e!768 call!233)))

(declare-fun b!1364 () Bool)

(declare-fun e!767 () Bool)

(assert (=> b!1364 (= e!767 e!769)))

(declare-fun res!728 () Bool)

(assert (=> b!1364 (= res!728 (isBlack!0 (left!8 (left!8 (right!8 (right!8 (right!8 lt!2)))))))))

(assert (=> b!1364 (=> (not res!728) (not e!769))))

(declare-fun b!1365 () Bool)

(assert (=> b!1365 (= e!770 e!767)))

(declare-fun c!354 () Bool)

(assert (=> b!1365 (= c!354 ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 (right!8 lt!2)))))))))

(declare-fun b!1366 () Bool)

(assert (=> b!1366 (= e!767 e!768)))

(declare-fun res!729 () Bool)

(assert (=> b!1366 (= res!729 call!234)))

(assert (=> b!1366 (=> (not res!729) (not e!768))))

(assert (= (and d!819 (not res!730)) b!1365))

(assert (= (and b!1365 c!354) b!1366))

(assert (= (and b!1365 (not c!354)) b!1364))

(assert (= (and b!1366 res!729) b!1363))

(assert (= (and b!1364 res!728) b!1362))

(assert (= (and b!1362 res!731) b!1360))

(assert (= (and b!1360 res!732) b!1361))

(assert (= (or b!1366 b!1360) bm!233))

(assert (= (or b!1363 b!1361) bm!234))

(declare-fun m!1981 () Bool)

(assert (=> bm!233 m!1981))

(declare-fun m!1983 () Bool)

(assert (=> bm!234 m!1983))

(declare-fun m!1985 () Bool)

(assert (=> b!1362 m!1985))

(declare-fun m!1987 () Bool)

(assert (=> b!1364 m!1987))

(assert (=> bm!116 d!819))

(declare-fun b!1367 () Bool)

(declare-fun res!737 () Bool)

(declare-fun call!236 () Bool)

(assert (=> b!1367 (= res!737 call!236)))

(declare-fun e!773 () Bool)

(assert (=> b!1367 (=> (not res!737) (not e!773))))

(declare-fun d!821 () Bool)

(declare-fun res!735 () Bool)

(declare-fun e!774 () Bool)

(assert (=> d!821 (=> res!735 e!774)))

(assert (=> d!821 (= res!735 ((_ is Empty!3) (left!8 (right!8 (left!8 (left!8 t!78))))))))

(assert (=> d!821 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (left!8 t!78))))) e!774)))

(declare-fun b!1368 () Bool)

(declare-fun call!235 () Bool)

(assert (=> b!1368 (= e!773 call!235)))

(declare-fun bm!235 () Bool)

(assert (=> bm!235 (= call!236 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (left!8 (left!8 t!78)))))))))

(declare-fun bm!236 () Bool)

(assert (=> bm!236 (= call!235 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (left!8 (left!8 t!78)))))))))

(declare-fun b!1369 () Bool)

(declare-fun res!736 () Bool)

(assert (=> b!1369 (= res!736 (isBlack!0 (right!8 (left!8 (right!8 (left!8 (left!8 t!78)))))))))

(assert (=> b!1369 (=> (not res!736) (not e!773))))

(declare-fun b!1370 () Bool)

(declare-fun e!772 () Bool)

(assert (=> b!1370 (= e!772 call!235)))

(declare-fun b!1371 () Bool)

(declare-fun e!771 () Bool)

(assert (=> b!1371 (= e!771 e!773)))

(declare-fun res!733 () Bool)

(assert (=> b!1371 (= res!733 (isBlack!0 (left!8 (left!8 (right!8 (left!8 (left!8 t!78)))))))))

(assert (=> b!1371 (=> (not res!733) (not e!773))))

(declare-fun b!1372 () Bool)

(assert (=> b!1372 (= e!774 e!771)))

(declare-fun c!355 () Bool)

(assert (=> b!1372 (= c!355 ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 (left!8 t!78)))))))))

(declare-fun b!1373 () Bool)

(assert (=> b!1373 (= e!771 e!772)))

(declare-fun res!734 () Bool)

(assert (=> b!1373 (= res!734 call!236)))

(assert (=> b!1373 (=> (not res!734) (not e!772))))

(assert (= (and d!821 (not res!735)) b!1372))

(assert (= (and b!1372 c!355) b!1373))

(assert (= (and b!1372 (not c!355)) b!1371))

(assert (= (and b!1373 res!734) b!1370))

(assert (= (and b!1371 res!733) b!1369))

(assert (= (and b!1369 res!736) b!1367))

(assert (= (and b!1367 res!737) b!1368))

(assert (= (or b!1373 b!1367) bm!235))

(assert (= (or b!1370 b!1368) bm!236))

(declare-fun m!1989 () Bool)

(assert (=> bm!235 m!1989))

(declare-fun m!1991 () Bool)

(assert (=> bm!236 m!1991))

(declare-fun m!1993 () Bool)

(assert (=> b!1369 m!1993))

(declare-fun m!1995 () Bool)

(assert (=> b!1371 m!1995))

(assert (=> bm!90 d!821))

(declare-fun d!823 () Bool)

(declare-fun c!356 () Bool)

(assert (=> d!823 (= c!356 ((_ is Empty!3) (left!8 (left!8 (left!8 lt!5)))))))

(declare-fun e!775 () (_ BitVec 32))

(assert (=> d!823 (= (blackHeight!0 (left!8 (left!8 (left!8 lt!5)))) e!775)))

(declare-fun b!1374 () Bool)

(declare-fun e!776 () (_ BitVec 32))

(declare-fun call!237 () (_ BitVec 32))

(assert (=> b!1374 (= e!776 (bvadd call!237 #b00000000000000000000000000000001))))

(declare-fun bm!237 () Bool)

(assert (=> bm!237 (= call!237 (blackHeight!0 (left!8 (left!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!1375 () Bool)

(assert (=> b!1375 (= e!776 call!237)))

(declare-fun b!1376 () Bool)

(assert (=> b!1376 (= e!775 e!776)))

(declare-fun c!357 () Bool)

(assert (=> b!1376 (= c!357 ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!1377 () Bool)

(assert (=> b!1377 (= e!775 #b00000000000000000000000000000001)))

(assert (= (and d!823 c!356) b!1377))

(assert (= (and d!823 (not c!356)) b!1376))

(assert (= (and b!1376 c!357) b!1374))

(assert (= (and b!1376 (not c!357)) b!1375))

(assert (= (or b!1374 b!1375) bm!237))

(declare-fun m!1997 () Bool)

(assert (=> bm!237 m!1997))

(assert (=> b!724 d!823))

(declare-fun d!825 () Bool)

(declare-fun c!358 () Bool)

(assert (=> d!825 (= c!358 ((_ is Empty!3) (right!8 (left!8 (left!8 lt!5)))))))

(declare-fun e!777 () (_ BitVec 32))

(assert (=> d!825 (= (blackHeight!0 (right!8 (left!8 (left!8 lt!5)))) e!777)))

(declare-fun b!1378 () Bool)

(declare-fun e!778 () (_ BitVec 32))

(declare-fun call!238 () (_ BitVec 32))

(assert (=> b!1378 (= e!778 (bvadd call!238 #b00000000000000000000000000000001))))

(declare-fun bm!238 () Bool)

(assert (=> bm!238 (= call!238 (blackHeight!0 (left!8 (right!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!1379 () Bool)

(assert (=> b!1379 (= e!778 call!238)))

(declare-fun b!1380 () Bool)

(assert (=> b!1380 (= e!777 e!778)))

(declare-fun c!359 () Bool)

(assert (=> b!1380 (= c!359 ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!1381 () Bool)

(assert (=> b!1381 (= e!777 #b00000000000000000000000000000001)))

(assert (= (and d!825 c!358) b!1381))

(assert (= (and d!825 (not c!358)) b!1380))

(assert (= (and b!1380 c!359) b!1378))

(assert (= (and b!1380 (not c!359)) b!1379))

(assert (= (or b!1378 b!1379) bm!238))

(assert (=> bm!238 m!1833))

(assert (=> b!724 d!825))

(declare-fun d!827 () Bool)

(declare-fun c!360 () Bool)

(assert (=> d!827 (= c!360 ((_ is Empty!3) (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun e!779 () (InoxSet (_ BitVec 32)))

(assert (=> d!827 (= (content!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!779)))

(declare-fun b!1382 () Bool)

(assert (=> b!1382 (= e!779 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1383 () Bool)

(assert (=> b!1383 (= e!779 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) true)) (content!0 (right!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!827 c!360) b!1382))

(assert (= (and d!827 (not c!360)) b!1383))

(declare-fun m!1999 () Bool)

(assert (=> b!1383 m!1999))

(declare-fun m!2001 () Bool)

(assert (=> b!1383 m!2001))

(declare-fun m!2003 () Bool)

(assert (=> b!1383 m!2003))

(assert (=> b!731 d!827))

(declare-fun d!829 () Bool)

(declare-fun c!361 () Bool)

(assert (=> d!829 (= c!361 ((_ is Empty!3) (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(declare-fun e!780 () (InoxSet (_ BitVec 32)))

(assert (=> d!829 (= (content!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!780)))

(declare-fun b!1384 () Bool)

(assert (=> b!1384 (= e!780 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1385 () Bool)

(assert (=> b!1385 (= e!780 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) true)) (content!0 (right!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (= (and d!829 c!361) b!1384))

(assert (= (and d!829 (not c!361)) b!1385))

(declare-fun m!2005 () Bool)

(assert (=> b!1385 m!2005))

(declare-fun m!2007 () Bool)

(assert (=> b!1385 m!2007))

(declare-fun m!2009 () Bool)

(assert (=> b!1385 m!2009))

(assert (=> b!731 d!829))

(declare-fun c!362 () Bool)

(declare-fun d!831 () Bool)

(assert (=> d!831 (= c!362 ((_ is Empty!3) (left!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))))))

(declare-fun e!781 () (InoxSet (_ BitVec 32)))

(assert (=> d!831 (= (content!0 (left!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))) e!781)))

(declare-fun b!1386 () Bool)

(assert (=> b!1386 (= e!781 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1387 () Bool)

(assert (=> b!1387 (= e!781 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))) true)) (content!0 (right!8 (left!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))))))))

(assert (= (and d!831 c!362) b!1386))

(assert (= (and d!831 (not c!362)) b!1387))

(declare-fun m!2011 () Bool)

(assert (=> b!1387 m!2011))

(declare-fun m!2013 () Bool)

(assert (=> b!1387 m!2013))

(declare-fun m!2015 () Bool)

(assert (=> b!1387 m!2015))

(assert (=> b!709 d!831))

(declare-fun c!363 () Bool)

(declare-fun d!833 () Bool)

(assert (=> d!833 (= c!363 ((_ is Empty!3) (right!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))))))

(declare-fun e!782 () (InoxSet (_ BitVec 32)))

(assert (=> d!833 (= (content!0 (right!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))) e!782)))

(declare-fun b!1388 () Bool)

(assert (=> b!1388 (= e!782 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1389 () Bool)

(assert (=> b!1389 (= e!782 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))) true)) (content!0 (right!8 (right!8 (Node!3 (color!6 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 call!46 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78)))) (value!38 (ite c!50 (left!8 t!78) (right!8 t!78))) (ite c!62 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))) call!46)))))))))

(assert (= (and d!833 c!363) b!1388))

(assert (= (and d!833 (not c!363)) b!1389))

(declare-fun m!2017 () Bool)

(assert (=> b!1389 m!2017))

(declare-fun m!2019 () Bool)

(assert (=> b!1389 m!2019))

(declare-fun m!2021 () Bool)

(assert (=> b!1389 m!2021))

(assert (=> b!709 d!833))

(declare-fun d!835 () Bool)

(declare-fun c!364 () Bool)

(assert (=> d!835 (= c!364 ((_ is Empty!3) (left!8 (right!8 (left!8 t!78)))))))

(declare-fun e!783 () (_ BitVec 32))

(assert (=> d!835 (= (blackHeight!0 (left!8 (right!8 (left!8 t!78)))) e!783)))

(declare-fun b!1390 () Bool)

(declare-fun e!784 () (_ BitVec 32))

(declare-fun call!239 () (_ BitVec 32))

(assert (=> b!1390 (= e!784 (bvadd call!239 #b00000000000000000000000000000001))))

(declare-fun bm!239 () Bool)

(assert (=> bm!239 (= call!239 (blackHeight!0 (left!8 (left!8 (right!8 (left!8 t!78))))))))

(declare-fun b!1391 () Bool)

(assert (=> b!1391 (= e!784 call!239)))

(declare-fun b!1392 () Bool)

(assert (=> b!1392 (= e!783 e!784)))

(declare-fun c!365 () Bool)

(assert (=> b!1392 (= c!365 ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 t!78))))))))

(declare-fun b!1393 () Bool)

(assert (=> b!1393 (= e!783 #b00000000000000000000000000000001)))

(assert (= (and d!835 c!364) b!1393))

(assert (= (and d!835 (not c!364)) b!1392))

(assert (= (and b!1392 c!365) b!1390))

(assert (= (and b!1392 (not c!365)) b!1391))

(assert (= (or b!1390 b!1391) bm!239))

(assert (=> bm!239 m!1239))

(assert (=> bm!85 d!835))

(declare-fun b!1394 () Bool)

(declare-fun res!742 () Bool)

(declare-fun call!241 () Bool)

(assert (=> b!1394 (= res!742 call!241)))

(declare-fun e!787 () Bool)

(assert (=> b!1394 (=> (not res!742) (not e!787))))

(declare-fun d!837 () Bool)

(declare-fun res!740 () Bool)

(declare-fun e!788 () Bool)

(assert (=> d!837 (=> res!740 e!788)))

(assert (=> d!837 (= res!740 ((_ is Empty!3) (right!8 (right!8 (right!8 (left!8 t!78))))))))

(assert (=> d!837 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (left!8 t!78))))) e!788)))

(declare-fun b!1395 () Bool)

(declare-fun call!240 () Bool)

(assert (=> b!1395 (= e!787 call!240)))

(declare-fun bm!240 () Bool)

(assert (=> bm!240 (= call!241 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (right!8 (left!8 t!78)))))))))

(declare-fun bm!241 () Bool)

(assert (=> bm!241 (= call!240 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (right!8 (left!8 t!78)))))))))

(declare-fun b!1396 () Bool)

(declare-fun res!741 () Bool)

(assert (=> b!1396 (= res!741 (isBlack!0 (right!8 (right!8 (right!8 (right!8 (left!8 t!78)))))))))

(assert (=> b!1396 (=> (not res!741) (not e!787))))

(declare-fun b!1397 () Bool)

(declare-fun e!786 () Bool)

(assert (=> b!1397 (= e!786 call!240)))

(declare-fun b!1398 () Bool)

(declare-fun e!785 () Bool)

(assert (=> b!1398 (= e!785 e!787)))

(declare-fun res!738 () Bool)

(assert (=> b!1398 (= res!738 (isBlack!0 (left!8 (right!8 (right!8 (right!8 (left!8 t!78)))))))))

(assert (=> b!1398 (=> (not res!738) (not e!787))))

(declare-fun b!1399 () Bool)

(assert (=> b!1399 (= e!788 e!785)))

(declare-fun c!366 () Bool)

(assert (=> b!1399 (= c!366 ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 (left!8 t!78)))))))))

(declare-fun b!1400 () Bool)

(assert (=> b!1400 (= e!785 e!786)))

(declare-fun res!739 () Bool)

(assert (=> b!1400 (= res!739 call!241)))

(assert (=> b!1400 (=> (not res!739) (not e!786))))

(assert (= (and d!837 (not res!740)) b!1399))

(assert (= (and b!1399 c!366) b!1400))

(assert (= (and b!1399 (not c!366)) b!1398))

(assert (= (and b!1400 res!739) b!1397))

(assert (= (and b!1398 res!738) b!1396))

(assert (= (and b!1396 res!741) b!1394))

(assert (= (and b!1394 res!742) b!1395))

(assert (= (or b!1400 b!1394) bm!240))

(assert (= (or b!1397 b!1395) bm!241))

(declare-fun m!2023 () Bool)

(assert (=> bm!240 m!2023))

(declare-fun m!2025 () Bool)

(assert (=> bm!241 m!2025))

(declare-fun m!2027 () Bool)

(assert (=> b!1396 m!2027))

(declare-fun m!2029 () Bool)

(assert (=> b!1398 m!2029))

(assert (=> bm!137 d!837))

(declare-fun d!839 () Bool)

(assert (=> d!839 (= (isBlack!0 (left!8 (left!8 lt!13))) (or ((_ is Empty!3) (left!8 (left!8 lt!13))) ((_ is Black!3) (color!6 (left!8 (left!8 lt!13))))))))

(assert (=> b!752 d!839))

(declare-fun d!841 () Bool)

(declare-fun lt!60 () Int)

(assert (=> d!841 (>= lt!60 0)))

(declare-fun e!789 () Int)

(assert (=> d!841 (= lt!60 e!789)))

(declare-fun c!367 () Bool)

(assert (=> d!841 (= c!367 ((_ is Empty!3) (left!8 (left!8 (right!8 t!78)))))))

(assert (=> d!841 (= (size!0 (left!8 (left!8 (right!8 t!78)))) lt!60)))

(declare-fun b!1401 () Bool)

(assert (=> b!1401 (= e!789 0)))

(declare-fun b!1402 () Bool)

(assert (=> b!1402 (= e!789 (+ (size!0 (left!8 (left!8 (left!8 (right!8 t!78))))) 1 (size!0 (right!8 (left!8 (left!8 (right!8 t!78)))))))))

(assert (= (and d!841 c!367) b!1401))

(assert (= (and d!841 (not c!367)) b!1402))

(declare-fun m!2031 () Bool)

(assert (=> b!1402 m!2031))

(declare-fun m!2033 () Bool)

(assert (=> b!1402 m!2033))

(assert (=> b!733 d!841))

(declare-fun d!843 () Bool)

(declare-fun lt!61 () Int)

(assert (=> d!843 (>= lt!61 0)))

(declare-fun e!790 () Int)

(assert (=> d!843 (= lt!61 e!790)))

(declare-fun c!368 () Bool)

(assert (=> d!843 (= c!368 ((_ is Empty!3) (right!8 (left!8 (right!8 t!78)))))))

(assert (=> d!843 (= (size!0 (right!8 (left!8 (right!8 t!78)))) lt!61)))

(declare-fun b!1403 () Bool)

(assert (=> b!1403 (= e!790 0)))

(declare-fun b!1404 () Bool)

(assert (=> b!1404 (= e!790 (+ (size!0 (left!8 (right!8 (left!8 (right!8 t!78))))) 1 (size!0 (right!8 (right!8 (left!8 (right!8 t!78)))))))))

(assert (= (and d!843 c!368) b!1403))

(assert (= (and d!843 (not c!368)) b!1404))

(declare-fun m!2035 () Bool)

(assert (=> b!1404 m!2035))

(declare-fun m!2037 () Bool)

(assert (=> b!1404 m!2037))

(assert (=> b!733 d!843))

(declare-fun d!845 () Bool)

(declare-fun lt!62 () Int)

(assert (=> d!845 (>= lt!62 0)))

(declare-fun e!791 () Int)

(assert (=> d!845 (= lt!62 e!791)))

(declare-fun c!369 () Bool)

(assert (=> d!845 (= c!369 ((_ is Empty!3) (left!8 (left!8 lt!13))))))

(assert (=> d!845 (= (size!0 (left!8 (left!8 lt!13))) lt!62)))

(declare-fun b!1405 () Bool)

(assert (=> b!1405 (= e!791 0)))

(declare-fun b!1406 () Bool)

(assert (=> b!1406 (= e!791 (+ (size!0 (left!8 (left!8 (left!8 lt!13)))) 1 (size!0 (right!8 (left!8 (left!8 lt!13))))))))

(assert (= (and d!845 c!369) b!1405))

(assert (= (and d!845 (not c!369)) b!1406))

(declare-fun m!2039 () Bool)

(assert (=> b!1406 m!2039))

(declare-fun m!2041 () Bool)

(assert (=> b!1406 m!2041))

(assert (=> b!719 d!845))

(declare-fun d!847 () Bool)

(declare-fun lt!63 () Int)

(assert (=> d!847 (>= lt!63 0)))

(declare-fun e!792 () Int)

(assert (=> d!847 (= lt!63 e!792)))

(declare-fun c!370 () Bool)

(assert (=> d!847 (= c!370 ((_ is Empty!3) (right!8 (left!8 lt!13))))))

(assert (=> d!847 (= (size!0 (right!8 (left!8 lt!13))) lt!63)))

(declare-fun b!1407 () Bool)

(assert (=> b!1407 (= e!792 0)))

(declare-fun b!1408 () Bool)

(assert (=> b!1408 (= e!792 (+ (size!0 (left!8 (right!8 (left!8 lt!13)))) 1 (size!0 (right!8 (right!8 (left!8 lt!13))))))))

(assert (= (and d!847 c!370) b!1407))

(assert (= (and d!847 (not c!370)) b!1408))

(declare-fun m!2043 () Bool)

(assert (=> b!1408 m!2043))

(declare-fun m!2045 () Bool)

(assert (=> b!1408 m!2045))

(assert (=> b!719 d!847))

(declare-fun b!1409 () Bool)

(declare-fun res!747 () Bool)

(declare-fun call!243 () Bool)

(assert (=> b!1409 (= res!747 call!243)))

(declare-fun e!795 () Bool)

(assert (=> b!1409 (=> (not res!747) (not e!795))))

(declare-fun d!849 () Bool)

(declare-fun res!745 () Bool)

(declare-fun e!796 () Bool)

(assert (=> d!849 (=> res!745 e!796)))

(assert (=> d!849 (= res!745 ((_ is Empty!3) (left!8 (right!8 (left!8 (left!8 lt!2))))))))

(assert (=> d!849 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (left!8 lt!2))))) e!796)))

(declare-fun b!1410 () Bool)

(declare-fun call!242 () Bool)

(assert (=> b!1410 (= e!795 call!242)))

(declare-fun bm!242 () Bool)

(assert (=> bm!242 (= call!243 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (left!8 (left!8 lt!2)))))))))

(declare-fun bm!243 () Bool)

(assert (=> bm!243 (= call!242 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (left!8 (left!8 lt!2)))))))))

(declare-fun b!1411 () Bool)

(declare-fun res!746 () Bool)

(assert (=> b!1411 (= res!746 (isBlack!0 (right!8 (left!8 (right!8 (left!8 (left!8 lt!2)))))))))

(assert (=> b!1411 (=> (not res!746) (not e!795))))

(declare-fun b!1412 () Bool)

(declare-fun e!794 () Bool)

(assert (=> b!1412 (= e!794 call!242)))

(declare-fun b!1413 () Bool)

(declare-fun e!793 () Bool)

(assert (=> b!1413 (= e!793 e!795)))

(declare-fun res!743 () Bool)

(assert (=> b!1413 (= res!743 (isBlack!0 (left!8 (left!8 (right!8 (left!8 (left!8 lt!2)))))))))

(assert (=> b!1413 (=> (not res!743) (not e!795))))

(declare-fun b!1414 () Bool)

(assert (=> b!1414 (= e!796 e!793)))

(declare-fun c!371 () Bool)

(assert (=> b!1414 (= c!371 ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 (left!8 lt!2)))))))))

(declare-fun b!1415 () Bool)

(assert (=> b!1415 (= e!793 e!794)))

(declare-fun res!744 () Bool)

(assert (=> b!1415 (= res!744 call!243)))

(assert (=> b!1415 (=> (not res!744) (not e!794))))

(assert (= (and d!849 (not res!745)) b!1414))

(assert (= (and b!1414 c!371) b!1415))

(assert (= (and b!1414 (not c!371)) b!1413))

(assert (= (and b!1415 res!744) b!1412))

(assert (= (and b!1413 res!743) b!1411))

(assert (= (and b!1411 res!746) b!1409))

(assert (= (and b!1409 res!747) b!1410))

(assert (= (or b!1415 b!1409) bm!242))

(assert (= (or b!1412 b!1410) bm!243))

(declare-fun m!2047 () Bool)

(assert (=> bm!242 m!2047))

(declare-fun m!2049 () Bool)

(assert (=> bm!243 m!2049))

(declare-fun m!2051 () Bool)

(assert (=> b!1411 m!2051))

(declare-fun m!2053 () Bool)

(assert (=> b!1413 m!2053))

(assert (=> bm!96 d!849))

(assert (=> b!689 d!723))

(declare-fun d!851 () Bool)

(declare-fun c!372 () Bool)

(assert (=> d!851 (= c!372 ((_ is Empty!3) (right!8 (right!8 lt!13))))))

(declare-fun e!797 () (_ BitVec 32))

(assert (=> d!851 (= (blackHeight!0 (right!8 (right!8 lt!13))) e!797)))

(declare-fun b!1416 () Bool)

(declare-fun e!798 () (_ BitVec 32))

(declare-fun call!244 () (_ BitVec 32))

(assert (=> b!1416 (= e!798 (bvadd call!244 #b00000000000000000000000000000001))))

(declare-fun bm!244 () Bool)

(assert (=> bm!244 (= call!244 (blackHeight!0 (left!8 (right!8 (right!8 lt!13)))))))

(declare-fun b!1417 () Bool)

(assert (=> b!1417 (= e!798 call!244)))

(declare-fun b!1418 () Bool)

(assert (=> b!1418 (= e!797 e!798)))

(declare-fun c!373 () Bool)

(assert (=> b!1418 (= c!373 ((_ is Black!3) (color!6 (right!8 (right!8 lt!13)))))))

(declare-fun b!1419 () Bool)

(assert (=> b!1419 (= e!797 #b00000000000000000000000000000001)))

(assert (= (and d!851 c!372) b!1419))

(assert (= (and d!851 (not c!372)) b!1418))

(assert (= (and b!1418 c!373) b!1416))

(assert (= (and b!1418 (not c!373)) b!1417))

(assert (= (or b!1416 b!1417) bm!244))

(assert (=> bm!244 m!1937))

(assert (=> b!689 d!851))

(declare-fun d!853 () Bool)

(assert (=> d!853 (= (isBlack!0 (right!8 (left!8 (left!8 (left!8 t!78))))) (or ((_ is Empty!3) (right!8 (left!8 (left!8 (left!8 t!78))))) ((_ is Black!3) (color!6 (right!8 (left!8 (left!8 (left!8 t!78))))))))))

(assert (=> b!816 d!853))

(declare-fun b!1420 () Bool)

(declare-fun res!752 () Bool)

(declare-fun call!246 () Bool)

(assert (=> b!1420 (= res!752 call!246)))

(declare-fun e!801 () Bool)

(assert (=> b!1420 (=> (not res!752) (not e!801))))

(declare-fun d!855 () Bool)

(declare-fun res!750 () Bool)

(declare-fun e!802 () Bool)

(assert (=> d!855 (=> res!750 e!802)))

(assert (=> d!855 (= res!750 ((_ is Empty!3) (left!8 (left!8 (left!8 (left!8 lt!2))))))))

(assert (=> d!855 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (left!8 lt!2))))) e!802)))

(declare-fun b!1421 () Bool)

(declare-fun call!245 () Bool)

(assert (=> b!1421 (= e!801 call!245)))

(declare-fun bm!245 () Bool)

(assert (=> bm!245 (= call!246 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (left!8 (left!8 lt!2)))))))))

(declare-fun bm!246 () Bool)

(assert (=> bm!246 (= call!245 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (left!8 (left!8 lt!2)))))))))

(declare-fun b!1422 () Bool)

(declare-fun res!751 () Bool)

(assert (=> b!1422 (= res!751 (isBlack!0 (right!8 (left!8 (left!8 (left!8 (left!8 lt!2)))))))))

(assert (=> b!1422 (=> (not res!751) (not e!801))))

(declare-fun b!1423 () Bool)

(declare-fun e!800 () Bool)

(assert (=> b!1423 (= e!800 call!245)))

(declare-fun b!1424 () Bool)

(declare-fun e!799 () Bool)

(assert (=> b!1424 (= e!799 e!801)))

(declare-fun res!748 () Bool)

(assert (=> b!1424 (= res!748 (isBlack!0 (left!8 (left!8 (left!8 (left!8 (left!8 lt!2)))))))))

(assert (=> b!1424 (=> (not res!748) (not e!801))))

(declare-fun b!1425 () Bool)

(assert (=> b!1425 (= e!802 e!799)))

(declare-fun c!374 () Bool)

(assert (=> b!1425 (= c!374 ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 (left!8 lt!2)))))))))

(declare-fun b!1426 () Bool)

(assert (=> b!1426 (= e!799 e!800)))

(declare-fun res!749 () Bool)

(assert (=> b!1426 (= res!749 call!246)))

(assert (=> b!1426 (=> (not res!749) (not e!800))))

(assert (= (and d!855 (not res!750)) b!1425))

(assert (= (and b!1425 c!374) b!1426))

(assert (= (and b!1425 (not c!374)) b!1424))

(assert (= (and b!1426 res!749) b!1423))

(assert (= (and b!1424 res!748) b!1422))

(assert (= (and b!1422 res!751) b!1420))

(assert (= (and b!1420 res!752) b!1421))

(assert (= (or b!1426 b!1420) bm!245))

(assert (= (or b!1423 b!1421) bm!246))

(declare-fun m!2055 () Bool)

(assert (=> bm!245 m!2055))

(declare-fun m!2057 () Bool)

(assert (=> bm!246 m!2057))

(declare-fun m!2059 () Bool)

(assert (=> b!1422 m!2059))

(declare-fun m!2061 () Bool)

(assert (=> b!1424 m!2061))

(assert (=> bm!80 d!855))

(declare-fun d!857 () Bool)

(declare-fun c!375 () Bool)

(assert (=> d!857 (= c!375 ((_ is Empty!3) (left!8 (left!8 (right!8 (right!8 lt!2))))))))

(declare-fun e!803 () (InoxSet (_ BitVec 32)))

(assert (=> d!857 (= (content!0 (left!8 (left!8 (right!8 (right!8 lt!2))))) e!803)))

(declare-fun b!1427 () Bool)

(assert (=> b!1427 (= e!803 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1428 () Bool)

(assert (=> b!1428 (= e!803 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (right!8 (right!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (right!8 (right!8 lt!2))))) true)) (content!0 (right!8 (left!8 (left!8 (right!8 (right!8 lt!2))))))))))

(assert (= (and d!857 c!375) b!1427))

(assert (= (and d!857 (not c!375)) b!1428))

(declare-fun m!2063 () Bool)

(assert (=> b!1428 m!2063))

(declare-fun m!2065 () Bool)

(assert (=> b!1428 m!2065))

(declare-fun m!2067 () Bool)

(assert (=> b!1428 m!2067))

(assert (=> b!826 d!857))

(declare-fun d!859 () Bool)

(declare-fun c!376 () Bool)

(assert (=> d!859 (= c!376 ((_ is Empty!3) (right!8 (left!8 (right!8 (right!8 lt!2))))))))

(declare-fun e!804 () (InoxSet (_ BitVec 32)))

(assert (=> d!859 (= (content!0 (right!8 (left!8 (right!8 (right!8 lt!2))))) e!804)))

(declare-fun b!1429 () Bool)

(assert (=> b!1429 (= e!804 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1430 () Bool)

(assert (=> b!1430 (= e!804 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (right!8 (right!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (right!8 (right!8 lt!2))))) true)) (content!0 (right!8 (right!8 (left!8 (right!8 (right!8 lt!2))))))))))

(assert (= (and d!859 c!376) b!1429))

(assert (= (and d!859 (not c!376)) b!1430))

(declare-fun m!2069 () Bool)

(assert (=> b!1430 m!2069))

(declare-fun m!2071 () Bool)

(assert (=> b!1430 m!2071))

(declare-fun m!2073 () Bool)

(assert (=> b!1430 m!2073))

(assert (=> b!826 d!859))

(declare-fun d!861 () Bool)

(declare-fun lt!64 () Int)

(assert (=> d!861 (>= lt!64 0)))

(declare-fun e!805 () Int)

(assert (=> d!861 (= lt!64 e!805)))

(declare-fun c!377 () Bool)

(assert (=> d!861 (= c!377 ((_ is Empty!3) (left!8 (right!8 (left!8 lt!5)))))))

(assert (=> d!861 (= (size!0 (left!8 (right!8 (left!8 lt!5)))) lt!64)))

(declare-fun b!1431 () Bool)

(assert (=> b!1431 (= e!805 0)))

(declare-fun b!1432 () Bool)

(assert (=> b!1432 (= e!805 (+ (size!0 (left!8 (left!8 (right!8 (left!8 lt!5))))) 1 (size!0 (right!8 (left!8 (right!8 (left!8 lt!5)))))))))

(assert (= (and d!861 c!377) b!1431))

(assert (= (and d!861 (not c!377)) b!1432))

(declare-fun m!2075 () Bool)

(assert (=> b!1432 m!2075))

(declare-fun m!2077 () Bool)

(assert (=> b!1432 m!2077))

(assert (=> b!637 d!861))

(declare-fun d!863 () Bool)

(declare-fun lt!65 () Int)

(assert (=> d!863 (>= lt!65 0)))

(declare-fun e!806 () Int)

(assert (=> d!863 (= lt!65 e!806)))

(declare-fun c!378 () Bool)

(assert (=> d!863 (= c!378 ((_ is Empty!3) (right!8 (right!8 (left!8 lt!5)))))))

(assert (=> d!863 (= (size!0 (right!8 (right!8 (left!8 lt!5)))) lt!65)))

(declare-fun b!1433 () Bool)

(assert (=> b!1433 (= e!806 0)))

(declare-fun b!1434 () Bool)

(assert (=> b!1434 (= e!806 (+ (size!0 (left!8 (right!8 (right!8 (left!8 lt!5))))) 1 (size!0 (right!8 (right!8 (right!8 (left!8 lt!5)))))))))

(assert (= (and d!863 c!378) b!1433))

(assert (= (and d!863 (not c!378)) b!1434))

(declare-fun m!2079 () Bool)

(assert (=> b!1434 m!2079))

(declare-fun m!2081 () Bool)

(assert (=> b!1434 m!2081))

(assert (=> b!637 d!863))

(declare-fun d!865 () Bool)

(assert (=> d!865 (= (isBlack!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (or ((_ is Empty!3) (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) ((_ is Black!3) (color!6 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> b!653 d!865))

(declare-fun b!1435 () Bool)

(declare-fun res!757 () Bool)

(declare-fun call!248 () Bool)

(assert (=> b!1435 (= res!757 call!248)))

(declare-fun e!809 () Bool)

(assert (=> b!1435 (=> (not res!757) (not e!809))))

(declare-fun d!867 () Bool)

(declare-fun res!755 () Bool)

(declare-fun e!810 () Bool)

(assert (=> d!867 (=> res!755 e!810)))

(assert (=> d!867 (= res!755 ((_ is Empty!3) (left!8 (left!8 (left!8 (right!8 t!78))))))))

(assert (=> d!867 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (right!8 t!78))))) e!810)))

(declare-fun b!1436 () Bool)

(declare-fun call!247 () Bool)

(assert (=> b!1436 (= e!809 call!247)))

(declare-fun bm!247 () Bool)

(assert (=> bm!247 (= call!248 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (left!8 (right!8 t!78)))))))))

(declare-fun bm!248 () Bool)

(assert (=> bm!248 (= call!247 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (left!8 (right!8 t!78)))))))))

(declare-fun b!1437 () Bool)

(declare-fun res!756 () Bool)

(assert (=> b!1437 (= res!756 (isBlack!0 (right!8 (left!8 (left!8 (left!8 (right!8 t!78)))))))))

(assert (=> b!1437 (=> (not res!756) (not e!809))))

(declare-fun b!1438 () Bool)

(declare-fun e!808 () Bool)

(assert (=> b!1438 (= e!808 call!247)))

(declare-fun b!1439 () Bool)

(declare-fun e!807 () Bool)

(assert (=> b!1439 (= e!807 e!809)))

(declare-fun res!753 () Bool)

(assert (=> b!1439 (= res!753 (isBlack!0 (left!8 (left!8 (left!8 (left!8 (right!8 t!78)))))))))

(assert (=> b!1439 (=> (not res!753) (not e!809))))

(declare-fun b!1440 () Bool)

(assert (=> b!1440 (= e!810 e!807)))

(declare-fun c!379 () Bool)

(assert (=> b!1440 (= c!379 ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 (right!8 t!78)))))))))

(declare-fun b!1441 () Bool)

(assert (=> b!1441 (= e!807 e!808)))

(declare-fun res!754 () Bool)

(assert (=> b!1441 (= res!754 call!248)))

(assert (=> b!1441 (=> (not res!754) (not e!808))))

(assert (= (and d!867 (not res!755)) b!1440))

(assert (= (and b!1440 c!379) b!1441))

(assert (= (and b!1440 (not c!379)) b!1439))

(assert (= (and b!1441 res!754) b!1438))

(assert (= (and b!1439 res!753) b!1437))

(assert (= (and b!1437 res!756) b!1435))

(assert (= (and b!1435 res!757) b!1436))

(assert (= (or b!1441 b!1435) bm!247))

(assert (= (or b!1438 b!1436) bm!248))

(declare-fun m!2083 () Bool)

(assert (=> bm!247 m!2083))

(declare-fun m!2085 () Bool)

(assert (=> bm!248 m!2085))

(declare-fun m!2087 () Bool)

(assert (=> b!1437 m!2087))

(declare-fun m!2089 () Bool)

(assert (=> b!1439 m!2089))

(assert (=> bm!124 d!867))

(declare-fun b!1442 () Bool)

(declare-fun res!762 () Bool)

(declare-fun call!250 () Bool)

(assert (=> b!1442 (= res!762 call!250)))

(declare-fun e!813 () Bool)

(assert (=> b!1442 (=> (not res!762) (not e!813))))

(declare-fun d!869 () Bool)

(declare-fun res!760 () Bool)

(declare-fun e!814 () Bool)

(assert (=> d!869 (=> res!760 e!814)))

(assert (=> d!869 (= res!760 ((_ is Empty!3) (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!869 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!814)))

(declare-fun b!1443 () Bool)

(declare-fun call!249 () Bool)

(assert (=> b!1443 (= e!813 call!249)))

(declare-fun bm!249 () Bool)

(assert (=> bm!249 (= call!250 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun bm!250 () Bool)

(assert (=> bm!250 (= call!249 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1444 () Bool)

(declare-fun res!761 () Bool)

(assert (=> b!1444 (= res!761 (isBlack!0 (right!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!1444 (=> (not res!761) (not e!813))))

(declare-fun b!1445 () Bool)

(declare-fun e!812 () Bool)

(assert (=> b!1445 (= e!812 call!249)))

(declare-fun b!1446 () Bool)

(declare-fun e!811 () Bool)

(assert (=> b!1446 (= e!811 e!813)))

(declare-fun res!758 () Bool)

(assert (=> b!1446 (= res!758 (isBlack!0 (left!8 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!1446 (=> (not res!758) (not e!813))))

(declare-fun b!1447 () Bool)

(assert (=> b!1447 (= e!814 e!811)))

(declare-fun c!380 () Bool)

(assert (=> b!1447 (= c!380 ((_ is Black!3) (color!6 (left!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1448 () Bool)

(assert (=> b!1448 (= e!811 e!812)))

(declare-fun res!759 () Bool)

(assert (=> b!1448 (= res!759 call!250)))

(assert (=> b!1448 (=> (not res!759) (not e!812))))

(assert (= (and d!869 (not res!760)) b!1447))

(assert (= (and b!1447 c!380) b!1448))

(assert (= (and b!1447 (not c!380)) b!1446))

(assert (= (and b!1448 res!759) b!1445))

(assert (= (and b!1446 res!758) b!1444))

(assert (= (and b!1444 res!761) b!1442))

(assert (= (and b!1442 res!762) b!1443))

(assert (= (or b!1448 b!1442) bm!249))

(assert (= (or b!1445 b!1443) bm!250))

(declare-fun m!2091 () Bool)

(assert (=> bm!249 m!2091))

(declare-fun m!2093 () Bool)

(assert (=> bm!250 m!2093))

(declare-fun m!2095 () Bool)

(assert (=> b!1444 m!2095))

(declare-fun m!2097 () Bool)

(assert (=> b!1446 m!2097))

(assert (=> bm!114 d!869))

(declare-fun d!871 () Bool)

(declare-fun c!381 () Bool)

(assert (=> d!871 (= c!381 ((_ is Empty!3) (left!8 (right!8 (left!8 (right!8 lt!2))))))))

(declare-fun e!815 () (InoxSet (_ BitVec 32)))

(assert (=> d!871 (= (content!0 (left!8 (right!8 (left!8 (right!8 lt!2))))) e!815)))

(declare-fun b!1449 () Bool)

(assert (=> b!1449 (= e!815 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1450 () Bool)

(assert (=> b!1450 (= e!815 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (left!8 (right!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (left!8 (right!8 lt!2))))) true)) (content!0 (right!8 (left!8 (right!8 (left!8 (right!8 lt!2))))))))))

(assert (= (and d!871 c!381) b!1449))

(assert (= (and d!871 (not c!381)) b!1450))

(declare-fun m!2099 () Bool)

(assert (=> b!1450 m!2099))

(declare-fun m!2101 () Bool)

(assert (=> b!1450 m!2101))

(declare-fun m!2103 () Bool)

(assert (=> b!1450 m!2103))

(assert (=> b!513 d!871))

(declare-fun d!873 () Bool)

(declare-fun c!382 () Bool)

(assert (=> d!873 (= c!382 ((_ is Empty!3) (right!8 (right!8 (left!8 (right!8 lt!2))))))))

(declare-fun e!816 () (InoxSet (_ BitVec 32)))

(assert (=> d!873 (= (content!0 (right!8 (right!8 (left!8 (right!8 lt!2))))) e!816)))

(declare-fun b!1451 () Bool)

(assert (=> b!1451 (= e!816 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1452 () Bool)

(assert (=> b!1452 (= e!816 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (left!8 (right!8 lt!2)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (left!8 (right!8 lt!2))))) true)) (content!0 (right!8 (right!8 (right!8 (left!8 (right!8 lt!2))))))))))

(assert (= (and d!873 c!382) b!1451))

(assert (= (and d!873 (not c!382)) b!1452))

(declare-fun m!2105 () Bool)

(assert (=> b!1452 m!2105))

(declare-fun m!2107 () Bool)

(assert (=> b!1452 m!2107))

(declare-fun m!2109 () Bool)

(assert (=> b!1452 m!2109))

(assert (=> b!513 d!873))

(declare-fun d!875 () Bool)

(declare-fun res!763 () Bool)

(declare-fun e!817 () Bool)

(assert (=> d!875 (=> res!763 e!817)))

(assert (=> d!875 (= res!763 (not ((_ is Node!3) (left!8 (left!8 lt!13)))))))

(assert (=> d!875 (= (blackBalanced!0 (left!8 (left!8 lt!13))) e!817)))

(declare-fun b!1453 () Bool)

(declare-fun e!818 () Bool)

(assert (=> b!1453 (= e!817 e!818)))

(declare-fun res!765 () Bool)

(assert (=> b!1453 (=> (not res!765) (not e!818))))

(assert (=> b!1453 (= res!765 (blackBalanced!0 (left!8 (left!8 (left!8 lt!13)))))))

(declare-fun b!1454 () Bool)

(declare-fun res!764 () Bool)

(assert (=> b!1454 (=> (not res!764) (not e!818))))

(assert (=> b!1454 (= res!764 (blackBalanced!0 (right!8 (left!8 (left!8 lt!13)))))))

(declare-fun b!1455 () Bool)

(assert (=> b!1455 (= e!818 (= (blackHeight!0 (left!8 (left!8 (left!8 lt!13)))) (blackHeight!0 (right!8 (left!8 (left!8 lt!13))))))))

(assert (= (and d!875 (not res!763)) b!1453))

(assert (= (and b!1453 res!765) b!1454))

(assert (= (and b!1454 res!764) b!1455))

(declare-fun m!2111 () Bool)

(assert (=> b!1453 m!2111))

(declare-fun m!2113 () Bool)

(assert (=> b!1454 m!2113))

(assert (=> b!1455 m!1815))

(declare-fun m!2115 () Bool)

(assert (=> b!1455 m!2115))

(assert (=> b!608 d!875))

(declare-fun d!877 () Bool)

(declare-fun c!383 () Bool)

(assert (=> d!877 (= c!383 ((_ is Empty!3) (left!8 (right!8 (right!8 (left!8 t!78))))))))

(declare-fun e!819 () (InoxSet (_ BitVec 32)))

(assert (=> d!877 (= (content!0 (left!8 (right!8 (right!8 (left!8 t!78))))) e!819)))

(declare-fun b!1456 () Bool)

(assert (=> b!1456 (= e!819 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1457 () Bool)

(assert (=> b!1457 (= e!819 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (right!8 (left!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (right!8 (left!8 t!78))))) true)) (content!0 (right!8 (left!8 (right!8 (right!8 (left!8 t!78))))))))))

(assert (= (and d!877 c!383) b!1456))

(assert (= (and d!877 (not c!383)) b!1457))

(declare-fun m!2117 () Bool)

(assert (=> b!1457 m!2117))

(declare-fun m!2119 () Bool)

(assert (=> b!1457 m!2119))

(declare-fun m!2121 () Bool)

(assert (=> b!1457 m!2121))

(assert (=> b!824 d!877))

(declare-fun d!879 () Bool)

(declare-fun c!384 () Bool)

(assert (=> d!879 (= c!384 ((_ is Empty!3) (right!8 (right!8 (right!8 (left!8 t!78))))))))

(declare-fun e!820 () (InoxSet (_ BitVec 32)))

(assert (=> d!879 (= (content!0 (right!8 (right!8 (right!8 (left!8 t!78))))) e!820)))

(declare-fun b!1458 () Bool)

(assert (=> b!1458 (= e!820 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1459 () Bool)

(assert (=> b!1459 (= e!820 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (right!8 (left!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (right!8 (left!8 t!78))))) true)) (content!0 (right!8 (right!8 (right!8 (right!8 (left!8 t!78))))))))))

(assert (= (and d!879 c!384) b!1458))

(assert (= (and d!879 (not c!384)) b!1459))

(declare-fun m!2123 () Bool)

(assert (=> b!1459 m!2123))

(declare-fun m!2125 () Bool)

(assert (=> b!1459 m!2125))

(declare-fun m!2127 () Bool)

(assert (=> b!1459 m!2127))

(assert (=> b!824 d!879))

(declare-fun d!881 () Bool)

(assert (=> d!881 (= (isBlack!0 (right!8 (right!8 lt!13))) (or ((_ is Empty!3) (right!8 (right!8 lt!13))) ((_ is Black!3) (color!6 (right!8 (right!8 lt!13))))))))

(assert (=> b!482 d!881))

(declare-fun d!883 () Bool)

(declare-fun c!385 () Bool)

(assert (=> d!883 (= c!385 ((_ is Empty!3) (left!8 (right!8 lt!13))))))

(declare-fun e!821 () (InoxSet (_ BitVec 32)))

(assert (=> d!883 (= (content!0 (left!8 (right!8 lt!13))) e!821)))

(declare-fun b!1460 () Bool)

(assert (=> b!1460 (= e!821 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1461 () Bool)

(assert (=> b!1461 (= e!821 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 lt!13)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 lt!13))) true)) (content!0 (right!8 (left!8 (right!8 lt!13))))))))

(assert (= (and d!883 c!385) b!1460))

(assert (= (and d!883 (not c!385)) b!1461))

(declare-fun m!2129 () Bool)

(assert (=> b!1461 m!2129))

(declare-fun m!2131 () Bool)

(assert (=> b!1461 m!2131))

(declare-fun m!2133 () Bool)

(assert (=> b!1461 m!2133))

(assert (=> b!799 d!883))

(declare-fun d!885 () Bool)

(declare-fun c!386 () Bool)

(assert (=> d!885 (= c!386 ((_ is Empty!3) (right!8 (right!8 lt!13))))))

(declare-fun e!822 () (InoxSet (_ BitVec 32)))

(assert (=> d!885 (= (content!0 (right!8 (right!8 lt!13))) e!822)))

(declare-fun b!1462 () Bool)

(assert (=> b!1462 (= e!822 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1463 () Bool)

(assert (=> b!1463 (= e!822 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 lt!13)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 lt!13))) true)) (content!0 (right!8 (right!8 (right!8 lt!13))))))))

(assert (= (and d!885 c!386) b!1462))

(assert (= (and d!885 (not c!386)) b!1463))

(declare-fun m!2135 () Bool)

(assert (=> b!1463 m!2135))

(declare-fun m!2137 () Bool)

(assert (=> b!1463 m!2137))

(declare-fun m!2139 () Bool)

(assert (=> b!1463 m!2139))

(assert (=> b!799 d!885))

(declare-fun b!1464 () Bool)

(declare-fun res!770 () Bool)

(declare-fun call!252 () Bool)

(assert (=> b!1464 (= res!770 call!252)))

(declare-fun e!825 () Bool)

(assert (=> b!1464 (=> (not res!770) (not e!825))))

(declare-fun d!887 () Bool)

(declare-fun res!768 () Bool)

(declare-fun e!826 () Bool)

(assert (=> d!887 (=> res!768 e!826)))

(assert (=> d!887 (= res!768 ((_ is Empty!3) (left!8 (right!8 (left!8 (right!8 lt!2))))))))

(assert (=> d!887 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 (right!8 lt!2))))) e!826)))

(declare-fun b!1465 () Bool)

(declare-fun call!251 () Bool)

(assert (=> b!1465 (= e!825 call!251)))

(declare-fun bm!251 () Bool)

(assert (=> bm!251 (= call!252 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (left!8 (right!8 lt!2)))))))))

(declare-fun bm!252 () Bool)

(assert (=> bm!252 (= call!251 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (left!8 (right!8 lt!2)))))))))

(declare-fun b!1466 () Bool)

(declare-fun res!769 () Bool)

(assert (=> b!1466 (= res!769 (isBlack!0 (right!8 (left!8 (right!8 (left!8 (right!8 lt!2)))))))))

(assert (=> b!1466 (=> (not res!769) (not e!825))))

(declare-fun b!1467 () Bool)

(declare-fun e!824 () Bool)

(assert (=> b!1467 (= e!824 call!251)))

(declare-fun b!1468 () Bool)

(declare-fun e!823 () Bool)

(assert (=> b!1468 (= e!823 e!825)))

(declare-fun res!766 () Bool)

(assert (=> b!1468 (= res!766 (isBlack!0 (left!8 (left!8 (right!8 (left!8 (right!8 lt!2)))))))))

(assert (=> b!1468 (=> (not res!766) (not e!825))))

(declare-fun b!1469 () Bool)

(assert (=> b!1469 (= e!826 e!823)))

(declare-fun c!387 () Bool)

(assert (=> b!1469 (= c!387 ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 (right!8 lt!2)))))))))

(declare-fun b!1470 () Bool)

(assert (=> b!1470 (= e!823 e!824)))

(declare-fun res!767 () Bool)

(assert (=> b!1470 (= res!767 call!252)))

(assert (=> b!1470 (=> (not res!767) (not e!824))))

(assert (= (and d!887 (not res!768)) b!1469))

(assert (= (and b!1469 c!387) b!1470))

(assert (= (and b!1469 (not c!387)) b!1468))

(assert (= (and b!1470 res!767) b!1467))

(assert (= (and b!1468 res!766) b!1466))

(assert (= (and b!1466 res!769) b!1464))

(assert (= (and b!1464 res!770) b!1465))

(assert (= (or b!1470 b!1464) bm!251))

(assert (= (or b!1467 b!1465) bm!252))

(declare-fun m!2141 () Bool)

(assert (=> bm!251 m!2141))

(declare-fun m!2143 () Bool)

(assert (=> bm!252 m!2143))

(declare-fun m!2145 () Bool)

(assert (=> b!1466 m!2145))

(declare-fun m!2147 () Bool)

(assert (=> b!1468 m!2147))

(assert (=> bm!132 d!887))

(declare-fun d!889 () Bool)

(assert (=> d!889 (= (isBlack!0 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (or ((_ is Empty!3) (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) ((_ is Black!3) (color!6 (right!8 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> b!559 d!889))

(declare-fun d!891 () Bool)

(declare-fun c!388 () Bool)

(assert (=> d!891 (= c!388 ((_ is Empty!3) lt!37))))

(declare-fun e!827 () (InoxSet (_ BitVec 32)))

(assert (=> d!891 (= (content!0 lt!37) e!827)))

(declare-fun b!1471 () Bool)

(assert (=> b!1471 (= e!827 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1472 () Bool)

(assert (=> b!1472 (= e!827 ((_ map or) ((_ map or) (content!0 (left!8 lt!37)) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 lt!37) true)) (content!0 (right!8 lt!37))))))

(assert (= (and d!891 c!388) b!1471))

(assert (= (and d!891 (not c!388)) b!1472))

(declare-fun m!2149 () Bool)

(assert (=> b!1472 m!2149))

(declare-fun m!2151 () Bool)

(assert (=> b!1472 m!2151))

(declare-fun m!2153 () Bool)

(assert (=> b!1472 m!2153))

(assert (=> d!423 d!891))

(declare-fun d!893 () Bool)

(declare-fun c!389 () Bool)

(assert (=> d!893 (= c!389 ((_ is Empty!3) (Node!3 (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))))))

(declare-fun e!828 () (InoxSet (_ BitVec 32)))

(assert (=> d!893 (= (content!0 (Node!3 (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) e!828)))

(declare-fun b!1473 () Bool)

(assert (=> b!1473 (= e!828 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1474 () Bool)

(assert (=> b!1474 (= e!828 ((_ map or) ((_ map or) (content!0 (left!8 (Node!3 (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (Node!3 (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))) true)) (content!0 (right!8 (Node!3 (color!6 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 call!58 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) (value!38 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (ite c!92 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) call!58))))))))

(assert (= (and d!893 c!389) b!1473))

(assert (= (and d!893 (not c!389)) b!1474))

(declare-fun m!2155 () Bool)

(assert (=> b!1474 m!2155))

(declare-fun m!2157 () Bool)

(assert (=> b!1474 m!2157))

(declare-fun m!2159 () Bool)

(assert (=> b!1474 m!2159))

(assert (=> d!423 d!893))

(declare-fun d!895 () Bool)

(declare-fun res!771 () Bool)

(declare-fun e!829 () Bool)

(assert (=> d!895 (=> res!771 e!829)))

(assert (=> d!895 (= res!771 (not ((_ is Node!3) (left!8 lt!19))))))

(assert (=> d!895 (= (blackBalanced!0 (left!8 lt!19)) e!829)))

(declare-fun b!1475 () Bool)

(declare-fun e!830 () Bool)

(assert (=> b!1475 (= e!829 e!830)))

(declare-fun res!773 () Bool)

(assert (=> b!1475 (=> (not res!773) (not e!830))))

(assert (=> b!1475 (= res!773 (blackBalanced!0 (left!8 (left!8 lt!19))))))

(declare-fun b!1476 () Bool)

(declare-fun res!772 () Bool)

(assert (=> b!1476 (=> (not res!772) (not e!830))))

(assert (=> b!1476 (= res!772 (blackBalanced!0 (right!8 (left!8 lt!19))))))

(declare-fun b!1477 () Bool)

(assert (=> b!1477 (= e!830 (= (blackHeight!0 (left!8 (left!8 lt!19))) (blackHeight!0 (right!8 (left!8 lt!19)))))))

(assert (= (and d!895 (not res!771)) b!1475))

(assert (= (and b!1475 res!773) b!1476))

(assert (= (and b!1476 res!772) b!1477))

(declare-fun m!2161 () Bool)

(assert (=> b!1475 m!2161))

(declare-fun m!2163 () Bool)

(assert (=> b!1476 m!2163))

(assert (=> b!1477 m!1861))

(declare-fun m!2165 () Bool)

(assert (=> b!1477 m!2165))

(assert (=> b!725 d!895))

(assert (=> b!757 d!835))

(declare-fun d!897 () Bool)

(declare-fun c!390 () Bool)

(assert (=> d!897 (= c!390 ((_ is Empty!3) (right!8 (right!8 (left!8 t!78)))))))

(declare-fun e!831 () (_ BitVec 32))

(assert (=> d!897 (= (blackHeight!0 (right!8 (right!8 (left!8 t!78)))) e!831)))

(declare-fun b!1478 () Bool)

(declare-fun e!832 () (_ BitVec 32))

(declare-fun call!253 () (_ BitVec 32))

(assert (=> b!1478 (= e!832 (bvadd call!253 #b00000000000000000000000000000001))))

(declare-fun bm!253 () Bool)

(assert (=> bm!253 (= call!253 (blackHeight!0 (left!8 (right!8 (right!8 (left!8 t!78))))))))

(declare-fun b!1479 () Bool)

(assert (=> b!1479 (= e!832 call!253)))

(declare-fun b!1480 () Bool)

(assert (=> b!1480 (= e!831 e!832)))

(declare-fun c!391 () Bool)

(assert (=> b!1480 (= c!391 ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 t!78))))))))

(declare-fun b!1481 () Bool)

(assert (=> b!1481 (= e!831 #b00000000000000000000000000000001)))

(assert (= (and d!897 c!390) b!1481))

(assert (= (and d!897 (not c!390)) b!1480))

(assert (= (and b!1480 c!391) b!1478))

(assert (= (and b!1480 (not c!391)) b!1479))

(assert (= (or b!1478 b!1479) bm!253))

(assert (=> bm!253 m!1403))

(assert (=> b!757 d!897))

(declare-fun d!899 () Bool)

(declare-fun c!392 () Bool)

(assert (=> d!899 (= c!392 ((_ is Empty!3) (left!8 (left!8 (right!8 (right!8 t!78))))))))

(declare-fun e!833 () (InoxSet (_ BitVec 32)))

(assert (=> d!899 (= (content!0 (left!8 (left!8 (right!8 (right!8 t!78))))) e!833)))

(declare-fun b!1482 () Bool)

(assert (=> b!1482 (= e!833 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1483 () Bool)

(assert (=> b!1483 (= e!833 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 (right!8 (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 (right!8 (right!8 t!78))))) true)) (content!0 (right!8 (left!8 (left!8 (right!8 (right!8 t!78))))))))))

(assert (= (and d!899 c!392) b!1482))

(assert (= (and d!899 (not c!392)) b!1483))

(declare-fun m!2167 () Bool)

(assert (=> b!1483 m!2167))

(declare-fun m!2169 () Bool)

(assert (=> b!1483 m!2169))

(declare-fun m!2171 () Bool)

(assert (=> b!1483 m!2171))

(assert (=> b!811 d!899))

(declare-fun d!901 () Bool)

(declare-fun c!393 () Bool)

(assert (=> d!901 (= c!393 ((_ is Empty!3) (right!8 (left!8 (right!8 (right!8 t!78))))))))

(declare-fun e!834 () (InoxSet (_ BitVec 32)))

(assert (=> d!901 (= (content!0 (right!8 (left!8 (right!8 (right!8 t!78))))) e!834)))

(declare-fun b!1484 () Bool)

(assert (=> b!1484 (= e!834 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1485 () Bool)

(assert (=> b!1485 (= e!834 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 (right!8 (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 (right!8 (right!8 t!78))))) true)) (content!0 (right!8 (right!8 (left!8 (right!8 (right!8 t!78))))))))))

(assert (= (and d!901 c!393) b!1484))

(assert (= (and d!901 (not c!393)) b!1485))

(declare-fun m!2173 () Bool)

(assert (=> b!1485 m!2173))

(declare-fun m!2175 () Bool)

(assert (=> b!1485 m!2175))

(declare-fun m!2177 () Bool)

(assert (=> b!1485 m!2177))

(assert (=> b!811 d!901))

(declare-fun d!903 () Bool)

(declare-fun res!774 () Bool)

(declare-fun e!835 () Bool)

(assert (=> d!903 (=> res!774 e!835)))

(assert (=> d!903 (= res!774 (not ((_ is Node!3) lt!28)))))

(assert (=> d!903 (= (blackBalanced!0 lt!28) e!835)))

(declare-fun b!1486 () Bool)

(declare-fun e!836 () Bool)

(assert (=> b!1486 (= e!835 e!836)))

(declare-fun res!776 () Bool)

(assert (=> b!1486 (=> (not res!776) (not e!836))))

(assert (=> b!1486 (= res!776 (blackBalanced!0 (left!8 lt!28)))))

(declare-fun b!1487 () Bool)

(declare-fun res!775 () Bool)

(assert (=> b!1487 (=> (not res!775) (not e!836))))

(assert (=> b!1487 (= res!775 (blackBalanced!0 (right!8 lt!28)))))

(declare-fun b!1488 () Bool)

(assert (=> b!1488 (= e!836 (= (blackHeight!0 (left!8 lt!28)) (blackHeight!0 (right!8 lt!28))))))

(assert (= (and d!903 (not res!774)) b!1486))

(assert (= (and b!1486 res!776) b!1487))

(assert (= (and b!1487 res!775) b!1488))

(declare-fun m!2179 () Bool)

(assert (=> b!1486 m!2179))

(declare-fun m!2181 () Bool)

(assert (=> b!1487 m!2181))

(declare-fun m!2183 () Bool)

(assert (=> b!1488 m!2183))

(declare-fun m!2185 () Bool)

(assert (=> b!1488 m!2185))

(assert (=> b!603 d!903))

(assert (=> b!831 d!619))

(declare-fun d!905 () Bool)

(declare-fun c!394 () Bool)

(assert (=> d!905 (= c!394 ((_ is Empty!3) (right!8 (left!8 (right!8 t!78)))))))

(declare-fun e!837 () (_ BitVec 32))

(assert (=> d!905 (= (blackHeight!0 (right!8 (left!8 (right!8 t!78)))) e!837)))

(declare-fun b!1489 () Bool)

(declare-fun e!838 () (_ BitVec 32))

(declare-fun call!254 () (_ BitVec 32))

(assert (=> b!1489 (= e!838 (bvadd call!254 #b00000000000000000000000000000001))))

(declare-fun bm!254 () Bool)

(assert (=> bm!254 (= call!254 (blackHeight!0 (left!8 (right!8 (left!8 (right!8 t!78))))))))

(declare-fun b!1490 () Bool)

(assert (=> b!1490 (= e!838 call!254)))

(declare-fun b!1491 () Bool)

(assert (=> b!1491 (= e!837 e!838)))

(declare-fun c!395 () Bool)

(assert (=> b!1491 (= c!395 ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 t!78))))))))

(declare-fun b!1492 () Bool)

(assert (=> b!1492 (= e!837 #b00000000000000000000000000000001)))

(assert (= (and d!905 c!394) b!1492))

(assert (= (and d!905 (not c!394)) b!1491))

(assert (= (and b!1491 c!395) b!1489))

(assert (= (and b!1491 (not c!395)) b!1490))

(assert (= (or b!1489 b!1490) bm!254))

(assert (=> bm!254 m!1413))

(assert (=> b!831 d!905))

(declare-fun d!907 () Bool)

(assert (=> d!907 (= (isBlack!0 (right!8 (left!8 (right!8 lt!5)))) (or ((_ is Empty!3) (right!8 (left!8 (right!8 lt!5)))) ((_ is Black!3) (color!6 (right!8 (left!8 (right!8 lt!5)))))))))

(assert (=> b!592 d!907))

(declare-fun b!1493 () Bool)

(declare-fun res!781 () Bool)

(declare-fun call!256 () Bool)

(assert (=> b!1493 (= res!781 call!256)))

(declare-fun e!841 () Bool)

(assert (=> b!1493 (=> (not res!781) (not e!841))))

(declare-fun d!909 () Bool)

(declare-fun res!779 () Bool)

(declare-fun e!842 () Bool)

(assert (=> d!909 (=> res!779 e!842)))

(assert (=> d!909 (= res!779 ((_ is Empty!3) (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))

(assert (=> d!909 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) e!842)))

(declare-fun b!1494 () Bool)

(declare-fun call!255 () Bool)

(assert (=> b!1494 (= e!841 call!255)))

(declare-fun bm!255 () Bool)

(assert (=> bm!255 (= call!256 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun bm!256 () Bool)

(assert (=> bm!256 (= call!255 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1495 () Bool)

(declare-fun res!780 () Bool)

(assert (=> b!1495 (= res!780 (isBlack!0 (right!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!1495 (=> (not res!780) (not e!841))))

(declare-fun b!1496 () Bool)

(declare-fun e!840 () Bool)

(assert (=> b!1496 (= e!840 call!255)))

(declare-fun b!1497 () Bool)

(declare-fun e!839 () Bool)

(assert (=> b!1497 (= e!839 e!841)))

(declare-fun res!777 () Bool)

(assert (=> b!1497 (= res!777 (isBlack!0 (left!8 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> b!1497 (=> (not res!777) (not e!841))))

(declare-fun b!1498 () Bool)

(assert (=> b!1498 (= e!842 e!839)))

(declare-fun c!396 () Bool)

(assert (=> b!1498 (= c!396 ((_ is Black!3) (color!6 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(declare-fun b!1499 () Bool)

(assert (=> b!1499 (= e!839 e!840)))

(declare-fun res!778 () Bool)

(assert (=> b!1499 (= res!778 call!256)))

(assert (=> b!1499 (=> (not res!778) (not e!840))))

(assert (= (and d!909 (not res!779)) b!1498))

(assert (= (and b!1498 c!396) b!1499))

(assert (= (and b!1498 (not c!396)) b!1497))

(assert (= (and b!1499 res!778) b!1496))

(assert (= (and b!1497 res!777) b!1495))

(assert (= (and b!1495 res!780) b!1493))

(assert (= (and b!1493 res!781) b!1494))

(assert (= (or b!1499 b!1493) bm!255))

(assert (= (or b!1496 b!1494) bm!256))

(declare-fun m!2187 () Bool)

(assert (=> bm!255 m!2187))

(declare-fun m!2189 () Bool)

(assert (=> bm!256 m!2189))

(declare-fun m!2191 () Bool)

(assert (=> b!1495 m!2191))

(declare-fun m!2193 () Bool)

(assert (=> b!1497 m!2193))

(assert (=> bm!115 d!909))

(declare-fun d!911 () Bool)

(declare-fun c!397 () Bool)

(assert (=> d!911 (= c!397 ((_ is Empty!3) (left!8 (right!8 (left!8 (right!8 t!78))))))))

(declare-fun e!843 () (InoxSet (_ BitVec 32)))

(assert (=> d!911 (= (content!0 (left!8 (right!8 (left!8 (right!8 t!78))))) e!843)))

(declare-fun b!1500 () Bool)

(assert (=> b!1500 (= e!843 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1501 () Bool)

(assert (=> b!1501 (= e!843 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (left!8 (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (left!8 (right!8 t!78))))) true)) (content!0 (right!8 (left!8 (right!8 (left!8 (right!8 t!78))))))))))

(assert (= (and d!911 c!397) b!1500))

(assert (= (and d!911 (not c!397)) b!1501))

(declare-fun m!2195 () Bool)

(assert (=> b!1501 m!2195))

(declare-fun m!2197 () Bool)

(assert (=> b!1501 m!2197))

(declare-fun m!2199 () Bool)

(assert (=> b!1501 m!2199))

(assert (=> b!531 d!911))

(declare-fun d!913 () Bool)

(declare-fun c!398 () Bool)

(assert (=> d!913 (= c!398 ((_ is Empty!3) (right!8 (right!8 (left!8 (right!8 t!78))))))))

(declare-fun e!844 () (InoxSet (_ BitVec 32)))

(assert (=> d!913 (= (content!0 (right!8 (right!8 (left!8 (right!8 t!78))))) e!844)))

(declare-fun b!1502 () Bool)

(assert (=> b!1502 (= e!844 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1503 () Bool)

(assert (=> b!1503 (= e!844 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (left!8 (right!8 t!78)))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (left!8 (right!8 t!78))))) true)) (content!0 (right!8 (right!8 (right!8 (left!8 (right!8 t!78))))))))))

(assert (= (and d!913 c!398) b!1502))

(assert (= (and d!913 (not c!398)) b!1503))

(declare-fun m!2201 () Bool)

(assert (=> b!1503 m!2201))

(declare-fun m!2203 () Bool)

(assert (=> b!1503 m!2203))

(declare-fun m!2205 () Bool)

(assert (=> b!1503 m!2205))

(assert (=> b!531 d!913))

(declare-fun b!1504 () Bool)

(declare-fun res!786 () Bool)

(declare-fun call!258 () Bool)

(assert (=> b!1504 (= res!786 call!258)))

(declare-fun e!847 () Bool)

(assert (=> b!1504 (=> (not res!786) (not e!847))))

(declare-fun d!915 () Bool)

(declare-fun res!784 () Bool)

(declare-fun e!848 () Bool)

(assert (=> d!915 (=> res!784 e!848)))

(assert (=> d!915 (= res!784 ((_ is Empty!3) (right!8 (left!8 lt!13))))))

(assert (=> d!915 (= (redNodesHaveBlackChildren!0 (right!8 (left!8 lt!13))) e!848)))

(declare-fun b!1505 () Bool)

(declare-fun call!257 () Bool)

(assert (=> b!1505 (= e!847 call!257)))

(declare-fun bm!257 () Bool)

(assert (=> bm!257 (= call!258 (redNodesHaveBlackChildren!0 (left!8 (right!8 (left!8 lt!13)))))))

(declare-fun bm!258 () Bool)

(assert (=> bm!258 (= call!257 (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 lt!13)))))))

(declare-fun b!1506 () Bool)

(declare-fun res!785 () Bool)

(assert (=> b!1506 (= res!785 (isBlack!0 (right!8 (right!8 (left!8 lt!13)))))))

(assert (=> b!1506 (=> (not res!785) (not e!847))))

(declare-fun b!1507 () Bool)

(declare-fun e!846 () Bool)

(assert (=> b!1507 (= e!846 call!257)))

(declare-fun b!1508 () Bool)

(declare-fun e!845 () Bool)

(assert (=> b!1508 (= e!845 e!847)))

(declare-fun res!782 () Bool)

(assert (=> b!1508 (= res!782 (isBlack!0 (left!8 (right!8 (left!8 lt!13)))))))

(assert (=> b!1508 (=> (not res!782) (not e!847))))

(declare-fun b!1509 () Bool)

(assert (=> b!1509 (= e!848 e!845)))

(declare-fun c!399 () Bool)

(assert (=> b!1509 (= c!399 ((_ is Black!3) (color!6 (right!8 (left!8 lt!13)))))))

(declare-fun b!1510 () Bool)

(assert (=> b!1510 (= e!845 e!846)))

(declare-fun res!783 () Bool)

(assert (=> b!1510 (= res!783 call!258)))

(assert (=> b!1510 (=> (not res!783) (not e!846))))

(assert (= (and d!915 (not res!784)) b!1509))

(assert (= (and b!1509 c!399) b!1510))

(assert (= (and b!1509 (not c!399)) b!1508))

(assert (= (and b!1510 res!783) b!1507))

(assert (= (and b!1508 res!782) b!1506))

(assert (= (and b!1506 res!785) b!1504))

(assert (= (and b!1504 res!786) b!1505))

(assert (= (or b!1510 b!1504) bm!257))

(assert (= (or b!1507 b!1505) bm!258))

(declare-fun m!2207 () Bool)

(assert (=> bm!257 m!2207))

(declare-fun m!2209 () Bool)

(assert (=> bm!258 m!2209))

(declare-fun m!2211 () Bool)

(assert (=> b!1506 m!2211))

(declare-fun m!2213 () Bool)

(assert (=> b!1508 m!2213))

(assert (=> bm!131 d!915))

(declare-fun b!1511 () Bool)

(declare-fun res!791 () Bool)

(declare-fun call!260 () Bool)

(assert (=> b!1511 (= res!791 call!260)))

(declare-fun e!851 () Bool)

(assert (=> b!1511 (=> (not res!791) (not e!851))))

(declare-fun d!917 () Bool)

(declare-fun res!789 () Bool)

(declare-fun e!852 () Bool)

(assert (=> d!917 (=> res!789 e!852)))

(assert (=> d!917 (= res!789 ((_ is Empty!3) (left!8 (right!8 (right!8 lt!5)))))))

(assert (=> d!917 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 lt!5)))) e!852)))

(declare-fun b!1512 () Bool)

(declare-fun call!259 () Bool)

(assert (=> b!1512 (= e!851 call!259)))

(declare-fun bm!259 () Bool)

(assert (=> bm!259 (= call!260 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (right!8 lt!5))))))))

(declare-fun bm!260 () Bool)

(assert (=> bm!260 (= call!259 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!1513 () Bool)

(declare-fun res!790 () Bool)

(assert (=> b!1513 (= res!790 (isBlack!0 (right!8 (left!8 (right!8 (right!8 lt!5))))))))

(assert (=> b!1513 (=> (not res!790) (not e!851))))

(declare-fun b!1514 () Bool)

(declare-fun e!850 () Bool)

(assert (=> b!1514 (= e!850 call!259)))

(declare-fun b!1515 () Bool)

(declare-fun e!849 () Bool)

(assert (=> b!1515 (= e!849 e!851)))

(declare-fun res!787 () Bool)

(assert (=> b!1515 (= res!787 (isBlack!0 (left!8 (left!8 (right!8 (right!8 lt!5))))))))

(assert (=> b!1515 (=> (not res!787) (not e!851))))

(declare-fun b!1516 () Bool)

(assert (=> b!1516 (= e!852 e!849)))

(declare-fun c!400 () Bool)

(assert (=> b!1516 (= c!400 ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!1517 () Bool)

(assert (=> b!1517 (= e!849 e!850)))

(declare-fun res!788 () Bool)

(assert (=> b!1517 (= res!788 call!260)))

(assert (=> b!1517 (=> (not res!788) (not e!850))))

(assert (= (and d!917 (not res!789)) b!1516))

(assert (= (and b!1516 c!400) b!1517))

(assert (= (and b!1516 (not c!400)) b!1515))

(assert (= (and b!1517 res!788) b!1514))

(assert (= (and b!1515 res!787) b!1513))

(assert (= (and b!1513 res!790) b!1511))

(assert (= (and b!1511 res!791) b!1512))

(assert (= (or b!1517 b!1511) bm!259))

(assert (= (or b!1514 b!1512) bm!260))

(declare-fun m!2215 () Bool)

(assert (=> bm!259 m!2215))

(declare-fun m!2217 () Bool)

(assert (=> bm!260 m!2217))

(declare-fun m!2219 () Bool)

(assert (=> b!1513 m!2219))

(declare-fun m!2221 () Bool)

(assert (=> b!1515 m!2221))

(assert (=> bm!118 d!917))

(declare-fun b!1518 () Bool)

(declare-fun res!796 () Bool)

(declare-fun call!262 () Bool)

(assert (=> b!1518 (= res!796 call!262)))

(declare-fun e!855 () Bool)

(assert (=> b!1518 (=> (not res!796) (not e!855))))

(declare-fun d!919 () Bool)

(declare-fun res!794 () Bool)

(declare-fun e!856 () Bool)

(assert (=> d!919 (=> res!794 e!856)))

(assert (=> d!919 (= res!794 ((_ is Empty!3) (left!8 (right!8 (right!8 (right!8 t!78))))))))

(assert (=> d!919 (= (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (right!8 t!78))))) e!856)))

(declare-fun b!1519 () Bool)

(declare-fun call!261 () Bool)

(assert (=> b!1519 (= e!855 call!261)))

(declare-fun bm!261 () Bool)

(assert (=> bm!261 (= call!262 (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (right!8 (right!8 t!78)))))))))

(declare-fun bm!262 () Bool)

(assert (=> bm!262 (= call!261 (redNodesHaveBlackChildren!0 (right!8 (left!8 (right!8 (right!8 (right!8 t!78)))))))))

(declare-fun b!1520 () Bool)

(declare-fun res!795 () Bool)

(assert (=> b!1520 (= res!795 (isBlack!0 (right!8 (left!8 (right!8 (right!8 (right!8 t!78)))))))))

(assert (=> b!1520 (=> (not res!795) (not e!855))))

(declare-fun b!1521 () Bool)

(declare-fun e!854 () Bool)

(assert (=> b!1521 (= e!854 call!261)))

(declare-fun b!1522 () Bool)

(declare-fun e!853 () Bool)

(assert (=> b!1522 (= e!853 e!855)))

(declare-fun res!792 () Bool)

(assert (=> b!1522 (= res!792 (isBlack!0 (left!8 (left!8 (right!8 (right!8 (right!8 t!78)))))))))

(assert (=> b!1522 (=> (not res!792) (not e!855))))

(declare-fun b!1523 () Bool)

(assert (=> b!1523 (= e!856 e!853)))

(declare-fun c!401 () Bool)

(assert (=> b!1523 (= c!401 ((_ is Black!3) (color!6 (left!8 (right!8 (right!8 (right!8 t!78)))))))))

(declare-fun b!1524 () Bool)

(assert (=> b!1524 (= e!853 e!854)))

(declare-fun res!793 () Bool)

(assert (=> b!1524 (= res!793 call!262)))

(assert (=> b!1524 (=> (not res!793) (not e!854))))

(assert (= (and d!919 (not res!794)) b!1523))

(assert (= (and b!1523 c!401) b!1524))

(assert (= (and b!1523 (not c!401)) b!1522))

(assert (= (and b!1524 res!793) b!1521))

(assert (= (and b!1522 res!792) b!1520))

(assert (= (and b!1520 res!795) b!1518))

(assert (= (and b!1518 res!796) b!1519))

(assert (= (or b!1524 b!1518) bm!261))

(assert (= (or b!1521 b!1519) bm!262))

(declare-fun m!2223 () Bool)

(assert (=> bm!261 m!2223))

(declare-fun m!2225 () Bool)

(assert (=> bm!262 m!2225))

(declare-fun m!2227 () Bool)

(assert (=> b!1520 m!2227))

(declare-fun m!2229 () Bool)

(assert (=> b!1522 m!2229))

(assert (=> bm!92 d!919))

(declare-fun b!1525 () Bool)

(declare-fun res!801 () Bool)

(declare-fun call!264 () Bool)

(assert (=> b!1525 (= res!801 call!264)))

(declare-fun e!859 () Bool)

(assert (=> b!1525 (=> (not res!801) (not e!859))))

(declare-fun d!921 () Bool)

(declare-fun res!799 () Bool)

(declare-fun e!860 () Bool)

(assert (=> d!921 (=> res!799 e!860)))

(assert (=> d!921 (= res!799 ((_ is Empty!3) (left!8 (left!8 (right!8 (right!8 lt!2))))))))

(assert (=> d!921 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (right!8 lt!2))))) e!860)))

(declare-fun b!1526 () Bool)

(declare-fun call!263 () Bool)

(assert (=> b!1526 (= e!859 call!263)))

(declare-fun bm!263 () Bool)

(assert (=> bm!263 (= call!264 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (right!8 (right!8 lt!2)))))))))

(declare-fun bm!264 () Bool)

(assert (=> bm!264 (= call!263 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (right!8 (right!8 lt!2)))))))))

(declare-fun b!1527 () Bool)

(declare-fun res!800 () Bool)

(assert (=> b!1527 (= res!800 (isBlack!0 (right!8 (left!8 (left!8 (right!8 (right!8 lt!2)))))))))

(assert (=> b!1527 (=> (not res!800) (not e!859))))

(declare-fun b!1528 () Bool)

(declare-fun e!858 () Bool)

(assert (=> b!1528 (= e!858 call!263)))

(declare-fun b!1529 () Bool)

(declare-fun e!857 () Bool)

(assert (=> b!1529 (= e!857 e!859)))

(declare-fun res!797 () Bool)

(assert (=> b!1529 (= res!797 (isBlack!0 (left!8 (left!8 (left!8 (right!8 (right!8 lt!2)))))))))

(assert (=> b!1529 (=> (not res!797) (not e!859))))

(declare-fun b!1530 () Bool)

(assert (=> b!1530 (= e!860 e!857)))

(declare-fun c!402 () Bool)

(assert (=> b!1530 (= c!402 ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 (right!8 lt!2)))))))))

(declare-fun b!1531 () Bool)

(assert (=> b!1531 (= e!857 e!858)))

(declare-fun res!798 () Bool)

(assert (=> b!1531 (= res!798 call!264)))

(assert (=> b!1531 (=> (not res!798) (not e!858))))

(assert (= (and d!921 (not res!799)) b!1530))

(assert (= (and b!1530 c!402) b!1531))

(assert (= (and b!1530 (not c!402)) b!1529))

(assert (= (and b!1531 res!798) b!1528))

(assert (= (and b!1529 res!797) b!1527))

(assert (= (and b!1527 res!800) b!1525))

(assert (= (and b!1525 res!801) b!1526))

(assert (= (or b!1531 b!1525) bm!263))

(assert (= (or b!1528 b!1526) bm!264))

(declare-fun m!2231 () Bool)

(assert (=> bm!263 m!2231))

(declare-fun m!2233 () Bool)

(assert (=> bm!264 m!2233))

(declare-fun m!2235 () Bool)

(assert (=> b!1527 m!2235))

(declare-fun m!2237 () Bool)

(assert (=> b!1529 m!2237))

(assert (=> bm!100 d!921))

(declare-fun d!923 () Bool)

(declare-fun res!802 () Bool)

(declare-fun e!861 () Bool)

(assert (=> d!923 (=> res!802 e!861)))

(assert (=> d!923 (= res!802 (not ((_ is Node!3) (right!8 (left!8 lt!13)))))))

(assert (=> d!923 (= (blackBalanced!0 (right!8 (left!8 lt!13))) e!861)))

(declare-fun b!1532 () Bool)

(declare-fun e!862 () Bool)

(assert (=> b!1532 (= e!861 e!862)))

(declare-fun res!804 () Bool)

(assert (=> b!1532 (=> (not res!804) (not e!862))))

(assert (=> b!1532 (= res!804 (blackBalanced!0 (left!8 (right!8 (left!8 lt!13)))))))

(declare-fun b!1533 () Bool)

(declare-fun res!803 () Bool)

(assert (=> b!1533 (=> (not res!803) (not e!862))))

(assert (=> b!1533 (= res!803 (blackBalanced!0 (right!8 (right!8 (left!8 lt!13)))))))

(declare-fun b!1534 () Bool)

(assert (=> b!1534 (= e!862 (= (blackHeight!0 (left!8 (right!8 (left!8 lt!13)))) (blackHeight!0 (right!8 (right!8 (left!8 lt!13))))))))

(assert (= (and d!923 (not res!802)) b!1532))

(assert (= (and b!1532 res!804) b!1533))

(assert (= (and b!1533 res!803) b!1534))

(declare-fun m!2239 () Bool)

(assert (=> b!1532 m!2239))

(declare-fun m!2241 () Bool)

(assert (=> b!1533 m!2241))

(declare-fun m!2243 () Bool)

(assert (=> b!1534 m!2243))

(declare-fun m!2245 () Bool)

(assert (=> b!1534 m!2245))

(assert (=> b!609 d!923))

(assert (=> bm!86 d!823))

(declare-fun b!1535 () Bool)

(declare-fun res!809 () Bool)

(declare-fun call!266 () Bool)

(assert (=> b!1535 (= res!809 call!266)))

(declare-fun e!865 () Bool)

(assert (=> b!1535 (=> (not res!809) (not e!865))))

(declare-fun d!925 () Bool)

(declare-fun res!807 () Bool)

(declare-fun e!866 () Bool)

(assert (=> d!925 (=> res!807 e!866)))

(assert (=> d!925 (= res!807 ((_ is Empty!3) (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> d!925 (= (redNodesHaveBlackChildren!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) e!866)))

(declare-fun b!1536 () Bool)

(declare-fun call!265 () Bool)

(assert (=> b!1536 (= e!865 call!265)))

(declare-fun bm!265 () Bool)

(assert (=> bm!265 (= call!266 (redNodesHaveBlackChildren!0 (left!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun bm!266 () Bool)

(assert (=> bm!266 (= call!265 (redNodesHaveBlackChildren!0 (right!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun res!808 () Bool)

(declare-fun b!1537 () Bool)

(assert (=> b!1537 (= res!808 (isBlack!0 (right!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> b!1537 (=> (not res!808) (not e!865))))

(declare-fun b!1538 () Bool)

(declare-fun e!864 () Bool)

(assert (=> b!1538 (= e!864 call!265)))

(declare-fun b!1539 () Bool)

(declare-fun e!863 () Bool)

(assert (=> b!1539 (= e!863 e!865)))

(declare-fun res!805 () Bool)

(assert (=> b!1539 (= res!805 (isBlack!0 (left!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> b!1539 (=> (not res!805) (not e!865))))

(declare-fun b!1540 () Bool)

(assert (=> b!1540 (= e!866 e!863)))

(declare-fun c!403 () Bool)

(assert (=> b!1540 (= c!403 ((_ is Black!3) (color!6 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun b!1541 () Bool)

(assert (=> b!1541 (= e!863 e!864)))

(declare-fun res!806 () Bool)

(assert (=> b!1541 (= res!806 call!266)))

(assert (=> b!1541 (=> (not res!806) (not e!864))))

(assert (= (and d!925 (not res!807)) b!1540))

(assert (= (and b!1540 c!403) b!1541))

(assert (= (and b!1540 (not c!403)) b!1539))

(assert (= (and b!1541 res!806) b!1538))

(assert (= (and b!1539 res!805) b!1537))

(assert (= (and b!1537 res!808) b!1535))

(assert (= (and b!1535 res!809) b!1536))

(assert (= (or b!1541 b!1535) bm!265))

(assert (= (or b!1538 b!1536) bm!266))

(declare-fun m!2247 () Bool)

(assert (=> bm!265 m!2247))

(declare-fun m!2249 () Bool)

(assert (=> bm!266 m!2249))

(declare-fun m!2251 () Bool)

(assert (=> b!1537 m!2251))

(declare-fun m!2253 () Bool)

(assert (=> b!1539 m!2253))

(assert (=> bm!138 d!925))

(declare-fun d!927 () Bool)

(declare-fun c!404 () Bool)

(assert (=> d!927 (= c!404 ((_ is Empty!3) (left!8 (left!8 lt!12))))))

(declare-fun e!867 () (InoxSet (_ BitVec 32)))

(assert (=> d!927 (= (content!0 (left!8 (left!8 lt!12))) e!867)))

(declare-fun b!1542 () Bool)

(assert (=> b!1542 (= e!867 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1543 () Bool)

(assert (=> b!1543 (= e!867 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (left!8 lt!12)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (left!8 lt!12))) true)) (content!0 (right!8 (left!8 (left!8 lt!12))))))))

(assert (= (and d!927 c!404) b!1542))

(assert (= (and d!927 (not c!404)) b!1543))

(declare-fun m!2255 () Bool)

(assert (=> b!1543 m!2255))

(declare-fun m!2257 () Bool)

(assert (=> b!1543 m!2257))

(declare-fun m!2259 () Bool)

(assert (=> b!1543 m!2259))

(assert (=> b!639 d!927))

(declare-fun d!929 () Bool)

(declare-fun c!405 () Bool)

(assert (=> d!929 (= c!405 ((_ is Empty!3) (right!8 (left!8 lt!12))))))

(declare-fun e!868 () (InoxSet (_ BitVec 32)))

(assert (=> d!929 (= (content!0 (right!8 (left!8 lt!12))) e!868)))

(declare-fun b!1544 () Bool)

(assert (=> b!1544 (= e!868 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1545 () Bool)

(assert (=> b!1545 (= e!868 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (left!8 lt!12)))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (left!8 lt!12))) true)) (content!0 (right!8 (right!8 (left!8 lt!12))))))))

(assert (= (and d!929 c!405) b!1544))

(assert (= (and d!929 (not c!405)) b!1545))

(declare-fun m!2261 () Bool)

(assert (=> b!1545 m!2261))

(declare-fun m!2263 () Bool)

(assert (=> b!1545 m!2263))

(declare-fun m!2265 () Bool)

(assert (=> b!1545 m!2265))

(assert (=> b!639 d!929))

(declare-fun d!931 () Bool)

(declare-fun lt!66 () Int)

(assert (=> d!931 (>= lt!66 0)))

(declare-fun e!869 () Int)

(assert (=> d!931 (= lt!66 e!869)))

(declare-fun c!406 () Bool)

(assert (=> d!931 (= c!406 ((_ is Empty!3) (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> d!931 (= (size!0 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) lt!66)))

(declare-fun b!1546 () Bool)

(assert (=> b!1546 (= e!869 0)))

(declare-fun b!1547 () Bool)

(assert (=> b!1547 (= e!869 (+ (size!0 (left!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) 1 (size!0 (right!8 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (= (and d!931 c!406) b!1546))

(assert (= (and d!931 (not c!406)) b!1547))

(declare-fun m!2267 () Bool)

(assert (=> b!1547 m!2267))

(declare-fun m!2269 () Bool)

(assert (=> b!1547 m!2269))

(assert (=> b!717 d!931))

(declare-fun d!933 () Bool)

(declare-fun lt!67 () Int)

(assert (=> d!933 (>= lt!67 0)))

(declare-fun e!870 () Int)

(assert (=> d!933 (= lt!67 e!870)))

(declare-fun c!407 () Bool)

(assert (=> d!933 (= c!407 ((_ is Empty!3) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))

(assert (=> d!933 (= (size!0 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))) lt!67)))

(declare-fun b!1548 () Bool)

(assert (=> b!1548 (= e!870 0)))

(declare-fun b!1549 () Bool)

(assert (=> b!1549 (= e!870 (+ (size!0 (left!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) 1 (size!0 (right!8 (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (= (and d!933 c!407) b!1548))

(assert (= (and d!933 (not c!407)) b!1549))

(declare-fun m!2271 () Bool)

(assert (=> b!1549 m!2271))

(declare-fun m!2273 () Bool)

(assert (=> b!1549 m!2273))

(assert (=> b!717 d!933))

(declare-fun d!935 () Bool)

(assert (=> d!935 (= (isBlack!0 (left!8 (left!8 (right!8 (left!8 lt!2))))) (or ((_ is Empty!3) (left!8 (left!8 (right!8 (left!8 lt!2))))) ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 (left!8 lt!2))))))))))

(assert (=> b!631 d!935))

(declare-fun d!937 () Bool)

(assert (=> d!937 (= (isBlack!0 (left!8 (right!8 (left!8 (right!8 t!78))))) (or ((_ is Empty!3) (left!8 (right!8 (left!8 (right!8 t!78))))) ((_ is Black!3) (color!6 (left!8 (right!8 (left!8 (right!8 t!78))))))))))

(assert (=> b!772 d!937))

(assert (=> bm!107 d!685))

(declare-fun b!1550 () Bool)

(declare-fun res!814 () Bool)

(declare-fun call!268 () Bool)

(assert (=> b!1550 (= res!814 call!268)))

(declare-fun e!873 () Bool)

(assert (=> b!1550 (=> (not res!814) (not e!873))))

(declare-fun d!939 () Bool)

(declare-fun res!812 () Bool)

(declare-fun e!874 () Bool)

(assert (=> d!939 (=> res!812 e!874)))

(assert (=> d!939 (= res!812 ((_ is Empty!3) (right!8 (right!8 (left!8 (right!8 lt!2))))))))

(assert (=> d!939 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (left!8 (right!8 lt!2))))) e!874)))

(declare-fun b!1551 () Bool)

(declare-fun call!267 () Bool)

(assert (=> b!1551 (= e!873 call!267)))

(declare-fun bm!267 () Bool)

(assert (=> bm!267 (= call!268 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (left!8 (right!8 lt!2)))))))))

(declare-fun bm!268 () Bool)

(assert (=> bm!268 (= call!267 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (left!8 (right!8 lt!2)))))))))

(declare-fun b!1552 () Bool)

(declare-fun res!813 () Bool)

(assert (=> b!1552 (= res!813 (isBlack!0 (right!8 (right!8 (right!8 (left!8 (right!8 lt!2)))))))))

(assert (=> b!1552 (=> (not res!813) (not e!873))))

(declare-fun b!1553 () Bool)

(declare-fun e!872 () Bool)

(assert (=> b!1553 (= e!872 call!267)))

(declare-fun b!1554 () Bool)

(declare-fun e!871 () Bool)

(assert (=> b!1554 (= e!871 e!873)))

(declare-fun res!810 () Bool)

(assert (=> b!1554 (= res!810 (isBlack!0 (left!8 (right!8 (right!8 (left!8 (right!8 lt!2)))))))))

(assert (=> b!1554 (=> (not res!810) (not e!873))))

(declare-fun b!1555 () Bool)

(assert (=> b!1555 (= e!874 e!871)))

(declare-fun c!408 () Bool)

(assert (=> b!1555 (= c!408 ((_ is Black!3) (color!6 (right!8 (right!8 (left!8 (right!8 lt!2)))))))))

(declare-fun b!1556 () Bool)

(assert (=> b!1556 (= e!871 e!872)))

(declare-fun res!811 () Bool)

(assert (=> b!1556 (= res!811 call!268)))

(assert (=> b!1556 (=> (not res!811) (not e!872))))

(assert (= (and d!939 (not res!812)) b!1555))

(assert (= (and b!1555 c!408) b!1556))

(assert (= (and b!1555 (not c!408)) b!1554))

(assert (= (and b!1556 res!811) b!1553))

(assert (= (and b!1554 res!810) b!1552))

(assert (= (and b!1552 res!813) b!1550))

(assert (= (and b!1550 res!814) b!1551))

(assert (= (or b!1556 b!1550) bm!267))

(assert (= (or b!1553 b!1551) bm!268))

(declare-fun m!2275 () Bool)

(assert (=> bm!267 m!2275))

(declare-fun m!2277 () Bool)

(assert (=> bm!268 m!2277))

(declare-fun m!2279 () Bool)

(assert (=> b!1552 m!2279))

(declare-fun m!2281 () Bool)

(assert (=> b!1554 m!2281))

(assert (=> bm!133 d!939))

(declare-fun d!941 () Bool)

(assert (=> d!941 (= (isBlack!0 (left!8 (left!8 (left!8 (right!8 lt!2))))) (or ((_ is Empty!3) (left!8 (left!8 (left!8 (right!8 lt!2))))) ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 (right!8 lt!2))))))))))

(assert (=> b!677 d!941))

(declare-fun d!943 () Bool)

(declare-fun res!815 () Bool)

(declare-fun e!875 () Bool)

(assert (=> d!943 (=> res!815 e!875)))

(assert (=> d!943 (= res!815 (not ((_ is Node!3) (left!8 (left!8 (left!8 lt!5))))))))

(assert (=> d!943 (= (blackBalanced!0 (left!8 (left!8 (left!8 lt!5)))) e!875)))

(declare-fun b!1557 () Bool)

(declare-fun e!876 () Bool)

(assert (=> b!1557 (= e!875 e!876)))

(declare-fun res!817 () Bool)

(assert (=> b!1557 (=> (not res!817) (not e!876))))

(assert (=> b!1557 (= res!817 (blackBalanced!0 (left!8 (left!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!1558 () Bool)

(declare-fun res!816 () Bool)

(assert (=> b!1558 (=> (not res!816) (not e!876))))

(assert (=> b!1558 (= res!816 (blackBalanced!0 (right!8 (left!8 (left!8 (left!8 lt!5))))))))

(declare-fun b!1559 () Bool)

(assert (=> b!1559 (= e!876 (= (blackHeight!0 (left!8 (left!8 (left!8 (left!8 lt!5))))) (blackHeight!0 (right!8 (left!8 (left!8 (left!8 lt!5)))))))))

(assert (= (and d!943 (not res!815)) b!1557))

(assert (= (and b!1557 res!817) b!1558))

(assert (= (and b!1558 res!816) b!1559))

(declare-fun m!2283 () Bool)

(assert (=> b!1557 m!2283))

(declare-fun m!2285 () Bool)

(assert (=> b!1558 m!2285))

(assert (=> b!1559 m!1997))

(declare-fun m!2287 () Bool)

(assert (=> b!1559 m!2287))

(assert (=> b!722 d!943))

(declare-fun d!945 () Bool)

(declare-fun lt!68 () Int)

(assert (=> d!945 (>= lt!68 0)))

(declare-fun e!877 () Int)

(assert (=> d!945 (= lt!68 e!877)))

(declare-fun c!409 () Bool)

(assert (=> d!945 (= c!409 ((_ is Empty!3) (left!8 (left!8 (left!8 lt!5)))))))

(assert (=> d!945 (= (size!0 (left!8 (left!8 (left!8 lt!5)))) lt!68)))

(declare-fun b!1560 () Bool)

(assert (=> b!1560 (= e!877 0)))

(declare-fun b!1561 () Bool)

(assert (=> b!1561 (= e!877 (+ (size!0 (left!8 (left!8 (left!8 (left!8 lt!5))))) 1 (size!0 (right!8 (left!8 (left!8 (left!8 lt!5)))))))))

(assert (= (and d!945 c!409) b!1560))

(assert (= (and d!945 (not c!409)) b!1561))

(declare-fun m!2289 () Bool)

(assert (=> b!1561 m!2289))

(declare-fun m!2291 () Bool)

(assert (=> b!1561 m!2291))

(assert (=> b!635 d!945))

(declare-fun d!947 () Bool)

(declare-fun lt!69 () Int)

(assert (=> d!947 (>= lt!69 0)))

(declare-fun e!878 () Int)

(assert (=> d!947 (= lt!69 e!878)))

(declare-fun c!410 () Bool)

(assert (=> d!947 (= c!410 ((_ is Empty!3) (right!8 (left!8 (left!8 lt!5)))))))

(assert (=> d!947 (= (size!0 (right!8 (left!8 (left!8 lt!5)))) lt!69)))

(declare-fun b!1562 () Bool)

(assert (=> b!1562 (= e!878 0)))

(declare-fun b!1563 () Bool)

(assert (=> b!1563 (= e!878 (+ (size!0 (left!8 (right!8 (left!8 (left!8 lt!5))))) 1 (size!0 (right!8 (right!8 (left!8 (left!8 lt!5)))))))))

(assert (= (and d!947 c!410) b!1562))

(assert (= (and d!947 (not c!410)) b!1563))

(declare-fun m!2293 () Bool)

(assert (=> b!1563 m!2293))

(declare-fun m!2295 () Bool)

(assert (=> b!1563 m!2295))

(assert (=> b!635 d!947))

(declare-fun b!1564 () Bool)

(declare-fun res!822 () Bool)

(declare-fun call!270 () Bool)

(assert (=> b!1564 (= res!822 call!270)))

(declare-fun e!881 () Bool)

(assert (=> b!1564 (=> (not res!822) (not e!881))))

(declare-fun d!949 () Bool)

(declare-fun res!820 () Bool)

(declare-fun e!882 () Bool)

(assert (=> d!949 (=> res!820 e!882)))

(assert (=> d!949 (= res!820 ((_ is Empty!3) (left!8 (left!8 (right!8 (left!8 t!78))))))))

(assert (=> d!949 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (right!8 (left!8 t!78))))) e!882)))

(declare-fun b!1565 () Bool)

(declare-fun call!269 () Bool)

(assert (=> b!1565 (= e!881 call!269)))

(declare-fun bm!269 () Bool)

(assert (=> bm!269 (= call!270 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (right!8 (left!8 t!78)))))))))

(declare-fun bm!270 () Bool)

(assert (=> bm!270 (= call!269 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (right!8 (left!8 t!78)))))))))

(declare-fun b!1566 () Bool)

(declare-fun res!821 () Bool)

(assert (=> b!1566 (= res!821 (isBlack!0 (right!8 (left!8 (left!8 (right!8 (left!8 t!78)))))))))

(assert (=> b!1566 (=> (not res!821) (not e!881))))

(declare-fun b!1567 () Bool)

(declare-fun e!880 () Bool)

(assert (=> b!1567 (= e!880 call!269)))

(declare-fun b!1568 () Bool)

(declare-fun e!879 () Bool)

(assert (=> b!1568 (= e!879 e!881)))

(declare-fun res!818 () Bool)

(assert (=> b!1568 (= res!818 (isBlack!0 (left!8 (left!8 (left!8 (right!8 (left!8 t!78)))))))))

(assert (=> b!1568 (=> (not res!818) (not e!881))))

(declare-fun b!1569 () Bool)

(assert (=> b!1569 (= e!882 e!879)))

(declare-fun c!411 () Bool)

(assert (=> b!1569 (= c!411 ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 (left!8 t!78)))))))))

(declare-fun b!1570 () Bool)

(assert (=> b!1570 (= e!879 e!880)))

(declare-fun res!819 () Bool)

(assert (=> b!1570 (= res!819 call!270)))

(assert (=> b!1570 (=> (not res!819) (not e!880))))

(assert (= (and d!949 (not res!820)) b!1569))

(assert (= (and b!1569 c!411) b!1570))

(assert (= (and b!1569 (not c!411)) b!1568))

(assert (= (and b!1570 res!819) b!1567))

(assert (= (and b!1568 res!818) b!1566))

(assert (= (and b!1566 res!821) b!1564))

(assert (= (and b!1564 res!822) b!1565))

(assert (= (or b!1570 b!1564) bm!269))

(assert (= (or b!1567 b!1565) bm!270))

(declare-fun m!2297 () Bool)

(assert (=> bm!269 m!2297))

(declare-fun m!2299 () Bool)

(assert (=> bm!270 m!2299))

(declare-fun m!2301 () Bool)

(assert (=> b!1566 m!2301))

(declare-fun m!2303 () Bool)

(assert (=> b!1568 m!2303))

(assert (=> bm!126 d!949))

(declare-fun d!951 () Bool)

(assert (=> d!951 (= (isBlack!0 (left!8 (left!8 (right!8 (right!8 t!78))))) (or ((_ is Empty!3) (left!8 (left!8 (right!8 (right!8 t!78))))) ((_ is Black!3) (color!6 (left!8 (left!8 (right!8 (right!8 t!78))))))))))

(assert (=> b!807 d!951))

(declare-fun d!953 () Bool)

(assert (=> d!953 (= (isBlack!0 (right!8 (left!8 lt!13))) (or ((_ is Empty!3) (right!8 (left!8 lt!13))) ((_ is Black!3) (color!6 (right!8 (left!8 lt!13))))))))

(assert (=> b!750 d!953))

(declare-fun d!955 () Bool)

(declare-fun c!412 () Bool)

(assert (=> d!955 (= c!412 ((_ is Empty!3) lt!28))))

(declare-fun e!883 () (InoxSet (_ BitVec 32)))

(assert (=> d!955 (= (content!0 lt!28) e!883)))

(declare-fun b!1571 () Bool)

(assert (=> b!1571 (= e!883 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1572 () Bool)

(assert (=> b!1572 (= e!883 ((_ map or) ((_ map or) (content!0 (left!8 lt!28)) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 lt!28) true)) (content!0 (right!8 lt!28))))))

(assert (= (and d!955 c!412) b!1571))

(assert (= (and d!955 (not c!412)) b!1572))

(declare-fun m!2305 () Bool)

(assert (=> b!1572 m!2305))

(declare-fun m!2307 () Bool)

(assert (=> b!1572 m!2307))

(declare-fun m!2309 () Bool)

(assert (=> b!1572 m!2309))

(assert (=> d!301 d!955))

(declare-fun d!957 () Bool)

(declare-fun c!413 () Bool)

(assert (=> d!957 (= c!413 ((_ is Empty!3) (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(declare-fun e!884 () (InoxSet (_ BitVec 32)))

(assert (=> d!957 (= (content!0 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) e!884)))

(declare-fun b!1573 () Bool)

(assert (=> b!1573 (= e!884 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1574 () Bool)

(assert (=> b!1574 (= e!884 ((_ map or) ((_ map or) (content!0 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) true)) (content!0 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))))

(assert (= (and d!957 c!413) b!1573))

(assert (= (and d!957 (not c!413)) b!1574))

(declare-fun m!2311 () Bool)

(assert (=> b!1574 m!2311))

(declare-fun m!2313 () Bool)

(assert (=> b!1574 m!2313))

(declare-fun m!2315 () Bool)

(assert (=> b!1574 m!2315))

(assert (=> d!301 d!957))

(declare-fun b!1575 () Bool)

(declare-fun res!827 () Bool)

(declare-fun call!272 () Bool)

(assert (=> b!1575 (= res!827 call!272)))

(declare-fun e!887 () Bool)

(assert (=> b!1575 (=> (not res!827) (not e!887))))

(declare-fun d!959 () Bool)

(declare-fun res!825 () Bool)

(declare-fun e!888 () Bool)

(assert (=> d!959 (=> res!825 e!888)))

(assert (=> d!959 (= res!825 ((_ is Empty!3) (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> d!959 (= (redNodesHaveBlackChildren!0 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))) e!888)))

(declare-fun b!1576 () Bool)

(declare-fun call!271 () Bool)

(assert (=> b!1576 (= e!887 call!271)))

(declare-fun bm!271 () Bool)

(assert (=> bm!271 (= call!272 (redNodesHaveBlackChildren!0 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(declare-fun bm!272 () Bool)

(assert (=> bm!272 (= call!271 (redNodesHaveBlackChildren!0 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(declare-fun b!1577 () Bool)

(declare-fun res!826 () Bool)

(assert (=> b!1577 (= res!826 (isBlack!0 (right!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (=> b!1577 (=> (not res!826) (not e!887))))

(declare-fun b!1578 () Bool)

(declare-fun e!886 () Bool)

(assert (=> b!1578 (= e!886 call!271)))

(declare-fun b!1579 () Bool)

(declare-fun e!885 () Bool)

(assert (=> b!1579 (= e!885 e!887)))

(declare-fun res!823 () Bool)

(assert (=> b!1579 (= res!823 (isBlack!0 (left!8 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(assert (=> b!1579 (=> (not res!823) (not e!887))))

(declare-fun b!1580 () Bool)

(assert (=> b!1580 (= e!888 e!885)))

(declare-fun c!414 () Bool)

(assert (=> b!1580 (= c!414 ((_ is Black!3) (color!6 (ite c!92 (left!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (right!8 (ite c!62 (left!8 (ite c!50 (left!8 t!78) (right!8 t!78))) (right!8 (ite c!50 (left!8 t!78) (right!8 t!78)))))))))))

(declare-fun b!1581 () Bool)

(assert (=> b!1581 (= e!885 e!886)))

(declare-fun res!824 () Bool)

(assert (=> b!1581 (= res!824 call!272)))

(assert (=> b!1581 (=> (not res!824) (not e!886))))

(assert (= (and d!959 (not res!825)) b!1580))

(assert (= (and b!1580 c!414) b!1581))

(assert (= (and b!1580 (not c!414)) b!1579))

(assert (= (and b!1581 res!824) b!1578))

(assert (= (and b!1579 res!823) b!1577))

(assert (= (and b!1577 res!826) b!1575))

(assert (= (and b!1575 res!827) b!1576))

(assert (= (or b!1581 b!1575) bm!271))

(assert (= (or b!1578 b!1576) bm!272))

(declare-fun m!2317 () Bool)

(assert (=> bm!271 m!2317))

(declare-fun m!2319 () Bool)

(assert (=> bm!272 m!2319))

(declare-fun m!2321 () Bool)

(assert (=> b!1577 m!2321))

(declare-fun m!2323 () Bool)

(assert (=> b!1579 m!2323))

(assert (=> d!301 d!959))

(declare-fun d!961 () Bool)

(declare-fun res!828 () Bool)

(declare-fun e!889 () Bool)

(assert (=> d!961 (=> res!828 e!889)))

(assert (=> d!961 (= res!828 (not ((_ is Node!3) (right!8 lt!19))))))

(assert (=> d!961 (= (blackBalanced!0 (right!8 lt!19)) e!889)))

(declare-fun b!1582 () Bool)

(declare-fun e!890 () Bool)

(assert (=> b!1582 (= e!889 e!890)))

(declare-fun res!830 () Bool)

(assert (=> b!1582 (=> (not res!830) (not e!890))))

(assert (=> b!1582 (= res!830 (blackBalanced!0 (left!8 (right!8 lt!19))))))

(declare-fun b!1583 () Bool)

(declare-fun res!829 () Bool)

(assert (=> b!1583 (=> (not res!829) (not e!890))))

(assert (=> b!1583 (= res!829 (blackBalanced!0 (right!8 (right!8 lt!19))))))

(declare-fun b!1584 () Bool)

(assert (=> b!1584 (= e!890 (= (blackHeight!0 (left!8 (right!8 lt!19))) (blackHeight!0 (right!8 (right!8 lt!19)))))))

(assert (= (and d!961 (not res!828)) b!1582))

(assert (= (and b!1582 res!830) b!1583))

(assert (= (and b!1583 res!829) b!1584))

(declare-fun m!2325 () Bool)

(assert (=> b!1582 m!2325))

(declare-fun m!2327 () Bool)

(assert (=> b!1583 m!2327))

(assert (=> b!1584 m!1863))

(declare-fun m!2329 () Bool)

(assert (=> b!1584 m!2329))

(assert (=> b!726 d!961))

(declare-fun d!963 () Bool)

(assert (=> d!963 (= (isBlack!0 (left!8 (left!8 (left!8 lt!5)))) (or ((_ is Empty!3) (left!8 (left!8 (left!8 lt!5)))) ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 lt!5)))))))))

(assert (=> b!540 d!963))

(declare-fun d!965 () Bool)

(assert (=> d!965 (= (isBlack!0 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) (or ((_ is Empty!3) (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))) ((_ is Black!3) (color!6 (right!8 (right!8 (ite c!50 (left!8 t!78) (right!8 t!78))))))))))

(assert (=> b!651 d!965))

(declare-fun b!1585 () Bool)

(declare-fun res!835 () Bool)

(declare-fun call!274 () Bool)

(assert (=> b!1585 (= res!835 call!274)))

(declare-fun e!893 () Bool)

(assert (=> b!1585 (=> (not res!835) (not e!893))))

(declare-fun d!967 () Bool)

(declare-fun res!833 () Bool)

(declare-fun e!894 () Bool)

(assert (=> d!967 (=> res!833 e!894)))

(assert (=> d!967 (= res!833 ((_ is Empty!3) (left!8 (left!8 (left!8 (left!8 t!78))))))))

(assert (=> d!967 (= (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (left!8 t!78))))) e!894)))

(declare-fun b!1586 () Bool)

(declare-fun call!273 () Bool)

(assert (=> b!1586 (= e!893 call!273)))

(declare-fun bm!273 () Bool)

(assert (=> bm!273 (= call!274 (redNodesHaveBlackChildren!0 (left!8 (left!8 (left!8 (left!8 (left!8 t!78)))))))))

(declare-fun bm!274 () Bool)

(assert (=> bm!274 (= call!273 (redNodesHaveBlackChildren!0 (right!8 (left!8 (left!8 (left!8 (left!8 t!78)))))))))

(declare-fun b!1587 () Bool)

(declare-fun res!834 () Bool)

(assert (=> b!1587 (= res!834 (isBlack!0 (right!8 (left!8 (left!8 (left!8 (left!8 t!78)))))))))

(assert (=> b!1587 (=> (not res!834) (not e!893))))

(declare-fun b!1588 () Bool)

(declare-fun e!892 () Bool)

(assert (=> b!1588 (= e!892 call!273)))

(declare-fun b!1589 () Bool)

(declare-fun e!891 () Bool)

(assert (=> b!1589 (= e!891 e!893)))

(declare-fun res!831 () Bool)

(assert (=> b!1589 (= res!831 (isBlack!0 (left!8 (left!8 (left!8 (left!8 (left!8 t!78)))))))))

(assert (=> b!1589 (=> (not res!831) (not e!893))))

(declare-fun b!1590 () Bool)

(assert (=> b!1590 (= e!894 e!891)))

(declare-fun c!415 () Bool)

(assert (=> b!1590 (= c!415 ((_ is Black!3) (color!6 (left!8 (left!8 (left!8 (left!8 t!78)))))))))

(declare-fun b!1591 () Bool)

(assert (=> b!1591 (= e!891 e!892)))

(declare-fun res!832 () Bool)

(assert (=> b!1591 (= res!832 call!274)))

(assert (=> b!1591 (=> (not res!832) (not e!892))))

(assert (= (and d!967 (not res!833)) b!1590))

(assert (= (and b!1590 c!415) b!1591))

(assert (= (and b!1590 (not c!415)) b!1589))

(assert (= (and b!1591 res!832) b!1588))

(assert (= (and b!1589 res!831) b!1587))

(assert (= (and b!1587 res!834) b!1585))

(assert (= (and b!1585 res!835) b!1586))

(assert (= (or b!1591 b!1585) bm!273))

(assert (= (or b!1588 b!1586) bm!274))

(declare-fun m!2331 () Bool)

(assert (=> bm!273 m!2331))

(declare-fun m!2333 () Bool)

(assert (=> bm!274 m!2333))

(declare-fun m!2335 () Bool)

(assert (=> b!1587 m!2335))

(declare-fun m!2337 () Bool)

(assert (=> b!1589 m!2337))

(assert (=> bm!142 d!967))

(assert (=> b!610 d!753))

(declare-fun d!969 () Bool)

(declare-fun c!416 () Bool)

(assert (=> d!969 (= c!416 ((_ is Empty!3) (right!8 (left!8 lt!13))))))

(declare-fun e!895 () (_ BitVec 32))

(assert (=> d!969 (= (blackHeight!0 (right!8 (left!8 lt!13))) e!895)))

(declare-fun b!1592 () Bool)

(declare-fun e!896 () (_ BitVec 32))

(declare-fun call!275 () (_ BitVec 32))

(assert (=> b!1592 (= e!896 (bvadd call!275 #b00000000000000000000000000000001))))

(declare-fun bm!275 () Bool)

(assert (=> bm!275 (= call!275 (blackHeight!0 (left!8 (right!8 (left!8 lt!13)))))))

(declare-fun b!1593 () Bool)

(assert (=> b!1593 (= e!896 call!275)))

(declare-fun b!1594 () Bool)

(assert (=> b!1594 (= e!895 e!896)))

(declare-fun c!417 () Bool)

(assert (=> b!1594 (= c!417 ((_ is Black!3) (color!6 (right!8 (left!8 lt!13)))))))

(declare-fun b!1595 () Bool)

(assert (=> b!1595 (= e!895 #b00000000000000000000000000000001)))

(assert (= (and d!969 c!416) b!1595))

(assert (= (and d!969 (not c!416)) b!1594))

(assert (= (and b!1594 c!417) b!1592))

(assert (= (and b!1594 (not c!417)) b!1593))

(assert (= (or b!1592 b!1593) bm!275))

(assert (=> bm!275 m!2243))

(assert (=> b!610 d!969))

(declare-fun d!971 () Bool)

(declare-fun c!418 () Bool)

(assert (=> d!971 (= c!418 ((_ is Empty!3) (left!8 (right!8 (left!8 lt!5)))))))

(declare-fun e!897 () (InoxSet (_ BitVec 32)))

(assert (=> d!971 (= (content!0 (left!8 (right!8 (left!8 lt!5)))) e!897)))

(declare-fun b!1596 () Bool)

(assert (=> b!1596 (= e!897 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1597 () Bool)

(assert (=> b!1597 (= e!897 ((_ map or) ((_ map or) (content!0 (left!8 (left!8 (right!8 (left!8 lt!5))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (left!8 (right!8 (left!8 lt!5)))) true)) (content!0 (right!8 (left!8 (right!8 (left!8 lt!5)))))))))

(assert (= (and d!971 c!418) b!1596))

(assert (= (and d!971 (not c!418)) b!1597))

(declare-fun m!2339 () Bool)

(assert (=> b!1597 m!2339))

(declare-fun m!2341 () Bool)

(assert (=> b!1597 m!2341))

(declare-fun m!2343 () Bool)

(assert (=> b!1597 m!2343))

(assert (=> b!747 d!971))

(declare-fun d!973 () Bool)

(declare-fun c!419 () Bool)

(assert (=> d!973 (= c!419 ((_ is Empty!3) (right!8 (right!8 (left!8 lt!5)))))))

(declare-fun e!898 () (InoxSet (_ BitVec 32)))

(assert (=> d!973 (= (content!0 (right!8 (right!8 (left!8 lt!5)))) e!898)))

(declare-fun b!1598 () Bool)

(assert (=> b!1598 (= e!898 ((as const (Array (_ BitVec 32) Bool)) false))))

(declare-fun b!1599 () Bool)

(assert (=> b!1599 (= e!898 ((_ map or) ((_ map or) (content!0 (left!8 (right!8 (right!8 (left!8 lt!5))))) (store ((as const (Array (_ BitVec 32) Bool)) false) (value!38 (right!8 (right!8 (left!8 lt!5)))) true)) (content!0 (right!8 (right!8 (right!8 (left!8 lt!5)))))))))

(assert (= (and d!973 c!419) b!1598))

(assert (= (and d!973 (not c!419)) b!1599))

(declare-fun m!2345 () Bool)

(assert (=> b!1599 m!2345))

(declare-fun m!2347 () Bool)

(assert (=> b!1599 m!2347))

(declare-fun m!2349 () Bool)

(assert (=> b!1599 m!2349))

(assert (=> b!747 d!973))

(assert (=> b!597 d!673))

(assert (=> b!597 d!671))

(declare-fun b!1600 () Bool)

(declare-fun res!840 () Bool)

(declare-fun call!277 () Bool)

(assert (=> b!1600 (= res!840 call!277)))

(declare-fun e!901 () Bool)

(assert (=> b!1600 (=> (not res!840) (not e!901))))

(declare-fun d!975 () Bool)

(declare-fun res!838 () Bool)

(declare-fun e!902 () Bool)

(assert (=> d!975 (=> res!838 e!902)))

(assert (=> d!975 (= res!838 ((_ is Empty!3) (right!8 (right!8 (right!8 lt!5)))))))

(assert (=> d!975 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 lt!5)))) e!902)))

(declare-fun b!1601 () Bool)

(declare-fun call!276 () Bool)

(assert (=> b!1601 (= e!901 call!276)))

(declare-fun bm!276 () Bool)

(assert (=> bm!276 (= call!277 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (right!8 lt!5))))))))

(declare-fun bm!277 () Bool)

(assert (=> bm!277 (= call!276 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!1602 () Bool)

(declare-fun res!839 () Bool)

(assert (=> b!1602 (= res!839 (isBlack!0 (right!8 (right!8 (right!8 (right!8 lt!5))))))))

(assert (=> b!1602 (=> (not res!839) (not e!901))))

(declare-fun b!1603 () Bool)

(declare-fun e!900 () Bool)

(assert (=> b!1603 (= e!900 call!276)))

(declare-fun b!1604 () Bool)

(declare-fun e!899 () Bool)

(assert (=> b!1604 (= e!899 e!901)))

(declare-fun res!836 () Bool)

(assert (=> b!1604 (= res!836 (isBlack!0 (left!8 (right!8 (right!8 (right!8 lt!5))))))))

(assert (=> b!1604 (=> (not res!836) (not e!901))))

(declare-fun b!1605 () Bool)

(assert (=> b!1605 (= e!902 e!899)))

(declare-fun c!420 () Bool)

(assert (=> b!1605 (= c!420 ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 lt!5))))))))

(declare-fun b!1606 () Bool)

(assert (=> b!1606 (= e!899 e!900)))

(declare-fun res!837 () Bool)

(assert (=> b!1606 (= res!837 call!277)))

(assert (=> b!1606 (=> (not res!837) (not e!900))))

(assert (= (and d!975 (not res!838)) b!1605))

(assert (= (and b!1605 c!420) b!1606))

(assert (= (and b!1605 (not c!420)) b!1604))

(assert (= (and b!1606 res!837) b!1603))

(assert (= (and b!1604 res!836) b!1602))

(assert (= (and b!1602 res!839) b!1600))

(assert (= (and b!1600 res!840) b!1601))

(assert (= (or b!1606 b!1600) bm!276))

(assert (= (or b!1603 b!1601) bm!277))

(declare-fun m!2351 () Bool)

(assert (=> bm!276 m!2351))

(declare-fun m!2353 () Bool)

(assert (=> bm!277 m!2353))

(declare-fun m!2355 () Bool)

(assert (=> b!1602 m!2355))

(declare-fun m!2357 () Bool)

(assert (=> b!1604 m!2357))

(assert (=> bm!119 d!975))

(declare-fun b!1607 () Bool)

(declare-fun res!845 () Bool)

(declare-fun call!279 () Bool)

(assert (=> b!1607 (= res!845 call!279)))

(declare-fun e!905 () Bool)

(assert (=> b!1607 (=> (not res!845) (not e!905))))

(declare-fun d!977 () Bool)

(declare-fun res!843 () Bool)

(declare-fun e!906 () Bool)

(assert (=> d!977 (=> res!843 e!906)))

(assert (=> d!977 (= res!843 ((_ is Empty!3) (right!8 (right!8 (right!8 (right!8 t!78))))))))

(assert (=> d!977 (= (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (right!8 t!78))))) e!906)))

(declare-fun b!1608 () Bool)

(declare-fun call!278 () Bool)

(assert (=> b!1608 (= e!905 call!278)))

(declare-fun bm!278 () Bool)

(assert (=> bm!278 (= call!279 (redNodesHaveBlackChildren!0 (left!8 (right!8 (right!8 (right!8 (right!8 t!78)))))))))

(declare-fun bm!279 () Bool)

(assert (=> bm!279 (= call!278 (redNodesHaveBlackChildren!0 (right!8 (right!8 (right!8 (right!8 (right!8 t!78)))))))))

(declare-fun b!1609 () Bool)

(declare-fun res!844 () Bool)

(assert (=> b!1609 (= res!844 (isBlack!0 (right!8 (right!8 (right!8 (right!8 (right!8 t!78)))))))))

(assert (=> b!1609 (=> (not res!844) (not e!905))))

(declare-fun b!1610 () Bool)

(declare-fun e!904 () Bool)

(assert (=> b!1610 (= e!904 call!278)))

(declare-fun b!1611 () Bool)

(declare-fun e!903 () Bool)

(assert (=> b!1611 (= e!903 e!905)))

(declare-fun res!841 () Bool)

(assert (=> b!1611 (= res!841 (isBlack!0 (left!8 (right!8 (right!8 (right!8 (right!8 t!78)))))))))

(assert (=> b!1611 (=> (not res!841) (not e!905))))

(declare-fun b!1612 () Bool)

(assert (=> b!1612 (= e!906 e!903)))

(declare-fun c!421 () Bool)

(assert (=> b!1612 (= c!421 ((_ is Black!3) (color!6 (right!8 (right!8 (right!8 (right!8 t!78)))))))))

(declare-fun b!1613 () Bool)

(assert (=> b!1613 (= e!903 e!904)))

(declare-fun res!842 () Bool)

(assert (=> b!1613 (= res!842 call!279)))

(assert (=> b!1613 (=> (not res!842) (not e!904))))

(assert (= (and d!977 (not res!843)) b!1612))

(assert (= (and b!1612 c!421) b!1613))

(assert (= (and b!1612 (not c!421)) b!1611))

(assert (= (and b!1613 res!842) b!1610))

(assert (= (and b!1611 res!841) b!1609))

(assert (= (and b!1609 res!844) b!1607))

(assert (= (and b!1607 res!845) b!1608))

(assert (= (or b!1613 b!1607) bm!278))

(assert (= (or b!1610 b!1608) bm!279))

(declare-fun m!2359 () Bool)

(assert (=> bm!278 m!2359))

(declare-fun m!2361 () Bool)

(assert (=> bm!279 m!2361))

(declare-fun m!2363 () Bool)

(assert (=> b!1609 m!2363))

(declare-fun m!2365 () Bool)

(assert (=> b!1611 m!2365))

(assert (=> bm!93 d!977))

(assert (=> bm!98 d!551))

(check-sat (not bm!171) (not b!1444) (not b!971) (not bm!150) (not b!877) (not bm!145) (not bm!266) (not b!1109) (not b!1583) (not b!999) (not bm!250) (not bm!184) (not b!1387) (not b!1149) (not b!1044) (not bm!269) (not b!1213) (not b!1055) (not bm!152) (not bm!210) (not b!1485) (not b!1257) (not b!1432) (not b!1254) (not bm!179) (not b!1297) (not b!1383) (not b!876) (not b!1095) (not b!909) (not bm!262) (not b!1452) (not b!910) (not d!813) (not b!1229) (not b!979) (not bm!277) (not b!1231) (not bm!159) (not b!1062) (not bm!168) (not b!1270) (not b!1230) (not bm!203) (not b!1309) (not b!1513) (not b!1235) (not b!1029) (not bm!215) (not bm!267) (not b!947) (not b!1577) (not bm!263) (not b!1472) (not b!934) (not b!1107) (not bm!146) (not b!1506) (not b!1340) (not bm!174) (not b!1056) (not b!1597) (not bm!175) (not bm!190) (not b!1547) (not b!1224) (not bm!163) (not bm!187) (not b!1527) (not b!1362) (not b!1071) (not b!857) (not b!871) (not b!1539) (not b!1404) (not bm!252) (not b!1450) (not bm!276) (not bm!278) (not b!1364) (not b!1057) (not b!1604) (not b!1430) (not b!928) (not b!1031) (not bm!254) (not b!1369) (not b!1198) (not bm!268) (not b!1110) (not b!1141) (not b!911) (not bm!201) (not b!1325) (not b!1422) (not b!1454) (not b!1222) (not b!1236) (not bm!255) (not bm!166) (not bm!157) (not b!1207) (not b!1216) (not b!1129) (not b!1091) (not b!1265) (not bm!148) (not b!1190) (not b!1566) (not bm!204) (not b!1027) (not b!1503) (not b!1515) (not b!1371) (not b!1611) (not b!918) (not b!1012) (not b!1048) (not bm!144) (not b!851) (not bm!208) (not b!1351) (not b!1211) (not b!1334) (not b!931) (not b!1589) (not b!1501) (not b!1139) (not b!1073) (not b!1529) (not bm!239) (not b!1173) (not b!921) (not bm!233) (not bm!248) (not bm!162) (not b!949) (not b!1476) (not b!899) (not b!1359) (not bm!199) (not bm!253) (not b!1337) (not b!1245) (not b!1103) (not bm!173) (not bm!197) (not b!1508) (not b!1200) (not b!941) (not b!1328) (not b!1259) (not b!929) (not b!1318) (not b!1437) (not b!1134) (not b!1026) (not bm!216) (not b!861) (not b!1459) (not bm!249) (not bm!240) (not bm!185) (not b!1353) (not b!1434) (not b!926) (not b!936) (not b!1587) (not bm!251) (not b!1533) (not b!1242) (not b!917) (not b!1050) (not bm!193) (not bm!207) (not b!1112) (not bm!237) (not bm!214) (not bm!228) (not b!1299) (not b!1402) (not bm!165) (not bm!224) (not bm!275) (not b!1117) (not b!1193) (not bm!158) (not bm!191) (not b!961) (not b!1281) (not bm!212) (not b!977) (not b!1385) (not b!878) (not bm!209) (not b!1084) (not b!1025) (not b!1475) (not bm!257) (not b!1187) (not b!1463) (not b!1322) (not b!1579) (not b!1172) (not b!1348) (not b!1175) (not b!1269) (not bm!169) (not b!1145) (not b!1247) (not b!1602) (not b!997) (not b!1005) (not bm!192) (not bm!274) (not b!1003) (not b!1233) (not bm!164) (not b!1040) (not b!1461) (not bm!261) (not b!963) (not b!1537) (not b!1327) (not b!1125) (not b!873) (not b!1345) (not b!1099) (not bm!170) (not b!1332) (not b!1335) (not b!1342) (not b!913) (not bm!264) (not b!1311) (not bm!271) (not bm!160) (not b!1455) (not b!1446) (not bm!156) (not b!1167) (not b!1557) (not bm!181) (not b!1267) (not b!1052) (not bm!198) (not b!1558) (not bm!244) (not b!1105) (not bm!247) (not bm!194) (not b!1275) (not b!962) (not b!1483) (not bm!270) (not b!1268) (not bm!272) (not bm!229) (not bm!220) (not b!1174) (not bm!151) (not bm!242) (not b!1119) (not b!1010) (not b!1284) (not b!1563) (not bm!243) (not b!1572) (not bm!256) (not bm!186) (not bm!219) (not b!1147) (not b!1150) (not bm!196) (not bm!265) (not bm!223) (not b!906) (not bm!217) (not b!984) (not bm!231) (not bm!149) (not b!1054) (not bm!147) (not b!1094) (not bm!182) (not b!1486) (not b!1170) (not b!1323) (not b!1252) (not b!1398) (not bm!202) (not bm!245) (not b!953) (not b!1035) (not b!1568) (not b!1302) (not b!1497) (not b!1273) (not b!1545) (not b!916) (not b!1237) (not b!982) (not b!1609) (not b!1599) (not bm!241) (not bm!235) (not b!1559) (not b!959) (not bm!218) (not bm!200) (not b!864) (not b!1185) (not bm!221) (not b!1584) (not b!1466) (not b!1549) (not bm!211) (not b!1406) (not b!849) (not b!1171) (not b!1033) (not bm!189) (not bm!153) (not b!927) (not b!1218) (not b!1389) (not b!1169) (not bm!234) (not bm!225) (not b!1011) (not bm!238) (not b!1439) (not b!1354) (not b!1316) (not b!1357) (not bm!236) (not b!973) (not b!1330) (not bm!227) (not b!1153) (not b!1495) (not b!1194) (not b!1286) (not b!1078) (not b!1487) (not b!1038) (not bm!176) (not b!923) (not bm!183) (not b!904) (not b!1080) (not b!1180) (not bm!161) (not b!1413) (not b!1298) (not b!1321) (not b!1561) (not b!1520) (not b!1258) (not b!1411) (not bm!230) (not b!1060) (not bm!177) (not b!859) (not b!1424) (not b!1114) (not b!1522) (not bm!167) (not b!951) (not bm!178) (not b!1155) (not bm!258) (not d!727) (not b!1195) (not b!1543) (not b!1329) (not b!1192) (not b!957) (not b!1127) (not b!943) (not b!1101) (not b!844) (not bm!259) (not bm!154) (not bm!273) (not b!1574) (not b!842) (not b!1205) (not b!1279) (not b!866) (not b!1093) (not bm!222) (not b!1238) (not b!1083) (not b!1085) (not b!1148) (not b!1453) (not bm!213) (not b!1468) (not b!1097) (not b!1046) (not b!1396) (not b!930) (not bm!155) (not b!1123) (not b!1178) (not b!1474) (not bm!206) (not bm!180) (not b!855) (not bm!195) (not b!1428) (not bm!260) (not b!1477) (not bm!205) (not b!1488) (not b!1532) (not b!1108) (not b!955) (not b!1240) (not b!1132) (not b!915) (not b!1554) (not bm!226) (not b!1336) (not b!1552) (not bm!279) (not b!1304) (not bm!172) (not b!964) (not b!1408) (not b!1534) (not bm!188) (not b!897) (not b!1457) (not b!1191) (not bm!232) (not b!1582) (not bm!246))
(get-model)

