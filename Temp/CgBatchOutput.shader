Shader "Toon/Basic" {
	Properties {
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ToonShade ("ToonShader Cubemap(RGB)", CUBE) = "" { Texgen CubeNormal }
	}


	SubShader {
		Tags { "RenderType"="Opaque" }
		Pass {
			Name "BASE"
			Cull Off
			
			Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 10 to 10
//   d3d9 - ALU: 10 to 10
//   d3d11 - ALU: 8 to 8, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 8 to 8, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "normal" Normal
Vector 9 [_MainTex_ST]
"!!ARBvp1.0
# 10 ALU
PARAM c[10] = { { 0 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9] };
TEMP R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
DP4 result.texcoord[1].z, R0, c[3];
DP4 result.texcoord[1].y, R0, c[2];
DP4 result.texcoord[1].x, R0, c[1];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[8];
DP4 result.position.z, vertex.position, c[7];
DP4 result.position.y, vertex.position, c[6];
DP4 result.position.x, vertex.position, c[5];
END
# 10 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "normal" Normal
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 8 [_MainTex_ST]
"vs_2_0
; 10 ALU
def c9, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_normal0 v2
mov r0.w, c9.x
mov r0.xyz, v2
dp4 oT1.z, r0, c2
dp4 oT1.y, r0, c1
dp4 oT1.x, r0, c0
mad oT0.xy, v1, c8, c8.zwzw
dp4 oPos.w, v0, c7
dp4 oPos.z, v0, c6
dp4 oPos.y, v0, c5
dp4 oPos.x, v0, c4
"
}

SubProgram "xbox360 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "normal" Normal
Vector 7 [_MainTex_ST]
Matrix 4 [glstate_matrix_modelview0] 3
Matrix 0 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 10.67 (8 instructions), vertex: 32, texture: 0,
//   sequencer: 10,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabdeaaaaaaleaaaaaaaaaaaaaaceaaaaaaaaaaaaaapaaaaaaaaa
aaaaaaaaaaaaaamiaaaaaabmaaaaaalkpppoadaaaaaaaaadaaaaaabmaaaaaaaa
aaaaaaldaaaaaafiaaacaaahaaabaaaaaaaaaageaaaaaaaaaaaaaaheaaacaaae
aaadaaaaaaaaaajaaaaaaaaaaaaaaakaaaacaaaaaaaeaaaaaaaaaajaaaaaaaaa
fpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgngpgegfgmhggjgfhhdaaaklklaaadaaadaaaeaaae
aaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahghdfpddfp
daaadccodacodcdadddfddcodaaaklklaaaaaaaaaaaaaaleaabbaaadaaaaaaaa
aaaaaaaaaaaabeecaaaaaaabaaaaaaadaaaaaaacaaaaacjaaabaaaadaaaafaae
aacadaafaaaadafaaaabhbfbaaaabaanaaaabaamhabfdaadaaaabcaamcaaaaaa
aaaaeaagaaaabcaameaaaaaaaaaaeaakaaaaccaaaaaaaaaaafpidaaaaaaaagii
aaaaaaaaafpiaaaaaaaaaoehaaaaaaaaafpibaaaaaaaabnbaaaaaaaamiapaaac
aabliiaakbadadaamiapaaacaamgiiaakladacacmiapaaacaalbdejekladabac
miapiadoaagmaadekladaaacmiahaaacaalbleaakbabagaamiahaaabaagmlema
klabafacmiahiaabaablmaleklabaeabmiadiaaaaamflabkilaaahahaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { }
Matrix 256 [glstate_matrix_modelview0]
Matrix 260 [glstate_matrix_mvp]
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "normal" Normal
Vector 467 [_MainTex_ST]
"sce_vp_rsx // 8 instructions using 1 registers
[Configuration]
8
0000000801050100
[Microcode]
128
401f9c6c011d3808010400d740619f9c401f9c6c01d0700d8106c0c360403f80
401f9c6c01d0600d8106c0c360405f80401f9c6c01d0500d8106c0c360409f80
401f9c6c01d0400d8106c0c360411f80401f9c6c0150220c010600c360405fa0
401f9c6c0150120c010600c360409fa0401f9c6c0150020c010600c360411fa1
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "normal" Normal
ConstBuffer "$Globals" 48 // 32 used size, 3 vars
Vector 16 [_MainTex_ST] 4
ConstBuffer "UnityPerDraw" 336 // 128 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedjkbjhknghpfggnilhbdnljbhjmimioebabaaaaaammacaaaaadaaaaaa
cmaaaaaakaaaaaaabaabaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaagcaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaafaepfdejfeejepeoaafeeffiedepepfceeaaeoepfcenebemaaklklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcleabaaaaeaaaabaagnaaaaaa
fjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaaabaaaaaaahaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaabaaaaaa
egiacaaaaaaaaaaaabaaaaaaogikcaaaaaaaaaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaacaaaaaaegiccaaaabaaaaaaafaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaaeaaaaaaagbabaaaacaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaabaaaaaaagaaaaaakgbkbaaaacaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize(_glesNormal);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (glstate_matrix_modelview0 * tmpvar_1).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Color;
uniform samplerCube _ToonShade;
uniform sampler2D _MainTex;
void main ()
{
  highp vec4 cube_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_3;
  tmpvar_3 = (_Color * tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_ToonShade, xlv_TEXCOORD1);
  cube_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.xyz = ((2.0 * cube_1.xyz) * tmpvar_3.xyz);
  tmpvar_5.w = tmpvar_3.w;
  gl_FragData[0] = tmpvar_5;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize(_glesNormal);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (glstate_matrix_modelview0 * tmpvar_1).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Color;
uniform samplerCube _ToonShade;
uniform sampler2D _MainTex;
void main ()
{
  highp vec4 cube_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_3;
  tmpvar_3 = (_Color * tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_ToonShade, xlv_TEXCOORD1);
  cube_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.xyz = ((2.0 * cube_1.xyz) * tmpvar_3.xyz);
  tmpvar_5.w = tmpvar_3.w;
  gl_FragData[0] = tmpvar_5;
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "normal" Normal
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 8 [_MainTex_ST]
"agal_vs
c9 0.0 0.0 0.0 0.0
[bc]
aaaaaaaaaaaaaiacajaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c9.x
aaaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a1
bdaaaaaaabaaaeaeaaaaaaoeacaaaaaaacaaaaoeabaaaaaa dp4 v1.z, r0, c2
bdaaaaaaabaaacaeaaaaaaoeacaaaaaaabaaaaoeabaaaaaa dp4 v1.y, r0, c1
bdaaaaaaabaaabaeaaaaaaoeacaaaaaaaaaaaaoeabaaaaaa dp4 v1.x, r0, c0
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaiaaaaoeabaaaaaa mul r0.xy, a3, c8
abaaaaaaaaaaadaeaaaaaafeacaaaaaaaiaaaaooabaaaaaa add v0.xy, r0.xyyy, c8.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 o0.w, a0, c7
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 o0.z, a0, c6
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 o0.y, a0, c5
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 o0.x, a0, c4
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "normal" Normal
ConstBuffer "$Globals" 48 // 32 used size, 3 vars
Vector 16 [_MainTex_ST] 4
ConstBuffer "UnityPerDraw" 336 // 128 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedjlgelgfpahajkipiacfknlkmgeienhghabaaaaaapmadaaaaaeaaaaaa
daaaaaaafmabaaaabiadaaaaimadaaaaebgpgodjceabaaaaceabaaaaaaacpopp
oeaaaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaabaa
abaaabaaaaaaaaaaabaaaaaaahaaacaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaac
afaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjabpaaaaacafaaaciaacaaapja
aeaaaaaeaaaaadoaabaaoejaabaaoekaabaaookaafaaaaadaaaaahiaacaaffja
ahaaoekaaeaaaaaeaaaaahiaagaaoekaacaaaajaaaaaoeiaaeaaaaaeabaaahoa
aiaaoekaacaakkjaaaaaoeiaafaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaae
aaaaapiaacaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefc
leabaaaaeaaaabaagnaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaae
egiocaaaabaaaaaaahaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaa
abaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaabaaaaaaegiacaaaaaaaaaaaabaaaaaaogikcaaaaaaaaaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaacaaaaaaegiccaaaabaaaaaa
afaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaaagbabaaa
acaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaabaaaaaa
agaaaaaakgbkbaaaacaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheogmaaaaaa
adaaaaaaaiaaaaaafaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
fjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaagcaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaafaepfdejfeejepeoaafeeffiedepepfc
eeaaeoepfcenebemaaklklklepfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 326
struct v2f {
    highp vec4 pos;
    highp vec2 texcoord;
    highp vec3 cubenormal;
};
#line 319
struct appdata {
    highp vec4 vertex;
    highp vec2 texcoord;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform sampler2D _MainTex;
uniform samplerCube _ToonShade;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Color;
#line 333
#line 341
#line 333
v2f vert( in appdata v ) {
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 337
    o.texcoord = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.cubenormal = vec3( (glstate_matrix_modelview0 * vec4( v.normal, 0.0)));
    return o;
}
out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
void main() {
    v2f xl_retval;
    appdata xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.texcoord = vec2(gl_MultiTexCoord0);
    xlt_v.normal = vec3(gl_Normal);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.texcoord);
    xlv_TEXCOORD1 = vec3(xl_retval.cubenormal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 326
struct v2f {
    highp vec4 pos;
    highp vec2 texcoord;
    highp vec3 cubenormal;
};
#line 319
struct appdata {
    highp vec4 vertex;
    highp vec2 texcoord;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 315
uniform sampler2D _MainTex;
uniform samplerCube _ToonShade;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Color;
#line 333
#line 341
#line 341
highp vec4 frag( in v2f i ) {
    highp vec4 col = (_Color * texture( _MainTex, i.texcoord));
    highp vec4 cube = texture( _ToonShade, i.cubenormal);
    #line 345
    return vec4( ((2.0 * cube.xyz) * col.xyz), col.w);
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
void main() {
    highp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.texcoord = vec2(xlv_TEXCOORD0);
    xlt_i.cubenormal = vec3(xlv_TEXCOORD1);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 6 to 6, TEX: 2 to 2
//   d3d9 - ALU: 5 to 5, TEX: 2 to 2
//   d3d11 - ALU: 3 to 3, TEX: 2 to 2, FLOW: 1 to 1
//   d3d11_9x - ALU: 3 to 3, TEX: 2 to 2, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ToonShade] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 6 ALU, 2 TEX
PARAM c[2] = { program.local[0],
		{ 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[1], CUBE;
MUL R0, R0, c[0];
MUL R0.xyz, R1, R0;
MUL result.color.xyz, R0, c[1].x;
MOV result.color.w, R0;
END
# 6 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ToonShade] CUBE
"ps_2_0
; 5 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c1, 2.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xyz
texld r0, t1, s1
texld r1, t0, s0
mul r1, r1, c0
mul r0.xyz, r0, r1
mov r0.w, r1
mul r0.xyz, r0, c1.x
mov oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ToonShade] CUBE
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 8.00 (6 instructions), vertex: 0, texture: 8,
//   sequencer: 6, interpolator: 8;    3 GPRs, 63 threads,
// Performance (if enough threads): ~8 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabdeaaaaaameaaaaaaaaaaaaaaceaaaaaaoeaaaaabamaaaaaaaa
aaaaaaaaaaaaaalmaaaaaabmaaaaaakpppppadaaaaaaaaadaaaaaabmaaaaaaaa
aaaaaakiaaaaaafiaaacaaaaaaabaaaaaaaaaagaaaaaaaaaaaaaaahaaaadaaaa
aaabaaaaaaaaaahmaaaaaaaaaaaaaaimaaadaaabaaabaaaaaaaaaajiaaaaaaaa
fpedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpengbgjgofegfhi
aaklklklaaaeaaamaaabaaabaaabaaaaaaaaaaaafpfegpgpgofdgigbgegfaakl
aaaeaaaoaaabaaabaaabaaaaaaaaaaaahahdfpddfpdaaadccodacodcdadddfdd
codaaaklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaiebaaaacaaaaaaaaaeaaaaaaaa
aaaabeecaaadaaadaaaaaaabaaaadafaaaaahbfbaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadpmaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabeafaacaaaabcaameaaaaaa
aaaadaahaaaaccaaaaaaaaaamiapaaabaakgmnaapcababaaemeeaaacaablblmg
ocababibmiadaaacaagnmggmmlabaappjabicaebbpbppoiiaaaamaaabaaibaab
bpbppgiiaaaaeaaamiaoaaaaaapmpmaaoaacacaabebhaaabaamamablkbabaaab
kiihiaaaaamabfaambabaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ToonShade] CUBE
"sce_fp_rsx // 6 instructions using 2 registers
[Configuration]
24
ffffffff0000c0200003fffd000000000000844002000000
[Offsets]
1
_Color 1 0
00000020
[Microcode]
96
9e001700c8011c9dc8000001c8003fe11e000200c8001c9dc8020001c8000001
00000000000000000000000000000000ae021702c8011c9dc8000001c800bfe1
0e000200c8041c9dc8001001c800000110010100c8001c9dc8000001c8000001
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 48 // 48 used size, 3 vars
Vector 32 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ToonShade] CUBE 1
// 7 instructions, 2 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddpgpgncipggmopcjcpenfjikhihbhflbabaaaaaaamacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdeabaaaaeaaaaaaaenaaaaaa
fjaaaaaeegiocaaaaaaaaaaaadaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaa
abaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbcbaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaai
pcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaacaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaabaaaaaaaaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ToonShade] CUBE
"agal_ps
c1 2.0 0.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacabaaaaoeaeaaaaaaabaaaaaaafbababb tex r0, v1, s1 <cube wrap linear point>
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
adaaaaaaabaaapacabaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r1, r1, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c1.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 48 // 48 used size, 3 vars
Vector 32 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_ToonShade] CUBE 1
// 7 instructions, 2 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecednlmmfcljafaenhhockhichmdpinnohggabaaaaaaoeacaaaaaeaaaaaa
daaaaaaaaeabaaaaeaacaaaalaacaaaaebgpgodjmmaaaaaammaaaaaaaaacpppp
jeaaaaaadiaaaaaaabaacmaaaaaadiaaaaaadiaaacaaceaaaaaadiaaaaaaaaaa
abababaaaaaaacaaabaaaaaaaaaaaaaaaaacppppbpaaaaacaaaaaaiaaaaaadla
bpaaaaacaaaaaaiaabaaahlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaaji
abaiapkaecaaaaadaaaaapiaabaaoelaabaioekaecaaaaadabaaapiaaaaaoela
aaaioekaafaaaaadabaaapiaabaaoeiaaaaaoekaafaaaaadaaaaahiaaaaaoeia
abaaoeiaacaaaaadabaaahiaaaaaoeiaaaaaoeiaabaaaaacaaaiapiaabaaoeia
ppppaaaafdeieefcdeabaaaaeaaaaaaaenaaaaaafjaaaaaeegiocaaaaaaaaaaa
adaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbcbaaaacaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaaegaobaaa
abaaaaaaegiocaaaaaaaaaaaacaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaa
aaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
ejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}

#LINE 54
			
		}
	} 

	SubShader {
		Tags { "RenderType"="Opaque" }
		Pass {
			Name "BASE"
			Cull Off
			SetTexture [_MainTex] {
				constantColor [_Color]
				Combine texture * constant
			} 
			SetTexture [_ToonShade] {
				combine texture * previous DOUBLE, previous
			}
		}
	} 
	
	Fallback "VertexLit"
}
