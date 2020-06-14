; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"


define void @second_store_smaller(i32* noalias %P) {
; CHECK-LABEL: @second_store_smaller(
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[P_I16:%.*]] = bitcast i32* [[P]] to i16*
; CHECK-NEXT:    store i16 0, i16* [[P_I16]], align 2
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  %P.i16 = bitcast i32* %P to i16*
  store i16 0, i16* %P.i16
  ret void
}


define void @second_store_bigger(i32* noalias %P) {
; CHECK-LABEL: @second_store_bigger(
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[P_I64:%.*]] = bitcast i32* [[P:%.*]] to i64*
; CHECK-NEXT:    store i64 0, i64* [[P_I64]], align 8
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  %P.i64 = bitcast i32* %P to i64*
  store i64 0, i64* %P.i64
  ret void
}
