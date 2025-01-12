; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -opaque-pointers=0 -passes=loop-vectorize -S < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

define void @trip1024_i64(i64* noalias nocapture noundef %dst, i64* noalias nocapture noundef readonly %src) #0 {
; CHECK-LABEL: @trip1024_i64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 2
; CHECK-NEXT:    [[TMP4:%.*]] = sub i64 [[TMP3]], 1
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 1024, [[TMP4]]
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 2
; CHECK-NEXT:    [[TMP7:%.*]] = sub i64 1024, [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ugt i64 1024, [[TMP6]]
; CHECK-NEXT:    [[TMP9:%.*]] = select i1 [[TMP8]], i64 [[TMP7]], i64 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_ENTRY:%.*]] = call <vscale x 2 x i1> @llvm.get.active.lane.mask.nxv2i1.i64(i64 0, i64 1024)
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = phi <vscale x 2 x i1> [ [[ACTIVE_LANE_MASK_ENTRY]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i64, i64* [[SRC:%.*]], i64 [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i64, i64* [[TMP11]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i64* [[TMP12]] to <vscale x 2 x i64>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 2 x i64> @llvm.masked.load.nxv2i64.p0nxv2i64(<vscale x 2 x i64>* [[TMP13]], i32 8, <vscale x 2 x i1> [[ACTIVE_LANE_MASK]], <vscale x 2 x i64> poison)
; CHECK-NEXT:    [[TMP14:%.*]] = shl nsw <vscale x 2 x i64> [[WIDE_MASKED_LOAD]], shufflevector (<vscale x 2 x i64> insertelement (<vscale x 2 x i64> poison, i64 1, i64 0), <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds i64, i64* [[DST:%.*]], i64 [[TMP10]]
; CHECK-NEXT:    [[TMP16:%.*]] = getelementptr inbounds i64, i64* [[TMP15]], i32 0
; CHECK-NEXT:    [[TMP17:%.*]] = bitcast i64* [[TMP16]] to <vscale x 2 x i64>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD1:%.*]] = call <vscale x 2 x i64> @llvm.masked.load.nxv2i64.p0nxv2i64(<vscale x 2 x i64>* [[TMP17]], i32 8, <vscale x 2 x i1> [[ACTIVE_LANE_MASK]], <vscale x 2 x i64> poison)
; CHECK-NEXT:    [[TMP18:%.*]] = add nsw <vscale x 2 x i64> [[WIDE_MASKED_LOAD1]], [[TMP14]]
; CHECK-NEXT:    [[TMP19:%.*]] = bitcast i64* [[TMP16]] to <vscale x 2 x i64>*
; CHECK-NEXT:    call void @llvm.masked.store.nxv2i64.p0nxv2i64(<vscale x 2 x i64> [[TMP18]], <vscale x 2 x i64>* [[TMP19]], i32 8, <vscale x 2 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_NEXT]] = call <vscale x 2 x i1> @llvm.get.active.lane.mask.nxv2i1.i64(i64 [[INDEX]], i64 [[TMP9]])
; CHECK-NEXT:    [[TMP20:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP21:%.*]] = mul i64 [[TMP20]], 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], [[TMP21]]
; CHECK-NEXT:    [[TMP22:%.*]] = xor <vscale x 2 x i1> [[ACTIVE_LANE_MASK_NEXT]], shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> poison, i1 true, i64 0), <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP23:%.*]] = extractelement <vscale x 2 x i1> [[TMP22]], i32 0
; CHECK-NEXT:    br i1 [[TMP23]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_06:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[SRC]], i64 [[I_06]]
; CHECK-NEXT:    [[TMP24:%.*]] = load i64, i64* [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[MUL:%.*]] = shl nsw i64 [[TMP24]], 1
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i64, i64* [[DST]], i64 [[I_06]]
; CHECK-NEXT:    [[TMP25:%.*]] = load i64, i64* [[ARRAYIDX1]], align 8
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[TMP25]], [[MUL]]
; CHECK-NEXT:    store i64 [[ADD]], i64* [[ARRAYIDX1]], align 8
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_06]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 1024
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds i64, i64* %src, i64 %i.06
  %0 = load i64, i64* %arrayidx, align 8
  %mul = shl nsw i64 %0, 1
  %arrayidx1 = getelementptr inbounds i64, i64* %dst, i64 %i.06
  %1 = load i64, i64* %arrayidx1, align 8
  %add = add nsw i64 %1, %mul
  store i64 %add, i64* %arrayidx1, align 8
  %inc = add nuw nsw i64 %i.06, 1
  %exitcond.not = icmp eq i64 %inc, 1024
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

attributes #0 = { vscale_range(1,16) "target-features"="+sve" optsize }
