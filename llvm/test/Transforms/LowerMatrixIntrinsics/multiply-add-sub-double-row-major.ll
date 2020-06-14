; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; RUN: opt -lower-matrix-intrinsics -matrix-default-layout=row-major -S < %s | FileCheck --check-prefix=RM %s

; Check row-major code generation for loads, stores, binary operators (fadd/fsub) and multiply.
; %a.ptr is a pointer to a 2x3 matrix, %b.ptr to a 3x2 matrix and %c.ptr to a 2x2 matrix.
; Load, store and binary operators on %a should operate on 3 element vectors and on 2 element vectors for %b.
define void @multiply_sub_add_2x3_3x2(<6 x double>* %a.ptr, <6 x double>* %b.ptr, <4 x double>* %c.ptr) {
; RM-LABEL: @multiply_sub_add_2x3_3x2(
; RM-NEXT:  entry:
; RM-NEXT:    [[TMP0:%.*]] = bitcast <6 x double>* [[A_PTR:%.*]] to double*
; RM-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[TMP0]] to <3 x double>*
; RM-NEXT:    [[COL_LOAD:%.*]] = load <3 x double>, <3 x double>* [[VEC_CAST]], align 8
; RM-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[TMP0]], i32 3
; RM-NEXT:    [[VEC_CAST1:%.*]] = bitcast double* [[VEC_GEP]] to <3 x double>*
; RM-NEXT:    [[COL_LOAD2:%.*]] = load <3 x double>, <3 x double>* [[VEC_CAST1]], align 8
; RM-NEXT:    [[TMP1:%.*]] = bitcast <6 x double>* [[B_PTR:%.*]] to double*
; RM-NEXT:    [[VEC_CAST3:%.*]] = bitcast double* [[TMP1]] to <2 x double>*
; RM-NEXT:    [[COL_LOAD4:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST3]], align 8
; RM-NEXT:    [[VEC_GEP5:%.*]] = getelementptr double, double* [[TMP1]], i32 2
; RM-NEXT:    [[VEC_CAST6:%.*]] = bitcast double* [[VEC_GEP5]] to <2 x double>*
; RM-NEXT:    [[COL_LOAD7:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST6]], align 8
; RM-NEXT:    [[VEC_GEP8:%.*]] = getelementptr double, double* [[TMP1]], i32 4
; RM-NEXT:    [[VEC_CAST9:%.*]] = bitcast double* [[VEC_GEP8]] to <2 x double>*
; RM-NEXT:    [[COL_LOAD10:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST9]], align 8
; RM-NEXT:    [[TMP2:%.*]] = fadd <3 x double> [[COL_LOAD]], [[COL_LOAD]]
; RM-NEXT:    [[TMP3:%.*]] = fadd <3 x double> [[COL_LOAD2]], [[COL_LOAD2]]
; RM-NEXT:    [[TMP4:%.*]] = bitcast <6 x double>* [[A_PTR]] to double*
; RM-NEXT:    [[VEC_CAST11:%.*]] = bitcast double* [[TMP4]] to <3 x double>*
; RM-NEXT:    store <3 x double> [[TMP2]], <3 x double>* [[VEC_CAST11]], align 8
; RM-NEXT:    [[VEC_GEP12:%.*]] = getelementptr double, double* [[TMP4]], i32 3
; RM-NEXT:    [[VEC_CAST13:%.*]] = bitcast double* [[VEC_GEP12]] to <3 x double>*
; RM-NEXT:    store <3 x double> [[TMP3]], <3 x double>* [[VEC_CAST13]], align 8
; RM-NEXT:    [[TMP5:%.*]] = fsub <2 x double> [[COL_LOAD4]], <double 1.000000e+00, double 1.000000e+00>
; RM-NEXT:    [[TMP6:%.*]] = fsub <2 x double> [[COL_LOAD7]], <double 1.000000e+00, double 1.000000e+00>
; RM-NEXT:    [[TMP7:%.*]] = fsub <2 x double> [[COL_LOAD10]], <double 1.000000e+00, double 1.000000e+00>
; RM-NEXT:    [[TMP8:%.*]] = bitcast <6 x double>* [[B_PTR]] to double*
; RM-NEXT:    [[VEC_CAST14:%.*]] = bitcast double* [[TMP8]] to <2 x double>*
; RM-NEXT:    store <2 x double> [[TMP5]], <2 x double>* [[VEC_CAST14]], align 8
; RM-NEXT:    [[VEC_GEP15:%.*]] = getelementptr double, double* [[TMP8]], i32 2
; RM-NEXT:    [[VEC_CAST16:%.*]] = bitcast double* [[VEC_GEP15]] to <2 x double>*
; RM-NEXT:    store <2 x double> [[TMP6]], <2 x double>* [[VEC_CAST16]], align 8
; RM-NEXT:    [[VEC_GEP17:%.*]] = getelementptr double, double* [[TMP8]], i32 4
; RM-NEXT:    [[VEC_CAST18:%.*]] = bitcast double* [[VEC_GEP17]] to <2 x double>*
; RM-NEXT:    store <2 x double> [[TMP7]], <2 x double>* [[VEC_CAST18]], align 8
; RM-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x double> [[TMP5]], <2 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP9:%.*]] = extractelement <3 x double> [[TMP2]], i64 0
; RM-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <1 x double> undef, double [[TMP9]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP10:%.*]] = fmul <1 x double> [[SPLAT_SPLAT]], [[BLOCK]]
; RM-NEXT:    [[BLOCK19:%.*]] = shufflevector <2 x double> [[TMP6]], <2 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP11:%.*]] = extractelement <3 x double> [[TMP2]], i64 1
; RM-NEXT:    [[SPLAT_SPLATINSERT20:%.*]] = insertelement <1 x double> undef, double [[TMP11]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT21:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT20]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP12:%.*]] = fmul <1 x double> [[SPLAT_SPLAT21]], [[BLOCK19]]
; RM-NEXT:    [[TMP13:%.*]] = fadd <1 x double> [[TMP10]], [[TMP12]]
; RM-NEXT:    [[BLOCK22:%.*]] = shufflevector <2 x double> [[TMP7]], <2 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP14:%.*]] = extractelement <3 x double> [[TMP2]], i64 2
; RM-NEXT:    [[SPLAT_SPLATINSERT23:%.*]] = insertelement <1 x double> undef, double [[TMP14]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT24:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT23]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP15:%.*]] = fmul <1 x double> [[SPLAT_SPLAT24]], [[BLOCK22]]
; RM-NEXT:    [[TMP16:%.*]] = fadd <1 x double> [[TMP13]], [[TMP15]]
; RM-NEXT:    [[TMP17:%.*]] = shufflevector <1 x double> [[TMP16]], <1 x double> undef, <2 x i32> <i32 0, i32 undef>
; RM-NEXT:    [[TMP18:%.*]] = shufflevector <2 x double> undef, <2 x double> [[TMP17]], <2 x i32> <i32 2, i32 1>
; RM-NEXT:    [[BLOCK25:%.*]] = shufflevector <2 x double> [[TMP5]], <2 x double> undef, <1 x i32> <i32 1>
; RM-NEXT:    [[TMP19:%.*]] = extractelement <3 x double> [[TMP2]], i64 0
; RM-NEXT:    [[SPLAT_SPLATINSERT26:%.*]] = insertelement <1 x double> undef, double [[TMP19]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT27:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT26]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP20:%.*]] = fmul <1 x double> [[SPLAT_SPLAT27]], [[BLOCK25]]
; RM-NEXT:    [[BLOCK28:%.*]] = shufflevector <2 x double> [[TMP6]], <2 x double> undef, <1 x i32> <i32 1>
; RM-NEXT:    [[TMP21:%.*]] = extractelement <3 x double> [[TMP2]], i64 1
; RM-NEXT:    [[SPLAT_SPLATINSERT29:%.*]] = insertelement <1 x double> undef, double [[TMP21]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT30:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT29]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP22:%.*]] = fmul <1 x double> [[SPLAT_SPLAT30]], [[BLOCK28]]
; RM-NEXT:    [[TMP23:%.*]] = fadd <1 x double> [[TMP20]], [[TMP22]]
; RM-NEXT:    [[BLOCK31:%.*]] = shufflevector <2 x double> [[TMP7]], <2 x double> undef, <1 x i32> <i32 1>
; RM-NEXT:    [[TMP24:%.*]] = extractelement <3 x double> [[TMP2]], i64 2
; RM-NEXT:    [[SPLAT_SPLATINSERT32:%.*]] = insertelement <1 x double> undef, double [[TMP24]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT33:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT32]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP25:%.*]] = fmul <1 x double> [[SPLAT_SPLAT33]], [[BLOCK31]]
; RM-NEXT:    [[TMP26:%.*]] = fadd <1 x double> [[TMP23]], [[TMP25]]
; RM-NEXT:    [[TMP27:%.*]] = shufflevector <1 x double> [[TMP26]], <1 x double> undef, <2 x i32> <i32 0, i32 undef>
; RM-NEXT:    [[TMP28:%.*]] = shufflevector <2 x double> [[TMP18]], <2 x double> [[TMP27]], <2 x i32> <i32 0, i32 2>
; RM-NEXT:    [[BLOCK34:%.*]] = shufflevector <2 x double> [[TMP5]], <2 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP29:%.*]] = extractelement <3 x double> [[TMP3]], i64 0
; RM-NEXT:    [[SPLAT_SPLATINSERT35:%.*]] = insertelement <1 x double> undef, double [[TMP29]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT36:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT35]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP30:%.*]] = fmul <1 x double> [[SPLAT_SPLAT36]], [[BLOCK34]]
; RM-NEXT:    [[BLOCK37:%.*]] = shufflevector <2 x double> [[TMP6]], <2 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP31:%.*]] = extractelement <3 x double> [[TMP3]], i64 1
; RM-NEXT:    [[SPLAT_SPLATINSERT38:%.*]] = insertelement <1 x double> undef, double [[TMP31]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT39:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT38]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP32:%.*]] = fmul <1 x double> [[SPLAT_SPLAT39]], [[BLOCK37]]
; RM-NEXT:    [[TMP33:%.*]] = fadd <1 x double> [[TMP30]], [[TMP32]]
; RM-NEXT:    [[BLOCK40:%.*]] = shufflevector <2 x double> [[TMP7]], <2 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP34:%.*]] = extractelement <3 x double> [[TMP3]], i64 2
; RM-NEXT:    [[SPLAT_SPLATINSERT41:%.*]] = insertelement <1 x double> undef, double [[TMP34]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT42:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT41]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP35:%.*]] = fmul <1 x double> [[SPLAT_SPLAT42]], [[BLOCK40]]
; RM-NEXT:    [[TMP36:%.*]] = fadd <1 x double> [[TMP33]], [[TMP35]]
; RM-NEXT:    [[TMP37:%.*]] = shufflevector <1 x double> [[TMP36]], <1 x double> undef, <2 x i32> <i32 0, i32 undef>
; RM-NEXT:    [[TMP38:%.*]] = shufflevector <2 x double> undef, <2 x double> [[TMP37]], <2 x i32> <i32 2, i32 1>
; RM-NEXT:    [[BLOCK43:%.*]] = shufflevector <2 x double> [[TMP5]], <2 x double> undef, <1 x i32> <i32 1>
; RM-NEXT:    [[TMP39:%.*]] = extractelement <3 x double> [[TMP3]], i64 0
; RM-NEXT:    [[SPLAT_SPLATINSERT44:%.*]] = insertelement <1 x double> undef, double [[TMP39]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT45:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT44]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP40:%.*]] = fmul <1 x double> [[SPLAT_SPLAT45]], [[BLOCK43]]
; RM-NEXT:    [[BLOCK46:%.*]] = shufflevector <2 x double> [[TMP6]], <2 x double> undef, <1 x i32> <i32 1>
; RM-NEXT:    [[TMP41:%.*]] = extractelement <3 x double> [[TMP3]], i64 1
; RM-NEXT:    [[SPLAT_SPLATINSERT47:%.*]] = insertelement <1 x double> undef, double [[TMP41]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT48:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT47]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP42:%.*]] = fmul <1 x double> [[SPLAT_SPLAT48]], [[BLOCK46]]
; RM-NEXT:    [[TMP43:%.*]] = fadd <1 x double> [[TMP40]], [[TMP42]]
; RM-NEXT:    [[BLOCK49:%.*]] = shufflevector <2 x double> [[TMP7]], <2 x double> undef, <1 x i32> <i32 1>
; RM-NEXT:    [[TMP44:%.*]] = extractelement <3 x double> [[TMP3]], i64 2
; RM-NEXT:    [[SPLAT_SPLATINSERT50:%.*]] = insertelement <1 x double> undef, double [[TMP44]], i32 0
; RM-NEXT:    [[SPLAT_SPLAT51:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT50]], <1 x double> undef, <1 x i32> zeroinitializer
; RM-NEXT:    [[TMP45:%.*]] = fmul <1 x double> [[SPLAT_SPLAT51]], [[BLOCK49]]
; RM-NEXT:    [[TMP46:%.*]] = fadd <1 x double> [[TMP43]], [[TMP45]]
; RM-NEXT:    [[TMP47:%.*]] = shufflevector <1 x double> [[TMP46]], <1 x double> undef, <2 x i32> <i32 0, i32 undef>
; RM-NEXT:    [[TMP48:%.*]] = shufflevector <2 x double> [[TMP38]], <2 x double> [[TMP47]], <2 x i32> <i32 0, i32 2>
; RM-NEXT:    [[TMP49:%.*]] = bitcast <4 x double>* [[C_PTR:%.*]] to double*
; RM-NEXT:    [[VEC_CAST52:%.*]] = bitcast double* [[TMP49]] to <2 x double>*
; RM-NEXT:    [[COL_LOAD53:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST52]], align 8
; RM-NEXT:    [[VEC_GEP54:%.*]] = getelementptr double, double* [[TMP49]], i32 2
; RM-NEXT:    [[VEC_CAST55:%.*]] = bitcast double* [[VEC_GEP54]] to <2 x double>*
; RM-NEXT:    [[COL_LOAD56:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST55]], align 8
; RM-NEXT:    [[TMP50:%.*]] = fsub <2 x double> [[COL_LOAD53]], [[TMP28]]
; RM-NEXT:    [[TMP51:%.*]] = fsub <2 x double> [[COL_LOAD56]], [[TMP48]]
; RM-NEXT:    [[TMP52:%.*]] = bitcast <4 x double>* [[C_PTR]] to double*
; RM-NEXT:    [[VEC_CAST57:%.*]] = bitcast double* [[TMP52]] to <2 x double>*
; RM-NEXT:    store <2 x double> [[TMP50]], <2 x double>* [[VEC_CAST57]], align 8
; RM-NEXT:    [[VEC_GEP58:%.*]] = getelementptr double, double* [[TMP52]], i32 2
; RM-NEXT:    [[VEC_CAST59:%.*]] = bitcast double* [[VEC_GEP58]] to <2 x double>*
; RM-NEXT:    store <2 x double> [[TMP51]], <2 x double>* [[VEC_CAST59]], align 8
; RM-NEXT:    ret void
;
entry:
  %a = load <6 x double>, <6 x double>* %a.ptr
  %b = load <6 x double>, <6 x double>* %b.ptr
  %add = fadd <6 x double> %a, %a
  store <6 x double> %add, <6 x double>* %a.ptr
  %sub = fsub <6 x double> %b, <double 1.0, double 1.0, double 1.0, double 1.0, double 1.0, double 1.0>
  store <6 x double> %sub, <6 x double>* %b.ptr
  %mul = call <4 x double> @llvm.matrix.multiply.v4f64.v6f64.v6f64(<6 x double> %add, <6 x double> %sub, i32 2, i32 3, i32 2)
  %c = load <4 x double>, <4 x double>* %c.ptr
  %res = fsub <4 x double> %c, %mul
  store <4 x double> %res, <4 x double>* %c.ptr
  ret void
}

declare <4 x double> @llvm.matrix.multiply.v4f64.v6f64.v6f64(<6 x double>, <6 x double>, i32, i32, i32)