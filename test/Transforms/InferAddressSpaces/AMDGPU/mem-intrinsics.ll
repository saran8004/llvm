; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -infer-address-spaces %s | FileCheck %s

; CHECK-LABEL: @memset_group_to_flat(
; CHECK: call void @llvm.memset.p3i8.i64(i8 addrspace(3)* %group.ptr, i8 4, i64 32, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
define void @memset_group_to_flat(i8 addrspace(3)* %group.ptr, i32 %y) #0 {
  %cast = addrspacecast i8 addrspace(3)* %group.ptr to i8 addrspace(4)*
  call void @llvm.memset.p4i8.i64(i8 addrspace(4)* %cast, i8 4, i64 32, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
  ret void
}

; CHECK-LABEL: @memset_global_to_flat(
; CHECK: call void @llvm.memset.p1i8.i64(i8 addrspace(1)* %global.ptr, i8 4, i64 32, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
define void @memset_global_to_flat(i8 addrspace(1)* %global.ptr, i32 %y) #0 {
  %cast = addrspacecast i8 addrspace(1)* %global.ptr to i8 addrspace(4)*
  call void @llvm.memset.p4i8.i64(i8 addrspace(4)* %cast, i8 4, i64 32, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
  ret void
}

; CHECK-LABEL: @memset_group_to_flat_no_md(
; CHECK: call void @llvm.memset.p3i8.i64(i8 addrspace(3)* %group.ptr, i8 4, i64 %size, i32 4, i1 false){{$}}
define void @memset_group_to_flat_no_md(i8 addrspace(3)* %group.ptr, i64 %size) #0 {
  %cast = addrspacecast i8 addrspace(3)* %group.ptr to i8 addrspace(4)*
  call void @llvm.memset.p4i8.i64(i8 addrspace(4)* %cast, i8 4, i64 %size, i32 4, i1 false)
  ret void
}

; CHECK-LABEL: @memset_global_to_flat_no_md(
; CHECK: call void @llvm.memset.p1i8.i64(i8 addrspace(1)* %global.ptr, i8 4, i64 %size, i32 4, i1 false){{$}}
define void @memset_global_to_flat_no_md(i8 addrspace(1)* %global.ptr, i64 %size) #0 {
  %cast = addrspacecast i8 addrspace(1)* %global.ptr to i8 addrspace(4)*
  call void @llvm.memset.p4i8.i64(i8 addrspace(4)* %cast, i8 4, i64 %size, i32 4, i1 false)
  ret void
}

; CHECK-LABEL: @memcpy_flat_to_flat_replace_src_with_group(
; CHCK: call void @llvm.memcpy.p4i8.p3i8.i64(i8 addrspace(4)* %dest, i8 addrspace(3)* %src.group.ptr, i64 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
define void @memcpy_flat_to_flat_replace_src_with_group(i8 addrspace(4)* %dest, i8 addrspace(3)* %src.group.ptr, i64 %size) #0 {
  %cast.src = addrspacecast i8 addrspace(3)* %src.group.ptr to i8 addrspace(4)*
  call void @llvm.memcpy.p4i8.p4i8.i64(i8 addrspace(4)* %dest, i8 addrspace(4)* %cast.src, i64 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
  ret void
}

; CHECK-LABEL: @memcpy_flat_to_flat_replace_dest_with_group(
; CHECK: call void @llvm.memcpy.p3i8.p4i8.i64(i8 addrspace(3)* %dest.group.ptr, i8 addrspace(4)* %src.ptr, i64 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
define void @memcpy_flat_to_flat_replace_dest_with_group(i8 addrspace(3)* %dest.group.ptr, i8 addrspace(4)* %src.ptr, i64 %size) #0 {
  %cast.dest = addrspacecast i8 addrspace(3)* %dest.group.ptr to i8 addrspace(4)*
  call void @llvm.memcpy.p4i8.p4i8.i64(i8 addrspace(4)* %cast.dest, i8 addrspace(4)* %src.ptr, i64 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
  ret void
}

; CHECK-LABEL: @memcpy_flat_to_flat_replace_dest_src_with_group(
; CHECK: call void @llvm.memcpy.p3i8.p3i8.i64(i8 addrspace(3)* %src.group.ptr, i8 addrspace(3)* %src.group.ptr, i64 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
define void @memcpy_flat_to_flat_replace_dest_src_with_group(i8 addrspace(3)* %dest.group.ptr, i8 addrspace(3)* %src.group.ptr, i64 %size) #0 {
  %cast.src = addrspacecast i8 addrspace(3)* %src.group.ptr to i8 addrspace(4)*
  %cast.dest = addrspacecast i8 addrspace(3)* %src.group.ptr to i8 addrspace(4)*
  call void @llvm.memcpy.p4i8.p4i8.i64(i8 addrspace(4)* %cast.dest, i8 addrspace(4)* %cast.src, i64 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
  ret void
}

; CHECK-LABEL: @memcpy_flat_to_flat_replace_dest_group_src_global(
; CHECK: call void @llvm.memcpy.p3i8.p1i8.i64(i8 addrspace(3)* %dest.group.ptr, i8 addrspace(1)* %src.global.ptr, i64 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
define void @memcpy_flat_to_flat_replace_dest_group_src_global(i8 addrspace(3)* %dest.group.ptr, i8 addrspace(1)* %src.global.ptr, i64 %size) #0 {
  %cast.src = addrspacecast i8 addrspace(1)* %src.global.ptr to i8 addrspace(4)*
  %cast.dest = addrspacecast i8 addrspace(3)* %dest.group.ptr to i8 addrspace(4)*
  call void @llvm.memcpy.p4i8.p4i8.i64(i8 addrspace(4)* %cast.dest, i8 addrspace(4)* %cast.src, i64 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
  ret void
}

; CHECK-LABEL: @memcpy_group_to_flat_replace_dest_global(
; CHECK: call void @llvm.memcpy.p1i8.p3i8.i32(i8 addrspace(1)* %dest.global.ptr, i8 addrspace(3)* %src.group.ptr, i32 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
define void @memcpy_group_to_flat_replace_dest_global(i8 addrspace(1)* %dest.global.ptr, i8 addrspace(3)* %src.group.ptr, i32 %size) #0 {
  %cast.dest = addrspacecast i8 addrspace(1)* %dest.global.ptr to i8 addrspace(4)*
  call void @llvm.memcpy.p4i8.p3i8.i32(i8 addrspace(4)* %cast.dest, i8 addrspace(3)* %src.group.ptr, i32 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
  ret void
}

; CHECK-LABEL: @memcpy_flat_to_flat_replace_src_with_group_tbaa_struct(
; CHECK: call void @llvm.memcpy.p4i8.p3i8.i64(i8 addrspace(4)* %dest, i8 addrspace(3)* %src.group.ptr, i64 %size, i32 4, i1 false), !tbaa.struct !7
define void @memcpy_flat_to_flat_replace_src_with_group_tbaa_struct(i8 addrspace(4)* %dest, i8 addrspace(3)* %src.group.ptr, i64 %size) #0 {
  %cast.src = addrspacecast i8 addrspace(3)* %src.group.ptr to i8 addrspace(4)*
  call void @llvm.memcpy.p4i8.p4i8.i64(i8 addrspace(4)* %dest, i8 addrspace(4)* %cast.src, i64 %size, i32 4, i1 false), !tbaa.struct !7
  ret void
}

; CHECK-LABEL: @memcpy_flat_to_flat_replace_src_with_group_no_md(
; CHECK: call void @llvm.memcpy.p4i8.p3i8.i64(i8 addrspace(4)* %dest, i8 addrspace(3)* %src.group.ptr, i64 %size, i32 4, i1 false){{$}}
define void @memcpy_flat_to_flat_replace_src_with_group_no_md(i8 addrspace(4)* %dest, i8 addrspace(3)* %src.group.ptr, i64 %size) #0 {
  %cast.src = addrspacecast i8 addrspace(3)* %src.group.ptr to i8 addrspace(4)*
  call void @llvm.memcpy.p4i8.p4i8.i64(i8 addrspace(4)* %dest, i8 addrspace(4)* %cast.src, i64 %size, i32 4, i1 false)
  ret void
}

; CHECK-LABEL: @multiple_memcpy_flat_to_flat_replace_src_with_group_no_md(
; CHECK: call void @llvm.memcpy.p4i8.p3i8.i64(i8 addrspace(4)* %dest0, i8 addrspace(3)* %src.group.ptr, i64 %size, i32 4, i1 false){{$}}
; CHECK: call void @llvm.memcpy.p4i8.p3i8.i64(i8 addrspace(4)* %dest1, i8 addrspace(3)* %src.group.ptr, i64 %size, i32 4, i1 false){{$}}
define void @multiple_memcpy_flat_to_flat_replace_src_with_group_no_md(i8 addrspace(4)* %dest0, i8 addrspace(4)* %dest1, i8 addrspace(3)* %src.group.ptr, i64 %size) #0 {
  %cast.src = addrspacecast i8 addrspace(3)* %src.group.ptr to i8 addrspace(4)*
  call void @llvm.memcpy.p4i8.p4i8.i64(i8 addrspace(4)* %dest0, i8 addrspace(4)* %cast.src, i64 %size, i32 4, i1 false)
  call void @llvm.memcpy.p4i8.p4i8.i64(i8 addrspace(4)* %dest1, i8 addrspace(4)* %cast.src, i64 %size, i32 4, i1 false)
  ret void
}

; Check for iterator problems if the pointer has 2 uses in the same call
; CHECK-LABEL: @memcpy_group_flat_to_flat_self(
; CHECK: call void @llvm.memcpy.p3i8.p3i8.i64(i8 addrspace(3)* %group.ptr, i8 addrspace(3)* %group.ptr, i64 32, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
define void @memcpy_group_flat_to_flat_self(i8 addrspace(3)* %group.ptr) #0 {
  %cast = addrspacecast i8 addrspace(3)* %group.ptr to i8 addrspace(4)*
  call void @llvm.memcpy.p4i8.p4i8.i64(i8 addrspace(4)* %cast, i8 addrspace(4)* %cast, i64 32, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
  ret void
}
; CHECK-LABEL: @memmove_flat_to_flat_replace_src_with_group(
; CHECK: call void @llvm.memmove.p4i8.p3i8.i64(i8 addrspace(4)* %dest, i8 addrspace(3)* %src.group.ptr, i64 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
define void @memmove_flat_to_flat_replace_src_with_group(i8 addrspace(4)* %dest, i8 addrspace(3)* %src.group.ptr, i64 %size) #0 {
  %cast.src = addrspacecast i8 addrspace(3)* %src.group.ptr to i8 addrspace(4)*
  call void @llvm.memmove.p4i8.p4i8.i64(i8 addrspace(4)* %dest, i8 addrspace(4)* %cast.src, i64 %size, i32 4, i1 false), !tbaa !0, !alias.scope !3, !noalias !4
  ret void
}

declare void @llvm.memset.p4i8.i64(i8 addrspace(4)* nocapture writeonly, i8, i64, i32, i1) #1
declare void @llvm.memcpy.p4i8.p4i8.i64(i8 addrspace(4)* nocapture writeonly, i8 addrspace(4)* nocapture readonly, i64, i32, i1) #1
declare void @llvm.memcpy.p4i8.p3i8.i32(i8 addrspace(4)* nocapture writeonly, i8 addrspace(3)* nocapture readonly, i32, i32, i1) #1
declare void @llvm.memmove.p4i8.p4i8.i64(i8 addrspace(4)* nocapture writeonly, i8 addrspace(4)* nocapture readonly, i64, i32, i1) #1

attributes #0 = { nounwind }
attributes #1 = { argmemonly nounwind }

!0 = !{!1, !1, i64 0}
!1 = !{!"A", !2}
!2 = !{!"tbaa root"}
!3 = !{!"B", !2}
!4 = !{!5}
!5 = distinct !{!5, !6, !"some scope"}
!6 = distinct !{!6, !"some domain"}
!7 = !{i64 0, i64 8, null}