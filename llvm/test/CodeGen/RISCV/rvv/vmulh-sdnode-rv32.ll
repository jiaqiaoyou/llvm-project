; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s

; Test that the prepareSREMEqFold optimization doesn't crash on scalable
; vector types. RVV doesn't have ROTR or ROTL operations so the optimization
; itself doesn't kick in.
define <vscale x 4 x i1> @srem_eq_fold_nxv4i8(<vscale x 4 x i8> %va) {
; CHECK-LABEL: srem_eq_fold_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 43
; CHECK-NEXT:    vsetvli a1, zero, e8,mf2,ta,mu
; CHECK-NEXT:    vmulh.vx v25, v8, a0
; CHECK-NEXT:    vadd.vi v25, v25, 0
; CHECK-NEXT:    vsrl.vi v26, v25, 7
; CHECK-NEXT:    vand.vi v26, v26, -1
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    addi a0, zero, 6
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v25, v8, v25
; CHECK-NEXT:    vmseq.vi v0, v25, 0
; CHECK-NEXT:    ret
  %head_six = insertelement <vscale x 4 x i8> undef, i8 6, i32 0
  %splat_six = shufflevector <vscale x 4 x i8> %head_six, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
  %rem = srem <vscale x 4 x i8> %va, %splat_six

  %cc = icmp eq <vscale x 4 x i8> %rem, zeroinitializer
  ret <vscale x 4 x i1> %cc
}
