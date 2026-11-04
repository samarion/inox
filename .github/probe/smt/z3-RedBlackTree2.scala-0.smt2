; Options: -in -smt2
(set-option :produce-unsat-assumptions true)

(declare-fun start!2 () Bool)

(assert start!2)

(declare-fun res!73 () Bool)

(declare-fun e!18 () Bool)

(assert (=> start!2 (=> (not res!73) (not e!18))))

(declare-datatypes ((Color!2 0))(
  ( (Red!2) (Black!2) )
))
(declare-datatypes ((Tree!2 0))(
  ( (Empty!2) (Node!2 (color!5 Color!2) (left!7 Tree!2) (value!36 (_ BitVec 32)) (right!7 Tree!2)) )
))
(declare-fun t!78 () Tree!2)

(declare-fun redNodesHaveBlackChildren!0 (Tree!2) Bool)

(assert (=> start!2 (= res!73 (redNodesHaveBlackChildren!0 t!78))))

(assert (=> start!2 e!18))

(assert (=> start!2 true))

(declare-fun b!16 () Bool)

(declare-fun blackBalanced!0 (Tree!2) Bool)

(assert (=> b!16 (= e!18 (not (blackBalanced!0 t!78)))))

(assert (= (and start!2 res!73) b!16))

(declare-fun m!1 () Bool)

(assert (=> start!2 m!1))

(declare-fun m!3 () Bool)

(assert (=> b!16 m!3))

(check-sat (not b!16) (not start!2))
(check-sat)
(get-model)

(declare-fun d!5 () Bool)

(declare-fun res!81 () Bool)

(declare-fun e!24 () Bool)

(assert (=> d!5 (=> res!81 e!24)))

(get-info :version)

(assert (=> d!5 (= res!81 (not ((_ is Node!2) t!78)))))

(assert (=> d!5 (= (blackBalanced!0 t!78) e!24)))

(declare-fun b!23 () Bool)

(declare-fun e!23 () Bool)

(assert (=> b!23 (= e!24 e!23)))

(declare-fun res!82 () Bool)

(assert (=> b!23 (=> (not res!82) (not e!23))))

(assert (=> b!23 (= res!82 (blackBalanced!0 (left!7 t!78)))))

(declare-fun b!24 () Bool)

(declare-fun res!80 () Bool)

(assert (=> b!24 (=> (not res!80) (not e!23))))

(assert (=> b!24 (= res!80 (blackBalanced!0 (right!7 t!78)))))

(declare-fun b!25 () Bool)

(declare-fun blackHeight!0 (Tree!2) (_ BitVec 32))

(assert (=> b!25 (= e!23 (= (blackHeight!0 (left!7 t!78)) (blackHeight!0 (right!7 t!78))))))

(assert (= (and d!5 (not res!81)) b!23))

(assert (= (and b!23 res!82) b!24))

(assert (= (and b!24 res!80) b!25))

(declare-fun m!5 () Bool)

(assert (=> b!23 m!5))

(declare-fun m!7 () Bool)

(assert (=> b!24 m!7))

(declare-fun m!9 () Bool)

(assert (=> b!25 m!9))

(declare-fun m!11 () Bool)

(assert (=> b!25 m!11))

(assert (=> b!16 d!5))

(declare-fun bm!4 () Bool)

(declare-fun call!4 () Bool)

(assert (=> bm!4 (= call!4 (redNodesHaveBlackChildren!0 (left!7 t!78)))))

(declare-fun d!7 () Bool)

(declare-fun res!95 () Bool)

(declare-fun e!36 () Bool)

(assert (=> d!7 (=> res!95 e!36)))

(assert (=> d!7 (= res!95 ((_ is Empty!2) t!78))))

(assert (=> d!7 (= (redNodesHaveBlackChildren!0 t!78) e!36)))

(declare-fun b!40 () Bool)

(declare-fun res!94 () Bool)

(declare-fun isBlack!0 (Tree!2) Bool)

(assert (=> b!40 (= res!94 (isBlack!0 (right!7 t!78)))))

(declare-fun e!34 () Bool)

(assert (=> b!40 (=> (not res!94) (not e!34))))

(declare-fun b!41 () Bool)

(declare-fun e!35 () Bool)

(assert (=> b!41 (= e!35 e!34)))

(declare-fun res!97 () Bool)

(assert (=> b!41 (= res!97 (isBlack!0 (left!7 t!78)))))

(assert (=> b!41 (=> (not res!97) (not e!34))))

(declare-fun b!42 () Bool)

(declare-fun res!96 () Bool)

(assert (=> b!42 (= res!96 call!4)))

(assert (=> b!42 (=> (not res!96) (not e!34))))

(declare-fun b!43 () Bool)

(declare-fun e!33 () Bool)

(assert (=> b!43 (= e!35 e!33)))

(declare-fun res!93 () Bool)

(assert (=> b!43 (= res!93 call!4)))

(assert (=> b!43 (=> (not res!93) (not e!33))))

(declare-fun b!44 () Bool)

(assert (=> b!44 (= e!36 e!35)))

(declare-fun c!11 () Bool)

(assert (=> b!44 (= c!11 ((_ is Black!2) (color!5 t!78)))))

(declare-fun b!45 () Bool)

(declare-fun call!5 () Bool)

(assert (=> b!45 (= e!34 call!5)))

(declare-fun bm!5 () Bool)

(assert (=> bm!5 (= call!5 (redNodesHaveBlackChildren!0 (right!7 t!78)))))

(declare-fun b!46 () Bool)

(assert (=> b!46 (= e!33 call!5)))

(assert (= (and d!7 (not res!95)) b!44))

(assert (= (and b!44 c!11) b!43))

(assert (= (and b!44 (not c!11)) b!41))

(assert (= (and b!43 res!93) b!46))

(assert (= (and b!41 res!97) b!40))

(assert (= (and b!40 res!94) b!42))

(assert (= (and b!42 res!96) b!45))

(assert (= (or b!43 b!42) bm!4))

(assert (= (or b!46 b!45) bm!5))

(declare-fun m!13 () Bool)

(assert (=> bm!4 m!13))

(declare-fun m!15 () Bool)

(assert (=> b!40 m!15))

(declare-fun m!17 () Bool)

(assert (=> b!41 m!17))

(declare-fun m!19 () Bool)

(assert (=> bm!5 m!19))

(assert (=> start!2 d!7))

(check-sat (not b!41) (not b!25) (not b!23) (not bm!4) (not bm!5) (not b!40) (not b!24))
(check-sat)
(get-model)

(declare-fun bm!6 () Bool)

(declare-fun call!6 () Bool)

(assert (=> bm!6 (= call!6 (redNodesHaveBlackChildren!0 (left!7 (right!7 t!78))))))

(declare-fun d!9 () Bool)

(declare-fun res!100 () Bool)

(declare-fun e!40 () Bool)

(assert (=> d!9 (=> res!100 e!40)))

(assert (=> d!9 (= res!100 ((_ is Empty!2) (right!7 t!78)))))

(assert (=> d!9 (= (redNodesHaveBlackChildren!0 (right!7 t!78)) e!40)))

(declare-fun b!47 () Bool)

(declare-fun res!99 () Bool)

(assert (=> b!47 (= res!99 (isBlack!0 (right!7 (right!7 t!78))))))

(declare-fun e!38 () Bool)

(assert (=> b!47 (=> (not res!99) (not e!38))))

(declare-fun b!48 () Bool)

(declare-fun e!39 () Bool)

(assert (=> b!48 (= e!39 e!38)))

(declare-fun res!102 () Bool)

(assert (=> b!48 (= res!102 (isBlack!0 (left!7 (right!7 t!78))))))

(assert (=> b!48 (=> (not res!102) (not e!38))))

(declare-fun b!49 () Bool)

(declare-fun res!101 () Bool)

(assert (=> b!49 (= res!101 call!6)))

(assert (=> b!49 (=> (not res!101) (not e!38))))

(declare-fun b!50 () Bool)

(declare-fun e!37 () Bool)

(assert (=> b!50 (= e!39 e!37)))

(declare-fun res!98 () Bool)

(assert (=> b!50 (= res!98 call!6)))

(assert (=> b!50 (=> (not res!98) (not e!37))))

(declare-fun b!51 () Bool)

(assert (=> b!51 (= e!40 e!39)))

(declare-fun c!12 () Bool)

(assert (=> b!51 (= c!12 ((_ is Black!2) (color!5 (right!7 t!78))))))

(declare-fun b!52 () Bool)

(declare-fun call!7 () Bool)

(assert (=> b!52 (= e!38 call!7)))

(declare-fun bm!7 () Bool)

(assert (=> bm!7 (= call!7 (redNodesHaveBlackChildren!0 (right!7 (right!7 t!78))))))

(declare-fun b!53 () Bool)

(assert (=> b!53 (= e!37 call!7)))

(assert (= (and d!9 (not res!100)) b!51))

(assert (= (and b!51 c!12) b!50))

(assert (= (and b!51 (not c!12)) b!48))

(assert (= (and b!50 res!98) b!53))

(assert (= (and b!48 res!102) b!47))

(assert (= (and b!47 res!99) b!49))

(assert (= (and b!49 res!101) b!52))

(assert (= (or b!50 b!49) bm!6))

(assert (= (or b!53 b!52) bm!7))

(declare-fun m!21 () Bool)

(assert (=> bm!6 m!21))

(declare-fun m!23 () Bool)

(assert (=> b!47 m!23))

(declare-fun m!25 () Bool)

(assert (=> b!48 m!25))

(declare-fun m!27 () Bool)

(assert (=> bm!7 m!27))

(assert (=> bm!5 d!9))

(declare-fun d!11 () Bool)

(assert (=> d!11 (= (isBlack!0 (left!7 t!78)) (or ((_ is Empty!2) (left!7 t!78)) ((_ is Black!2) (color!5 (left!7 t!78)))))))

(assert (=> b!41 d!11))

(declare-fun d!13 () Bool)

(assert (=> d!13 (= (isBlack!0 (right!7 t!78)) (or ((_ is Empty!2) (right!7 t!78)) ((_ is Black!2) (color!5 (right!7 t!78)))))))

(assert (=> b!40 d!13))

(declare-fun b!62 () Bool)

(declare-fun e!45 () (_ BitVec 32))

(declare-fun e!46 () (_ BitVec 32))

(assert (=> b!62 (= e!45 e!46)))

(declare-fun c!17 () Bool)

(assert (=> b!62 (= c!17 ((_ is Black!2) (color!5 (left!7 t!78))))))

(declare-fun b!63 () Bool)

(assert (=> b!63 (= e!45 #b00000000000000000000000000000001)))

(declare-fun b!64 () Bool)

(declare-fun call!10 () (_ BitVec 32))

(assert (=> b!64 (= e!46 (bvadd call!10 #b00000000000000000000000000000001))))

(declare-fun b!65 () Bool)

(assert (=> b!65 (= e!46 call!10)))

(declare-fun bm!10 () Bool)

(assert (=> bm!10 (= call!10 (blackHeight!0 (left!7 (left!7 t!78))))))

(declare-fun d!15 () Bool)

(declare-fun c!18 () Bool)

(assert (=> d!15 (= c!18 ((_ is Empty!2) (left!7 t!78)))))

(assert (=> d!15 (= (blackHeight!0 (left!7 t!78)) e!45)))

(assert (= (and d!15 c!18) b!63))

(assert (= (and d!15 (not c!18)) b!62))

(assert (= (and b!62 c!17) b!64))

(assert (= (and b!62 (not c!17)) b!65))

(assert (= (or b!64 b!65) bm!10))

(declare-fun m!29 () Bool)

(assert (=> bm!10 m!29))

(assert (=> b!25 d!15))

(declare-fun b!66 () Bool)

(declare-fun e!47 () (_ BitVec 32))

(declare-fun e!48 () (_ BitVec 32))

(assert (=> b!66 (= e!47 e!48)))

(declare-fun c!19 () Bool)

(assert (=> b!66 (= c!19 ((_ is Black!2) (color!5 (right!7 t!78))))))

(declare-fun b!67 () Bool)

(assert (=> b!67 (= e!47 #b00000000000000000000000000000001)))

(declare-fun b!68 () Bool)

(declare-fun call!11 () (_ BitVec 32))

(assert (=> b!68 (= e!48 (bvadd call!11 #b00000000000000000000000000000001))))

(declare-fun b!69 () Bool)

(assert (=> b!69 (= e!48 call!11)))

(declare-fun bm!11 () Bool)

(assert (=> bm!11 (= call!11 (blackHeight!0 (left!7 (right!7 t!78))))))

(declare-fun d!17 () Bool)

(declare-fun c!20 () Bool)

(assert (=> d!17 (= c!20 ((_ is Empty!2) (right!7 t!78)))))

(assert (=> d!17 (= (blackHeight!0 (right!7 t!78)) e!47)))

(assert (= (and d!17 c!20) b!67))

(assert (= (and d!17 (not c!20)) b!66))

(assert (= (and b!66 c!19) b!68))

(assert (= (and b!66 (not c!19)) b!69))

(assert (= (or b!68 b!69) bm!11))

(declare-fun m!31 () Bool)

(assert (=> bm!11 m!31))

(assert (=> b!25 d!17))

(declare-fun d!19 () Bool)

(declare-fun res!104 () Bool)

(declare-fun e!50 () Bool)

(assert (=> d!19 (=> res!104 e!50)))

(assert (=> d!19 (= res!104 (not ((_ is Node!2) (right!7 t!78))))))

(assert (=> d!19 (= (blackBalanced!0 (right!7 t!78)) e!50)))

(declare-fun b!70 () Bool)

(declare-fun e!49 () Bool)

(assert (=> b!70 (= e!50 e!49)))

(declare-fun res!105 () Bool)

(assert (=> b!70 (=> (not res!105) (not e!49))))

(assert (=> b!70 (= res!105 (blackBalanced!0 (left!7 (right!7 t!78))))))

(declare-fun b!71 () Bool)

(declare-fun res!103 () Bool)

(assert (=> b!71 (=> (not res!103) (not e!49))))

(assert (=> b!71 (= res!103 (blackBalanced!0 (right!7 (right!7 t!78))))))

(declare-fun b!72 () Bool)

(assert (=> b!72 (= e!49 (= (blackHeight!0 (left!7 (right!7 t!78))) (blackHeight!0 (right!7 (right!7 t!78)))))))

(assert (= (and d!19 (not res!104)) b!70))

(assert (= (and b!70 res!105) b!71))

(assert (= (and b!71 res!103) b!72))

(declare-fun m!33 () Bool)

(assert (=> b!70 m!33))

(declare-fun m!35 () Bool)

(assert (=> b!71 m!35))

(assert (=> b!72 m!31))

(declare-fun m!37 () Bool)

(assert (=> b!72 m!37))

(assert (=> b!24 d!19))

(declare-fun bm!12 () Bool)

(declare-fun call!12 () Bool)

(assert (=> bm!12 (= call!12 (redNodesHaveBlackChildren!0 (left!7 (left!7 t!78))))))

(declare-fun d!21 () Bool)

(declare-fun res!108 () Bool)

(declare-fun e!54 () Bool)

(assert (=> d!21 (=> res!108 e!54)))

(assert (=> d!21 (= res!108 ((_ is Empty!2) (left!7 t!78)))))

(assert (=> d!21 (= (redNodesHaveBlackChildren!0 (left!7 t!78)) e!54)))

(declare-fun b!73 () Bool)

(declare-fun res!107 () Bool)

(assert (=> b!73 (= res!107 (isBlack!0 (right!7 (left!7 t!78))))))

(declare-fun e!52 () Bool)

(assert (=> b!73 (=> (not res!107) (not e!52))))

(declare-fun b!74 () Bool)

(declare-fun e!53 () Bool)

(assert (=> b!74 (= e!53 e!52)))

(declare-fun res!110 () Bool)

(assert (=> b!74 (= res!110 (isBlack!0 (left!7 (left!7 t!78))))))

(assert (=> b!74 (=> (not res!110) (not e!52))))

(declare-fun b!75 () Bool)

(declare-fun res!109 () Bool)

(assert (=> b!75 (= res!109 call!12)))

(assert (=> b!75 (=> (not res!109) (not e!52))))

(declare-fun b!76 () Bool)

(declare-fun e!51 () Bool)

(assert (=> b!76 (= e!53 e!51)))

(declare-fun res!106 () Bool)

(assert (=> b!76 (= res!106 call!12)))

(assert (=> b!76 (=> (not res!106) (not e!51))))

(declare-fun b!77 () Bool)

(assert (=> b!77 (= e!54 e!53)))

(declare-fun c!21 () Bool)

(assert (=> b!77 (= c!21 ((_ is Black!2) (color!5 (left!7 t!78))))))

(declare-fun b!78 () Bool)

(declare-fun call!13 () Bool)

(assert (=> b!78 (= e!52 call!13)))

(declare-fun bm!13 () Bool)

(assert (=> bm!13 (= call!13 (redNodesHaveBlackChildren!0 (right!7 (left!7 t!78))))))

(declare-fun b!79 () Bool)

(assert (=> b!79 (= e!51 call!13)))

(assert (= (and d!21 (not res!108)) b!77))

(assert (= (and b!77 c!21) b!76))

(assert (= (and b!77 (not c!21)) b!74))

(assert (= (and b!76 res!106) b!79))

(assert (= (and b!74 res!110) b!73))

(assert (= (and b!73 res!107) b!75))

(assert (= (and b!75 res!109) b!78))

(assert (= (or b!76 b!75) bm!12))

(assert (= (or b!79 b!78) bm!13))

(declare-fun m!39 () Bool)

(assert (=> bm!12 m!39))

(declare-fun m!41 () Bool)

(assert (=> b!73 m!41))

(declare-fun m!43 () Bool)

(assert (=> b!74 m!43))

(declare-fun m!45 () Bool)

(assert (=> bm!13 m!45))

(assert (=> bm!4 d!21))

(declare-fun d!23 () Bool)

(declare-fun res!112 () Bool)

(declare-fun e!56 () Bool)

(assert (=> d!23 (=> res!112 e!56)))

(assert (=> d!23 (= res!112 (not ((_ is Node!2) (left!7 t!78))))))

(assert (=> d!23 (= (blackBalanced!0 (left!7 t!78)) e!56)))

(declare-fun b!80 () Bool)

(declare-fun e!55 () Bool)

(assert (=> b!80 (= e!56 e!55)))

(declare-fun res!113 () Bool)

(assert (=> b!80 (=> (not res!113) (not e!55))))

(assert (=> b!80 (= res!113 (blackBalanced!0 (left!7 (left!7 t!78))))))

(declare-fun b!81 () Bool)

(declare-fun res!111 () Bool)

(assert (=> b!81 (=> (not res!111) (not e!55))))

(assert (=> b!81 (= res!111 (blackBalanced!0 (right!7 (left!7 t!78))))))

(declare-fun b!82 () Bool)

(assert (=> b!82 (= e!55 (= (blackHeight!0 (left!7 (left!7 t!78))) (blackHeight!0 (right!7 (left!7 t!78)))))))

(assert (= (and d!23 (not res!112)) b!80))

(assert (= (and b!80 res!113) b!81))

(assert (= (and b!81 res!111) b!82))

(declare-fun m!47 () Bool)

(assert (=> b!80 m!47))

(declare-fun m!49 () Bool)

(assert (=> b!81 m!49))

(assert (=> b!82 m!29))

(declare-fun m!51 () Bool)

(assert (=> b!82 m!51))

(assert (=> b!23 d!23))

(check-sat (not b!74) (not b!73) (not b!82) (not b!81) (not bm!11) (not bm!6) (not bm!13) (not b!70) (not b!71) (not b!47) (not bm!7) (not b!48) (not bm!10) (not b!80) (not b!72) (not bm!12))
(check-sat)
(get-model)

(declare-fun b!83 () Bool)

(declare-fun e!57 () (_ BitVec 32))

(declare-fun e!58 () (_ BitVec 32))

(assert (=> b!83 (= e!57 e!58)))

(declare-fun c!22 () Bool)

(assert (=> b!83 (= c!22 ((_ is Black!2) (color!5 (left!7 (left!7 t!78)))))))

(declare-fun b!84 () Bool)

(assert (=> b!84 (= e!57 #b00000000000000000000000000000001)))

(declare-fun b!85 () Bool)

(declare-fun call!14 () (_ BitVec 32))

(assert (=> b!85 (= e!58 (bvadd call!14 #b00000000000000000000000000000001))))

(declare-fun b!86 () Bool)

(assert (=> b!86 (= e!58 call!14)))

(declare-fun bm!14 () Bool)

(assert (=> bm!14 (= call!14 (blackHeight!0 (left!7 (left!7 (left!7 t!78)))))))

(declare-fun d!25 () Bool)

(declare-fun c!23 () Bool)

(assert (=> d!25 (= c!23 ((_ is Empty!2) (left!7 (left!7 t!78))))))

(assert (=> d!25 (= (blackHeight!0 (left!7 (left!7 t!78))) e!57)))

(assert (= (and d!25 c!23) b!84))

(assert (= (and d!25 (not c!23)) b!83))

(assert (= (and b!83 c!22) b!85))

(assert (= (and b!83 (not c!22)) b!86))

(assert (= (or b!85 b!86) bm!14))

(declare-fun m!53 () Bool)

(assert (=> bm!14 m!53))

(assert (=> b!82 d!25))

(declare-fun b!87 () Bool)

(declare-fun e!59 () (_ BitVec 32))

(declare-fun e!60 () (_ BitVec 32))

(assert (=> b!87 (= e!59 e!60)))

(declare-fun c!24 () Bool)

(assert (=> b!87 (= c!24 ((_ is Black!2) (color!5 (right!7 (left!7 t!78)))))))

(declare-fun b!88 () Bool)

(assert (=> b!88 (= e!59 #b00000000000000000000000000000001)))

(declare-fun b!89 () Bool)

(declare-fun call!15 () (_ BitVec 32))

(assert (=> b!89 (= e!60 (bvadd call!15 #b00000000000000000000000000000001))))

(declare-fun b!90 () Bool)

(assert (=> b!90 (= e!60 call!15)))

(declare-fun bm!15 () Bool)

(assert (=> bm!15 (= call!15 (blackHeight!0 (left!7 (right!7 (left!7 t!78)))))))

(declare-fun d!27 () Bool)

(declare-fun c!25 () Bool)

(assert (=> d!27 (= c!25 ((_ is Empty!2) (right!7 (left!7 t!78))))))

(assert (=> d!27 (= (blackHeight!0 (right!7 (left!7 t!78))) e!59)))

(assert (= (and d!27 c!25) b!88))

(assert (= (and d!27 (not c!25)) b!87))

(assert (= (and b!87 c!24) b!89))

(assert (= (and b!87 (not c!24)) b!90))

(assert (= (or b!89 b!90) bm!15))

(declare-fun m!55 () Bool)

(assert (=> bm!15 m!55))

(assert (=> b!82 d!27))

(declare-fun d!29 () Bool)

(declare-fun res!115 () Bool)

(declare-fun e!62 () Bool)

(assert (=> d!29 (=> res!115 e!62)))

(assert (=> d!29 (= res!115 (not ((_ is Node!2) (right!7 (left!7 t!78)))))))

(assert (=> d!29 (= (blackBalanced!0 (right!7 (left!7 t!78))) e!62)))

(declare-fun b!91 () Bool)

(declare-fun e!61 () Bool)

(assert (=> b!91 (= e!62 e!61)))

(declare-fun res!116 () Bool)

(assert (=> b!91 (=> (not res!116) (not e!61))))

(assert (=> b!91 (= res!116 (blackBalanced!0 (left!7 (right!7 (left!7 t!78)))))))

(declare-fun b!92 () Bool)

(declare-fun res!114 () Bool)

(assert (=> b!92 (=> (not res!114) (not e!61))))

(assert (=> b!92 (= res!114 (blackBalanced!0 (right!7 (right!7 (left!7 t!78)))))))

(declare-fun b!93 () Bool)

(assert (=> b!93 (= e!61 (= (blackHeight!0 (left!7 (right!7 (left!7 t!78)))) (blackHeight!0 (right!7 (right!7 (left!7 t!78))))))))

(assert (= (and d!29 (not res!115)) b!91))

(assert (= (and b!91 res!116) b!92))

(assert (= (and b!92 res!114) b!93))

(declare-fun m!57 () Bool)

(assert (=> b!91 m!57))

(declare-fun m!59 () Bool)

(assert (=> b!92 m!59))

(assert (=> b!93 m!55))

(declare-fun m!61 () Bool)

(assert (=> b!93 m!61))

(assert (=> b!81 d!29))

(declare-fun d!31 () Bool)

(assert (=> d!31 (= (isBlack!0 (left!7 (right!7 t!78))) (or ((_ is Empty!2) (left!7 (right!7 t!78))) ((_ is Black!2) (color!5 (left!7 (right!7 t!78))))))))

(assert (=> b!48 d!31))

(declare-fun d!33 () Bool)

(declare-fun res!118 () Bool)

(declare-fun e!64 () Bool)

(assert (=> d!33 (=> res!118 e!64)))

(assert (=> d!33 (= res!118 (not ((_ is Node!2) (left!7 (left!7 t!78)))))))

(assert (=> d!33 (= (blackBalanced!0 (left!7 (left!7 t!78))) e!64)))

(declare-fun b!94 () Bool)

(declare-fun e!63 () Bool)

(assert (=> b!94 (= e!64 e!63)))

(declare-fun res!119 () Bool)

(assert (=> b!94 (=> (not res!119) (not e!63))))

(assert (=> b!94 (= res!119 (blackBalanced!0 (left!7 (left!7 (left!7 t!78)))))))

(declare-fun b!95 () Bool)

(declare-fun res!117 () Bool)

(assert (=> b!95 (=> (not res!117) (not e!63))))

(assert (=> b!95 (= res!117 (blackBalanced!0 (right!7 (left!7 (left!7 t!78)))))))

(declare-fun b!96 () Bool)

(assert (=> b!96 (= e!63 (= (blackHeight!0 (left!7 (left!7 (left!7 t!78)))) (blackHeight!0 (right!7 (left!7 (left!7 t!78))))))))

(assert (= (and d!33 (not res!118)) b!94))

(assert (= (and b!94 res!119) b!95))

(assert (= (and b!95 res!117) b!96))

(declare-fun m!63 () Bool)

(assert (=> b!94 m!63))

(declare-fun m!65 () Bool)

(assert (=> b!95 m!65))

(assert (=> b!96 m!53))

(declare-fun m!67 () Bool)

(assert (=> b!96 m!67))

(assert (=> b!80 d!33))

(declare-fun d!35 () Bool)

(assert (=> d!35 (= (isBlack!0 (right!7 (right!7 t!78))) (or ((_ is Empty!2) (right!7 (right!7 t!78))) ((_ is Black!2) (color!5 (right!7 (right!7 t!78))))))))

(assert (=> b!47 d!35))

(declare-fun bm!16 () Bool)

(declare-fun call!16 () Bool)

(assert (=> bm!16 (= call!16 (redNodesHaveBlackChildren!0 (left!7 (right!7 (left!7 t!78)))))))

(declare-fun d!37 () Bool)

(declare-fun res!122 () Bool)

(declare-fun e!68 () Bool)

(assert (=> d!37 (=> res!122 e!68)))

(assert (=> d!37 (= res!122 ((_ is Empty!2) (right!7 (left!7 t!78))))))

(assert (=> d!37 (= (redNodesHaveBlackChildren!0 (right!7 (left!7 t!78))) e!68)))

(declare-fun b!97 () Bool)

(declare-fun res!121 () Bool)

(assert (=> b!97 (= res!121 (isBlack!0 (right!7 (right!7 (left!7 t!78)))))))

(declare-fun e!66 () Bool)

(assert (=> b!97 (=> (not res!121) (not e!66))))

(declare-fun b!98 () Bool)

(declare-fun e!67 () Bool)

(assert (=> b!98 (= e!67 e!66)))

(declare-fun res!124 () Bool)

(assert (=> b!98 (= res!124 (isBlack!0 (left!7 (right!7 (left!7 t!78)))))))

(assert (=> b!98 (=> (not res!124) (not e!66))))

(declare-fun b!99 () Bool)

(declare-fun res!123 () Bool)

(assert (=> b!99 (= res!123 call!16)))

(assert (=> b!99 (=> (not res!123) (not e!66))))

(declare-fun b!100 () Bool)

(declare-fun e!65 () Bool)

(assert (=> b!100 (= e!67 e!65)))

(declare-fun res!120 () Bool)

(assert (=> b!100 (= res!120 call!16)))

(assert (=> b!100 (=> (not res!120) (not e!65))))

(declare-fun b!101 () Bool)

(assert (=> b!101 (= e!68 e!67)))

(declare-fun c!26 () Bool)

(assert (=> b!101 (= c!26 ((_ is Black!2) (color!5 (right!7 (left!7 t!78)))))))

(declare-fun b!102 () Bool)

(declare-fun call!17 () Bool)

(assert (=> b!102 (= e!66 call!17)))

(declare-fun bm!17 () Bool)

(assert (=> bm!17 (= call!17 (redNodesHaveBlackChildren!0 (right!7 (right!7 (left!7 t!78)))))))

(declare-fun b!103 () Bool)

(assert (=> b!103 (= e!65 call!17)))

(assert (= (and d!37 (not res!122)) b!101))

(assert (= (and b!101 c!26) b!100))

(assert (= (and b!101 (not c!26)) b!98))

(assert (= (and b!100 res!120) b!103))

(assert (= (and b!98 res!124) b!97))

(assert (= (and b!97 res!121) b!99))

(assert (= (and b!99 res!123) b!102))

(assert (= (or b!100 b!99) bm!16))

(assert (= (or b!103 b!102) bm!17))

(declare-fun m!69 () Bool)

(assert (=> bm!16 m!69))

(declare-fun m!71 () Bool)

(assert (=> b!97 m!71))

(declare-fun m!73 () Bool)

(assert (=> b!98 m!73))

(declare-fun m!75 () Bool)

(assert (=> bm!17 m!75))

(assert (=> bm!13 d!37))

(assert (=> bm!10 d!25))

(declare-fun b!104 () Bool)

(declare-fun e!69 () (_ BitVec 32))

(declare-fun e!70 () (_ BitVec 32))

(assert (=> b!104 (= e!69 e!70)))

(declare-fun c!27 () Bool)

(assert (=> b!104 (= c!27 ((_ is Black!2) (color!5 (left!7 (right!7 t!78)))))))

(declare-fun b!105 () Bool)

(assert (=> b!105 (= e!69 #b00000000000000000000000000000001)))

(declare-fun b!106 () Bool)

(declare-fun call!18 () (_ BitVec 32))

(assert (=> b!106 (= e!70 (bvadd call!18 #b00000000000000000000000000000001))))

(declare-fun b!107 () Bool)

(assert (=> b!107 (= e!70 call!18)))

(declare-fun bm!18 () Bool)

(assert (=> bm!18 (= call!18 (blackHeight!0 (left!7 (left!7 (right!7 t!78)))))))

(declare-fun d!39 () Bool)

(declare-fun c!28 () Bool)

(assert (=> d!39 (= c!28 ((_ is Empty!2) (left!7 (right!7 t!78))))))

(assert (=> d!39 (= (blackHeight!0 (left!7 (right!7 t!78))) e!69)))

(assert (= (and d!39 c!28) b!105))

(assert (= (and d!39 (not c!28)) b!104))

(assert (= (and b!104 c!27) b!106))

(assert (= (and b!104 (not c!27)) b!107))

(assert (= (or b!106 b!107) bm!18))

(declare-fun m!77 () Bool)

(assert (=> bm!18 m!77))

(assert (=> bm!11 d!39))

(declare-fun d!41 () Bool)

(declare-fun res!126 () Bool)

(declare-fun e!72 () Bool)

(assert (=> d!41 (=> res!126 e!72)))

(assert (=> d!41 (= res!126 (not ((_ is Node!2) (right!7 (right!7 t!78)))))))

(assert (=> d!41 (= (blackBalanced!0 (right!7 (right!7 t!78))) e!72)))

(declare-fun b!108 () Bool)

(declare-fun e!71 () Bool)

(assert (=> b!108 (= e!72 e!71)))

(declare-fun res!127 () Bool)

(assert (=> b!108 (=> (not res!127) (not e!71))))

(assert (=> b!108 (= res!127 (blackBalanced!0 (left!7 (right!7 (right!7 t!78)))))))

(declare-fun b!109 () Bool)

(declare-fun res!125 () Bool)

(assert (=> b!109 (=> (not res!125) (not e!71))))

(assert (=> b!109 (= res!125 (blackBalanced!0 (right!7 (right!7 (right!7 t!78)))))))

(declare-fun b!110 () Bool)

(assert (=> b!110 (= e!71 (= (blackHeight!0 (left!7 (right!7 (right!7 t!78)))) (blackHeight!0 (right!7 (right!7 (right!7 t!78))))))))

(assert (= (and d!41 (not res!126)) b!108))

(assert (= (and b!108 res!127) b!109))

(assert (= (and b!109 res!125) b!110))

(declare-fun m!79 () Bool)

(assert (=> b!108 m!79))

(declare-fun m!81 () Bool)

(assert (=> b!109 m!81))

(declare-fun m!83 () Bool)

(assert (=> b!110 m!83))

(declare-fun m!85 () Bool)

(assert (=> b!110 m!85))

(assert (=> b!71 d!41))

(declare-fun d!43 () Bool)

(declare-fun res!129 () Bool)

(declare-fun e!74 () Bool)

(assert (=> d!43 (=> res!129 e!74)))

(assert (=> d!43 (= res!129 (not ((_ is Node!2) (left!7 (right!7 t!78)))))))

(assert (=> d!43 (= (blackBalanced!0 (left!7 (right!7 t!78))) e!74)))

(declare-fun b!111 () Bool)

(declare-fun e!73 () Bool)

(assert (=> b!111 (= e!74 e!73)))

(declare-fun res!130 () Bool)

(assert (=> b!111 (=> (not res!130) (not e!73))))

(assert (=> b!111 (= res!130 (blackBalanced!0 (left!7 (left!7 (right!7 t!78)))))))

(declare-fun b!112 () Bool)

(declare-fun res!128 () Bool)

(assert (=> b!112 (=> (not res!128) (not e!73))))

(assert (=> b!112 (= res!128 (blackBalanced!0 (right!7 (left!7 (right!7 t!78)))))))

(declare-fun b!113 () Bool)

(assert (=> b!113 (= e!73 (= (blackHeight!0 (left!7 (left!7 (right!7 t!78)))) (blackHeight!0 (right!7 (left!7 (right!7 t!78))))))))

(assert (= (and d!43 (not res!129)) b!111))

(assert (= (and b!111 res!130) b!112))

(assert (= (and b!112 res!128) b!113))

(declare-fun m!87 () Bool)

(assert (=> b!111 m!87))

(declare-fun m!89 () Bool)

(assert (=> b!112 m!89))

(assert (=> b!113 m!77))

(declare-fun m!91 () Bool)

(assert (=> b!113 m!91))

(assert (=> b!70 d!43))

(declare-fun bm!19 () Bool)

(declare-fun call!19 () Bool)

(assert (=> bm!19 (= call!19 (redNodesHaveBlackChildren!0 (left!7 (right!7 (right!7 t!78)))))))

(declare-fun d!45 () Bool)

(declare-fun res!133 () Bool)

(declare-fun e!78 () Bool)

(assert (=> d!45 (=> res!133 e!78)))

(assert (=> d!45 (= res!133 ((_ is Empty!2) (right!7 (right!7 t!78))))))

(assert (=> d!45 (= (redNodesHaveBlackChildren!0 (right!7 (right!7 t!78))) e!78)))

(declare-fun b!114 () Bool)

(declare-fun res!132 () Bool)

(assert (=> b!114 (= res!132 (isBlack!0 (right!7 (right!7 (right!7 t!78)))))))

(declare-fun e!76 () Bool)

(assert (=> b!114 (=> (not res!132) (not e!76))))

(declare-fun b!115 () Bool)

(declare-fun e!77 () Bool)

(assert (=> b!115 (= e!77 e!76)))

(declare-fun res!135 () Bool)

(assert (=> b!115 (= res!135 (isBlack!0 (left!7 (right!7 (right!7 t!78)))))))

(assert (=> b!115 (=> (not res!135) (not e!76))))

(declare-fun b!116 () Bool)

(declare-fun res!134 () Bool)

(assert (=> b!116 (= res!134 call!19)))

(assert (=> b!116 (=> (not res!134) (not e!76))))

(declare-fun b!117 () Bool)

(declare-fun e!75 () Bool)

(assert (=> b!117 (= e!77 e!75)))

(declare-fun res!131 () Bool)

(assert (=> b!117 (= res!131 call!19)))

(assert (=> b!117 (=> (not res!131) (not e!75))))

(declare-fun b!118 () Bool)

(assert (=> b!118 (= e!78 e!77)))

(declare-fun c!29 () Bool)

(assert (=> b!118 (= c!29 ((_ is Black!2) (color!5 (right!7 (right!7 t!78)))))))

(declare-fun b!119 () Bool)

(declare-fun call!20 () Bool)

(assert (=> b!119 (= e!76 call!20)))

(declare-fun bm!20 () Bool)

(assert (=> bm!20 (= call!20 (redNodesHaveBlackChildren!0 (right!7 (right!7 (right!7 t!78)))))))

(declare-fun b!120 () Bool)

(assert (=> b!120 (= e!75 call!20)))

(assert (= (and d!45 (not res!133)) b!118))

(assert (= (and b!118 c!29) b!117))

(assert (= (and b!118 (not c!29)) b!115))

(assert (= (and b!117 res!131) b!120))

(assert (= (and b!115 res!135) b!114))

(assert (= (and b!114 res!132) b!116))

(assert (= (and b!116 res!134) b!119))

(assert (= (or b!117 b!116) bm!19))

(assert (= (or b!120 b!119) bm!20))

(declare-fun m!93 () Bool)

(assert (=> bm!19 m!93))

(declare-fun m!95 () Bool)

(assert (=> b!114 m!95))

(declare-fun m!97 () Bool)

(assert (=> b!115 m!97))

(declare-fun m!99 () Bool)

(assert (=> bm!20 m!99))

(assert (=> bm!7 d!45))

(declare-fun bm!21 () Bool)

(declare-fun call!21 () Bool)

(assert (=> bm!21 (= call!21 (redNodesHaveBlackChildren!0 (left!7 (left!7 (right!7 t!78)))))))

(declare-fun d!47 () Bool)

(declare-fun res!138 () Bool)

(declare-fun e!82 () Bool)

(assert (=> d!47 (=> res!138 e!82)))

(assert (=> d!47 (= res!138 ((_ is Empty!2) (left!7 (right!7 t!78))))))

(assert (=> d!47 (= (redNodesHaveBlackChildren!0 (left!7 (right!7 t!78))) e!82)))

(declare-fun b!121 () Bool)

(declare-fun res!137 () Bool)

(assert (=> b!121 (= res!137 (isBlack!0 (right!7 (left!7 (right!7 t!78)))))))

(declare-fun e!80 () Bool)

(assert (=> b!121 (=> (not res!137) (not e!80))))

(declare-fun b!122 () Bool)

(declare-fun e!81 () Bool)

(assert (=> b!122 (= e!81 e!80)))

(declare-fun res!140 () Bool)

(assert (=> b!122 (= res!140 (isBlack!0 (left!7 (left!7 (right!7 t!78)))))))

(assert (=> b!122 (=> (not res!140) (not e!80))))

(declare-fun b!123 () Bool)

(declare-fun res!139 () Bool)

(assert (=> b!123 (= res!139 call!21)))

(assert (=> b!123 (=> (not res!139) (not e!80))))

(declare-fun b!124 () Bool)

(declare-fun e!79 () Bool)

(assert (=> b!124 (= e!81 e!79)))

(declare-fun res!136 () Bool)

(assert (=> b!124 (= res!136 call!21)))

(assert (=> b!124 (=> (not res!136) (not e!79))))

(declare-fun b!125 () Bool)

(assert (=> b!125 (= e!82 e!81)))

(declare-fun c!30 () Bool)

(assert (=> b!125 (= c!30 ((_ is Black!2) (color!5 (left!7 (right!7 t!78)))))))

(declare-fun b!126 () Bool)

(declare-fun call!22 () Bool)

(assert (=> b!126 (= e!80 call!22)))

(declare-fun bm!22 () Bool)

(assert (=> bm!22 (= call!22 (redNodesHaveBlackChildren!0 (right!7 (left!7 (right!7 t!78)))))))

(declare-fun b!127 () Bool)

(assert (=> b!127 (= e!79 call!22)))

(assert (= (and d!47 (not res!138)) b!125))

(assert (= (and b!125 c!30) b!124))

(assert (= (and b!125 (not c!30)) b!122))

(assert (= (and b!124 res!136) b!127))

(assert (= (and b!122 res!140) b!121))

(assert (= (and b!121 res!137) b!123))

(assert (= (and b!123 res!139) b!126))

(assert (= (or b!124 b!123) bm!21))

(assert (= (or b!127 b!126) bm!22))

(declare-fun m!101 () Bool)

(assert (=> bm!21 m!101))

(declare-fun m!103 () Bool)

(assert (=> b!121 m!103))

(declare-fun m!105 () Bool)

(assert (=> b!122 m!105))

(declare-fun m!107 () Bool)

(assert (=> bm!22 m!107))

(assert (=> bm!6 d!47))

(declare-fun d!49 () Bool)

(assert (=> d!49 (= (isBlack!0 (left!7 (left!7 t!78))) (or ((_ is Empty!2) (left!7 (left!7 t!78))) ((_ is Black!2) (color!5 (left!7 (left!7 t!78))))))))

(assert (=> b!74 d!49))

(declare-fun d!51 () Bool)

(assert (=> d!51 (= (isBlack!0 (right!7 (left!7 t!78))) (or ((_ is Empty!2) (right!7 (left!7 t!78))) ((_ is Black!2) (color!5 (right!7 (left!7 t!78))))))))

(assert (=> b!73 d!51))

(assert (=> b!72 d!39))

(declare-fun b!128 () Bool)

(declare-fun e!83 () (_ BitVec 32))

(declare-fun e!84 () (_ BitVec 32))

(assert (=> b!128 (= e!83 e!84)))

(declare-fun c!31 () Bool)

(assert (=> b!128 (= c!31 ((_ is Black!2) (color!5 (right!7 (right!7 t!78)))))))

(declare-fun b!129 () Bool)

(assert (=> b!129 (= e!83 #b00000000000000000000000000000001)))

(declare-fun b!130 () Bool)

(declare-fun call!23 () (_ BitVec 32))

(assert (=> b!130 (= e!84 (bvadd call!23 #b00000000000000000000000000000001))))

(declare-fun b!131 () Bool)

(assert (=> b!131 (= e!84 call!23)))

(declare-fun bm!23 () Bool)

(assert (=> bm!23 (= call!23 (blackHeight!0 (left!7 (right!7 (right!7 t!78)))))))

(declare-fun d!53 () Bool)

(declare-fun c!32 () Bool)

(assert (=> d!53 (= c!32 ((_ is Empty!2) (right!7 (right!7 t!78))))))

(assert (=> d!53 (= (blackHeight!0 (right!7 (right!7 t!78))) e!83)))

(assert (= (and d!53 c!32) b!129))

(assert (= (and d!53 (not c!32)) b!128))

(assert (= (and b!128 c!31) b!130))

(assert (= (and b!128 (not c!31)) b!131))

(assert (= (or b!130 b!131) bm!23))

(assert (=> bm!23 m!83))

(assert (=> b!72 d!53))

(declare-fun bm!24 () Bool)

(declare-fun call!24 () Bool)

(assert (=> bm!24 (= call!24 (redNodesHaveBlackChildren!0 (left!7 (left!7 (left!7 t!78)))))))

(declare-fun d!55 () Bool)

(declare-fun res!143 () Bool)

(declare-fun e!88 () Bool)

(assert (=> d!55 (=> res!143 e!88)))

(assert (=> d!55 (= res!143 ((_ is Empty!2) (left!7 (left!7 t!78))))))

(assert (=> d!55 (= (redNodesHaveBlackChildren!0 (left!7 (left!7 t!78))) e!88)))

(declare-fun b!132 () Bool)

(declare-fun res!142 () Bool)

(assert (=> b!132 (= res!142 (isBlack!0 (right!7 (left!7 (left!7 t!78)))))))

(declare-fun e!86 () Bool)

(assert (=> b!132 (=> (not res!142) (not e!86))))

(declare-fun b!133 () Bool)

(declare-fun e!87 () Bool)

(assert (=> b!133 (= e!87 e!86)))

(declare-fun res!145 () Bool)

(assert (=> b!133 (= res!145 (isBlack!0 (left!7 (left!7 (left!7 t!78)))))))

(assert (=> b!133 (=> (not res!145) (not e!86))))

(declare-fun b!134 () Bool)

(declare-fun res!144 () Bool)

(assert (=> b!134 (= res!144 call!24)))

(assert (=> b!134 (=> (not res!144) (not e!86))))

(declare-fun b!135 () Bool)

(declare-fun e!85 () Bool)

(assert (=> b!135 (= e!87 e!85)))

(declare-fun res!141 () Bool)

(assert (=> b!135 (= res!141 call!24)))

(assert (=> b!135 (=> (not res!141) (not e!85))))

(declare-fun b!136 () Bool)

(assert (=> b!136 (= e!88 e!87)))

(declare-fun c!33 () Bool)

(assert (=> b!136 (= c!33 ((_ is Black!2) (color!5 (left!7 (left!7 t!78)))))))

(declare-fun b!137 () Bool)

(declare-fun call!25 () Bool)

(assert (=> b!137 (= e!86 call!25)))

(declare-fun bm!25 () Bool)

(assert (=> bm!25 (= call!25 (redNodesHaveBlackChildren!0 (right!7 (left!7 (left!7 t!78)))))))

(declare-fun b!138 () Bool)

(assert (=> b!138 (= e!85 call!25)))

(assert (= (and d!55 (not res!143)) b!136))

(assert (= (and b!136 c!33) b!135))

(assert (= (and b!136 (not c!33)) b!133))

(assert (= (and b!135 res!141) b!138))

(assert (= (and b!133 res!145) b!132))

(assert (= (and b!132 res!142) b!134))

(assert (= (and b!134 res!144) b!137))

(assert (= (or b!135 b!134) bm!24))

(assert (= (or b!138 b!137) bm!25))

(declare-fun m!109 () Bool)

(assert (=> bm!24 m!109))

(declare-fun m!111 () Bool)

(assert (=> b!132 m!111))

(declare-fun m!113 () Bool)

(assert (=> b!133 m!113))

(declare-fun m!115 () Bool)

(assert (=> bm!25 m!115))

(assert (=> bm!12 d!55))

(check-sat (not bm!16) (not bm!20) (not b!112) (not bm!15) (not b!111) (not b!97) (not b!133) (not bm!17) (not bm!18) (not bm!14) (not b!110) (not bm!21) (not bm!25) (not b!92) (not bm!22) (not b!93) (not b!108) (not b!98) (not b!95) (not b!115) (not b!132) (not b!113) (not bm!23) (not b!94) (not bm!24) (not b!91) (not b!109) (not b!122) (not b!96) (not b!114) (not b!121) (not bm!19))
(get-model)

