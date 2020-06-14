; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx908 -O0 -global-isel -stop-after=irtranslator -verify-machineinstrs -o - %s | FileCheck %s

define amdgpu_kernel void @asm_convergent() convergent{
  ; CHECK-LABEL: name: asm_convergent
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &s_barrier, 33 /* sideeffect isconvergent attdialect */, !0
  ; CHECK:   S_ENDPGM 0
  call void asm sideeffect "s_barrier", ""() convergent, !srcloc !0
  ret void
}

define amdgpu_kernel void @asm_simple_memory_clobber() {
  ; CHECK-LABEL: name: asm_simple_memory_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"", 25 /* sideeffect mayload maystore attdialect */, !0
  ; CHECK:   INLINEASM &"", 1 /* sideeffect attdialect */, !0
  ; CHECK:   S_ENDPGM 0
  call void asm sideeffect "", "~{memory}"(), !srcloc !0
  call void asm sideeffect "", ""(), !srcloc !0
  ret void
}

define amdgpu_kernel void @asm_simple_vgpr_clobber() {
  ; CHECK-LABEL: name: asm_simple_vgpr_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"v_mov_b32 v0, 7", 1 /* sideeffect attdialect */, 12 /* clobber */, implicit-def early-clobber $vgpr0, !0
  ; CHECK:   S_ENDPGM 0
  call void asm sideeffect "v_mov_b32 v0, 7", "~{v0}"(), !srcloc !0
  ret void
}

define amdgpu_kernel void @asm_simple_sgpr_clobber() {
  ; CHECK-LABEL: name: asm_simple_sgpr_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"s_mov_b32 s0, 7", 1 /* sideeffect attdialect */, 12 /* clobber */, implicit-def early-clobber $sgpr0, !0
  ; CHECK:   S_ENDPGM 0
  call void asm sideeffect "s_mov_b32 s0, 7", "~{s0}"(), !srcloc !0
  ret void
}

define amdgpu_kernel void @asm_simple_agpr_clobber() {
  ; CHECK-LABEL: name: asm_simple_agpr_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"; def a0", 1 /* sideeffect attdialect */, 12 /* clobber */, implicit-def early-clobber $agpr0, !0
  ; CHECK:   S_ENDPGM 0
  call void asm sideeffect "; def a0", "~{a0}"(), !srcloc !0
  ret void
}

define i32 @asm_vgpr_early_clobber() {
  ; CHECK-LABEL: name: asm_vgpr_early_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   INLINEASM &"v_mov_b32 $0, 7; v_mov_b32 $1, 7", 1 /* sideeffect attdialect */, 1835019 /* regdef-ec:VGPR_32 */, def early-clobber %1, 1835019 /* regdef-ec:VGPR_32 */, def early-clobber %2, !0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY %1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY %2
  ; CHECK:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[COPY1]], [[COPY2]]
  ; CHECK:   $vgpr0 = COPY [[ADD]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  call { i32, i32 } asm sideeffect "v_mov_b32 $0, 7; v_mov_b32 $1, 7", "=&v,=&v"(), !srcloc !0
  %asmresult = extractvalue { i32, i32 } %1, 0
  %asmresult1 = extractvalue { i32, i32 } %1, 1
  %add = add i32 %asmresult, %asmresult1
  ret i32 %add
}

define i32 @test_specific_vgpr_output() nounwind {
  ; CHECK-LABEL: name: test_specific_vgpr_output
  ; CHECK: bb.1.entry:
  ; CHECK:   liveins: $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   INLINEASM &"v_mov_b32 v1, 7", 0 /* attdialect */, 10 /* regdef */, implicit-def $vgpr1
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   $vgpr0 = COPY [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
entry:
  %0 = tail call i32 asm "v_mov_b32 v1, 7", "={v1}"() nounwind
  ret i32 %0
}

define i32 @test_single_vgpr_output() nounwind {
  ; CHECK-LABEL: name: test_single_vgpr_output
  ; CHECK: bb.1.entry:
  ; CHECK:   liveins: $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   INLINEASM &"v_mov_b32 $0, 7", 0 /* attdialect */, 1835018 /* regdef:VGPR_32 */, def %1
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY %1
  ; CHECK:   $vgpr0 = COPY [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
entry:
  %0 = tail call i32 asm "v_mov_b32 $0, 7", "=v"() nounwind
  ret i32 %0
}

define i32 @test_single_sgpr_output_s32() nounwind {
  ; CHECK-LABEL: name: test_single_sgpr_output_s32
  ; CHECK: bb.1.entry:
  ; CHECK:   liveins: $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   INLINEASM &"s_mov_b32 $0, 7", 0 /* attdialect */, 1966090 /* regdef:SReg_32 */, def %1
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY %1
  ; CHECK:   $vgpr0 = COPY [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
entry:
  %0 = tail call i32 asm "s_mov_b32 $0, 7", "=s"() nounwind
  ret i32 %0
}

; Check support for returning several floats
define float @test_multiple_register_outputs_same() #0 {
  ; CHECK-LABEL: name: test_multiple_register_outputs_same
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   INLINEASM &"v_mov_b32 $0, 0; v_mov_b32 $1, 1", 0 /* attdialect */, 1835018 /* regdef:VGPR_32 */, def %1, 1835018 /* regdef:VGPR_32 */, def %2
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY %1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY %2
  ; CHECK:   [[FADD:%[0-9]+]]:_(s32) = G_FADD [[COPY1]], [[COPY2]]
  ; CHECK:   $vgpr0 = COPY [[FADD]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %1 = call { float, float } asm "v_mov_b32 $0, 0; v_mov_b32 $1, 1", "=v,=v"()
  %asmresult = extractvalue { float, float } %1, 0
  %asmresult1 = extractvalue { float, float } %1, 1
  %add = fadd float %asmresult, %asmresult1
  ret float %add
}

; Check support for returning several floats
define double @test_multiple_register_outputs_mixed() #0 {
  ; CHECK-LABEL: name: test_multiple_register_outputs_mixed
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   INLINEASM &"v_mov_b32 $0, 0; v_add_f64 $1, 0, 0", 0 /* attdialect */, 1835018 /* regdef:VGPR_32 */, def %1, 2883594 /* regdef:VReg_64 */, def %2
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY %1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s64) = COPY %2
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[COPY2]](s64)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0, implicit $vgpr1
  %1 = call { float, double } asm "v_mov_b32 $0, 0; v_add_f64 $1, 0, 0", "=v,=v"()
  %asmresult = extractvalue { float, double } %1, 1
  ret double %asmresult
}


define float @test_vector_output() nounwind {
  ; CHECK-LABEL: name: test_vector_output
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 0
  ; CHECK:   INLINEASM &"v_add_f64 $0, 0, 0", 1 /* sideeffect attdialect */, 10 /* regdef */, implicit-def $vgpr14_vgpr15
  ; CHECK:   [[COPY1:%[0-9]+]]:_(<2 x s32>) = COPY $vgpr14_vgpr15
  ; CHECK:   [[EVEC:%[0-9]+]]:_(s32) = G_EXTRACT_VECTOR_ELT [[COPY1]](<2 x s32>), [[C]](s32)
  ; CHECK:   $vgpr0 = COPY [[EVEC]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
  %1 = tail call <2 x float> asm sideeffect "v_add_f64 $0, 0, 0", "={v[14:15]}"() nounwind
  %2 = extractelement <2 x float> %1, i32 0
  ret float %2
}

define amdgpu_kernel void @test_input_vgpr_imm() {
  ; CHECK-LABEL: name: test_input_vgpr_imm
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK:   [[COPY:%[0-9]+]]:vgpr_32 = COPY [[C]](s32)
  ; CHECK:   INLINEASM &"v_mov_b32 v0, $0", 1 /* sideeffect attdialect */, 9 /* reguse */, [[COPY]]
  ; CHECK:   S_ENDPGM 0
  call void asm sideeffect "v_mov_b32 v0, $0", "v"(i32 42)
  ret void
}

define amdgpu_kernel void @test_input_sgpr_imm() {
  ; CHECK-LABEL: name: test_input_sgpr_imm
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY [[C]](s32)
  ; CHECK:   INLINEASM &"s_mov_b32 s0, $0", 1 /* sideeffect attdialect */, 9 /* reguse */, [[COPY]]
  ; CHECK:   S_ENDPGM 0
  call void asm sideeffect "s_mov_b32 s0, $0", "s"(i32 42)
  ret void
}

define amdgpu_kernel void @test_input_imm() {
  ; CHECK-LABEL: name: test_input_imm
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"s_mov_b32 s0, $0", 9 /* sideeffect mayload attdialect */, 13 /* imm */, 42
  ; CHECK:   INLINEASM &"s_mov_b64 s[0:1], $0", 9 /* sideeffect mayload attdialect */, 13 /* imm */, 42
  ; CHECK:   S_ENDPGM 0
  call void asm sideeffect "s_mov_b32 s0, $0", "i"(i32 42)
  call void asm sideeffect "s_mov_b64 s[0:1], $0", "i"(i64 42)
  ret void
}

define float @test_input_vgpr(i32 %src) nounwind {
  ; CHECK-LABEL: name: test_input_vgpr
  ; CHECK: bb.1.entry:
  ; CHECK:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY [[COPY]](s32)
  ; CHECK:   INLINEASM &"v_add_f32 $0, 1.0, $1", 0 /* attdialect */, 1835018 /* regdef:VGPR_32 */, def %2, 9 /* reguse */, [[COPY2]]
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY %2
  ; CHECK:   $vgpr0 = COPY [[COPY3]](s32)
  ; CHECK:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0
entry:
  %0 = tail call float asm "v_add_f32 $0, 1.0, $1", "=v,v"(i32 %src) nounwind
  ret float %0
}

define i32 @test_memory_constraint(i32 addrspace(3)* %a) nounwind {
  ; CHECK-LABEL: name: test_memory_constraint
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(p3) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   INLINEASM &"ds_read_b32 $0, $1", 8 /* mayload attdialect */, 1835018 /* regdef:VGPR_32 */, def %2, 196622 /* mem:m */, [[COPY]](p3)
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY %2
  ; CHECK:   $vgpr0 = COPY [[COPY2]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %1 = tail call i32 asm "ds_read_b32 $0, $1", "=v,*m"(i32 addrspace(3)* %a)
  ret i32 %1
}

!0 = !{i32 70}