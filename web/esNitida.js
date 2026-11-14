(function dartProgram(){function copyProperties(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
b[q]=a[q]}}function mixinPropertiesHard(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
if(!b.hasOwnProperty(q)){b[q]=a[q]}}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var s=function(){}
s.prototype={p:{}}
var r=new s()
if(!(Object.getPrototypeOf(r)&&Object.getPrototypeOf(r).p===s.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var q=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(q))return true}}catch(p){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var s=Object.create(b.prototype)
copyProperties(a.prototype,s)
a.prototype=s}}function inheritMany(a,b){for(var s=0;s<b.length;s++){inherit(b[s],a)}}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){a[b]=d()}a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){var r=d()
if(a[b]!==s){A.u8(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.m(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.mq(b)
return new s(c,this)}:function(){if(s===null)s=A.mq(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.mq(a).prototype
return s}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number"){h+=x}return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var s=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var r=staticTearOffGetter(s)
a[b]=r}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var s=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var r=instanceTearOffGetter(c,s)
a[b]=r}function setOrUpdateInterceptorsByTag(a){var s=v.interceptorsByTag
if(!s){v.interceptorsByTag=a
return}copyProperties(a,s)}function setOrUpdateLeafTags(a){var s=v.leafTags
if(!s){v.leafTags=a
return}copyProperties(a,s)}function updateTypes(a){var s=v.types
var r=s.length
s.push.apply(s,a)
return r}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var s=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},r=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:s(0,0,null,["$0"],0),_instance_1u:s(0,1,null,["$1"],0),_instance_2u:s(0,2,null,["$2"],0),_instance_0i:s(1,0,null,["$0"],0),_instance_1i:s(1,1,null,["$1"],0),_instance_2i:s(1,2,null,["$2"],0),_static_0:r(0,null,["$0"],0),_static_1:r(1,null,["$1"],0),_static_2:r(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
mA(a,b,c,d){return{i:a,p:b,e:c,x:d}},
lh(a){var s,r,q,p,o,n="_$dart_js",m=a[v.dispatchPropertyName]
if(m==null)if($.mx==null){A.tT()
m=a[v.dispatchPropertyName]}if(m!=null){s=m.p
if(!1===s)return m.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return m.i
if(m.e===r)throw A.e(A.eA("Return interceptor for "+A.x(s(a,m))))}q=a.constructor
if(q==null)p=null
else{o=$.kQ
if(o==null)o=$.kQ=A.lg(n)
p=q[o]}if(p!=null)return p
p=A.u_(a)
if(p!=null)return p
if(typeof a=="function")return B.cp
s=Object.getPrototypeOf(a)
if(s==null)return B.bk
if(s===Object.prototype)return B.bk
if(typeof q=="function"){o=$.kQ
if(o==null)o=$.kQ=A.lg(n)
Object.defineProperty(q,o,{value:B.au,enumerable:false,writable:true,configurable:true})
return B.au}return B.au},
lH(a,b){if(a<0||a>4294967295)throw A.e(A.ad(a,0,4294967295,"length",null))
return J.nl(new Array(a),b)},
ak(a,b){if(a<0||a>4294967295)throw A.e(A.ad(a,0,4294967295,"length",null))
return J.nl(new Array(a),b)},
lI(a,b){if(a<0)throw A.e(A.aU("Length must be a non-negative integer: "+a,null))
return A.m(new Array(a),b.m("o<0>"))},
e5(a,b){return A.m(new Array(a),b.m("o<0>"))},
nl(a,b){var s=A.m(a,b.m("o<0>"))
s.$flags=1
return s},
nm(a){if(a<256)switch(a){case 9:case 10:case 11:case 12:case 13:case 32:case 133:case 160:return!0
default:return!1}switch(a){case 5760:case 8192:case 8193:case 8194:case 8195:case 8196:case 8197:case 8198:case 8199:case 8200:case 8201:case 8202:case 8232:case 8233:case 8239:case 8287:case 12288:case 65279:return!0
default:return!1}},
pK(a,b){var s,r
for(s=a.length;b<s;){r=a.charCodeAt(b)
if(r!==32&&r!==13&&!J.nm(r))break;++b}return b},
pL(a,b){var s,r
for(;b>0;b=s){s=b-1
r=a.charCodeAt(s)
if(r!==32&&r!==13&&!J.nm(r))break}return b},
cw(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.e6.prototype
return J.fW.prototype}if(typeof a=="string")return J.d0.prototype
if(a==null)return J.e7.prototype
if(typeof a=="boolean")return J.fV.prototype
if(Array.isArray(a))return J.o.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bd.prototype
if(typeof a=="symbol")return J.d2.prototype
if(typeof a=="bigint")return J.d1.prototype
return a}if(a instanceof A.n)return a
return J.lh(a)},
a3(a){if(typeof a=="string")return J.d0.prototype
if(a==null)return a
if(Array.isArray(a))return J.o.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bd.prototype
if(typeof a=="symbol")return J.d2.prototype
if(typeof a=="bigint")return J.d1.prototype
return a}if(a instanceof A.n)return a
return J.lh(a)},
aB(a){if(a==null)return a
if(Array.isArray(a))return J.o.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bd.prototype
if(typeof a=="symbol")return J.d2.prototype
if(typeof a=="bigint")return J.d1.prototype
return a}if(a instanceof A.n)return a
return J.lh(a)},
bt(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.bd.prototype
if(typeof a=="symbol")return J.d2.prototype
if(typeof a=="bigint")return J.d1.prototype
return a}if(a instanceof A.n)return a
return J.lh(a)},
aG(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.cw(a).O(a,b)},
c(a,b){if(typeof b==="number")if(Array.isArray(a)||A.oy(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.aB(a).n(a,b)},
V(a,b,c){if(typeof b==="number")if((Array.isArray(a)||A.oy(a,a[v.dispatchPropertyName]))&&!(a.$flags&2)&&b>>>0===b&&b<a.length)return a[b]=c
return J.aB(a).l(a,b,c)},
p4(a,b,c){return J.bt(a).fn(a,b,c)},
mN(a,b,c){return J.bt(a).fo(a,b,c)},
p5(a,b,c){return J.bt(a).fp(a,b,c)},
p6(a,b,c){return J.bt(a).fq(a,b,c)},
lu(a,b,c){return J.bt(a).fs(a,b,c)},
p7(a){return J.bt(a).ft(a)},
p8(a,b,c){return J.bt(a).cS(a,b,c)},
au(a,b,c){return J.bt(a).fu(a,b,c)},
C(a){return J.bt(a).fv(a)},
aj(a,b,c){return J.bt(a).cT(a,b,c)},
mO(a,b){return J.aB(a).bq(a,b)},
dB(a,b,c,d){return J.aB(a).an(a,b,c,d)},
p9(a){return J.aB(a).gfF(a)},
av(a){return J.cw(a).gG(a)},
f6(a){return J.aB(a).gF(a)},
mP(a){return J.aB(a).gcX(a)},
bM(a){return J.a3(a).gp(a)},
lv(a){return J.cw(a).gao(a)},
mQ(a,b,c){return J.aB(a).bC(a,b,c)},
lw(a,b){return J.aB(a).be(a,b)},
lx(a,b,c){return J.aB(a).bO(a,b,c)},
pa(a,b){return J.aB(a).fV(a,b)},
dC(a){return J.cw(a).B(a)},
fI:function fI(){},
fV:function fV(){},
e7:function e7(){},
e9:function e9(){},
by:function by(){},
hd:function hd(){},
eB:function eB(){},
bd:function bd(){},
d1:function d1(){},
d2:function d2(){},
o:function o(a){this.$ti=a},
fU:function fU(){},
j5:function j5(a){this.$ti=a},
f8:function f8(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
e8:function e8(){},
e6:function e6(){},
fW:function fW(){},
d0:function d0(){}},A={lJ:function lJ(){},
np(a){return new A.d3("Field '"+a+"' has not been initialized.")},
pN(a){return new A.d3("Field '"+a+"' has already been initialized.")},
bl(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
jT(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
f3(a,b,c){return a},
my(a){var s,r
for(s=$.ct.length,r=0;r<s;++r)if(a===$.ct[r])return!0
return!1},
dg(a,b,c,d){A.aM(b,"start")
if(c!=null){A.aM(c,"end")
if(b>c)A.X(A.ad(b,0,c,"start",null))}return new A.ez(a,b,c,d.m("ez<0>"))},
pR(a,b,c,d){if(t.R.b(a))return new A.bP(a,b,c.m("@<0>").aC(d).m("bP<1,2>"))
return new A.bf(a,b,c.m("@<0>").aC(d).m("bf<1,2>"))},
nE(a,b,c){var s="count"
if(t.R.b(a)){A.i8(b,s)
A.aM(b,s)
return new A.cK(a,b,c.m("cK<0>"))}A.i8(b,s)
A.aM(b,s)
return new A.bk(a,b,c.m("bk<0>"))},
e4(){return new A.bE("No element")},
nk(){return new A.bE("Too few elements")},
dE:function dE(a,b){this.a=a
this.$ti=b},
dF:function dF(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
d3:function d3(a){this.a=a},
aV:function aV(a){this.a=a},
jN:function jN(){},
u:function u(){},
aD:function aD(){},
ez:function ez(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
d4:function d4(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bf:function bf(a,b,c){this.a=a
this.b=b
this.$ti=c},
bP:function bP(a,b,c){this.a=a
this.b=b
this.$ti=c},
h2:function h2(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
bg:function bg(a,b,c){this.a=a
this.b=b
this.$ti=c},
eH:function eH(a,b,c){this.a=a
this.b=b
this.$ti=c},
hG:function hG(a,b,c){this.a=a
this.b=b
this.$ti=c},
bk:function bk(a,b,c){this.a=a
this.b=b
this.$ti=c},
cK:function cK(a,b,c){this.a=a
this.b=b
this.$ti=c},
hr:function hr(a,b,c){this.a=a
this.b=b
this.$ti=c},
bQ:function bQ(a){this.$ti=a},
fm:function fm(a){this.$ti=a},
dO:function dO(){},
hy:function hy(){},
dh:function dh(){},
jS:function jS(){},
ow(a,b){var s=new A.e1(a,b.m("e1<0>"))
s.hs(a)
return s},
oH(a){var s=A.oG(a)
if(s!=null)return s
return"minified:"+a},
oy(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.eA.b(a)},
x(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.dC(a)
return s},
d9(a){var s,r=$.ny
if(r==null)r=$.ny=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
qc(a,b){var s,r=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(r==null)return null
s=r[3]
if(s!=null)return parseInt(a,10)
if(r[2]!=null)return parseInt(a,16)
return null},
he(a){var s,r,q,p
if(a instanceof A.n)return A.aF(A.aR(a),null)
s=J.cw(a)
if(s===B.cl||s===B.cq||t.bI.b(a)){r=B.az(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.aF(A.aR(a),null)},
qd(a){var s,r,q
if(typeof a=="number"||A.i3(a))return J.dC(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.bN)return a.B(0)
s=$.p3()
for(r=0;r<1;++r){q=s[r].l8(a)
if(q!=null)return q}return"Instance of '"+A.he(a)+"'"},
nx(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
qe(a){var s,r,q,p=A.m([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a5)(a),++r){q=a[r]
if(!A.l7(q))throw A.e(A.cu(q))
if(q<=65535)p.push(q)
else if(q<=1114111){p.push(55296+(B.a.j(q-65536,10)&1023))
p.push(56320+(q&1023))}else throw A.e(A.cu(q))}return A.nx(p)},
nz(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.l7(q))throw A.e(A.cu(q))
if(q<0)throw A.e(A.cu(q))
if(q>65535)return A.qe(a)}return A.nx(a)},
qf(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
da(a){var s
if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.a.j(s,10)|55296)>>>0,s&1023|56320)}throw A.e(A.ad(a,0,1114111,null,null))},
d8(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
qb(a){var s=A.d8(a).getUTCFullYear()+0
return s},
q9(a){var s=A.d8(a).getUTCMonth()+1
return s},
q5(a){var s=A.d8(a).getUTCDate()+0
return s},
q6(a){var s=A.d8(a).getUTCHours()+0
return s},
q8(a){var s=A.d8(a).getUTCMinutes()+0
return s},
qa(a){var s=A.d8(a).getUTCSeconds()+0
return s},
q7(a){var s=A.d8(a).getUTCMilliseconds()+0
return s},
q4(a){var s=a.$thrownJsError
if(s==null)return null
return A.b4(s)},
nA(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.Z(a,s)
a.$thrownJsError=s
s.stack=b.B(0)}},
mv(a,b){var s,r="index",q=null
if(!A.l7(b))return new A.aT(!0,b,r,q)
s=J.bM(a)
if(b<0||b>=s)return A.iQ(b,s,a,q,r)
return new A.bj(q,q,!0,b,r,"Value not in range")},
tK(a,b,c){if(a<0||a>c)return A.ad(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.ad(b,a,c,"end",null)
return new A.aT(!0,b,"end",null)},
cu(a){return new A.aT(!0,a,null,null)},
e(a){return A.Z(a,new Error())},
Z(a,b){var s
if(a==null)a=new A.bm()
b.dartException=a
s=A.u9
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
u9(){return J.dC(this.dartException)},
X(a,b){throw A.Z(a,b==null?new Error():b)},
a(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.X(A.rQ(a,b,c),s)},
rQ(a,b,c){var s,r,q,p,o,n,m,l,k
if(typeof b=="string")s=b
else{r="[]=;add;removeWhere;retainWhere;removeRange;setRange;setInt8;setInt16;setInt32;setUint8;setUint16;setUint32;setFloat32;setFloat64".split(";")
q=r.length
p=b
if(p>q){c=p/q|0
p%=q}s=r[p]}o=typeof c=="string"?c:"modify;remove from;add to".split(";")[c]
n=t.j.b(a)?"list":"ByteData"
m=a.$flags|0
l="a "
if((m&4)!==0)k="constant "
else if((m&2)!==0){k="unmodifiable "
l="an "}else k=(m&1)!==0?"fixed-length ":""
return new A.eC("'"+s+"': Cannot "+o+" "+l+k+n)},
a5(a){throw A.e(A.aJ(a))},
bn(a){var s,r,q,p,o,n
a=A.u4(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.m([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.k4(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
k5(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
nH(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
lL(a,b){var s=b==null,r=s?null:b.method
return new A.h_(a,r,s?null:b.receiver)},
ar(a){if(a==null)return new A.jj(a)
if(a instanceof A.dJ)return A.bK(a,a.a)
if(typeof a!=="object")return a
if("dartException" in a)return A.bK(a,a.dartException)
return A.tz(a)},
bK(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
tz(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.a.j(r,16)&8191)===10)switch(q){case 438:return A.bK(a,A.lL(A.x(s)+" (Error "+q+")",null))
case 445:case 5007:A.x(s)
return A.bK(a,new A.em())}}if(a instanceof TypeError){p=$.oM()
o=$.oN()
n=$.oO()
m=$.oP()
l=$.oS()
k=$.oT()
j=$.oR()
$.oQ()
i=$.oV()
h=$.oU()
g=p.bk(s)
if(g!=null)return A.bK(a,A.lL(s,g))
else{g=o.bk(s)
if(g!=null){g.method="call"
return A.bK(a,A.lL(s,g))}else if(n.bk(s)!=null||m.bk(s)!=null||l.bk(s)!=null||k.bk(s)!=null||j.bk(s)!=null||m.bk(s)!=null||i.bk(s)!=null||h.bk(s)!=null)return A.bK(a,new A.em())}return A.bK(a,new A.hx(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.ew()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.bK(a,new A.aT(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.ew()
return a},
b4(a){var s
if(a instanceof A.dJ)return a.b
if(a==null)return new A.eW(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.eW(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
i5(a){if(a==null)return J.av(a)
if(typeof a=="object")return A.d9(a)
return J.av(a)},
tG(a){if(typeof a=="number")return B.b.gG(a)
if(a instanceof A.i_)return A.d9(a)
if(a instanceof A.jS)return a.gG(0)
return A.i5(a)},
oq(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.l(0,a[s],a[r])}return b},
t0(a,b,c,d,e,f){switch(b){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.e(new A.kC("Unsupported number of arguments for wrapped closure"))},
f4(a,b){var s=a.$identity
if(!!s)return s
s=A.tH(a,b)
a.$identity=s
return s},
tH(a,b){var s
switch(b){case 0:s=a.$0
break
case 1:s=a.$1
break
case 2:s=a.$2
break
case 3:s=a.$3
break
case 4:s=a.$4
break
default:s=null}if(s!=null)return s.bind(a)
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.t0)},
pj(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.jP().constructor.prototype):Object.create(new A.dD(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.mY(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.pf(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.mY(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
pf(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.e("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.pd)}throw A.e("Error in functionType of tearoff")},
pg(a,b,c,d){var s=A.mX
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
mY(a,b,c,d){if(c)return A.pi(a,b,d)
return A.pg(b.length,d,a,b)},
ph(a,b,c,d){var s=A.mX,r=A.pe
switch(b?-1:a){case 0:throw A.e(new A.hq("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
pi(a,b,c){var s,r
if($.mV==null)$.mV=A.mU("interceptor")
if($.mW==null)$.mW=A.mU("receiver")
s=b.length
r=A.ph(s,c,a,b)
return r},
mq(a){return A.pj(a)},
pd(a,b){return A.l_(v.typeUniverse,A.aR(a.a),b)},
mX(a){return a.a},
pe(a){return a.b},
mU(a){var s,r,q,p=new A.dD("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.e(A.aU("Field name "+a+" not found.",null))},
lg(a){return v.getIsolateTag(a)},
vz(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
u_(a){var s,r,q,p,o,n=$.ou.$1(a),m=$.le[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.lm[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=$.ok.$2(a,n)
if(q!=null){m=$.le[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.lm[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.lq(s)
$.le[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.lm[n]=s
return s}if(p==="-"){o=A.lq(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.oB(a,s)
if(p==="*")throw A.e(A.eA(n))
if(v.leafTags[n]===true){o=A.lq(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.oB(a,s)},
oB(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.mA(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
lq(a){return J.mA(a,!1,null,!!a.$iaC)},
u1(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.lq(s)
else return J.mA(s,c,null,null)},
tT(){if(!0===$.mx)return
$.mx=!0
A.tU()},
tU(){var s,r,q,p,o,n,m,l
$.le=Object.create(null)
$.lm=Object.create(null)
A.tS()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.oC.$1(o)
if(n!=null){m=A.u1(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
tS(){var s,r,q,p,o,n,m=B.bR()
m=A.dx(B.bS,A.dx(B.bT,A.dx(B.aA,A.dx(B.aA,A.dx(B.bU,A.dx(B.bV,A.dx(B.bW(B.az),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.ou=new A.lj(p)
$.ok=new A.lk(o)
$.oC=new A.ll(n)},
dx(a,b){return a(b)||b},
tJ(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
u4(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
cJ:function cJ(){},
ii:function ii(a,b,c){this.a=a
this.b=b
this.c=c},
dH:function dH(a,b,c){this.a=a
this.b=b
this.$ti=c},
eP:function eP(a,b){this.a=a
this.$ti=b},
dq:function dq(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bU:function bU(a,b){this.a=a
this.$ti=b},
dG:function dG(){},
dP:function dP(a,b){this.a=a
this.$ti=b},
iV:function iV(){},
e1:function e1(a,b){this.a=a
this.$ti=b},
eu:function eu(){},
k4:function k4(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
em:function em(){},
h_:function h_(a,b,c){this.a=a
this.b=b
this.c=c},
hx:function hx(a){this.a=a},
jj:function jj(a){this.a=a},
dJ:function dJ(a,b){this.a=a
this.b=b},
eW:function eW(a){this.a=a
this.b=null},
bN:function bN(){},
ig:function ig(){},
ih:function ih(){},
jU:function jU(){},
jP:function jP(){},
dD:function dD(a,b){this.a=a
this.b=b},
hq:function hq(a){this.a=a},
aY:function aY(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
jd:function jd(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
c5:function c5(a,b){this.a=a
this.$ti=b},
ab:function ab(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
je:function je(a,b){this.a=a
this.$ti=b},
bz:function bz(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
be:function be(a,b){this.a=a
this.$ti=b},
h0:function h0(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
c4:function c4(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
lj:function lj(a){this.a=a},
lk:function lk(a){this.a=a},
ll:function ll(a){this.a=a},
u8(a){throw A.Z(new A.d3("Field '"+a+"' has been assigned during initialization."),new Error())},
b(){throw A.Z(A.np(""),new Error())},
y(){throw A.Z(A.pN(""),new Error())},
rc(){var s=new A.kx()
return s.b=s},
kx:function kx(){this.b=null},
ap(a,b,c){},
t(a){var s,r,q
if(t.aP.b(a))return a
s=J.a3(a)
r=A.a0(s.gp(a),null,!1,t.z)
for(q=0;q<s.gp(a);++q)r[q]=s.n(a,q)
return r},
pS(a,b,c){var s
A.ap(a,b,c)
s=new DataView(a,b,c)
return s},
pT(a){return new Float32Array(a)},
pU(a,b,c){A.ap(a,b,c)
c=B.a.V(a.byteLength-b,4)
return new Float32Array(a,b,c)},
pV(a,b,c){A.ap(a,b,c)
c=B.a.V(a.byteLength-b,2)
return new Int16Array(a,b,c)},
pW(a){return new Int32Array(a)},
pX(a,b,c){A.ap(a,b,c)
c=B.a.V(a.byteLength-b,4)
return new Int32Array(a,b,c)},
nu(a){return new Int8Array(a)},
pY(a,b,c){A.ap(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
pZ(a){return new Uint16Array(a)},
q_(a,b,c){A.ap(a,b,c)
c=B.a.V(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
q0(a){return new Uint32Array(a)},
q1(a,b,c){A.ap(a,b,c)
c=B.a.V(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
el(a){return new Uint8Array(a)},
q2(a){return new Uint8Array(A.t(a))},
q3(a,b,c){A.ap(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
bs(a,b,c){if(a>>>0!==a||a>=c)throw A.e(A.mv(b,a))},
i2(a,b,c){var s
if(!(a>>>0!==a))if(b==null)s=a>c
else s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.e(A.tK(a,b,c))
if(b==null)return c
return b},
d5:function d5(){},
eh:function eh(){},
i0:function i0(a){this.a=a},
h3:function h3(){},
d6:function d6(){},
eg:function eg(){},
aE:function aE(){},
eb:function eb(){},
ec:function ec(){},
ed:function ed(){},
ee:function ee(){},
ef:function ef(){},
ei:function ei(){},
ej:function ej(){},
ek:function ek(){},
c7:function c7(){},
eR:function eR(){},
eS:function eS(){},
eT:function eT(){},
eU:function eU(){},
m4(a,b){var s=b.c
return s==null?b.c=A.f_(a,"bu",[b.x]):s},
nD(a){var s=a.w
if(s===6||s===7)return A.nD(a.x)
return s===11||s===12},
qh(a){return a.as},
U(a){return A.kZ(v.typeUniverse,a,!1)},
ox(a,b){var s,r,q,p,o
if(a==null)return null
s=b.y
r=a.Q
if(r==null)r=a.Q=new Map()
q=b.as
p=r.get(q)
if(p!=null)return p
o=A.bJ(v.typeUniverse,a.x,s,0)
r.set(q,o)
return o},
bJ(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.bJ(a1,s,a3,a4)
if(r===s)return a2
return A.nX(a1,r,!0)
case 7:s=a2.x
r=A.bJ(a1,s,a3,a4)
if(r===s)return a2
return A.nW(a1,r,!0)
case 8:q=a2.y
p=A.dw(a1,q,a3,a4)
if(p===q)return a2
return A.f_(a1,a2.x,p)
case 9:o=a2.x
n=A.bJ(a1,o,a3,a4)
m=a2.y
l=A.dw(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.md(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.dw(a1,j,a3,a4)
if(i===j)return a2
return A.nY(a1,k,i)
case 11:h=a2.x
g=A.bJ(a1,h,a3,a4)
f=a2.y
e=A.tv(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.nV(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.dw(a1,d,a3,a4)
o=a2.x
n=A.bJ(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.me(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.e(A.fa("Attempted to substitute unexpected RTI kind "+a0))}},
dw(a,b,c,d){var s,r,q,p,o=b.length,n=A.l2(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.bJ(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
tw(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.l2(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.bJ(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
tv(a,b,c,d){var s,r=b.a,q=A.dw(a,r,c,d),p=b.b,o=A.dw(a,p,c,d),n=b.c,m=A.tw(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.hP()
s.a=q
s.b=o
s.c=m
return s},
m(a,b){a[v.arrayRti]=b
return a},
i4(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.tQ(s)
return a.$S()}return null},
tV(a,b){var s
if(A.nD(b))if(a instanceof A.bN){s=A.i4(a)
if(s!=null)return s}return A.aR(a)},
aR(a){if(a instanceof A.n)return A.j(a)
if(Array.isArray(a))return A.br(a)
return A.mm(J.cw(a))},
br(a){var s=a[v.arrayRti],r=t.cO
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
j(a){var s=a.$ti
return s!=null?s:A.mm(a)},
mm(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.rZ(a,s)},
rZ(a,b){var s=a instanceof A.bN?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.rv(v.typeUniverse,s.name)
b.$ccache=r
return r},
tQ(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.kZ(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
dz(a){return A.aQ(A.j(a))},
mw(a){var s=A.i4(a)
return A.aQ(s==null?A.aR(a):s)},
tu(a){var s=a instanceof A.bN?A.i4(a):null
if(s!=null)return s
if(t.ci.b(a))return J.lv(a).a
if(Array.isArray(a))return A.br(a)
return A.aR(a)},
aQ(a){var s=a.r
return s==null?a.r=new A.i_(a):s},
aS(a){return A.aQ(A.kZ(v.typeUniverse,a,!1))},
rY(a){var s=this
s.b=A.ts(s)
return s.b(a)},
ts(a){var s,r,q,p
if(a===t.K)return A.t6
if(A.cx(a))return A.ta
s=a.w
if(s===6)return A.rV
if(s===1)return A.oa
if(s===7)return A.t1
r=A.tr(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.cx)){a.f="$i"+q
if(q==="A")return A.t4
if(a===t.m)return A.t3
return A.t9}}else if(s===10){p=A.tJ(a.x,a.y)
return p==null?A.oa:p}return A.rT},
tr(a){if(a.w===8){if(a===t.p)return A.l7
if(a===t.V||a===t.n)return A.t5
if(a===t.N)return A.t8
if(a===t.y)return A.i3}return null},
rX(a){var s=this,r=A.rS
if(A.cx(s))r=A.rJ
else if(s===t.K)r=A.l4
else if(A.dA(s)){r=A.rU
if(s===t.I)r=A.rE
else if(s===t.E)r=A.rI
else if(s===t.fQ)r=A.rB
else if(s===t.cg)r=A.rH
else if(s===t.cD)r=A.rD
else if(s===t.bX)r=A.rF}else if(s===t.p)r=A.z
else if(s===t.N)r=A.mf
else if(s===t.y)r=A.rA
else if(s===t.n)r=A.rG
else if(s===t.V)r=A.rC
else if(s===t.m)r=A.o2
s.a=r
return s.a(a)},
rT(a){var s=this
if(a==null)return A.dA(s)
return A.tX(v.typeUniverse,A.tV(a,s),s)},
rV(a){if(a==null)return!0
return this.x.b(a)},
t9(a){var s,r=this
if(a==null)return A.dA(r)
s=r.f
if(a instanceof A.n)return!!a[s]
return!!J.cw(a)[s]},
t4(a){var s,r=this
if(a==null)return A.dA(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.n)return!!a[s]
return!!J.cw(a)[s]},
t3(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.n)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
o9(a){if(typeof a=="object"){if(a instanceof A.n)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
rS(a){var s=this
if(a==null){if(A.dA(s))return a}else if(s.b(a))return a
throw A.Z(A.o4(a,s),new Error())},
rU(a){var s=this
if(a==null||s.b(a))return a
throw A.Z(A.o4(a,s),new Error())},
o4(a,b){return new A.eY("TypeError: "+A.nP(a,A.aF(b,null)))},
nP(a,b){return A.im(a)+": type '"+A.aF(A.tu(a),null)+"' is not a subtype of type '"+b+"'"},
aO(a,b){return new A.eY("TypeError: "+A.nP(a,b))},
t1(a){var s=this
return s.x.b(a)||A.m4(v.typeUniverse,s).b(a)},
t6(a){return a!=null},
l4(a){if(a!=null)return a
throw A.Z(A.aO(a,"Object"),new Error())},
ta(a){return!0},
rJ(a){return a},
oa(a){return!1},
i3(a){return!0===a||!1===a},
rA(a){if(!0===a)return!0
if(!1===a)return!1
throw A.Z(A.aO(a,"bool"),new Error())},
rB(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.Z(A.aO(a,"bool?"),new Error())},
rC(a){if(typeof a=="number")return a
throw A.Z(A.aO(a,"double"),new Error())},
rD(a){if(typeof a=="number")return a
if(a==null)return a
throw A.Z(A.aO(a,"double?"),new Error())},
l7(a){return typeof a=="number"&&Math.floor(a)===a},
z(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.Z(A.aO(a,"int"),new Error())},
rE(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.Z(A.aO(a,"int?"),new Error())},
t5(a){return typeof a=="number"},
rG(a){if(typeof a=="number")return a
throw A.Z(A.aO(a,"num"),new Error())},
rH(a){if(typeof a=="number")return a
if(a==null)return a
throw A.Z(A.aO(a,"num?"),new Error())},
t8(a){return typeof a=="string"},
mf(a){if(typeof a=="string")return a
throw A.Z(A.aO(a,"String"),new Error())},
rI(a){if(typeof a=="string")return a
if(a==null)return a
throw A.Z(A.aO(a,"String?"),new Error())},
o2(a){if(A.o9(a))return a
throw A.Z(A.aO(a,"JSObject"),new Error())},
rF(a){if(a==null)return a
if(A.o9(a))return a
throw A.Z(A.aO(a,"JSObject?"),new Error())},
og(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.aF(a[q],b)
return s},
th(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.og(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.aF(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
o5(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=", ",a0=null
if(a3!=null){s=a3.length
if(a2==null)a2=A.m([],t.s)
else a0=a2.length
r=a2.length
for(q=s;q>0;--q)a2.push("T"+(r+q))
for(p=t.X,o="<",n="",q=0;q<s;++q,n=a){o=o+n+a2[a2.length-1-q]
m=a3[q]
l=m.w
if(!(l===2||l===3||l===4||l===5||m===p))o+=" extends "+A.aF(m,a2)}o+=">"}else o=""
p=a1.x
k=a1.y
j=k.a
i=j.length
h=k.b
g=h.length
f=k.c
e=f.length
d=A.aF(p,a2)
for(c="",b="",q=0;q<i;++q,b=a)c+=b+A.aF(j[q],a2)
if(g>0){c+=b+"["
for(b="",q=0;q<g;++q,b=a)c+=b+A.aF(h[q],a2)
c+="]"}if(e>0){c+=b+"{"
for(b="",q=0;q<e;q+=3,b=a){c+=b
if(f[q+1])c+="required "
c+=A.aF(f[q+2],a2)+" "+f[q]}c+="}"}if(a0!=null){a2.toString
a2.length=a0}return o+"("+c+") => "+d},
aF(a,b){var s,r,q,p,o,n,m=a.w
if(m===5)return"erased"
if(m===2)return"dynamic"
if(m===3)return"void"
if(m===1)return"Never"
if(m===4)return"any"
if(m===6){s=a.x
r=A.aF(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(m===7)return"FutureOr<"+A.aF(a.x,b)+">"
if(m===8){p=A.ty(a.x)
o=a.y
return o.length>0?p+("<"+A.og(o,b)+">"):p}if(m===10)return A.th(a,b)
if(m===11)return A.o5(a,b,null)
if(m===12)return A.o5(a.x,b,a.y)
if(m===13){n=a.x
return b[b.length-1-n]}return"?"},
ty(a){var s=A.oG(a)
if(s!=null)return s
return"minified:"+a},
rw(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
rv(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.kZ(a,b,!1)
else if(typeof m=="number"){s=m
r=A.f0(a,5,"#")
q=A.l2(s)
for(p=0;p<s;++p)q[p]=r
o=A.f_(a,b,q)
n[b]=o
return o}else return m},
rt(a,b){return A.o0(a.tR,b)},
rs(a,b){return A.o0(a.eT,b)},
kZ(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.nZ(a,null,b,!1)
r.set(b,s)
return s},
l_(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.nZ(a,b,c,!0)
q.set(c,r)
return r},
ru(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.md(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
nZ(a,b,c,d){return A.rk(A.re(a,b,c,d))},
bI(a,b){b.a=A.rX
b.b=A.rY
return b},
f0(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.b0(null,null)
s.w=b
s.as=c
r=A.bI(a,s)
a.eC.set(c,r)
return r},
nX(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.rq(a,b,r,c)
a.eC.set(r,s)
return s},
rq(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.cx(b))if(!(b===t.a||b===t.T))if(s!==6)r=s===7&&A.dA(b.x)
if(r)return b
else if(s===1)return t.a}q=new A.b0(null,null)
q.w=6
q.x=b
q.as=c
return A.bI(a,q)},
nW(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.ro(a,b,r,c)
a.eC.set(r,s)
return s},
ro(a,b,c,d){var s,r
if(d){s=b.w
if(A.cx(b)||b===t.K)return b
else if(s===1)return A.f_(a,"bu",[b])
else if(b===t.a||b===t.T)return t.eH}r=new A.b0(null,null)
r.w=7
r.x=b
r.as=c
return A.bI(a,r)},
rr(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.b0(null,null)
s.w=13
s.x=b
s.as=q
r=A.bI(a,s)
a.eC.set(q,r)
return r},
eZ(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
rn(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
f_(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.eZ(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.b0(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.bI(a,r)
a.eC.set(p,q)
return q},
md(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.eZ(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.b0(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.bI(a,o)
a.eC.set(q,n)
return n},
nY(a,b,c){var s,r,q="+"+(b+"("+A.eZ(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.b0(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.bI(a,s)
a.eC.set(q,r)
return r},
nV(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.eZ(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.eZ(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.rn(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.b0(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.bI(a,p)
a.eC.set(r,o)
return o},
me(a,b,c,d){var s,r=b.as+("<"+A.eZ(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.rp(a,b,c,r,d)
a.eC.set(r,s)
return s},
rp(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.l2(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.bJ(a,b,r,0)
m=A.dw(a,c,r,0)
return A.me(a,n,m,c!==m)}}l=new A.b0(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.bI(a,l)},
re(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
rk(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.rg(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.nT(a,r,l,k,!1)
else if(q===46)r=A.nT(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.cs(a.u,a.e,k.pop()))
break
case 94:k.push(A.rr(a.u,k.pop()))
break
case 35:k.push(A.f0(a.u,5,"#"))
break
case 64:k.push(A.f0(a.u,2,"@"))
break
case 126:k.push(A.f0(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.ri(a,k)
break
case 38:A.rh(a,k)
break
case 63:p=a.u
k.push(A.nX(p,A.cs(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.nW(p,A.cs(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.rf(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.nU(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.rl(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-2)
break
case 43:n=l.indexOf("(",r)
k.push(l.substring(r,n))
k.push(-4)
k.push(a.p)
a.p=k.length
r=n+1
break
default:throw"Bad character "+q}}}m=k.pop()
return A.cs(a.u,a.e,m)},
rg(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
nT(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.rw(s,o.x)[p]
if(n==null)A.X('No "'+p+'" in "'+A.qh(o)+'"')
d.push(A.l_(s,o,n))}else d.push(p)
return m},
ri(a,b){var s,r=a.u,q=A.nS(a,b),p=b.pop()
if(typeof p=="string")b.push(A.f_(r,p,q))
else{s=A.cs(r,a.e,p)
switch(s.w){case 11:b.push(A.me(r,s,q,a.n))
break
default:b.push(A.md(r,s,q))
break}}},
rf(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.nS(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.cs(p,a.e,o)
q=new A.hP()
q.a=s
q.b=n
q.c=m
b.push(A.nV(p,r,q))
return
case-4:b.push(A.nY(p,b.pop(),s))
return
default:throw A.e(A.fa("Unexpected state under `()`: "+A.x(o)))}},
rh(a,b){var s=b.pop()
if(0===s){b.push(A.f0(a.u,1,"0&"))
return}if(1===s){b.push(A.f0(a.u,4,"1&"))
return}throw A.e(A.fa("Unexpected extended operation "+A.x(s)))},
nS(a,b){var s=b.splice(a.p)
A.nU(a.u,a.e,s)
a.p=b.pop()
return s},
cs(a,b,c){if(typeof c=="string")return A.f_(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.rj(a,b,c)}else return c},
nU(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.cs(a,b,c[s])},
rl(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.cs(a,b,c[s])},
rj(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.e(A.fa("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.e(A.fa("Bad index "+c+" for "+b.B(0)))},
tX(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.a2(a,b,null,c,null)
r.set(c,s)}return s},
a2(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.cx(d))return!0
s=b.w
if(s===4)return!0
if(A.cx(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.a2(a,c[b.x],c,d,e))return!0
q=d.w
p=t.a
if(b===p||b===t.T){if(q===7)return A.a2(a,b,c,d.x,e)
return d===p||d===t.T||q===6}if(d===t.K){if(s===7)return A.a2(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.a2(a,b.x,c,d,e))return!1
return A.a2(a,A.m4(a,b),c,d,e)}if(s===6)return A.a2(a,p,c,d,e)&&A.a2(a,b.x,c,d,e)
if(q===7){if(A.a2(a,b,c,d.x,e))return!0
return A.a2(a,b,c,A.m4(a,d),e)}if(q===6)return A.a2(a,b,c,p,e)||A.a2(a,b,c,d.x,e)
if(r)return!1
p=s!==11
if((!p||s===12)&&d===t.b8)return!0
o=s===10
if(o&&d===t.gT)return!0
if(q===12){if(b===t.e)return!0
if(s!==12)return!1
n=b.y
m=d.y
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.a2(a,j,c,i,e)||!A.a2(a,i,e,j,c))return!1}return A.o8(a,b.x,c,d.x,e)}if(q===11){if(b===t.e)return!0
if(p)return!1
return A.o8(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.t2(a,b,c,d,e)}if(o&&q===10)return A.t7(a,b,c,d,e)
return!1},
o8(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.a2(a3,a4.x,a5,a6.x,a7))return!1
s=a4.y
r=a6.y
q=s.a
p=r.a
o=q.length
n=p.length
if(o>n)return!1
m=n-o
l=s.b
k=r.b
j=l.length
i=k.length
if(o+j<n+i)return!1
for(h=0;h<o;++h){g=q[h]
if(!A.a2(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.a2(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.a2(a3,k[h],a7,g,a5))return!1}f=s.c
e=r.c
d=f.length
c=e.length
for(b=0,a=0;a<c;a+=3){a0=e[a]
for(;;){if(b>=d)return!1
a1=f[b]
b+=3
if(a0<a1)return!1
a2=f[b-2]
if(a1<a0){if(a2)return!1
continue}g=e[a+1]
if(a2&&!g)return!1
g=f[b-1]
if(!A.a2(a3,e[a+2],a7,g,a5))return!1
break}}while(b<d){if(f[b+1])return!1
b+=3}return!0},
t2(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.l_(a,b,r[o])
return A.o1(a,p,null,c,d.y,e)}return A.o1(a,b.y,null,c,d.y,e)},
o1(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.a2(a,b[s],d,e[s],f))return!1
return!0},
t7(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.a2(a,r[s],c,q[s],e))return!1
return!0},
dA(a){var s=a.w,r=!0
if(!(a===t.a||a===t.T))if(!A.cx(a))if(s!==6)r=s===7&&A.dA(a.x)
return r},
cx(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
o0(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
l2(a){return a>0?new Array(a):v.typeUniverse.sEA},
b0:function b0(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
hP:function hP(){this.c=this.b=this.a=null},
i_:function i_(a){this.a=a},
hN:function hN(){},
eY:function eY(a){this.a=a},
r8(){var s,r,q
if(self.scheduleImmediate!=null)return A.tA()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.f4(new A.ks(s),1)).observe(r,{childList:true})
return new A.kr(s,r,q)}else if(self.setImmediate!=null)return A.tB()
return A.tC()},
r9(a){self.scheduleImmediate(A.f4(new A.kt(a),0))},
ra(a){self.setImmediate(A.f4(new A.ku(a),0))},
rb(a){A.rm(0,a)},
rm(a,b){var s=new A.kW()
s.hC(a,b)
return s},
mo(a){return new A.hH(new A.R($.H,a.m("R<0>")),a.m("hH<0>"))},
mj(a,b){a.$2(0,null)
b.b=!0
return b.a},
mg(a,b){A.rK(a,b)},
mi(a,b){b.cV(a)},
mh(a,b){b.dS(A.ar(a),A.b4(a))},
rK(a,b){var s,r,q=new A.l5(b),p=new A.l6(b)
if(a instanceof A.R)a.fh(q,p,t.z)
else{s=t.z
if(a instanceof A.R)a.fW(q,p,s)
else{r=new A.R($.H,t.eI)
r.a=8
r.c=a
r.fh(q,p,s)}}},
mp(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.H.d2(new A.l9(s))},
ly(a){var s
if(t.C.b(a)){s=a.gc4()
if(s!=null)return s}return B.H},
t_(a,b){if($.H===B.p)return null
return null},
o7(a,b){if($.H!==B.p)A.t_(a,b)
if(b==null)if(t.C.b(a)){b=a.gc4()
if(b==null){A.nA(a,B.H)
b=B.H}}else b=B.H
else if(t.C.b(a))A.nA(a,b)
return new A.aI(a,b)},
nQ(a,b){var s=new A.R($.H,b.m("R<0>"))
s.a=8
s.c=a
return s},
m9(a,b,c){var s,r,q,p={},o=p.a=a
while(s=o.a,(s&4)!==0){o=o.c
p.a=o}if(o===b){s=A.qi()
b.df(new A.aI(new A.aT(!0,o,null,"Cannot complete a future with itself"),s))
return}r=b.a&1
s=o.a=s|r
if((s&24)===0){q=b.c
b.a=b.a&1|4
b.c=o
o.f4(q)
return}if(!c)if(b.c==null)o=(s&16)===0||r!==0
else o=!1
else o=!0
if(o){q=b.cc()
b.cB(p.a)
A.cr(b,q)
return}b.a^=2
A.dv(null,null,b.b,new A.kG(p,b))},
cr(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g={},f=g.a=a
for(;;){s={}
r=f.a
q=(r&16)===0
p=!q
if(b==null){if(p&&(r&1)===0){f=f.c
A.du(f.a,f.b)}return}s.a=b
o=b.a
for(f=b;o!=null;f=o,o=n){f.a=null
A.cr(g.a,f)
s.a=o
n=o.a}r=g.a
m=r.c
s.b=p
s.c=m
if(q){l=f.c
l=(l&1)!==0||(l&15)===8}else l=!0
if(l){k=f.b.b
if(p){r=r.b===k
r=!(r||r)}else r=!1
if(r){A.du(m.a,m.b)
return}j=$.H
if(j!==k)$.H=k
else j=null
f=f.c
if((f&15)===8)new A.kK(s,g,p).$0()
else if(q){if((f&1)!==0)new A.kJ(s,m).$0()}else if((f&2)!==0)new A.kI(g,s).$0()
if(j!=null)$.H=j
f=s.c
if(f instanceof A.R){r=s.a.$ti
r=r.m("bu<2>").b(f)||!r.y[1].b(f)}else r=!1
if(r){i=s.a.b
if((f.a&24)!==0){h=i.c
i.c=null
b=i.cO(h)
i.a=f.a&30|i.a&1
i.c=f.c
g.a=f
continue}else A.m9(f,i,!0)
return}}i=s.a.b
h=i.c
i.c=null
b=i.cO(h)
f=s.b
r=s.c
if(!f){i.a=8
i.c=r}else{i.a=i.a&1|16
i.c=r}g.a=i
f=i}},
ti(a,b){if(t.Q.b(a))return b.d2(a)
if(t.B.b(a))return a
throw A.e(A.mR(a,"onError",u.c))},
td(){var s,r
for(s=$.dt;s!=null;s=$.dt){$.f2=null
r=s.b
$.dt=r
if(r==null)$.f1=null
s.a.$0()}},
tt(){$.mn=!0
try{A.td()}finally{$.f2=null
$.mn=!1
if($.dt!=null)$.mH().$1(A.ol())}},
oi(a){var s=new A.hI(a),r=$.f1
if(r==null){$.dt=$.f1=s
if(!$.mn)$.mH().$1(A.ol())}else $.f1=r.b=s},
tq(a){var s,r,q,p=$.dt
if(p==null){A.oi(a)
$.f2=$.f1
return}s=new A.hI(a)
r=$.f2
if(r==null){s.b=p
$.dt=$.f2=s}else{q=r.b
s.b=q
$.f2=r.b=s
if(q==null)$.f1=s}},
oF(a){var s=null,r=$.H
if(B.p===r){A.dv(s,s,B.p,a)
return}A.dv(s,s,r,r.fw(a))},
uY(a,b){A.f3(a,"stream",t.K)
return new A.hY(b.m("hY<0>"))},
nF(a){return new A.eI(null,null,a.m("eI<0>"))},
oh(a){return},
nN(a,b){return b==null?A.tD():b},
nO(a,b){if(b==null)b=A.tF()
if(t.k.b(b))return a.d2(b)
if(t.u.b(b))return b
throw A.e(A.aU(u.h,null))},
te(a){},
tg(a,b){A.du(a,b)},
tf(){},
du(a,b){A.tq(new A.l8(a,b))},
od(a,b,c,d){var s,r=$.H
if(r===c)return d.$0()
$.H=c
s=r
try{r=d.$0()
return r}finally{$.H=s}},
of(a,b,c,d,e){var s,r=$.H
if(r===c)return d.$1(e)
$.H=c
s=r
try{r=d.$1(e)
return r}finally{$.H=s}},
oe(a,b,c,d,e,f){var s,r=$.H
if(r===c)return d.$2(e,f)
$.H=c
s=r
try{r=d.$2(e,f)
return r}finally{$.H=s}},
dv(a,b,c,d){if(B.p!==c){d=c.fw(d)
d=d}A.oi(d)},
ks:function ks(a){this.a=a},
kr:function kr(a,b,c){this.a=a
this.b=b
this.c=c},
kt:function kt(a){this.a=a},
ku:function ku(a){this.a=a},
kW:function kW(){},
kX:function kX(a,b){this.a=a
this.b=b},
hH:function hH(a,b){this.a=a
this.b=!1
this.$ti=b},
l5:function l5(a){this.a=a},
l6:function l6(a){this.a=a},
l9:function l9(a){this.a=a},
aI:function aI(a,b){this.a=a
this.b=b},
bH:function bH(a,b){this.a=a
this.$ti=b},
dl:function dl(a,b,c,d,e,f,g){var _=this
_.ay=0
_.CW=_.ch=null
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.r=_.f=null
_.$ti=g},
hJ:function hJ(){},
eI:function eI(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.r=_.e=_.d=null
_.$ti=c},
hK:function hK(){},
cq:function cq(a,b){this.a=a
this.$ti=b},
dm:function dm(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
R:function R(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
kD:function kD(a,b){this.a=a
this.b=b},
kH:function kH(a,b){this.a=a
this.b=b},
kG:function kG(a,b){this.a=a
this.b=b},
kF:function kF(a,b){this.a=a
this.b=b},
kE:function kE(a,b){this.a=a
this.b=b},
kK:function kK(a,b,c){this.a=a
this.b=b
this.c=c},
kL:function kL(a,b){this.a=a
this.b=b},
kM:function kM(a){this.a=a},
kJ:function kJ(a,b){this.a=a
this.b=b},
kI:function kI(a,b){this.a=a
this.b=b},
hI:function hI(a){this.a=a
this.b=null},
b1:function b1(){},
jQ:function jQ(a,b){this.a=a
this.b=b},
jR:function jR(a,b){this.a=a
this.b=b},
eK:function eK(){},
eL:function eL(){},
eJ:function eJ(){},
kw:function kw(a,b,c){this.a=a
this.b=b
this.c=c},
kv:function kv(a){this.a=a},
ds:function ds(){},
hM:function hM(){},
hL:function hL(a,b){this.b=a
this.a=null
this.$ti=b},
kA:function kA(a,b){this.b=a
this.c=b
this.a=null},
kz:function kz(){},
hV:function hV(a){var _=this
_.a=0
_.c=_.b=null
_.$ti=a},
kT:function kT(a,b){this.a=a
this.b=b},
eM:function eM(a,b){var _=this
_.a=1
_.b=a
_.c=null
_.$ti=b},
hY:function hY(a){this.$ti=a},
l3:function l3(){},
kU:function kU(){},
kV:function kV(a,b){this.a=a
this.b=b},
l8:function l8(a,b){this.a=a
this.b=b},
nR(a,b){var s=a[b]
return s===a?null:s},
mb(a,b,c){if(c==null)a[b]=a
else a[b]=c},
ma(){var s=Object.create(null)
A.mb(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
pO(a,b){return new A.aY(a.m("@<0>").aC(b).m("aY<1,2>"))},
c6(a,b,c){return A.oq(a,new A.aY(b.m("@<0>").aC(c).m("aY<1,2>")))},
O(a,b){return new A.aY(a.m("@<0>").aC(b).m("aY<1,2>"))},
nq(a){return new A.eQ(a.m("eQ<0>"))},
mc(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
h1(a,b,c){var s=A.pO(b,c)
a.bg(0,new A.jf(s,b,c))
return s},
lM(a){var s,r
if(A.my(a))return"{...}"
s=new A.ex("")
try{r={}
$.ct.push(a)
s.a+="{"
r.a=!0
a.bg(0,new A.jh(r,s))
s.a+="}"}finally{$.ct.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
pP(a){return 8},
pQ(a){var s
a=(a<<1>>>0)-1
for(;;a=s){s=(a&a-1)>>>0
if(s===0)return a}},
eN:function eN(){},
dn:function dn(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
eO:function eO(a,b){this.a=a
this.$ti=b},
hQ:function hQ(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
eQ:function eQ(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
kR:function kR(a){this.a=a
this.b=null},
hT:function hT(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
jf:function jf(a,b,c){this.a=a
this.b=b
this.c=c},
E:function E(){},
bA:function bA(){},
jh:function jh(a,b){this.a=a
this.b=b},
ea:function ea(a,b){var _=this
_.a=a
_.d=_.c=_.b=0
_.$ti=b},
hU:function hU(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.$ti=e},
bD:function bD(){},
eV:function eV(){},
ry(a,b,c){var s,r,q,p=c-b
if(p<=4096)s=$.oZ()
else s=new Uint8Array(p)
for(r=0;r<p;++r){q=a[b+r]
if((q&255)!==q)q=255
s[r]=q}return s},
rx(a,b,c,d){var s=a?$.oY():$.oX()
if(s==null)return null
if(0===c&&d===b.length)return A.o_(s,b)
return A.o_(s,b.subarray(c,d))},
o_(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
rz(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
l1:function l1(){},
l0:function l0(){},
kY:function kY(){},
ff:function ff(){},
fj:function fj(){},
il:function il(){},
jb:function jb(){},
jc:function jc(a){this.a=a},
k7:function k7(){},
hz:function hz(a){this.a=a},
i1:function i1(a){this.a=a
this.b=16
this.c=0},
tW(a){var s=A.qc(a,null)
if(s!=null)return s
throw A.e(A.lD(a,null,null))},
pl(a,b){a=A.Z(a,new Error())
a.stack=b.B(0)
throw a},
a0(a,b,c,d){var s,r=J.lH(a,d)
if(a!==0&&b!=null)for(s=0;s<a;++s)r[s]=b
return r},
nr(a,b){var s,r,q=A.m([],b.m("o<0>"))
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a5)(a),++r)q.push(a[r])
return q},
p(a,b){var s,r
if(Array.isArray(a))return A.m(a.slice(0),b.m("o<0>"))
s=A.m([],b.m("o<0>"))
for(r=J.f6(a);r.E();)s.push(r.gJ())
return s},
ns(a,b,c){var s,r=J.lI(a,c)
for(s=0;s<a;++s)r[s]=b.$1(s)
return r},
ey(a,b,c){var s,r,q,p,o
A.aM(b,"start")
s=c==null
r=!s
if(r){q=c-b
if(q<0)throw A.e(A.ad(c,b,null,"end",null))
if(q===0)return""}if(Array.isArray(a)){p=a
o=p.length
if(s)c=o
return A.nz(b>0||c<o?p.slice(b,c):p)}if(t.bm.b(a))return A.qj(a,b,c)
if(r)a=J.pa(a,c)
if(b>0)a=J.lw(a,b)
s=A.p(a,t.p)
return A.nz(s)},
qj(a,b,c){var s=a.length
if(b>=s)return""
return A.qf(a,b,c==null||c>s?s:c)},
nG(a,b,c){var s=J.f6(b)
if(!s.E())return a
if(c.length===0){do a+=A.x(s.gJ())
while(s.E())}else{a+=A.x(s.gJ())
while(s.E())a=a+c+A.x(s.gJ())}return a},
qi(){return A.b4(new Error())},
pk(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
n0(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
fl(a){if(a>=10)return""+a
return"0"+a},
im(a){if(typeof a=="number"||A.i3(a)||a==null)return J.dC(a)
if(typeof a=="string")return JSON.stringify(a)
return A.qd(a)},
pm(a,b){A.f3(a,"error",t.K)
A.f3(b,"stackTrace",t.gm)
A.pl(a,b)},
fa(a){return new A.f9(a)},
aU(a,b){return new A.aT(!1,null,b,a)},
mR(a,b,c){return new A.aT(!0,a,b,c)},
i8(a,b){return a},
ad(a,b,c,d,e){return new A.bj(b,c,!0,a,d,"Invalid value")},
cl(a,b,c){if(0>a||a>c)throw A.e(A.ad(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.e(A.ad(b,a,c,"end",null))
return b}return c},
aM(a,b){if(a<0)throw A.e(A.ad(a,0,null,b,null))
return a},
iQ(a,b,c,d,e){return new A.fE(b,!0,a,e,"Index out of range")},
b8(a){return new A.eC(a)},
eA(a){return new A.hw(a)},
jO(a){return new A.bE(a)},
aJ(a){return new A.fi(a)},
lD(a,b,c){return new A.ba(a,b,c)},
pJ(a,b,c){var s,r
if(A.my(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.m([],t.s)
$.ct.push(a)
try{A.tb(a,s)}finally{$.ct.pop()}r=A.nG(b,s,", ")+c
return r.charCodeAt(0)==0?r:r},
j4(a,b,c){var s,r
if(A.my(a))return b+"..."+c
s=new A.ex(b)
$.ct.push(a)
try{r=s
r.a=A.nG(r.a,a,", ")}finally{$.ct.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
tb(a,b){var s,r,q,p,o,n,m,l=a.gF(a),k=0,j=0
for(;;){if(!(k<80||j<3))break
if(!l.E())return
s=A.x(l.gJ())
b.push(s)
k+=s.length+2;++j}if(!l.E()){if(j<=5)return
r=b.pop()
q=b.pop()}else{p=l.gJ();++j
if(!l.E()){if(j<=4){b.push(A.x(p))
return}r=A.x(p)
q=b.pop()
k+=r.length+2}else{o=l.gJ();++j
for(;l.E();p=o,o=n){n=l.gJ();++j
if(j>100){for(;;){if(!(k>75&&j>3))break
k-=b.pop().length+2;--j}b.push("...")
return}}q=A.x(p)
r=A.x(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
for(;;){if(!(k>80&&b.length>3))break
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)b.push(m)
b.push(q)
b.push(r)},
lN(a,b,c,d){var s
if(B.B===c){s=J.av(a)
b=J.av(b)
return A.jT(A.bl(A.bl($.i7(),s),b))}if(B.B===d){s=J.av(a)
b=J.av(b)
c=J.av(c)
return A.jT(A.bl(A.bl(A.bl($.i7(),s),b),c))}s=J.av(a)
b=J.av(b)
c=J.av(c)
d=J.av(d)
d=A.jT(A.bl(A.bl(A.bl(A.bl($.i7(),s),b),c),d))
return d},
k(a){var s,r=$.i7()
for(s=J.f6(a);s.E();)r=A.bl(r,J.av(s.gJ()))
return A.jT(r)},
fk:function fk(a,b,c){this.a=a
this.b=b
this.c=c},
kB:function kB(){},
S:function S(){},
f9:function f9(a){this.a=a},
bm:function bm(){},
aT:function aT(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
bj:function bj(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
fE:function fE(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
eC:function eC(a){this.a=a},
hw:function hw(a){this.a=a},
bE:function bE(a){this.a=a},
fi:function fi(a){this.a=a},
h4:function h4(){},
ew:function ew(){},
kC:function kC(a){this.a=a},
ba:function ba(a,b,c){this.a=a
this.b=b
this.c=c},
d:function d(){},
az:function az(a,b,c){this.a=a
this.b=b
this.$ti=c},
ac:function ac(){},
n:function n(){},
eX:function eX(a){this.a=a},
ex:function ex(a){this.a=a},
fo:function fo(a,b){this.a=a
this.$ti=b},
ji:function ji(a){this.a=a},
o6(a){var s
if(typeof a=="function")throw A.e(A.aU("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.rN,a)
s[$.mC()]=a
return s},
rN(a,b,c){if(c>=1)return a.$1(b)
return a.$0()},
oc(a){return a==null||A.i3(a)||typeof a=="number"||typeof a=="string"||t.cu.b(a)||t.D.b(a)||t.go.b(a)||t.W.b(a)||t.h7.b(a)||t.an.b(a)||t.w.b(a)||t.h4.b(a)||t.gN.b(a)||t.dI.b(a)||t.fd.b(a)},
mz(a){if(A.oc(a))return a
return new A.lp(new A.dn(t.x)).$1(a)},
u2(a,b){var s=new A.R($.H,b.m("R<0>")),r=new A.cq(s,b.m("cq<0>"))
a.then(A.f4(new A.lr(r),1),A.f4(new A.ls(r),1))
return s},
ob(a){return a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string"||a instanceof Int8Array||a instanceof Uint8Array||a instanceof Uint8ClampedArray||a instanceof Int16Array||a instanceof Uint16Array||a instanceof Int32Array||a instanceof Uint32Array||a instanceof Float32Array||a instanceof Float64Array||a instanceof ArrayBuffer||a instanceof DataView},
mu(a){if(A.ob(a))return a
return new A.ld(new A.dn(t.x)).$1(a)},
lp:function lp(a){this.a=a},
lr:function lr(a){this.a=a},
ls:function ls(a){this.a=a},
ld:function ld(a){this.a=a},
lF(a,b){var s=new A.iC()
s.hi(a,b)
return s},
iC:function iC(){this.a=$
this.b=0
this.c=2147483647},
e0:function e0(a,b){this.a=a
this.b=b},
fF:function fF(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.r=_.f=_.e=0
_.w=d
_.x=null
_.y=0},
dr:function dr(a,b){this.a=a
this.b=b},
iR:function iR(a,b){var _=this
_.a=a
_.b=null
_.c=b
_.f=!1
_.w=_.r=0},
aH(a){return new A.f7(a,null,null)},
f7:function f7(a,b,c){this.a=a
this.b=b
this.c=c},
fe:function fe(a,b){this.a=a
this.b=b},
nh(a){return new A.fG(new A.ky(a,0,new Uint8Array(65536)),0,null,B.a1)},
ni(a,b,c){return new A.fG(a.b,a.c+b,c,a.a)},
fG:function fG(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=c
_.e=0
_.a=d},
ky:function ky(a,b,c){var _=this
_.b=a
_.c=b
_.d=c
_.r=_.f=_.e=0
_.w=!1},
iT(a,b,c,d){var s,r,q,p,o=new A.fH(b)
if(d==null)d=0
A.aM(d,"offset")
if(d<0)d=0
else{s=a.length
if(d>s)d=s}r=a.length-d
if(c==null)c=r
if(c<0||c>r)c=r
q=t.D.b(a)?a:new Uint8Array(A.t(a))
p=J.aj(B.c.gA(q),q.byteOffset+d,c)
o.b=p
o.d=p.length
return o},
fH:function fH(a){var _=this
_.b=null
_.c=0
_.d=$
_.a=a},
iU:function iU(){},
lO:function lO(a){this.b=0
this.c=a},
jm:function jm(){},
ie:function ie(a,b){this.a=a
this.b=b},
P:function P(a){this.a=-1
this.b=a},
cy:function cy(a){this.a=a},
cz:function cz(a){this.a=a},
cA:function cA(a){this.a=a},
cB:function cB(a){this.a=a},
cC:function cC(a){this.a=a},
cD:function cD(a){this.a=a},
cE:function cE(a,b){this.a=a
this.b=b},
cF:function cF(a){this.a=a},
cG:function cG(a,b){this.a=a
this.b=b},
cH:function cH(a){this.a=a},
cI:function cI(a,b){this.a=a
this.b=b},
mZ(a,b,c,d){var s=new A.bO(new Uint8Array(4))
s.hd(a,b,c,d)
return s},
aW:function aW(a){this.a=a},
fg:function fg(a){this.a=a},
bO:function bO(a){this.a=a},
dy(a,b,c){var s
if(b===c)return a
switch(b.a){case 0:if(a===0)s=0
else{s=B.bj.n(0,c)
s.toString}return s
case 1:switch(c.a){case 0:return a===0?0:1
case 1:return a
case 2:return a*5
case 3:return a*75
case 4:return a*21845
case 5:return a*1431655765
case 6:return a*42
case 7:return a*10922
case 8:return a*715827882
case 9:case 10:case 11:return a/3}break
case 2:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.z(a),1)
case 2:return a
case 3:return a*17
case 4:return a*4369
case 5:return a*286331153
case 6:return a*8
case 7:return a*2184
case 8:return a*143165576
case 9:case 10:case 11:return a/3}break
case 3:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.z(a),6)
case 2:return B.a.j(A.z(a),4)
case 3:return a
case 4:return a*257
case 5:return a*16843009
case 6:return B.a.j(A.z(a),1)
case 7:return a*128
case 8:return a*8421504
case 9:case 10:case 11:return a/255}break
case 4:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.z(a),14)
case 2:return B.a.j(A.z(a),12)
case 3:return B.a.j(A.z(a),8)
case 4:return a
case 5:return A.z(a)<<8>>>0
case 6:return B.a.j(A.z(a),9)
case 7:return B.a.j(A.z(a),1)
case 8:return a*524296
case 9:case 10:case 11:return a/65535}break
case 5:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.z(a),30)
case 2:return B.a.j(A.z(a),28)
case 3:return B.a.j(A.z(a),24)
case 4:return B.a.j(A.z(a),16)
case 5:return a
case 6:return B.a.j(A.z(a),25)
case 7:return B.a.j(A.z(a),17)
case 8:return B.a.j(A.z(a),1)
case 9:case 10:case 11:return a/4294967295}break
case 6:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.z(a),5)
case 2:return a<=0?0:B.a.j(A.z(a),3)
case 3:return a<=0?0:A.z(a)<<1>>>0
case 4:return a<=0?0:A.z(a)*516
case 5:return a<=0?0:A.z(a)*33818640
case 6:return a
case 7:return a*258
case 8:return a*16909320
case 9:case 10:case 11:return a/127}break
case 7:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.z(a),15)
case 2:return a<=0?0:B.a.j(A.z(a),11)
case 3:return a<=0?0:B.a.j(A.z(a),7)
case 4:return a<=0?0:A.z(a)<<1>>>0
case 5:return a<=0?0:A.z(a)*131076
case 6:return B.a.j(A.z(a),8)
case 7:return a
case 8:return A.z(a)*65538
case 9:case 10:case 11:return a/32767}break
case 8:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.z(a),29)
case 2:return a<=0?0:B.a.j(A.z(a),27)
case 3:return a<=0?0:B.a.j(A.z(a),23)
case 4:return a<=0?0:B.a.j(A.z(a),16)
case 5:return a<=0?0:A.z(a)<<1>>>0
case 6:return B.a.j(A.z(a),24)
case 7:return B.a.j(A.z(a),16)
case 8:return a
case 9:case 10:case 11:return a/2147483647}break
case 9:case 10:case 11:switch(c.a){case 0:return a===0?0:1
case 1:return B.b.h(B.b.I(a,0,1)*3)
case 2:return B.b.h(B.b.I(a,0,1)*15)
case 3:return B.b.h(B.b.I(a,0,1)*255)
case 4:return B.b.h(B.b.I(a,0,1)*65535)
case 5:return B.b.h(B.b.I(a,0,1)*4294967295)
case 6:return B.b.h(a<0?B.b.I(a,-1,1)*128:B.b.I(a,-1,1)*127)
case 7:return B.b.h(a<0?B.b.I(a,-1,1)*32768:B.b.I(a,-1,1)*32767)
case 8:return B.b.h(a<0?B.b.I(a,-1,1)*2147483648:B.b.I(a,-1,1)*2147483647)
case 9:case 10:case 11:return a}break}},
ae:function ae(a,b){this.a=a
this.b=b},
fb:function fb(a,b){this.a=a
this.b=b},
dK(a){var s,r=new A.bR(A.O(t.N,t.P))
r.hj(a)
s=a.b
if(s!=null)r.b=new Uint8Array(A.t(s))
return r},
lA(a){var s=new A.bR(A.O(t.N,t.P))
s.bu(a)
return s},
bR:function bR(a){this.b=null
this.c=0
this.a=a},
hO:function hO(a,b){this.a=a
this.b=b},
f(a,b,c){return new A.fn(a,b)},
fn:function fn(a,b){this.a=a
this.b=b},
bv:function bv(a){this.a=a},
iJ:function iJ(a){this.a=a},
n7(a){var s=new A.b5(A.O(t.p,t.r),new A.bv(A.O(t.N,t.P)))
s.ko(a)
return s},
b5:function b5(a,b){this.a=a
this.b=b},
iK:function iK(a){this.a=a},
iL:function iL(a){this.a=a},
ne(a,b){var s=new A.c1(new Uint16Array(b))
s.ho(a,b)
return s},
pB(a){var s=new Uint32Array(1)
s[0]=a
return new A.bw(s)},
n9(a,b){var s=new A.bw(new Uint32Array(b))
s.hl(a,b)
return s},
na(a,b){var s,r=J.e5(b,t.i)
for(s=0;s<b;++s)r[s]=new A.df(a.i(),a.i())
return new A.bY(r)},
nd(a,b){var s=new A.c0(new Int16Array(b))
s.hn(a,b)
return s},
nb(a,b){var s=new A.bZ(new Int32Array(b))
s.hm(a,b)
return s},
nc(a,b){var s,r,q,p,o=J.e5(b,t.i)
for(s=0;s<b;++s){r=a.i()
q=$.N()
q.$flags&2&&A.a(q)
q[0]=r
r=$.a_()
p=r[0]
q[0]=a.i()
o[s]=new A.df(p,r[0])}return new A.c_(o)},
nf(a,b){var s=new A.cQ(new Float32Array(b))
s.hp(a,b)
return s},
n8(a,b){var s=new A.cO(new Float64Array(b))
s.hk(a,b)
return s},
a8:function a8(a,b){this.a=a
this.b=b},
Y:function Y(){},
bc:function bc(a){this.a=a},
bX:function bX(a){this.a=a},
c1:function c1(a){this.a=a},
bw:function bw(a){this.a=a},
bY:function bY(a){this.a=a},
bx:function bx(a){this.a=a},
c0:function c0(a){this.a=a},
bZ:function bZ(a){this.a=a},
c_:function c_(a){this.a=a},
cQ:function cQ(a){this.a=a},
cO:function cO(a){this.a=a},
cR:function cR(a){this.a=a},
cP:function cP(a){this.a=a},
ag(a,b,c,d){var s
if(d)s=a<0||b<0
else s=a<1||b<1
if(s)throw A.e(A.i("Invalid image dimensions "+a+"x"+b))
if(c>0&&a*b>c)throw A.e(A.i("Image dimensions "+a+"x"+b+" exceed the maximum of "+c+" pixels"))},
bh:function bh(a){this.a=a
this.c=0},
mS(a){var s,r,q=new A.id()
if(!A.mT(a))A.X(A.i("Not a bitmap file."))
a.d+=2
s=a.i()
r=$.N()
r.$flags&2&&A.a(r)
r[0]=s
s=$.a_()
a.d+=4
r[0]=a.i()
q.b=s[0]
return q},
mT(a){if(a.c-a.d<2)return!1
return A.r(a,null,0).k()===19778},
pc(a,b){var s,r,q,p,o=b==null?A.mS(a):b,n=a.d,m=a.i(),l=a.i(),k=$.N()
k.$flags&2&&A.a(k)
k[0]=l
l=$.a_()
s=l[0]
k[0]=a.i()
l=l[0]
r=a.k()
q=a.k()
p=a.i()
if(p>=14)A.X(A.i("Unsupported BMP compression type: "+p))
p=B.bc[p]
a.i()
k[0]=a.i()
k[0]=a.i()
k=a.i()
a.i()
n=new A.b9(o,s,l,m,r,q,p,k,n)
n.ek(a,b)
return n},
a7:function a7(a,b){this.a=a
this.b=b},
id:function id(){this.b=$},
b9:function b9(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.z=h
_.ay=_.ax=_.at=_.as=$
_.ch=null
_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.CW=$
_.fy=i},
pb(a,b){return new A.fc(a,b==null?268435456:b)},
fc:function fc(a,b){var _=this
_.a=$
_.b=null
_.c=a
_.d=b},
ic:function ic(a,b){this.a=a
this.b=b},
ia:function ia(a,b){this.a=a
this.b=b},
i9:function i9(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
ib:function ib(a,b,c){this.a=a
this.b=b
this.c=c},
ik:function ik(a,b){var _=this
_.a=$
_.b=null
_.c=a
_.d=b},
dI:function dI(){},
ij:function ij(){},
fp:function fp(){},
fJ:function fJ(a,b,c,d){var _=this
_.r=a
_.w=b
_.x=c
_.b=_.a=0
_.c=d},
bT:function bT(a,b){this.a=a
this.b=b},
bS:function bS(a,b){this.a=a
this.b=b},
fq:function fq(){var _=this
_.w=_.r=_.f=_.d=_.c=_.b=_.a=$},
n1(a,b,c,d){var s,r
switch(a.a){case 1:return new A.j0(c,b)
case 2:return new A.fL(c,d==null?1:d,b)
case 3:return new A.fL(c,d==null?16:d,b)
case 4:s=d==null?32:d
r=new A.iZ(c,s,b)
r.ht(b,c,s)
return r
case 5:return new A.j_(c,d==null?16:d,b)
case 6:return new A.fJ(c,d==null?32:d,!1,b)
case 7:return new A.fJ(c,d==null?32:d,!0,b)
default:throw A.e(A.i("Invalid compression type: "+a.B(0)))}},
aX:function aX(a,b){this.a=a
this.b=b},
io:function io(){},
iY:function iY(){},
pq(a,b,c,d){var s,r,q,p,o,n,m,l
if(b===0){if(d!==0)throw A.e(A.i("Incomplete huffman data"))
return}s=a.d
r=a.i()
q=a.i()
a.d+=4
p=a.i()
o=!0
if(r<65537)o=q>=65537
if(o)throw A.e(A.i("Invalid huffman table size"))
a.d+=4
n=A.a0(65537,0,!1,t.p)
m=J.ak(16384,t.gV)
for(l=0;l<16384;++l)m[l]=new A.fr()
A.pr(a,b-20,r,q,n)
if(p>8*(b-(a.d-s)))throw A.e(A.i("Error in header for Huffman-encoded data (invalid number of bits)."))
A.pn(n,r,q,m)
A.pp(n,m,a,p,q,d,c)},
pp(a,b,c,d,e,f,g){var s,r,q,p,o,n,m,l,k="Error in Huffman-encoded data (invalid code).",j=A.m([0,0],t.t),i=c.d+B.a.V(d+7,8)
for(s=0;c.d<i;){A.lB(j,c)
while(r=j[1],r>=14){q=b[B.a.bn(j[0],r-14)&16383]
p=q.a
if(p!==0){j[1]=r-p
s=A.lC(q.b,e,j,c,g,s,f)}else{if(q.c==null)throw A.e(A.i(k))
for(o=0;o<q.b;++o){n=a[q.c[o]]&63
for(;;){r=j[1]
if(!(r<n&&c.d<i))break
A.lB(j,c)}if(r>=n){p=q.c
r-=n
if(a[p[o]]>>>6===(B.a.bn(j[0],r)&B.a.M(1,n)-1)>>>0){j[1]=r
m=A.lC(p[o],e,j,c,g,s,f)
s=m
break}}}if(o===q.b)throw A.e(A.i(k))}}}l=8-d&7
j[0]=B.a.j(j[0],l)
j[1]=j[1]-l
while(r=j[1],r>0){q=b[B.a.Y(j[0],14-r)&16383]
p=q.a
if(p!==0){j[1]=r-p
s=A.lC(q.b,e,j,c,g,s,f)}else throw A.e(A.i(k))}if(s!==f)throw A.e(A.i("Error in Huffman-encoded data (decoded data are shorter than expected)."))},
lC(a,b,c,d,e,f,g){var s,r,q,p,o,n="Error in Huffman-encoded data (decoded data are longer than expected)."
if(a===b){if(c[1]<8)A.lB(c,d)
s=c[1]-8
c[1]=s
r=B.a.bn(c[0],s)&255
if(f+r>g)throw A.e(A.i(n))
q=e[f-1]
for(s=e.$flags|0;p=r-1,r>0;r=p,f=o){o=f+1
s&2&&A.a(e)
e[f]=q}}else{if(f<g){e.toString
o=f+1
e.$flags&2&&A.a(e)
e[f]=a}else throw A.e(A.i(n))
f=o}return f},
pn(a,b,c,d){var s,r,q,p,o,n,m,l="Error in Huffman-encoded data (invalid code table entry)."
for(s=t.t;b<=c;++b){r=a[b]
q=r>>>6
p=r&63
if(B.a.a0(q,p)!==0)throw A.e(A.i(l))
if(p>14){o=d[B.a.U(q,p-14)]
if(o.a!==0)throw A.e(A.i(l));++o.b
r=o.c;(r==null?o.c=A.m([],s):r).push(b)}else if(p!==0){r=14-p
n=B.a.Y(q,r)
for(m=B.a.Y(1,r);m>0;--m,++n){o=d[n]
if(o.a!==0||o.c!=null)throw A.e(A.i(l))
o.a=p
o.b=b}}}},
pr(a,b,c,d,e){var s,r,q,p,o,n="Error in Huffman-encoded data (unexpected end of code table data).",m="Error in Huffman-encoded data (code table is longer than expected).",l=a.d,k=A.m([0,0],t.t)
for(s=d+1;c<=d;++c){if(a.d-l>b)throw A.e(A.i(n))
r=A.n2(6,k,a)
e[c]=r
if(r===63){if(a.d-l>b)throw A.e(A.i(n))
q=A.n2(8,k,a)+6
if(c+q>s)throw A.e(A.i(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
e[c]=0}--c}else if(r>=59){q=r-59+2
if(c+q>s)throw A.e(A.i(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
e[c]=0}--c}}A.po(e)},
po(a){var s,r,q,p,o,n=A.a0(59,0,!1,t.p)
for(s=0;s<65537;++s){r=a[s]
n[r]=n[r]+1}for(q=0,s=58;s>0;--s,q=p){p=q+n[s]>>>1
n[s]=q}for(s=0;s<65537;++s){o=a[s]
if(o>0){r=n[o]
n[o]=r+1
a[s]=(o|r<<6)>>>0}}},
lB(a,b){a[0]=(a[0]<<8|b.D())>>>0
a[1]=a[1]+8>>>0},
n2(a,b,c){var s
while(s=b[1],s<a){b[0]=(b[0]<<8|J.c(c.a,c.d++))>>>0
b[1]=b[1]+8>>>0}s-=a
b[1]=s
return(B.a.bn(b[0],s)&B.a.M(1,a)-1)>>>0},
fr:function fr(){this.b=this.a=0
this.c=null},
ps(a){var s
if(a.length<8)return!1
s=A.q(a,!1,null,0)
if(s.i()!==20000630)return!1
if(s.D()!==2)return!1
if((s.b6()&4294967289)>>>0!==0)return!1
return!0},
it:function it(a){var _=this
_.b=_.a=0
_.c=a
_.d=null
_.e=$},
nj(a,b,c,d){var s=new A.fK(a,A.m([],t.g9),A.O(t.N,t.aX),B.aG,b)
s.hg(a,b,c,d)
return s},
dL:function dL(){},
iu:function iu(a,b){this.a=a
this.b=b},
fK:function fK(a,b,c,d,e){var _=this
_.a=a
_.b=null
_.c=b
_.d=0
_.e=c
_.r=$
_.x=_.w=0
_.at=$
_.ax=d
_.ay=null
_.ch=$
_.CW=null
_.cx=0
_.cy=null
_.db=e
_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=null
_.k2=$
_.k3=null},
iZ:function iZ(a,b,c){var _=this
_.r=null
_.w=a
_.x=b
_.y=$
_.z=null
_.b=_.a=0
_.c=c},
hW:function hW(){var _=this
_.f=_.e=_.d=_.c=_.b=_.a=$},
j_:function j_(a,b,c){var _=this
_.r=a
_.w=b
_.x=null
_.b=_.a=0
_.c=c},
j0:function j0(a,b){var _=this
_.r=null
_.w=a
_.b=_.a=0
_.c=b},
fL:function fL(a,b,c){var _=this
_.w=a
_.x=b
_.y=null
_.b=_.a=0
_.c=c},
ip:function ip(a){this.a=null
this.b=a},
is:function is(a,b){this.a=a
this.b=b},
iq:function iq(a,b){this.a=a
this.b=b},
ir:function ir(a,b,c){this.a=a
this.b=b
this.c=c},
n4(a){var s=new Uint8Array(a*3)
return new A.dQ(A.pz(a),a,null,new A.b6(s,a,3))},
py(a){return new A.dQ(a.a,a.b,a.c,A.nv(a.d))},
pz(a){var s
for(s=1;s<=8;++s)if(B.a.M(1,s)>=a)return s
return 0},
dQ:function dQ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dR:function dR(){},
fM:function fM(){var _=this
_.e=_.d=_.c=_.b=_.a=$
_.f=null
_.r=80
_.w=0
_.x=-1
_.y=$},
cL:function cL(a){var _=this
_.b=_.a=0
_.e=_.c=null
_.r=a},
iy:function iy(a){var _=this
_.a=null
_.b=a
_.f=_.e=_.d=_.c=0
_.r=null
_.w=0
_.x=null
_.z=_.y=$
_.Q=null
_.as=0
_.at=null
_.ch=_.ay=_.ax=0
_.CW=null
_.fr=_.dy=_.dx=_.db=_.cy=_.cx=0},
iB:function iB(a,b){this.a=a
this.b=b},
iz:function iz(a,b){this.a=a
this.b=b},
iA:function iA(a,b,c){this.a=a
this.b=b
this.c=c},
n6(a){var s,r,q,p
if(a.k()!==0)return null
s=a.k()
if(s>=3)return null
if(B.cu[s]===B.aI)return null
r=a.k()
q=J.e5(r,t.gx)
for(p=0;p<r;++p){J.c(a.a,a.d++)
J.c(a.a,a.d++)
J.c(a.a,a.d++);++a.d
a.k()
a.k()
q[p]=new A.fx(a.i(),a.i())}return new A.iI(r,q)},
cN:function cN(a,b){this.a=a
this.b=b},
iI:function iI(a,b){this.d=a
this.e=b},
fx:function fx(a,b){this.d=a
this.e=b},
iD:function iD(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.z=h
_.ay=_.ax=_.at=_.as=$
_.ch=null
_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.CW=$
_.fy=i},
iE:function iE(a){this.b=this.a=null
this.c=a},
iH:function iH(a,b){this.a=a
this.b=b},
iG:function iG(a,b,c){this.a=a
this.b=b
this.c=c},
iF:function iF(a,b){this.a=a
this.b=b},
n_(a,b,c,d,e){var s,r
if(a===b)s=0
else s=a===1&&b===4?2:1
if(c===d)r=0
else r=c===1&&d===4?2:1
return new A.fh(e,s,r)},
fh:function fh(a,b,c){this.e=a
this.f=b
this.r=c},
ov(a){var s,r=$.p2()
r=r.a
s=r.get(a)
if(s==null){s=A.rL(a)
r.set(a,s)
r=s}else r=s
return r},
rL(a){var s,r,q,p,o=new Uint16Array(512)
for(s=0;s<512;++s)for(r=a,q=1;q<=9;++q){p=r[B.a.U(s,9-q)&1]
if(p instanceof A.cM){o[s]=(q<<8|p.a)>>>0
break}if(!(p instanceof A.bW))break
r=p.a}return o},
bV:function bV(){},
bW:function bW(a){this.a=a},
cM:function cM(a){this.a=a},
no(a){var s,r=a.f.e
r.toString
s=a.b
s=new A.j9(a,B.a.a5(r+s-1,s),a.gd8())
s.hu(a)
return s},
ot(a){var s,r=A.no(a)
r.h0(0,a.gd8())
s=r.d
s===$&&A.b()
return s},
j9:function j9(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.w=_.r=_.f=_.e=_.d=$},
j6:function j6(){this.d=null},
c3:function c3(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.x=_.w=_.r=_.f=_.e=$
_.y=!1
_.z=0
_.ay=_.ax=_.at=_.as=_.Q=$},
lK(){var s,r,q,p,o=A.a0(4,null,!1,t.bC),n=A.m([],t.f8),m=t.eC,l=J.lI(0,m)
m=J.lI(0,m)
s=A.m([],t.eB)
r=A.m([],t.cJ)
q=new Uint8Array(64)
p=new Int32Array(64)
return new A.fX(new A.bR(A.O(t.N,t.P)),o,n,l,m,s,r,q,p,new Int16Array(0))},
pM(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i,h=B.a.a5(8,b),g=h*h
for(s=g>>>1,r=0;r<b;++r){q=c[d+r]
q.toString
for(p=q.$flags|0,o=r*h,n=0;n<b;++n){for(m=n*h,l=0,k=0;k<h;++k){j=(o+k)*8+m
for(i=0;i<h;++i)l+=a[j+i]}m=B.a.a5(l+s,g)
p&2&&A.a(q)
q[e+n]=m}}},
fX:function fX(a,b,c,d,e,f,g,h,i,j){var _=this
_.a=0
_.b=1
_.d=_.c=$
_.x=_.r=_.f=_.e=null
_.y=a
_.z=b
_.Q=c
_.as=d
_.at=e
_.ax=f
_.ay=!1
_.ch=0
_.cx=_.CW=!1
_.cy=null
_.db=g
_.dx=h
_.dy=i
_.fr=j},
dp:function dp(a){this.a=a
this.b=0},
hX:function hX(){},
fY:function fY(a,b){var _=this
_.e=_.d=_.c=_.b=null
_.r=_.f=0
_.x=_.w=$
_.y=a
_.z=b},
ja:function ja(){this.r=this.f=$},
fZ:function fZ(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.f=$
_.r=null
_.y=c
_.z=d
_.Q=e
_.as=f
_.at=g
_.ax=h
_.ay=null
_.cx=_.CW=_.ch=0
_.cy=!1
_.dx=_.db=0
_.dy=$
_.fr=i},
nn(){return new A.j7(268435456)},
j7:function j7(a){this.a=a},
j8:function j8(a,b,c){this.a=a
this.b=b
this.c=c},
d7:function d7(a,b){this.a=a
this.b=b},
eq:function eq(a,b){this.a=a
this.b=b},
er:function er(){},
fN:function fN(a,b,c,d,e,f,g,h,i){var _=this
_.y=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i},
bB:function bB(a,b){this.a=a
this.b=b},
ju:function ju(){},
j1:function j1(a,b,c){var _=this
_.c=_.b=_.a=0
_.d=-1
_.r=_.f=0
_.z=_.x=_.w=null
_.Q=""
_.at=null
_.ax=a
_.CW=1
_.cy=b
_.db=c},
nw(a){var s=t.N,r=A.m([],t.dm),q=A.m([],t.t),p=a==null?268435456:a
return new A.jq(new A.j1(A.O(s,s),r,q),p)},
jq:function jq(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=0
_.e=$
_.f=0},
jt:function jt(a,b){this.a=a
this.b=b},
jr:function jr(a,b){this.a=a
this.b=b},
js:function js(a,b,c){this.a=a
this.b=b
this.c=c},
hZ:function hZ(){},
bC:function bC(a,b){this.a=a
this.b=b},
ck:function ck(a){this.b=this.a=0
this.e=a},
jv:function jv(a,b){var _=this
_.b=_.a=null
_.c=a
_.d=b},
jy:function jy(a,b,c){this.a=a
this.b=b
this.c=c},
jz:function jz(a,b){this.a=a
this.b=b},
jx:function jx(a,b){this.a=a
this.b=b},
jw:function jw(){},
hf:function hf(){this.a=null},
hg:function hg(){this.a=null},
b7:function b7(){},
hi:function hi(){this.a=null},
hj:function hj(){this.a=null},
hm:function hm(){this.a=null},
hn:function hn(){this.a=null},
es:function es(a){this.b=a},
hl:function hl(){},
jA:function jA(){var _=this
_.w=_.r=_.f=_.e=$},
db:function db(a){this.a=a
this.c=null},
nB(a,b){var s=A.m([],t.l),r=b==null?268435456:b
r=new A.jF(s,A.O(t.p,t.fh),a.length,r)
r.hw(a,b)
return r},
m_(a,b,c,d){var s=a/255,r=b/255,q=c/255,p=d/255,o=r*(1-q),n=s*(1-p)
return B.b.h(B.b.I((2*s<q?2*r*s+o+n:p*q-2*(q-s)*(p-r)+o+n)*255,0,255))},
jG(a,b){if(b===0)return 0
return B.a.h(B.a.I(B.b.h(255*(1-(1-a/255)/(b/255))),0,255))},
jI(a,b){return B.a.h(B.a.I(a+b-255,0,255))},
m1(a,b){return B.a.h(B.a.I(255-(255-b)*(255-a),0,255))},
jH(a,b){if(b===255)return 255
return B.b.h(B.b.I(a/255/(1-b/255)*255,0,255))},
m2(a,b){var s=a/255,r=b/255,q=1-r
return B.b.b7(255*(q*r*s+r*(1-q*(1-s))))},
lY(a,b){var s=b/255,r=a/255
if(r<0.5)return B.b.b7(510*s*r)
else return B.b.b7(255*(1-2*(1-s)*(1-r)))},
m3(a,b){if(b<128)return A.jG(a,2*b)
else return A.jH(a,2*(b-128))},
lZ(a,b){var s
if(b<128)return A.jI(a,2*b)
else{s=2*(b-128)
return s+a>255?255:a+s}},
m0(a,b){return b<128?Math.min(a,2*b):Math.max(a,2*(b-128))},
lX(a,b){return B.b.b7(b+a-2*b*a/255)},
aA(a,b,c){var s
if(a==null)s=0
else s=c===1?a[b]:(a[b]<<8|a[b+1])>>>8
return s},
nC(b7,b8,b9,c0,c1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=null,b6=A.O(t.p,t.fW)
for(s=c1.length,r=0;q=c1.length,r<q;c1.length===s||(0,A.a5)(c1),++r){p=c1[r]
b6.l(0,p.a,p)}if(b8===8)o=1
else o=b8===16?2:-1
n=A.Q(b5,b5,B.e,0,B.i,c0,b5,0,q,b5,B.e,b9,!1)
if(o===-1)throw A.e(A.i("PSD: unsupported bit depth: "+A.x(b8)))
m=b6.n(0,0)
l=b6.n(0,1)
k=b6.n(0,2)
j=b6.n(0,-1)
i=A.m([0,0,0],t.t)
h=-o
for(s=n.a,s=s.gF(s),g=q>=5,f=q===4,e=q>=2,q=q>=4;s.E();){d=s.gJ()
h+=o
switch(b7){case B.bt:d.sq(A.aA(m.c,h,o))
d.st(A.aA(l.c,h,o))
d.su(A.aA(k.c,h,o))
d.sv(q?A.aA(j.c,h,o):255)
if(d.gv()!==0){d.sq((d.gq()+d.gv()-255)*255/d.gv())
d.st((d.gt()+d.gv()-255)*255/d.gv())
d.su((d.gu()+d.gv()-255)*255/d.gv())}break
case B.bv:c=A.aA(m.c,h,o)
b=A.aA(l.c,h,o)
a=A.aA(k.c,h,o)
a0=q?A.aA(j.c,h,o):255
a1=((c*100>>>8)+16)/116
a2=(b-128)/500+a1
a3=a1-(a-128)/200
a4=Math.pow(a1,3)
a1=a4>0.008856?a4:(a1-0.13793103448275862)/7.787
a5=Math.pow(a2,3)
a2=a5>0.008856?a5:(a2-0.13793103448275862)/7.787
a6=Math.pow(a3,3)
a3=a6>0.008856?a6:(a3-0.13793103448275862)/7.787
a2=a2*95.047/100
a1=a1*100/100
a3=a3*108.883/100
a7=a2*3.240454836+a1*-1.53713885+a3*-0.498531547
a8=a2*-0.96926639+a1*1.87601093+a3*0.041556082
a9=a2*0.05564342+a1*-0.20402585+a3*1.05722516
a7=a7>0.0031308?1.055*Math.pow(a7,0.4166666666666667)-0.055:12.92*a7
a8=a8>0.0031308?1.055*Math.pow(a8,0.4166666666666667)-0.055:12.92*a8
a9=a9>0.0031308?1.055*Math.pow(a9,0.4166666666666667)-0.055:12.92*a9
b0=[B.b.b7(B.b.I(a7*255,0,255)),B.b.b7(B.b.I(a8*255,0,255)),B.b.b7(B.b.I(a9*255,0,255))]
d.sq(b0[0])
d.st(b0[1])
d.su(b0[2])
d.sv(a0)
break
case B.bs:b1=A.aA(m.c,h,o)
a0=e?A.aA(j.c,h,o):255
d.sq(b1)
d.st(b1)
d.su(b1)
d.sv(a0)
break
case B.bu:b2=A.aA(m.c,h,o)
b3=A.aA(l.c,h,o)
a1=A.aA(k.c,h,o)
b4=A.aA(b6.n(0,f?-1:3).c,h,o)
a0=g?A.aA(j.c,h,o):255
A.oo(255-b2,255-b3,255-a1,255-b4,i)
d.sq(i[0])
d.st(i[1])
d.su(i[2])
d.sv(a0)
break
default:throw A.e(A.i("Unhandled color mode: "+A.x(b7)))}}return n},
b_:function b_(a,b){this.a=a
this.b=b},
jF:function jF(a,b,c,d){var _=this
_.b=_.a=0
_.d=_.c=null
_.e=$
_.r=_.f=null
_.w=a
_.x=$
_.y=null
_.z=b
_.as=$
_.at=c
_.ch=_.ay=_.ax=null
_.CW=d},
hh:function hh(){},
hk:function hk(a,b,c){var _=this
_.b=_.a=null
_.f=_.e=_.d=_.c=$
_.r=null
_.as=_.y=_.w=$
_.ay=a
_.ch=b
_.cx=null
_.cy=c},
qg(a,b){var s
switch(a){case"lsct":s=b.c-b.d
b.i()
if(s>=12){if(b.ag(4)!=="8BIM")A.X(A.i("Invalid key in layer additional data"))
b.ag(4)}if(s>=16)b.i()
return new A.hl()
default:return new A.es(b)}},
dc:function dc(){},
jB:function jB(a){this.a=null
this.b=a},
jD:function jD(a,b,c){this.a=a
this.b=b
this.c=c},
jE:function jE(a,b){this.a=a
this.b=b},
jC:function jC(a,b){this.a=a
this.b=b},
hp:function hp(){},
de:function de(a,b,c){this.a=a
this.b=b
this.c=c},
al:function al(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
et:function et(){var _=this
_.Q=_.z=_.y=_.f=_.d=_.b=_.a=0},
dd:function dd(a){var _=this
_.b=0
_.c=a
_.Q=_.r=_.f=0},
ho:function ho(){this.y=this.b=this.a=0},
bi(a,b){return(B.a4[a>>>8]<<17|B.a4[b>>>8]<<16|B.a4[a&255]<<1|B.a4[b&255])>>>0},
aL:function aL(a){var _=this
_.a=a
_.b=0
_.c=!1
_.d=0
_.e=!1
_.f=0
_.r=!1},
jJ:function jJ(a){this.b=this.a=null
this.c=a},
jM:function jM(a,b){this.a=a
this.b=b},
jK:function jK(a,b){this.a=a
this.b=b},
jL:function jL(a,b,c){this.a=a
this.b=b
this.c=c},
hs:function hs(a){var _=this
_.b=_.a=0
_.c=a
_.Q=_.z=_.y=_.x=_.f=_.e=0
_.as=null
_.ax=0},
am:function am(a,b){this.a=a
this.b=b},
jV:function jV(a){this.a=null
this.b=$
this.c=a},
jX:function jX(a,b,c){this.a=a
this.b=b
this.c=c},
jY:function jY(a,b){this.a=a
this.b=b},
jW:function jW(a,b){this.a=a
this.b=b},
jZ:function jZ(a){this.a=a
this.c=this.b=0},
ht:function ht(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.f=e},
m5(a,b,c){var s=new A.k2(b,a),r=t.I
s.e=A.a0(b,null,!1,r)
s.f=A.a0(b,null,!1,r)
return s},
k2:function k2(a,b){var _=this
_.a=a
_.c=b
_.d=0
_.f=_.e=null
_.r=$
_.x=_.w=null
_.y=0
_.z=2
_.as=0
_.at=null},
hu:function hu(a,b,c,d){var _=this
_.a=a
_.c=_.b=0
_.d=b
_.w=_.r=_.f=_.e=1
_.x=c
_.y=d
_.z=!1
_.Q=1
_.at=_.as=$
_.ch=_.ay=0
_.cx=_.CW=null
_.db=_.cy=$
_.dy=1
_.fx=_.fr=0
_.id=null
_.k3=_.k2=_.k1=$},
cm:function cm(a,b){this.a=a
this.b=b},
a1:function a1(a,b){this.a=a
this.b=b},
aN:function aN(a,b){this.a=a
this.b=b},
k3:function k3(a){var _=this
_.b=_.a=0
_.d=null
_.f=a},
nt(){return new A.jg(new Uint8Array(4096))},
jg:function jg(a){var _=this
_.a=9
_.d=_.c=_.b=0
_.w=_.r=_.f=_.e=$
_.x=a
_.z=_.y=$
_.Q=null
_.as=$},
k_:function k_(a){this.a=null
this.c=$
this.d=a},
k0:function k0(a,b){this.a=a
this.b=b},
k1:function k1(a,b,c){this.a=a
this.b=b
this.c=c},
m6(a,b){var s=new Int32Array(4),r=new Int32Array(4),q=new Int8Array(4),p=new Int8Array(4),o=A.a0(8,null,!1,t.eW),n=A.a0(4,null,!1,t.dP)
return new A.k8(a,b,new A.kg(),new A.kj(),new A.ka(s,r),new A.kl(q,p),o,n,new Uint8Array(4))},
an(a,b,c,d,e){var s,r,q
for(s=a.$flags|0,r=0;r<e;++r){q=c[d+r]
s&2&&A.a(a)
a[b+r]=q}},
nM(a,b,c){if(c===0)if(a===0)return b===0?6:5
else return b===0?4:0
return c},
k8:function k8(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=$
_.d=null
_.e=$
_.f=c
_.r=d
_.w=e
_.x=f
_.as=_.Q=_.z=_.y=0
_.ax=_.at=null
_.ch=_.ay=$
_.cx=_.CW=null
_.cy=$
_.db=g
_.dy=h
_.fr=null
_.fy=_.fx=$
_.go=null
_.id=i
_.p3=_.p2=_.p1=_.ok=_.k4=_.k3=_.k2=_.k1=$
_.R8=_.p4=null
_.x2=_.x1=_.to=_.ry=_.rx=_.RG=$
_.xr=null
_.y2=_.y1=0
_.cf=$
_.bz=null
_.dW=$
_.dX=_.fE=null
_.dY=$},
nK(a){var s=new A.eE(a)
s.b=254
s.c=0
s.d=-8
return s},
eE:function eE(a){var _=this
_.a=a
_.d=_.c=_.b=$
_.e=!1},
B(a,b,c){return B.a.aD(B.a.j(a+2*b+c+2,2),32)},
qy(a){var s,r=A.m([A.B(J.c(a.a,a.d+-33),J.c(a.a,a.d+-32),J.c(a.a,a.d+-31)),A.B(J.c(a.a,a.d+-32),J.c(a.a,a.d+-31),J.c(a.a,a.d+-30)),A.B(J.c(a.a,a.d+-31),J.c(a.a,a.d+-30),J.c(a.a,a.d+-29)),A.B(J.c(a.a,a.d+-30),J.c(a.a,a.d+-29),J.c(a.a,a.d+-28))],t.t)
for(s=0;s<4;++s)a.cY(s*32,4,r)},
qq(a){var s=J.c(a.a,a.d+-33),r=J.c(a.a,a.d+-1),q=J.c(a.a,a.d+31),p=J.c(a.a,a.d+63),o=J.c(a.a,a.d+95),n=A.r(a,null,0),m=n.d6(),l=A.B(s,r,q)
m.$flags&2&&A.a(m)
m[0]=16843009*l
n.d+=32
l=n.d6()
m=A.B(r,q,p)
l.$flags&2&&A.a(l)
l[0]=16843009*m
n.d+=32
m=n.d6()
l=A.B(q,p,o)
m.$flags&2&&A.a(m)
m[0]=16843009*l
n.d+=32
l=n.d6()
m=A.B(p,o,o)
l.$flags&2&&A.a(l)
l[0]=16843009*m},
qo(a){var s,r,q,p
for(s=4,r=0;r<4;++r)s+=J.c(a.a,a.d+(r-32))+J.c(a.a,a.d+(-1+r*32))
s=B.a.j(s,3)
for(r=0;r<4;++r){q=a.a
p=a.d+r*32
J.dB(q,p,p+4,s)}},
m7(a,b){var s,r,q,p,o,n=255-J.c(a.a,a.d+-33)
for(s=0,r=0;r<b;++r){q=n+J.c(a.a,a.d+(s-1))
for(p=0;p<b;++p){o=$.lt()[q+J.c(a.a,a.d+(-32+p))]
J.V(a.a,a.d+(s+p),o)}s+=32}},
qw(a){A.m7(a,4)},
qx(a){A.m7(a,8)},
qv(a){A.m7(a,16)},
qu(a){var s,r=J.c(a.a,a.d+-1),q=J.c(a.a,a.d+31),p=J.c(a.a,a.d+63),o=J.c(a.a,a.d+95),n=J.c(a.a,a.d+-33),m=J.c(a.a,a.d+-32),l=J.c(a.a,a.d+-31),k=J.c(a.a,a.d+-30),j=J.c(a.a,a.d+-29)
a.l(0,96,A.B(q,p,o))
s=A.B(r,q,p)
a.l(0,97,s)
a.l(0,64,s)
s=A.B(n,r,q)
a.l(0,98,s)
a.l(0,65,s)
a.l(0,32,s)
s=A.B(m,n,r)
a.l(0,99,s)
a.l(0,66,s)
a.l(0,33,s)
a.l(0,0,s)
s=A.B(l,m,n)
a.l(0,67,s)
a.l(0,34,s)
a.l(0,1,s)
s=A.B(k,l,m)
a.l(0,35,s)
a.l(0,2,s)
a.l(0,3,A.B(j,k,l))},
qt(a){var s,r=J.c(a.a,a.d+-32),q=J.c(a.a,a.d+-31),p=J.c(a.a,a.d+-30),o=J.c(a.a,a.d+-29),n=J.c(a.a,a.d+-28),m=J.c(a.a,a.d+-27),l=J.c(a.a,a.d+-26),k=J.c(a.a,a.d+-25)
a.l(0,0,A.B(r,q,p))
s=A.B(q,p,o)
a.l(0,32,s)
a.l(0,1,s)
s=A.B(p,o,n)
a.l(0,64,s)
a.l(0,33,s)
a.l(0,2,s)
s=A.B(o,n,m)
a.l(0,96,s)
a.l(0,65,s)
a.l(0,34,s)
a.l(0,3,s)
s=A.B(n,m,l)
a.l(0,97,s)
a.l(0,66,s)
a.l(0,35,s)
s=A.B(m,l,k)
a.l(0,98,s)
a.l(0,67,s)
a.l(0,99,A.B(l,k,k))},
qA(a){var s=J.c(a.a,a.d+-1),r=J.c(a.a,a.d+31),q=J.c(a.a,a.d+63),p=J.c(a.a,a.d+-33),o=J.c(a.a,a.d+-32),n=J.c(a.a,a.d+-31),m=J.c(a.a,a.d+-30),l=J.c(a.a,a.d+-29),k=B.a.aD(B.a.j(p+o+1,1),32)
a.l(0,65,k)
a.l(0,0,k)
k=B.a.aD(B.a.j(o+n+1,1),32)
a.l(0,66,k)
a.l(0,1,k)
k=B.a.aD(B.a.j(n+m+1,1),32)
a.l(0,67,k)
a.l(0,2,k)
a.l(0,3,B.a.aD(B.a.j(m+l+1,1),32))
a.l(0,96,A.B(q,r,s))
a.l(0,64,A.B(r,s,p))
k=A.B(s,p,o)
a.l(0,97,k)
a.l(0,32,k)
k=A.B(p,o,n)
a.l(0,98,k)
a.l(0,33,k)
k=A.B(o,n,m)
a.l(0,99,k)
a.l(0,34,k)
a.l(0,35,A.B(n,m,l))},
qz(a){var s,r=J.c(a.a,a.d+-32),q=J.c(a.a,a.d+-31),p=J.c(a.a,a.d+-30),o=J.c(a.a,a.d+-29),n=J.c(a.a,a.d+-28),m=J.c(a.a,a.d+-27),l=J.c(a.a,a.d+-26),k=J.c(a.a,a.d+-25)
a.l(0,0,B.a.aD(B.a.j(r+q+1,1),32))
s=B.a.aD(B.a.j(q+p+1,1),32)
a.l(0,64,s)
a.l(0,1,s)
s=B.a.aD(B.a.j(p+o+1,1),32)
a.l(0,65,s)
a.l(0,2,s)
s=B.a.aD(B.a.j(o+n+1,1),32)
a.l(0,66,s)
a.l(0,3,s)
a.l(0,32,A.B(r,q,p))
s=A.B(q,p,o)
a.l(0,96,s)
a.l(0,33,s)
s=A.B(p,o,n)
a.l(0,97,s)
a.l(0,34,s)
s=A.B(o,n,m)
a.l(0,98,s)
a.l(0,35,s)
a.l(0,67,A.B(n,m,l))
a.l(0,99,A.B(m,l,k))},
qr(a){var s,r=J.c(a.a,a.d+-1),q=J.c(a.a,a.d+31),p=J.c(a.a,a.d+63),o=J.c(a.a,a.d+95)
a.l(0,0,B.a.aD(B.a.j(r+q+1,1),32))
s=B.a.aD(B.a.j(q+p+1,1),32)
a.l(0,32,s)
a.l(0,2,s)
s=B.a.aD(B.a.j(p+o+1,1),32)
a.l(0,64,s)
a.l(0,34,s)
a.l(0,1,A.B(r,q,p))
s=A.B(q,p,o)
a.l(0,33,s)
a.l(0,3,s)
s=A.B(p,o,o)
a.l(0,65,s)
a.l(0,35,s)
a.l(0,99,o)
a.l(0,98,o)
a.l(0,97,o)
a.l(0,96,o)
a.l(0,66,o)
a.l(0,67,o)},
qp(a){var s=J.c(a.a,a.d+-1),r=J.c(a.a,a.d+31),q=J.c(a.a,a.d+63),p=J.c(a.a,a.d+95),o=J.c(a.a,a.d+-33),n=J.c(a.a,a.d+-32),m=J.c(a.a,a.d+-31),l=J.c(a.a,a.d+-30),k=B.a.aD(B.a.j(s+o+1,1),32)
a.l(0,34,k)
a.l(0,0,k)
k=B.a.aD(B.a.j(r+s+1,1),32)
a.l(0,66,k)
a.l(0,32,k)
k=B.a.aD(B.a.j(q+r+1,1),32)
a.l(0,98,k)
a.l(0,64,k)
a.l(0,96,B.a.aD(B.a.j(p+q+1,1),32))
a.l(0,3,A.B(n,m,l))
a.l(0,2,A.B(o,n,m))
k=A.B(s,o,n)
a.l(0,35,k)
a.l(0,1,k)
k=A.B(r,s,o)
a.l(0,67,k)
a.l(0,33,k)
k=A.B(q,r,s)
a.l(0,99,k)
a.l(0,65,k)
a.l(0,97,A.B(p,q,r))},
qL(a){var s
for(s=0;s<16;++s)a.c0(s*32,16,a,-32)},
qJ(a){var s,r,q,p,o
for(s=0,r=16;r>0;--r){q=J.c(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.dB(p,o,o+16,q)
s+=32}},
ke(a,b){var s,r,q
for(s=0;s<16;++s){r=b.a
q=b.d+s*32
J.dB(r,q,q+16,a)}},
qB(a){var s,r
for(s=16,r=0;r<16;++r)s+=J.c(a.a,a.d+(-1+r*32))+J.c(a.a,a.d+(r-32))
A.ke(B.a.j(s,5),a)},
qD(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.c(a.a,a.d+(-1+r*32))
A.ke(B.a.j(s,4),a)},
qC(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.c(a.a,a.d+(r-32))
A.ke(B.a.j(s,4),a)},
qE(a){A.ke(128,a)},
qM(a){var s
for(s=0;s<8;++s)a.c0(s*32,8,a,-32)},
qK(a){var s,r,q,p,o
for(s=0,r=0;r<8;++r){q=J.c(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.dB(p,o,o+8,q)
s+=32}},
kf(a,b){var s,r,q
for(s=0;s<8;++s){r=b.a
q=b.d+s*32
J.dB(r,q,q+8,a)}},
qF(a){var s,r
for(s=8,r=0;r<8;++r)s+=J.c(a.a,a.d+(r-32))+J.c(a.a,a.d+(-1+r*32))
A.kf(B.a.j(s,4),a)},
qG(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.c(a.a,a.d+(r-32))
A.kf(B.a.j(s,3),a)},
qH(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.c(a.a,a.d+(-1+r*32))
A.kf(B.a.j(s,3),a)},
qI(a){A.kf(128,a)},
kb(a,b){return B.a.j(a*b+1073741824,16)-16384},
kc(a,b,c,d,e){var s=b+c+d*32
a.l(0,s,A.qn(J.c(a.a,a.d+s)+(B.a.j(e+65536,3)-8192)))},
kd(a,b,c,d,e){A.kc(a,0,0,b,c+d)
A.kc(a,0,1,b,c+e)
A.kc(a,0,2,b,c-e)
A.kc(a,0,3,b,c-d)},
qs(){var s,r,q,p
if(!$.nL){for(s=-255;s<=255;++s){r=$.mD()
q=255+s
p=s<0?-s:s
r.$flags&2&&A.a(r)
r[q]=p
p=$.mE()
r=B.a.j(r[q],1)
p.$flags&2&&A.a(p)
p[q]=r}for(s=-1020;s<=1020;++s){r=$.mF()
if(s<-128)q=-128
else q=s>127?127:s
r.$flags&2&&A.a(r)
r[1020+s]=q}for(s=-112;s<=112;++s){r=$.mG()
if(s<-16)q=-16
else q=s>15?15:s
r.$flags&2&&A.a(r)
r[112+s]=q}for(s=-255;s<=510;++s){r=$.lt()
if(s<0)q=0
else q=s>255?255:s
r.$flags&2&&A.a(r)
r[255+s]=q}$.nL=!0}},
qn(a){var s
if((a&-256)>>>0===0)s=a
else s=a<0?0:255
return s},
k9:function k9(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
qm(){var s,r=J.ak(3,t.D)
for(s=0;s<3;++s)r[s]=new Uint8Array(11)
return new A.eD(r)},
r1(){var s,r,q,p,o=new Uint8Array(3),n=J.ak(4,t.c7)
for(s=t.dd,r=0;r<4;++r){q=J.ak(8,s)
for(p=0;p<8;++p)q[p]=A.qm()
n[r]=q}B.c.an(o,0,3,255)
return new A.kk(o,n)},
kg:function kg(){this.d=$},
kj:function kj(){},
kl:function kl(a,b){var _=this
_.b=_.a=!1
_.c=!0
_.d=a
_.e=b},
eD:function eD(a){this.a=a},
kk:function kk(a,b){this.a=a
this.b=b},
ka:function ka(a,b){var _=this
_.a=$
_.b=null
_.d=_.c=$
_.e=a
_.f=b},
bF:function bF(){var _=this
_.b=_.a=0
_.c=!1
_.d=0},
hC:function hC(){this.b=this.a=0},
hE:function hE(a,b,c){this.a=a
this.b=b
this.c=c},
hD:function hD(a,b){var _=this
_.a=a
_.b=$
_.c=b
_.e=_.d=null
_.f=$},
hF:function hF(a,b,c){this.a=a
this.b=b
this.c=c},
m8(a,b){var s,r=A.m([],t.Z),q=A.m([],t.d),p=new Uint32Array(2),o=new A.hA(a,p)
p=o.e=J.aj(B.l.gA(p),0,null)
s=a.D()
p.$flags&2&&A.a(p)
p[0]=s
s=a.D()
p.$flags&2&&A.a(p)
p[1]=s
s=a.D()
p.$flags&2&&A.a(p)
p[2]=s
s=a.D()
p.$flags&2&&A.a(p)
p[3]=s
s=a.D()
p.$flags&2&&A.a(p)
p[4]=s
s=a.D()
p.$flags&2&&A.a(p)
p[5]=s
s=a.D()
p.$flags&2&&A.a(p)
p[6]=s
s=a.D()
p.$flags&2&&A.a(p)
p[7]=s
o.b=!1
return new A.eF(o,b,r,q)},
bG(a,b){return B.a.j(a+B.a.M(1,b)-1,b)},
eF:function eF(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=null
_.w=_.r=_.f=0
_.x=null
_.Q=_.z=_.y=0
_.as=null
_.at=0
_.ax=c
_.ay=null
_.ch=d
_.CW=0
_.cx=null
_.cy=$
_.db=0
_.dx=null
_.fr=_.dy=0},
fO:function fO(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=null
_.w=_.r=_.f=0
_.x=null
_.Q=_.z=_.y=0
_.as=null
_.at=0
_.ax=c
_.ay=null
_.ch=d
_.CW=0
_.cx=null
_.cy=$
_.db=0
_.dx=null
_.fr=_.dy=0},
hA:function hA(a,b){var _=this
_.a=0
_.b=!0
_.c=a
_.d=b
_.e=$},
kh:function kh(a,b){this.a=a
this.b=b},
bp(a,b){return((a^b)>>>1&2139062143)+((a&b)>>>0)},
cp(a){if(a<0)return 0
if(a>255)return 255
return a},
ki(a,b,c){return Math.abs(b-c)-Math.abs(a-c)},
qN(a,b,c){return 4278190080},
qO(a,b,c){return a},
qT(a,b,c){return b[c]},
qU(a,b,c){return b[c+1]},
qV(a,b,c){return b[c-1]},
qW(a,b,c){var s=b[c]
return A.bp(A.bp(a,b[c+1]),s)},
qX(a,b,c){return A.bp(a,b[c-1])},
qY(a,b,c){return A.bp(a,b[c])},
qZ(a,b,c){return A.bp(b[c-1],b[c])},
r_(a,b,c){return A.bp(b[c],b[c+1])},
qP(a,b,c){var s=b[c-1],r=b[c],q=b[c+1]
return A.bp(A.bp(a,s),A.bp(r,q))},
qQ(a,b,c){var s=b[c],r=b[c-1]
return A.ki(s>>>24,a>>>24,r>>>24)+A.ki(s>>>16&255,a>>>16&255,r>>>16&255)+A.ki(s>>>8&255,a>>>8&255,r>>>8&255)+A.ki(s&255,a&255,r&255)<=0?s:a},
qR(a,b,c){var s=b[c],r=b[c-1]
return(A.cp((a>>>24)+(s>>>24)-(r>>>24))<<24|A.cp((a>>>16&255)+(s>>>16&255)-(r>>>16&255))<<16|A.cp((a>>>8&255)+(s>>>8&255)-(r>>>8&255))<<8|A.cp((a&255)+(s&255)-(r&255)))>>>0},
qS(a,b,c){var s,r,q,p=b[c],o=b[c-1],n=A.bp(a,p)
p=n>>>24
s=n>>>16&255
r=n>>>8&255
q=n>>>0&255
return(A.cp(p+B.a.V(p-(o>>>24),2))<<24|A.cp(s+B.a.V(s-(o>>>16&255),2))<<16|A.cp(r+B.a.V(r-(o>>>8&255),2))<<8|A.cp(q+B.a.V(q-(o&255),2)))>>>0},
co:function co(a,b){this.a=a
this.b=b},
hB:function hB(a){var _=this
_.a=a
_.c=_.b=0
_.d=null
_.e=0},
km:function km(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.f=_.e=_.d=0
_.r=1
_.w=!1
_.x=$
_.y=!1},
eG:function eG(){},
fP:function fP(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.r=_.f=$
_.w=1
_.y=_.x=$},
lE(a){var s,r=J.e5(a,t.gj)
for(s=0;s<a;++s)r[s]=new A.ft()
return new A.dT(r,0)},
pA(){var s,r,q=J.ak(5,t.fa)
for(s=0;s<5;++s)q[s]=A.lE(0)
r=J.ak(64,t.ak)
for(s=0;s<64;++s)r[s]=new A.fu()
return new A.dS(q,r)},
ft:function ft(){this.b=this.a=0},
fu:function fu(){this.b=this.a=0},
dT:function dT(a,b){this.a=a
this.b=b},
dS:function dS(a,b){var _=this
_.a=a
_.b=!1
_.c=0
_.e=_.d=!1
_.f=b},
dU:function dU(){var _=this
_.b=_.a=null
_.e=_.d=0},
fv:function fv(a){this.a=a
this.b=null},
dj:function dj(a,b){this.a=a
this.b=b},
dk:function dk(a,b){var _=this
_.b=_.a=0
_.c=null
_.e=_.d=!1
_.f=a
_.r=null
_.w=""
_.y=0
_.z=b
_.as=0
_.at=null
_.ch=_.ay=0},
fQ:function fQ(a,b){var _=this
_.b=_.a=0
_.c=null
_.e=_.d=!1
_.f=a
_.r=null
_.w=""
_.y=0
_.z=b
_.as=0
_.at=null
_.ch=_.ay=0},
kn:function kn(a){this.a=null
this.b=a
this.c=null},
kq:function kq(a,b){this.a=a
this.b=b},
ko:function ko(a,b){this.a=a
this.b=b},
kp:function kp(a,b,c){this.a=a
this.b=b
this.c=c},
n5(a){return new A.bb(a.a,a.b,B.c.hb(a.c,0))},
fw:function fw(a,b){this.a=a
this.b=b},
bb:function bb(a,b,c){this.a=a
this.b=b
this.c=c},
Q(a,b,c,d,e,f,g,h,i,j,k,l,m){var s,r=null,q=new A.aw(r,r,r,a,h,e,d,0)
q.gar().push(q)
if(l<0||f<0)A.X(A.aU("Invalid image dimensions "+l+"x"+f,r))
q.c=g
if(b!=null)q.e=A.dK(b)
s=!1
if(j==null)if(m)s=q.gH()===B.u||q.gH()===B.x||q.gH()===B.y||q.gH()===B.e||q.gH()===B.m
q.eF(l,f,c,i,s?q.hZ(c,k,i):j)
return q},
fC(a,b,c,d){var s,r,q,p,o=null,n=a.e
n=n==null?o:A.dK(n)
s=a.c
s=s==null?o:A.n5(s)
r=a.w
q=a.r
p=a.f
p=p==null?o:new A.aW(new Uint8Array(A.t(p.a)))
r=new A.aw(o,s,n,p,q,r,a.y,a.z)
r.hr(a,b,c,d)
return r},
aK(a,b,c){var s,r,q,p,o,n=null,m=a.a
m=m==null?n:m.b4(c)
s=a.e
s=s==null?n:A.dK(s)
r=a.c
r=r==null?n:A.n5(r)
q=a.w
p=a.r
o=a.f
o=o==null?n:new A.aW(new Uint8Array(A.t(o.a)))
q=new A.aw(m,r,s,o,p,q,a.y,a.z)
q.hq(a,b,c)
return q},
fs:function fs(a,b){this.a=a
this.b=b},
aw:function aw(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=null
_.c=b
_.d=null
_.e=c
_.f=d
_.r=e
_.w=f
_.x=$
_.y=g
_.z=h},
iP:function iP(a,b){this.a=a
this.b=b},
iO:function iO(){},
a9:function a9(){},
pC(a,b,c){return new A.cS(new Uint16Array(a*b*c),a,b,c)},
cS:function cS(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
pD(a,b,c){return new A.cT(new Float32Array(a*b*c),a,b,c)},
cT:function cT(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
dX:function dX(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
dY:function dY(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
dZ:function dZ(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
e_:function e_(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
cU:function cU(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
c2:function c2(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
cV:function cV(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
pE(a,b,c){return new A.cW(new Uint32Array(a*b*c),a,b,c)},
cW:function cW(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
cX:function cX(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
ng(a,b,c){return new A.cY(new Uint8Array(a*b*c),null,a,b,c)},
cY:function cY(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
e2:function e2(a,b){this.a=a
this.b=b},
jn:function jn(){},
h5:function h5(a,b,c){this.c=a
this.a=b
this.b=c},
h6:function h6(a,b,c){this.c=a
this.a=b
this.b=c},
h7:function h7(a,b,c){this.c=a
this.a=b
this.b=c},
h8:function h8(a,b,c){this.c=a
this.a=b
this.b=c},
h9:function h9(a,b,c){this.c=a
this.a=b
this.b=c},
ha:function ha(a,b,c){this.c=a
this.a=b
this.b=c},
hb:function hb(a,b,c){this.c=a
this.a=b
this.b=c},
hc:function hc(a,b,c){this.c=a
this.a=b
this.b=c},
nv(a){return new A.b6(new Uint8Array(A.t(a.c)),a.a,a.b)},
b6:function b6(a,b,c){this.c=a
this.a=b
this.b=c},
lP(a){return new A.c8(-1,0,-a.c,a)},
c8:function c8(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
lQ(a){return new A.c9(-1,0,-a.c,a)},
c9:function c9(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
lR(a){return new A.ca(-1,0,-a.c,a)},
ca:function ca(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
lS(a){return new A.cb(-1,0,-a.c,a)},
cb:function cb(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
lT(a){return new A.cc(-1,0,-a.c,a)},
cc:function cc(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
lU(a){return new A.cd(-1,0,-a.c,a)},
cd:function cd(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
aZ(a,b,c,d,e){a.Z(b-1,c)
return new A.jo(a,b,b+d-1,c+e-1)},
jo:function jo(a,b,c,d){var _=this
_.a=a
_.b=b
_.d=c
_.e=d},
en(a){return new A.ce(-1,0,0,-1,0,a)},
ce:function ce(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
lV(a){return new A.cf(-1,0,-a.c,a)},
cf:function cf(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
eo(a){return new A.cg(-1,0,0,-2,0,a)},
cg:function cg(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
lW(a){return new A.ch(-1,0,-a.c,a)},
ch:function ch(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ep(a){return new A.ci(-1,0,0,-(a.c<<2>>>0),a)},
ci:function ci(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
jp(a){return new A.cj(-1,0,-a.c,a)},
cj:function cj(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
D:function D(){},
on(a,b){var s
if(b===B.T)s=A.aP(a)>0
else s=a.gH()===B.e&&!a.gbr()
return s},
oA(a,b){return b>=5&&b<=8?a.gR():a.gX()},
oz(a,b){return b>=5&&b<=8?a.gX():a.gR()},
u5(a,b,c,d,e,f,g,h,i,j,k,l){var s,r,q,p,o
if(!A.on(a,c))return!1
s=a.T()
r=A.aP(a)
q=new A.kS(s,r,A.oA(a,l),A.oz(a,l))
q.hB(a,l)
p=b.T()
o=b.a.gaw()
if(c===B.T){if(A.aP(b)!==r)return!1
A.tm(q,p,o,d,e,f,g,j,k)
return!0}if(b.gH()!==B.e||b.a.c!==a.a.c)return!1
switch(c.a){case 1:A.tl(q,p,o,d,e,f,g,h,i)
return!0
case 3:A.tj(q,p,o,d,e,f,g,h,i)
return!0
case 2:A.tk(q,p,o,d,e,f,g,h,i)
return!0
case 0:return!1}},
tm(a,b,c,d,a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g=a.b,f=a.a,e=new Int32Array(a1)
for(s=a.f,r=0;r<a1;++r){q=a3[r]
s===$&&A.b()
e[r]=q*s}for(s=b.$flags|0,q=a.e,p=a.r,o=d*g,n=0;n<a2;++n){m=a4[n]
q===$&&A.b()
p===$&&A.b()
l=q+m*p
k=(a0+n)*c+o
for(r=0;r<a1;++r){j=l+e[r]
for(i=0;i<g;++i,k=h){h=k+1
m=f[j+i]
s&2&&A.a(b)
b[k]=m}}}},
tl(a,b,a0,a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h=a.b,g=a.c-1,f=a.d-1,e=new Int32Array(a3),d=new Int32Array(a3),c=new Float64Array(a3)
for(s=0;s<a3;++s){r=s*a5
q=B.b.h(r)
c[s]=r-q
p=a.f
p===$&&A.b()
e[s]=q*p
d[s]=B.a.I(q+1,0,g)*p}for(p=a.a,o=a1*h,n=0;n<a4;++n){m=n*a6
l=B.b.h(m)
k=B.a.I(l+1,0,f)
j=a.e
j===$&&A.b()
i=a.r
i===$&&A.b()
A.tc(p,j+l*i,j+k*i,b,(a2+n)*a0+o,h,a3,e,d,c,m-l)}},
tc(a,b,c,d,e,a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f
for(s=d.$flags|0,r=0;r<a1;++r){q=a2[r]
p=b+q
o=a3[r]
n=b+o
m=c+q
l=c+o
k=a4[r]
for(j=0;j<a0;++j,e=f){i=a[p+j]
h=a[n+j]
g=a[m+j]
f=e+1
q=B.b.h(i+k*(h-i+a5*(i+a[l+j]-g-h))+a5*(g-i))
s&2&&A.a(d)
d[e]=q}}},
tj(a6,a7,a8,a9,b0,b1,b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=a6.b,a4=new Int32Array(b1),a5=new Int32Array(b1)
for(s=0;s<b1;s=q){r=B.b.h(s*b3)
q=s+1
p=B.b.h(q*b3)
if(p===r)++p
a4[s]=r
a5[s]=p}o=new Int32Array(a3)
for(n=a7.$flags|0,m=a6.a,l=a9*a3,k=0;k<b2;k=i){j=B.b.h(k*b4)
i=k+1
h=B.b.h(i*b4)
if(h===j)++h
g=(b0+k)*a8+l
for(f=h-j,s=0;s<b1;++s){r=a4[s]
p=a5[s]
for(e=0;e<a3;++e)o[e]=0
for(d=p-r,c=j;c<h;++c){b=a6.e
b===$&&A.b()
a=a6.r
a===$&&A.b()
a0=a6.f
a0===$&&A.b()
A.tx(m,b+c*a+r*a0,d,a0,a3,o)}a1=1/(f*d)
for(e=0;e<a3;++e,g=a2){a2=g+1
d=B.b.h(o[e]*a1)
n&2&&A.a(a7)
a7[g]=d}}}},
tx(a,b,c,d,e,f){var s,r,q,p,o
for(s=f.$flags|0,r=0;r<c;++r,b+=d)for(q=0;q<e;++q){p=f[q]
o=a[b+q]
s&2&&A.a(f)
f[q]=p+o}},
tk(b6,b7,b8,b9,c0,c1,c2,c3,c4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=b6.b,b1=b6.a,b2=c1*4,b3=new Int32Array(b2),b4=new Uint8Array(b2),b5=new Float64Array(c1)
for(b2=b6.f,s=b6.c,r=0;r<c1;++r){q=r*c3
p=B.b.h(q)
b5[r]=q-p
for(o=r*4,n=0;n<4;++n){m=p+n-1
l=o+n
b2===$&&A.b()
b3[l]=m*b2
b4[l]=m<0||m>=s?0:1}}k=new Int32Array(4)
j=new Uint8Array(4)
i=new Int32Array(16)
h=new Float64Array(4)
for(b2=b7.$flags|0,s=b9*b0,o=b6.e,l=b6.r,g=b6.d,f=0;f<c2;++f){e=f*c4
d=B.b.h(e)
c=e-d
for(n=0;n<4;++n){b=d+n-1
o===$&&A.b()
l===$&&A.b()
k[n]=o+b*l
j[n]=b<0||b>=g?0:1}a=(c0+f)*b8+s
for(r=0;r<c1;++r){a0=r*4
a1=k[1]+b3[a0+1]
for(a2=0;a2<4;++a2)for(a3=a2*4,n=0;n<4;++n){a4=j[a2]===0||b4[a0+n]===0?a1:k[a2]+b3[a0+n]
i[a3+n]=a4}a5=b5[r]
for(a6=0;a6<b0;++a6,a=a9){for(a2=0;a2<4;++a2){a7=a2*4
h[a2]=A.o3(a5,b1[i[a7]+a6],b1[i[a7+1]+a6],b1[i[a7+2]+a6],b1[i[a7+3]+a6])}a8=A.o3(c,h[0],h[1],h[2],h[3])
a9=a+1
if(a8<0)a0=0
else a0=a8>255?255:B.b.h(a8)
b2&2&&A.a(b7)
b7[a]=a0}}}},
o3(a,b,c,d,e){var s=-b,r=a*a
return c+0.5*(a*(s+d)+r*(2*b-5*c+4*d-e)+r*a*(s+3*c-3*d+e))},
kS:function kS(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.r=_.f=_.e=$},
tI(f3,f4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,e0,e1,e2,e3,e4,e5,e6,e7,e8,e9,f0=null,f1="ifd0",f2={}
f2.a=s
f2.a=B.T
f3.gbr()
r=1
if(f3.gbj().n(0,f1).a.am(274)&&f3.gbj().n(0,f1).gbt()!==1){q=f3.gbj().n(0,f1).gbt()
q.toString
if(q>=2&&q<=8&&B.k.kz(f3.gar(),new A.la(f2)))r=q
else f3=A.om(f3)}p=A.oA(f3,r)
o=A.oz(f3,r)
n=B.b.b7(f4*(o/p))
if(f4<=0)f4=B.b.b7(n*(p/o))
m=n
if(f4===p&&n===o)return r===1?A.aK(f3,!1,!1):A.om(f3)
l=new Int32Array(f4)
for(k=0;k<f4;++k)l[k]=B.a.a5(k*p,f4)
j=new Int32Array(m)
for(i=0;i<m;++i)j[i]=B.a.a5(i*o,m)
h=f3.gar().length
for(q=r>=5,g=t.g,f=r<=8,e=f0,d=0;d<h;++d){c=f3.x
b=(c===$?f3.x=A.m([],g):c)[d]
a=A.fC(b,n,!0,f4)
a0=e==null
if(!a0)e.aY(a)
if(a0)e=a
a0=q&&f
a1=b.a
if(a0){a0=a1==null?f0:a1.a
if(a0==null)a0=0}else{a0=a1==null?f0:a1.b
if(a0==null)a0=0}a2=a0/m
if(q&&f){a0=a1==null?f0:a1.b
if(a0==null)a0=0}else{a0=a1==null?f0:a1.a
if(a0==null)a0=0}a3=a0/f4
if(A.u5(b,a,f2.a,0,0,f4,m,a3,a2,l,j,r))continue
a0=f2.a
if(a0===B.cn){a4=b.ad(0,0)
for(i=0;i<m;i=a6){a5=B.b.h(i*a2)
a6=i+1
a7=B.b.h(a6*a2)
if(a7===a5)++a7
for(k=0;k<f4;k=a9){a8=B.b.h(k*a3)
a9=k+1
b0=B.b.h(a9*a3)
if(b0===a8)++b0
for(b1=a5,b2=0,b3=0,b4=0,b5=0,b6=0;b1<a7;++b1)for(b7=a8;b7<b0;++b7,++b6){a0=b.a
if(a0!=null)a0.K(b7,b1,a4)
b2+=a4.gq()
b3+=a4.gt()
b4+=a4.gu()
b5+=a4.gv()}b8=1/b6
a0=a.a
if(a0!=null)a0.ai(k,i,b2*b8,b3*b8,b4*b8,b5*b8)}}}else if(a0===B.T){a0=b.a
if((a0==null?f0:a0.gP())!=null)for(i=0;i<m;++i){b9=j[i]
for(k=0;k<f4;++k){a0=l[k]
a1=b.a
a0=a1==null?f0:B.b.h(a1.aH(a0,b9).gL())
if(a0==null)a0=0
a1=a.a
if(a1!=null)a1.aB(k,i,a0)}}else{a4=b.ad(0,0)
for(i=0;i<m;++i){b1=j[i]
for(k=0;k<f4;++k){a0=l[k]
a1=b.a
if(a1!=null)a1.K(a0,b1,a4)
a0=a4.gq()
a1=a4.gt()
c0=a4.gu()
c1=a4.gv()
c2=a.a
if(c2!=null)c2.ai(k,i,a0,a1,c0,c1)}}}}else if(a0===B.cm){c3=b.ad(0,0)
c4=b.ad(0,0)
c5=b.ad(0,0)
c6=b.ad(0,0)
a0=b.a
a1=a0==null
c0=a1?f0:a0.a
c7=(c0==null?0:c0)-1
a0=a1?f0:a0.b
c8=(a0==null?0:a0)-1
for(i=0;i<m;++i){c9=i*a2
d0=B.b.h(c9)
d1=c9-d0
d2=B.a.I(d0+1,0,c8)
for(k=0;k<f4;++k){d3=k*a3
d4=B.b.h(d3)
d5=d3-d4
d6=B.a.I(d4+1,0,c7)
a0=b.a
if(a0!=null)a0.K(d4,d0,c3)
a0=b.a
if(a0!=null)a0.K(d4,d2,c4)
a0=b.a
if(a0!=null)a0.K(d6,d0,c5)
a0=b.a
if(a0!=null)a0.K(d6,d2,c6)
a0=c3.gq()
a1=c5.gq()
c0=c4.gq()
c1=c6.gq()
c2=c3.gt()
d7=c5.gt()
d8=c4.gt()
d9=c6.gt()
e0=c3.gu()
e1=c5.gu()
e2=c4.gu()
e3=c6.gu()
e4=c3.gv()
e5=c5.gv()
e6=c4.gv()
e7=c6.gv()
e8=a.a
if(e8!=null)e8.ai(k,i,a0+d5*(a1-a0+d1*(a0+c1-c0-a1))+d1*(c0-a0),c2+d5*(d7-c2+d1*(c2+d9-d8-d7))+d1*(d8-c2),e0+d5*(e1-e0+d1*(e0+e3-e2-e1))+d1*(e2-e0),e4+d5*(e5-e4+d1*(e4+e7-e6-e5))+d1*(e6-e4))}}}else for(i=0;i<m;++i){e9=i*a2
for(k=0;k<f4;++k)a.bD(k,i,b.ea(k*a3,e9,f2.a))}}if(r!==1)e.gbj().n(0,f1).sbt(f0)
e.toString
return e},
la:function la(a){this.a=a},
tO(a,b){switch(b.a){case 0:A.lf(a)
break
case 1:A.os(a)
break
case 2:A.tP(a)
break}return a},
os(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=null,a2=a3.gar().length
for(s=t.g,r=0;r<a2;++r){q=a3.x
p=(q===$?a3.x=A.m([],s):q)[r]
o=p.a
n=o==null
m=n?a1:o.a
if(m==null)m=0
l=n?a1:o.b
if(l==null)l=0
k=B.a.V(l,2)
if(!n){j=J.C(o.gA(o))
if(j==null){o=p.a
o=o==null?a1:o.gA(o)
if(o==null)o=B.c.gA(new Uint8Array(0))
j=J.C(o)}i=p.a.gaw()
h=new Uint8Array(i)
for(g=l-1,f=0;f<k;++f,--g){e=f*i
d=g*i
B.c.a_(h,0,i,j,e)
B.c.a_(j,e,e+i,j,d)
B.c.aK(j,d,d+i,h)}continue}o=a3.a
if((o==null?a1:o.gP())!=null)for(g=l-1,f=0;f<k;++f,--g)for(c=0;c<m;++c){o=p.a
b=o==null?a1:o.K(c,f,a1)
if(b==null)b=new A.D()
o=p.a
a=o==null?a1:o.K(c,g,a1)
if(a==null)a=new A.D()
a0=b.gL()
b.sL(a.gL())
a.sL(a0)}else for(g=l-1,f=0;f<k;++f,--g)for(c=0;c<m;++c){o=p.a
b=o==null?a1:o.K(c,f,a1)
if(b==null)b=new A.D()
o=p.a
a=o==null?a1:o.K(c,g,a1)
if(a==null)a=new A.D()
a0=b.gq()
b.sq(a.gq())
a.sq(a0)
a0=b.gt()
b.st(a.gt())
a.st(a0)
a0=b.gu()
b.su(a.gu())
a.su(a0)
a0=b.gv()
b.sv(a.gv())
a.sv(a0)}}return a3},
lf(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=null,a1=a2.gar().length
for(s=t.g,r=0;r<a1;++r){q=a2.x
p=(q===$?a2.x=A.m([],s):q)[r]
o=p.a
n=o==null
m=n?a0:o.a
if(m==null)m=0
l=n?a0:o.b
if(l==null)l=0
k=B.a.V(m,2)
j=A.aP(p)
if(j>0){o=p.a
i=o==null?a0:J.C(o.gA(o))
if(i==null){o=p.a
o=o==null?a0:o.gA(o)
if(o==null)o=B.c.gA(new Uint8Array(0))
i=J.C(o)}h=p.a.gaw()
for(g=0;g<l;++g)A.oD(i,g*h,m,j)
continue}o=a2.a
if((o==null?a0:o.gP())!=null)for(f=m-1,g=0;g<l;++g)for(e=f,d=0;d<k;++d,--e){o=p.a
c=o==null?a0:o.K(d,g,a0)
if(c==null)c=new A.D()
o=p.a
b=o==null?a0:o.K(e,g,a0)
if(b==null)b=new A.D()
a=c.gL()
c.sL(b.gL())
b.sL(a)}else for(f=m-1,g=0;g<l;++g)for(e=f,d=0;d<k;++d,--e){o=p.a
c=o==null?a0:o.K(d,g,a0)
if(c==null)c=new A.D()
o=p.a
b=o==null?a0:o.K(e,g,a0)
if(b==null)b=new A.D()
a=c.gq()
c.sq(b.gq())
b.sq(a)
a=c.gt()
c.st(b.gt())
b.st(a)
a=c.gu()
c.su(b.gu())
b.su(a)
a=c.gv()
c.sv(b.gv())
b.sv(a)}}return a2},
tP(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=null,a0=a1.gar().length
for(s=t.g,r=0;r<a0;++r){q=a1.x
p=(q===$?a1.x=A.m([],s):q)[r]
o=p.a
n=o==null
m=n?a:o.a
if(m==null)m=0
l=n?a:o.b
if(l==null)l=0
k=A.aP(p)
if(k>0){o=p.a
o=o==null?a:J.C(o.gA(o))
if(o==null){o=p.a
o=o==null?a:o.gA(o)
if(o==null)o=B.c.gA(new Uint8Array(0))
o=J.C(o)}A.oD(o,0,m*l,k)
continue}o=p.a
if((o==null?a:o.gP())!=null)for(j=l-1,i=m-1,h=0;h<=j;++h,--j){g=h===j?B.a.V(m,2):m
for(f=i,e=0;e<g;++e,--f){o=p.a
d=o==null?a:o.K(e,h,a)
if(d==null)d=new A.D()
o=p.a
c=o==null?a:o.K(f,j,a)
if(c==null)c=new A.D()
b=d.gL()
d.sL(c.gL())
c.sL(b)}}else for(j=l-1,i=m-1,h=0;h<=j;++h,--j){g=h===j?B.a.V(m,2):m
for(f=i,e=0;e<g;++e,--f){o=p.a
d=o==null?a:o.K(e,h,a)
if(d==null)d=new A.D()
o=p.a
c=o==null?a:o.K(f,j,a)
if(c==null)c=new A.D()
b=d.gq()
d.sq(c.gq())
c.sq(b)
b=d.gt()
d.st(c.gt())
c.st(b)
b=d.gu()
d.su(c.gu())
c.su(b)
b=d.gv()
d.sv(c.gv())
c.sv(b)}}}return a1},
iv:function iv(a,b){this.a=a
this.b=b},
i(a){return new A.fD(a)},
fD:function fD(a){this.a=a},
q(a,b,c,d){var s=J.a3(a),r=s.gp(a)
s=c==null?s.gp(a):d+c
return new A.a6(a,d,Math.min(r,s),d,b)},
r(a,b,c){var s=a.a,r=a.d,q=J.bM(s),p=b==null?a.c:a.d+c+b
return new A.a6(s,a.b,Math.min(q,p),r+c,a.e)},
a6:function a6(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
jl(a){return new A.jk(new Uint8Array(a))},
jk:function jk(a){this.a=0
this.c=a},
df:function df(a,b){this.a=a
this.b=b},
j3:function j3(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.r=$
_.w=f
_.x=g
_.$ti=h},
d_:function d_(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.e=d
_.f=e
_.r=f
_.$ti=g},
fT:function fT(a,b){this.a=a
this.b=b},
e3:function e3(a,b){this.a=a
this.b=b},
fR:function fR(a,b){this.a=a
this.$ti=b},
rd(a,b,c,d){var s=new A.hS(a,A.nF(d),c.m("@<0>").aC(d).m("hS<1,2>"))
s.hA(a,b,c,d)
return s},
fS:function fS(a,b){this.a=a
this.$ti=b},
hS:function hS(a,b,c){this.a=a
this.c=b
this.$ti=c},
kP:function kP(a,b){this.a=a
this.b=b},
hR:function hR(){},
ln(a,b,c,d){var s=0,r=A.mo(t.H),q,p
var $async$ln=A.mp(function(e,f){if(e===1)return A.mh(f,r)
for(;;)switch(s){case 0:p=v.G.self
p=J.lv(p)===B.bB?A.rd(A.o2(p),null,c,d):A.pG(p,A.ow(A.op(),c),!1,null,A.ow(A.op(),c),c,d)
q=A.nQ(null,t.H)
s=2
return A.mg(q,$async$ln)
case 2:p.ge2().fM(new A.lo(a,new A.fR(new A.fS(p,c.m("@<0>").aC(d).m("fS<1,2>")),c.m("@<0>").aC(d).m("fR<1,2>")),d,c))
p.dZ()
return A.mi(null,r)}})
return A.mj($async$ln,r)},
lo:function lo(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
iS:function iS(){},
lG(a,b,c){return new A.ax(c,a,b)},
pH(a){var s,r,q,p=A.mf(a.n(0,"name")),o=t.O.a(a.n(0,"value")),n=o.n(0,"e")
if(n==null)n=A.l4(n)
s=new A.eX(A.mf(o.n(0,"s")))
for(r=0;r<2;++r){q=$.pI[r].$2(n,s)
if(q.gcZ()===p)return q}return new A.ax("",n,s)},
ql(a,b){return new A.cn("",a,b)},
nJ(a,b){return new A.cn("",a,b)},
ax:function ax(a,b,c){this.a=a
this.b=b
this.c=c},
cn:function cn(a,b,c){this.a=a
this.b=b
this.c=c},
fB(a,b){var s
A:{if(b.b(a)){s=a
break A}if(typeof a=="number"){s=new A.fz(a)
break A}if(typeof a=="string"){s=new A.fA(a)
break A}if(A.i3(a)){s=new A.fy(a)
break A}if(t.Y.b(a)){s=new A.dV(J.mQ(a,new A.iM(),t.f),B.hG)
break A}if(t.O.b(a)){s=t.f
s=new A.dW(a.e1(0,new A.iN(),s,s),B.jk)
break A}s=A.X(A.ql("Unsupported type "+J.lv(a).B(0)+" when wrapping an IsolateType",B.H))}return b.a(s)},
L:function L(){},
iM:function iM(){},
iN:function iN(){},
fz:function fz(a){this.a=a},
fA:function fA(a){this.a=a},
fy:function fy(a){this.a=a},
dV:function dV(a,b){this.b=a
this.a=b},
dW:function dW(a,b){this.b=a
this.a=b},
bq:function bq(){},
kN:function kN(a){this.a=a},
ao:function ao(){},
kO:function kO(a){this.a=a},
qk(a){throw A.e(A.b8("Uint64List not supported on the web."))},
pF(a,b,c){return J.lu(a,b,c)},
nI(a,b){return J.au(a,b,null)},
pw(a){return J.mN(a,0,null)},
px(a){return a.lg(0,0,null)},
oG(a){return v.mangledGlobalNames[a]},
cv(a,b){var s,r,q,p
if(t.D.b(a)&&a.length>=32)return A.rP(a,b)
s=J.a3(a)
r=s.gp(a)
b^=4294967295
for(q=0;r>=8;){p=q+1
b=B.v[(b^s.n(a,q))&255]^b>>>8
q=p+1
b=B.v[(b^s.n(a,p))&255]^b>>>8
p=q+1
b=B.v[(b^s.n(a,q))&255]^b>>>8
q=p+1
b=B.v[(b^s.n(a,p))&255]^b>>>8
p=q+1
b=B.v[(b^s.n(a,q))&255]^b>>>8
q=p+1
b=B.v[(b^s.n(a,p))&255]^b>>>8
p=q+1
b=B.v[(b^s.n(a,q))&255]^b>>>8
q=p+1
b=B.v[(b^s.n(a,p))&255]^b>>>8
r-=8}if(r>0)do{p=q+1
b=B.v[(b^s.n(a,q))&255]^b>>>8
if(--r,r>0){q=p
continue}else break}while(!0)
return(b^4294967295)>>>0},
rM(a){var s,r,q,p,o,n=new Uint32Array(8192)
for(s=0;s<256;++s)n[s]=a[s]
for(r=1;r<32;++r)for(q=(r-1)*256,p=r*256,s=0;s<256;++s){o=n[q+s]
n[p+s]=(o>>>8^n[o&255])>>>0}return n},
rP(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=$.oj
if(e==null)e=$.oj=A.rM(B.v)
s=a.length
r=J.p4(B.c.gA(a),a.byteOffset,s)
q=b^4294967295
p=s-32
for(o=0;o<=p;){n=q^r.getUint32(o,!0)
m=r.getUint32(o+4,!0)
l=r.getUint32(o+8,!0)
k=r.getUint32(o+12,!0)
j=r.getUint32(o+16,!0)
i=r.getUint32(o+20,!0)
h=r.getUint32(o+24,!0)
g=r.getUint32(o+28,!0)
q=e[7936+(n&255)]^e[7680+(n>>>8&255)]^e[7424+(n>>>16&255)]^e[7168+(n>>>24)]^e[6912+(m&255)]^e[6656+(m>>>8&255)]^e[6400+(m>>>16&255)]^e[6144+(m>>>24)]^e[5888+(l&255)]^e[5632+(l>>>8&255)]^e[5376+(l>>>16&255)]^e[5120+(l>>>24)]^e[4864+(k&255)]^e[4608+(k>>>8&255)]^e[4352+(k>>>16&255)]^e[4096+(k>>>24)]^e[3840+(j&255)]^e[3584+(j>>>8&255)]^e[3328+(j>>>16&255)]^e[3072+(j>>>24)]^e[2816+(i&255)]^e[2560+(i>>>8&255)]^e[2304+(i>>>16&255)]^e[2048+(i>>>24)]^e[1792+(h&255)]^e[1536+(h>>>8&255)]^e[1280+(h>>>16&255)]^e[1024+(h>>>24)]^e[768+(g&255)]^e[512+(g>>>8&255)]^e[256+(g>>>16&255)]^e[g>>>24]
o+=32}for(;o<s;o=f){f=o+1
q=e[(q^a[o])&255]^q>>>8}return(q^4294967295)>>>0},
mr(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n,m,l
if(j==null)j=0
if(k==null)k=0
if(i==null)i=b.gX()
if(h==null)h=b.gR()
if(e==null)e=a.gX()<b.gX()?a.gX():b.gX()
if(d==null)d=a.gR()<b.gR()?a.gR():b.gR()
s=c===B.a0
if(!s&&a.gbr())a=a.dV(a.gbs())
r=h/d
q=i/e
p=t.p
o=J.ak(d,p)
for(n=0;n<d;++n)o[n]=k+B.b.h(n*r)
m=J.ak(e,p)
for(l=0;l<e;++l)m[l]=j+B.b.h(l*q)
if(s)A.rR(b,a,f,g,e,d,m,o,null,B.aD)
else A.rO(b,a,f,g,e,d,m,o,c,!1,null,B.aD)
return a},
rR(a3,a4,a5,a6,a7,a8,a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a4.gX(),a1=a4.gR(),a2=A.aP(a3)
if(a2>0&&A.aP(a4)===a2&&a3.gH()===a4.gH()&&a3.gbr()===a4.gbr()&&a5>=0&&a6>=0){s=a3.T()
r=a4.T()
q=a3.a.gaw()
p=a4.a.gaw()
o=Math.min(a7,a0-a5)
n=r.$flags|0
m=a5*a2
l=0
for(;;){if(!(l<a8&&a6+l<a1))break
k=b0[l]*q
j=(a6+l)*p+m
for(i=0;i<o;++i){h=k+a9[i]*a2
for(g=0;g<a2;++g,j=f){f=j+1
e=s[h+g]
n&2&&A.a(r)
r[j]=e}}++l}return}for(d=null,l=0;l<a8;++l)for(c=a6+l,n=c>=a1,i=0;i<a7;++i){b=a5+i
if(b>=a0||n)continue
m=a9[i]
e=b0[l]
a=a3.a
d=a==null?null:a.K(m,e,d)
if(d==null)d=new A.D()
a4.bD(b,c,d)}},
rO(a,b,c,d,e,f,g,h,i,j,k,l){var s,r,q,p,o,n,m
for(s=null,r=0;r<f;++r)for(q=d+r,p=0;p<e;++p){o=g[p]
n=h[r]
m=a.a
s=m==null?null:m.K(o,n,s)
if(s==null)s=new A.D()
A.tL(b,c+p,q,s,i,!1,k,l)}},
tL(a8,a9,b0,b1,b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7
if(!a8.fH(a9,b0))return a8
if(b2===B.a0||a8.gbr())if(a8.fH(a9,b0)){a8.aH(a9,b0).aJ(b1)
return a8}s=b1.ga8()
r=b1.ga3()
q=b1.ga7()
p=b1.gp(b1)<4?1:b1.gaa()
if(p===0)return a8
o=a8.aH(a9,b0)
n=o.ga8()
m=o.ga3()
l=o.ga7()
k=o.gaa()
switch(b2.a){case 0:return a8
case 1:break
case 2:s=Math.max(n,s)
r=Math.max(m,r)
q=Math.max(l,q)
break
case 3:s=1-(1-s)*(1-n)
r=1-(1-r)*(1-m)
q=1-(1-q)*(1-l)
break
case 4:j=p*k
i=1-k
h=1-p
g=s*i+n*h
f=r*i+m*h
e=q*i+l*h
h=B.b.I(p,0.01,1)
i=p<0
d=i?0:1
c=B.b.I(s/h*d,0,0.99)
d=B.b.I(p,0.01,1)
h=i?0:1
b=B.b.I(r/d*h,0,0.99)
h=B.b.I(p,0.01,1)
i=i?0:1
a=B.b.I(q/h*i,0,0.99)
i=n*p
h=m*p
d=l*p
a0=j<s*k+i?0:1
a1=j<r*k+h?0:1
a2=j<q*k+d?0:1
s=(j+g)*(1-a0)+(i/(1-c)+g)*a0
r=(j+f)*(1-a1)+(h/(1-b)+f)*a1
q=(j+e)*(1-a2)+(d/(1-a)+e)*a2
break
case 5:s=n+s
r=m+r
q=l+q
break
case 6:s=Math.min(n,s)
r=Math.min(m,r)
q=Math.min(l,q)
break
case 7:s=n*s
r=m*r
q=l*q
break
case 8:s=s!==0?1-(1-n)/s:0
r=r!==0?1-(1-m)/r:0
q=q!==0?1-(1-l)/q:0
break
case 9:i=1-k
h=1-p
d=s*i
a3=n*h
s=2*n<k?2*s*n+d+a3:p*k-2*(k-n)*(p-s)+d+a3
d=r*i
a3=m*h
r=2*m<k?2*r*m+d+a3:p*k-2*(k-m)*(p-r)+d+a3
i=q*i
h=l*h
q=2*l<k?2*q*l+i+h:p*k-2*(k-l)*(p-q)+i+h
break
case 10:i=k===0
if(i)s=0
else{h=n/k
s=n*(p*h+2*s*(1-h))+s*(1-k)+n*(1-p)}if(i)r=0
else{h=m/k
r=m*(p*h+2*r*(1-h))+r*(1-k)+m*(1-p)}if(i)q=0
else{i=l/k
q=l*(p*i+2*q*(1-i))+q*(1-k)+l*(1-p)}break
case 11:i=2*s
h=1-k
d=1-p
a3=s*h
a4=n*d
s=i<p?i*n+a3+a4:p*k-2*(k-n)*(p-s)+a3+a4
i=2*r
a3=r*h
a4=m*d
r=i<p?i*m+a3+a4:p*k-2*(k-m)*(p-r)+a3+a4
i=2*q
h=q*h
d=l*d
q=i<p?i*l+h+d:p*k-2*(k-l)*(p-q)+h+d
break
case 12:s=Math.abs(s-n)
r=Math.abs(r-m)
q=Math.abs(q-l)
break
case 13:s=n-s
r=m-r
q=l-q
break
case 14:s=s!==0?n/s:0
r=r!==0?m/r:0
q=q!==0?l/q:0
break}a5=1-p
a6=p+k*a5
a7=a6>0?1/a6:0
o.sa8((s*p+n*k*a5)*a7)
o.sa3((r*p+m*k*a5)*a7)
o.sa7((q*p+l*k*a5)*a7)
o.saa(a6)
return a8},
or(a,b,c,d,e,f,g){var s,r=B.b.I(Math.min(d,e),0,a.gX()-1),q=B.b.I(Math.min(f,g),0,a.gR()-1),p=B.b.I(Math.max(d,e),0,a.gX()-1),o=B.b.I(Math.max(f,g),0,a.gR()-1),n=a.a.b0(0,r,q,p-r+1,o-q+1)
for(s=n.a;n.E();)s.aJ(c)
return a},
tR(a){var s,r,q,p,o,n,m,l,k,j=null
if(a.gbr())a=a.dV(a.gbs())
for(s=a.gar(),r=s.length,q=0;q<s.length;s.length===r||(0,A.a5)(s),++q){p=s[q]
o=p.a
if((o==null?j:o.gP())!=null){o=p.a
n=o==null?j:o.gP()
m=n.a
for(l=0;l<m;++l){k=0.299*n.aI(l)+0.587*n.aG(l)+0.114*n.aE(l)
n.bd(l,k)
n.bc(l,k)
n.bb(l,k)}}else{o=p.a
o=o==null?j:o.gH()
o=(o==null?B.e:o)===B.e&&p.gbs()>=3
if(o){o=p.a
o=o==null?j:J.C(o.gA(o))
if(o==null){o=p.a
o=o==null?j:o.gA(o)
if(o==null)o=B.c.gA(new Uint8Array(0))
o=J.C(o)}A.rW(o,p.gbs(),1)}else for(o=p.a,o=o.gF(o);o.E();){n=o.gJ()
k=0.299*n.gq()+0.587*n.gt()+0.114*n.gu()
n.sq(k)
n.st(k)
n.su(k)}}}return a},
rW(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h=a.length
if(c===1){for(s=a.$flags|0,r=0;r<h;r+=b){q=r+1
p=r+2
o=B.b.h(0.299*a[r]+0.587*a[q]+0.114*a[p])
s&2&&A.a(a)
a[r]=o
a[q]=o
a[p]=o}return}n=1-c
for(s=a.$flags|0,r=0;r<h;r+=b){m=a[r]
q=r+1
l=a[q]
p=r+2
k=a[p]
j=(0.299*m+0.587*l+0.114*k)*c
i=B.b.h(B.b.I(m*n+j,0,255))
s&2&&A.a(a)
a[r]=i
a[q]=B.b.h(B.b.I(l*n+j,0,255))
a[p]=B.b.h(B.b.I(k*n+j,0,255))}},
J(a){var s,r,q
try{r=a.$0()
return r}catch(q){s=A.ar(q)
if(s instanceof A.fD)throw q
throw A.e(A.i("Invalid image data: "+A.x(s)))}},
pt(a6,a7,a8,a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=b2<16384,a5=a8>b0?b0:a8
for(s=1;s<=a5;)s=s<<1>>>0
s=s>>>1
r=s>>>1
q=A.m([0,0],t.t)
for(p=a6.$flags|0,o=s,s=r;s>=1;o=s,s=r){n=a7+b1*(b0-o)
m=b1*s
l=b1*o
k=a9*s
j=a9*o
for(i=(a8&s)>>>0!==0,h=a9*(a8-o),g=a7;g<=n;g+=l){f=g+h
for(e=g;e<=f;e+=j){d=e+k
c=e+m
b=c+k
if(a4){A.dM(a6[e],a6[c],q)
a=q[0]
a0=q[1]
A.dM(a6[d],a6[b],q)
a1=q[0]
a2=q[1]
A.dM(a,a1,q)
a3=q[0]
p&2&&A.a(a6)
a6[e]=a3
a6[d]=q[1]
A.dM(a0,a2,q)
a6[c]=q[0]
a6[b]=q[1]}else{A.dN(a6[e],a6[c],q)
a=q[0]
a0=q[1]
A.dN(a6[d],a6[b],q)
a1=q[0]
a2=q[1]
A.dN(a,a1,q)
a3=q[0]
p&2&&A.a(a6)
a6[e]=a3
a6[d]=q[1]
A.dN(a0,a2,q)
a6[c]=q[0]
a6[b]=q[1]}}if(i){c=e+m
if(a4){A.dM(a6[e],a6[c],q)
a=q[0]
a3=q[1]
p&2&&A.a(a6)
a6[c]=a3}else{A.dN(a6[e],a6[c],q)
a=q[0]
a3=q[1]
p&2&&A.a(a6)
a6[c]=a3}p&2&&A.a(a6)
a6[e]=a}}if((b0&s)>>>0!==0){f=g+h
for(e=g;e<=f;e+=j){d=e+k
if(a4){A.dM(a6[e],a6[d],q)
a=q[0]
i=q[1]
p&2&&A.a(a6)
a6[d]=i}else{A.dN(a6[e],a6[d],q)
a=q[0]
i=q[1]
p&2&&A.a(a6)
a6[d]=i}p&2&&A.a(a6)
a6[e]=a}}r=s>>>1}},
dM(a,b,c){var s,r,q,p,o=$.ah()
o.$flags&2&&A.a(o)
o[0]=a
s=$.as()
r=s[0]
o[0]=b
q=s[0]
p=r+(q&1)+B.a.j(q,1)
c[0]=p
c[1]=p-q},
dN(a,b,c){var s=a-B.a.j(b,1)&65535
c[1]=s
c[0]=b+s-32768&65535},
tN(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=null,f=268435456,e=A.nn()
if(e.aA(a))return e
s=A.nw(g)
if(s.aA(a))return s
r=new A.iy(f)
if(r.aA(a))return r
q=new A.kn(f)
if(q.aA(a))return q
p=new A.k_(f)
if(p.f7(A.q(a,!1,g,0),!0)!=null)return p
o=new A.jB(f)
if(o.aA(a))return o
if(A.ps(a))return new A.ip(f)
n=A.pb(!1,g)
if(n.aA(a))return n
m=A.a0(A.pP(g),g,!1,t.E)
l=new A.jv(new A.ea(m,t.ha),f)
if(l.aA(a))return l
k=new A.jV(f)
j=A.q(a,!1,g,0)
m=k.a=new A.hs(B.a8)
m.bu(j)
if(m.fK())return k
i=new A.iE(f)
if(i.aA(a))return i
h=new A.jJ(f)
if(h.aA(a))return h
return g},
u3(b3,b4,b5,b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2
if($.ml==null){s=new Uint8Array(768)
for(r=0;r<256;++r)s[256+r]=r
for(r=256;r<512;++r)s[256+r]=255
$.ml=s}for(q=b7.$flags|0,r=0;r<64;++r){p=b4[b5+r]
o=b3[r]
q&2&&A.a(b7)
b7[r]=p*o}for(n=0,r=0;r<8;++r,n+=8){p=1+n
o=b7[p]
if(o===0&&b7[2+n]===0&&b7[3+n]===0&&b7[4+n]===0&&b7[5+n]===0&&b7[6+n]===0&&b7[7+n]===0){p=B.a.j(5793*b7[n]+512,10)
m=(p&2147483647)-((p&2147483648)>>>0)
q&2&&A.a(b7)
b7[n]=m
b7[n+1]=m
b7[n+2]=m
b7[n+3]=m
b7[n+4]=m
b7[n+5]=m
b7[n+6]=m
b7[n+7]=m
continue}l=B.a.j(5793*b7[n]+128,8)
k=(l&2147483647)-((l&2147483648)>>>0)
l=4+n
j=B.a.j(5793*b7[l]+128,8)
i=(j&2147483647)-((j&2147483648)>>>0)
j=2+n
h=b7[j]
g=6+n
f=b7[g]
e=7+n
d=b7[e]
c=B.a.j(2896*(o-d)+128,8)
b=(c&2147483647)-((c&2147483648)>>>0)
d=B.a.j(2896*(o+d)+128,8)
a=(d&2147483647)-((d&2147483648)>>>0)
d=3+n
o=b7[d]<<4
a0=(o&2147483647)-((o&2147483648)>>>0)
o=5+n
c=b7[o]<<4
a1=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.j(k-i+1,1)
m=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.j(k+i+1,1)
k=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.j(h*3784+f*1567+128,8)
c=(c&2147483647)-((c&2147483648)>>>0)
a2=B.a.j(h*1567-f*3784+128,8)
h=(a2&2147483647)-((a2&2147483648)>>>0)
a2=B.a.j(b-a1+1,1)
a2=(a2&2147483647)-((a2&2147483648)>>>0)
a3=B.a.j(b+a1+1,1)
b=(a3&2147483647)-((a3&2147483648)>>>0)
a3=B.a.j(a+a0+1,1)
a3=(a3&2147483647)-((a3&2147483648)>>>0)
a4=B.a.j(a-a0+1,1)
a0=(a4&2147483647)-((a4&2147483648)>>>0)
a4=B.a.j(k-c+1,1)
a4=(a4&2147483647)-((a4&2147483648)>>>0)
c=B.a.j(k+c+1,1)
k=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.j(m-h+1,1)
c=(c&2147483647)-((c&2147483648)>>>0)
a5=B.a.j(m+h+1,1)
i=(a5&2147483647)-((a5&2147483648)>>>0)
a5=B.a.j(b*2276+a3*3406+2048,12)
m=(a5&2147483647)-((a5&2147483648)>>>0)
a3=B.a.j(b*3406-a3*2276+2048,12)
b=(a3&2147483647)-((a3&2147483648)>>>0)
a3=B.a.j(a0*799+a2*4017+2048,12)
a3=(a3&2147483647)-((a3&2147483648)>>>0)
a2=B.a.j(a0*4017-a2*799+2048,12)
a0=(a2&2147483647)-((a2&2147483648)>>>0)
q&2&&A.a(b7)
b7[n]=k+m
b7[e]=k-m
b7[p]=i+a3
b7[g]=i-a3
b7[j]=c+a0
b7[o]=c-a0
b7[d]=a4+b
b7[l]=a4-b}for(r=0;r<8;++r){a6=8+r
a7=16+r
a8=24+r
a9=32+r
b0=40+r
b1=48+r
b2=56+r
p=b7[a6]
if(p===0&&b7[a7]===0&&b7[a8]===0&&b7[a9]===0&&b7[b0]===0&&b7[b1]===0&&b7[b2]===0){p=B.a.j(5793*b7[r]+8192,14)
m=(p&2147483647)-((p&2147483648)>>>0)
q&2&&A.a(b7)
b7[r]=m
b7[a6]=m
b7[a7]=m
b7[a8]=m
b7[a9]=m
b7[b0]=m
b7[b1]=m
b7[b2]=m
continue}o=B.a.j(5793*b7[r]+2048,12)
k=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(5793*b7[a9]+2048,12)
i=(o&2147483647)-((o&2147483648)>>>0)
h=b7[a7]
f=b7[b1]
o=b7[b2]
l=B.a.j(2896*(p-o)+2048,12)
b=(l&2147483647)-((l&2147483648)>>>0)
o=B.a.j(2896*(p+o)+2048,12)
a=(o&2147483647)-((o&2147483648)>>>0)
a0=b7[a8]
a1=b7[b0]
o=B.a.j(k-i+1,1)
m=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(k+i+1,1)
k=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(h*3784+f*1567+2048,12)
p=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(h*1567-f*3784+2048,12)
h=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(b-a1+1,1)
o=(o&2147483647)-((o&2147483648)>>>0)
l=B.a.j(b+a1+1,1)
b=(l&2147483647)-((l&2147483648)>>>0)
l=B.a.j(a+a0+1,1)
l=(l&2147483647)-((l&2147483648)>>>0)
j=B.a.j(a-a0+1,1)
a0=(j&2147483647)-((j&2147483648)>>>0)
j=B.a.j(k-p+1,1)
j=(j&2147483647)-((j&2147483648)>>>0)
p=B.a.j(k+p+1,1)
k=(p&2147483647)-((p&2147483648)>>>0)
p=B.a.j(m-h+1,1)
p=(p&2147483647)-((p&2147483648)>>>0)
g=B.a.j(m+h+1,1)
i=(g&2147483647)-((g&2147483648)>>>0)
g=B.a.j(b*2276+l*3406+2048,12)
m=(g&2147483647)-((g&2147483648)>>>0)
l=B.a.j(b*3406-l*2276+2048,12)
b=(l&2147483647)-((l&2147483648)>>>0)
l=B.a.j(a0*799+o*4017+2048,12)
l=(l&2147483647)-((l&2147483648)>>>0)
o=B.a.j(a0*4017-o*799+2048,12)
a0=(o&2147483647)-((o&2147483648)>>>0)
q&2&&A.a(b7)
b7[r]=k+m
b7[b2]=k-m
b7[a6]=i+l
b7[b1]=i-l
b7[a7]=p+a0
b7[b0]=p-a0
b7[a8]=j+b
b7[a9]=j-b}for(q=$.ml,p=b6.$flags|0,r=0;r<64;++r){q.toString
o=B.a.j(b7[r]+8,4)
o=q[384+((o&2147483647)-((o&2147483648)>>>0))]
p&2&&A.a(b6)
b6[r]=o}},
f5(a,b){return(a&65535)*b+((a>>>16)*b&65535)*65536>>>0},
r6(a,b,c,d,e,f){A.r3(f,a,b,c,d,e,!0,f)},
r7(a,b,c,d,e,f){A.r4(f,a,b,c,d,e,!0,f)},
r5(a,b,c,d,e,f){A.r2(f,a,b,c,d,e,!0,f)},
di(a,b,c,d,e){var s,r,q
for(s=0;s<d;++s){r=J.c(a.a,a.d+s)
q=J.c(b.a,b.d+s)
J.V(c.a,c.d+s,r+q)}},
r3(a,b,c,d,e,f,g,h){var s,r,q=null,p=e*d,o=e+f,n=A.q(a,!1,q,p),m=A.q(h,!1,q,p),l=A.r(m,q,0)
if(e===0){m.l(0,0,J.c(n.a,n.d))
A.di(A.r(n,q,1),l,A.r(m,q,1),b-1,!0)
l.d+=d
n.d+=d
m.d+=d
e=1}for(s=-d,r=b-1;e<o;){A.di(n,A.r(l,q,s),m,1,!0)
A.di(A.r(n,q,1),l,A.r(m,q,1),r,!0);++e
l.d+=d
n.d+=d
m.d+=d}},
r4(a,b,c,d,e,f,g,h){var s=null,r=e*d,q=e+f,p=A.q(a,!1,s,r),o=A.q(h,!1,s,r),n=A.r(o,s,0)
if(e===0){o.l(0,0,J.c(p.a,p.d))
A.di(A.r(p,s,1),n,A.r(o,s,1),b-1,!0)
p.d+=d
o.d+=d
e=1}else n.d-=d
while(e<q){A.di(p,n,o,b,!0);++e
n.d+=d
p.d+=d
o.d+=d}},
r2(a,b,c,d,e,f,g,h){var s,r,q,p,o,n=null,m=e*d,l=e+f,k=A.q(a,!1,n,m),j=A.q(h,!1,n,m),i=A.r(j,n,0)
if(e===0){j.l(0,0,J.c(k.a,k.d))
A.di(A.r(k,n,1),i,A.r(j,n,1),b-1,!0)
i.d+=d
k.d+=d
j.d+=d
e=1}for(s=-d;e<l;){A.di(k,A.r(i,n,s),j,1,!0)
for(r=1;r<b;++r){q=r-d
p=J.c(i.a,i.d+(r-1))+J.c(i.a,i.d+q)-J.c(i.a,i.d+(q-1))
if((p&4294967040)>>>0===0)o=p
else o=p<0?0:255
q=J.c(k.a,k.d+r)
J.V(j.a,j.d+r,q+o)}++e
i.d+=d
k.d+=d
j.d+=d}},
aP(a){var s,r,q,p=a.a
if(p==null)return 0
s=p.gb3()
if(s==null)s=0
r=s*p.c
if((r&7)!==0)return 0
q=B.a.j(r,3)
return p.gaw()===a.gX()*q?q:0},
u6(a,b,c,d){var s,r,q,p,o,n
for(s=a.$flags|0,r=0;r<d;++r){q=b+r
p=a[q]
o=c+r
n=a[o]
s&2&&A.a(a)
a[q]=n
a[o]=p}},
oD(a,b,c,d){var s,r
for(s=b+(c-1)*d,r=b;r<s;r+=d,s-=d)A.u6(a,r,s,d)},
om(a){var s,r="ifd0"
if(!a.gbj().n(0,r).a.am(274)||a.gbj().n(0,r).gbt()===1)return A.aK(a,!1,!1)
switch(a.gbj().n(0,r).gbt()){case 2:s=A.lf(A.aK(a,!1,!1))
break
case 3:s=A.tO(A.aK(a,!1,!1),B.cd)
break
case 4:s=A.os(A.aK(a,!1,!1))
break
case 5:s=A.lf(A.lb(a,90))
break
case 6:s=A.lb(a,90)
break
case 7:s=A.lf(A.lb(a,-90))
break
case 8:s=A.lb(a,-90)
break
default:s=A.aK(a,!1,!1)
break}s.e=A.dK(a.gbj())
s.gbj().n(0,r).sbt(null)
return s},
lb(b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=null,b0=B.a.a9(b2,360)
b1.gbr()
if(B.a.a9(b0,90)===0)switch(B.a.V(b0,90)){case 1:return A.tp(b1)
case 2:return A.tn(b1)
case 3:return A.to(b1)
default:return A.aK(b1,!1,!1)}s=b0*3.141592653589793/180
r=Math.cos(s)
q=Math.sin(s)
p=b1.gX()
o=b1.gX()
n=b1.gR()
m=b1.gR()
l=0.5*b1.gX()
k=0.5*b1.gR()
n=Math.abs(p*r)+Math.abs(n*q)
j=0.5*n
m=Math.abs(o*q)+Math.abs(m*r)
i=0.5*m
h=b1.gar().length
for(p=t.g,g=b1.f,f=a9,e=0;e<h;++e){d=b1.x
c=(d===$?b1.x=A.m([],p):d)[e]
o=f==null
b=o?a9:f.cR()
if(b==null){a=B.b.h(n)
b=A.fC(b1,B.b.h(m),!0,a)}if(o)f=b
a0=c.f
if(a0==null)a0=g
if(a0!=null){o=b.a
if(o!=null)o.aL(0,a0)}for(o=b.a,o=o.gF(o);o.E();){a1=o.gJ()
a2=a1.gaV()
a3=a1.gaM()
a=a2-j
a4=a3-i
a5=l+a*r+a4*q
a6=k-a*q+a4*r
a=!1
if(a5>=0)if(a6>=0){a4=c.a
a7=a4==null
a8=a7?a9:a4.a
if(a5<(a8==null?0:a8)){a=a7?a9:a4.b
a=a6<(a==null?0:a)}}if(a)b.bD(a2,a3,c.ea(a5,a6,B.T))}}f.toString
return f},
tp(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=null
for(s=a.gar(),r=s.length,q=b,p=0;p<s.length;s.length===r||(0,A.a5)(s),++p){o=s[p]
n=q==null
m=n?b:q.cR()
if(m==null){l=o.a
k=l==null
j=k?b:l.b
if(j==null)j=0
l=k?b:l.a
m=A.fC(o,l==null?0:l,!0,j)}if(n)q=m
n=o.a
n=n==null?b:n.b
i=(n==null?0:n)-1
h=A.aP(o)
if(h>0&&A.aP(m)===h){n=o.a
l=n==null
k=l?b:n.a
g=-(k==null?0:k)*h
f=l?b:J.C(n.gA(n))
if(f==null){n=o.a
n=n==null?b:n.gA(n)
if(n==null)n=B.c.gA(new Uint8Array(0))
f=J.C(n)}n=m.a
e=n==null?b:J.C(n.gA(n))
if(e==null){n=m.a
n=n==null?b:n.gA(n)
if(n==null)n=B.c.gA(new Uint8Array(0))
e=J.C(n)}d=0
for(;;){n=m.a
l=n==null
k=l?b:n.b
if(!(d<(k==null?0:k)))break
k=o.a
k=k==null?b:k.a
if(k==null)k=0
j=l?b:n.a
if(j==null)j=0
n=l?b:n.a
if(n==null)n=0
A.mk(f,(i*k+d)*h,g,e,d*j*h,n,h);++d}continue}d=0
for(;;){n=m.a
n=n==null?b:n.b
if(!(d<(n==null?0:n)))break
c=0
for(;;){n=m.a
n=n==null?b:n.a
if(!(c<(n==null?0:n)))break
n=o.a
n=n==null?b:n.K(d,i-c,b)
m.bD(c,d,n==null?new A.D():n);++c}++d}}q.toString
return q},
tn(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=null
for(s=a.gar(),r=s.length,q=c,p=0;p<s.length;s.length===r||(0,A.a5)(s),++p){o=s[p]
n=o.a
m=n==null
l=m?c:n.a
k=(l==null?0:l)-1
n=m?c:n.b
j=(n==null?0:n)-1
n=q==null
i=n?c:q.cR()
if(i==null)i=A.aK(o,!0,!0)
if(n)q=i
h=A.aP(o)
if(h>0&&A.aP(i)===h){n=o.a
m=n==null
l=m?c:n.a
if(l==null)l=0
g=m?c:n.b
f=l*(g==null?0:g)
n=m?c:J.C(n.gA(n))
if(n==null){n=o.a
n=n==null?c:n.gA(n)
if(n==null)n=B.c.gA(new Uint8Array(0))
n=J.C(n)}m=i.a
m=m==null?c:J.C(m.gA(m))
if(m==null){m=i.a
m=m==null?c:m.gA(m)
if(m==null)m=B.c.gA(new Uint8Array(0))
m=J.C(m)}A.mk(n,(f-1)*h,-h,m,0,f,h)
continue}e=0
for(;;){n=i.a
n=n==null?c:n.b
if(!(e<(n==null?0:n)))break
n=j-e
d=0
for(;;){m=i.a
m=m==null?c:m.a
if(!(d<(m==null?0:m)))break
m=o.a
m=m==null?c:m.K(k-d,n,c)
i.bD(d,e,m==null?new A.D():m);++d}++e}}q.toString
return q},
to(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=null
for(s=a.gar(),r=s.length,q=b,p=0;p<s.length;s.length===r||(0,A.a5)(s),++p){o=s[p]
n=a.a
n=n==null?b:n.a
m=(n==null?0:n)-1
n=q==null
l=n?b:q.cR()
if(l==null){k=o.a
j=k==null
i=j?b:k.b
if(i==null)i=0
k=j?b:k.a
l=A.fC(o,k==null?0:k,!0,i)}if(n)q=l
h=A.aP(o)
n=!1
if(h>0)if(A.aP(l)===h){n=o.a
n=n==null?b:n.a
if(n==null)n=0
k=a.a
k=k==null?b:k.a
n=n===(k==null?0:k)}if(n){n=o.a
k=n==null
j=k?b:n.a
g=(j==null?0:j)*h
f=k?b:J.C(n.gA(n))
if(f==null){n=o.a
n=n==null?b:n.gA(n)
if(n==null)n=B.c.gA(new Uint8Array(0))
f=J.C(n)}n=l.a
e=n==null?b:J.C(n.gA(n))
if(e==null){n=l.a
n=n==null?b:n.gA(n)
if(n==null)n=B.c.gA(new Uint8Array(0))
e=J.C(n)}d=0
for(;;){n=l.a
k=n==null
j=k?b:n.b
if(!(d<(j==null?0:j)))break
j=k?b:n.a
if(j==null)j=0
n=k?b:n.a
if(n==null)n=0
A.mk(f,(m-d)*h,g,e,d*j*h,n,h);++d}continue}d=0
for(;;){n=l.a
n=n==null?b:n.b
if(!(d<(n==null?0:n)))break
n=m-d
c=0
for(;;){k=l.a
k=k==null?b:k.a
if(!(c<(k==null?0:k)))break
k=o.a
k=k==null?b:k.K(n,c,b)
l.bD(c,d,k==null?new A.D():k);++c}++d}}q.toString
return q},
mk(a,b,c,d,e,f,g){var s,r,q,p,o
for(s=d.$flags|0,r=0;r<f;++r,b+=c)for(q=0;q<g;++q,e=p){p=e+1
o=a[b+q]
s&2&&A.a(d)
d[e]=o}},
li(a,b){var s=A.iT(a,B.a1,null,null),r=A.nh(new A.fF(s,B.O,!1,B.aw))
try{s=r.a1(b).T()
return s}finally{r.fA()}},
lc(a){var s
a=(a&-a)>>>0
s=a!==0?31:32
if((a&65535)!==0)s-=16
if((a&16711935)!==0)s-=8
if((a&252645135)!==0)s-=4
if((a&858993459)!==0)s-=2
return(a&1431655765)!==0?s-1:s},
ua(a){$.mK().l(0,0,a)
return $.p1()[0]},
oE(a,b,c,d){return(B.a.I(a,0,255)|B.a.I(b,0,255)<<8|B.a.I(c,0,255)<<16|B.a.I(d,0,255)<<24)>>>0},
b3(a,b,c){var s,r,q,p,o,n=b.gp(b),m=b.gH(),l=a.gP(),k=l==null?null:l.gH()
if(k==null)k=a.gH()
s=a.gp(a)
if(n===1)b.l(0,0,A.dy(B.b.bA(a.gp(a)>2?a.gah():a.n(0,0)),k,m))
else if(n===2){r=s>2?a.gah():a.n(0,0)
b.l(0,0,A.dy(!B.jw.bo(0,k)?B.b.bA(r):r,k,m))
b.l(0,1,A.dy(s===2?a.n(0,1):a.gv(),k,m))}else if(n<=s)for(q=0;q<n;++q)b.l(0,q,A.dy(a.n(0,q),k,m))
else if(s===2){p=A.dy(a.n(0,0),k,m)
if(n===3){b.l(0,0,p)
b.l(0,1,p)
b.l(0,2,p)}else{c=A.dy(a.n(0,1),k,m)
b.l(0,0,p)
b.l(0,1,p)
b.l(0,2,p)
b.l(0,3,c)}}else{for(q=0;q<s;++q)b.l(0,q,A.dy(a.n(0,q),k,m))
o=s===1?b.n(0,0):0
for(q=s;q<n;++q)b.l(0,q,q===3?c:o)}return b},
ms(a,b,c,d,e){var s,r,q=a.gP(),p=q==null?null:q.gH()
if(p==null)p=a.gH()
q=e==null
s=q?null:e.gH()
c=s==null?c:s
if(c==null)c=a.gH()
s=q?null:e.gp(e)
d=s==null?d:s
if(d==null)d=a.gp(a)
if(b==null)b=0
if(c===p&&d===a.gp(a)){if(q)return a.N()
e.aJ(a)
return e}switch(c.a){case 3:if(q)r=new A.aW(new Uint8Array(d))
else r=e
return A.b3(a,r,b)
case 0:return A.b3(a,q?new A.cE(d,0):e,b)
case 1:return A.b3(a,q?new A.cG(d,0):e,b)
case 2:if(q){q=d<3?1:2
r=new A.cI(d,new Uint8Array(q))}else r=e
return A.b3(a,r,b)
case 4:if(q)r=new A.cF(new Uint16Array(d))
else r=e
return A.b3(a,r,b)
case 5:if(q)r=new A.cH(new Uint32Array(d))
else r=e
return A.b3(a,r,b)
case 6:if(q)r=new A.cD(new Int8Array(d))
else r=e
return A.b3(a,r,b)
case 7:if(q)r=new A.cB(new Int16Array(d))
else r=e
return A.b3(a,r,b)
case 8:if(q)r=new A.cC(new Int32Array(d))
else r=e
return A.b3(a,r,b)
case 9:if(q)r=new A.cy(new Uint16Array(d))
else r=e
return A.b3(a,r,b)
case 10:if(q)r=new A.cz(new Float32Array(d))
else r=e
return A.b3(a,r,b)
case 11:if(q)r=new A.cA(new Float64Array(d))
else r=e
return A.b3(a,r,b)}},
W(a){return 0.299*a.gq()+0.587*a.gt()+0.114*a.gu()},
oo(a,b,c,d,e){var s=1-d/255
e[0]=B.b.b7(255*(1-a/255)*s)
e[1]=B.b.b7(255*(1-b/255)*s)
e[2]=B.b.b7(255*(1-c/255)*s)},
G(a){var s,r,q,p=$.mI()
p.$flags&2&&A.a(p)
p[0]=a
s=$.p_()[0]
if(a===0)return s>>>16
if($.F==null)A.K()
r=$.n3.jy()[s>>>23&511]
if(r!==0){q=s&8388607
return r+(q+4095+(q>>>13&1)>>>13)}return A.pu(s)},
pu(a){var s,r,q=a>>>16&32768,p=(a>>>23&255)-112,o=a&8388607
if(p<=0){if(p<-10)return q
o|=8388608
s=14-p
return(q|B.a.bn(o+(B.a.Y(1,s-1)-1)+(B.a.U(o,s)&1),s))>>>0}else if(p===143)if(o===0)return q|31744
else{o=o>>>13
r=o===0?1:0
return q|o|r|31744}else{o=o+4095+(o>>>13&1)
if((o&8388608)!==0){++p
o=0}if(p>30)return q|31744
return(q|p<<10|o>>>13)>>>0}},
K(){var s,r,q,p,o=$.F
if(o!=null)return o
s=new Uint32Array(65536)
$.F=J.mN(B.l.gA(s),0,null)
o=new Uint16Array(512)
$.n3.b=o
for(r=0;r<256;++r){q=(r&255)-112
if(q<=0||q>=30){o[r]=0
o[(r|256)>>>0]=0}else{p=q<<10>>>0
o[r]=p
o[(r|256)>>>0]=(p|32768)>>>0}}for(r=0;r<65536;++r)s[r]=A.pv(r)
o=$.F
o.toString
return o},
pv(a){var s,r=a>>>15&1,q=a>>>10&31,p=a&1023
if(q===0)if(p===0)return r<<31>>>0
else{while((p&1024)===0){p=p<<1;--q}++q
p&=4294966271}else if(q===31){s=r<<31
if(p===0)return(s|2139095040)>>>0
else return(s|p<<13|2139095040)>>>0}return(r<<31|q+112<<23|p<<13)>>>0},
pG(a,b,c,d,e,f,g){var s,r,q
if(t.j.b(a))t.U.a(J.mP(a)).gdT()
s=$.H
r=t.j.b(a)
q=r?t.U.a(J.mP(a)).gdT():a
if(r)J.p9(a)
s=new A.d_(q,d,e,A.nF(f),!1,new A.cq(new A.R(s,t.q),t.ez),f.m("@<0>").aC(g).m("d_<1,2>"))
q.onmessage=A.o6(s.giP())
return s},
mt(a,b,c,d){var s=b==null?null:b.$1(a)
return s==null?d.a(a):s},
u0(){A.ln(A.u7(),null,t.y,t.D)},
tM(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=null,b=A.tN(a0),a=b==null?c:b.aS(a0,c)
if(a==null)return!1
s=A.tR(A.tI(a,400))
r=0
q=0
p=0
o=1
for(;;){n=s.a
n=n==null?c:n.b
if(!(o<(n==null?0:n)-1))break
m=o+1
n=o-1
l=1
for(;;){k=s.a
j=k==null
i=j?c:k.a
if(!(l<(i==null?0:i)-1))break
k=j?c:k.K(l,n,c)
k=(k==null?new A.D():k).gq()
j=s.a
j=j==null?c:j.K(l,m,c)
j=(j==null?new A.D():j).gq()
i=s.a
i=i==null?c:i.K(l-1,o,c)
i=(i==null?new A.D():i).gq()
h=l+1
g=s.a
g=g==null?c:g.K(h,o,c)
g=(g==null?new A.D():g).gq()
f=s.a
f=f==null?c:f.K(l,o,c)
e=k+j+i+g-4*(f==null?new A.D():f).gq()
r+=e
q+=e*e;++p
l=h}o=m}d=r/p
return q/p-d*d>100}},B={}
var w=[A,J,B]
var $={}
A.lJ.prototype={}
J.fI.prototype={
O(a,b){return a===b},
gG(a){return A.d9(a)},
B(a){return"Instance of '"+A.he(a)+"'"},
gao(a){return A.aQ(A.mm(this))}}
J.fV.prototype={
B(a){return String(a)},
gG(a){return a?519018:218159},
gao(a){return A.aQ(t.y)},
$iM:1,
$iaq:1}
J.e7.prototype={
O(a,b){return null==b},
B(a){return"null"},
gG(a){return 0},
gao(a){return A.aQ(t.a)},
$iM:1}
J.e9.prototype={$iT:1}
J.by.prototype={
gG(a){return 0},
gao(a){return B.bB},
B(a){return String(a)}}
J.hd.prototype={}
J.eB.prototype={}
J.bd.prototype={
B(a){var s=a[$.oI()]
if(s==null)s=a[$.mC()]
if(s==null)return this.hc(a)
return"JavaScript function for "+J.dC(s)}}
J.d1.prototype={
gG(a){return 0},
B(a){return String(a)}}
J.d2.prototype={
gG(a){return 0},
B(a){return String(a)}}
J.o.prototype={
dP(a,b){var s
a.$flags&1&&A.a(a,"addAll",2)
for(s=b.gF(b);s.E();)a.push(s.gJ())},
cU(a){a.$flags&1&&A.a(a,"clear","clear")
a.length=0},
bC(a,b,c){return new A.bg(a,b,A.br(a).m("@<1>").aC(c).m("bg<1,2>"))},
kN(a,b){var s,r=A.a0(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)r[s]=A.x(a[s])
return r.join(b)},
fV(a,b){return A.dg(a,0,A.f3(b,"count",t.p),A.br(a).c)},
be(a,b){return A.dg(a,b,null,A.br(a).c)},
bq(a,b){return a[b]},
bO(a,b,c){if(b<0||b>a.length)throw A.e(A.ad(b,0,a.length,"start",null))
if(c<b||c>a.length)throw A.e(A.ad(c,b,a.length,"end",null))
if(b===c)return A.m([],A.br(a))
return A.m(a.slice(b,c),A.br(a))},
gfF(a){if(a.length>0)return a[0]
throw A.e(A.e4())},
gcX(a){var s=a.length
if(s>0)return a[s-1]
throw A.e(A.e4())},
a_(a,b,c,d,e){var s,r,q,p,o
a.$flags&2&&A.a(a,5)
A.cl(b,c,a.length)
s=c-b
if(s===0)return
A.aM(e,"skipCount")
if(t.j.b(d)){r=d
q=e}else{r=J.lw(d,e).d4(0,!1)
q=0}p=J.a3(r)
if(q+s>p.gp(r))throw A.e(A.nk())
if(q<b)for(o=s-1;o>=0;--o)a[b+o]=p.n(r,q+o)
else for(o=0;o<s;++o)a[b+o]=p.n(r,q+o)},
an(a,b,c,d){var s
a.$flags&2&&A.a(a,"fillRange")
A.cl(b,c,a.length)
for(s=b;s<c;++s)a[s]=d},
kz(a,b){var s,r=a.length
for(s=0;s<r;++s){if(!b.$1(a[s]))return!1
if(a.length!==r)throw A.e(A.aJ(a))}return!0},
bo(a,b){var s
for(s=0;s<a.length;++s)if(J.aG(a[s],b))return!0
return!1},
B(a){return A.j4(a,"[","]")},
gF(a){return new J.f8(a,a.length,A.br(a).m("f8<1>"))},
gG(a){return A.d9(a)},
gp(a){return a.length},
sp(a,b){a.$flags&1&&A.a(a,"set length","change the length of")
if(b<0)throw A.e(A.ad(b,0,null,"newLength",null))
if(b>a.length)A.br(a).c.a(null)
a.length=b},
n(a,b){if(!(b>=0&&b<a.length))throw A.e(A.mv(a,b))
return a[b]},
l(a,b,c){a.$flags&2&&A.a(a)
if(!(b>=0&&b<a.length))throw A.e(A.mv(a,b))
a[b]=c},
gao(a){return A.aQ(A.br(a))},
$iaa:1,
$iu:1,
$id:1,
$iA:1}
J.fU.prototype={
l8(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.he(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.j5.prototype={}
J.f8.prototype={
gJ(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a,p=q.length
if(r.b!==p)throw A.e(A.a5(q))
s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0}}
J.e8.prototype={
dR(a,b){var s
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.ge0(b)
if(this.ge0(a)===s)return 0
if(this.ge0(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
ge0(a){return a===0?1/a<0:a<0},
h(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.e(A.b8(""+a+".toInt()"))},
aZ(a){var s,r
if(a>=0){if(a<=2147483647){s=a|0
return a===s?s:s+1}}else if(a>=-2147483648)return a|0
r=Math.ceil(a)
if(isFinite(r))return r
throw A.e(A.b8(""+a+".ceil()"))},
bA(a){var s,r
if(a>=0){if(a<=2147483647)return a|0}else if(a>=-2147483648){s=a|0
return a===s?s:s-1}r=Math.floor(a)
if(isFinite(r))return r
throw A.e(A.b8(""+a+".floor()"))},
b7(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw A.e(A.b8(""+a+".round()"))},
I(a,b,c){if(this.dR(b,c)>0)throw A.e(A.cu(b))
if(this.dR(a,b)<0)return b
if(this.dR(a,c)>0)return c
return a},
d5(a,b){var s,r,q,p
if(b<2||b>36)throw A.e(A.ad(b,2,36,"radix",null))
s=a.toString(b)
if(s.charCodeAt(s.length-1)!==41)return s
r=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(r==null)A.X(A.b8("Unexpected toString result: "+s))
s=r[1]
q=+r[3]
p=r[2]
if(p!=null){s+=p
q-=p.length}return s+B.D.h7("0",q)},
B(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gG(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
a9(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
if(b<0)return s-b
else return s+b},
a5(a,b){if((a|0)===a)if(b>=1||b<-1)return a/b|0
return this.fg(a,b)},
V(a,b){return(a|0)===a?a/b|0:this.fg(a,b)},
fg(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.e(A.b8("Result of truncating division is "+A.x(s)+": "+A.x(a)+" ~/ "+b))},
Y(a,b){if(b<0)throw A.e(A.cu(b))
return b>31?0:a<<b>>>0},
M(a,b){return b>31?0:a<<b>>>0},
bn(a,b){var s
if(b<0)throw A.e(A.cu(b))
if(a>0)s=this.a0(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
j(a,b){var s
if(a>0)s=this.a0(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
U(a,b){if(0>b)throw A.e(A.cu(b))
return this.a0(a,b)},
a0(a,b){return b>31?0:a>>>b},
gao(a){return A.aQ(t.n)},
$iI:1,
$il:1}
J.e6.prototype={
aD(a,b){var s=this.Y(1,b-1)
return((a&s-1)>>>0)-((a&s)>>>0)},
gao(a){return A.aQ(t.p)},
$iM:1,
$ih:1}
J.fW.prototype={
gao(a){return A.aQ(t.V)},
$iM:1}
J.d0.prototype={
eh(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
fZ(a){var s,r,q,p=a.trim(),o=p.length
if(o===0)return p
if(p.charCodeAt(0)===133){s=J.pK(p,1)
if(s===o)return""}else s=0
r=o-1
q=p.charCodeAt(r)===133?J.pL(p,r):o
if(s===0&&q===o)return p
return p.substring(s,q)},
h7(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.e(B.bX)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
B(a){return a},
gG(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gao(a){return A.aQ(t.N)},
gp(a){return a.length},
$iaa:1,
$iM:1,
$ia4:1}
A.dE.prototype={
c_(a,b,c,d){var s=this.a.fN(null,b,c),r=new A.dF(s,$.H,this.$ti.m("dF<1,2>"))
s.d_(r.gj1())
r.d_(a)
r.d0(d)
return r},
fM(a){return this.c_(a,null,null,null)},
fN(a,b,c){return this.c_(a,b,c,null)}}
A.dF.prototype={
d_(a){this.c=a==null?null:a},
d0(a){var s=this
s.a.d0(a)
if(a==null)s.d=null
else if(t.k.b(a))s.d=s.b.d2(a)
else if(t.u.b(a))s.d=a
else throw A.e(A.aU(u.h,null))},
j2(a){var s,r,q,p,o,n=this,m=n.c
if(m==null)return
s=null
try{s=n.$ti.y[1].a(a)}catch(o){r=A.ar(o)
q=A.b4(o)
p=n.d
if(p==null)A.du(r,q)
else{m=n.b
if(t.k.b(p))m.fU(p,r,q)
else m.d3(t.u.a(p),r)}return}n.b.d3(m,s)}}
A.d3.prototype={
B(a){return"LateInitializationError: "+this.a}}
A.aV.prototype={
gp(a){return this.a.length},
n(a,b){return this.a.charCodeAt(b)}}
A.jN.prototype={}
A.u.prototype={}
A.aD.prototype={
gF(a){var s=this
return new A.d4(s,s.gp(s),A.j(s).m("d4<aD.E>"))},
bC(a,b,c){return new A.bg(this,b,A.j(this).m("@<aD.E>").aC(c).m("bg<1,2>"))},
be(a,b){return A.dg(this,b,null,A.j(this).m("aD.E"))}}
A.ez.prototype={
giA(){var s=J.bM(this.a),r=this.c
if(r==null||r>s)return s
return r},
gk0(){var s=J.bM(this.a),r=this.b
if(r>s)return s
return r},
gp(a){var s,r=J.bM(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
bq(a,b){var s=this,r=s.gk0()+b
if(b<0||r>=s.giA())throw A.e(A.iQ(b,s.gp(0),s,null,"index"))
return J.mO(s.a,r)},
be(a,b){var s,r,q=this
A.aM(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.bQ(q.$ti.m("bQ<1>"))
return A.dg(q.a,s,r,q.$ti.c)},
d4(a,b){var s,r,q,p=this,o=p.b,n=p.a,m=J.a3(n),l=m.gp(n),k=p.c
if(k!=null&&k<l)l=k
s=l-o
if(s<=0){n=J.lH(0,p.$ti.c)
return n}r=A.a0(s,m.bq(n,o),!1,p.$ti.c)
for(q=1;q<s;++q){r[q]=m.bq(n,o+q)
if(m.gp(n)<l)throw A.e(A.aJ(p))}return r}}
A.d4.prototype={
gJ(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a,p=J.a3(q),o=p.gp(q)
if(r.b!==o)throw A.e(A.aJ(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.bq(q,s);++r.c
return!0}}
A.bf.prototype={
gF(a){var s=this.a
return new A.h2(s.gF(s),this.b,A.j(this).m("h2<1,2>"))},
gp(a){var s=this.a
return s.gp(s)}}
A.bP.prototype={$iu:1}
A.h2.prototype={
E(){var s=this,r=s.b
if(r.E()){s.a=s.c.$1(r.gJ())
return!0}s.a=null
return!1},
gJ(){var s=this.a
return s==null?this.$ti.y[1].a(s):s}}
A.bg.prototype={
gp(a){return J.bM(this.a)},
bq(a,b){return this.b.$1(J.mO(this.a,b))}}
A.eH.prototype={
gF(a){return new A.hG(J.f6(this.a),this.b,this.$ti.m("hG<1>"))},
bC(a,b,c){return new A.bf(this,b,this.$ti.m("@<1>").aC(c).m("bf<1,2>"))}}
A.hG.prototype={
E(){var s,r
for(s=this.a,r=this.b;s.E();)if(r.$1(s.gJ()))return!0
return!1},
gJ(){return this.a.gJ()}}
A.bk.prototype={
be(a,b){A.i8(b,"count")
A.aM(b,"count")
return new A.bk(this.a,this.b+b,A.j(this).m("bk<1>"))},
gF(a){var s=this.a
return new A.hr(s.gF(s),this.b,A.j(this).m("hr<1>"))}}
A.cK.prototype={
gp(a){var s=this.a,r=s.gp(s)-this.b
if(r>=0)return r
return 0},
be(a,b){A.i8(b,"count")
A.aM(b,"count")
return new A.cK(this.a,this.b+b,this.$ti)},
$iu:1}
A.hr.prototype={
E(){var s,r
for(s=this.a,r=0;r<this.b;++r)s.E()
this.b=0
return s.E()},
gJ(){return this.a.gJ()}}
A.bQ.prototype={
gF(a){return B.bQ},
gp(a){return 0},
bC(a,b,c){return new A.bQ(c.m("bQ<0>"))},
be(a,b){A.aM(b,"count")
return this},
d4(a,b){var s=J.lH(0,this.$ti.c)
return s}}
A.fm.prototype={
E(){return!1},
gJ(){throw A.e(A.e4())}}
A.dO.prototype={}
A.hy.prototype={
l(a,b,c){throw A.e(A.b8("Cannot modify an unmodifiable list"))},
a_(a,b,c,d,e){throw A.e(A.b8("Cannot modify an unmodifiable list"))},
aK(a,b,c,d){return this.a_(0,b,c,d,0)},
an(a,b,c,d){throw A.e(A.b8("Cannot modify an unmodifiable list"))}}
A.dh.prototype={}
A.jS.prototype={}
A.cJ.prototype={
B(a){return A.lM(this)},
e1(a,b,c,d){var s=A.O(c,d)
this.bg(0,new A.ii(this,b,s))
return s},
$iay:1}
A.ii.prototype={
$2(a,b){var s=this.b.$2(a,b)
this.c.l(0,s.a,s.b)},
$S(){return A.j(this.a).m("~(1,2)")}}
A.dH.prototype={
gp(a){return this.b.length},
geZ(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
am(a){if(typeof a!="string")return!1
if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
n(a,b){if(!this.am(b))return null
return this.b[this.a[b]]},
bg(a,b){var s,r,q=this.geZ(),p=this.b
for(s=q.length,r=0;r<s;++r)b.$2(q[r],p[r])},
gbB(){return new A.eP(this.geZ(),this.$ti.m("eP<1>"))}}
A.eP.prototype={
gp(a){return this.a.length},
gF(a){var s=this.a
return new A.dq(s,s.length,this.$ti.m("dq<1>"))}}
A.dq.prototype={
gJ(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0}}
A.bU.prototype={
bU(){var s=this,r=s.$map
if(r==null){r=new A.c4(s.$ti.m("c4<1,2>"))
A.oq(s.a,r)
s.$map=r}return r},
n(a,b){return this.bU().n(0,b)},
bg(a,b){this.bU().bg(0,b)},
gbB(){var s=this.bU()
return new A.c5(s,A.j(s).m("c5<1>"))},
gp(a){return this.bU().a}}
A.dG.prototype={}
A.dP.prototype={
gp(a){return this.a.length},
gF(a){var s=this.a
return new A.dq(s,s.length,this.$ti.m("dq<1>"))},
bU(){var s,r,q,p,o=this,n=o.$map
if(n==null){n=new A.c4(o.$ti.m("c4<1,1>"))
for(s=o.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.a5)(s),++q){p=s[q]
n.l(0,p,p)}o.$map=n}return n},
bo(a,b){return this.bU().am(b)}}
A.iV.prototype={
hs(a){if(false)A.ox(0,0)},
O(a,b){if(b==null)return!1
return b instanceof A.e1&&this.a.O(0,b.a)&&A.mw(this)===A.mw(b)},
gG(a){return A.lN(this.a,A.mw(this),B.B,B.B)},
B(a){var s=B.k.kN([A.aQ(this.$ti.c)],", ")
return this.a.B(0)+" with "+("<"+s+">")}}
A.e1.prototype={
$1(a){return this.a.$1$1(a,this.$ti.y[0])},
$S(){return A.ox(A.i4(this.a),this.$ti)}}
A.eu.prototype={}
A.k4.prototype={
bk(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
if(p==null)return null
s=Object.create(null)
r=q.b
if(r!==-1)s.arguments=p[r+1]
r=q.c
if(r!==-1)s.argumentsExpr=p[r+1]
r=q.d
if(r!==-1)s.expr=p[r+1]
r=q.e
if(r!==-1)s.method=p[r+1]
r=q.f
if(r!==-1)s.receiver=p[r+1]
return s}}
A.em.prototype={
B(a){return"Null check operator used on a null value"}}
A.h_.prototype={
B(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.hx.prototype={
B(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.jj.prototype={
B(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.dJ.prototype={}
A.eW.prototype={
B(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$iaf:1}
A.bN.prototype={
B(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.oH(r==null?"unknown":r)+"'"},
gao(a){var s=A.i4(this)
return A.aQ(s==null?A.aR(this):s)},
glc(){return this},
$C:"$1",
$R:1,
$D:null}
A.ig.prototype={$C:"$0",$R:0}
A.ih.prototype={$C:"$2",$R:2}
A.jU.prototype={}
A.jP.prototype={
B(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.oH(s)+"'"}}
A.dD.prototype={
O(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.dD))return!1
return this.$_target===b.$_target&&this.a===b.a},
gG(a){return(A.i5(this.a)^A.d9(this.$_target))>>>0},
B(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.he(this.a)+"'")}}
A.hq.prototype={
B(a){return"RuntimeError: "+this.a}}
A.aY.prototype={
gp(a){return this.a},
gbB(){return new A.c5(this,A.j(this).m("c5<1>"))},
am(a){var s,r
if(typeof a=="string"){s=this.b
if(s==null)return!1
return s[a]!=null}else if(typeof a=="number"&&(a&0x3fffffff)===a){r=this.c
if(r==null)return!1
return r[a]!=null}else return this.kH(a)},
kH(a){var s=this.d
if(s==null)return!1
return this.ci(this.eO(s,a),a)>=0},
n(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.kI(b)},
kI(a){var s,r,q=this.d
if(q==null)return null
s=this.eO(q,a)
r=this.ci(s,a)
if(r<0)return null
return s[r].b},
l(a,b,c){var s,r,q=this
if(typeof b=="string"){s=q.b
q.em(s==null?q.b=q.dA():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=q.c
q.em(r==null?q.c=q.dA():r,b,c)}else q.kK(b,c)},
kK(a,b){var s,r,q,p=this,o=p.d
if(o==null)o=p.d=p.dA()
s=p.cW(a)
r=o[s]
if(r==null)o[s]=[p.dB(a,b)]
else{q=p.ci(r,a)
if(q>=0)r[q].b=b
else r.push(p.dB(a,b))}},
kZ(a,b){var s=this
if(typeof b=="string")return s.fa(s.b,b)
else if(typeof b=="number"&&(b&0x3fffffff)===b)return s.fa(s.c,b)
else return s.kJ(b)},
kJ(a){var s,r,q,p,o=this,n=o.d
if(n==null)return null
s=o.cW(a)
r=n[s]
q=o.ci(r,a)
if(q<0)return null
p=r.splice(q,1)[0]
o.fj(p)
if(r.length===0)delete n[s]
return p.b},
bg(a,b){var s=this,r=s.e,q=s.r
while(r!=null){b.$2(r.a,r.b)
if(q!==s.r)throw A.e(A.aJ(s))
r=r.c}},
em(a,b,c){var s=a[b]
if(s==null)a[b]=this.dB(b,c)
else s.b=c},
fa(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.fj(s)
delete a[b]
return s.b},
f_(){this.r=this.r+1&1073741823},
dB(a,b){var s,r=this,q=new A.jd(a,b)
if(r.e==null)r.e=r.f=q
else{s=r.f
s.toString
q.d=s
r.f=s.c=q}++r.a
r.f_()
return q},
fj(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.f_()},
cW(a){return J.av(a)&1073741823},
eO(a,b){return a[this.cW(b)]},
ci(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.aG(a[r].a,b))return r
return-1},
B(a){return A.lM(this)},
dA(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s}}
A.jd.prototype={}
A.c5.prototype={
gp(a){return this.a.a},
gF(a){var s=this.a
return new A.ab(s,s.r,s.e,this.$ti.m("ab<1>"))}}
A.ab.prototype={
gJ(){return this.d},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.e(A.aJ(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}}}
A.je.prototype={
gp(a){return this.a.a},
gF(a){var s=this.a
return new A.bz(s,s.r,s.e,this.$ti.m("bz<1>"))}}
A.bz.prototype={
gJ(){return this.d},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.e(A.aJ(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.b
r.c=s.c
return!0}}}
A.be.prototype={
gp(a){return this.a.a},
gF(a){var s=this.a
return new A.h0(s,s.r,s.e,this.$ti.m("h0<1,2>"))}}
A.h0.prototype={
gJ(){var s=this.d
s.toString
return s},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.e(A.aJ(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=new A.az(s.a,s.b,r.$ti.m("az<1,2>"))
r.c=s.c
return!0}}}
A.c4.prototype={
cW(a){return A.tG(a)&1073741823},
ci(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.aG(a[r].a,b))return r
return-1}}
A.lj.prototype={
$1(a){return this.a(a)},
$S:44}
A.lk.prototype={
$2(a,b){return this.a(a,b)},
$S:41}
A.ll.prototype={
$1(a){return this.a(a)},
$S:40}
A.kx.prototype={
jy(){var s=this.b
if(s===this)throw A.e(A.np(""))
return s}}
A.d5.prototype={
gao(a){return B.jZ},
cT(a,b,c){A.ap(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
fv(a){return this.cT(a,0,null)},
fs(a,b,c){A.ap(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
cS(a,b,c){A.ap(a,b,c)
c=B.a.V(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
ft(a){return this.cS(a,0,null)},
fp(a,b,c){A.ap(a,b,c)
c=B.a.V(a.byteLength-b,2)
return new Int16Array(a,b,c)},
fu(a,b,c){A.ap(a,b,c)
c=B.a.V(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
fq(a,b,c){A.ap(a,b,c)
c=B.a.V(a.byteLength-b,4)
return new Int32Array(a,b,c)},
fo(a,b,c){A.ap(a,b,c)
c=B.a.V(a.byteLength-b,4)
return new Float32Array(a,b,c)},
fn(a,b,c){var s
A.ap(a,b,c)
s=new DataView(a,b,c)
return s},
$iM:1,
$ifd:1}
A.eh.prototype={
gA(a){if(((a.$flags|0)&2)!==0)return new A.i0(a.buffer)
else return a.buffer},
iV(a,b,c,d){var s=A.ad(b,0,c,d,null)
throw A.e(s)},
ex(a,b,c,d){if(b>>>0!==b||b>c)this.iV(a,b,c,d)}}
A.i0.prototype={
cT(a,b,c){var s=A.q3(this.a,b,c)
s.$flags=3
return s},
fv(a){return this.cT(0,0,null)},
fs(a,b,c){var s=A.pY(this.a,b,c)
s.$flags=3
return s},
cS(a,b,c){var s=A.q_(this.a,b,c)
s.$flags=3
return s},
ft(a){return this.cS(0,0,null)},
fp(a,b,c){var s=A.pV(this.a,b,c)
s.$flags=3
return s},
fu(a,b,c){var s=A.q1(this.a,b,c)
s.$flags=3
return s},
fq(a,b,c){var s=A.pX(this.a,b,c)
s.$flags=3
return s},
fo(a,b,c){var s=A.pU(this.a,b,c)
s.$flags=3
return s},
fn(a,b,c){var s=A.pS(this.a,b,c)
s.$flags=3
return s},
$ifd:1}
A.h3.prototype={
gao(a){return B.k_},
$iM:1,
$ilz:1}
A.d6.prototype={
gp(a){return a.length},
jX(a,b,c,d,e){var s,r,q=a.length
this.ex(a,b,q,"start")
this.ex(a,c,q,"end")
if(b>c)throw A.e(A.ad(b,0,c,null,null))
s=c-b
if(e<0)throw A.e(A.aU(e,null))
r=d.length
if(r-e<s)throw A.e(A.jO("Not enough elements"))
if(e!==0||r!==s)d=d.subarray(e,e+s)
a.set(d,b)},
$iaa:1,
$iaC:1}
A.eg.prototype={
n(a,b){A.bs(b,a,a.length)
return a[b]},
l(a,b,c){a.$flags&2&&A.a(a)
A.bs(b,a,a.length)
a[b]=c},
a_(a,b,c,d,e){a.$flags&2&&A.a(a,5)
this.ej(a,b,c,d,e)},
aK(a,b,c,d){return this.a_(a,b,c,d,0)},
$iu:1,
$id:1,
$iA:1}
A.aE.prototype={
l(a,b,c){a.$flags&2&&A.a(a)
A.bs(b,a,a.length)
a[b]=c},
a_(a,b,c,d,e){a.$flags&2&&A.a(a,5)
if(t.bc.b(d)){this.jX(a,b,c,d,e)
return}this.ej(a,b,c,d,e)},
aK(a,b,c,d){return this.a_(a,b,c,d,0)},
$iu:1,
$id:1,
$iA:1}
A.eb.prototype={
gao(a){return B.k0},
$iM:1,
$iiw:1}
A.ec.prototype={
gao(a){return B.k1},
$iM:1,
$iix:1}
A.ed.prototype={
gao(a){return B.k2},
n(a,b){A.bs(b,a,a.length)
return a[b]},
bO(a,b,c){return new Int16Array(a.subarray(b,A.i2(b,c,a.length)))},
$iM:1,
$icZ:1}
A.ee.prototype={
gao(a){return B.k3},
n(a,b){A.bs(b,a,a.length)
return a[b]},
$iM:1,
$iiW:1}
A.ef.prototype={
gao(a){return B.k4},
n(a,b){A.bs(b,a,a.length)
return a[b]},
$iM:1,
$iiX:1}
A.ei.prototype={
gao(a){return B.k6},
n(a,b){A.bs(b,a,a.length)
return a[b]},
$iM:1,
$ihv:1}
A.ej.prototype={
gao(a){return B.k7},
n(a,b){A.bs(b,a,a.length)
return a[b]},
$iM:1,
$ibo:1}
A.ek.prototype={
gao(a){return B.k8},
gp(a){return a.length},
n(a,b){A.bs(b,a,a.length)
return a[b]},
$iM:1,
$ik6:1}
A.c7.prototype={
gao(a){return B.k9},
gp(a){return a.length},
n(a,b){A.bs(b,a,a.length)
return a[b]},
bO(a,b,c){return new Uint8Array(a.subarray(b,A.i2(b,c,a.length)))},
hb(a,b){return this.bO(a,b,null)},
$iM:1,
$ic7:1,
$ib2:1}
A.eR.prototype={}
A.eS.prototype={}
A.eT.prototype={}
A.eU.prototype={}
A.b0.prototype={
m(a){return A.l_(v.typeUniverse,this,a)},
aC(a){return A.ru(v.typeUniverse,this,a)}}
A.hP.prototype={}
A.i_.prototype={
B(a){return A.aF(this.a,null)}}
A.hN.prototype={
B(a){return this.a}}
A.eY.prototype={$ibm:1}
A.ks.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:10}
A.kr.prototype={
$1(a){var s,r
this.a.a=a
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:39}
A.kt.prototype={
$0(){this.a.$0()},
$S:12}
A.ku.prototype={
$0(){this.a.$0()},
$S:12}
A.kW.prototype={
hC(a,b){if(self.setTimeout!=null)self.setTimeout(A.f4(new A.kX(this,b),0),a)
else throw A.e(A.b8("`setTimeout()` not found."))}}
A.kX.prototype={
$0(){this.b.$0()},
$S:2}
A.hH.prototype={
cV(a){var s,r=this
if(a==null)a=r.$ti.c.a(a)
if(!r.b)r.a.cz(a)
else{s=r.a
if(r.$ti.m("bu<1>").b(a))s.ew(a)
else s.eC(a)}},
dS(a,b){var s=this.a
if(this.b)s.cC(new A.aI(a,b))
else s.df(new A.aI(a,b))}}
A.l5.prototype={
$1(a){return this.a.$2(0,a)},
$S:7}
A.l6.prototype={
$2(a,b){this.a.$2(1,new A.dJ(a,b))},
$S:28}
A.l9.prototype={
$2(a,b){this.a(a,b)},
$S:25}
A.aI.prototype={
B(a){return A.x(this.a)},
$iS:1,
gc4(){return this.b}}
A.bH.prototype={}
A.dl.prototype={
dC(){},
dD(){}}
A.hJ.prototype={
gdz(){return this.c<4},
jU(a){var s=a.CW,r=a.ch
if(s==null)this.d=r
else s.ch=r
if(r==null)this.e=s
else r.CW=s
a.CW=a
a.ch=a},
k5(a,b,c,d){var s,r,q,p,o,n,m,l,k=this
if((k.c&4)!==0){s=new A.eM($.H,A.j(k).m("eM<1>"))
A.oF(s.gj3())
if(c!=null)s.c=c
return s}s=$.H
r=d?1:0
q=b!=null?32:0
p=A.nN(s,a)
o=A.nO(s,b)
n=c==null?A.tE():c
m=new A.dl(k,p,o,n,s,r|q,A.j(k).m("dl<1>"))
m.CW=m
m.ch=m
m.ay=k.c&1
l=k.e
k.e=m
m.ch=null
m.CW=l
if(l==null)k.d=m
else l.ch=m
if(k.d===m)A.oh(k.a)
return m},
jT(a){var s,r=this
A.j(r).m("dl<1>").a(a)
if(a.ch===a)return null
s=a.ay
if((s&2)!==0)a.ay=s|4
else{r.jU(a)
if((r.c&2)===0&&r.d==null)r.hQ()}return null},
dc(){if((this.c&4)!==0)return new A.bE("Cannot add new events after calling close")
return new A.bE("Cannot add new events while doing an addStream")},
by(a,b){if(!this.gdz())throw A.e(this.dc())
this.dM(b)},
dQ(a,b){var s
if(!this.gdz())throw A.e(this.dc())
s=A.o7(a,b)
this.dO(s.a,s.b)},
kg(a){return this.dQ(a,null)},
bY(){var s,r,q=this
if((q.c&4)!==0){s=q.r
s.toString
return s}if(!q.gdz())throw A.e(q.dc())
q.c|=4
r=q.r
if(r==null)r=q.r=new A.R($.H,t.q)
q.dN()
return r},
hQ(){if((this.c&4)!==0){var s=this.r
if((s.a&30)===0)s.cz(null)}A.oh(this.b)}}
A.eI.prototype={
dM(a){var s,r
for(s=this.d,r=this.$ti.m("hL<1>");s!=null;s=s.ch)s.de(new A.hL(a,r))},
dO(a,b){var s
for(s=this.d;s!=null;s=s.ch)s.de(new A.kA(a,b))},
dN(){var s=this.d
if(s!=null)for(;s!=null;s=s.ch)s.de(B.bZ)
else this.r.cz(null)}}
A.hK.prototype={
dS(a,b){var s=this.a
if((s.a&30)!==0)throw A.e(A.jO("Future already completed"))
s.df(A.o7(a,b))},
fC(a){return this.dS(a,null)}}
A.cq.prototype={
cV(a){var s=this.a
if((s.a&30)!==0)throw A.e(A.jO("Future already completed"))
s.cz(a)},
kn(){return this.cV(null)}}
A.dm.prototype={
kO(a){if((this.c&15)!==6)return!0
return this.b.b.e7(this.d,a.a)},
kE(a){var s,r=this.e,q=null,p=a.a,o=this.b.b
if(t.Q.b(r))q=o.l2(r,p,a.b)
else q=o.e7(r,p)
try{p=q
return p}catch(s){if(t.eK.b(A.ar(s))){if((this.c&1)!==0)throw A.e(A.aU("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.e(A.aU("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.R.prototype={
fW(a,b,c){var s,r=$.H
if(r===B.p){if(!t.Q.b(b)&&!t.B.b(b))throw A.e(A.mR(b,"onError",u.c))}else b=A.ti(b,r)
s=new A.R(r,c.m("R<0>"))
this.dd(new A.dm(s,3,a,b,this.$ti.m("@<1>").aC(c).m("dm<1,2>")))
return s},
fh(a,b,c){var s=new A.R($.H,c.m("R<0>"))
this.dd(new A.dm(s,19,a,b,this.$ti.m("@<1>").aC(c).m("dm<1,2>")))
return s},
jW(a){this.a=this.a&1|16
this.c=a},
cB(a){this.a=a.a&30|this.a&1
this.c=a.c},
dd(a){var s=this,r=s.a
if(r<=3){a.a=s.c
s.c=a}else{if((r&4)!==0){r=s.c
if((r.a&24)===0){r.dd(a)
return}s.cB(r)}A.dv(null,null,s.b,new A.kD(s,a))}},
f4(a){var s,r,q,p,o,n=this,m={}
m.a=a
if(a==null)return
s=n.a
if(s<=3){r=n.c
n.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){s=n.c
if((s.a&24)===0){s.f4(a)
return}n.cB(s)}m.a=n.cO(a)
A.dv(null,null,n.b,new A.kH(m,n))}},
cc(){var s=this.c
this.c=null
return this.cO(s)},
cO(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
eC(a){var s=this,r=s.cc()
s.a=8
s.c=a
A.cr(s,r)},
hU(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.cc()
q.cB(a)
A.cr(q,r)},
cC(a){var s=this.cc()
this.jW(a)
A.cr(this,s)},
hT(a,b){this.cC(new A.aI(a,b))},
cz(a){if(this.$ti.m("bu<1>").b(a)){this.ew(a)
return}this.hF(a)},
hF(a){this.a^=2
A.dv(null,null,this.b,new A.kF(this,a))},
ew(a){A.m9(a,this,!1)
return},
df(a){this.a^=2
A.dv(null,null,this.b,new A.kE(this,a))},
$ibu:1}
A.kD.prototype={
$0(){A.cr(this.a,this.b)},
$S:2}
A.kH.prototype={
$0(){A.cr(this.b,this.a.a)},
$S:2}
A.kG.prototype={
$0(){A.m9(this.a.a,this.b,!0)},
$S:2}
A.kF.prototype={
$0(){this.a.eC(this.b)},
$S:2}
A.kE.prototype={
$0(){this.a.cC(this.b)},
$S:2}
A.kK.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.l0(q.d)}catch(p){s=A.ar(p)
r=A.b4(p)
if(k.c&&k.b.a.c.a===s){q=k.a
q.c=k.b.a.c}else{q=s
o=r
if(o==null)o=A.ly(q)
n=k.a
n.c=new A.aI(q,o)
q=n}q.b=!0
return}if(j instanceof A.R&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=j.c
q.b=!0}return}if(j instanceof A.R){m=k.b.a
l=new A.R(m.b,m.$ti)
j.fW(new A.kL(l,m),new A.kM(l),t.H)
q=k.a
q.c=l
q.b=!1}},
$S:2}
A.kL.prototype={
$1(a){this.a.hU(this.b)},
$S:10}
A.kM.prototype={
$2(a,b){this.a.cC(new A.aI(a,b))},
$S:23}
A.kJ.prototype={
$0(){var s,r,q,p,o,n
try{q=this.a
p=q.a
q.c=p.b.b.e7(p.d,this.b)}catch(o){s=A.ar(o)
r=A.b4(o)
q=s
p=r
if(p==null)p=A.ly(q)
n=this.a
n.c=new A.aI(q,p)
n.b=!0}},
$S:2}
A.kI.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=l.a.a.c
p=l.b
if(p.a.kO(s)&&p.a.e!=null){p.c=p.a.kE(s)
p.b=!1}}catch(o){r=A.ar(o)
q=A.b4(o)
p=l.a.a.c
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.ly(p)
m=l.b
m.c=new A.aI(p,n)
p=m}p.b=!0}},
$S:2}
A.hI.prototype={}
A.b1.prototype={
gp(a){var s={},r=new A.R($.H,t.fJ)
s.a=0
this.c_(new A.jQ(s,this),!0,new A.jR(s,r),r.ghS())
return r}}
A.jQ.prototype={
$1(a){++this.a.a},
$S(){return A.j(this.b).m("~(b1.T)")}}
A.jR.prototype={
$0(){var s=this.b,r=this.a.a,q=s.cc()
s.a=8
s.c=r
A.cr(s,q)},
$S:2}
A.eK.prototype={
gG(a){return(A.d9(this.a)^892482866)>>>0},
O(a,b){if(b==null)return!1
if(this===b)return!0
return b instanceof A.bH&&b.a===this.a}}
A.eL.prototype={
f2(){return this.w.jT(this)},
dC(){},
dD(){}}
A.eJ.prototype={
d_(a){this.a=A.nN(this.d,a)},
d0(a){var s=this,r=s.e
if(a==null)s.e=r&4294967263
else s.e=r|32
s.b=A.nO(s.d,a)},
ev(){var s,r=this,q=r.e|=8
if((q&128)!==0){s=r.r
if(s.a===1)s.a=3}if((q&64)===0)r.r=null
r.f=r.f2()},
dC(){},
dD(){},
f2(){return null},
de(a){var s,r,q=this,p=q.r
if(p==null)p=q.r=new A.hV(A.j(q).m("hV<1>"))
s=p.c
if(s==null)p.b=p.c=a
else{s.scj(a)
p.c=a}r=q.e
if((r&128)===0){r|=128
q.e=r
if(r<256)p.eb(q)}},
dM(a){var s=this,r=s.e
s.e=r|64
s.d.d3(s.a,a)
s.e&=4294967231
s.ey((r&4)!==0)},
dO(a,b){var s=this,r=s.e,q=new A.kw(s,a,b)
if((r&1)!==0){s.e=r|16
s.ev()
q.$0()}else{q.$0()
s.ey((r&4)!==0)}},
dN(){this.ev()
this.e|=16
new A.kv(this).$0()},
ey(a){var s,r,q=this,p=q.e
if((p&128)!==0&&q.r.c==null){p=q.e=p&4294967167
s=!1
if((p&4)!==0)if(p<256){s=q.r
s=s==null?null:s.c==null
s=s!==!1}if(s){p&=4294967291
q.e=p}}for(;;a=r){if((p&8)!==0){q.r=null
return}r=(p&4)!==0
if(a===r)break
q.e=p^64
if(r)q.dC()
else q.dD()
p=q.e&=4294967231}if((p&128)!==0&&p<256)q.r.eb(q)}}
A.kw.prototype={
$0(){var s,r,q=this.a,p=q.e
if((p&8)!==0&&(p&16)===0)return
q.e=p|64
s=q.b
p=this.b
r=q.d
if(t.k.b(s))r.fU(s,p,this.c)
else r.d3(s,p)
q.e&=4294967231},
$S:2}
A.kv.prototype={
$0(){var s=this.a,r=s.e
if((r&16)===0)return
s.e=r|74
s.d.e6(s.c)
s.e&=4294967231},
$S:2}
A.ds.prototype={
c_(a,b,c,d){return this.a.k5(a,d,c,b===!0)},
fM(a){return this.c_(a,null,null,null)},
fN(a,b,c){return this.c_(a,b,c,null)}}
A.hM.prototype={
gcj(){return this.a},
scj(a){return this.a=a}}
A.hL.prototype={
e3(a){a.dM(this.b)}}
A.kA.prototype={
e3(a){a.dO(this.b,this.c)}}
A.kz.prototype={
e3(a){a.dN()},
gcj(){return null},
scj(a){throw A.e(A.jO("No events after a done."))}}
A.hV.prototype={
eb(a){var s=this,r=s.a
if(r===1)return
if(r>=1){s.a=1
return}A.oF(new A.kT(s,a))
s.a=1}}
A.kT.prototype={
$0(){var s,r,q=this.a,p=q.a
q.a=0
if(p===3)return
s=q.b
r=s.gcj()
q.b=r
if(r==null)q.c=null
s.e3(this.b)},
$S:2}
A.eM.prototype={
d_(a){},
d0(a){},
j4(){var s,r=this,q=r.a-1
if(q===0){r.a=-1
s=r.c
if(s!=null){r.c=null
r.b.e6(s)}}else r.a=q}}
A.hY.prototype={}
A.l3.prototype={}
A.kU.prototype={
e6(a){var s,r,q
try{if(B.p===$.H){a.$0()
return}A.od(null,null,this,a)}catch(q){s=A.ar(q)
r=A.b4(q)
A.du(s,r)}},
l6(a,b){var s,r,q
try{if(B.p===$.H){a.$1(b)
return}A.of(null,null,this,a,b)}catch(q){s=A.ar(q)
r=A.b4(q)
A.du(s,r)}},
d3(a,b){return this.l6(a,b,t.z)},
l4(a,b,c){var s,r,q
try{if(B.p===$.H){a.$2(b,c)
return}A.oe(null,null,this,a,b,c)}catch(q){s=A.ar(q)
r=A.b4(q)
A.du(s,r)}},
fU(a,b,c){var s=t.z
return this.l4(a,b,c,s,s)},
fw(a){return new A.kV(this,a)},
l1(a){if($.H===B.p)return a.$0()
return A.od(null,null,this,a)},
l0(a){return this.l1(a,t.z)},
l5(a,b){if($.H===B.p)return a.$1(b)
return A.of(null,null,this,a,b)},
e7(a,b){var s=t.z
return this.l5(a,b,s,s)},
l3(a,b,c){if($.H===B.p)return a.$2(b,c)
return A.oe(null,null,this,a,b,c)},
l2(a,b,c){var s=t.z
return this.l3(a,b,c,s,s,s)},
kY(a){return a},
d2(a){var s=t.z
return this.kY(a,s,s,s)}}
A.kV.prototype={
$0(){return this.a.e6(this.b)},
$S:2}
A.l8.prototype={
$0(){A.pm(this.a,this.b)},
$S:2}
A.eN.prototype={
gp(a){return this.a},
gbB(){return new A.eO(this,this.$ti.m("eO<1>"))},
am(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.hX(a)},
hX(a){var s=this.d
if(s==null)return!1
return this.c6(this.eB(s,a),a)>=0},
n(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.nR(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.nR(q,b)
return r}else return this.hR(b)},
hR(a){var s,r,q=this.d
if(q==null)return null
s=this.eB(q,a)
r=this.c6(s,a)
return r<0?null:s[r+1]},
l(a,b,c){var s,r,q,p,o,n,m=this
if(typeof b=="string"&&b!=="__proto__"){s=m.b
m.eA(s==null?m.b=A.ma():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=m.c
m.eA(r==null?m.c=A.ma():r,b,c)}else{q=m.d
if(q==null)q=m.d=A.ma()
p=A.i5(b)&1073741823
o=q[p]
if(o==null){A.mb(q,p,[b,c]);++m.a
m.e=null}else{n=m.c6(o,b)
if(n>=0)o[n+1]=c
else{o.push(b,c);++m.a
m.e=null}}}},
bg(a,b){var s,r,q,p,o,n=this,m=n.eD()
for(s=m.length,r=n.$ti.y[1],q=0;q<s;++q){p=m[q]
o=n.n(0,p)
b.$2(p,o==null?r.a(o):o)
if(m!==n.e)throw A.e(A.aJ(n))}},
eD(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.a0(i.a,null,!1,t.z)
s=i.b
r=0
if(s!=null){q=Object.getOwnPropertyNames(s)
p=q.length
for(o=0;o<p;++o){h[r]=q[o];++r}}n=i.c
if(n!=null){q=Object.getOwnPropertyNames(n)
p=q.length
for(o=0;o<p;++o){h[r]=+q[o];++r}}m=i.d
if(m!=null){q=Object.getOwnPropertyNames(m)
p=q.length
for(o=0;o<p;++o){l=m[q[o]]
k=l.length
for(j=0;j<k;j+=2){h[r]=l[j];++r}}}return i.e=h},
eA(a,b,c){if(a[b]==null){++this.a
this.e=null}A.mb(a,b,c)},
eB(a,b){return a[A.i5(b)&1073741823]}}
A.dn.prototype={
c6(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.eO.prototype={
gp(a){return this.a.a},
gF(a){var s=this.a
return new A.hQ(s,s.eD(),this.$ti.m("hQ<1>"))}}
A.hQ.prototype={
gJ(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.e(A.aJ(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}}}
A.eQ.prototype={
gF(a){var s=this,r=new A.hT(s,s.r,A.j(s).m("hT<1>"))
r.c=s.e
return r},
gp(a){return this.a},
by(a,b){var s,r,q=this
if(typeof b=="string"&&b!=="__proto__"){s=q.b
return q.ez(s==null?q.b=A.mc():s,b)}else if(typeof b=="number"&&(b&1073741823)===b){r=q.c
return q.ez(r==null?q.c=A.mc():r,b)}else return q.hD(b)},
hD(a){var s,r,q=this,p=q.d
if(p==null)p=q.d=A.mc()
s=q.hW(a)
r=p[s]
if(r==null)p[s]=[q.di(a)]
else{if(q.c6(r,a)>=0)return!1
r.push(q.di(a))}return!0},
ez(a,b){if(a[b]!=null)return!1
a[b]=this.di(b)
return!0},
di(a){var s=this,r=new A.kR(a)
if(s.e==null)s.e=s.f=r
else s.f=s.f.b=r;++s.a
s.r=s.r+1&1073741823
return r},
hW(a){return J.av(a)&1073741823},
c6(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.aG(a[r].a,b))return r
return-1}}
A.kR.prototype={}
A.hT.prototype={
gJ(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.c,q=s.a
if(s.b!==q.r)throw A.e(A.aJ(q))
else if(r==null){s.d=null
return!1}else{s.d=r.a
s.c=r.b
return!0}}}
A.jf.prototype={
$2(a,b){this.a.l(0,this.b.a(a),this.c.a(b))},
$S:19}
A.E.prototype={
gF(a){return new A.d4(a,this.gp(a),A.aR(a).m("d4<E.E>"))},
bq(a,b){return this.n(a,b)},
gac(a){return this.gp(a)===0},
gfF(a){if(this.gp(a)===0)throw A.e(A.e4())
return this.n(a,0)},
gcX(a){if(this.gp(a)===0)throw A.e(A.e4())
return this.n(a,this.gp(a)-1)},
bo(a,b){var s,r=this.gp(a)
for(s=0;s<r;++s){if(J.aG(this.n(a,s),b))return!0
if(r!==this.gp(a))throw A.e(A.aJ(a))}return!1},
bC(a,b,c){return new A.bg(a,b,A.aR(a).m("@<E.E>").aC(c).m("bg<1,2>"))},
be(a,b){return A.dg(a,b,null,A.aR(a).m("E.E"))},
fV(a,b){return A.dg(a,0,A.f3(b,"count",t.p),A.aR(a).m("E.E"))},
bO(a,b,c){var s,r=this.gp(a)
A.cl(b,c,r)
s=A.p(this.h6(a,b,c),A.aR(a).m("E.E"))
return s},
h6(a,b,c){A.cl(b,c,this.gp(a))
return A.dg(a,b,c,A.aR(a).m("E.E"))},
an(a,b,c,d){var s
A.cl(b,c,this.gp(a))
for(s=b;s<c;++s)this.l(a,s,d)},
a_(a,b,c,d,e){var s,r,q,p,o
A.cl(b,c,this.gp(a))
s=c-b
if(s===0)return
A.aM(e,"skipCount")
if(t.j.b(d)){r=e
q=d}else{q=J.lw(d,e).d4(0,!1)
r=0}p=J.a3(q)
if(r+s>p.gp(q))throw A.e(A.nk())
if(r<b)for(o=s-1;o>=0;--o)this.l(a,b+o,p.n(q,r+o))
else for(o=0;o<s;++o)this.l(a,b+o,p.n(q,r+o))},
aK(a,b,c,d){return this.a_(a,b,c,d,0)},
ec(a,b,c){this.aK(a,b,b+c.length,c)},
B(a){return A.j4(a,"[","]")},
$iu:1,
$id:1,
$iA:1}
A.bA.prototype={
bg(a,b){var s,r,q,p
for(s=this.gbB(),s=s.gF(s),r=A.j(this).y[1];s.E();){q=s.gJ()
p=this.n(0,q)
b.$2(q,p==null?r.a(p):p)}},
e1(a,b,c,d){var s,r,q,p,o,n=A.O(c,d)
for(s=this.gbB(),s=s.gF(s),r=A.j(this).y[1];s.E();){q=s.gJ()
p=this.n(0,q)
o=b.$2(q,p==null?r.a(p):p)
n.l(0,o.a,o.b)}return n},
gp(a){var s=this.gbB()
return s.gp(s)},
B(a){return A.lM(this)},
$iay:1}
A.jh.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.x(a)
r.a=(r.a+=s)+": "
s=A.x(b)
r.a+=s},
$S:17}
A.ea.prototype={
gF(a){var s=this
return new A.hU(s,s.c,s.d,s.b,s.$ti.m("hU<1>"))},
gac(a){return this.b===this.c},
gp(a){return(this.c-this.b&this.a.length-1)>>>0},
bq(a,b){var s=this,r=s.gp(0)
if(0>b||b>=r)A.X(A.iQ(b,r,s,null,"index"))
r=s.a
r=r[(s.b+b&r.length-1)>>>0]
return r==null?s.$ti.c.a(r):r},
dP(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this
if(t.j.b(b)){s=b.length
r=h.gp(0)
q=r+s
p=h.a
o=p.length
if(q>=o){n=A.a0(A.pQ(q+(q>>>1)),null,!1,h.$ti.m("1?"))
h.c=h.kf(n)
h.a=n
h.b=0
B.k.a_(n,r,q,b,0)
h.c+=s}else{q=h.c
m=o-q
if(s<m){B.k.a_(p,q,q+s,b,0)
h.c+=s}else{l=s-m
B.k.a_(p,q,q+m,b,0)
B.k.a_(h.a,0,l,b,m)
h.c=l}}++h.d}else for(q=J.f6(b),p=h.$ti.m("1?");q.E();){k=q.gJ()
o=h.a
j=h.c
o[j]=k
o=o.length
j=(j+1&o-1)>>>0
h.c=j
if(h.b===j){n=A.a0(o*2,null,!1,p)
o=h.a
j=h.b
i=o.length-j
B.k.a_(n,0,i,o,j)
B.k.a_(n,i,i+h.b,h.a,0)
h.b=0
h.c=h.a.length
h.a=n}++h.d}},
B(a){return A.j4(this,"{","}")},
fT(){var s,r,q=this,p=q.b
if(p===q.c)throw A.e(A.e4());++q.d
s=q.a
r=s[p]
if(r==null)r=q.$ti.c.a(r)
s[p]=null
q.b=(p+1&s.length-1)>>>0
return r},
kf(a){var s,r,q=this,p=q.b,o=q.c,n=q.a
if(p<=o){s=o-p
B.k.a_(a,0,s,n,p)
return s}else{r=n.length-p
B.k.a_(a,0,r,n,p)
B.k.a_(a,r,r+q.c,q.a,0)
return q.c+r}}}
A.hU.prototype={
gJ(){var s=this.e
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a
if(r.c!==q.d)A.X(A.aJ(q))
s=r.d
if(s===r.b){r.e=null
return!1}q=q.a
r.e=q[s]
r.d=(s+1&q.length-1)>>>0
return!0}}
A.bD.prototype={
bC(a,b,c){return new A.bP(this,b,A.j(this).m("@<1>").aC(c).m("bP<1,2>"))},
B(a){return A.j4(this,"{","}")},
be(a,b){return A.nE(this,b,A.j(this).c)},
$iu:1,
$id:1,
$iev:1}
A.eV.prototype={}
A.l1.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:15}
A.l0.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:15}
A.kY.prototype={
dU(a){var s,r,q=A.cl(0,null,a.length)
for(s=0;s<q;++s){r=a[s]
if((r&4294967040)!==0){if(!this.a)throw A.e(A.lD("Invalid value in input: "+r,null,null))
return this.hY(a,0,q)}}return A.ey(a,0,q)},
hY(a,b,c){var s,r,q
for(s=b,r="";s<c;++s){q=a[s]
r+=A.da((q&4294967040)!==0?65533:q)}return r.charCodeAt(0)==0?r:r}}
A.ff.prototype={}
A.fj.prototype={}
A.il.prototype={}
A.jb.prototype={
bZ(a){var s=B.cr.dU(a)
return s}}
A.jc.prototype={}
A.k7.prototype={
kp(a,b){return(b===!0?B.kb:B.ka).dU(a)}}
A.hz.prototype={
dU(a){return new A.i1(this.a).eE(a,0,null,!0)}}
A.i1.prototype={
eE(a,b,c,d){var s,r,q,p,o,n,m=this,l=A.cl(b,c,a.length)
if(b===l)return""
if(a instanceof Uint8Array){s=a
r=s
q=0}else{r=A.ry(a,b,l)
l-=b
q=b
b=0}if(l-b>=15){p=m.a
o=A.rx(p,r,b,l)
if(o!=null){if(!p)return o
if(o.indexOf("\ufffd")<0)return o}}o=m.dl(r,b,l,!0)
p=m.b
if((p&1)!==0){n=A.rz(p)
m.b=0
throw A.e(A.lD(n,a,q+m.c))}return o},
dl(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.a.V(b+c,2)
r=q.dl(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.dl(a,s,c,d)}return q.ku(a,b,c,d)},
ku(a,b,c,d){var s,r,q,p,o,n,m,l=this,k=65533,j=l.b,i=l.c,h=new A.ex(""),g=b+1,f=a[b]
A:for(s=l.a;;){for(;;g=p){r="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE".charCodeAt(f)&31
i=j<=32?f&61694>>>r:(f&63|i<<6)>>>0
j=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA".charCodeAt(j+r)
if(j===0){q=A.da(i)
h.a+=q
if(g===c)break A
break}else if((j&1)!==0){if(s)switch(j){case 69:case 67:q=A.da(k)
h.a+=q
break
case 65:q=A.da(k)
h.a+=q;--g
break
default:q=A.da(k)
h.a=(h.a+=q)+q
break}else{l.b=j
l.c=g-1
return""}j=0}if(g===c)break A
p=g+1
f=a[g]}p=g+1
f=a[g]
if(f<128){for(;;){if(!(p<c)){o=c
break}n=p+1
f=a[p]
if(f>=128){o=n-1
p=n
break}p=n}if(o-g<20)for(m=g;m<o;++m){q=A.da(a[m])
h.a+=q}else{q=A.ey(a,g,o)
h.a+=q}if(o===c)break A
g=p}else g=p}if(d&&j>32)if(s){s=A.da(k)
h.a+=s}else{l.b=77
l.c=c
return""}l.b=j
l.c=i
s=h.a
return s.charCodeAt(0)==0?s:s}}
A.fk.prototype={
O(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.fk)if(this.a===b.a)s=this.b===b.b
return s},
gG(a){return A.lN(this.a,this.b,B.B,B.B)},
B(a){var s=this,r=A.pk(A.qb(s)),q=A.fl(A.q9(s)),p=A.fl(A.q5(s)),o=A.fl(A.q6(s)),n=A.fl(A.q8(s)),m=A.fl(A.qa(s)),l=A.n0(A.q7(s)),k=s.b,j=k===0?"":A.n0(k)
return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"}}
A.kB.prototype={
B(a){return this.a6()}}
A.S.prototype={
gc4(){return A.q4(this)}}
A.f9.prototype={
B(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.im(s)
return"Assertion failed"}}
A.bm.prototype={}
A.aT.prototype={
gdq(){return"Invalid argument"+(!this.a?"(s)":"")},
gdn(){return""},
B(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.x(p),n=s.gdq()+q+o
if(!s.a)return n
return n+s.gdn()+": "+A.im(s.ge_())},
ge_(){return this.b}}
A.bj.prototype={
ge_(){return this.b},
gdq(){return"RangeError"},
gdn(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.x(q):""
else if(q==null)s=": Not greater than or equal to "+A.x(r)
else if(q>r)s=": Not in inclusive range "+A.x(r)+".."+A.x(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.x(r)
return s}}
A.fE.prototype={
ge_(){return this.b},
gdq(){return"RangeError"},
gdn(){if(this.b<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
$ibj:1,
gp(a){return this.f}}
A.eC.prototype={
B(a){return"Unsupported operation: "+this.a}}
A.hw.prototype={
B(a){return"UnimplementedError: "+this.a}}
A.bE.prototype={
B(a){return"Bad state: "+this.a}}
A.fi.prototype={
B(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.im(s)+"."}}
A.h4.prototype={
B(a){return"Out of Memory"},
gc4(){return null},
$iS:1}
A.ew.prototype={
B(a){return"Stack Overflow"},
gc4(){return null},
$iS:1}
A.kC.prototype={
B(a){return"Exception: "+this.a}}
A.ba.prototype={
B(a){var s=this.a,r=""!==s?"FormatException: "+s:"FormatException",q=this.c
return q!=null?r+(" (at offset "+A.x(q)+")"):r}}
A.d.prototype={
bC(a,b,c){return A.pR(this,b,A.j(this).m("d.E"),c)},
d4(a,b){var s=A.j(this).m("d.E")
if(b)s=A.p(this,s)
else{s=A.p(this,s)
s.$flags=1
s=s}return s},
gp(a){var s,r=this.gF(this)
for(s=0;r.E();)++s
return s},
be(a,b){return A.nE(this,b,A.j(this).m("d.E"))},
bq(a,b){var s,r
A.aM(b,"index")
s=this.gF(this)
for(r=b;s.E();){if(r===0)return s.gJ();--r}throw A.e(A.iQ(b,b-r,this,null,"index"))},
B(a){return A.pJ(this,"(",")")}}
A.az.prototype={
B(a){return"MapEntry("+A.x(this.a)+": "+A.x(this.b)+")"}}
A.ac.prototype={
gG(a){return A.n.prototype.gG.call(this,0)},
B(a){return"null"}}
A.n.prototype={$in:1,
O(a,b){return this===b},
gG(a){return A.d9(this)},
B(a){return"Instance of '"+A.he(this)+"'"},
gao(a){return A.dz(this)},
toString(){return this.B(this)}}
A.eX.prototype={
B(a){return this.a},
$iaf:1}
A.ex.prototype={
gp(a){return this.a.length},
B(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.fo.prototype={
B(a){return"Expando:null"}}
A.ji.prototype={
B(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.lp.prototype={
$1(a){var s,r,q,p
if(A.oc(a))return a
s=this.a
if(s.am(a))return s.n(0,a)
if(t.O.b(a)){r={}
s.l(0,a,r)
for(s=a.gbB(),s=s.gF(s);s.E();){q=s.gJ()
r[q]=this.$1(a.n(0,q))}return r}else if(t.Y.b(a)){p=[]
s.l(0,a,p)
B.k.dP(p,J.mQ(a,this,t.z))
return p}else return a},
$S:16}
A.lr.prototype={
$1(a){return this.a.cV(a)},
$S:7}
A.ls.prototype={
$1(a){if(a==null)return this.a.fC(new A.ji(a===undefined))
return this.a.fC(a)},
$S:7}
A.ld.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h
if(A.ob(a))return a
s=this.a
a.toString
if(s.am(a))return s.n(0,a)
if(a instanceof Date){r=a.getTime()
if(r<-864e13||r>864e13)A.X(A.ad(r,-864e13,864e13,"millisecondsSinceEpoch",null))
A.f3(!0,"isUtc",t.y)
return new A.fk(r,0,!0)}if(a instanceof RegExp)throw A.e(A.aU("structured clone of RegExp",null))
if(a instanceof Promise)return A.u2(a,t.X)
q=Object.getPrototypeOf(a)
if(q===Object.prototype||q===null){p=t.X
o=A.O(p,p)
s.l(0,a,o)
n=Object.keys(a)
m=[]
for(s=J.aB(n),p=s.gF(n);p.E();)m.push(A.mu(p.gJ()))
for(l=0;l<s.gp(n);++l){k=s.n(n,l)
j=m[l]
if(k!=null)o.l(0,j,this.$1(a[k]))}return o}if(a instanceof Array){i=a
o=[]
s.l(0,a,o)
h=a.length
for(s=J.aB(i),l=0;l<h;++l)o.push(this.$1(s.n(i,l)))
return o}return a},
$S:16}
A.iC.prototype={
hi(a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=a0.length
for(s=0;s<a;++s){r=a0[s]
if(r>b.b)b.b=r
if(r<b.c)b.c=r}r=b.b
if(r>15)throw A.e(B.ce)
q=new Uint16Array(r+1)
for(p=a0.length,o=0;o<p;++o){n=a0[o]
if(n!==0)q[n]=q[n]+1}for(m=1,l=1;l<=r;++l){m=(m<<1>>>0)-q[l]
if(m<0)throw A.e(B.cg)}if(m>0)p=r>(a1?0:1)
else p=!1
if(p)throw A.e(B.cf)
k=B.a.Y(1,r)
r=new Uint32Array(k)
b.a=r
for(p=b.b,j=1,i=0,h=2;j<=p;){for(g=j<<16,s=0;s<a;++s)if(a0[s]===j){for(f=i,e=0,d=0;d<j;++d){e=(e<<1|f&1)>>>0
f=f>>>1}for(c=(g|s)>>>0,d=e;d<k;d+=h)r[d]=c;++i}++j
i=i<<1>>>0
h=h<<1>>>0}}}
A.e0.prototype={
a6(){return"InflateFormat."+this.b}}
A.fF.prototype={
gkF(){var s,r=this.x
if(r==null)return 32768
s=r.e+r.f-this.y
return s>32768?s:32768},
kt(a){var s,r,q,p,o,n,m,l,k=this,j="Truncated zlib stream"
switch(k.w.a){case 0:s=k.a
r=s.c
q=s.d
q===$&&A.b()
if(r>=q){if(k.e===0&&k.b!==B.ck)throw A.e(A.aH("Empty input is not a "+k.b.b+" stream"))
k.w=B.bE
return!1}if(k.b===B.ad)if(!k.jA()){if(k.e!==0)throw A.e(A.aH("Data after the last gzip member"))
s.c=r
k.b=B.O}if(k.b===B.O){if(s.gp(0)<2)A.X(A.aH(j))
p=s.D()
o=s.D()
if((p&15)!==8)A.X(A.aH("Only deflate compression is supported"))
if(B.a.a9(p*256+o,31)!==0)A.X(A.aH("Invalid zlib header"))
if((o&32)!==0)A.X(A.aH("zlib preset dictionaries are not supported"))}k.f=a.e+a.f
k.r=k.b===B.O?1:0
k.d=new A.iR(s,a)
k.w=B.kf
return!0
case 1:if(!k.d.kG())k.w=B.kg
k.x=null
return!0
case 2:s=k.b
if(s===B.ad){s=k.a
if(s.gp(0)<8)throw A.e(A.aH("Truncated gzip stream"))
s.i()
n=s.i()
if(B.a.a9(a.e+a.f-k.f,4294967296)!==n)throw A.e(A.aH("gzip member length does not match"))}else if(s===B.O){s=k.a
if(s.gp(0)<4)throw A.e(A.aH(j))
for(m=0,l=0;l<4;++l){r=s.b
r.toString
m=m<<8|r[s.c++]}}++k.e
s=k.b===B.ad
k.w=s?B.aw:B.bE
return s
case 3:return!1}},
jA(){var s,r,q=this.a
if(q.gp(0)<10)return!1
if(q.k()!==35615)return!1
if(q.D()!==8)return!1
s=q.D()
q.i()
q.D()
q.D()
if((s&4)!==0){if(q.gp(0)<2)return!1
r=q.k()
if(q.gp(0)<r)return!1
q.be(0,r)}if((s&8)!==0&&!this.fd())return!1
if((s&16)!==0&&!this.fd())return!1
if((s&2)!==0){if(q.gp(0)<2)return!1
q.k()}return!0},
fd(){var s,r,q=this.a
for(;;){s=q.c
r=q.d
r===$&&A.b()
if(!(s<r))break
r=q.b
r.toString
q.c=s+1
if(r[s]===0)return!0}return!1}}
A.dr.prototype={
a6(){return"_State."+this.b}}
A.iR.prototype={
kG(){var s,r="Invalid deflate data",q=null
try{q=this.j5()}catch(s){if(t.fL.b(A.ar(s)))throw A.e(A.aH(r))
else throw s}if(!q&&!this.f)throw A.e(A.aH(r))
return q},
gbv(){var s=this.a
if(s==null)return s
s.d===$&&A.b()
return s},
j5(){var s,r,q,p=this,o=p.gbv()
if(o!=null){s=o.c
r=o.d
r===$&&A.b()
r=s>=r
s=r}else s=!0
if(s)return!1
q=p.b2(3)
s=(q&1)===0
switch(B.a.j(q,1)){case 0:if(p.jf()===-1)return!1
break
case 1:if(p.eI($.oK(),$.oJ())===-1)return!1
break
case 2:if(p.j6()===-1)return!1
break
default:return!1}if(!s)p.f=!0
return s},
b2(a){var s,r,q,p,o=this
if(a===0)return 0
while(s=o.w,s<a){s=o.gbv()
r=s.c
s=s.d
s===$&&A.b()
if(r>=s)return-1
s=o.gbv()
r=s.b
r.toString
q=r[s.c++]
s=o.r
r=o.w
o.r=(s|B.a.Y(q,r))>>>0
o.w=r+8}r=o.r
p=B.a.M(1,a)
o.r=B.a.a0(r,a)
o.w=s-a
return(r&p-1)>>>0},
dH(a){var s,r,q,p,o,n,m=this,l=a.a
l===$&&A.b()
s=a.b
while(m.w<s){r=m.gbv()
q=r.c
r=r.d
r===$&&A.b()
if(q>=r)break
r=m.gbv()
q=r.b
q.toString
p=q[r.c++]
r=m.r
q=m.w
m.r=(r|B.a.Y(p,q))>>>0
m.w=q+8}r=m.r
o=l[(r&B.a.Y(1,s)-1)>>>0]
n=o>>>16
if(n===0||n>m.w)return-1
m.r=B.a.a0(r,n)
m.w-=n
return o&65535},
jf(){var s,r=this
r.w=r.r=0
s=r.b2(16)
if(s!==(r.b2(16)^65535)>>>0)return-1
if(s>r.gbv().gp(0))return-1
r.c.h1(r.gbv().a1(s))
return 0},
j6(){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.b2(5)
if(f===-1)return-1
f+=257
if(f>286)return-1
s=g.b2(5)
if(s===-1)return-1;++s
if(s>32)return-1
r=g.b2(4)
if(r===-1)return-1
r+=4
if(r>19)return-1
q=new Uint8Array(19)
for(p=0;p<r;++p){o=g.b2(3)
if(o===-1)return-1
q[B.ia[p]]=o}n=g.ff(q,!0)
if(n==null)return-1
m=f+s
l=new Uint8Array(m)
k=J.aj(B.c.gA(l),0,f)
j=J.aj(B.c.gA(l),f,s)
if(g.iT(m,n,l)===-1)return-1
i=g.fe(k)
m=i==null
h=m?null:g.fe(j)
if(m||h==null)return-1
return g.eI(i,h)},
ff(a,b){var s,r
try{s=A.lF(a,b)
return s}catch(r){if(A.ar(r) instanceof A.ba)return null
else throw r}},
fe(a){return this.ff(a,!1)},
eI(a,b){var s,r,q,p,o,n,m,l,k,j=this
for(s=j.c;;){r=j.dH(a)
if(r<0||r>285)return-1
if(r===256)break
if(r<256){s.aU(r&255)
continue}q=r-257
p=j.b2(B.ja[q])
if(p<0)return-1
o=B.it[q]
n=j.dH(b)
if(n<0||n>29)return-1
m=j.b2(B.eA[n])
if(m<0)return-1
l=B.iy[n]+m
if(l<1||l>s.gp(s))return-1
s.h_(l,o+p)}while(s=j.w,s>=8){j.w=s-8
s=j.gbv()
o=s.c
if(1>=o)s.c=0
else{k=s.d
k===$&&A.b()
if(1<=o-k)s.c=k
else s.c=o-1}}return 0},
iT(a,b,c){var s,r,q,p,o,n,m,l,k=this
for(s=c.$flags|0,r=0,q=0;q<a;){p=k.dH(b)
if(p===-1)return-1
o=0
switch(p){case 16:if(q===0)return-1
n=k.b2(2)
if(n===-1)return-1
n+=3
if(q+n>a)return-1
for(;m=n-1,n>0;n=m,q=l){l=q+1
s&2&&A.a(c)
c[q]=r}break
case 17:n=k.b2(3)
if(n===-1)return-1
n+=3
if(q+n>a)return-1
for(;m=n-1,n>0;n=m,q=l){l=q+1
s&2&&A.a(c)
c[q]=0}r=o
break
case 18:n=k.b2(7)
if(n===-1)return-1
n+=11
if(q+n>a)return-1
for(;m=n-1,n>0;n=m,q=l){l=q+1
s&2&&A.a(c)
c[q]=0}r=o
break
default:if(p<0||p>15)return-1
l=q+1
s&2&&A.a(c)
c[q]=p
q=l
r=p
break}}return 0}}
A.f7.prototype={}
A.fe.prototype={
a6(){return"ByteOrder."+this.b}}
A.fG.prototype={
ge4(){return this.e},
ed(a){return this.e=a},
gp(a){var s=this,r=s.d
if(r!=null)return Math.max(0,r-s.e)
return s.b.fS(s.c+s.e)},
gkM(){var s,r,q=this,p=q.d
if(p!=null&&q.e>=p)return!0
s=q.b
r=q.c+q.e
s.cG(r,1)
return r>=s.e+s.f},
fA(){if(this.c===0&&this.d==null){var s=this.b
s.d=new Uint8Array(0)
s.e=s.e+s.f
s.f=0
s.w=!0}},
ei(a,b){var s=this.d
if(s!=null)a=Math.min(a,Math.max(0,s-b))
return A.ni(this,b,a)},
D(){var s,r=this
if(r.gkM())return 0
s=r.b.kj(r.c+r.e);++r.e
return s},
a1(a){var s,r,q=this,p=q.d
if(p!=null)a=Math.max(0,Math.min(a,p-q.e))
s=q.e
r=A.ni(q,s,a)
q.e=s+a
return r},
T(){var s,r,q=this,p=q.d
if(p!=null){s=q.e
return q.b.fP(q.c+s,Math.max(0,p-s))}s=q.b
r=q.c+q.e
return s.fP(r,s.fS(r))}}
A.ky.prototype={
gp(a){return this.e+this.f},
cG(a,b){var s,r=this,q=r.e
if(a<q)throw A.e(A.aH("Position "+a+" of the decoded data has already been read past, only the last "+r.f+" bytes from "+q+" are still held"))
r.r=a
q=r.b
s=a+b
for(;;){if(!(!r.w&&r.e+r.f<s))break
if(!q.kt(r))r.w=!0}},
kj(a){var s,r=this
r.cG(a,1)
s=r.e
if(a>=s+r.f)return 0
return r.d[a-s]},
fP(a,b){var s,r,q=this
q.cG(a,b)
s=q.e
r=Math.max(0,Math.min(b,s+q.f-a))
if(r===0)return new Uint8Array(0)
s=a-s
return B.c.bO(q.d,s,s+r)},
fS(a){this.cG(a,1125899906842624)
return Math.max(0,this.e+this.f-a)},
dK(a){var s,r,q,p,o=this,n=o.f,m=o.d
if(n+a<=m.length)return
s=o.e
r=Math.max(s,Math.min(o.r-o.c,s+n-o.b.gkF()))-s
if(r>0){B.c.a_(m,0,n-r,m,r)
n=o.f-=r
o.e+=r}m=n+a
s=o.d
q=s.length
if(m>q){m=Math.max(q*2,m)
p=new Uint8Array(m)
B.c.aK(p,0,n,s)
o.d=p}},
aU(a){var s,r,q=this
if(q.f===q.d.length)q.dK(1)
s=q.d
r=q.f++
s.$flags&2&&A.a(s)
s[r]=a},
lb(a){var s,r,q=this,p=a.length
q.dK(p)
s=q.d
r=q.f
B.c.aK(s,r,r+p,a)
q.f+=p},
h1(a){return this.lb(a.T())},
h_(a,b){var s,r,q,p,o,n,m,l,k,j=this
j.dK(b)
s=j.f
r=s-a
if(r<0)throw A.e(A.aH("Back reference before the start of the data"))
q=s+b
if(a>=b){p=j.d
B.c.a_(p,s,q,p,r)}else for(p=j.d,o=p.$flags|0,n=r;s<q;s=m,n=l){m=s+1
l=n+1
k=p[n]
o&2&&A.a(p)
p[s]=k}j.f+=b}}
A.fH.prototype={
ge4(){return this.c},
gp(a){var s=this.b
return s==null?0:s.length-this.c},
ed(a){this.c=a},
be(a,b){var s,r=this,q=r.d
q===$&&A.b()
s=r.c
if(b>=q-s)r.c=q
else if(b<=-s)r.c=0
else r.c=s+b},
ei(a,b){var s=this.b
if(s==null)return A.iT(A.m([],t.t),B.a1,null,null)
return A.iT(s,this.a,a,b)},
D(){var s=this.b
s.toString
return s[this.c++]},
T(){var s,r,q,p,o=this,n=o.b
if(n==null)return new Uint8Array(0)
s=o.gp(0)
r=n.length
q=o.c
p=r-q
if(s<0||s>p)s=p
if(q<0)throw A.e(A.ad(q,0,r,"position",null))
return J.aj(B.c.gA(n),o.b.byteOffset+o.c,s)}}
A.iU.prototype={
k(){var s=this.D(),r=this.D()
if(this.a===B.ay)return(s<<8|r)>>>0
return(r<<8|s)>>>0},
i(){var s=this,r=s.D(),q=s.D(),p=s.D(),o=s.D()
if(s.a===B.ay)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
a1(a){var s=this,r=s.ei(a,s.ge4())
s.ed(s.ge4()+r.gp(r))
return r}}
A.lO.prototype={
aU(a){var s,r,q=this
if(q.b===q.c.length)q.iB()
s=q.c
r=q.b++
s.$flags&2&&A.a(s)
s[r]=a},
h1(a){var s,r,q,p,o=this
while(s=o.b,r=a.gp(a),q=o.c,s+r>q.length)o.dr(o.b+a.gp(a)-o.c.length)
if(a instanceof A.fH){s=a.b
if(s!=null){r=o.b
B.c.a_(q,r,r+a.gp(0),s,a.c)}}else{p=a.T()
s=o.c
r=o.b
q=p.length
B.c.a_(s,r,r+q,p,0)
o.b+=q
return}o.b=o.b+a.gp(0)},
h_(a,b){var s,r,q,p,o,n,m,l,k,j=this
while(s=j.b,r=s+b,q=j.c,p=q.length,r>p)j.dr(r-p)
o=s-a
if(a>=b)B.c.a_(q,s,r,q,o)
else for(p=q.$flags|0,n=o;s<r;s=m,n=l){m=s+1
l=n+1
k=q[n]
p&2&&A.a(q)
q[s]=k}j.b+=b},
dr(a){var s,r=this.c,q=r.length,p=q+(a==null?1:a),o=q===0?32768:q*2
if(o<p)o=p
s=new Uint8Array(o)
B.c.aK(s,0,q,r)
this.c=s},
iB(){return this.dr(null)},
gp(a){return this.b}}
A.jm.prototype={}
A.ie.prototype={
a6(){return"Channel."+this.b}}
A.P.prototype={
E(){var s=this.b
return++this.a<s.gp(s)},
gJ(){return this.b.n(0,this.a)}}
A.cy.prototype={
N(){return new A.cy(new Uint16Array(A.t(this.a)))},
gH(){return B.z},
gp(a){return this.a.length},
gP(){return null},
n(a,b){var s,r=this.a
if(b<r.length){r=r[b]
s=$.F
r=(s!=null?s:A.K())[r]}else r=0
return r},
l(a,b,c){var s,r=this.a
if(b<r.length){s=A.G(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gL(){return this.gq()},
gq(){var s,r=this.a
if(!B.A.gac(r)){r=r[0]
s=$.F
r=(s!=null?s:A.K())[r]}else r=0
return r},
gt(){var s=this.a,r=s.length
if(r===2){s=s[0]
r=$.F
s=(r!=null?r:A.K())[s]}else if(r>1){s=s[1]
r=$.F
s=(r!=null?r:A.K())[s]}else s=0
return s},
gu(){var s=this.a,r=s.length
if(r===2){s=s[0]
r=$.F
s=(r!=null?r:A.K())[s]}else if(r>2){s=s[2]
r=$.F
s=(r!=null?r:A.K())[s]}else s=0
return s},
gv(){var s=this.a,r=s.length
if(r===2){s=s[1]
r=$.F
s=(r!=null?r:A.K())[s]}else if(r>3){s=s[3]
r=$.F
s=(r!=null?r:A.K())[s]}else s=0
return s},
gah(){return this.a.length===2?this.gq():A.W(this)},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1}
A.cz.prototype={
N(){return new A.cz(new Float32Array(A.t(this.a)))},
gH(){return B.C},
gp(a){return this.a.length},
gP(){return null},
n(a,b){var s=this.a
return b<s.length?s[b]:0},
l(a,b,c){var s=this.a
if(b<s.length){s.$flags&2&&A.a(s)
s[b]=c}},
gL(){var s=this.a
return!B.R.gac(s)?s[0]:0},
gq(){var s=this.a
return!B.R.gac(s)?s[0]:0},
gt(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:1
return s},
gah(){var s=this.a
if(s.length===2)s=!B.R.gac(s)?s[0]:0
else s=A.W(this)
return s},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1}
A.cA.prototype={
N(){return new A.cA(new Float64Array(A.t(this.a)))},
gH(){return B.I},
gp(a){return this.a.length},
gP(){return null},
n(a,b){var s=this.a
return b<s.length?s[b]:0},
l(a,b,c){var s=this.a
if(b<s.length){s.$flags&2&&A.a(s)
s[b]=c}},
gL(){var s=this.a
return!B.V.gac(s)?s[0]:0},
gq(){var s=this.a
return!B.V.gac(s)?s[0]:0},
gt(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:1
return s},
gah(){var s=this.a
if(s.length===2)s=!B.V.gac(s)?s[0]:0
else s=A.W(this)
return s},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1}
A.cB.prototype={
N(){return new A.cB(new Int16Array(A.t(this.a)))},
gH(){return B.L},
gp(a){return this.a.length},
gP(){return null},
n(a,b){var s=this.a
return b<s.length?s[b]:0},
l(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gL(){var s=this.a
return!B.S.gac(s)?s[0]:0},
gq(){var s=this.a
return!B.S.gac(s)?s[0]:0},
gt(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:0
return s},
gah(){var s=this.a
if(s.length===2)s=!B.S.gac(s)?s[0]:0
else s=A.W(this)
return s},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1}
A.cC.prototype={
N(){return new A.cC(new Int32Array(A.t(this.a)))},
gH(){return B.M},
gp(a){return this.a.length},
gP(){return null},
n(a,b){var s=this.a
return b<s.length?s[b]:0},
l(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gL(){var s=this.a
return!B.E.gac(s)?s[0]:0},
gq(){var s=this.a
return!B.E.gac(s)?s[0]:0},
gt(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:0
return s},
gah(){var s=this.a
if(s.length===2)s=!B.E.gac(s)?s[0]:0
else s=A.W(this)
return s},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1}
A.cD.prototype={
N(){return new A.cD(new Int8Array(A.t(this.a)))},
gH(){return B.K},
gp(a){return this.a.length},
gP(){return null},
n(a,b){var s=this.a
return b<s.length?s[b]:0},
l(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gL(){var s=this.a
return!B.W.gac(s)?s[0]:0},
gq(){var s=this.a
return!B.W.gac(s)?s[0]:0},
gt(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:0
return s},
gah(){var s=this.a
if(s.length===2)s=!B.W.gac(s)?s[0]:0
else s=A.W(this)
return s},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1}
A.cE.prototype={
N(){var s=this.b
s===$&&A.b()
return new A.cE(this.a,s)},
gH(){return B.u},
gP(){return null},
bF(a){var s
if(a<this.a){s=this.b
s===$&&A.b()
s=B.a.U(s,7-a)&1}else s=0
return s},
bQ(a,b){var s
if(a>=this.a)return
a=7-a
s=this.b
s===$&&A.b()
this.b=b!==0?(s|B.a.Y(1,a))>>>0:(s&~(B.a.Y(1,a)&255))>>>0},
n(a,b){return this.bF(b)},
l(a,b,c){return this.bQ(b,c)},
gL(){return this.bF(0)},
gq(){return this.bF(0)},
gt(){return this.bF(this.a===2?0:1)},
gu(){return this.bF(this.a===2?0:2)},
gv(){return this.bF(this.a===2?1:3)},
gah(){return this.a===2?this.bF(0):A.W(this)},
ae(a,b,c,d){var s,r=this
r.bQ(0,a)
s=r.a
if(s===2)r.bQ(1,d)
else if(s>2){r.bQ(1,b)
r.bQ(2,c)
r.bQ(3,d)}},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
gp(a){return this.a}}
A.cF.prototype={
N(){return new A.cF(new Uint16Array(A.t(this.a)))},
gH(){return B.m},
gp(a){return this.a.length},
gP(){return null},
n(a,b){var s=this.a
return b<s.length?s[b]:0},
l(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gL(){var s=this.a
return!B.A.gac(s)?s[0]:0},
gq(){var s=this.a
return!B.A.gac(s)?s[0]:0},
gt(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:0
return s},
gah(){var s=this.a
if(s.length===2)s=!B.A.gac(s)?s[0]:0
else s=A.W(this)
return s},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1}
A.cG.prototype={
N(){var s=this.b
s===$&&A.b()
return new A.cG(this.a,s)},
gH(){return B.x},
gP(){return null},
bG(a){var s
if(a<this.a){s=this.b
s===$&&A.b()
s=B.a.U(s,6-(a<<1>>>0))&3}else s=0
return s},
bR(a,b){var s,r,q
if(a>=this.a)return
s=B.dr[a]
r=B.b.h(b)
q=this.b
q===$&&A.b()
this.b=(q&s|B.a.Y(r&3,6-(a<<1>>>0)))>>>0},
n(a,b){return this.bG(b)},
l(a,b,c){return this.bR(b,c)},
gL(){return this.bG(0)},
gq(){return this.bG(0)},
gt(){return this.bG(this.a===2?0:1)},
gu(){return this.bG(this.a===2?0:2)},
gv(){return this.bG(this.a===2?1:3)},
gah(){return this.a===2?this.bG(0):A.W(this)},
ae(a,b,c,d){var s,r=this
r.bR(0,a)
s=r.a
if(s===2)r.bR(1,d)
else if(s>2){r.bR(1,b)
r.bR(2,c)
r.bR(3,d)}},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
gp(a){return this.a}}
A.cH.prototype={
N(){return new A.cH(new Uint32Array(A.t(this.a)))},
gH(){return B.J},
gp(a){return this.a.length},
gP(){return null},
n(a,b){var s=this.a
return b<s.length?s[b]:0},
l(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gL(){var s=this.a
return!B.l.gac(s)?s[0]:0},
gq(){var s=this.a
return!B.l.gac(s)?s[0]:0},
gt(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:0
return s},
gah(){var s=this.a
if(s.length===2)s=!B.l.gac(s)?s[0]:0
else s=A.W(this)
return s},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1}
A.cI.prototype={
N(){return new A.cI(this.a,new Uint8Array(A.t(this.b)))},
gH(){return B.y},
gP(){return null},
bH(a){var s
if(a<0||a>=this.a)s=0
else{s=this.b
s=a<2?B.a.U(s[0],4-(a<<2>>>0))&15:B.a.U(s[1],4-((a&1)<<2))&15}return s},
bX(a,b){var s,r,q,p
if(a>=this.a)return
s=B.a.I(B.b.h(b),0,15)
if(a>1){a&=1
r=1}else r=0
if(a===0){q=this.b
p=q[r]
q.$flags&2&&A.a(q)
q[r]=(p&15|s<<4)>>>0}else if(a===1){q=this.b
p=q[r]
q.$flags&2&&A.a(q)
q[r]=(p&240|s)>>>0}},
n(a,b){return this.bH(b)},
l(a,b,c){return this.bX(b,c)},
gL(){return this.bH(0)},
gq(){return this.bH(0)},
gt(){return this.bH(this.a===2?0:1)},
gu(){return this.bH(this.a===2?0:2)},
gv(){return this.bH(this.a===2?1:3)},
gah(){return this.a===2?this.bH(0):A.W(this)},
ae(a,b,c,d){var s,r=this
r.bX(0,a)
s=r.a
if(s===2)r.bX(1,d)
else if(s>2){r.bX(1,b)
r.bX(2,c)
r.bX(3,d)}},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
gp(a){return this.a}}
A.aW.prototype={
hd(a,b,c,d){var s=this.a
s.$flags&2&&A.a(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d},
N(){return new A.aW(new Uint8Array(A.t(this.a)))},
gH(){return B.e},
gp(a){return this.a.length},
gP(){return null},
n(a,b){var s=this.a
return b<s.length?s[b]:0},
l(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gL(){var s=this.a
return!B.c.gac(s)?s[0]:0},
gq(){var s=this.a
return!B.c.gac(s)?s[0]:0},
gt(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:255
return s},
gah(){var s=this.a
if(s.length===2)s=!B.c.gac(s)?s[0]:0
else s=A.W(this)
return s},
gF(a){return new A.P(this)},
O(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gG(b)
r=A.p(this,A.j(this).m("d.E"))
s=s===A.k(r)}return s},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1}
A.fg.prototype={}
A.bO.prototype={}
A.ae.prototype={
a6(){return"Format."+this.b}}
A.fb.prototype={
a6(){return"BlendMode."+this.b}}
A.bR.prototype={
cs(a){var s=$.mM()
if(!s.am(a))return"<unknown>"
return s.n(0,a).a},
B(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
for(s=e.a,r=new A.ab(s,s.r,s.e,A.j(s).m("ab<1>")),q=t.p,p=t.r,o=t.N,n=t.P,m="";r.E();){l=r.d
m+=l+"\n"
k=s.n(0,l)
for(l=k.a,l=new A.ab(l,l.r,l.e,A.j(l).m("ab<1>"));l.E();){j=l.d
i=k.n(0,j)
m=i==null?m+("\t"+e.cs(j)+"\n"):m+("\t"+e.cs(j)+": "+i.B(0)+"\n")}for(l=k.b.a,j=new A.ab(l,l.r,l.e,A.j(l).m("ab<1>"));j.E();){h=j.d
m+=h+"\n"
if(!l.am(h))l.l(0,h,new A.b5(A.O(q,p),new A.bv(A.O(o,n))))
g=l.n(0,h)
for(h=g.a,h=new A.ab(h,h.r,h.e,A.j(h).m("ab<1>"));h.E();){f=h.d
i=g.n(0,f)
m=i==null?m+("\t"+e.cs(f)+"\n"):m+("\t"+e.cs(f)+": "+i.B(0)+"\n")}}}return m.charCodeAt(0)==0?m:m},
bu(c6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3=this,c4="Length must be a non-negative integer: ",c5=c6.e
c6.e=!0
s=c6.d
a1=c6.k()
if(a1===18761){c6.e=!1
if(c6.k()!==42){c6.e=c5
return!1}}else if(a1===19789){c6.e=!0
if(c6.k()!==42){c6.e=c5
return!1}}else return!1
r=c6.i()
c3.c=0
q=0
a2=t.p
a3=A.nq(a2)
a4=c3.a
a5=t.gn
a6=c6.c
a7=t.r
a8=t.N
a9=t.P
for(;;){if(!(r>0&&q<64&&a3.by(0,r)))break
try{b0=s+r
c6.d=b0
if(a6-b0<2)break
p=new A.b5(A.O(a2,a7),new A.bv(A.O(a8,a9)))
o=c6.k()
if(o*12>a6-c6.d)break
n=o
b0=n
if(b0<0)A.X(A.aU(c4+A.x(b0),null))
m=A.m(new Array(b0),a5)
for(l=0;l<n;++l)J.V(m,l,c3.f6(c6,s))
k=m
for(b0=k,b1=b0.length,b2=0;b2<b0.length;b0.length===b1||(0,A.a5)(b0),++b2){j=b0[b2]
if(j.b!=null){b3=j.a
b4=j.b
b4.toString
J.V(p,b3,b4)}}a4.l(0,"ifd"+A.x(q),p);++q
r=c6.i()}catch(b5){break}}for(b0=new A.bz(a4,a4.r,a4.e,A.j(a4).m("bz<2>"));b0.E();){i=b0.d
for(b1=B.bi.gbB(),b1=b1.gF(b1);b1.E();){h=b1.gJ()
if(i.a.am(h))try{g=J.c(i,h).h(0)
c6.d=s+g
f=new A.b5(A.O(a2,a7),new A.bv(A.O(a8,a9)))
e=c6.k()
d=e
b3=d
if(b3<0)A.X(A.aU(c4+A.x(b3),null))
c=A.m(new Array(b3),a5)
for(b=0;b<d;++b)J.V(c,b,c3.f6(c6,s))
a=c
for(b3=a,b4=b3.length,b2=0;b2<b3.length;b3.length===b4||(0,A.a5)(b3),++b2){a0=b3[b2]
if(a0.b!=null){b6=a0.a
b7=a0.b
b7.toString
J.V(f,b6,b7)}}b3=i.b
b4=B.bi.n(0,h)
b4.toString
b3.a.l(0,b4,f)}catch(b5){continue}}}c3.b=null
b8=a4.n(0,"ifd1")
if(b8!=null){a2=b8.a
a2=a2.am(513)&&a2.am(514)}else a2=!1
if(a2){b9=b8.n(0,513).h(0)
c0=b8.n(0,514).h(0)
c1=s+b9
if(c0>0&&c1>=s&&c1+c0<=a6){c2=c6.d
c6.d=c1
c3.b=c6.a1(c0).T()
c6.d=c2}}c6.e=c5
return!1},
f6(a,b){var s,r,q,p,o,n,m,l=a.k(),k=a.k(),j=a.i(),i=new A.hO(l,null)
if(k>=14)return i
s=B.b3[k]
r=j*B.a3[k]
if(this.c+r>16777216)return i
q=a.d
if((r>4?a.d=a.i()+b:q)+r>a.c)return i
p=a.a1(r)
this.c+=r
switch(s.a){case 0:break
case 6:i.b=new A.bx(new Int8Array(A.t(J.lu(B.c.gA(p.T()),0,j))))
break
case 1:i.b=new A.bc(new Uint8Array(A.t(p.a1(j).T())))
break
case 7:i.b=new A.cR(new Uint8Array(A.t(p.a1(j).T())))
break
case 2:i.b=new A.bX(j===0?"":p.ag(j-1))
break
case 3:i.b=A.ne(p,j)
break
case 4:i.b=A.n9(p,j)
break
case 5:i.b=A.na(p,j)
break
case 10:i.b=A.nc(p,j)
break
case 8:i.b=A.nd(p,j)
break
case 9:i.b=A.nb(p,j)
break
case 11:i.b=A.nf(p,j)
break
case 12:i.b=A.n8(p,j)
break
case 13:if(j===1){o=new A.cP(0)
n=p.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=n
o.a=$.a_()[0]
i.b=o}break}a.d=q+4
return i}}
A.hO.prototype={}
A.fn.prototype={}
A.bv.prototype={
hj(a){a.a.bg(0,new A.iJ(this))},
n(a,b){var s=this.a
if(!s.am(b))s.l(0,b,new A.b5(A.O(t.p,t.r),new A.bv(A.O(t.N,t.P))))
s=s.n(0,b)
s.toString
return s}}
A.iJ.prototype={
$2(a,b){var s=A.n7(b)
this.a.a.l(0,a,s)
return s},
$S:14}
A.b5.prototype={
ko(a){a.a.bg(0,new A.iK(this))
a.b.a.bg(0,new A.iL(this))},
n(a,b){var s=this.a.n(0,b)
return s},
l(a,b,c){this.a.l(0,b,c)},
gbt(){var s=this.a.n(0,274)
return s==null?null:s.h(0)},
sbt(a){this.a.kZ(0,274)}}
A.iK.prototype={
$2(a,b){var s=b.N()
this.a.a.l(0,a,s)
return s},
$S:18}
A.iL.prototype={
$2(a,b){var s=A.n7(b)
this.a.b.a.l(0,a,s)
return s},
$S:14}
A.a8.prototype={
a6(){return"IfdValueType."+this.b}}
A.Y.prototype={
a2(a,b){return 0},
h(a){return this.a2(0,0)},
b8(){return new Uint8Array(0)},
B(a){return""},
O(a,b){var s=this
if(b==null)return!1
return b instanceof A.Y&&s.gaT()===b.gaT()&&s.gp(s)===b.gp(b)&&s.gG(s)===b.gG(b)},
gG(a){return 0}}
A.bc.prototype={
N(){return new A.bc(new Uint8Array(A.t(this.a)))},
gaT(){return B.aJ},
gp(a){return this.a.length},
O(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bc){s=this.a
r=b.a
s=s.length===r.length&&A.k(s)===A.k(r)}else s=!1
return s},
gG(a){return A.k(this.a)},
a2(a,b){return this.a[b]},
h(a){return this.a2(0,0)},
b8(){return this.a},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.bX.prototype={
N(){return new A.bX(this.a)},
gaT(){return B.j},
gp(a){return this.a.length+1},
O(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bX){s=this.a
r=b.a
s=s.length+1===r.length+1&&B.D.gG(s)===B.D.gG(r)}else s=!1
return s},
gG(a){return B.D.gG(this.a)},
b8(){return new Uint8Array(A.t(new A.aV(this.a)))},
B(a){return this.a}}
A.c1.prototype={
ho(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
r&2&&A.a(s)
s[q]=p}},
N(){return new A.c1(new Uint16Array(A.t(this.a)))},
gaT(){return B.h},
gp(a){return this.a.length},
O(a,b){var s,r
if(b==null)return!1
if(b instanceof A.c1){s=this.a
r=b.a
s=s.length===r.length&&A.k(s)===A.k(r)}else s=!1
return s},
gG(a){return A.k(this.a)},
a2(a,b){return this.a[b]},
h(a){return this.a2(0,0)},
b8(){return J.C(B.A.gA(this.a))},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.bw.prototype={
hl(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.i()
r&2&&A.a(s)
s[q]=p}},
N(){return new A.bw(new Uint32Array(A.t(this.a)))},
gaT(){return B.n},
gp(a){return this.a.length},
O(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bw){s=this.a
r=b.a
s=s.length===r.length&&A.k(s)===A.k(r)}else s=!1
return s},
gG(a){return A.k(this.a)},
a2(a,b){return this.a[b]},
h(a){return this.a2(0,0)},
b8(){return J.C(B.l.gA(this.a))},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.bY.prototype={
N(){return new A.bY(A.nr(this.a,t.i))},
gaT(){return B.q},
gp(a){return this.a.length},
a2(a,b){return this.a[b].h(0)},
h(a){return this.a2(0,0)},
O(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.bY){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.k(s)===A.k(q)}else s=!1
return s},
gG(a){return A.k(this.a)},
B(a){var s=this.a
return s.length===1?s[0].B(0):A.x(s)}}
A.bx.prototype={
N(){return new A.bx(new Int8Array(A.t(this.a)))},
gaT(){return B.aO},
gp(a){return this.a.length},
O(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bx){s=this.a
r=b.a
s=s.length===r.length&&A.k(s)===A.k(r)}else s=!1
return s},
gG(a){return A.k(this.a)},
a2(a,b){return this.a[b]},
h(a){return this.a2(0,0)},
b8(){return J.C(B.W.gA(this.a))},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.c0.prototype={
hn(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
o=$.ah()
o.$flags&2&&A.a(o)
o[0]=p
p=$.as()[0]
r&2&&A.a(s)
s[q]=p}},
N(){return new A.c0(new Int16Array(A.t(this.a)))},
gaT(){return B.aP},
gp(a){return this.a.length},
O(a,b){var s,r
if(b==null)return!1
if(b instanceof A.c0){s=this.a
r=b.a
s=s.length===r.length&&A.k(s)===A.k(r)}else s=!1
return s},
gG(a){return A.k(this.a)},
a2(a,b){return this.a[b]},
h(a){return this.a2(0,0)},
b8(){return J.C(B.S.gA(this.a))},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.bZ.prototype={
hm(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.i()
o=$.N()
o.$flags&2&&A.a(o)
o[0]=p
p=$.a_()[0]
r&2&&A.a(s)
s[q]=p}},
N(){return new A.bZ(new Int32Array(A.t(this.a)))},
gaT(){return B.aQ},
gp(a){return this.a.length},
O(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bZ){s=this.a
r=b.a
s=s.length===r.length&&A.k(s)===A.k(r)}else s=!1
return s},
gG(a){return A.k(this.a)},
a2(a,b){return this.a[b]},
h(a){return this.a2(0,0)},
b8(){return J.C(B.E.gA(this.a))},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.c_.prototype={
N(){return new A.c_(A.nr(this.a,t.i))},
gaT(){return B.aK},
gp(a){return this.a.length},
O(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.c_){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.k(s)===A.k(q)}else s=!1
return s},
gG(a){return A.k(this.a)},
a2(a,b){return this.a[b].h(0)},
h(a){return this.a2(0,0)},
B(a){var s=this.a
return s.length===1?s[0].B(0):A.x(s)}}
A.cQ.prototype={
hp(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.i()
o=$.N()
o.$flags&2&&A.a(o)
o[0]=p
p=$.bL()[0]
r&2&&A.a(s)
s[q]=p}},
N(){return new A.cQ(new Float32Array(A.t(this.a)))},
gaT(){return B.aL},
gp(a){return this.a.length},
O(a,b){var s,r
if(b==null)return!1
if(b instanceof A.cQ){s=this.a
r=b.a
s=s.length===r.length&&A.k(s)===A.k(r)}else s=!1
return s},
gG(a){return A.k(this.a)},
b8(){return J.C(B.R.gA(this.a))},
B(a){var s=this.a
return s.length===1?A.x(s[0]):A.x(s)}}
A.cO.prototype={
hk(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.d1()
r&2&&A.a(s)
s[q]=p}},
N(){return new A.cO(new Float64Array(A.t(this.a)))},
gaT(){return B.aM},
gp(a){return this.a.length},
O(a,b){var s,r
if(b==null)return!1
if(b instanceof A.cO){s=this.a
r=b.a
s=s.length===r.length&&A.k(s)===A.k(r)}else s=!1
return s},
gG(a){return A.k(this.a)},
b8(){return J.C(B.V.gA(this.a))},
B(a){var s=this.a
return s.length===1?A.x(s[0]):A.x(s)}}
A.cR.prototype={
N(){return new A.cR(new Uint8Array(A.t(this.a)))},
gaT(){return B.N},
gp(a){return this.a.length},
b8(){return this.a},
O(a,b){var s,r
if(b==null)return!1
if(b instanceof A.cR){s=this.a
r=b.a
s=s.length===r.length&&A.k(s)===A.k(r)}else s=!1
return s},
gG(a){return A.k(this.a)},
B(a){return"<data>"}}
A.cP.prototype={
N(){return A.pB(this.a)},
gaT(){return B.aN},
gp(a){return 1},
O(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.cP)s=this.a===b.a
return s},
gG(a){return this.a},
a2(a,b){var s=null
if(b!==0)throw A.e(new A.bj(s,s,!1,s,s,"Ifd tags must have exactly one entry (the offset)"))
return this.a},
h(a){return this.a2(0,0)},
b8(){var s=this.a
return new Uint8Array(A.t(A.m([B.a.j(s,24),B.a.j(s,16),B.a.j(s,8),s],t.t)))},
B(a){return"Ifd@"+this.a}}
A.bh.prototype={
bL(a,b,c){var s,r=this.c+b*c
this.c=r
s=this.a
if(s>0&&r>s)throw A.e(A.i("Animation frames exceed the maximum of "+s+" pixels"))}}
A.a7.prototype={
a6(){return"BmpCompression."+this.b}}
A.id.prototype={}
A.b9.prototype={
ek(a,b){var s,r,q,p,o,n,m,l=this,k=l.d,j=k<=40
if(j){s=l.r
s=s===B.ab||s===B.ac}else s=!0
if(s){s=l.as=a.i()
r=A.lc(s)
l.CW=r
q=B.a.U(s,r)
s=q>0
l.cx=s?255/q:0
r=l.at=a.i()
p=A.lc(r)
l.cy=p
o=B.a.U(r,p)
l.db=s?255/o:0
r=l.ax=a.i()
p=A.lc(r)
l.dx=p
n=B.a.U(r,p)
l.dy=s?255/n:0
if(!j||l.r===B.ac){j=l.ay=a.i()
s=A.lc(j)
l.fr=s
m=B.a.U(j,s)
l.fx=m>0?255/m:0}else if(l.f===16){l.ay=4278190080
l.fr=24
l.fx=1}else{l.ay=4278190080
l.fr=24
l.fx=1}}else if(l.f===16){l.as=31744
l.CW=10
l.cx=8.225806451612904
l.at=992
l.cy=5
l.db=8.225806451612904
l.ax=31
l.dx=0
l.dy=8.225806451612904
l.fx=l.fr=l.ay=0}else{l.as=16711680
l.CW=16
l.cx=1
l.at=65280
l.cy=8
l.db=1
l.ax=255
l.dx=0
l.dy=1
l.ay=4278190080
l.fr=24
l.fx=1}j=a.d
a.d=j+(k-(j-l.fy))
if(l.f<=8)l.kU(a)},
gcg(){var s=this.d
if(s!==40)if(s===124){s=this.ay
s===$&&A.b()
s=s===0}else s=!1
else s=!0
return s},
gR(){return Math.abs(this.c)},
kU(a){var s,r,q,p,o,n=this,m=n.z
if(m===0)m=B.a.M(1,n.f)
n.ch=new A.b6(new Uint8Array(m*3),m,3)
for(s=0;s<m;++s){r=J.c(a.a,a.d++)
q=J.c(a.a,a.d++)
p=J.c(a.a,a.d++)
o=J.c(a.a,a.d++)
n.ch.cu(s,p,q,r,o)}},
kx(a,b){var s,r,q,p,o,n,m,l,k,j=this
if(j.ch!=null){s=j.f
if(s===1){r=a.D()
for(q=7;q>=0;--q)b.$4(B.a.bn(r,q)&1,0,0,0)
return}else if(s===2){r=a.D()
for(q=6;q>=0;q-=2)b.$4(B.a.bn(r,q)&2,0,0,0)}else if(s===4){r=a.D()
b.$4(B.a.j(r,4)&15,0,0,0)
b.$4(r&15,0,0,0)
return}else if(s===8){b.$4(a.D(),0,0,0)
return}}s=j.r
if(s===B.ab&&j.f===32){p=a.i()
s=j.as
s===$&&A.b()
o=j.CW
o===$&&A.b()
o=B.a.U((p&s)>>>0,o)
s=j.cx
s===$&&A.b()
n=B.b.h(o*s)
s=j.at
s===$&&A.b()
o=j.cy
o===$&&A.b()
o=B.a.U((p&s)>>>0,o)
s=j.db
s===$&&A.b()
m=B.b.h(o*s)
s=j.ax
s===$&&A.b()
o=j.dx
o===$&&A.b()
o=B.a.U((p&s)>>>0,o)
s=j.dy
s===$&&A.b()
l=B.b.h(o*s)
if(j.gcg())k=255
else{s=j.ay
s===$&&A.b()
o=j.fr
o===$&&A.b()
o=B.a.U((p&s)>>>0,o)
s=j.fx
s===$&&A.b()
k=B.b.h(o*s)}return b.$4(n,m,l,k)}else{o=j.f
if(o===32&&s===B.ax){l=a.D()
m=a.D()
n=a.D()
k=a.D()
return b.$4(n,m,l,j.gcg()?255:k)}else if(o===24){l=a.D()
m=a.D()
return b.$4(a.D(),m,l,255)}else if(o===16){p=a.k()
s=j.as
s===$&&A.b()
o=j.CW
o===$&&A.b()
o=B.a.U((p&s)>>>0,o)
s=j.cx
s===$&&A.b()
n=B.b.h(o*s)
s=j.at
s===$&&A.b()
o=j.cy
o===$&&A.b()
o=B.a.U((p&s)>>>0,o)
s=j.db
s===$&&A.b()
m=B.b.h(o*s)
s=j.ax
s===$&&A.b()
o=j.dx
o===$&&A.b()
o=B.a.U((p&s)>>>0,o)
s=j.dy
s===$&&A.b()
l=B.b.h(o*s)
if(j.gcg())k=255
else{s=j.ay
s===$&&A.b()
o=j.fr
o===$&&A.b()
o=B.a.U((p&s)>>>0,o)
s=j.fx
s===$&&A.b()
k=B.b.h(o*s)}return b.$4(n,m,l,k)}else throw A.e(A.i("Unsupported bitsPerPixel ("+o+") or compression ("+s.B(0)+")."))}}}
A.fc.prototype={
aA(a){var s,r
if(!A.mT(A.q(a,!1,null,0))||a.length<18)return!1
s=A.q(a,!1,null,0)
s.d+=14
r=s.i()
return r>=12&&r<=124},
au(a){return A.J(new A.ic(this,a))},
hJ(a){var s
if(!this.aA(a))return null
s=A.q(a,!1,null,0)
this.a=s
return this.b=A.pc(s,null)},
ab(a){return A.J(new A.ia(this,a))},
hI(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.b
if(a0==null)return new A.aw(a,a,a,a,0,B.i,0,0)
s=b.a
s===$&&A.b()
r=a0.a.b
r===$&&A.b()
s.d=r
r=a0.b
A.ag(r,a0.gR(),b.d,!1)
q=a0.f
p=B.a.V(r*q+31,32)*4
s=a0.gR()
o=b.a
if(p*s>o.c-o.d)throw A.e(A.i("Truncated BMP data"))
s=b.c
if(s)n=4
else if(q===1||q===4||q===8)n=1
else{o=q===32?4:3
n=o}if(s)m=B.e
else if(q===1)m=B.u
else{if(q===2)o=B.x
else if(q===4)o=B.y
else o=B.e
m=o}l=s?a:a0.ch
k=A.Q(a,a,m,0,B.i,a0.gR(),a,0,n,l,B.e,r,!1)
for(j=k.gR()-1,s=a0.c,r=1/s<0,o=s<0,s=s===0;j>=0;--j){i={}
if(!(s?r:o))h=j
else{g=k.a
g=g==null?a:g.b
h=(g==null?0:g)-1-j}g=b.a
f=g.aq(p)
g.d=g.d+(f.c-f.d)
g=k.a
e=g==null
d=e?a:g.a
if(d==null)d=0
i.a=0
c=e?a:g.K(0,h,a)
if(c==null)c=new A.D()
while(i.a<d)a0.kx(f,new A.i9(i,b,d,a0,c))}return k},
aS(a,b){return A.J(new A.ib(this,a,b))},
hH(a,b){var s=this.au(a)
if(s==null||s.b<1||s.gR()<1)return null
return this.ab(0)}}
A.ic.prototype={
$0(){return this.a.hJ(this.b)},
$S:20}
A.ia.prototype={
$0(){return this.a.hI(this.b)},
$S:21}
A.i9.prototype={
$4(a,b,c,d){var s,r,q=this,p=q.a
if(p.a<q.c){s=q.b.c&&q.d.ch!=null
r=q.e
if(s){s=q.d
r.ae(s.ch.aI(a),s.ch.aG(a),s.ch.aE(a),s.ch.aN(a))}else r.ae(a,b,c,d)
r.E();++p.a}},
$S:22}
A.ib.prototype={
$0(){return this.a.hH(this.b,this.c)},
$S:1}
A.ik.prototype={}
A.dI.prototype={}
A.ij.prototype={}
A.fp.prototype={}
A.fJ.prototype={
ck(){return this.w},
b9(a,b,c,d,e){throw A.e(A.i("B44 compression not yet supported."))},
c1(a,b,c){return this.b9(a,b,c,null,null)},
B(a){return A.x(this.r)+" "+this.x}}
A.bT.prototype={
a6(){return"ExrChannelType."+this.b}}
A.bS.prototype={
a6(){return"ExrChannelName."+this.b}}
A.fq.prototype={
he(a){var s=this,r=a.cm()
s.a=r
if(r.length===0)return
s.c=B.ez[a.i()]
a.D()
a.d+=3
s.f=a.i()
s.r=a.i()
r=s.a
if(r==="R"){s.w=!0
s.b=B.c0}else if(r==="G"){s.w=!0
s.b=B.c1}else if(r==="B"){s.w=!0
s.b=B.c2}else if(r==="A"){s.w=!0
s.b=B.c3}else{s.w=!1
s.b=B.c4}switch(s.c.a){case 0:s.d=4
break
case 1:s.d=2
break
case 2:s.d=4
break}}}
A.aX.prototype={
a6(){return"ExrCompressorType."+this.b}}
A.io.prototype={
b9(a,b,c,d,e){throw A.e(A.i("Unsupported compression type"))},
c1(a,b,c){return this.b9(a,b,c,null,null)}}
A.iY.prototype={}
A.fr.prototype={}
A.it.prototype={
hf(a,b){var s,r,q,p,o,n=this,m=A.q(a,!1,null,0)
if(m.i()!==20000630)throw A.e(A.i("File is not an OpenEXR image file."))
s=n.d=m.D()
if(s!==2)throw A.e(A.i("Cannot read version "+s+" image files."))
s=n.e=m.b6()
if((s&4294967289)>>>0!==0)throw A.e(A.i("The file format version number's flag field contains unrecognized flags."))
r=new A.bh(b)
if((s&16)===0){q=n.c
p=A.nj(q.length,(s&2)!==0,m,b)
if(p.w>0)q.push(p)}else for(s=n.c;;){p=A.nj(s.length,(n.e&2)!==0,m,b)
q=p.w
if(q<=0)break
r.bL(0,q,p.x)
s.push(p)}s=n.c
q=s.length
if(q===0)throw A.e(A.i("Error reading image header"))
for(o=0;o<s.length;s.length===q||(0,A.a5)(s),++o)s[o].kT(m)
n.jH(m)},
jH(a){var s,r,q,p,o=this
for(s=o.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.a5)(s),++q){p=s[q]
o.a=Math.max(o.a,p.w)
o.b=Math.max(o.b,p.x)
if(p.db)o.jQ(p,a)
else o.jP(p,a)}},
jQ(b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=null,b5=this.e
b5===$&&A.b()
s=(b5&16)!==0
b5=b6.b
b5.toString
r=b6.CW
q=b6.ay
p=A.r(b7,b4,0)
o=b6.c
n=b6.a
m=0
l=0
for(;;){k=b6.k1
k.toString
if(!(m<k))break
j=0
for(;;){k=b6.id
k.toString
if(!(j<k))break
for(k=l!==0,i=0,h=0;i<b6.go[m];++i)for(g=0;g<b6.fy[j];++g,++h){if(k)break
p.d=q[l][h]
if(s)if(p.i()!==n)throw A.e(A.i("Invalid Image Data"))
f=p.i()
e=p.i()
p.i()
p.i()
d=p.aq(p.i())
p.d=p.d+(d.c-d.d)
c=b6.dy
c.toString
b=e*c
a=b6.dx
a.toString
c=r.b9(d,f*a,b,a,c)
a=c.length
a=Math.min(a,a)
a0=new A.a6(c,0,a,0,!1)
a1=r.a
a2=r.b
a3=o.length
a4=0
a5=0
for(;;){if(!(a5<a2&&b<this.b))break
for(a6=0;a6<a3;++a6){if(a4>=a)break
a7=o[a6]
c=b6.dx
c.toString
a8=f*c
for(a9=0;a9<a1;++a9,++a8){c=a7.c
c===$&&A.b()
switch(c.a){case 1:c=a0.k()
b0=$.F
b1=(b0!=null?b0:A.K())[c]
break
case 2:b1=a0.k()
break
case 0:b1=a0.i()
break
default:b1=b4}c=a7.d
c===$&&A.b()
a4+=c
c=a7.w
c===$&&A.b()
if(c){c=b5.a
b2=c==null?b4:c.K(a8,b,b4)
if(b2==null)b2=new A.D()
c=a7.b
c===$&&A.b()
b2.l(0,c.a,b1)}else{c=a7.a
c===$&&A.b()
b0=b5.b
b3=b0!=null?b0.n(0,c):b4
if(b3!=null)b3.az(a8,b,b1,0,0)}}}++a5;++b}}++j;++l}++m}},
jP(a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6=null,a7=this.e
a7===$&&A.b()
s=(a7&16)!==0
a7=a8.b
a7.toString
r=a8.CW
q=a8.ay[0]
p=a8.cx
o=A.r(a9,a6,0)
for(n=q.length,m=a8.c,l=r!=null,k=0,j=0;j<n;++j){o.d=q[j]
if(s)if(o.i()!==3.141592653589793)throw A.e(A.i("Invalid Image Data"))
i=o.i()
h=$.N()
h.$flags&2&&A.a(h)
h[0]=i
i=$.a_()
h[0]=o.i()
g=o.aq(i[0])
o.d=o.d+(g.c-g.d)
if(l){i=r.c1(g,0,k)
h=i.length
f=new A.a6(i,0,Math.min(h,h),0,!1)}else f=g
e=f.c-f.d
d=m.length
c=0
for(;;){if(!(c<p&&k<this.b))break
b=a8.cy[k]
if(b>=e)break
for(a=0;a<d;++a){if(b>=e)break
a0=m[a]
a1=a8.w
for(a2=0;a2<a1;++a2){i=a0.c
i===$&&A.b()
switch(i.a){case 1:i=f.k()
h=$.F
a3=(h!=null?h:A.K())[i]
break
case 2:a3=f.k()
break
case 0:a3=f.i()
break
default:a3=a6}i=a0.d
i===$&&A.b()
b+=i
i=a0.w
i===$&&A.b()
if(i){i=a7.a
a4=i==null?a6:i.K(a2,k,a6)
if(a4==null)a4=new A.D()
i=a0.b
i===$&&A.b()
a4.l(0,i.a,a3)}else{i=a0.a
i===$&&A.b()
h=a7.b
a5=h!=null?h.n(0,i):a6
if(a5!=null)a5.az(a2,k,a3,0,0)}}}++c;++k}}}}
A.dL.prototype={
hg(b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=this,b0=null,b1=A.O(t.N,t.fe)
for(s=a9.e,r=t.t,q=a9.c,p=B.z;;){o=b4.cm()
if(o.length===0)break
b4.cm()
n=b4.aq(b4.i())
b4.d=b4.d+(n.c-n.d)
s.l(0,o,new A.fp())
switch(o){case"channels":for(;;){m=new A.fq()
m.he(n)
l=m.a
l===$&&A.b()
if(l.length===0)break
k=m.w
k===$&&A.b()
if(k){++a9.d
l=m.c
l===$&&A.b()
if(l===B.aE)p=B.z
else p=l===B.aF?B.C:B.J}else{k=m.c
k===$&&A.b()
b1.l(0,l,k)}q.push(m)}break
case"chromaticities":l=new Float32Array(8)
a9.at=l
k=n.i()
j=$.N()
j.$flags&2&&A.a(j)
j[0]=k
k=$.bL()
l[0]=k[0]
l=a9.at
j[0]=n.i()
i=k[0]
l.$flags&2&&A.a(l)
l[1]=i
i=a9.at
j[0]=n.i()
l=k[0]
i.$flags&2&&A.a(i)
i[2]=l
l=a9.at
j[0]=n.i()
i=k[0]
l.$flags&2&&A.a(l)
l[3]=i
i=a9.at
j[0]=n.i()
l=k[0]
i.$flags&2&&A.a(i)
i[4]=l
l=a9.at
j[0]=n.i()
i=k[0]
l.$flags&2&&A.a(l)
l[5]=i
i=a9.at
j[0]=n.i()
l=k[0]
i.$flags&2&&A.a(i)
i[6]=l
l=a9.at
j[0]=n.i()
k=k[0]
l.$flags&2&&A.a(l)
l[7]=k
break
case"compression":a9.ax=B.fB[J.c(n.a,n.d++)]
break
case"dataWindow":l=n.i()
k=$.N()
k.$flags&2&&A.a(k)
k[0]=l
l=$.a_()
j=l[0]
k[0]=n.i()
i=l[0]
k[0]=n.i()
h=l[0]
k[0]=n.i()
l=a9.r=A.m([j,i,h,l[0]],r)
a9.w=l[2]-l[0]+1
a9.x=l[3]-l[1]+1
break
case"displayWindow":l=n.i()
k=$.N()
k.$flags&2&&A.a(k)
k[0]=l
$.a_()
k[0]=n.i()
k[0]=n.i()
k[0]=n.i()
break
case"lineOrder":break
case"pixelAspectRatio":l=n.i()
k=$.N()
k.$flags&2&&A.a(k)
k[0]=l
$.bL()
break
case"screenWindowCenter":l=n.i()
k=$.N()
k.$flags&2&&A.a(k)
k[0]=l
$.bL()
k[0]=n.i()
break
case"screenWindowWidth":l=n.i()
k=$.N()
k.$flags&2&&A.a(k)
k[0]=l
$.bL()
break
case"tiles":a9.dx=n.i()
a9.dy=n.i()
g=J.c(n.a,n.d++)
a9.fr=g&15
a9.fx=B.a.j(g,4)&15
break
case"type":f=n.cm()
if(f!=="deepscanline")if(f!=="deeptile")throw A.e(A.i("EXR Invalid type: "+f))
break
default:break}}s=a9.w
if(s===0&&a9.x===0)return
A.ag(s,a9.x,b5,!1)
s=a9.w
a9.b=A.Q(b0,b0,p,0,B.i,a9.x,b0,0,a9.d,b0,B.e,s,!1)
for(s=new A.be(b1,b1.$ti.m("be<1,2>")).gF(0);s.E();){e=s.d
switch(e.b.a){case 1:r=a9.w
l=a9.x
r=new A.cS(new Uint16Array(r*l),r,l,1)
break
case 2:r=a9.w
l=a9.x
r=new A.cT(new Float32Array(r*l),r,l,1)
break
case 0:r=a9.w
l=a9.x
r=new A.cW(new Uint32Array(r*l),r,l,1)
break
default:r=b0}l=a9.b
l.toString
l.h8(e.a,r)}if(a9.db){d={}
c=a9.dx
if(c==null)c=0
b=a9.dy
if(b==null)b=0
if(c<1||b<1)throw A.e(A.i("Invalid EXR tile size"))
A.ag(c,b,b5,!1)
s=a9.r
s===$&&A.b()
a9.id=a9.hO(s[0],s[2],s[1],s[3])
s=a9.r
a9.k1=a9.hP(s[0],s[2],s[1],s[3])
if(a9.fr!==2)a9.k1=1
s=a9.id
s.toString
r=a9.r
a9.fy=a9.eu(s,r[0],r[2],a9.dx,a9.fx)
r=a9.k1
r.toString
s=a9.r
a9.go=a9.eu(r,s[1],s[3],a9.dy,a9.fx)
s=a9.hN()
a9.k2=s
r=a9.dx
r.toString
r=s*r
a9.k3=r
a9.CW=A.n1(a9.ax,a9,r,a9.dy)
s=a9.k1
s.toString
r=a9.id
q=a9.fy
l=a9.go
a=0
a0=0
for(;a0<s;++a0){r.toString
a1=0
for(;a1<r;++a1)a+=q[a1]*l[a0]}if(a*8>b4.c-b4.d)throw A.e(A.i("Truncated EXR data"))
d.a=d.b=0
s=a9.id
s.toString
r=a9.k1
r.toString
a9.ay=A.ns(s*r,new A.iu(d,a9),t.w)}else{s=a9.x
r=a9.ch=new Uint32Array(s+1)
for(l=q.length,k=a9.r,j=a9.w,a2=0;a2<l;++a2){a3=q[a2]
i=a3.d
i===$&&A.b()
h=a3.f
h===$&&A.b()
a4=B.a.a5(i*j,h)
for(i=a3.r,a5=0;a5<s;++a5){k===$&&A.b()
h=k[1]
i===$&&A.b()
if(B.a.a9(a5+h,i)===0)r[a5]=r[a5]+a4}}for(a6=0,a5=0;a5<s;++a5)a6=Math.max(a6,r[a5])
s=A.n1(a9.ax,a9,a6,b0)
a9.CW=s
s=a9.cx=s.ck()
r=a9.ch
q=r.length
l=new Uint32Array(q)
a9.cy=l
for(--q,a7=0,a8=0;a8<=q;++a8){if(B.a.a9(a8,s)===0)a7=0
l[a8]=a7
a7+=r[a8]}s=B.a.a5(a9.x+s,s)
a9.ay=A.m([new Uint32Array(s-1)],t.hh)}},
hO(a,b,c,d){var s,r,q,p=this
switch(p.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
s=(p.fx===0?p.cI(r):p.cA(r))+1
break
case 2:q=b-a+1
s=(p.fx===0?p.cI(q):p.cA(q))+1
break
default:throw A.e(A.i("Unknown LevelMode format."))}return s},
hP(a,b,c,d){var s,r,q,p=this
switch(p.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
s=(p.fx===0?p.cI(r):p.cA(r))+1
break
case 2:q=d-c+1
s=(p.fx===0?p.cI(q):p.cA(q))+1
break
default:throw A.e(A.i("Unknown LevelMode format."))}return s},
cI(a){var s
for(s=0;a>1;){++s
a=B.a.j(a,1)}return s},
cA(a){var s,r
for(s=0,r=0;a>1;){if((a&1)!==0)r=1;++s
a=B.a.j(a,1)}return s+r},
hN(){var s,r,q,p,o
for(s=this.c,r=s.length,q=0,p=0;p<r;++p){o=s[p].d
o===$&&A.b()
q+=o}return q},
eu(a,b,c,d,e){var s,r,q,p,o,n,m=J.ak(a,t.p)
for(s=e===1,r=c-b+1,q=0;q<a;++q){p=B.a.M(1,q)
o=B.a.a5(r,p)
if(s&&o*p<r)++o
n=Math.max(o,1)
d.toString
m[q]=B.a.a5(n+d-1,d)}return m}}
A.iu.prototype={
$1(a){var s,r,q,p,o=this.b,n=o.fy,m=this.a,l=m.b
n=n[l]
s=o.go
r=m.a
s=s[r]
q=new Uint32Array(n*s)
p=l+1
m.b=p
if(p===o.id){m.b=0
m.a=r+1}return q},
$S:24}
A.fK.prototype={
kT(a){var s,r,q,p,o,n=this
if(n.db)for(s=0;s<n.ay.length;++s)for(r=0;q=n.ay[s],r<q.length;++r){p=a.e5()
q.$flags&2&&A.a(q)
q[r]=p}else{o=n.ay[0].length
for(s=0;s<o;++s){q=n.ay[0]
p=a.e5()
q.$flags&2&&A.a(q)
q[s]=p}}}}
A.iZ.prototype={
ht(a,b,c){var s,r,q,p=this,o=a.c.length,n=J.ak(o,t.eO)
for(s=0;s<o;++s)n[s]=new A.hW()
p.y=n
r=p.w
r.toString
q=B.a.V(r*p.x,2)
p.z=new Uint16Array(q)},
ck(){return this.x},
b9(a6,a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this
if(a9==null)a9=a5.c.w
if(b0==null)b0=a5.c.cx
s=a7+a9-1
r=a8+b0-1
q=a5.c
p=q.w
if(s>p)s=p-1
p=q.x
if(r>p)r=p-1
a5.a=s-a7+1
a5.b=r-a8+1
o=q.c
n=o.length
for(m=0,l=0;l<n;++l){k=o[l]
q=a5.y
q===$&&A.b()
j=q[l]
j.b=j.a=m
q=k.f
q===$&&A.b()
i=B.a.a5(a7,q)
h=B.a.a5(s,q)
q=i*q<a7?0:1
q=h-i+q
j.c=q
p=k.r
p===$&&A.b()
i=B.a.a5(a8,p)
h=B.a.a5(r,p)
g=i*p<a8?0:1
g=h-i+g
j.d=g
j.e=p
p=k.d
p===$&&A.b()
p=p/2|0
j.f=p
m+=q*g*p}f=a6.k()
e=a6.k()
if(e>=8192)throw A.e(A.i("Error in header for PIZ-compressed data (invalid bitmap size)."))
d=new Uint8Array(8192)
if(f<=e){c=a6.a1(e-f+1)
b=c.c-c.d
for(a=f,l=0;l<b;++l,a=a0){a0=a+1
d[a]=J.c(c.a,c.d+l)}}a1=new Uint16Array(65536)
a2=a5.jV(d,a1)
A.pq(a6,a6.i(),a5.z,m)
for(l=0;l<n;++l){q=a5.y
q===$&&A.b()
j=q[l]
a=0
for(;;){q=j.f
q===$&&A.b()
if(!(a<q))break
p=a5.z
p.toString
g=j.a
g===$&&A.b()
a3=j.c
a3===$&&A.b()
a4=j.d
a4===$&&A.b()
A.pt(p,g+a,a3,q,a4,a3*q,a2);++a}}q=a5.z
q.toString
a5.hE(a1,q,m)
q=a5.r
if(q==null){q=a5.w
q.toString
q=a5.r=A.jl(q*a5.x+73728)}q.a=0
for(;a8<=r;++a8)for(l=0;l<n;++l){q=a5.y
q===$&&A.b()
j=q[l]
q=j.e
q===$&&A.b()
if(B.a.a9(a8,q)!==0)continue
q=j.c
q===$&&A.b()
p=j.f
p===$&&A.b()
a7=q*p
for(;a7>0;--a7){q=a5.r
q.toString
p=a5.z
p.toString
g=j.b
g===$&&A.b()
j.b=g+1
q.h2(p[g])}}q=a5.r
return J.aj(B.c.gA(q.c),0,q.a)},
c1(a,b,c){return this.b9(a,b,c,null,null)},
hE(a,b,c){var s,r,q
for(s=b.$flags|0,r=0;r<c;++r){q=a[b[r]]
s&2&&A.a(b)
b[r]=q}},
jV(a,b){var s,r,q,p,o
for(s=b.$flags|0,r=0,q=0;q<65536;++q)if(q===0||(a[q>>>3]&1<<(q&7))>>>0!==0){p=r+1
s&2&&A.a(b)
b[r]=q
r=p}for(p=r;p<65536;p=o){o=p+1
s&2&&A.a(b)
b[p]=0}return r-1}}
A.hW.prototype={}
A.j_.prototype={
ck(){return this.w},
b9(a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a2.T(),a1=a.r
a1.toString
a1=a.w*a1
s=A.li(a0,a1)
a0=a.x;(a0==null?a.x=A.jl(a1):a0).a=0
r=A.m([0,0,0,0],t.t)
q=new Uint32Array(1)
p=J.aj(B.l.gA(q),0,null)
if(a5==null)a5=a.c.w
if(a6==null)a6=a.c.cx
o=a3+a5-1
n=a4+a6-1
a0=a.c
a1=a0.w
if(o>a1)o=a1-1
a1=a0.x
if(n>a1)n=a1-1
a.a=o-a3+1
a.b=n-a4+1
a0=a0.c
m=a0.length
for(l=a4,k=0;l<=n;++l)for(j=0;j<m;++j){i=a0[j]
a1=i.r
a1===$&&A.b()
if(B.a.a9(a4,a1)!==0)continue
a1=i.f
a1===$&&A.b()
h=B.a.a5(a3,a1)
g=B.a.a5(o,a1)
a1=h*a1<a3?0:1
f=g-h+a1
q[0]=0
a1=i.c
a1===$&&A.b()
switch(a1.a){case 0:r[0]=k
a1=k+f
r[1]=a1
a1+=f
r[2]=a1
k=a1+f
for(e=0;e<f;++e){a1=r[0]
r[0]=a1+1
a1=s[a1]
d=r[1]
r[1]=d+1
d=s[d]
c=r[2]
r[2]=c+1
c=s[c]
q[0]=q[0]+((a1<<24|d<<16|c<<8)>>>0)
for(b=0;b<4;++b)a.x.aU(p[b])}break
case 1:r[0]=k
a1=k+f
r[1]=a1
k=a1+f
for(e=0;e<f;++e){a1=r[0]
r[0]=a1+1
a1=s[a1]
d=r[1]
r[1]=d+1
d=s[d]
q[0]=q[0]+((a1<<8|d)>>>0)
for(b=0;b<2;++b)a.x.aU(p[b])}break
case 2:r[0]=k
a1=k+f
r[1]=a1
a1+=f
r[2]=a1
k=a1+f
for(e=0;e<f;++e){a1=r[0]
r[0]=a1+1
a1=s[a1]
d=r[1]
r[1]=d+1
d=s[d]
c=r[2]
r[2]=c+1
c=s[c]
q[0]=q[0]+((a1<<24|d<<16|c<<8)>>>0)
for(b=0;b<4;++b)a.x.aU(p[b])}break}}a0=a.x
return J.aj(B.c.gA(a0.c),0,a0.a)},
c1(a,b,c){return this.b9(a,b,c,null,null)}}
A.j0.prototype={
ck(){return 1},
b9(a,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=a.c,b=A.jl((c-a.d)*2)
if(a2==null)a2=d.c.w
if(a3==null)a3=d.c.cx
s=a0+a2-1
r=a1+a3-1
q=d.c
p=q.w
if(s>p)s=p-1
q=q.x
if(r>q)r=q-1
d.a=s-a0+1
d.b=r-a1+1
while(q=a.d,q<c){p=a.a
a.d=q+1
q=J.c(p,q)
p=$.ai()
p.$flags&2&&A.a(p)
p[0]=q
o=$.at()[0]
if(o<0){n=-o
for(;m=n-1,n>0;n=m)b.aU(J.c(a.a,a.d++))}else for(n=o;m=n-1,n>=0;n=m)b.aU(J.c(a.a,a.d++))}l=J.aj(B.c.gA(b.c),0,b.a)
k=l.length
for(c=l.$flags|0,j=1;j<k;++j){q=l[j-1]
p=l[j]
c&2&&A.a(l)
l[j]=q+p-128}c=d.r
if(c==null||c.length!==k)c=d.r=new Uint8Array(k)
q=B.a.V(k+1,2)
for(i=0,h=0;;q=e,i=f){if(h<k){g=h+1
f=i+1
p=l[i]
c.$flags&2&&A.a(c)
c[h]=p}else break
if(g<k){h=g+1
e=q+1
c[g]=l[q]}else break}return c},
c1(a,b,c){return this.b9(a,b,c,null,null)},
B(a){return A.x(this.w)}}
A.fL.prototype={
ck(){return this.x},
b9(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=a.T(),f=h.w
if(f==null)f=0
s=A.li(g,f*h.x)
if(d==null)d=h.c.w
if(e==null)e=h.c.cx
r=b+d-1
q=c+e-1
g=h.c
f=g.w
if(r>f)r=f-1
g=g.x
if(q>g)q=g-1
h.a=r-b+1
h.b=q-c+1
p=s.length
for(g=s.$flags|0,o=1;o<p;++o){f=s[o-1]
n=s[o]
g&2&&A.a(s)
s[o]=f+n-128}g=h.y
if(g==null||g.length!==p)g=h.y=new Uint8Array(p)
f=B.a.V(p+1,2)
for(m=0,l=0;;f=i,m=j){if(l<p){k=l+1
j=m+1
n=s[m]
g.$flags&2&&A.a(g)
g[l]=n}else break
if(k<p){l=k+1
i=f+1
g[k]=s[f]}else break}return g},
c1(a,b,c){return this.b9(a,b,c,null,null)},
B(a){return A.x(this.w)}}
A.ip.prototype={
au(a){return A.J(new A.is(this,a))},
ab(a){return A.J(new A.iq(this,a))},
iE(a){var s=this.a
if(s==null)return null
return s.c[a].b},
aS(a,b){return A.J(new A.ir(this,a,b))},
iD(a,b){if(this.au(a)==null)return null
return this.ab(0)}}
A.is.prototype={
$0(){var s=this.a,r=new A.it(A.m([],t.dw))
r.hf(this.b,s.b)
return s.a=r},
$S:5}
A.iq.prototype={
$0(){return this.a.iE(this.b)},
$S:1}
A.ir.prototype={
$0(){return this.a.iD(this.b,this.c)},
$S:1}
A.dQ.prototype={
kC(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
if(d===0&&e.c!=null){s=e.c
s.toString
return s}for(s=e.b,r=e.d,q=-1,p=-1,o=0;o<s;++o){n=r.aI(o)
m=r.aG(o)
l=r.aE(o)
k=r.aN(o)
if(n===a&&m===b&&l===c&&k===d)return o
j=a-n
i=b-m
h=c-l
g=d-k
f=j*j+i*i+h*h+g*g
if(p===-1){p=o
q=f}else if(f<q){p=o
q=f}}return p},
e9(){var s,r,q,p,o,n,m,l=this
if(l.c==null)return l.d
s=l.d
r=s.a
q=new A.b6(new Uint8Array(r*4),r,4)
for(p=0;p<r;++p){o=s.aI(p)
n=s.aG(p)
m=s.aE(p)
q.cu(p,o,n,m,p===l.c?0:255)}return q}}
A.dR.prototype={
hh(a){var s,r,q,p,o,n,m=this
m.a=a.k()
m.b=a.k()
m.c=a.k()
m.d=a.k()
s=a.D()
m.e=(s&64)!==0
if((s&128)!==0){m.f=A.n4(B.a.M(1,(s&7)+1))
for(r=0;q=m.f,r<q.b;++r){p=J.c(a.a,a.d++)
o=J.c(a.a,a.d++)
n=J.c(a.a,a.d++)
q.d.b1(r,p,o,n)}}m.y=a.d-a.b}}
A.fM.prototype={}
A.cL.prototype={}
A.iy.prototype={
aA(a){var s,r
this.r=A.q(a,!1,null,0)
this.a=new A.cL(A.m([],t.b))
try{s=this.eW()
return s}catch(r){return!1}},
au(a){return A.J(new A.iB(this,a))},
iO(a){var s,r,q,p,o,n,m,l,k,j,i=this
i.r=A.q(a,!1,null,0)
i.a=new A.cL(A.m([],t.b))
if(!i.eW())return null
p=i.a
A.ag(p.a,p.b,i.b,!0)
try{while(p=i.r,o=p.d,o<p.c){n=p.a
p.d=o+1
s=J.c(n,o)
switch(s){case 44:r=i.fc()
if(r==null){p=i.a
return p}p=r
p.r=i.f
p.w=i.d
if(i.c!==0){if(r.f==null&&i.a.e!=null){p=i.a.e
o=p.a
n=p.b
m=p.c
p=p.d
r.f=new A.dQ(o,n,m,new A.b6(new Uint8Array(A.t(p.c)),p.a,p.b))}if(r.f!=null)r.f.c=i.e}i.a.r.push(r)
break
case 33:p=i.r
q=J.c(p.a,p.d++)
if(J.aG(q,255)){p=i.r
if(p.ag(J.c(p.a,p.d++))==="NETSCAPE2.0"){l=J.c(p.a,p.d++)
k=J.c(p.a,p.d++)
if(l===3&&k===1)i.w=p.k()}else i.cP()}else if(J.aG(q,249)){p=i.r
p.toString
i.jB(p)}else i.cP()
break
case 59:p=i.a
return p
default:break}}}catch(j){}return i.a},
jB(a){var s,r,q,p=this
a.D()
s=a.D()
p.f=a.k()
p.e=a.D()
a.D()
p.d=B.a.j(s,2)&7
p.c=s&1
r=a.cv(1,0)
if(J.c(r.a,r.d)===44){++a.d
q=p.fc()
if(q==null)return
q.r=p.f
q.w=p.d
r=p.c!==0
q.x=r?p.e:-1
if(r){r=q.f
if(r==null&&p.a.e!=null){r=p.a.e
r.toString
r=q.f=A.py(r)}if(r!=null)r.c=p.e}p.a.r.push(q)}},
ab(a){return A.J(new A.iz(this,a))},
iN(a){var s,r,q,p=this,o=p.r
if(o==null||p.a==null)return null
s=p.a.r
r=s.length
if(a>=r)return null
q=s[a]
s=q.y
s===$&&A.b()
o.d=s
return p.ij(q)},
aS(a,b){return A.J(new A.iA(this,a,b))},
iM(a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5=null
if(a4.au(a6)==null)return a5
s=a4.a
r=s.r.length
if(r===1)return a4.ab(0)
new A.bh(a4.b).bL(0,s.a*r,s.b)
for(s=t.p,q=a5,p=q,o=0;r=a4.a.r,o<r.length;++o){a7=r[o]
n=a4.ab(o)
if(n==null)return a5
n.y=a7.r*10
if(p==null||q==null){n.r=a4.w
q=n
p=q
continue}r=n.a
m=r==null
l=m?a5:r.a
if(l==null)l=0
k=q.a
j=k==null
i=j?a5:k.a
h=!1
if(l===(i==null?0:i)){r=m?a5:r.b
if(r==null)r=0
m=j?a5:k.b
if(r===(m==null?0:m)){r=a7.a
r===$&&A.b()
if(r===0){r=a7.b
r===$&&A.b()
r=r===0&&a7.w===2}else r=h}else r=h}else r=h
if(r){p.aY(n)
q=n
continue}g=a7.f
if(!(g!=null)){r=a4.a.e
r.toString
g=r}r=j?a5:k.a
if(r==null)r=0
m=j?a5:k.b
if(m==null)m=0
f=A.Q(a5,a5,B.e,0,B.i,m,a5,0,1,g.e9(),B.e,r,!1)
r=a7.w
if(r===2){r=f.a
e=r==null?a5:J.C(r.gA(r))
if(e==null){r=f.a
r=r==null?a5:r.gA(r)
if(r==null)r=B.c.gA(new Uint8Array(0))
e=J.C(r)}r=a7.x
m=e.length
if(r!==-1)B.c.an(e,0,m,r)
else{r=a4.a.c.a
B.c.an(e,0,m,!B.c.gac(r)?r[0]:0)}}else if(r!==3)if(a7.f!=null){r=q.a
d=r==null?a5:r.gP()
c=A.O(s,s)
for(r=d.a,b=0;b<r;++b)c.l(0,b,g.kC(d.aI(b),d.aG(b),d.aE(b),d.aN(b)))
r=f.a
a=r==null?a5:J.C(r.gA(r))
if(a==null){r=f.a
r=r==null?a5:r.gA(r)
if(r==null)r=B.c.gA(new Uint8Array(0))
a=J.C(r)}r=q.a
a0=r==null?a5:J.C(r.gA(r))
if(a0==null){r=q.a
r=r==null?a5:r.gA(r)
if(r==null)r=B.c.gA(new Uint8Array(0))
a0=J.C(r)}for(a1=a.length,r=a.$flags|0,a2=0;a2<a1;++a2){a3=c.n(0,a0[a2])
if(a3!=null&&a3!==-1){r&2&&A.a(a)
a[a2]=a3}}}f.y=n.y
r=a7.a
r===$&&A.b()
m=a7.b
m===$&&A.b()
a4.hV(n,f,r,m)
p.aY(f)
q=f}return p},
fc(){var s,r=this.r
if(r.d>=r.c)return null
s=new A.fM()
s.hh(r);++this.r.d
this.cP()
return s},
ij(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=null
if(f.x==null){f.x=new Uint8Array(256)
f.y=new Uint8Array(4095)
f.z=new Uint8Array(4096)
f.Q=new Uint32Array(4096)}s=f.as=f.r.D()
r=B.a.Y(1,s)
f.fr=r;++r
f.dy=r
f.dx=r+1;++s
f.db=s
f.cy=B.a.Y(1,s)
f.ch=0
f.cx=4098
f.ax=f.ay=0
s=f.x
s.toString
s.$flags&2&&A.a(s)
s[0]=0
s=f.Q
s.toString
B.l.an(s,0,4096,4098)
s=a.c
s===$&&A.b()
r=a.d
r===$&&A.b()
q=a.a
q===$&&A.b()
p=f.a
if(q+s<=p.a){q=a.b
q===$&&A.b()
q=q+r>p.b}else q=!0
if(q)return e
o=a.f
if(!(o!=null)){q=p.e
q.toString
o=q}f.at=s*r
n=A.Q(e,e,B.e,0,B.i,r,e,0,1,o.e9(),B.e,s,!1)
m=new Uint8Array(s)
q=a.e
q===$&&A.b()
if(q){q=a.b
q===$&&A.b()
for(r=q+r,l=0,k=0;l<4;++l)for(j=q+B.cs[l];j<r;j+=B.dN[l],++k){if(!f.eS(m))return n
p=n.a
i=p==null
h=i?e:p.a
g=j*(h==null?0:h)
p=i?e:J.C(p.gA(p))
if(p==null){p=n.a
p=p==null?e:p.gA(p)
if(p==null)p=B.c.gA(new Uint8Array(0))
p=J.C(p)}B.c.aK(p,g,g+s,m)}}else for(j=0;j<r;++j){if(!f.eS(m))return n
q=n.a
p=q==null
i=p?e:q.a
g=j*(i==null?0:i)
q=p?e:J.C(q.gA(q))
if(q==null){q=n.a
q=q==null?e:q.gA(q)
if(q==null)q=B.c.gA(new Uint8Array(0))
q=J.C(q)}B.c.aK(q,g,g+s,m)}return n},
hV(a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=a0.a,c=d==null?null:d.gP(),b=c.a,a=J.e5(b,t.y)
for(s=0;s<b;++s)a[s]=c.aN(s)!==0
r=a0.T()
q=a1.T()
p=a0.gX()
o=a1.gX()
n=a1.gR()
d=a0.a
m=a.length
l=q.$flags|0
k=d==null
j=0
for(;;){i=k?null:d.b
if(!(j<(i==null?0:i)))break
h=j+a3
if(h>=n)break
for(g=j*p,i=h*o,f=0;f<p;++f,++g){e=f+a2
if(e>=o)break
s=r[g]
if(s<m&&a[s]){l&2&&A.a(q)
q[i+e]=s}}++j}},
eW(){var s,r,q,p,o,n=this,m=n.r.ag(6)
if(m!=="GIF87a"&&m!=="GIF89a")return!1
s=n.a
s.toString
s.a=n.r.k()
s=n.a
s.toString
s.b=n.r.k()
r=n.r.D()
s=n.a
s.toString
s.c=new A.aW(new Uint8Array(A.t(A.m([n.r.D()],t.t))));++n.r.d
if((r&128)!==0){s=n.a
s.toString
s.e=A.n4(B.a.M(1,(r&7)+1))
for(q=0;q<n.a.e.b;++q){s=n.r
p=J.c(s.a,s.d++)
s=n.r
o=J.c(s.a,s.d++)
s=n.r
r=J.c(s.a,s.d++)
n.a.e.d.b1(q,p,o,r)}}n.a.toString
return!0},
eS(a){var s=this,r=s.at
r.toString
s.at=r-a.length
if(!s.iv(a))return!1
if(s.at===0)s.cP()
return!0},
cP(){var s,r,q,p=this.r
if(p.d>=p.c)return!0
s=p.D()
for(;;){if(s!==0){p=this.r
p=p.d<p.c}else p=!1
if(!p)break
p=this.r
r=p.d+=s
if(r>=p.c)return!0
q=p.a
p.d=r+1
s=J.c(q,r)}return!0},
iv(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.ch
if(f>4095)return!1
s=a.length
r=0
if(f!==0){q=a.$flags|0
for(;;){if(!(f!==0&&r<s))break
p=r+1
o=g.y
o===$&&A.b()
f=g.ch=f-1
o=o[f]
q&2&&A.a(a)
a[r]=o
r=p}}for(f=a.$flags|0;r<s;){n=g.CW=g.iu()
if(n==null)return!1
q=g.dy
if(n===q)return!1
o=g.fr
if(n===o){for(o=g.Q,m=0;m<=4095;++m){o.toString
o.$flags&2&&A.a(o)
o[m]=4098}g.dx=q+1
q=g.as+1
g.db=q
g.cy=B.a.Y(1,q)
g.cx=4098}else{if(n<o){p=r+1
f&2&&A.a(a)
a[r]=n
r=p}else{q=g.Q
if(q[n]===4098){l=g.dx-2
if(n===l){n=g.cx
k=g.z
k===$&&A.b()
j=g.y
j===$&&A.b()
i=g.ch++
o=g.dw(q,n,o)
j.$flags&2&&A.a(j)
j[i]=o
k.$flags&2&&A.a(k)
k[l]=o}else return!1}m=0
for(;;){h=m+1
if(!(m<=4095&&n>g.fr&&n<=4095))break
q=g.y
q===$&&A.b()
o=g.ch++
l=g.z
l===$&&A.b()
l=l[n]
q.$flags&2&&A.a(q)
q[o]=l
n=g.Q[n]
m=h}if(h>=4095||n>4095)return!1
q=g.y
q===$&&A.b()
o=g.ch
l=g.ch=o+1
q.$flags&2&&A.a(q)
q[o]=n
o=l
for(;;){if(!(o!==0&&r<s))break
p=r+1
o=g.ch=o-1
l=q[o]
f&2&&A.a(a)
a[r]=l
r=p}}q=g.cx
if(q!==4098&&g.Q[g.dx-2]===4098){o=g.Q
o.toString
l=g.dx-2
o.$flags&2&&A.a(o)
o[l]=q
k=g.CW
j=g.z
i=g.fr
if(k===l){j===$&&A.b()
q=g.dw(o,q,i)
j.$flags&2&&A.a(j)
j[l]=q}else{j===$&&A.b()
k.toString
q=g.dw(o,k,i)
j.$flags&2&&A.a(j)
j[l]=q}}q=g.CW
q.toString
g.cx=q}}return!0},
iu(){var s,r,q,p,o=this
if(o.db>12)return null
while(s=o.ay,r=o.db,s<r){s=o.hK()
s.toString
r=o.ax
q=o.ay
o.ax=(r|B.a.Y(s,q))>>>0
o.ay=q+8}q=o.ax
p=B.e1[r]
o.ax=B.a.U(q,r)
o.ay=s-r
s=o.dx
if(s<4097){++s
o.dx=s
s=s>o.cy&&r<12}else s=!1
if(s){o.cy=o.cy<<1>>>0
o.db=r+1}return q&p},
dw(a,b,c){var s,r,q=0
for(;;){if(b>c){s=q+1
r=q<=4095
q=s}else r=!1
if(!r)break
if(b>4095)return 4098
b=a[b]}return b},
hK(){var s,r,q=this,p=q.x,o=p[0],n=p.$flags|0
if(o===0){o=q.r.D()
n&2&&A.a(p)
p[0]=o
p=q.x
o=p[0]
if(o===0)return null
B.c.aK(p,1,1+o,q.r.a1(o).T())
p=q.x
s=p[1]
p.$flags&2&&A.a(p)
p[1]=2
p[0]=p[0]-1}else{r=p[1]
n&2&&A.a(p)
p[1]=r+1
s=p[r]
p[0]=o-1}return s}}
A.iB.prototype={
$0(){return this.a.iO(this.b)},
$S:26}
A.iz.prototype={
$0(){return this.a.iN(this.b)},
$S:1}
A.iA.prototype={
$0(){return this.a.iM(this.b,this.c)},
$S:1}
A.cN.prototype={
a6(){return"IcoType."+this.b}}
A.iI.prototype={}
A.fx.prototype={}
A.iD.prototype={
gR(){return B.a.V(A.b9.prototype.gR.call(this),2)},
gcg(){return!(this.d===40&&this.f===32)&&A.b9.prototype.gcg.call(this)}}
A.iE.prototype={
aA(a){var s,r=this,q=A.q(a,!1,null,0)
r.a=q
try{r.b=A.n6(q)}catch(s){r.b=null}return r.b!=null},
au(a){return A.J(new A.iH(this,a))},
aS(a,b){return A.J(new A.iG(this,a,b))},
iR(a,b){var s,r,q,p,o,n,m=this,l=null
if(m.au(a)==null)return l
s=m.b.e.length
if(s===1)return m.ab(0)
r=new A.bh(m.c)
for(q=l,p=0;p<m.b.e.length;++p){b=m.ab(p)
if(b==null)continue
s=b.a
o=s==null
n=o?l:s.a
if(n==null)n=0
s=o?l:s.b
r.bL(0,n,s==null?0:s)
if(q==null){b.w=B.i
q=b}else q.aY(b)}return q},
ab(a){return A.J(new A.iF(this,a))},
iS(b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=this,b0=null,b1=a9.a
if(b1!=null){s=a9.b
s=s==null||b2>=s.d}else s=!0
if(s)return b0
r=a9.b.e[b2]
s=b1.a
b1=b1.b+r.e
q=r.d
p=J.lx(s,b1,b1+q)
b1=a9.c
o=A.nw(b1)
t.D.a(p)
if(o.aA(p))return o.aS(p,0)
n=A.jl(14)
n.h2(19778)
n.d7(q)
n.d7(0)
n.d7(0)
s=A.q(p,!1,b0,0)
q=A.mS(A.q(J.aj(B.c.gA(n.c),0,n.a),!1,b0,0))
m=s.d
l=s.i()
k=s.i()
j=$.N()
j.$flags&2&&A.a(j)
j[0]=k
k=$.a_()
i=k[0]
j[0]=s.i()
k=k[0]
h=s.k()
g=s.k()
f=s.i()
if(f>=14)A.X(A.i("Unsupported BMP compression type: "+f))
f=B.bc[f]
s.i()
j[0]=s.i()
j[0]=s.i()
j=s.i()
s.i()
e=new A.iD(q,i,k,l,h,g,f,j,m)
e.ek(s,q)
if(l!==40&&h!==1)return b0
d=j===0&&g<=8?40+4*B.a.M(1,g):40+4*j
q.b=d
n.a-=4
n.d7(d)
c=A.q(p,!1,b0,0)
b=new A.ik(!0,b1)
b.a=c
b.b=e
a=b.ab(0)
if(g>=32)return a
a0=32-B.a.a9(i,32)
a1=B.a.V(a0===32?i:i+a0,8)
for(b1=k<0,s=k===0,k=1/k<0,a2=0;a2<B.a.V(A.b9.prototype.gR.call(e),2);++a2){if(!(s?k:b1))a3=a2
else{q=a.a
q=q==null?b0:q.b
a3=(q==null?0:q)-1-a2}a4=c.aq(a1)
c.d=c.d+(a4.c-a4.d)
q=a.a
a5=q==null?b0:q.K(0,a3,b0)
if(a5==null)a5=new A.D()
for(a6=0;a6<i;){a7=J.c(a4.a,a4.d++)
a8=7
for(;;){if(!(a8>-1&&a6<i))break
if((a7&B.a.Y(1,a8))>>>0!==0)a5.sv(0)
a5.E();++a6;--a8}}}return a}}
A.iH.prototype={
$0(){var s=this.a,r=A.q(this.b,!1,null,0)
s.a=r
return s.b=A.n6(r)},
$S:5}
A.iG.prototype={
$0(){return this.a.iR(this.b,this.c)},
$S:1}
A.iF.prototype={
$0(){return this.a.iS(this.b)},
$S:1}
A.fh.prototype={}
A.bV.prototype={}
A.bW.prototype={}
A.cM.prototype={}
A.j9.prototype={
hu(a){var s,r,q,p,o,n,m,l=this,k=null,j="ifd0",i=l.a,h=i.y
if(h.n(0,j).a.am(274)){s=h.n(0,j).gbt()
s.toString
r=s}else r=0
q=r>=5&&r<=8
p=q?l.c:l.b
s=A.Q(k,k,B.e,0,B.i,q?l.b:l.c,k,0,3,k,B.e,p,!1)
s.e=A.dK(h)
s.gbj().n(0,j).sbt(k)
s.c=i.x
l.d!==$&&A.y()
l.d=s
i=s.a
i=J.C(i.gA(i))
l.e!==$&&A.y()
l.e=i
o=s.a.gaw()
n=l.b-1
m=l.c-1
i=l.f
switch(r){case 2:i!==$&&A.y()
l.f=n*3
l.r!==$&&A.y()
l.r=-3
l.w!==$&&A.y()
l.w=o
break
case 3:i!==$&&A.y()
l.f=m*o+n*3
l.r!==$&&A.y()
l.r=-3
l.w!==$&&A.y()
l.w=-o
break
case 4:i!==$&&A.y()
l.f=m*o
l.r!==$&&A.y()
l.r=3
l.w!==$&&A.y()
l.w=-o
break
case 5:i!==$&&A.y()
l.f=0
l.r!==$&&A.y()
l.r=o
l.w!==$&&A.y()
l.w=3
break
case 6:i!==$&&A.y()
l.f=m*3
l.r!==$&&A.y()
l.r=o
l.w!==$&&A.y()
l.w=-3
break
case 7:i!==$&&A.y()
l.f=n*o+m*3
l.r!==$&&A.y()
l.r=-o
l.w!==$&&A.y()
l.w=-3
break
case 8:i!==$&&A.y()
l.f=n*o
l.r!==$&&A.y()
l.r=-o
l.w!==$&&A.y()
l.w=3
break
default:i!==$&&A.y()
l.f=0
l.r!==$&&A.y()
l.r=3
l.w!==$&&A.y()
l.w=o
break}},
h0(c2,c3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9=this,c0=b9.a,c1=c0.ax
switch(c1.length){case 1:s=c1[0]
r=s.f
q=s.r
c0=b9.f
c0===$&&A.b()
p=b9.w
p===$&&A.b()
o=c0+c2*p
for(c0=b9.b,n=b9.r,m=b9.e,l=s.e,k=c2;k<c3;++k,o+=p){j=l[B.a.j(k,q)]
j.toString
i=o
h=0
while(h<c0){g=j[B.a.a0(h,r)]
m===$&&A.b()
m.$flags&2&&A.a(m)
m[i]=g
m[i+1]=g
m[i+2]=g;++h
n===$&&A.b()
i+=n}}break
case 3:c0=c0.e
f=c0==null||c0.d===1
s=c1[0]
e=c1[1]
d=c1[2]
r=s.f
q=s.r
c=e.f
b=e.r
a=d.f
a0=d.r
a1=$.mL()
c0=b9.f
c0===$&&A.b()
p=b9.w
p===$&&A.b()
o=c0+c2*p
for(c0=b9.b,n=b9.r,m=b9.e,l=s.e,j=e.e,a2=d.e,k=c2;k<c3;++k,o+=p){a3=l[B.a.j(k,q)]
a3.toString
a4=j[B.a.j(k,b)]
a4.toString
a5=a2[B.a.j(k,a0)]
a5.toString
if(f){i=o
h=0
while(h<c0){g=(a3[B.a.a0(h,r)]<<8>>>0)+65536
a6=a4[B.a.a0(h,c)]-128
a7=a5[B.a.a0(h,a)]-128
m===$&&A.b()
a8=a1[B.a.j(g+359*a7,8)]
m.$flags&2&&A.a(m)
m[i]=a8
m[i+1]=a1[B.a.j(g-88*a6-183*a7,8)]
m[i+2]=a1[B.a.j(g+454*a6,8)];++h
n===$&&A.b()
i+=n}}else{i=o
h=0
while(h<c0){m===$&&A.b()
a8=a3[B.a.a0(h,r)]
m.$flags&2&&A.a(m)
m[i]=a8
m[i+1]=a4[B.a.a0(h,c)]
m[i+2]=a5[B.a.a0(h,a)];++h
n===$&&A.b()
i+=n}}}break
case 4:c0=c0.e
if(c0==null)throw A.e(A.i("Unsupported color mode (4 components)"))
c0=c0.d===0
s=c1[0]
e=c1[1]
d=c1[2]
a9=c1[3]
r=s.f
q=s.r
c=e.f
b=e.r
a=d.f
a0=d.r
b0=a9.f
b1=a9.r
a1=$.mL()
p=b9.f
p===$&&A.b()
n=b9.w
n===$&&A.b()
o=p+c2*n
for(p=b9.b,m=b9.r,l=b9.e,j=s.e,a2=e.e,a3=d.e,a4=a9.e,k=c2;k<c3;++k,o+=n){a5=j[B.a.j(k,q)]
a5.toString
a8=a2[B.a.j(k,b)]
a8.toString
b2=a3[B.a.j(k,a0)]
b2.toString
b3=a4[B.a.j(k,b1)]
b3.toString
i=o
h=0
while(h<p){b4=b3[B.a.a0(h,b0)]
if(c0){b5=a5[B.a.a0(h,r)]
b6=a8[B.a.a0(h,c)]
g=b2[B.a.a0(h,a)]}else{b7=(a5[B.a.a0(h,r)]<<8>>>0)+65536
a6=a8[B.a.a0(h,c)]-128
a7=b2[B.a.a0(h,a)]-128
b5=255-a1[B.a.j(b7+359*a7,8)]
b6=255-a1[B.a.j(b7-88*a6-183*a7,8)]
g=255-a1[B.a.j(b7+454*a6,8)]}l===$&&A.b()
b8=B.a.j(b5*b4,8)
l.$flags&2&&A.a(l)
l[i]=b8
l[i+1]=B.a.j(b6*b4,8)
l[i+2]=B.a.j(g*b4,8);++h
m===$&&A.b()
i+=m}}break
default:throw A.e(A.i("Unsupported color mode"))}}}
A.j6.prototype={}
A.c3.prototype={}
A.fX.prototype={
la(a){var s,r,q,p,o,n=this,m=A.q(a,!0,null,0)
n.c=m
s=m.cv(2,0)
if(J.c(s.a,s.d)!==255||J.c(s.a,s.d+1)!==216)return!1
if(n.bI()!==216)return!1
r=n.bI()
q=!1
p=!1
for(;;){if(r!==217){m=n.c
m=m.d<m.c}else m=!1
if(!m)break
o=n.c.k()
if(o<2)break
m=n.c
m.d=m.d+(o-2)
switch(r){case 192:case 193:case 194:q=!0
break
case 218:if(q)return!0
p=!0
break}r=n.bI()}return q&&p},
bu(a){var s,r,q,p,o,n,m=this
m.c=A.q(a,!0,null,0)
m.jt()
if(m.Q.length!==1)throw A.e(A.i("Only single frame JPEGs supported"))
s=m.f
s.toString
if(m.cy!=null)return
if(!m.ay){m.ay=!0
s.kR(m.b===8)}for(r=s.z,q=s.y,p=m.ax,o=0;o<r.length;++o){n=q.n(0,r[o])
p.push(A.n_(n.a,s.f,n.b,s.r,m.hL(s,n)))}},
gd8(){var s,r=this.f.d
r.toString
s=this.b
return B.a.a5(r+s-1,s)},
jt(){var s,r,q,p,o,n=this
n.ch=0
if(n.bI()!==216)throw A.e(A.i("Start Of Image marker not found."))
s=n.bI()
for(;;){if(s!==217){r=n.c
r===$&&A.b()
r=r.d<r.c}else r=!1
if(!r)break
A:{if(s>=208&&s<=215||s===1){s=n.bI()
break A}r=n.c
r===$&&A.b()
q=r.k()
if(q<2)A.X(A.i("Invalid Block"))
r=n.c
p=r.aq(q-2)
r.d=r.d+(p.c-p.d)
switch(s){case 224:case 225:case 226:case 227:case 228:case 229:case 230:case 231:case 232:case 233:case 234:case 235:case 236:case 237:case 238:case 239:case 254:n.ju(s,p)
break
case 219:n.jw(p)
break
case 192:case 193:case 194:n.jz(s,p)
break
case 195:case 197:case 198:case 199:case 200:case 201:case 202:case 203:case 205:case 206:case 207:throw A.e(A.i("Unhandled frame type "+B.a.d5(s,16)))
case 196:n.jv(p)
break
case 221:n.r=p.k()
break
case 218:n.jO(p)
break
case 255:r=n.c
if(J.c(r.a,r.d)!==255)--n.c.d
break
default:r=n.c
o=!1
if(J.c(r.a,r.d+-3)===255){r=n.c
if(J.c(r.a,r.d+-2)>=192){r=n.c
r=J.c(r.a,r.d+-2)<=254}else r=o}else r=o
if(r){n.c.d-=3
break}if(s!==0)throw A.e(A.i("Unknown JPEG marker "+B.a.d5(s,16)))
break}s=n.bI()}}},
bI(){var s,r=this,q=r.c
q===$&&A.b()
if(q.d>=q.c)return 0
do{do{s=r.c.D()
if(s!==255){q=r.c
q=q.d<q.c}else q=!1}while(q)
q=r.c
if(q.d>=q.c)return s
do{s=r.c.D()
if(s===255){q=r.c
q=q.d<q.c}else q=!1}while(q)
if(s===0){q=r.c
q=q.d<q.c}else q=!1}while(q)
return s},
jG(a){var s
for(s=0;s<12;++s)if(J.c(a.a,a.d++)!==B.iR[s])return
this.x=new A.bb("ICC_PROFILE",B.a2,a.T())},
jx(a){if(a.i()!==1165519206)return
if(a.k()!==0)return
this.y.bu(a)},
ju(a,b){var s,r,q,p,o,n=this,m=b
if(n.cy!=null)s=a===225||a===238
else s=!1
if(s)n.cx=!0
if(a===224){s=m
r=!1
if(J.c(s.a,s.d)===74){s=m
if(J.c(s.a,s.d+1)===70){s=m
if(J.c(s.a,s.d+2)===73){s=m
if(J.c(s.a,s.d+3)===70){s=m
s=J.c(s.a,s.d+4)===0}else s=r}else s=r}else s=r}else s=r
if(s){s=new A.ja()
r=m
J.c(r.a,r.d+5)
r=m
J.c(r.a,r.d+6)
r=m
J.c(r.a,r.d+7)
r=m
J.c(r.a,r.d+8)
r=m
J.c(r.a,r.d+9)
r=m
J.c(r.a,r.d+10)
r=m
J.c(r.a,r.d+11)
r=m
r=J.c(r.a,r.d+12)
s.f=r
q=m
q=J.c(q.a,q.d+13)
s.r=q
n.d=s
m.cv(14+3*r*q,14)}}else if(a===225)n.jx(m)
else if(a===226)n.jG(m)
else if(a===238){s=m
r=!1
if(J.c(s.a,s.d)===65){s=m
if(J.c(s.a,s.d+1)===100){s=m
if(J.c(s.a,s.d+2)===111){s=m
if(J.c(s.a,s.d+3)===98){s=m
if(J.c(s.a,s.d+4)===101){s=m
s=J.c(s.a,s.d+5)===0}else s=r}else s=r}else s=r}else s=r}else s=r
if(s){p=new A.j6()
s=m
J.c(s.a,s.d+6)
s=m
J.c(s.a,s.d+7)
s=m
J.c(s.a,s.d+8)
s=m
J.c(s.a,s.d+9)
s=m
J.c(s.a,s.d+10)
s=m
p.d=J.c(s.a,s.d+11)
n.e=p}}else if(a===254)try{m.kX()}catch(o){}},
jw(a){var s,r,q,p,o,n,m,l,k
for(s=a.c,r=this.z;q=a.d,p=q<s,p;){p=a.a
a.d=q+1
o=J.c(p,q)
n=B.a.j(o,4)
o&=15
if(o>=4)throw A.e(A.i("Invalid number of quantization tables"))
q=r[o]
if(q==null){q=new Int16Array(64)
r[o]=q}for(p=n!==0,m=0;m<64;++m){l=p?a.k():J.c(a.a,a.d++)
k=$.i6()[m]
q.$flags&2&&A.a(q)
q[k]=l}}if(p)throw A.e(A.i("Bad length for DQT block"))},
jz(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
if(i.f!=null)throw A.e(A.i("Duplicate JPG frame data found."))
s=A.O(t.p,t.d2)
r=A.m([],t.t)
q=new A.fY(s,r)
q.b=a===194
q.c=b.D()
q.d=b.k()
q.e=b.k()
p=b.D()
for(o=i.z,n=0;n<p;++n){m=J.c(b.a,b.d++)
l=J.c(b.a,b.d++)
k=B.a.j(l,4)
j=J.c(b.a,b.d++)
r.push(m)
s.l(0,m,new A.c3(k&15,l&15,o,j))}i.kc(q)
i.f=q
i.Q.push(q)},
kc(a){var s,r,q,p=a.e
p.toString
s=a.d
s.toString
if(p===0||s===0)throw A.e(A.i("Invalid JPEG dimensions "+p+"x"+s))
r=this.a
if(r>0&&p*s>r)throw A.e(A.i("JPEG dimensions "+p+"x"+s+" exceed the maximum of "+r+" pixels"))
p=a.y
s=p.a
if(s===0||s>4)throw A.e(A.i("Unsupported number of JPEG components: "+s))
for(p=new A.bz(p,p.r,p.e,A.j(p).m("bz<2>"));p.E();){s=p.d
r=s.a
q=!0
if(r>=1)if(r<=4){s=s.b
s=s<1||s>4}else s=q
else s=q
if(s)throw A.e(A.i("Invalid JPEG sampling factor"))}},
jv(a){var s,r,q,p,o,n,m,l,k,j,i,h
for(s=a.c,r=this.at,q=this.as;p=a.d,p<s;){o=a.a
a.d=p+1
n=J.c(o,p)
m=new Uint8Array(16)
for(l=0,k=0;k<16;++k){m[k]=J.c(a.a,a.d++)
l+=m[k]}j=a.aq(l)
a.d=a.d+(j.c-j.d)
i=j.T()
if((n&16)!==0){n-=16
h=q}else h=r
if(h.length<=n)B.k.sp(h,n+1)
h[n]=this.iY(m,i)}},
jO(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this
if(++a.ch>1000)throw A.e(A.i("Too many JPEG scans"))
s=a0.D()
if(s<1||s>4)throw A.e(A.i("Invalid SOS block"))
r=a.f
r.toString
q=A.m([],t.b7)
for(p=a.as,o=a.at,n=r.y,m=0;m<s;++m){l=J.c(a0.a,a0.d++)
k=J.c(a0.a,a0.d++)
if(!n.am(l))throw A.e(A.i("Invalid Component in SOS block"))
j=n.n(0,l)
j.toString
i=B.a.j(k,4)&15
h=k&15
if(i<o.length){g=o[i]
g.toString
j.Q=g
j.at=A.ov(g)}if(h<p.length){g=p[h]
g.toString
j.as=g
j.ax=A.ov(g)}q.push(j)}f=a0.D()
e=a0.D()
d=a0.D()
p=B.a.j(d,4)
o=r.b
o.toString
if(o&&a.b===8&&f>0)return
if(a.cy!=null)throw A.e(B.c_)
c=!1
if(!a.ay){a.ay=!0
o=n.n(0,r.z[0])
o.toString
if(a.CW){j=r.b
j.toString
if(!j){j=q.length
if(j===n.a)if(j<=1)o=o.a===1&&o.b===1
else o=!0
else o=c
c=o}}r.fO(c,a.b===8)
if(c)a.jZ(r)}o=a.c
o===$&&A.b()
n=a.r
b=new A.fZ(o,r,q,n,f,e,p&15,d&15,new Int16Array(64))
p=r.w
p===$&&A.b()
b.f=p
b.r=r.b
if(c)b.ay=a.gi6()
b.bp()},
iY(a,b){var s,r,q,p,o,n,m,l=A.m([],t.e8),k=16
for(;;){if(!(k>0&&a[k-1]===0))break;--k}s=t.en
l.push(new A.dp(A.a0(2,null,!1,s)))
r=l[0]
for(q=0,p=0;p<k;){for(o=0;o<a[p];++o){r=l.pop()
r.a[r.b]=new A.cM(b[q])
while(n=r.b,n>0)r=l.pop()
r.b=n+1
l.push(r)
for(;l.length<=p;r=m){n=A.a0(2,null,!1,s)
m=new A.dp(n)
l.push(m)
r.a[r.b]=new A.bW(n)}++q}++p
if(p<k){n=A.a0(2,null,!1,s)
m=new A.dp(n)
l.push(m)
r.a[r.b]=new A.bW(n)
r=m}}return l[0].a},
hL(a,b){var s,r,q,p,o,n,m,l,k=b.e
k===$&&A.b()
s=b.f
s===$&&A.b()
r=B.a.a5(8,this.b)
q=k*r
p=new Int32Array(64)
o=new Uint8Array(64)
n=A.a0(s*r,null,!1,t.aD)
for(m=0;m<s;++m){for(k=m*r,l=0;l<r;++l)n[k+l]=new Uint8Array(q)
this.er(b,m,n,k,o,p)}b.x=new Int16Array(0)
return n},
er(a,b,c,d,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=B.a.a5(8,this.b),e=a.x
e===$&&A.b()
s=a.r
s===$&&A.b()
r=a.c[a.d]
r.toString
q=f===8
p=f===1
s=b*s
o=0
for(;;){n=a.e
n===$&&A.b()
if(!(o<n))break
A:{m=s+o
l=m<<6>>>0
if(p){k=e[a.y?m:l]
n=c[d]
n.toString
j=128+B.b.bA((B.b.bA((5793*B.b.bA((5793*(k*r[0])+512)/1024)+8192)/16384)+8)/16)
if(j<0)i=0
else i=j>255?255:j
n.$flags&2&&A.a(n)
n[o]=i
break A}A.u3(r,e,l,a0,a1)
h=o*f
if(q)for(n=h+8,g=0;g<8;++g){i=c[d+g]
if(i!=null)B.c.a_(i,h,n,a0,g<<3>>>0)}else A.pM(a0,f,c,d,h)}++o}},
kw(a){var s,r,q,p=this
p.CW=!0
try{p.bu(a)}catch(s){if(A.ar(s) instanceof A.hX)return p.eH(a)
else throw s}r=p.cy
if(r==null)return A.ot(p)
if(p.cx)return p.eH(a)
q=r.d
q===$&&A.b()
q.c=p.x
return q},
eH(a){var s=A.lK()
s.a=this.a
s.b=this.b
s.bu(a)
return A.ot(s)},
jZ(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=B.a.a5(8,c.b),a=c.db
B.k.cU(a)
for(s=a0.z,r=s.length,q=t.h,p=a0.y,o=c.ax,n=t.aD,m=0;m<s.length;s.length===r||(0,A.a5)(s),++m){l=p.n(0,s[m])
k=l.a
j=a0.f
i=l.b
h=a0.r
g=l.f
g===$&&A.b()
o.push(A.n_(k,j,i,h,A.a0(g*b,null,!1,n)))
f=i*b
e=A.m(new Array(f),q)
for(k=l.e,d=0;d<f;++d){k===$&&A.b()
e[d]=new Uint8Array(k*b)}a.push(e)}c.cy=A.no(c)},
i7(a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5=a4.f
a5.toString
s=B.a.a5(8,a4.b)
for(r=a5.z,q=a4.dx,p=a4.dy,o=a5.y,n=a4.ax,m=a4.db,l=0;l<r.length;++l){k=o.n(0,r[l])
j=n[l].e
i=m[l]
for(h=k.b,g=a6*h,f=0;f<h;++f){e=g+f
d=k.f
d===$&&A.b()
if(e>=d)break
for(d=e*s,c=f*s,b=0;b<s;++b)j[d+b]=i[c+b]
a4.er(k,f,j,d,q,p)}h=k.x
h===$&&A.b()
g=a4.fr
d=h.length
if(g.length<d)g=a4.fr=new Int16Array(d)
B.S.aK(h,0,d,g)}a=a5.r*s
a0=a6*a
a1=Math.min(a0+a,a4.gd8())
if(a0<a1)a4.cy.h0(a0,a1)
for(l=0;l<r.length;++l){k=o.n(0,r[l])
j=n[l].e
a5=k.b
a2=a6*a5*s
a5=a2+a5*s
q=j.length
a3=a2
for(;;){if(!(a3<a5&&a3<q))break
j[a3]=null;++a3}}}}
A.dp.prototype={}
A.hX.prototype={}
A.fY.prototype={
fO(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
for(s=i.y,r=A.j(s).m("ab<1>"),q=new A.ab(s,s.r,s.e,r);q.E();){p=s.n(0,q.d)
i.f=Math.max(i.f,p.a)
i.r=Math.max(i.r,p.b)}q=i.e
q.toString
i.w=B.b.aZ(q/8/i.f)
q=i.d
q.toString
i.x=B.b.aZ(q/8/i.r)
for(r=new A.ab(s,s.r,s.e,r);r.E();){q=s.n(0,r.d)
q.toString
o=i.e
o.toString
n=q.a
m=B.b.aZ(B.b.aZ(o/8)*n/i.f)
o=i.d
o.toString
l=q.b
k=B.b.aZ(B.b.aZ(o/8)*l/i.r)
j=i.w*n
n=i.x
q.e=m
q.f=k
q.r=j
n=q.w=n*l
q.y=b
q.z=a?l:0
o=a?l:n
n=b?1:64
q.x=new Int16Array(j*o*n)}},
kR(a){return this.fO(!1,a)}}
A.ja.prototype={}
A.fZ.prototype={
bp(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=b.y,a0=a.length,a1=b.r
a1.toString
if(a1)if(b.Q===0)s=b.at===0?b.gib():b.gie()
else s=b.at===0?b.gi0():b.gi2()
else s=b.gi8()
a1=a0===1
if(a1){r=a[0]
q=r.e
q===$&&A.b()
r=r.f
r===$&&A.b()
p=q*r}else{r=b.f
r===$&&A.b()
q=b.b.x
q===$&&A.b()
p=r*q}r=b.z
if(r==null||r===0)b.z=p
for(r=b.a,o=0;o<p;){for(n=0;n<a0;++n)a[n].ay=0
b.db=0
if(a1){m=a[0]
l=0
for(;;){q=b.z
q.toString
if(!(l<q))break
q=m.e
q===$&&A.b()
k=B.a.a5(o,q)
j=B.a.a9(o,q)
q=m.z
q=q>0?B.a.a9(k,q):k
i=m.r
i===$&&A.b()
b.eJ(m,s,q*i+j);++o
if(b.ay!=null&&B.a.a9(o,m.e)===0)b.dL(B.a.a5(o,m.e));++l}}else{l=0
for(;;){q=b.z
q.toString
if(!(l<q))break
for(n=0;n<a0;++n){m=a[n]
h=m.a
g=m.b
for(f=0;f<g;++f)for(e=0;e<h;++e)b.ik(m,s,o,f,e)}++o
if(b.ay!=null){q=b.f
q===$&&A.b()
q=B.a.a9(o,q)===0}else q=!1
if(q){q=b.f
q===$&&A.b()
b.dL(B.a.a5(o,q))}++l}}b.cx=b.CW=0
q=b.cy=!1
if(o>=p)break
d=J.c(r.a,r.d)
c=J.c(r.a,r.d+1)
if(d===255)if(c>=208?c<=215:q)r.d+=2
else break}if(b.ay!=null){if(a1){a=a[0].f
a===$&&A.b()}else{a=b.b.x
a===$&&A.b()}b.dL(a)}},
dL(a){var s,r
while(s=this.ch,s<a){r=this.ay
r.toString
this.ch=s+1
r.$1(s)}},
ds(){var s,r,q=this,p=q.a,o=p.c
for(;;){if(!(q.cx<=24&&!q.cy))break
s=p.d
if(s>=o){q.cy=!0
break}r=J.c(p.a,s)
if(r===255){s=p.d
if(o-s<2||J.c(p.a,s+1)!==0){q.cy=!0
break}p.d+=2}else ++p.d
q.CW=(q.CW<<8|r)>>>0
q.cx+=8}},
bV(){var s=this,r=s.cx
if(r===0){s.ds()
r=s.cx
if(r===0)return null}--r
s.cx=r
return B.a.U(s.CW,r)&1},
c9(a,b){var s,r,q,p,o,n=this
if(n.cx<9)n.ds()
s=n.cx
if(s>=9){r=b[B.a.U(n.CW,s-9)&511]
if(r!==0){n.cx=s-(r>>>8)
return r&255}}for(q=a;;){p=n.bV()
if(p==null)return null
o=q[p]
if(o instanceof A.cM)return o.a
if(!(o instanceof A.bW))return null
q=o.a}},
dI(a){var s=this,r=s.cx
if(r<a){s.ds()
r=s.cx
if(r<a){s.cx=0
return null}}r-=a
s.cx=r
return(B.a.U(s.CW,r)&B.a.M(1,a)-1)>>>0},
cb(a){var s
if(a==null)return 0
if(a===1)return this.bV()===1?1:-1
s=this.dI(a)
if(s==null)return 0
if(s>=B.a.Y(1,a-1))return s
return s+B.a.M(-1,a)+1},
i9(a,b,c){var s,r,q,p,o,n,m,l=this,k=a.Q
k===$&&A.b()
s=a.at
s===$&&A.b()
r=l.c9(k,s)
q=r===0?0:l.cb(r)
k=a.ay
k===$&&A.b()
k+=q
a.ay=k
b.$flags&2&&A.a(b)
b[c]=k
for(p=1;p<64;){k=a.as
k===$&&A.b()
s=a.ax
s===$&&A.b()
o=l.c9(k,s)
if(o==null)break
n=o&15
m=o>>>4
if(n===0){if(m<15)break
p+=16
continue}p+=m
n=l.cb(n)
b[c+$.i6()[p]]=n;++p}},
ic(a,b,c){var s,r,q,p=a.Q
p===$&&A.b()
s=a.at
s===$&&A.b()
r=this.c9(p,s)
q=r===0?0:B.a.M(this.cb(r),this.ax)
p=a.ay
p===$&&A.b()
p+=q
a.ay=p
b.$flags&2&&A.a(b)
b[c]=p},
ig(a,b,c){var s=b[c],r=this.bV()
r.toString
r=B.a.M(r,this.ax)
b.$flags&2&&A.a(b)
b[c]=(s|r)>>>0},
i1(a,b,c){var s,r,q,p,o,n,m,l,k=this,j=k.db
if(j>0){k.db=j-1
return}s=k.Q
r=k.as
for(j=k.ax,q=b.$flags|0;s<=r;){p=a.as
p===$&&A.b()
o=a.ax
o===$&&A.b()
o=k.c9(p,o)
o.toString
n=o&15
m=o>>>4
if(n===0){if(m<15){j=k.dI(m)
j.toString
k.db=j+B.a.M(1,m)-1
break}s+=16
continue}s+=m
l=$.i6()[s]
p=k.cb(n)
o=B.a.M(1,j)
q&2&&A.a(b)
b[c+l]=p*o;++s}},
i3(a,b,c){var s,r,q,p,o,n,m,l,k=this,j=k.Q,i=k.as
A:for(s=k.ax,r=b.$flags|0,q=0;j<=i;){p=c+$.i6()[j]
o=k.dx
switch(o){case 0:o=a.as
o===$&&A.b()
n=a.ax
n===$&&A.b()
m=k.c9(o,n)
if(m==null)throw A.e(A.i("Invalid progressive encoding"))
l=m&15
q=m>>>4
if(l===0)if(q<15){o=k.dI(q)
o.toString
k.db=o+B.a.M(1,q)
k.dx=4}else{k.dx=1
q=16}else{if(l!==1)throw A.e(A.i("invalid ACn encoding"))
k.dy=k.cb(l)
k.dx=q!==0?2:3}continue A
case 1:case 2:n=b[p]
if(n!==0){o=k.bV()
o.toString
o=B.a.M(o,s)
r&2&&A.a(b)
b[p]=n+o}else{--q
if(q===0)k.dx=o===2?3:0}break
case 3:o=b[p]
if(o!==0){n=k.bV()
n.toString
n=B.a.M(n,s)
r&2&&A.a(b)
b[p]=o+n}else{o=k.dy
o===$&&A.b()
o=B.a.M(o,s)
r&2&&A.a(b)
b[p]=o
k.dx=0}break
case 4:o=b[p]
if(o!==0){n=k.bV()
n.toString
n=B.a.M(n,s)
r&2&&A.a(b)
b[p]=o+n}break}++j}if(k.dx===4)if(--k.db===0)k.dx=0},
ik(a,b,c,d,e){var s,r,q,p=this.f
p===$&&A.b()
s=B.a.a5(c,p)*a.b+d
r=B.a.a9(c,p)*a.a+e
p=a.w
p===$&&A.b()
if(s<p){p=a.r
p===$&&A.b()
p=r>=p}else p=!0
if(p)return
p=a.z
p=p>0?B.a.a9(s,p):s
q=a.r
q===$&&A.b()
this.eJ(a,b,p*q+r)},
eJ(a,b,c){var s,r,q=a.x
q===$&&A.b()
if(!a.y){b.$3(a,q,c<<6>>>0)
return}s=this.fr
r=q[c]
s.$flags&2&&A.a(s)
s[0]=r
b.$3(a,s,0)
r=s[0]
q.$flags&2&&A.a(q)
q[c]=r}}
A.j7.prototype={
aA(a){var s,r
if(a.length<2||a[0]!==255||a[1]!==216)return!1
try{s=A.lK().la(a)
return s}catch(r){return!1}},
aS(a,b){return A.J(new A.j8(this,a,b))},
bZ(a){return this.aS(a,null)}}
A.j8.prototype={
$0(){var s=A.lK()
s.a=this.a.a
s.b=1
return s.kw(this.b)},
$S:1}
A.d7.prototype={
a6(){return"PngDisposeMode."+this.b}}
A.eq.prototype={
a6(){return"PngBlendMode."+this.b}}
A.er.prototype={}
A.fN.prototype={}
A.bB.prototype={
a6(){return"PngFilterType."+this.b}}
A.ju.prototype={}
A.j1.prototype={}
A.jq.prototype={
aA(a){var s
if(a.length<8)return!1
for(s=0;s<8;++s)if(a[s]!==B.bd[s])return!1
return!0},
au(a){return A.J(new A.jt(this,a))},
ji(b8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=this,b6=null,b7=A.q(b8,!0,b6,0)
b5.e=b7
s=b7.a1(8)
for(r=0;r<8;++r)if(J.c(s.a,s.d+r)!==B.bd[r])return b6
for(b7=b5.a,q=b7.cy,p=t.t,o=b7.db,n=t.L,m=b5.b,l=b7.ax;;){k=b5.e
j=k.d-k.b
i=k.i()
h=b5.e.ag(4)
switch(h){case"tEXt":k=b5.e
g=k.aq(i)
k.d=k.d+(g.c-g.d)
f=g.T()
e=f.length
for(r=0;r<e;++r)if(f[r]===0){k=r+1
l.l(0,B.aB.bZ(new Uint8Array(f.subarray(0,A.i2(0,r,e)))),B.aB.bZ(new Uint8Array(f.subarray(k,A.i2(k,b6,e)))))
break}b5.e.d+=4
break
case"pHYs":k=b5.e
g=k.aq(i)
k.d=k.d+(g.c-g.d)
d=A.r(g,b6,0)
d.i()
d.i()
J.c(d.a,d.d++)
b5.e.d+=4
break
case"IHDR":k=b5.e
g=k.aq(i)
k.d=k.d+(g.c-g.d)
c=A.r(g,b6,0)
b=c.T()
b7.a=c.i()
k=c.i()
b7.b=k
A.ag(b7.a,k,m,!1)
b7.c=J.c(c.a,c.d++)
b7.d=J.c(c.a,c.d++)
J.c(c.a,c.d++)
b7.f=J.c(c.a,c.d++)
b7.r=J.c(c.a,c.d++)
k=b7.d
if(!(k===0||k===2||k===3||k===4||k===6))return b6
if(b7.f!==0)return b6
switch(k){case 0:if(!B.k.bo(A.m([1,2,4,8,16],p),b7.c))return b6
break
case 2:if(!B.k.bo(A.m([8,16],p),b7.c))return b6
break
case 3:if(!B.k.bo(A.m([1,2,4,8],p),b7.c))return b6
break
case 4:if(!B.k.bo(A.m([8,16],p),b7.c))return b6
break
case 6:if(!B.k.bo(A.m([8,16],p),b7.c))return b6
break}if(b5.e.i()!==A.cv(b,A.cv(new A.aV(h),0)))throw A.e(A.i("Invalid "+h+" checksum"))
break
case"PLTE":k=b5.e
g=k.aq(i)
k.d=k.d+(g.c-g.d)
b7.w=g.T()
if(b5.e.i()!==A.cv(n.a(b7.w),A.cv(new A.aV(h),0)))throw A.e(A.i("Invalid "+h+" checksum"))
break
case"tRNS":k=b5.e
g=k.aq(i)
k.d=k.d+(g.c-g.d)
b7.x=g.T()
a=b5.e.i()
k=b7.x
k.toString
if(a!==A.cv(k,A.cv(new A.aV(h),0)))throw A.e(A.i("Invalid "+h+" checksum"))
break
case"IEND":b5.e.d+=4
break
case"gAMA":if(i!==4)throw A.e(A.i("Invalid gAMA chunk"))
b5.e.i()
b5.e.d+=4
break
case"IDAT":o.push(j)
k=b5.e
k.d=(k.d+=i)+4
break
case"acTL":b7.CW=b5.e.i()
b5.e.i()
b5.e.d+=4
break
case"fcTL":b5.e.i()
a0=b5.e.i()
a1=b5.e.i()
a2=b5.e.i()
a3=b5.e.i()
a4=b5.e.k()
a5=b5.e.k()
k=b5.e
a6=J.c(k.a,k.d++)
k=b5.e
a7=J.c(k.a,k.d++)
k=B.cM[a6]
a8=B.fe[a7]
q.push(new A.fN(A.m([],p),a0,a1,a2,a3,a4,a5,k,a8))
b5.e.d+=4
break
case"fdAT":b5.e.i()
B.k.gcX(q).y.push(j)
k=b5.e
k.d=(k.d+=i-4)+4
break
case"bKGD":k=b7.d
if(k===3){k=b5.e
a9=J.c(k.a,k.d++);--i
b0=a9*3
k=b7.w
b1=k[b0]
b2=k[b0+1]
b3=k[b0+2]
k=b7.x
if(k!=null){k=B.c.bo(k,a9)?0:255
a8=new Uint8Array(4)
a8[0]=b1
a8[1]=b2
a8[2]=b3
a8[3]=k
b7.z=new A.bO(a8)}else{k=new Uint8Array(3)
k[0]=b1
k[1]=b2
k[2]=b3
b7.z=new A.fg(k)}}else if(k===0||k===4){b5.e.k()
i-=2}else if(k===2||k===6){k=b5.e
k.k()
k.k()
k.k()
i-=24}if(i>0)b5.e.d+=i
b5.e.d+=4
break
case"iCCP":b7.Q=b5.e.cm()
k=b5.e
J.c(k.a,k.d++)
k=b7.Q
a8=b5.e
g=a8.aq(i-(k.length+2))
a8.d=a8.d+(g.c-g.d)
b7.at=g.T()
b5.e.d+=4
break
case"cICP":k=b5.e
a8=k.d
if(i===4){b4=k.a
k.d=a8+1
J.c(b4,a8)
a8=b5.e
J.c(a8.a,a8.d++)
a8=b5.e
J.c(a8.a,a8.d++)
a8=b5.e
J.c(a8.a,a8.d++)}else k.d=a8+i
b5.e.d+=4
break
default:k=b5.e
k.d=(k.d+=i)+4
break}if(h==="IEND")break
k=b5.e
if(k.d>=k.c)return b6}return b7},
ab(a){return A.J(new A.jr(this,a))},
jh(c0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3=this,b4=null,b5=b3.a,b6=b5.a,b7=b5.b,b8=b5.cy,b9=b8.length
if(b9===0||c0===0){m=A.m([],t.h)
b8=b5.db
l=b8.length
for(k=0,j=0;j<l;++j){b9=b3.e
b9===$&&A.b()
b9.d=b8[j]
i=b9.i()
h=b3.e.ag(4)
b9=b3.e
g=b9.aq(i)
b9.d=b9.d+(g.c-g.d)
f=g.T()
k+=f.length
m.push(f)
if(b3.e.i()!==A.cv(f,A.cv(new A.aV(h),0)))throw A.e(A.i("Invalid "+h+" checksum"))}e=new Uint8Array(k)
for(b8=m.length,d=0,c=0;c<m.length;m.length===b8||(0,A.a5)(m),++c){f=m[c]
B.c.ec(e,d,f)
d+=f.length}}else{if(c0>=b9)throw A.e(A.i("Invalid Frame Number: "+c0))
b=b8[c0]
b6=b.b
b7=b.c
A.ag(b6,b7,b3.b,!1)
m=A.m([],t.h)
for(b8=b.y,k=0,j=0;j<b8.length;++j){b9=b3.e
b9===$&&A.b()
b9.d=b8[j]
i=b9.i()
b9=b3.e
b9.ag(4)
b9.d+=4
b9=b3.e
g=b9.aq(i-4)
b9.d=b9.d+(g.c-g.d)
f=g.T()
k+=f.length
m.push(f)}e=new Uint8Array(k)
for(b8=m.length,d=0,c=0;c<m.length;m.length===b8||(0,A.a5)(m),++c){f=m[c]
B.c.ec(e,d,f)
d+=f.length}}b8=b5.d
a=1
if(!(b8===3))if(!(b8===0)){if(b8===4)b8=2
else b8=b8===6?4:3
a=b8}b8=A.iT(e,B.a1,b4,b4)
s=A.nh(new A.fF(b8,B.O,!1,B.aw))
b3.d=b3.c=0
a0=b4
if(b5.d===3){b8=b5.w
if(b8!=null){a1=b8.length/3|0
a2=b5.x
b9=a2!=null
a3=b9?a2.length:0
a4=b9?4:3
a0=new A.b6(new Uint8Array(a1*a4),a1,a4)
for(b9=a4===4,j=0,a5=0;j<a1;++j,a5+=3){a6=b9&&j<a3?a2[j]:255
a0.cu(j,b8[a5],b8[a5+1],b8[a5+2],a6)}}}if(b5.d===0&&b5.x!=null&&a0==null&&b5.c<=8){a2=b5.x
a7=a2.length
b8=b5.c
a1=B.a.Y(1,b8)
b9=new Uint8Array(a1*4)
a0=new A.b6(b9,a1,4)
if(b8===1)a8=255
else if(b8===2)a8=85
else{b8=b8===4?17:1
a8=b8}for(j=0;j<a1;++j){a9=j*a8
a0.cu(j,a9,a9,a9,255)}for(j=0;j<a7;j+=2){b0=(a2[j]&255)<<8|a2[j+1]&255
if(b0<a1)b9[b0*4+3]=0}}b8=b5.c
if(b8===1)b1=B.u
else if(b8===2)b1=B.x
else{if(b8===4)b9=B.y
else b9=b8===16?B.m:B.e
b1=b9}b9=b5.d
if(b9===0&&b5.x!=null&&b8>8)a=4
r=A.Q(b4,b4,b1,0,B.i,b7,b4,0,b9===2&&b5.x!=null?4:a,a0,B.e,b6,!1)
q=b5.a
p=b5.b
b5.a=b6
b5.b=b7
o=b6
n=b7
b3.f=0
try{if(b5.r!==0){b3.bJ(s,r,0,0,8,8,B.b.j(o+7,3),B.b.j(n+7,3))
b3.bJ(s,r,4,0,8,8,B.b.j(o+3,3),B.b.j(n+7,3))
b3.bJ(s,r,0,4,4,8,B.b.j(o+3,2),B.b.j(n+3,3))
b3.bJ(s,r,2,0,4,4,B.b.j(o+1,2),B.b.j(n+3,2))
b3.bJ(s,r,0,2,2,4,B.b.j(o+1,1),B.b.j(n+1,2))
b3.bJ(s,r,1,0,2,2,B.b.j(o,1),B.b.j(n+1,1))
b3.bJ(s,r,0,1,1,2,o,B.b.j(n,1))}else b3.jn(s,r)}catch(b2){b8=A.ar(b2)
if(b8 instanceof A.f7)return b4
else if(b8 instanceof A.ba)return b4
else if(b8 instanceof A.hZ)return b4
else throw b2}finally{s.fA()
b5.a=q
b5.b=p}b8=b5.at
if(b8!=null)r.c=new A.bb(b5.Q,B.ch,b8)
b5=b5.ax
if(b5.a!==0)r.ki(b5)
return r},
aS(a,b){return A.J(new A.js(this,a,b))},
jg(a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null
if(a.au(a1)==null)return a0
s=a.a
r=s.cy
q=r.length
if(q===0||a2!=null)return a.ab(a2==null?0:a2)
p=Math.min(s.CW,q)
new A.bh(a.b).bL(0,s.a*p,s.b)
for(q=t.g,o=a0,n=o,m=0;m<p;++m){a2=r[m]
l=a.ab(m)
if(l==null)continue
if(n==null||o==null){n=l.dV(l.gbs())
k=a2.f
n.y=B.b.h((k===0||a2.r===0?0:k/a2.r)*1000)
o=n
continue}k=m-1
j=r[k]
i=l.a
h=i==null
g=h?a0:i.a
if(g==null)g=0
f=o.a
e=f==null
d=e?a0:f.a
if(g===(d==null?0:d)){i=h?a0:i.b
if(i==null)i=0
h=e?a0:f.b
i=i===(h==null?0:h)&&a2.d===0&&a2.e===0&&a2.x===B.bl}else i=!1
if(i){k=a2.f
l.y=B.b.h((k===0||a2.r===0?0:k/a2.r)*1000)
n.aY(l)
o=l
continue}c=n.x
o=A.aK((c===$?n.x=A.m([],q):c)[k],!1,!1)
b=j.w
if(b===B.bn){k=j.d
i=j.e
h=s.z
if(h==null){h=new Uint8Array(4)
g=new A.bO(h)
h[0]=0
h[1]=0
h[2]=0
h[3]=0
h=g}A.or(o,!1,h,k,k+j.b-1,i,i+j.c-1)}else if(b===B.bo&&m>1){c=n.x
if(c===$)c=n.x=A.m([],q)
k=j.d
i=j.e
h=j.b
g=j.c
o=A.mr(o,c[m-2],B.aa,g,h,k,i,g,h,k,i)}k=a2.f
o.y=B.b.h((k===0||a2.r===0?0:k/a2.r)*1000)
k=a2.x===B.bm?B.aa:B.a0
o=A.mr(o,l,k,a0,a0,a2.d,a2.e,a0,a0,a0,a0)
n.aY(o)}return n},
gdG(){var s=this.a.d
if(s===4)s=2
else if(s===2)s=3
else s=s===6?4:1
return s},
bJ(a,b,a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this
if(a4===0||a5===0)return
s=c.gdG()
r=c.a.c
q=s*r
p=B.a.j(q+7,3)
o=B.a.V(q*a4+7,8)
n=r===8||r===16
m=A.m([0,0,0,0],t.t)
for(l=a1,k=null,j=null,i=0;i<a5;++i,l+=a3,++c.f,j=g){h=B.ba[a.D()]
g=a.a1(o).T()
s=g.length
if(s!==o)throw A.e(B.aC)
c.fi(h,p,g,j)
if(n){c.fm(g,b,l,a0,a2,a4)
continue}c.d=c.c=0
f=new A.a6(g,0,Math.min(s,s),0,!0)
for(e=a0,d=0;d<a4;++d,e+=a2){c.f9(f,m)
s=b.a
k=s==null?null:s.K(e,l,k)
if(k==null)k=new A.D()
c.fb(k,m)}}},
jn(a,a0){var s,r,q,p,o,n,m,l=this,k=l.gdG(),j=l.a,i=j.c,h=k*i,g=j.a,f=j.b,e=B.a.V(g*h+7,8),d=B.a.j(h+7,3),c=i===8||i===16,b=A.m([0,0,0,0],t.t)
k=a0.a
s=k.gF(k)
s.E()
for(r=null,q=0;q<f;++q,r=o){p=B.ba[a.D()]
o=a.a1(e).T()
k=o.length
if(k!==e)throw A.e(B.aC)
l.fi(p,d,o,r)
if(c){l.fm(o,a0,q,0,1,g)
continue}l.d=l.c=0
n=new A.a6(o,0,Math.min(k,k),0,!0)
for(m=0;m<g;++m){l.f9(n,b)
l.fb(s.gJ(),b)
s.E()}}},
fm(a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this.gdG(),d=a1.a,c=d.c,b=this.a,a=b.x
if(b.c===8){s=J.C(d.gA(d))
r=a2*a1.a.gaw()+a3*c
q=a4*c
if(c===e){if(a4===1){B.c.aK(s,r,r+a5*e,a0)
return}for(d=s.$flags|0,p=0,o=0;p<a5;++p,r+=q)for(n=0;n<e;++n,o=m){m=o+1
b=a0[o]
d&2&&A.a(s)
s[r+n]=b}return}l=(a[0]&255)<<8|a[1]&255
k=(a[2]&255)<<8|a[3]&255
j=(a[4]&255)<<8|a[5]&255
for(d=s.$flags|0,p=0,o=0;p<a5;++p,o+=3,r+=q){i=a0[o]
h=a0[o+1]
g=a0[o+2]
d&2&&A.a(s)
s[r]=i
s[r+1]=h
s[r+2]=g
b=i===l&&h===k&&g===j?0:255
s[r+3]=b}return}s=t.cV.a(d).d
r=(a2*a1.gX()+a3)*c
q=a4*c
if(c===e)for(d=s.$flags|0,p=0,o=0;p<a5;++p,r+=q)for(n=0;n<e;++n,o+=2){b=a0[o]
f=a0[o+1]
d&2&&A.a(s)
s[r+n]=(b<<8|f)>>>0}else if(e===3){l=(a[0]&255)<<8|a[1]&255
k=(a[2]&255)<<8|a[3]&255
j=(a[4]&255)<<8|a[5]&255
for(d=s.$flags|0,p=0,o=0;p<a5;++p,o+=6,r+=q){i=(a0[o]<<8|a0[o+1])>>>0
h=(a0[o+2]<<8|a0[o+3])>>>0
g=(a0[o+4]<<8|a0[o+5])>>>0
d&2&&A.a(s)
s[r]=i
s[r+1]=h
s[r+2]=g
b=i===l&&h===k&&g===j?0:65535
s[r+3]=b}}else{k=(a[0]&255)<<8|a[1]&255
for(d=s.$flags|0,p=0,o=0;p<a5;++p,o+=2,r+=q){h=(a0[o]<<8|a0[o+1])>>>0
d&2&&A.a(s)
s[r]=h
s[r+1]=h
s[r+2]=h
b=h===k?0:65535
s[r+3]=b}}},
fi(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h=c.length,g=b<h?b:h
switch(a.a){case 0:break
case 1:for(s=c.$flags|0,r=b;r<h;++r){q=c[r]
p=c[r-b]
s&2&&A.a(c)
c[r]=q+p}break
case 2:if(d!=null)for(s=c.$flags|0,r=0;r<h;++r){q=c[r]
p=d[r]
s&2&&A.a(c)
c[r]=q+p}break
case 3:if(d==null)for(s=c.$flags|0,r=b;r<h;++r){q=c[r]
p=c[r-b]
s&2&&A.a(c)
c[r]=q+(p>>>1)}else{for(s=c.$flags|0,r=0;r<g;++r){q=c[r]
p=d[r]
s&2&&A.a(c)
c[r]=q+(p>>>1)}for(r=b;r<h;++r){q=c[r]
p=c[r-b]
o=d[r]
s&2&&A.a(c)
c[r]=q+(p+o>>>1)}}break
case 4:if(d==null)for(s=c.$flags|0,r=b;r<h;++r){q=c[r]
p=c[r-b]
s&2&&A.a(c)
c[r]=q+p}else{for(s=c.$flags|0,r=0;r<g;++r){q=c[r]
p=d[r]
s&2&&A.a(c)
c[r]=q+p}for(r=b;r<h;++r){q=r-b
n=c[q]
m=d[r]
l=d[q]
k=m-l
j=n-l
i=k+j
if(k<0)k=-k
if(j<0)j=-j
if(i<0)i=-i
q=c[r]
if(k<=j&&k<=i)p=n
else p=j<=i?m:l
s&2&&A.a(c)
c[r]=q+p}}break}},
bf(a,b){var s,r,q,p,o,n=this
if(b===0)return 0
if(b===8)return a.D()
if(b===16)return a.k()
for(s=a.c;r=n.d,r<b;){r=a.d
if(r>=s)throw A.e(A.i("Invalid PNG data."))
q=a.a
a.d=r+1
p=J.c(q,r)
r=n.d
n.c=B.a.Y(p,r)
n.d=r+8}if(b===1)o=1
else if(b===2)o=3
else{if(b===4)s=15
else s=0
o=s}s=r-b
r=B.a.U(n.c,s)
n.d=s
return r&o},
f9(a,b){var s=this,r=s.a,q=r.d
switch(q){case 0:b[0]=s.bf(a,r.c)
return
case 2:b[0]=s.bf(a,r.c)
b[1]=s.bf(a,r.c)
b[2]=s.bf(a,r.c)
return
case 3:b[0]=s.bf(a,r.c)
return
case 4:b[0]=s.bf(a,r.c)
b[1]=s.bf(a,r.c)
return
case 6:b[0]=s.bf(a,r.c)
b[1]=s.bf(a,r.c)
b[2]=s.bf(a,r.c)
b[3]=s.bf(a,r.c)
return}throw A.e(A.i("Invalid color type: "+q+"."))},
fb(a,b){var s,r,q,p,o,n,m,l=this.a,k=l.d
switch(k){case 0:k=l.x
if(k!=null&&l.c>8){l=k[0]
k=k[1]
s=b[0]
a.ae(s,s,s,s!==((l&255)<<8|k&255)?a.gC():0)
return}a.ap(b[0],0,0)
return
case 2:r=b[0]
s=b[1]
q=b[2]
l=l.x
if(l!=null){k=l[0]
p=l[1]
o=l[2]
n=l[3]
m=l[4]
l=l[5]
if(r!==((k&255)<<8|p&255)||s!==((o&255)<<8|n&255)||q!==((m&255)<<8|l&255)){a.ae(r,s,q,a.gC())
return}}a.ap(r,s,q)
return
case 3:a.sL(b[0])
return
case 4:a.ae(b[0],0,0,b[1])
return
case 6:a.ae(b[0],b[1],b[2],b[3])
return}throw A.e(A.i("Invalid color type: "+k+"."))}}
A.jt.prototype={
$0(){return this.a.ji(this.b)},
$S:5}
A.jr.prototype={
$0(){return this.a.jh(this.b)},
$S:1}
A.js.prototype={
$0(){return this.a.jg(this.b,this.c)},
$S:1}
A.hZ.prototype={}
A.bC.prototype={
a6(){return"PnmFormat."+this.b}}
A.ck.prototype={}
A.jv.prototype={
aA(a){var s
this.b=A.q(a,!1,null,0)
s=this.cK()
if(s==="P1"||s==="P2"||s==="P5"||s==="P3"||s==="P6")return!0
return!1},
aS(a,b){return A.J(new A.jy(this,a,b))},
jj(a,b){if(this.au(a)==null)return null
return this.ab(0)},
au(a){return A.J(new A.jz(this,a))},
jl(a){var s,r,q,p=this
p.b=A.q(a,!1,null,0)
s=p.cK()
if(s==="P1"){r=p.a=new A.ck(B.X)
r.e=B.bp}else if(s==="P2"){r=p.a=new A.ck(B.X)
r.e=B.bq}else if(s==="P5"){r=p.a=new A.ck(B.X)
r.e=B.ao}else if(s==="P3"){r=p.a=new A.ck(B.X)
r.e=B.br}else if(s==="P6"){r=p.a=new A.ck(B.X)
r.e=B.ap}else return p.b=null
r.a=p.ca()
r=p.a
r.toString
r.b=p.ca()
r=p.a
q=r.a
if(q<1||r.b<1)return p.a=p.b=null
A.ag(q,r.b,p.d,!1)
return p.a},
ab(a){return A.J(new A.jx(this,a))},
jk(a){var s,r,q,p,o,n=this,m=null,l=n.a
if(l==null)return m
l=l.e
if(l===B.bp){n.dg(1)
l=n.a
s=l.a
r=A.Q(m,m,B.u,0,B.i,l.b,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gF(l);l.E();){q=l.gJ()
if(n.cK()==="1")q.ap(1,1,1)
else q.ap(0,0,0)}return r}else if(l===B.bq||l===B.ao){p=n.ca()
if(p===0)return m
n.dg(1)
l=n.a
s=l.a
l=l.b
r=A.Q(m,m,n.fG(p),0,B.i,l,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gF(l);l.E();){q=l.gJ()
o=n.cN(n.a.e,p)
q.ap(o,o,o)}return r}else if(l===B.br||l===B.ap){p=n.ca()
if(p===0)return m
n.dg(3)
l=n.a
s=l.a
l=l.b
r=A.Q(m,m,n.fG(p),0,B.i,l,m,0,3,m,B.e,s,!1)
for(l=r.a,l=l.gF(l);l.E();)l.gJ().ap(n.cN(n.a.e,p),n.cN(n.a.e,p),n.cN(n.a.e,p))
return r}return m},
dg(a){var s,r=this.a,q=r.a
r=r.b
s=this.b
if(s.c-s.d+this.c.gp(0)<q*r*a)throw A.e(A.i("Truncated PNM data"))},
fG(a){if(a>255)return B.m
if(a>15)return B.e
if(a>3)return B.y
if(a>1)return B.x
return B.u},
cN(a,b){if(a===B.ao||a===B.ap)return this.b.D()
return this.ca()},
ca(){var s,r,q=this.cK()
if(J.bM(q)===0)return 0
try{s=A.tW(q)
return s}catch(r){return 0}},
cK(){var s,r,q,p,o=this.b
if(o==null)return""
s=this.c
if(!s.gac(0))return s.fT()
r=B.D.fZ(o.kW())
if(r.length===0)return""
while(B.D.eh(r,"#"))r=B.D.fZ(this.b.fR(70))
o=t.cc
q=A.p(new A.eH(A.m(r.split(" "),t.s),new A.jw(),o),o.m("d.E"))
for(o=q.length,p=0;p<o;++p)if(B.D.eh(q[p],"#")){B.k.sp(q,p)
break}s.dP(0,q)
if(s.b===s.c)return""
return s.fT()}}
A.jy.prototype={
$0(){return this.a.jj(this.b,this.c)},
$S:1}
A.jz.prototype={
$0(){return this.a.jl(this.b)},
$S:5}
A.jx.prototype={
$0(){return this.a.jk(this.b)},
$S:1}
A.jw.prototype={
$1(a){return a!==""},
$S:29}
A.hf.prototype={}
A.hg.prototype={}
A.b7.prototype={}
A.hi.prototype={}
A.hj.prototype={}
A.hm.prototype={}
A.hn.prototype={}
A.es.prototype={}
A.hl.prototype={}
A.jA.prototype={
hv(a){var s,r,q,p,o=this
a.k()
a.k()
a.k()
a.k()
s=B.a.V(a.c-a.d,8)
if(s>0){o.e=new Uint16Array(s)
o.f=new Uint16Array(s)
o.r=new Uint16Array(s)
o.w=new Uint16Array(s)
for(r=0;r<s;++r){q=o.e
p=a.k()
q.$flags&2&&A.a(q)
q[r]=p
p=o.f
q=a.k()
p.$flags&2&&A.a(p)
p[r]=q
q=o.r
p=a.k()
q.$flags&2&&A.a(q)
q[r]=p
p=o.w
q=a.k()
p.$flags&2&&A.a(p)
p[r]=q}}}}
A.db.prototype={
fQ(a,b,c,d,e,f,g){if(a.c-a.d<2)return
if(e==null)e=a.k()
switch(e){case 0:d.toString
this.jN(a,b,c,d)
break
case 1:if(f==null)f=this.jK(a,c)
d.toString
this.jM(a,b,c,d,f,g)
break
default:throw A.e(A.i("Unsupported compression: "+e))}},
kV(a,b,c,d){return this.fQ(a,b,c,d,null,null,0)},
jK(a,b){var s,r=new Uint16Array(b)
for(s=0;s<b;++s)r[s]=a.k()
return r},
jN(a,b,c,d){var s,r=b*c
if(d===16)r*=2
if(r>a.c-a.d){s=new Uint8Array(r)
this.c=s
B.c.an(s,0,r,255)
return}this.c=a.a1(r).T()},
jM(a,b,c,d,e,f){var s,r,q,p,o,n,m=b*c
if(d===16)m*=2
s=new Uint8Array(m)
this.c=s
r=f*c
if(r>=e.length){B.c.an(s,0,m,255)
return}for(q=0,p=0;p<c;++p,r=o){o=r+1
n=a.aq(e[r])
a.d=a.d+(n.c-n.d)
s=this.c
s.toString
this.iq(n,s,q)
q+=b}},
iq(a,b,c){var s,r,q,p,o,n,m,l,k
for(s=a.c,r=b.$flags|0,q=b.length;p=a.d,p<s;){o=a.a
a.d=p+1
p=J.c(o,p)
o=$.ai()
o.$flags&2&&A.a(o)
o[0]=p
n=$.at()[0]
if(n<0){n=1-n
p=a.d
if(p>=s)break
o=a.a
a.d=p+1
m=J.c(o,p)
if(c+n>q)n=q-c
for(l=0;l<n;++l,c=k){k=c+1
r&2&&A.a(b)
b[c]=m}}else{++n
if(c+n>q)n=q-c
n=Math.min(n,s-a.d)
for(l=0;l<n;++l,c=k){k=c+1
p=J.c(a.a,a.d++)
r&2&&A.a(b)
b[c]=p}}}}}
A.b_.prototype={
a6(){return"PsdColorMode."+this.b}}
A.jF.prototype={
gkk(){var s=this.e
s===$&&A.b()
return s},
hw(a,b){var s,r,q=this
q.as=A.q(a,!0,null,0)
q.jr()
if(q.c!==943870035)return
s=q.as.i()
q.as.a1(s)
s=q.as.i()
q.ax=q.as.a1(s)
s=q.as.i()
q.ay=q.as.a1(s)
r=q.as
q.ch=r.a1(r.c-r.d)},
bp(){var s,r=this
if(r.c===943870035){s=r.as
s===$&&A.b()
s=s==null}else s=!0
if(s)return!1
A.ag(r.a,r.b,r.CW,!1)
s=r.e
s===$&&A.b()
if(s<1||s>56)throw A.e(A.i("Invalid number of PSD channels: "+r.gkk()))
r.jI()
r.jJ()
r.jL()
r.ch=r.ay=r.ax=r.as=null
return!0},
kv(){if(!this.bp())return null
return this.l_()},
l_(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=null,a2=a0.y
if(a2!=null)return a2
a2=a0.a
a2=A.Q(a1,a1,B.e,0,B.i,a0.b,a1,0,4,a1,B.e,a2,!1)
a0.y=a2
a2.cU(0)
for(a2=a0.w,s=0;s<a2.length;++s){r=a2[s]
q=r.y
q===$&&A.b()
if((q&2)!==0)continue
q=r.w
q===$&&A.b()
p=q/255
o=r.r
n=r.cx
q=r.a
q.toString
m=q
l=0
for(;;){q=r.f
q===$&&A.b()
if(!(l<q))break
q=r.a
q.toString
k=q+l
j=r.b
q=m>=0
i=0
for(;;){h=r.e
h===$&&A.b()
if(!(i<h))break
h=n.a
g=h==null?a1:h.K(i,l,a1)
if(g==null)g=new A.D()
f=B.b.h(g.gq())
e=B.b.h(g.gt())
d=B.b.h(g.gu())
c=B.b.h(g.gv())
j.toString
if(j>=0&&j<a0.a&&q&&m<a0.b){h=r.b
h.toString
b=a0.y.a
a=b==null?a1:b.K(h+i,k,a1)
if(a==null)a=new A.D()
a0.hG(B.b.h(a.gq()),B.b.h(a.gt()),B.b.h(a.gu()),B.b.h(a.gv()),f,e,d,c,o,p,a)}++i;++j}++l;++m}}a2=a0.y
a2.toString
return a2},
hG(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n=h/255*j
switch(i){case 1885434739:s=d
r=c
q=b
p=a
break
case 1852797549:s=h
r=g
q=f
p=e
break
case 1684632435:s=h
r=g
q=f
p=e
break
case 1684107883:p=Math.min(a,e)
q=Math.min(b,f)
r=Math.min(c,g)
s=h
break
case 1836411936:p=B.a.j(a*e,8)
q=B.a.j(b*f,8)
r=B.a.j(c*g,8)
s=h
break
case 1768188278:p=A.jG(a,e)
q=A.jG(b,f)
r=A.jG(c,g)
s=h
break
case 1818391150:p=A.jI(a,e)
q=A.jI(b,f)
r=A.jI(c,g)
s=h
break
case 1684751212:s=h
r=g
q=f
p=e
break
case 1818850405:p=Math.max(a,e)
q=Math.max(b,f)
r=Math.max(c,g)
s=h
break
case 1935897198:p=A.m1(a,e)
q=A.m1(b,f)
r=A.m1(c,g)
s=h
break
case 1684633120:p=A.jH(a,e)
q=A.jH(b,f)
r=A.jH(c,g)
s=h
break
case 1818518631:p=e+a>255?255:a+e
q=f+b>255?255:b+f
r=g+c>255?255:c+g
s=h
break
case 1818706796:s=h
r=g
q=f
p=e
break
case 1870030194:p=A.m_(a,e,d,h)
q=A.m_(b,f,d,h)
r=A.m_(c,g,d,h)
s=h
break
case 1934387572:p=A.m2(a,e)
q=A.m2(b,f)
r=A.m2(c,g)
s=h
break
case 1749838196:p=A.lY(a,e)
q=A.lY(b,f)
r=A.lY(c,g)
s=h
break
case 1984719220:p=A.m3(a,e)
q=A.m3(b,f)
r=A.m3(c,g)
s=h
break
case 1816947060:p=A.lZ(a,e)
q=A.lZ(b,f)
r=A.lZ(c,g)
s=h
break
case 1884055924:p=A.m0(a,e)
q=A.m0(b,f)
r=A.m0(c,g)
s=h
break
case 1749903736:p=e<255-a?0:255
q=f<255-b?0:255
r=g<255-c?0:255
s=h
break
case 1684629094:p=Math.abs(e-a)
q=Math.abs(f-b)
r=Math.abs(g-c)
s=h
break
case 1936553316:p=A.lX(a,e)
q=A.lX(b,f)
r=A.lX(c,g)
s=h
break
case 1718842722:s=h
r=g
q=f
p=e
break
case 1717856630:s=h
r=g
q=f
p=e
break
case 1752524064:s=h
r=g
q=f
p=e
break
case 1935766560:s=h
r=g
q=f
p=e
break
case 1668246642:s=h
r=g
q=f
p=e
break
case 1819634976:s=h
r=g
q=f
p=e
break
default:s=h
r=g
q=f
p=e}o=1-n
k.sq(B.b.h(a*o+p*n))
k.st(B.b.h(b*o+q*n))
k.su(B.b.h(c*o+r*n))
k.sv(B.b.h(d*o+s*n))},
jr(){var s,r,q=this,p=q.as
p===$&&A.b()
q.c=p.i()
p=q.as.k()
q.d=p
if(p!==1){q.c=0
return}s=q.as.a1(6)
for(r=0;r<6;++r)if(J.c(s.a,s.d+r)!==0){q.c=0
return}q.e=q.as.k()
q.b=q.as.i()
q.a=q.as.i()
q.f=q.as.k()
q.r=B.j3[q.as.k()]},
jI(){var s,r,q,p,o,n=this,m=n.ax
m.d=m.b
for(m=n.z;s=n.ax,s.d<s.c;){r=s.i()
q=n.ax.k()
s=n.ax
p=J.c(s.a,s.d++)
n.ax.ag(p)
if((p&1)===0)++n.ax.d
p=n.ax.i()
s=n.ax
o=s.aq(p)
s.d=s.d+(o.c-o.d)
if((p&1)===1)++n.ax.d
if(r===943868237)m.l(0,q,new A.hh())}},
jJ(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=d.ay
c.d=c.b
s=c.i()
if((s&1)!==0)++s
r=d.ay.a1(s)
c=d.w
B.k.cU(c)
if(s>0){q=r.k()
p=$.ah()
p.$flags&2&&A.a(p)
p[0]=q
o=$.as()[0]
if(o<0)o=-o
for(q=t.N,p=t.hf,n=t.l,m=t.af,l=0;l<o;++l){k=new A.hk(A.O(q,p),A.m([],n),A.m([],m))
k.hx(r)
c.push(k)}}q=d.CW
j=new A.bh(q)
i=d.f===16?2:1
p=d.a
n=d.b
m=d.e
m===$&&A.b()
h=p*n*m*i
for(p=c.length,g=0;g<c.length;c.length===p||(0,A.a5)(c),++g){k=c[g]
n=k.e
n===$&&A.b()
m=k.f
m===$&&A.b()
A.ag(n,m,q,!0)
j.bL(0,k.e,k.f)
m=k.e
n=k.f
f=k.as
f===$&&A.b()
h+=m*n*f.length*i}if(h>Math.max(128*d.at,16777216))throw A.e(A.i("PSD data is too small for its size"))
for(l=0;l<c.length;++l)c[l].kS(r,d)
s=d.ay.i()
e=d.ay.a1(s)
if(s>0){e.k()
e.k()
e.k()
e.k()
e.k()
e.k()
e.D()}},
jL(){var s,r,q,p,o,n,m=this,l=m.ch
l.d=l.b
s=l.k()
if(s===1){l=m.b
r=m.e
r===$&&A.b()
q=l*r
p=new Uint16Array(q)
for(o=0;o<q;++o)p[o]=m.ch.k()}else p=null
m.x=A.m([],t.c)
o=0
for(;;){l=m.e
l===$&&A.b()
if(!(o<l))break
l=m.x
r=m.ch
r.toString
n=o===3?-1:o
n=new A.db(n)
n.fQ(r,m.a,m.b,m.f,s,p,o)
l.push(n);++o}m.y=A.nC(m.r,m.f,m.a,m.b,m.x)}}
A.hh.prototype={}
A.hk.prototype={
hx(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=a3.i(),a2=$.N()
a2.$flags&2&&A.a(a2)
a2[0]=a1
a1=$.a_()
a0.a=a1[0]
a2[0]=a3.i()
a0.b=a1[0]
a2[0]=a3.i()
a0.c=a1[0]
a2[0]=a3.i()
a1=a1[0]
a0.d=a1
a2=a0.b
a2.toString
a0.e=a1-a2
a2=a0.c
a1=a0.a
a1.toString
a0.f=a2-a1
a0.as=A.m([],t.c)
s=a3.k()
for(r=0;r<s;++r){a1=a3.k()
a2=$.ah()
a2.$flags&2&&A.a(a2)
a2[0]=a1
q=$.as()[0]
a3.i()
a0.as.push(new A.db(q))}p=a3.i()
if(p!==943868237)throw A.e(A.i("Invalid PSD layer signature: "+B.a.d5(p,16)))
a0.r=a3.i()
a0.w=a3.D()
a3.D()
a0.y=a3.D()
if(a3.D()!==0)throw A.e(A.i("Invalid PSD layer data"))
o=a3.i()
n=a3.a1(o)
if(o>0){o=n.i()
if(o>0){m=n.a1(o)
a1=m.d
m.i()
m.i()
m.i()
m.i()
m.D()
m.D()
if(m.c-a1===20)m.d+=2
else{m.D()
m.D()
m.i()
m.i()
m.i()
m.i()}}o=n.i()
if(o>0)new A.jA().hv(n.a1(o))
o=n.D()
n.ag(o)
l=4-B.a.a9(o,4)-1
if(l>0)n.d+=l
for(a1=n.c,a2=a0.ay,k=a0.cy,j=t.cE;n.d<a1;){p=n.i()
if(p!==943868237)throw A.e(A.i("PSD invalid signature for layer additional data: "+B.a.d5(p,16)))
i=n.ag(4)
o=n.i()
h=n.aq(o)
g=n.d+(h.c-h.d)
n.d=g
if((o&1)===1)n.d=g+1
a2.l(0,i,A.qg(i,h))
if(i==="lrFX"){f=A.r(j.a(a2.n(0,"lrFX")).b,null,0)
f.k()
e=f.k()
for(d=0;d<e;++d){f.ag(4)
c=f.ag(4)
b=f.i()
if(c==="dsdw"){a=new A.hg()
k.push(a)
a.a=f.i()
f.i()
f.i()
f.i()
f.i()
f.k()
f.k()
f.k()
f.k()
f.k()
f.ag(8)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
f.k()
f.k()
f.k()
f.k()
f.k()}else if(c==="isdw"){a=new A.hj()
k.push(a)
a.a=f.i()
f.i()
f.i()
f.i()
f.i()
f.k()
f.k()
f.k()
f.k()
f.k()
f.ag(8)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
f.k()
f.k()
f.k()
f.k()
f.k()}else if(c==="oglw"){a=new A.hm()
k.push(a)
a.a=f.i()
f.i()
f.i()
f.k()
f.k()
f.k()
f.k()
f.k()
f.ag(8)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
if(a.a===2){f.k()
f.k()
f.k()
f.k()
f.k()}}else if(c==="iglw"){a=new A.hi()
k.push(a)
a.a=f.i()
f.i()
f.i()
f.k()
f.k()
f.k()
f.k()
f.k()
f.ag(8)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
if(a.a===2){J.c(f.a,f.d++)
f.k()
f.k()
f.k()
f.k()
f.k()}}else if(c==="bevl"){a=new A.hf()
k.push(a)
a.a=f.i()
f.i()
f.i()
f.i()
f.ag(8)
f.ag(8)
f.k()
f.k()
f.k()
f.k()
f.k()
f.k()
f.k()
f.k()
f.k()
f.k()
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
if(a.a===2){f.k()
f.k()
f.k()
f.k()
f.k()
f.k()
f.k()
f.k()
f.k()
f.k()}}else if(c==="sofi"){a=new A.hn()
k.push(a)
a.a=f.i()
f.ag(4)
f.k()
f.k()
f.k()
f.k()
f.k()
J.c(f.a,f.d++)
J.c(f.a,f.d++)
f.k()
f.k()
f.k()
f.k()
f.k()}else f.d+=b}}}}},
kS(a,b){var s,r,q,p,o,n=this,m=0
for(;;){s=n.as
s===$&&A.b()
if(!(m<s.length))break
s=s[m]
r=n.e
r===$&&A.b()
q=n.f
q===$&&A.b()
s.kV(a,r,q,b.f);++m}r=b.r
q=b.f
p=n.e
p===$&&A.b()
o=n.f
o===$&&A.b()
n.cx=A.nC(r,q,p,o,s)}}
A.dc.prototype={}
A.jB.prototype={
aA(a){var s,r
try{s=A.nB(a,null).c
return s===943870035}catch(r){return!1}},
aS(a,b){return A.J(new A.jD(this,a,b))},
jq(a,b){var s,r,q,p=this
if(p.au(a)==null)return null
s=p.a==null?null:1
if(s==null)s=0
if(s===1)return p.ab(0)
for(r=null,q=0;q<s;++q){b=p.ab(q)
if(b==null)continue
if(r==null){b.w=B.aH
r=b}else r.aY(b)}return r},
au(a){return A.J(new A.jE(this,a))},
ab(a){return A.J(new A.jC(this,a))}}
A.jD.prototype={
$0(){return this.a.jq(this.b,this.c)},
$S:1}
A.jE.prototype={
$0(){var s=this.a
return s.a=A.nB(this.b,s.b)},
$S:5}
A.jC.prototype={
$0(){var s=this.a.a
return s==null?null:s.kv()},
$S:1}
A.hp.prototype={}
A.de.prototype={}
A.al.prototype={
bN(a,b){var s=this
return new A.al(s.a+b.a,s.b+b.b,s.c+b.c,s.d+b.d)}}
A.et.prototype={
gX(){return this.a},
gR(){return this.b}}
A.dd.prototype={
gR(){return this.f},
gX(){return this.r}}
A.ho.prototype={
gX(){return this.a},
gR(){return this.b}}
A.aL.prototype={
scd(a){var s=this.a,r=this.b
s.$flags&2&&A.a(s)
s[r+1]=a},
co(){var s=this.e,r=this.d
if(s)return new A.de(B.w[r>>>9],B.w[r>>>4&31],B.t[r&15])
else return new A.de(B.t[r>>>7&15],B.t[r>>>3&15],B.a7[r&7])},
cq(){var s=this.e,r=this.d
if(s)return new A.al(B.w[r>>>9],B.w[r>>>4&31],B.t[r&15],255)
else return new A.al(B.t[r>>>7&15],B.t[r>>>3&15],B.a7[r&7],B.a7[r>>>11&7])},
cp(){var s=this.r,r=this.f
if(s)return new A.de(B.w[r>>>10],B.w[r>>>5&31],B.w[r&31])
else return new A.de(B.t[r>>>8&15],B.t[r>>>4&15],B.t[r&15])},
cr(){var s=this.r,r=this.f
if(s)return new A.al(B.w[r>>>10],B.w[r>>>5&31],B.w[r&31],255)
else return new A.al(B.t[r>>>8&15],B.t[r>>>4&15],B.t[r&15],B.a7[r>>>12&7])},
c7(){var s=this,r=s.c?1:0,q=s.d,p=s.e?1:0,o=s.f,n=s.r?1:0
return(r|(q&16383)<<1|p<<15|(o&32767)<<16|n<<31)>>>0},
bi(){var s=this,r=s.a[s.b+1]
s.c=(r&1)===1
s.scd(s.c7())
s.d=r>>>1&16383
s.scd(s.c7())
s.e=(r>>>15&1)===1
s.scd(s.c7())
s.f=r>>>16&32767
s.scd(s.c7())
s.r=(r>>>31&1)===1
s.scd(s.c7())}}
A.jJ.prototype={
aA(a){var s,r
try{s=this.au(a)
return s!=null}catch(r){return!1}},
au(a){return A.J(new A.jM(this,a))},
k_(a){var s,r=this,q=a.length,p=q-(q>>>1&1431655765)>>>0
p=(p&858993459)+(p>>>2&858993459)
if((p+(p>>>4)>>>0&252645135)*16843009>>>0>>>24===1){s=r.i5(a)
if(s!=null){r.a=a
return r.b=s}}s=r.ip(a)
if(s!=null){r.a=a
return r.b=s}s=r.im(a)
if(s!=null){r.a=a
return r.b=s}return null},
ip(a){var s,r,q=A.q(a,!1,null,0)
if(q.c-q.d<52)return null
if(q.i()!==55727696)return null
s=A.m([0,0,0,0],t.t)
r=new A.dd(s)
q.i()
r.b=q.i()
s[0]=q.D()
s[1]=q.D()
s[2]=q.D()
s[3]=q.D()
q.i()
q.i()
r.f=q.i()
r.r=q.i()
q.i()
q.i()
q.i()
q.i()
r.Q=q.i()
return r},
im(a){var s,r,q=A.q(a,!1,null,0)
if(q.i()!==52)return null
s=new A.et()
s.b=q.i()
s.a=q.i()
q.i()
s.d=q.i()
q.i()
s.f=q.i()
q.i()
q.i()
q.i()
s.y=q.i()
r=q.i()
s.z=r
s.Q=q.i()
if(r!==559044176)return null
return s},
i5(a){var s,r,q,p,o,n,m=null,l=a.length,k=A.q(a,!1,m,0)
if(k.i()!==0)return m
s=new A.ho()
s.b=k.i()
s.a=k.i()
k.i()
k.i()
k.i()
k.i()
k.i()
k.i()
k.i()
r=k.i()
s.y=r
if(r===559044176)return m
q=0
p=8
if(!(l===32)){o=0
for(;;){if(!(o<10)){q=1
break}n=o<<1>>>0
if((B.a.M(64,n)&l)>>>0!==0){p=B.a.M(16,o)
q=1
break}if((B.a.M(128,n)&l)>>>0!==0){p=B.a.M(16,o)
break}++o}if(o===10)return m}if((q+1)*2===4)return m
s.b=s.a=p
return s},
ab(a){return A.J(new A.jK(this,a))},
ih(a){var s,r,q=this,p=q.b
if(p==null||q.a==null)return null
A.ag(p.gX(),q.b.gR(),q.c,!1)
p=q.b
if(p instanceof A.ho){p=p.a
s=q.b.gR()
r=q.a
r.toString
return q.dm(p,s,r)}else if(p instanceof A.et){p=q.a
p.toString
return q.il(p)}else if(p instanceof A.dd){p=q.a
p.toString
return q.io(p)}return null},
aS(a,b){return A.J(new A.jL(this,a,b))},
i_(a,b){if(this.au(a)==null)return null
return this.ab(0)},
il(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=a.length
if(e<52||g.b==null)return f
s=g.b
s.toString
t.fi.a(s)
r=A.q(a,!1,f,0)
r.d+=52
q=s.Q
if(q<1)q=(s.d&4096)!==0?6:1
if(q!==1)return f
p=s.a
o=s.b
if(p*o*s.f/8>e-52)return f
switch(s.d&255){case 16:n=A.Q(f,f,B.e,0,B.i,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gF(s);s.E();){m=s.gJ()
l=J.c(r.a,r.d++)
k=J.c(r.a,r.d++)
m.sq(k&240)
m.st((k&15)<<4)
m.su(l&240)
m.sv((l&15)<<4)}return n
case 17:n=A.Q(f,f,B.e,0,B.i,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gF(s);s.E();){m=s.gJ()
j=r.k()
i=(j&1)!==0?255:0
m.sq(j>>>8&248)
m.st(j>>>3&248)
m.su((j&62)<<2)
m.sv(i)}return n
case 18:n=A.Q(f,f,B.e,0,B.i,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gF(s);s.E();){m=s.gJ()
m.sq(J.c(r.a,r.d++))
m.st(J.c(r.a,r.d++))
m.su(J.c(r.a,r.d++))
m.sv(J.c(r.a,r.d++))}return n
case 19:n=A.Q(f,f,B.e,0,B.i,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gF(s);s.E();){m=s.gJ()
j=r.k()
m.sq(j>>>8&248)
m.st(j>>>3&252)
m.su((j&31)<<3)}return n
case 20:n=A.Q(f,f,B.e,0,B.i,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gF(s);s.E();){m=s.gJ()
j=r.k()
m.sq((j&31)<<3)
m.st(j>>>2&248)
m.su(j>>>7&248)}return n
case 21:n=A.Q(f,f,B.e,0,B.i,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gF(s);s.E();){m=s.gJ()
m.sq(J.c(r.a,r.d++))
m.st(J.c(r.a,r.d++))
m.su(J.c(r.a,r.d++))}return n
case 22:n=A.Q(f,f,B.e,0,B.i,o,f,0,1,f,B.e,p,!1)
for(s=n.a,s=s.gF(s);s.E();)s.gJ().sq(J.c(r.a,r.d++))
return n
case 23:n=A.Q(f,f,B.e,0,B.i,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gF(s);s.E();){m=s.gJ()
i=J.c(r.a,r.d++)
h=J.c(r.a,r.d++)
m.sq(h)
m.st(h)
m.su(h)
m.sv(i)}return n
case 24:return f
case 25:return s.y===0?g.eM(p,o,r.T()):g.dm(p,o,r.T())}return f},
io(a){var s,r,q,p=this
if(!(p.b instanceof A.dd))return null
s=A.q(a,!1,null,0)
r=s.d+=52
q=t.a7.a(p.b)
s.d=r+q.Q
if(q.c[0]===0)switch(q.b){case 2:return p.eM(q.r,q.f,s.T())
case 3:return p.dm(q.r,q.f,s.T())}return null},
eM(c5,c6,c7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=null,b6=A.Q(b5,b5,B.e,0,B.i,c6,b5,0,3,b5,B.e,c5,!1),b7=c5/4|0,b8=b7-1,b9=J.au(B.c.gA(c7),0,null),c0=new A.aL(b9),c1=new A.aL(J.au(B.c.gA(c7),0,null)),c2=new A.aL(J.au(B.c.gA(c7),0,null)),c3=new A.aL(J.au(B.c.gA(c7),0,null)),c4=new A.aL(J.au(B.c.gA(c7),0,null))
for(s=0,r=0;s<b7;++s,r+=4)for(q=0,p=0;q<b7;++q,p+=4){c0.b=A.bi(q,s)<<1>>>0
c0.bi()
o=b9[c0.b]
n=c0.c?4:0
for(m=0,l=0;l<4;++l){k=(s+(l<2?-1:0)&b8)>>>0
j=(k+1&b8)>>>0
for(i=l+r,h=0;h<4;++h){g=(q+(h<2?-1:0)&b8)>>>0
f=(g+1&b8)>>>0
c1.b=A.bi(g,k)<<1>>>0
c1.bi()
c2.b=A.bi(f,k)<<1>>>0
c2.bi()
c3.b=A.bi(g,j)<<1>>>0
c3.bi()
c4.b=A.bi(f,j)<<1>>>0
c4.bi()
e=c1.co()
d=B.o[m][0]
c=c2.co()
b=B.o[m][1]
a=c3.co()
a0=B.o[m][2]
a1=c4.co()
a2=B.o[m][3]
a3=c1.cp()
a4=B.o[m][0]
a5=c2.cp()
a6=B.o[m][1]
a7=c3.cp()
a8=B.o[m][2]
a9=c4.cp()
b0=B.o[m][3]
b1=B.b4[n+o&3]
b2=b1[0]
b3=b1[1]
b4=b6.a
if(b4!=null)b4.az(h+p,i,(e.a*d+c.a*b+a.a*a0+a1.a*a2)*b2+(a3.a*a4+a5.a*a6+a7.a*a8+a9.a*b0)*b3>>>7,(e.b*d+c.b*b+a.b*a0+a1.b*a2)*b2+(a3.b*a4+a5.b*a6+a7.b*a8+a9.b*b0)*b3>>>7,(e.c*d+c.c*b+a.c*a0+a1.c*a2)*b2+(a3.c*a4+a5.c*a6+a7.c*a8+a9.c*b0)*b3>>>7)
o=o>>>2;++m}}}return b6},
dm(b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=null,a4=A.Q(a3,a3,B.e,0,B.i,b4,a3,0,4,a3,B.e,b3,!1),a5=b3/4|0,a6=a5-1,a7=J.au(B.c.gA(b5),0,null),a8=new A.aL(a7),a9=new A.aL(J.au(B.c.gA(b5),0,null)),b0=new A.aL(J.au(B.c.gA(b5),0,null)),b1=new A.aL(J.au(B.c.gA(b5),0,null)),b2=new A.aL(J.au(B.c.gA(b5),0,null))
for(s=0,r=0;s<a5;++s,r+=4)for(q=0,p=0;q<a5;++q,p+=4){a8.b=A.bi(q,s)<<1>>>0
a8.bi()
o=a7[a8.b]
n=a8.c?4:0
for(m=0,l=0;l<4;++l){k=(s+(l<2?-1:0)&a6)>>>0
j=(k+1&a6)>>>0
for(i=l+r,h=0;h<4;++h){g=(q+(h<2?-1:0)&a6)>>>0
f=(g+1&a6)>>>0
a9.b=A.bi(g,k)<<1>>>0
a9.bi()
b0.b=A.bi(f,k)<<1>>>0
b0.bi()
b1.b=A.bi(g,j)<<1>>>0
b1.bi()
b2.b=A.bi(f,j)<<1>>>0
b2.bi()
e=a9.cq()
d=B.o[m][0]
c=b0.cq()
b=B.o[m][1]
b=new A.al(e.a*d,e.b*d,e.c*d,e.d*d).bN(0,new A.al(c.a*b,c.b*b,c.c*b,c.d*b))
c=b1.cq()
d=B.o[m][2]
d=b.bN(0,new A.al(c.a*d,c.b*d,c.c*d,c.d*d))
c=b2.cq()
b=B.o[m][3]
a=d.bN(0,new A.al(c.a*b,c.b*b,c.c*b,c.d*b))
b=a9.cr()
c=B.o[m][0]
d=b0.cr()
e=B.o[m][1]
e=new A.al(b.a*c,b.b*c,b.c*c,b.d*c).bN(0,new A.al(d.a*e,d.b*e,d.c*e,d.d*e))
d=b1.cr()
c=B.o[m][2]
c=e.bN(0,new A.al(d.a*c,d.b*c,d.c*c,d.d*c))
d=b2.cr()
e=B.o[m][3]
a0=c.bN(0,new A.al(d.a*e,d.b*e,d.c*e,d.d*e))
a1=B.b4[n+o&3]
e=a1[0]
d=a1[1]
c=a1[2]
b=a1[3]
a2=a4.a
if(a2!=null)a2.ai(h+p,i,a.a*e+a0.a*d>>>7,a.b*e+a0.b*d>>>7,a.c*e+a0.c*d>>>7,a.d*c+a0.d*b>>>7)
o=o>>>2;++m}}}return a4}}
A.jM.prototype={
$0(){return this.a.k_(this.b)},
$S:5}
A.jK.prototype={
$0(){return this.a.ih(this.b)},
$S:1}
A.jL.prototype={
$0(){return this.a.i_(this.b,this.c)},
$S:1}
A.hs.prototype={
bu(a){var s,r=this
if(a.c-a.d<18)return
r.a=a.D()
r.b=a.D()
s=a.D()
r.c=s<12?B.fK[s]:B.a8
a.k()
r.e=a.k()
r.f=a.D()
a.k()
a.k()
r.x=a.k()
r.y=a.k()
r.z=a.D()
r.Q=a.D()},
fK(){var s=this,r=s.z
if(r!==8&&r!==16&&r!==24&&r!==32)return!1
r=s.c
if(r===B.F||r===B.G){if(s.e>256||s.b!==1)return!1
r=s.f
if(r!==16&&r!==24&&r!==32)return!1}else if(s.b===1)return!1
return!0}}
A.am.prototype={
a6(){return"TgaImageType."+this.b}}
A.jV.prototype={
aS(a,b){return A.J(new A.jX(this,a,b))},
k6(a,b){if(this.au(a)==null)return null
return this.ab(0)},
au(a){return A.J(new A.jY(this,a))},
k8(a){var s,r,q,p,o=this
o.a=new A.hs(B.a8)
s=A.q(a,!1,null,0)
o.b=s
r=s.a1(18)
o.a.bu(r)
s=o.a
if(!s.fK()||s.x<1||s.y<1)return null
q=o.b
q.d+=s.a
p=s.c
if(p===B.F||p===B.G)s.as=q.a1(s.e*B.a.j(s.f,3)).T()
s=o.a
s.ax=o.b.d
return s},
ab(a){return A.J(new A.jW(this,a))},
k7(a){var s=this,r=s.a
if(r==null)return null
A.ag(r.x,r.y,s.c,!1)
r=s.a.c
if(r===B.bx)return s.eL()
else if(r===B.bw||r===B.G)return s.ir()
else if(r===B.F)return s.eL()
return null},
eG(a,b){var s,r,q,p,o,n,m,l=this,k=A.q(a,!1,null,0),j=l.a.f
if(j===16){j=l.b
j===$&&A.b()
s=j.k()
r=s>>>7&248
q=s>>>2&248
p=(s&31)<<3
o=(s&32768)!==0?0:255
for(n=0;n<l.a.e;++n){b.bd(n,r)
b.bc(n,q)
b.bb(n,p)
b.bh(n,o)}}else{m=j===32
for(n=0;n<l.a.e;++n){p=J.c(k.a,k.d++)
q=J.c(k.a,k.d++)
r=J.c(k.a,k.d++)
o=m?J.c(k.a,k.d++):255
b.bd(n,r)
b.bc(n,q)
b.bb(n,p)
b.bh(n,o)}}},
ir(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=null,c=e.a,b=c.z,a=b===16,a0=a||b===32,a1=c.x,a2=c.y,a3=a0?4:3
c=c.c
s=A.Q(d,d,B.e,0,B.i,a2,d,0,a3,d,B.e,a1,c===B.F||c===B.G)
c=s.a
if((c==null?d:c.gP())!=null){c=e.a.as
c.toString
a1=s.a
a1=a1==null?d:a1.gP()
a1.toString
e.eG(c,a1)}r=s.gX()
q=s.gR()-1
c=b===8
p=0
for(;;){a1=e.b
a1===$&&A.b()
a2=a1.d
if(!(a2<a1.c&&q>=0))break
a3=a1.a
a1.d=a2+1
o=J.c(a3,a2)
n=(o&127)+1
m=0
if((o&128)!==0)if(c){a1=e.b
l=J.c(a1.a,a1.d++)
for(k=0;k<n;++k){j=p+1
a1=s.a
if(a1!=null)a1.aB(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}else{a1=e.b
if(a){i=a1.k()
l=i>>>7&248
h=i>>>2&248
g=(i&31)<<3
f=(i&32768)!==0?0:255
for(k=0;k<n;++k){j=p+1
a1=s.a
if(a1!=null)a1.ai(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}else{g=J.c(a1.a,a1.d++)
a1=e.b
h=J.c(a1.a,a1.d++)
a1=e.b
l=J.c(a1.a,a1.d++)
if(a0){a1=e.b
f=J.c(a1.a,a1.d++)}else f=255
for(k=0;k<n;++k){j=p+1
a1=s.a
if(a1!=null)a1.ai(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}}else if(c)for(k=0;k<n;++k){a1=e.b
l=J.c(a1.a,a1.d++)
j=p+1
a1=s.a
if(a1!=null)a1.aB(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}else if(a)for(k=0;k<n;++k){i=e.b.k()
f=(i&32768)!==0?0:255
j=p+1
a1=s.a
if(a1!=null)a1.ai(p,q,i>>>7&248,i>>>2&248,(i&31)<<3,f)
a1=e.b
if(a1.d>=a1.c){p=j
break}if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}else for(k=0;k<n;++k){a1=e.b
g=J.c(a1.a,a1.d++)
a1=e.b
h=J.c(a1.a,a1.d++)
a1=e.b
l=J.c(a1.a,a1.d++)
if(a0){a1=e.b
f=J.c(a1.a,a1.d++)}else f=255
j=p+1
a1=s.a
if(a1!=null)a1.ai(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}if(p>=r){--q
if(q<0)break
p=0}}return s},
eL(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=d.b
b===$&&A.b()
s=d.a
b.d=s.ax
r=s.z
b=r===16
q=!0
if(!b)if(r!==32){p=s.c
if(p===B.F||p===B.G){p=s.f
p=p===16||p===32}else p=!1
q=p}p=s.x
o=s.y
n=q?4:3
s=s.c
m=A.Q(c,c,B.e,0,B.i,o,c,0,n,c,B.e,p,s===B.F||s===B.G)
s=d.a
p=s.c
if(p===B.F||p===B.G){s=s.as
s.toString
p=m.a
p=p==null?c:p.gP()
p.toString
d.eG(s,p)}if(r===8)for(l=m.gR()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
b=d.b
j=J.c(b.a,b.d++)
b=m.a
if(b!=null)b.aB(k,l,j);++k}}else if(b)for(l=m.gR()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
i=d.b.k()
h=(i&32768)!==0?0:255
b=m.a
if(b!=null)b.ai(k,l,i>>>7&248,i>>>2&248,(i&31)<<3,h);++k}}else for(l=m.gR()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
b=d.b
g=J.c(b.a,b.d++)
b=d.b
f=J.c(b.a,b.d++)
b=d.b
e=J.c(b.a,b.d++)
if(q){b=d.b
h=J.c(b.a,b.d++)}else h=255
b=m.a
if(b!=null)b.ai(k,l,e,f,g,h);++k}}return m}}
A.jX.prototype={
$0(){return this.a.k6(this.b,this.c)},
$S:1}
A.jY.prototype={
$0(){return this.a.k8(this.b)},
$S:5}
A.jW.prototype={
$0(){return this.a.k7(this.b)},
$S:1}
A.jZ.prototype={
af(a){var s,r,q,p,o=this
if(a===0)return 0
if(o.c===0){o.c=8
o.b=o.a.D()}for(s=o.a,r=0;q=o.c,a>q;){r=B.a.Y(r,q)+(o.b&B.U[q])
a-=q
o.c=8
o.b=J.c(s.a,s.d++)}if(a>0){if(q===0){o.c=8
o.b=s.D()}s=B.a.Y(r,a)
q=o.b
p=o.c-a
r=s+(B.a.bn(q,p)&B.U[a])
o.c=p}return r}}
A.ht.prototype={
B(a){var s=this,r=s.a,q=$.mM().n(0,r)
if(q!=null)return q.a+": "+s.b.B(0)+" "+s.c
return"<"+r+">: "+s.b.B(0)+" "+s.c},
b5(){var s,r,q,p,o,n=this,m=n.e
if(m!=null)return m
m=n.f
s=n.d
m.d=s
r=n.c
q=n.b
p=q!==B.d
if(r*(p?B.a3[q.a]:0)>m.c-s)throw A.e(A.i("Invalid TIFF tag "+n.a+" count: "+r))
o=m.a1(r*(p?B.a3[q.a]:0))
switch(q.a){case 1:return n.e=new A.bc(new Uint8Array(A.t(o.a1(r).T())))
case 2:return n.e=new A.bX(r===0?"":o.ag(r-1))
case 7:return n.e=new A.bc(new Uint8Array(A.t(o.a1(r).T())))
case 3:return n.e=A.ne(o,r)
case 4:return n.e=A.n9(o,r)
case 5:return n.e=A.na(o,r)
case 11:return n.e=A.nf(o,r)
case 12:return n.e=A.n8(o,r)
case 6:return n.e=new A.bx(new Int8Array(A.t(J.lu(B.c.gA(o.T()),0,r))))
case 8:return n.e=A.nd(o,r)
case 9:return n.e=A.nb(o,r)
case 10:return n.e=A.nc(o,r)
case 13:case 0:return null}}}
A.k2.prototype={
kr(a,b,c,d){var s,r,q,p=this
p.r=b
p.x=p.w=0
s=B.a.V(p.a+7,8)
for(r=0,q=0;q<d;++q){p.dk(a,r,c)
r+=s}},
dk(a,b,c){var s,r,q,p,o,n,m,l,k=this
k.d=0
for(s=k.a,r=!0;c<s;){while(r){q=k.bw(10)
p=B.b8[q]
o=B.a.j(p,1)&15
if(o===12){p=B.a5[(q<<2&12|k.aO(2))>>>0]
n=B.a.j(p,1)
c+=B.a.j(p,4)&4095
k.av(4-(n&7))}else if(o===0)throw A.e(A.i("TIFFFaxDecoder0"))
else if(o===15)throw A.e(A.i("TIFFFaxDecoder1"))
else{c+=B.a.j(p,5)&2047
k.av(10-o)
if((p&1)===0){k.f[k.d++]=c
r=!1}}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}while(!r){p=B.aU[k.aO(4)]
m=p>>>5&2047
l=!0
if(m===100){p=B.aZ[k.bw(9)]
o=B.a.j(p,1)&15
m=B.a.j(p,5)&2047
if(o===12){k.av(5)
p=B.a5[k.aO(4)]
n=B.a.j(p,1)
m=B.a.j(p,4)&4095
k.aX(a,b,c,m)
c+=m
k.av(4-(n&7))}else if(o===15)throw A.e(A.i("TIFFFaxDecoder2"))
else{k.aX(a,b,c,m)
c+=m
k.av(9-o)
if((p&1)===0){k.f[k.d++]=c
r=l}}}else{if(m===200){p=B.aT[k.aO(2)]
m=p>>>5&2047
k.aX(a,b,c,m)
c+=m
k.av(2-(p>>>1&15))
k.f[k.d++]=c}else{k.aX(a,b,c,m)
c+=m
k.av(4-(p>>>1&15))
k.f[k.d++]=c}r=l}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}}k.f[k.d++]=c},
ks(a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
a0.r=a2
a0.z=3
a0.x=a0.w=0
s=a0.a
r=B.a.V(s+7,8)
q=A.a0(2,null,!1,t.I)
a0.at=a5&1
a0.as=a5>>>2&1
if(a0.f5()!==1)throw A.e(A.i("TIFFFaxDecoder3"))
a0.dk(a1,0,a3)
for(p=r,o=1;o<a4;++o){if(a0.f5()===0){n=a0.e
a0.e=a0.f
a0.f=n
a0.y=0
m=a3
l=-1
k=!0
j=0
for(;;){m.toString
if(!(m<s))break
a0.eT(l,k,q)
i=q[0]
h=q[1]
g=B.b5[a0.aO(7)]&255
f=g>>>3&15
e=g&7
if(f===0){if(!k){h.toString
a0.aX(a1,p,m,h-m)}a0.av(7-e)
m=h
l=m}else if(f===1){a0.av(7-e)
d=j+1
c=d+1
if(k){m+=a0.cE()
a0.f[j]=m
b=a0.cD()
a0.aX(a1,p,m,b)
m+=b
a0.f[d]=m}else{b=a0.cD()
a0.aX(a1,p,m,b)
m+=b
a0.f[j]=m
m+=a0.cE()
a0.f[d]=m}j=c
l=m}else{if(f<=8){i.toString
a=i+(f-5)
d=j+1
a0.f[j]=a
k=!k
if(k)a0.aX(a1,p,m,a-m)
a0.av(7-e)}else throw A.e(A.i("TIFFFaxDecoder4"))
m=a
j=d
l=m}}a0.f[j]=m
a0.d=j+1}else a0.dk(a1,p,a3)
p+=r}},
ky(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this
a4.r=a6
a4.z=4
a4.x=a4.w=0
s=a4.a
r=B.a.V(s+7,8)
q=A.a0(2,null,!1,t.I)
p=a4.f
a4.d=0
a4.d=1
p[0]=s
a4.d=2
p[1]=s
for(o=0,n=0;n<a8;++n){m=a4.e
a4.e=a4.f
a4.f=m
a4.y=0
l=a7
k=-1
j=!0
i=0
for(;;){l.toString
if(!(l<s))break
a4.eT(k,j,q)
h=q[0]
g=q[1]
f=B.b5[a4.aO(7)]&255
e=f>>>3&15
d=f&7
if(e===0){if(!j){g.toString
a4.aX(a5,o,l,g-l)}a4.av(7-d)
l=g
k=l}else if(e===1){a4.av(7-d)
c=i+1
b=c+1
if(j){l+=a4.cE()
m[i]=l
a=a4.cD()
a4.aX(a5,o,l,a)
l+=a
m[c]=l}else{a=a4.cD()
a4.aX(a5,o,l,a)
l+=a
m[i]=l
l+=a4.cE()
m[c]=l}i=b
k=l}else if(e<=8){h.toString
a0=h+(e-5)
c=i+1
m[i]=a0
j=!j
if(j)a4.aX(a5,o,l,a0-l)
a4.av(7-d)
l=a0
i=c
k=l}else if(e===11){if(a4.aO(3)!==7)throw A.e(A.i("TIFFFaxDecoder5"))
for(a1=0,a2=!1;!a2;j=a3){while(a4.aO(1)!==1)++a1
if(a1>5){a1-=6
if(!j&&a1>0){c=i+1
m[i]=l
i=c}l+=a1
if(a1>0)j=!0
a3=a4.aO(1)===0
if(a3){if(!j){c=i+1
m[i]=l
i=c}}else if(j){c=i+1
m[i]=l
i=c}j=a3
a2=!0}a3=a1===5
if(a3){if(!j){c=i+1
m[i]=l
i=c}l+=a1}else{l+=a1
c=i+1
m[i]=l
a4.aX(a5,o,l,1);++l
i=c}}}else throw A.e(A.i("TIFFFaxDecoder5 "+e))}m[i]=l
a4.d=i+1
o+=r}},
cE(){var s,r,q,p,o,n,m=this
for(s=0,r=!0;r;){q=m.bw(10)
p=B.b8[q]
o=B.a.j(p,1)&15
if(o===12){p=B.a5[(q<<2&12|m.aO(2))>>>0]
n=B.a.j(p,1)
s+=B.a.j(p,4)&4095
m.av(4-(n&7))}else if(o===0)throw A.e(A.i("TIFFFaxDecoder0"))
else if(o===15)throw A.e(A.i("TIFFFaxDecoder1"))
else{s+=B.a.j(p,5)&2047
m.av(10-o)
if((p&1)===0)r=!1}}return s},
cD(){var s,r,q,p,o,n,m=this
for(s=0,r=!1;!r;){q=B.aU[m.aO(4)]
p=q>>>5&2047
if(p===100){q=B.aZ[m.bw(9)]
o=B.a.j(q,1)&15
n=B.a.j(q,5)
if(o===12){m.av(5)
q=B.a5[m.aO(4)]
n=B.a.j(q,1)
s+=B.a.j(q,4)&4095
m.av(4-(n&7))}else if(o===15)throw A.e(A.i("TIFFFaxDecoder2"))
else{s+=n&2047
m.av(9-o)
if((q&1)===0)r=!0}}else{if(p===200){q=B.aT[m.aO(2)]
s+=q>>>5&2047
m.av(2-(q>>>1&15))}else{s+=p
m.av(4-(q>>>1&15))}r=!0}}return s},
f5(){var s,r,q=this,p="TIFFFaxDecoder8",o=q.as
if(o===0){if(q.bw(12)!==1)throw A.e(A.i("TIFFFaxDecoder6"))}else if(o===1){o=q.w
o.toString
s=8-o
if(q.bw(s)!==0)throw A.e(A.i(p))
if(s<4)if(q.bw(8)!==0)throw A.e(A.i(p))
while(r=q.bw(8),r!==1)if(r!==0)throw A.e(A.i(p))}if(q.at===0)return 1
else return q.aO(1)},
eT(a,b,c){var s,r=this,q=r.e,p=r.d,o=r.y,n=o>0?o-1:0
n=b?(n&4294967294)>>>0:(n|1)>>>0
for(s=n;s<p;s+=2){o=q[s]
o.toString
a.toString
if(o>a){r.y=s
c[0]=o
break}}o=s+1
if(o<p)c[1]=q[o]},
aX(a,b,c,d){var s,r,q,p,o,n=8*b+c,m=n+d,l=B.a.j(n,3),k=n&7
if(k>0){s=B.a.Y(1,7-k)
r=J.c(a.a,a.d+l)
for(;;){if(!(s>0&&n<m))break
r=(r|s)>>>0
s=s>>>1;++n}a.l(0,l,r)}l=B.a.j(n,3)
for(q=m-7;n<q;l=p){p=l+1
J.V(a.a,a.d+l,255)
n+=8}while(n<m){l=B.a.j(n,3)
q=J.c(a.a,a.d+l)
o=B.a.Y(1,7-(n&7))
J.V(a.a,a.d+l,(q|o)>>>0);++n}},
bw(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.r
e===$&&A.b()
s=e.d
r=e.c-s-1
q=f.x
p=f.c
o=0
n=0
if(p===1){q.toString
m=J.c(e.a,s+q)
if(!(q===r)){e=q+1
s=f.r
p=s.a
s=s.d
if(e===r)o=J.c(p,s+e)
else{o=J.c(p,s+e)
e=f.r
n=J.c(e.a,e.d+(q+2))}}}else if(p===2){q.toString
m=B.Q[J.c(e.a,s+q)&255]
if(!(q===r)){e=q+1
s=f.r
p=s.a
s=s.d
if(e===r)o=B.Q[J.c(p,s+e)&255]
else{o=B.Q[J.c(p,s+e)&255]
e=f.r
n=B.Q[J.c(e.a,e.d+(q+2))&255]}}}else throw A.e(A.i("TIFFFaxDecoder7"))
e=f.w
e.toString
l=8-e
k=a-l
if(k>8){j=k-8
i=8}else{i=k
j=0}e=f.x
e.toString
e=f.x=e+1
h=B.a.Y(m&B.U[l],k)
g=B.a.U(o&B.al[i],8-i)
if(j!==0){g=B.a.Y(g,j)|B.a.U(n&B.al[j],8-j)
f.x=e+1
f.w=j}else if(i===8){f.w=0
f.x=e+1}else f.w=i
return(h|g)>>>0},
aO(a){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.r
h===$&&A.b()
s=h.d
r=h.c-s-1
q=i.x
p=i.c
o=0
if(p===1){q.toString
n=J.c(h.a,s+q)
if(!(q===r)){h=i.r
o=J.c(h.a,h.d+(q+1))}}else if(p===2){q.toString
n=B.Q[J.c(h.a,s+q)&255]
if(!(q===r)){h=i.r
o=B.Q[J.c(h.a,h.d+(q+1))&255]}}else throw A.e(A.i("TIFFFaxDecoder7"))
h=i.w
h.toString
m=8-h
l=a-m
k=m-a
if(k>=0){j=B.a.U(n&B.U[m],k)
h+=a
i.w=h
if(h===8){i.w=0
h=i.x
h.toString
i.x=h+1}}else{j=(B.a.Y(n&B.U[m],-k)|B.a.U(o&B.al[l],8-l))>>>0
h=i.x
h.toString
i.x=h+1
i.w=l}return j},
av(a){var s,r=this,q=r.w
q.toString
s=q-a
if(s<0){q=r.x
q.toString
r.x=q-1
r.w=8+s}else r.w=s}}
A.hu.prototype={
hy(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=A.r(a0,c,0),a=a0.k()
for(s=d.a,r=0;r<a;++r){q=a0.k()
p=a0.k()
o=a0.i()
if(p>13){a0.d+=4
continue}n=B.b3[p]
if(o*B.a3[p]>4)m=a0.i()
else{m=a0.d
a0.d=m+4}l=new A.ht(q,n,o,m,b)
s.l(0,q,l)
if(q===256){k=l.b5()
k=k==null?c:k.h(0)
d.b=k==null?0:k}else if(q===257){k=l.b5()
k=k==null?c:k.h(0)
d.c=k==null?0:k}else if(q===262){j=l.b5()
i=j==null?c:j.h(0)
if(i==null)i=17
if(i<17)d.d=B.f4[i]
else d.d=B.as}else if(q===259){k=l.b5()
k=k==null?c:k.h(0)
d.e=k==null?0:k}else if(q===258){k=l.b5()
k=k==null?c:k.h(0)
d.f=k==null?0:k}else if(q===277){k=l.b5()
k=k==null?c:k.h(0)
d.r=k==null?0:k}else if(q===317){k=l.b5()
k=k==null?c:k.h(0)
d.Q=k==null?0:k}else if(q===339){k=l.b5()
j=k==null?c:k.h(0)
d.x=B.fh[j==null?0:j]}else if(q===320){j=l.b5()
if(j!=null){k=J.p7(B.c.gA(j.b8()))
d.id=k
d.k1=0
k=k.length/3|0
d.k2=k
d.k3=k*2}}}k=d.id
h=k!=null
if(h&&d.d===B.at)d.r=1
if(d.b===0||d.c===0)return
if(h&&d.f===8){g=k.length
for(h=k.$flags|0,r=0;r<g;++r){f=k[r]
h&2&&A.a(k)
k[r]=f>>>8}}if(d.d===B.ar)d.z=!0
d.w=d.r
if(s.am(324)){d.ay=d.bW(322)
d.ch=d.bW(323)
d.CW=d.cM(324)
d.cx=d.cM(325)}else{d.ay=d.cL(322,d.b)
if(!s.am(278))k=d.ch=d.cL(323,d.c)
else{e=d.bW(278)
if(e===-1){k=d.c
d.ch=k}else{d.ch=e
k=e}}h=d.c
if(k>h)d.ch=h
d.CW=d.cM(273)
d.cx=d.cM(279)}k=d.b
h=d.ay
d.cy=B.a.a5(k+h-1,h)
h=d.c
k=d.ch
d.db=B.a.a5(h+k-1,k)
d.dy=d.cL(266,1)
d.fr=d.bW(292)
d.fx=d.bW(293)
d.bW(338)
switch(d.d.a){case 0:case 1:s=d.f
if(s===1&&d.r===1)d.y=B.aq
else if(s===4&&d.r===1)d.y=B.jF
else if(B.a.a9(s,8)===0){s=d.r
if(s===1)d.y=B.jG
else if(s===2)d.y=B.jH
else d.y=B.Z}break
case 2:if(B.a.a9(d.f,8)===0){s=d.r
if(s===3)d.y=B.bz
else if(s===4)d.y=B.jJ
else d.y=B.Z}break
case 3:s=!1
if(d.r===1)if(d.id!=null){s=d.f
s=s===4||s===8||s===16}if(s)d.y=B.jI
break
case 4:if(d.f===1&&d.r===1)d.y=B.aq
break
case 6:if(d.e===7&&d.f===8&&d.r===3)d.y=B.bz
else{if(s.am(530)){j=s.n(0,530).b5()
d.as=j.h(0)
s=d.at=j.a2(0,1)}else s=d.at=d.as=2
k=d.as
k===$&&A.b()
if(k*s===1)d.y=B.Z
else if(d.f===8&&d.r===3)d.y=B.jK}break
case 5:if(B.a.a9(d.f,8)===0)d.y=B.Z
s=d.r
if(s===4)d.w=3
else if(s===5)d.w=4
break
default:if(B.a.a9(d.f,8)===0)d.y=B.Z
break}},
bZ(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.x,a1=a0===B.Y,a2=a0===B.f
a0=b.f
if(a0===1)s=B.u
else if(a0===2)s=B.x
else{if(a0===4)a0=B.y
else if(a1&&a0===16)a0=B.z
else if(a1&&a0===32)a0=B.C
else if(a1&&a0===64)a0=B.I
else if(a2&&a0===8)a0=B.K
else if(a2&&a0===16)a0=B.L
else if(a2&&a0===32)a0=B.M
else if(a0===16)a0=B.m
else a0=a0===32?B.J:B.e
s=a0}r=b.id!=null&&b.d===B.at
q=r?3:b.w
a0=b.b
p=A.Q(a,a,s,0,B.i,b.c,a,0,q,a,s,a0,r)
if(r){a0=p.a
a0=a0==null?a:a0.gP()
a0.toString
o=b.id
n=o.length
m=n/3|0
l=b.k1
l===$&&A.b()
k=b.k2
k===$&&A.b()
j=b.k3
j===$&&A.b()
for(i=j,h=k,g=l,f=0;f<m;++f,++g,++h,++i){if(i>=n)break
a0.b1(f,o[g],o[h],o[i])}}e=0
d=0
for(;;){a0=b.db
a0===$&&A.b()
if(!(e<a0))break
c=0
for(;;){a0=b.cy
a0===$&&A.b()
if(!(c<a0))break
b.is(a3,p,c,e);++c;++d}++e}return p},
is(b5,b6,b7,b8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3=this,b4=null
if(b3.y===B.aq){b3.ia(b5,b6,b7,b8)
return}p=b3.cy
p===$&&A.b()
o=b8*p+b7
b5.d=b3.CW[o]
p=b3.ay
n=b7*p
m=b3.ch
l=b8*m
s=b3.cx[o]
k=p*m*b3.r
p=b3.f
m=p===16
if(m)k*=2
else if(p===32)k*=4
r=null
if(p===8||m||p===32||p===64){p=b3.e
if(p===1)r=b5
else if(p===5){r=A.q(new Uint8Array(k),!1,b4,0)
q=A.nt()
try{q.fD(A.r(b5,s,0),r.a)}catch(j){}if(b3.Q===2)for(i=0;i<b3.ch;++i){h=b3.r
p=b3.ay
g=h*(i*p+1)
f=p*h
for(;h<f;++h){p=r
m=J.c(p.a,p.d+g)
e=r
d=b3.r
d=J.c(e.a,e.d+(g-d))
J.V(p.a,p.d+g,m+d);++g}}}else if(p===32773){r=A.q(new Uint8Array(k),!1,b4,0)
b3.eK(b5,k,r.a)}else if(p===32946||p===8){c=b5.e8(0,0,s)
p=b3.f
b=p<8?1:B.a.j(p+7,3)
r=A.q(A.li(c,b3.ay*b3.ch*b3.r*b),!1,b4,0)}else if(p===6||p===7){c=b5.e8(0,0,s)
a=A.nn().bZ(t.D.a(c))
if(a!=null)b3.iX(a,b6,n,l,b3.ay,b3.ch)
return}else throw A.e(A.i("Unsupported Compression Type: "+p))
a0=A.m([0,0,0],t.t)
for(a1=l,a2=0;a2<b3.ch;++a2,++a1)for(a3=n,a4=0;a4<b3.ay;++a4,++a3){p=r
if(p.d>=p.c||a3>=b3.b||a1>=b3.c)break
p=b3.r
if(p===1){p=b3.x
if(p===B.Y){p=b3.f
if(p===32){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
a5=$.bL()[0]}else if(p===64)a5=r.d1()
else if(p===16){p=r.k()
m=$.F
a5=(m!=null?m:A.K())[p]}else a5=0
if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aB(a3,a1,a5)}}else{m=b3.f
if(m===8)if(p===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
a5=$.at()[0]}else{p=r
a5=J.c(p.a,p.d++)}else if(m===16)if(p===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
a5=$.as()[0]}else a5=r.k()
else if(m===32)if(p===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
a5=$.a_()[0]}else a5=r.i()
else a5=0
if(b3.d===B.ar){p=b6.a
a6=p==null?b4:p.gC()
a5=(a6==null?0:a6)-a5}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aB(a3,a1,a5)}}}else if(p===2){p=b3.f
if(p===8){if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
a7=$.at()[0]}else{p=r
a7=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.at()[0]}else{p=r
a8=J.c(p.a,p.d++)}}else if(p===16){if(b3.x===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
a7=$.as()[0]}else a7=r.k()
if(b3.x===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.as()[0]}else a8=r.k()}else if(p===32){if(b3.x===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
a7=$.a_()[0]}else a7=r.i()
if(b3.x===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.a_()[0]}else a8=r.i()}else{a7=0
a8=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.ai(a3,a1,a7,0,0,a8)}}else if(p===3){p=b3.x
if(p===B.Y){p=b3.f
if(p===32){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
p=$.bL()
a9=p[0]
m[0]=r.i()
b0=p[0]
m[0]=r.i()
b1=p[0]}else{b0=0
b1=0
if(p===64)a9=r.d1()
else if(p===16){p=r.k()
m=$.F
a9=(m!=null?m:A.K())[p]
p=r.k()
m=$.F
b0=(m!=null?m:A.K())[p]
p=r.k()
m=$.F
b1=(m!=null?m:A.K())[p]}else a9=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.az(a3,a1,a9,b0,b1)}}else{m=b3.f
if(m===8){if(p===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.at()[0]}else{p=r
a9=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.at()[0]}else{p=r
b0=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.at()[0]}else{p=r
b1=J.c(p.a,p.d++)}}else if(m===16){if(p===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.as()[0]}else a9=r.k()
if(b3.x===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.as()[0]}else b0=r.k()
if(b3.x===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.as()[0]}else b1=r.k()}else if(m===32){if(p===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.a_()[0]}else a9=r.i()
if(b3.x===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.a_()[0]}else b0=r.i()
if(b3.x===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.a_()[0]}else b1=r.i()}else{a9=0
b0=0
b1=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.az(a3,a1,a9,b0,b1)}}}else if(p>=4)if(b3.x===B.Y){p=b3.f
if(p===32){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
p=$.bL()
a9=p[0]
m[0]=r.i()
b0=p[0]
m[0]=r.i()
b1=p[0]
m[0]=r.i()
b2=p[0]}else{b0=0
b1=0
b2=0
if(p===64)a9=r.d1()
else if(p===16){p=r.k()
m=$.F
a9=(m!=null?m:A.K())[p]
p=r.k()
m=$.F
b0=(m!=null?m:A.K())[p]
p=r.k()
m=$.F
b1=(m!=null?m:A.K())[p]
p=r.k()
m=$.F
b2=(m!=null?m:A.K())[p]}else a9=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.ai(a3,a1,a9,b0,b1,b2)}}else{p=b6.a
a8=p==null?b4:p.gC()
if(a8==null)a8=0
p=b3.f
if(p===8){if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.at()[0]}else{p=r
a9=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.at()[0]}else{p=r
b0=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.at()[0]}else{p=r
b1=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
b2=$.at()[0]}else{p=r
b2=J.c(p.a,p.d++)}if(b3.r===5)if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ai()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.at()[0]}else{p=r
a8=J.c(p.a,p.d++)}}else if(p===16){if(b3.x===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.as()[0]}else a9=r.k()
if(b3.x===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.as()[0]}else b0=r.k()
if(b3.x===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.as()[0]}else b1=r.k()
if(b3.x===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
b2=$.as()[0]}else b2=r.k()
if(b3.r===5)if(b3.x===B.f){p=r.k()
m=$.ah()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.as()[0]}else a8=r.k()}else if(p===32){if(b3.x===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.a_()[0]}else a9=r.i()
if(b3.x===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.a_()[0]}else b0=r.i()
if(b3.x===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.a_()[0]}else b1=r.i()
if(b3.x===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
b2=$.a_()[0]}else b2=r.i()
if(b3.r===5)if(b3.x===B.f){p=r.i()
m=$.N()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.a_()[0]}else a8=r.i()}else{a9=0
b0=0
b1=0
b2=0}if(b3.d===B.bA){A.oo(a9,b0,b1,b2,a0)
a9=a0[0]
b0=a0[1]
b1=a0[2]
b2=a8}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.ai(a3,a1,a9,b0,b1,b2)}}}}else throw A.e(A.i("Unsupported bitsPerSample: "+p))},
iX(a,b,c,d,e,f){var s,r,q,p
for(s=0;s<f;++s)for(r=s+d,q=0;q<e;++q){p=a.a
p=p==null?null:p.K(q,s,null)
if(p==null)p=new A.D()
b.bD(q+c,r,p)}},
ia(a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=null,a4=a2.cy
a4===$&&A.b()
r=a8*a4+a7
a5.d=a2.CW[r]
a4=a2.ay
q=a7*a4
p=a2.ch
o=a8*p
n=a2.cx[r]
s=null
m=a2.e
if(m===32773){l=B.a.a9(a4,8)===0?B.a.V(a4,8)*p:(B.a.V(a4,8)+1)*p
s=A.q(new Uint8Array(a4*p),!1,a3,0)
a2.eK(a5,l,s.a)}else if(m===5){s=A.q(new Uint8Array(a4*p),!1,a3,0)
A.nt().fD(A.r(a5,n,0),s.a)
if(a2.Q===2)for(k=0;k<a2.c;++k){j=a2.r
i=j*(k*a2.b+1)
for(;j<a2.b*a2.r;++j){a4=s
p=J.c(a4.a,a4.d+i)
m=s
h=a2.r
h=J.c(m.a,m.d+(i-h))
J.V(a4.a,a4.d+i,p+h);++i}}}else if(m===2){s=A.q(new Uint8Array(a4*p),!1,a3,0)
try{A.m5(a2.dy,a2.ay,a2.ch).kr(s,a5,0,a2.ch)}catch(g){}}else if(m===3){s=A.q(new Uint8Array(a4*p),!1,a3,0)
try{A.m5(a2.dy,a2.ay,a2.ch).ks(s,a5,0,a2.ch,a2.fr)}catch(g){}}else if(m===4){s=A.q(new Uint8Array(a4*p),!1,a3,0)
try{A.m5(a2.dy,a2.ay,a2.ch).ky(s,a5,0,a2.ch,a2.fx)}catch(g){}}else if(m===8||m===32946)s=A.q(A.li(a5.e8(0,0,n),B.a.j(a2.ay+7,3)*a2.ch),!1,a3,0)
else if(m===1)s=a5
else throw A.e(A.i("Unsupported Compression Type: "+m))
f=new A.jZ(s)
e=a6.gC()
a4=a2.z
d=a4?e:0
c=a4?0:e
for(b=o,a=0;a<a2.ch;++a,++b){for(a0=q,a1=0;a1<a2.ay;++a1,++a0){a4=a6.a
p=a4==null
m=p?a3:a4.b
if(b<(m==null?0:m)){a4=p?a3:a4.a
a4=a0>=(a4==null?0:a4)}else a4=!0
if(a4)break
a4=f.af(1)
p=a6.a
if(a4===0){if(p!=null)p.az(a0,b,d,0,0)}else if(p!=null)p.az(a0,b,c,0,0)}f.c=0}},
eK(a,b,c){var s,r,q,p,o,n,m,l,k,j
for(s=J.aB(c),r=0,q=0;q<b;){p=r+1
o=J.c(a.a,a.d+r)
n=$.ai()
n.$flags&2&&A.a(n)
n[0]=o
m=$.at()[0]
if(m>=0&&m<=127)for(o=m+1,r=p,l=0;l<o;++l,q=k,r=p){k=q+1
p=r+1
s.l(c,q,J.c(a.a,a.d+r))}else{o=m<=-1&&m>=-127
r=p+1
if(o){j=J.c(a.a,a.d+p)
for(o=-m+1,l=0;l<o;++l,q=k){k=q+1
s.l(c,q,j)}}}}},
cL(a,b){var s=this.a
if(!s.am(a))return b
s=s.n(0,a).b5()
s=s==null?null:s.h(0)
return s==null?0:s},
bW(a){return this.cL(a,0)},
cM(a){var s,r=this.a
if(!r.am(a))return null
s=r.n(0,a)
r=s.b5()
r.toString
return A.ns(s.c,r.gbl(r),t.p)}}
A.cm.prototype={
a6(){return"TiffFormat."+this.b}}
A.a1.prototype={
a6(){return"TiffPhotometricType."+this.b}}
A.aN.prototype={
a6(){return"TiffImageType."+this.b}}
A.k3.prototype={}
A.jg.prototype={
fD(a,b){var s,r,q,p,o,n,m=this
m.r=b
s=J.bM(b)
m.w=0
r=t.D.a(a.a)
m.e=r
m.f=r.length
m.b=a.d
if(r[0]===0&&r[1]===1)throw A.e(A.i("Invalid LZW Data"))
m.eY()
m.d=m.c=0
q=m.dv()
r=m.x
p=0
for(;;){if(!(q!==257&&m.w<s))break
if(q===256){m.eY()
q=m.dv()
m.as=0
if(q===257)break
J.V(m.r,m.w++,q)
p=q}else{o=m.Q
o.toString
if(q<o){m.eV(q)
o=m.as
o===$&&A.b()
n=o-1
for(;n>=0;--n)J.V(m.r,m.w++,r[n])
m.en(p,r[m.as-1])}else{m.eV(p)
o=m.as
o===$&&A.b()
n=o-1
for(;n>=0;--n)J.V(m.r,m.w++,r[n])
J.V(m.r,m.w++,r[m.as-1])
m.en(p,r[m.as-1])}p=q}q=m.dv()}},
en(a,b){var s,r=this,q=r.y
q===$&&A.b()
s=r.Q
s.toString
q.$flags&2&&A.a(q)
q[s]=b
q=r.z
q===$&&A.b()
q.$flags&2&&A.a(q)
q[s]=a
s=r.Q=s+1
if(s===511)r.a=10
else if(s===1023)r.a=11
else if(s===2047)r.a=12},
eV(a){var s,r,q,p,o,n,m=this
m.as=0
s=m.x
m.as=1
r=m.y
r===$&&A.b()
q=r[a]
s.$flags&2&&A.a(s)
s[0]=q
q=m.z
q===$&&A.b()
p=q[a]
for(o=1;p!==4098;o=n){n=o+1
m.as=n
s[o]=r[p]
p=q[p]}},
dv(){var s,r,q,p,o=this,n=o.b,m=o.f
m===$&&A.b()
if(n>=m)return 257
for(;s=o.d,r=o.a,s<r;n=p){if(n>=m)return 257
r=o.c
q=o.e
q===$&&A.b()
p=n+1
o.b=p
o.c=(r<<8>>>0)+q[n]>>>0
o.d=s+8}n=s-r
o.d=n
return B.a.U(o.c,n)&B.dg[r-9]},
eY(){var s,r,q=this
q.y=new Uint8Array(4096)
s=new Uint32Array(4096)
q.z=s
B.l.an(s,0,4096,4098)
for(s=q.y,r=0;r<256;++r){s.$flags&2&&A.a(s)
s[r]=r}q.a=9
q.Q=258}}
A.k_.prototype={
ab(a){return A.J(new A.k0(this,a))},
ka(a){var s,r,q=this.a
if(q==null)return null
s=q.f[a]
q=this.d
A.ag(s.b,s.c,q,!1)
A.ag(s.ay,s.ch,q,!1)
q=this.c
q===$&&A.b()
r=s.bZ(q)
return r},
aS(a,b){return A.J(new A.k1(this,a,b))},
k9(a,b){var s,r,q,p,o,n,m=this,l=null,k=A.q(a,!1,l,0)
m.c=k
k=m.a=m.jC(k)
if(k==null)return l
k=k.f
s=k.length
r=new A.bh(m.d)
for(q=0;q<k.length;k.length===s||(0,A.a5)(k),++q){p=k[q]
r.bL(0,p.b,p.c)}o=m.ab(0)
if(o==null)return l
o.e=A.lA(A.q(a,!1,l,0))
o.w=B.aH
for(n=1;n<s;++n)o.aY(m.ab(n))
return o},
f7(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=null,g=A.m([],t.aU),f=new A.k3(g),e=a.c
if(e-a.d<8)return h
q=a.k()
if(q!==18761&&q!==19789)return h
if(q===19789)a.e=!0
else a.e=!1
p=a.k()
f.d=p
if(p!==42)return h
o=a.i()
n=A.r(a,h,0)
n.d=o
s=n
p=t.p
m=A.nq(p)
l=t.a4
for(;;){if(!(o!==0&&o<e&&g.length<1024&&m.by(0,o)))break
r=null
try{k=new A.hu(A.O(p,l),B.as,B.by,B.jL)
k.hy(s)
r=k
j=r
if(!(j.b!==0&&j.c!==0))break}catch(i){break}g.push(r)
if(g.length===1){j=g[0]
f.a=j.b
f.b=j.c}if(b)break
o=s.i()
if(o!==0)s.d=o}return g.length!==0?f:h},
jC(a){return this.f7(a,!1)}}
A.k0.prototype={
$0(){return this.a.ka(this.b)},
$S:1}
A.k1.prototype={
$0(){return this.a.k9(this.b,this.c)},
$S:1}
A.k8.prototype={
ce(){var s,r=this.a,q=r.b6()
if((q&1)!==0)return!1
if((q>>>1&7)>3)return!1
if((q>>>4&1)===0)return!1
this.f.d=q>>>5
if(r.b6()!==2752925)return!1
s=this.b
s.a=r.k()
s.b=r.k()
return!0},
bp(){var s,r,q,p,o=this,n=null
if(!o.iJ())return n
s=o.b
r=s.a
o.d=A.Q(n,n,B.e,0,B.i,s.b,n,0,4,n,B.e,r,!1)
o.iU()
if(!o.j8())return n
r=s.w
if(r.length!==0){q=A.q(new A.aV(r),!1,n,0)
r=o.d
r.toString
r.e=A.lA(q)}p=s.r
if(p!=null)o.d.c=new A.bb("ICC_PROFILE",B.a2,p)
return o.d},
iJ(){var s,r,q,p,o=this
if(!o.ce())return!1
o.fr=A.r1()
for(s=o.dy,r=0;r<4;++r){q=new Int32Array(2)
p=new Int32Array(2)
s[r]=new A.hE(q,p,new Int32Array(2))}o.y=o.Q=0
s=o.b
q=s.a
o.z=q
s=s.b
o.as=s
o.at=q+15>>>4
o.ax=s+15>>>4
o.k1=0
s=o.a
q=o.f
p=q.d
p===$&&A.b()
p=A.nK(s.aq(p))
o.c=p
s.d+=q.d
p.W(1)
o.c.W(1)
o.je(o.x,o.fr)
o.j7()
if(!o.ja(s))return!1
o.jc()
o.c.W(1)
o.jb()
return!0},
je(a,b){var s,r,q,p=this,o=p.c
o===$&&A.b()
o=o.W(1)!==0
a.a=o
if(o){a.b=p.c.W(1)!==0
if(p.c.W(1)!==0){a.c=p.c.W(1)!==0
for(o=a.d,s=0;s<4;++s){if(p.c.W(1)!==0){r=p.c
q=r.W(7)
r=r.W(1)===1?-q:q}else r=0
o.$flags&2&&A.a(o)
o[s]=r}for(o=a.e,s=0;s<4;++s){if(p.c.W(1)!==0){r=p.c
q=r.W(6)
r=r.W(1)===1?-q:q}else r=0
o.$flags&2&&A.a(o)
o[s]=r}}if(a.b)for(s=0;s<3;++s){o=b.a
r=p.c.W(1)!==0?p.c.W(8):255
o.$flags&2&&A.a(o)
o[s]=r}}else a.b=!1
return!0},
j7(){var s,r,q,p=this,o=p.w,n=p.c
n===$&&A.b()
o.a=n.W(1)!==0
o.b=p.c.W(6)
o.c=p.c.W(3)
n=p.c.W(1)!==0
o.d=n
if(n)if(p.c.W(1)!==0){for(n=o.e,s=0;s<4;++s)if(p.c.W(1)!==0){r=p.c
q=r.W(6)
r=r.W(1)===1?-q:q
n.$flags&2&&A.a(n)
n[s]=r}for(n=o.f,s=0;s<4;++s)if(p.c.W(1)!==0){r=p.c
q=r.W(6)
r=r.W(1)===1?-q:q
n.$flags&2&&A.a(n)
n[s]=r}}if(o.b===0)n=0
else n=o.a?1:2
p.bz=n
return!0},
ja(a){var s,r,q,p,o,n,m,l=a.c-a.d,k=this.c
k===$&&A.b()
k=B.a.M(1,k.W(2))
this.cy=k
s=k-1
r=s*3
if(l<r)return!1
for(k=this.db,q=0,p=0;p<s;++p,r=n){o=a.cv(3,q)
n=r+((J.c(o.a,o.d)|J.c(o.a,o.d+1)<<8|J.c(o.a,o.d+2)<<16)>>>0)
if(n>l)n=l
m=new A.eE(a.bE(n-r,r))
m.b=254
m.c=0
m.d=-8
k[p]=m
q+=3}k[s]=A.nK(a.bE(l-r,a.d-a.b+r))
return r<l},
jc(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=d.c
c===$&&A.b()
s=c.W(7)
r=d.c.W(1)!==0?d.c.c3(4):0
q=d.c.W(1)!==0?d.c.c3(4):0
p=d.c.W(1)!==0?d.c.c3(4):0
o=d.c.W(1)!==0?d.c.c3(4):0
n=d.c.W(1)!==0?d.c.c3(4):0
m=d.x
for(c=d.dy,l=m.a,k=!m.c,j=m.d,i=0;i<4;++i){if(l){h=j[i]
if(k)h+=s}else{if(i>0){c[i]=c[0]
continue}h=s}g=c[i]
f=g.a
e=h+r
if(e<0)e=0
else if(e>127)e=127
e=B.ai[e]
f.$flags&2&&A.a(f)
f[0]=e
if(h<0)e=0
else e=h>127?127:h
f[1]=B.aj[e]
e=g.b
f=h+q
if(f<0)f=0
else if(f>127)f=127
f=B.ai[f]
e.$flags&2&&A.a(e)
e[0]=f*2
f=h+p
if(f<0)f=0
else if(f>127)f=127
e[1]=B.aj[f]*101581>>>16
if(e[1]<8)e[1]=8
f=g.c
e=h+o
if(e<0)e=0
else if(e>117)e=117
e=B.ai[e]
f.$flags&2&&A.a(f)
f[0]=e
e=h+n
if(e<0)e=0
else if(e>127)e=127
f[1]=B.aj[e]}},
jb(){var s,r,q,p,o,n,m=this,l=m.fr
for(s=0;s<4;++s)for(r=0;r<8;++r)for(q=0;q<3;++q)for(p=0;p<11;++p){o=m.c
o===$&&A.b()
n=o.a4(B.ij[s][r][q][p])!==0?m.c.W(8):B.de[s][r][q][p]
o=l.b[s][r].a[q]
o.$flags&2&&A.a(o)
o[p]=n}o=m.c
o===$&&A.b()
o=o.W(1)!==0
m.fx=o
if(o)m.fy=m.c.W(8)},
jm(){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.bz
f.toString
if(f>0){s=g.w
for(f=s.e,r=s.f,q=g.x,p=q.e,o=0;o<4;++o){if(q.a){n=p[o]
if(!q.c){m=s.b
m.toString
n+=m}}else n=s.b
for(l=0;l<=1;++l){m=g.dW
m===$&&A.b()
k=m[o][l]
m=s.d
m===$&&A.b()
if(m){n.toString
j=n+f[0]
if(l!==0)j+=r[0]}else j=n
j.toString
if(j<0)j=0
else if(j>63)j=63
if(j>0){m=s.c
m===$&&A.b()
if(m>0){i=m>4?B.a.j(j,2):B.a.j(j,1)
h=9-m
if(i>h)i=h}else i=j
if(i<1)i=1
k.b=i
k.a=2*j+i
if(j>=40)m=2
else m=j>=15?1:0
k.d=m}else k.a=0
k.c=l!==0}}}},
iU(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=null,d=f.b,c=d.at
if(c!=null)f.dX=c
s=J.ak(4,t.e6)
for(c=t.ao,r=0;r<4;++r)s[r]=A.m([new A.bF(),new A.bF()],c)
f.dW=s
c=f.at
c.toString
s=J.ak(c,t.dE)
for(q=0;q<c;++q){p=new Uint8Array(16)
o=new Uint8Array(8)
s[q]=new A.hF(p,o,new Uint8Array(8))}f.k2=s
f.ok=new Uint8Array(832)
c=f.at
c.toString
f.go=new Uint8Array(4*c)
p=f.p4=16*c
c=8*c
f.R8=c
o=f.bz
o.toString
n=B.af[o]
m=n*p
l=(n/2|0)*c
f.p1=A.q(new Uint8Array(16*p+m),!1,e,m)
c=f.R8
c.toString
f.p2=A.q(new Uint8Array(8*c+l),!1,e,l)
c=f.R8
c.toString
f.p3=A.q(new Uint8Array(8*c+l),!1,e,l)
c=d.a
f.RG=A.q(new Uint8Array(c),!1,e,0)
k=d.a+1>>>1
f.rx=A.q(new Uint8Array(k),!1,e,0)
f.ry=A.q(new Uint8Array(k),!1,e,0)
d=f.bz
d.toString
j=B.af[d]
if(d===2)f.ch=f.ay=0
else{d=B.a.V(f.y-j,16)
f.ay=d
c=B.a.V(f.Q-j,16)
f.ch=c
if(d<0)f.ay=0
if(c<0)f.ch=0}d=B.a.V(f.as+15+j,16)
f.cx=d
c=B.a.V(f.z+15+j,16)
f.CW=c
p=f.at
p.toString
if(c>p)f.CW=p
c=f.ax
c.toString
if(d>c)f.cx=c
i=p+1
s=J.ak(i,t.ai)
for(q=0;q<i;++q)s[q]=new A.hC()
f.k3=s
d=f.at
d.toString
s=J.ak(d,t.cP)
for(q=0;q<d;++q){c=new Int16Array(384)
s[q]=new A.hD(c,new Uint8Array(16))}f.cf=s
d=f.at
d.toString
s=J.ak(d,t.fD)
for(q=0;q<d;++q)s[q]=new A.bF()
f.k4=s
f.jm()
d=$.mD()
c=$.mE()
p=$.mF()
o=$.mG()
h=$.lt()
g=new Int32Array(16)
A.qs()
f.e=new A.k9(d,c,p,o,h,g)
return!0},
j8(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this
f.y2=0
s=f.id
r=f.x
q=f.db
p=0
for(;;){o=f.cx
o.toString
if(!(p<o))break
o=f.cy
o===$&&A.b()
n=q[(p&o-1)>>>0]
for(;;){p=f.y1
o=f.at
o.toString
if(!(p<o))break
o=f.k3
o===$&&A.b()
m=o[0]
l=o[1+p]
o=f.cf
o===$&&A.b()
k=o[p]
if(r.b){p=f.c
p===$&&A.b()
p=p.a4(f.fr.a[0])
o=f.c
j=f.fr
f.k1=p===0?o.a4(j.a[1]):2+o.a4(j.a[2])}p=f.fx
p===$&&A.b()
if(p){p=f.c
p===$&&A.b()
o=f.fy
o===$&&A.b()
i=p.a4(o)!==0}else i=!1
f.j9()
if(!i)i=f.jd(l,n)
else{m.a=l.a=0
p=k.b
p===$&&A.b()
if(!p)m.b=l.b=0
k.f=k.e=0}p=f.bz
p.toString
if(p>0){p=f.dW
p===$&&A.b()
o=f.k1
o===$&&A.b()
o=p[o]
p=k.b
p===$&&A.b()
h=o[p?1:0]
o=f.k4
o===$&&A.b()
o=o[f.y1]
o.a=h.a
o.b=h.b
o.d=h.d
o.c=h.c||!i}++f.y1}p=f.k3
p===$&&A.b()
p=p[0]
p.b=p.a=0
B.c.an(s,0,4,0)
f.y1=0
f.jS()
p=f.bz
p.toString
g=!1
if(p>0){p=f.y2
o=f.ch
o===$&&A.b()
if(p>=o){o=f.cx
o.toString
o=p<=o
g=o}}if(!f.iH(g))return!1
p=++f.y2}return!0},
jS(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=this,b0=null,b1=a9.y2,b2=a9.ok
b2===$&&A.b()
s=A.q(b2,!1,b0,40)
r=A.q(b2,!1,b0,584)
q=A.q(b2,!1,b0,600)
p=a9.p1
p===$&&A.b()
o=t.D
n=o.a(p.a)
p=a9.p2
p===$&&A.b()
m=o.a(p.a)
p=a9.p3
p===$&&A.b()
l=o.a(p.a)
p=a9.p4
p.toString
o=a9.R8
o.toString
k=b1>0
j=b2.$flags|0
i=0
for(;;){h=a9.at
h.toString
if(!(i<h))break
h=a9.cf
h===$&&A.b()
g=h[i]
if(i>0){for(f=-1;f<16;++f){h=40+f*32
A.an(b2,h-4,b2,h+12,4)}for(f=-1;f<8;++f){h=f*32
e=584+h
A.an(b2,e-4,b2,e+4,4)
h=600+h
A.an(b2,h-4,b2,h+4,4)}}else{for(f=0;f<16;++f){j&2&&A.a(b2)
b2[40+f*32-1]=129}for(f=0;f<8;++f){h=f*32
j&2&&A.a(b2)
b2[584+h-1]=129
b2[600+h-1]=129}if(k){j&2&&A.a(b2)
b2[567]=129
b2[551]=129
b2[7]=129}}h=a9.k2
h===$&&A.b()
d=h[i]
c=g.a
b=g.e
if(k){A.an(b2,8,d.a,0,16)
A.an(b2,552,d.b,0,8)
A.an(b2,568,d.c,0,8)}else if(i===0){B.c.an(b2,7,28,127)
B.c.an(b2,551,560,127)
B.c.an(b2,567,576,127)}h=g.b
h===$&&A.b()
if(h){if(k){h=a9.at
h.toString
if(i>=h-1)B.c.an(b2,24,28,d.a[15])
else A.an(b2,24,a9.k2[i+1].a,0,4)}A.an(b2,152,b2,24,4)
A.an(b2,280,b2,24,4)
A.an(b2,408,b2,24,4)
for(h=g.c,a=0;a<16;++a,b=b<<2>>>0){a0=A.r(s,b0,B.bh[a])
B.h3[h[a]].$1(a0)
b.toString
e=a*16
a9.eN(b,new A.a6(c,e,Math.min(384,384),e,!1),a0)}}else{h=A.nM(i,b1,g.c[0])
h.toString
B.iT[h].$1(s)
if(b!==0)for(a=0;a<16;++a,b=b<<2>>>0){a0=A.r(s,b0,B.bh[a])
b.toString
h=a*16
a9.eN(b,new A.a6(c,h,Math.min(384,384),h,!1),a0)}}h=g.f
h===$&&A.b()
e=A.nM(i,b1,g.d)
e.toString
B.b_[e].$1(r)
B.b_[e].$1(q)
e=Math.min(384,384)
a1=new A.a6(c,256,e,256,!1)
if((h&255)!==0){a2=a9.e
if((h&170)!==0){a2===$&&A.b()
a2.bm(a1,r)
a2.bm(A.r(a1,b0,16),A.r(r,b0,4))
a3=A.r(a1,b0,32)
a4=A.r(r,b0,128)
a2.bm(a3,a4)
a2.bm(A.r(a3,b0,16),A.r(a4,b0,4))}else{a2===$&&A.b()
a2.fY(a1,r)}}a5=new A.a6(c,320,e,320,!1)
h=h>>>8
if((h&255)!==0){e=a9.e
if((h&170)!==0){e===$&&A.b()
e.bm(a5,q)
e.bm(A.r(a5,b0,16),A.r(q,b0,4))
h=A.r(a5,b0,32)
a2=A.r(q,b0,128)
e.bm(h,a2)
e.bm(A.r(h,b0,16),A.r(a2,b0,4))}else{e===$&&A.b()
e.fY(a5,q)}}h=a9.ax
h.toString
if(b1<h-1){A.an(d.a,0,b2,520,16)
A.an(d.b,0,b2,808,8)
A.an(d.c,0,b2,824,8)}a6=a9.p1.d+i*16
h=i*8
a7=a9.p2.d+h
a8=a9.p3.d+h
for(f=0;f<16;++f)A.an(n,a6+f*p,b2,40+f*32,16)
for(f=0;f<8;++f){h=f*o
e=f*32
A.an(m,a7+h,b2,584+e,8)
A.an(l,a8+h,b2,600+e,8)}++i}},
eN(a,b,c){var s,r,q,p,o,n
switch(a>>>30){case 3:s=this.e
s===$&&A.b()
s.l7(b,c,!1)
break
case 2:this.e===$&&A.b()
r=J.c(b.a,b.d)+4
q=A.kb(J.c(b.a,b.d+4),35468)
p=A.kb(J.c(b.a,b.d+4),85627)
o=A.kb(J.c(b.a,b.d+1),35468)
n=A.kb(J.c(b.a,b.d+1),85627)
A.kd(c,0,r+p,n,o)
A.kd(c,1,r+q,n,o)
A.kd(c,2,r-q,n,o)
A.kd(c,3,r-p,n,o)
break
case 1:s=this.e
s===$&&A.b()
s.cn(b,c)
break
default:break}},
ix(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=e.p4
d.toString
s=e.k4
s===$&&A.b()
r=s[a]
s=e.p1
s===$&&A.b()
q=t.D
p=q.a(s.a)
o=s.d+a*16
n=r.a
if(n===0)return
if(e.bz===1){if(a>0){s=e.e
s===$&&A.b()
s.ee(p,o,d,n+4)}if(r.c){s=e.e
s===$&&A.b()
s.h9(p,o,d,n)}if(b>0){s=e.e
s===$&&A.b()
s.ef(p,o,d,n+4)}if(r.c){s=e.e
s===$&&A.b()
s.ha(p,o,d,n)}}else{m=r.b
s=e.R8
s.toString
l=e.p2
l===$&&A.b()
k=q.a(l.a)
j=a*8
i=l.d+j
l=e.p3
l===$&&A.b()
h=q.a(l.a)
g=l.d+j
f=r.d
if(a>0){q=e.e
q===$&&A.b()
l=n+4
q.bT(p,o,1,d,16,l,m,f)
q.bT(k,i,1,s,8,l,m,f)
q.bT(h,g,1,s,8,l,m,f)}if(r.c){q=e.e
q===$&&A.b()
q.kD(p,o,d,n,m,f)
q.bS(k,i+4,1,s,8,n,m,f)
q.bS(h,g+4,1,s,8,n,m,f)}if(b>0){q=e.e
q===$&&A.b()
l=n+4
q.bT(p,o,d,1,16,l,m,f)
q.bT(k,i,s,1,8,l,m,f)
q.bT(h,g,s,1,8,l,m,f)}if(r.c){q=e.e
q===$&&A.b()
q.l9(p,o,d,n,m,f)
d=4*s
q.bS(k,i+d,s,1,8,n,m,f)
q.bS(h,g+d,s,1,8,n,m,f)}}},
iG(){var s,r=this,q=r.ay
q===$&&A.b()
s=q
for(;;){q=r.CW
q.toString
if(!(s<q))break
r.ix(s,r.y2);++s}},
iH(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=a.bz
a1.toString
s=B.af[a1]
a1=a.p4
a1.toString
r=s*a1
a1=a.R8
a1.toString
q=(s/2|0)*a1
a1=a.p1
a1===$&&A.b()
p=-r
o=A.r(a1,a0,p)
a1=a.p2
a1===$&&A.b()
n=-q
m=A.r(a1,a0,n)
a1=a.p3
a1===$&&A.b()
l=A.r(a1,a0,n)
k=a.y2
a1=a.cx
a1.toString
j=k*16
i=(k+1)*16
if(a2)a.iG()
if(k!==0){j-=s
a.to=A.r(o,a0,0)
a.x1=A.r(m,a0,0)
a.x2=A.r(l,a0,0)}else{a.to=A.r(a.p1,a0,0)
a.x1=A.r(a.p2,a0,0)
a.x2=A.r(a.p3,a0,0)}a1=k<a1-1
if(a1)i-=s
h=a.as
if(i>h)i=h
a.xr=null
if(a.dX!=null&&j<i){g=a.xr=a.it(j,i-j)
if(g==null)return!1}else g=a0
f=a.Q
if(j<f){e=f-j
d=a.to
d===$&&A.b()
c=d.d
b=a.p4
b.toString
d.d=c+b*e
b=a.x1
b===$&&A.b()
c=b.d
d=a.R8
d.toString
d*=B.a.j(e,1)
b.d=c+d
c=a.x2
c===$&&A.b()
c.d+=d
if(g!=null)g.d=g.d+a.b.a*e
j=f}if(j<i){d=a.to
d===$&&A.b()
c=d.d
b=a.y
d.d=c+b
c=a.x1
c===$&&A.b()
d=b>>>1
c.d=c.d+d
c=a.x2
c===$&&A.b()
c.d+=d
if(g!=null)g.d+=b
a.js(j-f,a.z-b,i-j)}if(a1){a1=a.p1
g=a.p4
g.toString
a1.c0(p,r,o,16*g)
g=a.p2
p=a.R8
p.toString
g.c0(n,q,m,8*p)
p=a.p3
g=a.R8
g.toString
p.c0(n,q,l,8*g)}return!0},
js(a,b,c){if(b<=0||c<=0)return!1
this.iz(a,b,c)
this.iy(a,b,c)
return!0},
dh(a){var s
if((a&-4194304)>>>0===0)s=B.a.j(a,14)
else s=a<0?0:255
return s},
bx(a,b,c,d,e){var s=19077*a,r=this.dh(s+26149*c+-3644112)
d.$flags&2&&A.a(d)
d[e]=r
d[e+1]=this.dh(s-6419*b-13320*c+2229552)
d[e+2]=this.dh(s+33050*b+-4527440)
d[e+3]=255},
cQ(b6,b7,b8,b9,c0,c1,c2,c3,c4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=t.D,a1=a0.a(b6.a),a2=b6.d,a3=a0.a(b8.a),a4=b8.d,a5=a0.a(b9.a),a6=b9.d,a7=a0.a(c0.a),a8=c0.d,a9=a0.a(c1.a),b0=c1.d,b1=a0.a(c2.a),b2=c2.d,b3=b7==null,b4=b3?a:a0.a(b7.a),b5=b3?a:b7.d
if(b5==null)b5=0
b3=c3==null
s=b3?a:a0.a(c3.a)
r=b3?a:c3.d
if(r==null)r=0
a0=c4-1
q=B.a.j(a0,1)
p=(a3[a4]|a5[a6]<<16)>>>0
o=(a7[a8]|a9[b0]<<16)>>>0
n=3*p+o+131074>>>2
b.bx(a1[a2],n&255,n>>>16,b1,b2)
b3=b4!=null
if(b3){n=3*o+p+131074>>>2
m=b4[b5]
s.toString
b.bx(m,n&255,n>>>16,s,r)}for(l=1;l<=q;++l,o=j,p=k){k=(a3[a4+l]|a5[a6+l]<<16)>>>0
j=(a7[a8+l]|a9[b0+l]<<16)>>>0
i=p+k+o+j+524296
h=i+2*(k+o)>>>3
g=i+2*(p+j)>>>3
n=h+p>>>1
f=g+k>>>1
m=2*l
e=a2+m
d=(m-1)*4
b.bx(a1[e-1],n&255,n>>>16,b1,b2+d)
c=m*4
b.bx(a1[e],f&255,f>>>16,b1,b2+c)
if(b3){n=g+o>>>1
f=h+j>>>1
m=b5+m
e=b4[m-1]
s.toString
b.bx(e,n&255,n>>>16,s,r+d)
b.bx(b4[m],f&255,f>>>16,s,r+c)}}if((c4&1)===0){n=3*p+o+131074>>>2
a0*=4
b.bx(a1[a2+c4-1],n&255,n>>>16,b1,b2+a0)
if(b3){n=3*o+p+131074>>>2
b3=b4[b5+c4-1]
s.toString
b.bx(b3,n&255,n>>>16,s,r+a0)}}},
iy(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=h.xr
if(g==null)return
s=t.D.a(g.a)
r=g.d
if(a===0){q=c-1
p=a}else{p=a-1
r-=h.b.a
q=c}g=h.Q
o=h.as
if(g+a+c===o)q=o-g-p
n=h.d.T()
m=h.d.gX()*4
for(g=h.b.a,o=n.$flags|0,l=0;l<q;++l){k=(l+p)*m+3
for(j=0;j<b;++j,k+=4){i=s[r+j]
o&2&&A.a(n)
n[k]=i}r+=g}},
iz(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=g.b,d=A.q(J.aj(g.d.gA(0),0,null),!1,f,a*e.a*4),c=g.to
c===$&&A.b()
s=A.r(c,f,0)
c=g.x1
c===$&&A.b()
r=A.r(c,f,0)
c=g.x2
c===$&&A.b()
q=A.r(c,f,0)
p=a+a0
o=B.a.j(b+1,1)
n=e.a*4
e=g.rx
e===$&&A.b()
m=A.r(e,f,0)
e=g.ry
e===$&&A.b()
l=A.r(e,f,0)
if(a===0){g.cQ(s,f,r,q,r,q,d,f,b)
k=a0}else{e=g.RG
e===$&&A.b()
g.cQ(e,s,m,l,r,q,A.r(d,f,-n),d,b)
k=a0+1}m.a=r.a
l.a=q.a
for(e=2*n,c=-n,j=a;j+=2,j<p;){m.d=r.d
l.d=q.d
i=r.d
h=g.R8
h.toString
r.d=i+h
q.d+=h
d.d+=e
h=s.d
i=g.p4
i.toString
s.d=h+2*i
g.cQ(A.r(s,f,-i),s,m,l,r,q,A.r(d,f,c),d,b)}e=s.d
c=g.p4
c.toString
s.d=e+c
if(g.Q+p<g.as){e=g.RG
e===$&&A.b()
e.cY(0,b,s)
g.rx.cY(0,o,r)
g.ry.cY(0,o,q);--k}else if((p&1)===0)g.cQ(s,f,r,q,r,q,A.r(d,f,n),f,b)
return k},
it(a,b){var s,r,q,p,o,n,m,l,k,j=this,i=j.b,h=i.a,g=i.b
if(a<0||b<=0||a+b>g)return null
if(a===0){i=h*g
j.dY=new Uint8Array(i)
s=j.dX
r=new A.km(s,h,g)
q=s.D()
p=r.d=q&3
r.e=B.a.j(q,2)&3
r.f=B.a.j(q,4)&3
r.r=B.a.j(q,6)&3
if(r.gfJ())if(p===0){if(s.c-s.d<i)r.r=1}else if(p===1){o=new A.dk(B.a_,A.m([],t.J))
o.a=h
o.b=g
i=A.m([],t.Z)
p=A.m([],t.d)
n=new Uint32Array(2)
m=new A.hA(s,n)
n=m.e=J.aj(B.l.gA(n),0,null)
l=s.D()
n.$flags&2&&A.a(n)
n[0]=l
l=s.D()
n.$flags&2&&A.a(n)
n[1]=l
l=s.D()
n.$flags&2&&A.a(n)
n[2]=l
l=s.D()
n.$flags&2&&A.a(n)
n[3]=l
l=s.D()
n.$flags&2&&A.a(n)
n[4]=l
l=s.D()
n.$flags&2&&A.a(n)
n[5]=l
l=s.D()
n.$flags&2&&A.a(n)
n[6]=l
s=s.D()
n.$flags&2&&A.a(n)
n[7]=s
m.b=!1
p=new A.fO(m,o,i,p)
p.dy=h
p.fr=g
r.x=p
p.c5(h,g,!0)
i=r.x
s=i.ch
if(s.length===1&&s[0].a===B.bD&&i.iW()){r.y=!0
i=r.x
s=i.c
k=s.a*s.b
i.db=0
s=B.a.a9(k,4)
s=new Uint8Array(k+(4-s))
i.cy=s
i.cx=J.au(B.c.gA(s),0,null)}else{r.y=!1
r.x.eo(h)}}else r.r=1
j.fE=r}i=j.fE
if(i!=null)if(!i.w){s=j.dY
s===$&&A.b()
if(!i.kq(a,b,s))return null}i=j.dY
i===$&&A.b()
return A.q(i,!1,null,a*h)},
jd(a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4=a3.fr.b,a5=a3.k1
a5===$&&A.b()
s=a3.dy[a5]
a5=a3.cf
a5===$&&A.b()
r=a5[a3.y1]
q=A.q(r.a,!1,null,0)
a5=a3.k3
a5===$&&A.b()
p=a5[0]
q.kP(0,q.c-q.d,0)
a5=r.b
a5===$&&A.b()
if(!a5){o=A.q(new Int16Array(16),!1,null,0)
a5=a6.b
n=p.b
m=a3.du(a7,a4[1],a5+n,s.b,0,o)
a6.b=p.b=m>0?1:0
if(m>1)a3.kb(o,q)
else{l=B.a.j(J.c(o.a,o.d)+3,3)
for(k=0;k<256;k+=16)J.V(q.a,q.d+k,l)}j=a4[0]
i=1}else{j=a4[3]
i=0}h=a6.a&15
g=p.a&15
for(f=0,e=0;e<4;++e){d=g&1
for(c=0,b=0;b<4;++b){m=a3.du(a7,j,d+(h&1),s.a,i,q)
d=m>i?1:0
h=h>>>1|d<<7
a5=J.c(q.a,q.d)!==0?1:0
if(m>3)a5=3
else if(m>1)a5=2
c=c<<2|a5
q.d+=16}h=h>>>4
g=g>>>1|d<<7
f=(f<<8|c)>>>0}a=g>>>4
for(a0=h,a1=0,a2=0;a2<4;a2+=2){a5=4+a2
h=B.a.a0(a6.a,a5)
g=B.a.a0(p.a,a5)
for(c=0,e=0;e<2;++e){d=g&1
for(b=0;b<2;++b){m=a3.du(a7,a4[2],d+(h&1),s.c,0,q)
d=m>0?1:0
h=h>>>1|d<<3
a5=J.c(q.a,q.d)!==0?1:0
if(m>3)a5=3
else if(m>1)a5=2
c=(c<<2|a5)>>>0
q.d+=16}h=h>>>2
g=g>>>1|d<<5}a1=(a1|B.a.M(c,4*a2))>>>0
a0=(a0|B.a.M(h<<4>>>0,a2))>>>0
a=(a|B.a.M(g&240,a2))>>>0}a6.a=a0
p.a=a
r.e=f
r.f=a1
if((a1&43690)===0)s.toString
return(f|a1)>>>0===0},
kb(a,b){var s,r,q,p,o,n,m,l,k,j,i=new Int32Array(16)
for(s=0;s<4;++s){r=12+s
q=J.c(a.a,a.d+s)+J.c(a.a,a.d+r)
p=4+s
o=8+s
n=J.c(a.a,a.d+p)+J.c(a.a,a.d+o)
m=J.c(a.a,a.d+p)-J.c(a.a,a.d+o)
l=J.c(a.a,a.d+s)-J.c(a.a,a.d+r)
i[s]=q+n
i[o]=q-n
i[p]=l+m
i[r]=l-m}for(k=0,s=0;s<4;++s){r=s*4
j=i[r]+3
p=i[3+r]
q=j+p
o=i[1+r]
r=i[2+r]
n=o+r
m=o-r
l=j-p
p=B.a.j(q+n,3)
J.V(b.a,b.d+k,p)
p=B.a.j(l+m,3)
J.V(b.a,b.d+(k+16),p)
p=B.a.j(q-n,3)
J.V(b.a,b.d+(k+32),p)
p=B.a.j(l-m,3)
J.V(b.a,b.d+(k+48),p)
k+=64}},
iK(a,b){var s,r,q,p,o,n
if(a.a4(b[3])===0)s=a.a4(b[4])===0?2:3+a.a4(b[5])
else if(a.a4(b[6])===0)s=a.a4(b[7])===0?5+a.a4(159):7+2*a.a4(165)+a.a4(145)
else{r=a.a4(b[8])
q=2*r+a.a4(b[9+r])
p=B.dO[q]
o=p.length
for(s=0,n=0;n<o;++n)s+=s+a.a4(p[n])
s+=3+B.a.M(8,q)}return s},
du(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k=b[e].a[c]
for(;e<16;e=s){if(a.a4(k[0])===0)return e
while(a.a4(k[1])===0){++e
k=b[B.b9[e]].a[0]
if(e===16)return 16}s=e+1
r=b[B.b9[s]].a
if(a.a4(k[2])===0){k=r[1]
q=1}else{q=this.iK(a,k)
k=r[2]}p=B.fy[e]
o=a.b
o===$&&A.b()
n=a.eq(B.a.j(o,1))
o=a.b
m=B.b7[o]
a.b=B.b6[o]
o=a.d
o===$&&A.b()
a.d=o-m
o=n!==0?-q:q
l=d[e>0?1:0]
J.V(f.a,f.d+p,o*l)}return 16},
j9(){var s,r,q,p,o,n,m,l,k,j=this,i=j.y1,h=4*i,g=j.go,f=j.id,e=j.cf
e===$&&A.b()
s=e[i]
i=j.c
i===$&&A.b()
i=i.a4(145)===0
s.b=i
if(!i){if(j.c.a4(156)!==0)r=j.c.a4(128)!==0?1:3
else r=j.c.a4(163)!==0?2:0
i=s.c
i.$flags&2&&A.a(i)
i[0]=r
g.toString
B.c.an(g,h,h+4,r)
B.c.an(f,0,4,r)}else{q=s.c
for(i=f.$flags|0,p=0,o=0;o<4;++o,p=k){r=f[o]
for(n=0;n<4;++n){e=h+n
m=B.fF[g[e]][r]
l=B.b2[j.c.a4(m[0])]
while(l>0)l=B.b2[2*l+j.c.a4(m[l])]
r=-l
g.$flags&2&&A.a(g)
g[e]=r}k=p+4
g.toString
B.c.a_(q,p,k,g,h)
i&2&&A.a(f)
f[o]=r}}if(j.c.a4(142)===0)i=0
else if(j.c.a4(114)===0)i=2
else i=j.c.a4(183)!==0?1:3
s.d=i}}
A.eE.prototype={
W(a){var s,r
for(s=0;r=a-1,a>0;a=r)s=(s|B.a.Y(this.a4(128),r))>>>0
return s},
c3(a){var s=this.W(a)
return this.W(1)===1?-s:s},
a4(a){var s,r=this,q=r.b
q===$&&A.b()
s=r.eq(B.a.j(q*a,8))
if(r.b<=126)r.jY()
return s},
eq(a){var s,r,q,p,o,n=this,m=n.d
m===$&&A.b()
if(m<0){s=n.a
r=s.c
q=s.d
if(r-q>=1){p=s.D()
m=n.c
m===$&&A.b()
n.c=(p|m<<8)>>>0
m=n.d+8
n.d=m
o=m}else{if(q<r){m=s.D()
s=n.c
s===$&&A.b()
n.c=(m|s<<8)>>>0
s=n.d+8
n.d=s
m=s}else if(!n.e){s=n.c
s===$&&A.b()
n.c=s<<8>>>0
m+=8
n.d=m
n.e=!0}o=m}}else o=m
m=n.c
m===$&&A.b()
if(B.a.bn(m,o)>a){s=n.b
s===$&&A.b()
r=a+1
n.b=s-r
n.c=m-B.a.Y(r,o)
return 1}else{n.b=a
return 0}},
jY(){var s,r=this,q=r.b
q===$&&A.b()
s=B.b7[q]
r.b=B.b6[q]
q=r.d
q===$&&A.b()
r.d=q-s}}
A.k9.prototype={
ef(a,b,c,d){var s,r
for(s=0;s<16;++s){r=b+s
if(this.f0(a,r,c,d))this.cF(a,r,c)}},
ee(a,b,c,d){var s,r
for(s=0;s<16;++s){r=b+s*c
if(this.f0(a,r,1,d))this.cF(a,r,1)}},
ha(a,b,c,d){var s
for(s=1;s<=3;++s)this.ef(a,b+4*s*c,c,d)},
h9(a,b,c,d){var s
for(s=1;s<=3;++s)this.ee(a,b+4*s,c,d)},
l9(a,b,c,d,e,f){var s
for(s=1;s<=3;++s)this.bS(a,b+4*s*c,c,1,16,d,e,f)},
kD(a,b,c,d,e,f){var s
for(s=1;s<=3;++s)this.bS(a,b+4*s,1,c,16,d,e,f)},
bT(a4,a5,a6,a7,a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this
for(s=3*a6,r=2*a6,q=a3.c,p=a3.e,o=a4.$flags|0,n=0;n<a8;++n,a5+=a7)if(a3.f1(a4,a5,a6,a9,b0))if(a3.eX(a4,a5,a6,b1))a3.cF(a4,a5,a6)
else{m=a5-s
l=a4[m]
k=a5-r
j=a4[k]
i=a5-a6
h=a4[i]
g=a4[a5]
f=a5+a6
e=a4[f]
d=a5+r
c=a4[d]
b=q[1020+3*(g-h)+q[1020+j-e]]
a=B.a.j(27*b+63+3456,7)-27
a0=B.a.j(18*b+63+2304,7)-18
a1=B.a.j(9*b+63+1152,7)-9
a2=p[255+l+a1]
o&2&&A.a(a4)
a4[m]=a2
a4[k]=p[255+j+a0]
a4[i]=p[255+h+a]
a4[a5]=p[255+g-a]
a4[f]=p[255+e-a0]
a4[d]=p[255+c-a1]}},
bS(a,a0,a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
for(s=2*a1,r=b.d,q=b.e,p=a.$flags|0,o=0;o<a3;++o,a0+=a2)if(b.f1(a,a0,a1,a4,a5))if(b.eX(a,a0,a1,a6))b.cF(a,a0,a1)
else{n=a0-s
m=a[n]
l=a0-a1
k=a[l]
j=a[a0]
i=a0+a1
h=a[i]
g=3*(j-k)
f=r[B.a.j(g+4+1024,3)-128+112]
e=r[B.a.j(g+3+1024,3)-128+112]
d=B.a.j(f+1+16,1)-8
c=q[255+m+d]
p&2&&A.a(a)
a[n]=c
a[l]=q[255+k+e]
a[a0]=q[255+j-f]
a[i]=q[255+h-d]}},
cF(a,b,c){var s=a[b-2*c],r=b-c,q=a[r],p=a[b],o=3*(p-q)+this.c[1020+s-a[b+c]],n=this.d,m=n[B.a.j(o+4+1024,3)-128+112],l=this.e
n=l[255+q+n[B.a.j(o+3+1024,3)-128+112]]
a.$flags&2&&A.a(a)
a[r]=n
a[b]=l[255+p-m]},
eX(a,b,c,d){var s=a[b-2*c],r=a[b-c],q=a[b],p=a[b+c],o=this.a
return o[255+s-r]>d||o[255+p-q]>d},
f0(a,b,c,d){var s=a[b-2*c],r=a[b-c],q=a[b],p=a[b+c]
return 2*this.a[255+r-q]+this.b[255+s-p]<=d},
f1(a,b,c,d,e){var s=a[b-4*c],r=3*c,q=a[b-r],p=2*c,o=a[b-p],n=a[b-c],m=a[b],l=a[b+c],k=a[b+p],j=a[b+r]
r=this.a
p=255+o
if(2*r[255+n-m]+this.b[p-l]>d)return!1
return r[255+s-q]<=e&&r[255+q-o]<=e&&r[p-n]<=e&&r[255+j-k]<=e&&r[255+k-l]<=e&&r[255+l-m]<=e},
bm(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=t.W.a(a.a),e=t.D.a(b.a),d=this.f,c=a.d
for(s=d.$flags|0,r=0,q=0;q<4;++q){p=f[c]
o=f[c+8]
n=p+o
m=p-o
o=f[c+4]
p=B.a.j(o*35468+1073741824,16)
l=f[c+12]
k=p-16384-(B.a.j(l*85627+1073741824,16)-16384)
j=B.a.j(o*85627+1073741824,16)-16384+(B.a.j(l*35468+1073741824,16)-16384)
i=r+1
s&2&&A.a(d)
d[r]=n+j
r=i+1
d[i]=m+k
i=r+1
d[r]=m-k
r=i+1
d[i]=n-j;++c}h=b.d
for(s=e.$flags|0,r=0,q=0;q<4;++q){g=d[r]+4
p=d[r+8]
n=g+p
m=g-p
p=d[r+4]
o=B.a.j(p*35468+1073741824,16)
l=d[r+12]
k=o-16384-(B.a.j(l*85627+1073741824,16)-16384)
j=B.a.j(p*85627+1073741824,16)-16384+(B.a.j(l*35468+1073741824,16)-16384)
l=e[h]+(B.a.j(n+j+65536,3)-8192)
if((l&-256)>>>0===0)p=l
else p=l<0?0:255
s&2&&A.a(e)
e[h]=p
p=h+1
o=e[p]+(B.a.j(m+k+65536,3)-8192)
if(!((o&-256)>>>0===0))o=o<0?0:255
e[p]=o
o=h+2
p=e[o]+(B.a.j(m-k+65536,3)-8192)
if(!((p&-256)>>>0===0))p=p<0?0:255
e[o]=p
p=h+3
o=e[p]+(B.a.j(n-j+65536,3)-8192)
if(!((o&-256)>>>0===0))o=o<0?0:255
e[p]=o;++r
h+=32}},
l7(a,b,c){this.bm(a,b)
if(c)this.bm(A.r(a,null,16),A.r(b,null,4))},
cn(a,b){var s,r,q,p,o,n
for(s=J.c(a.a,a.d)+4+65536,r=0;r<4;++r)for(q=r*32,p=0;p<4;++p){o=p+q
n=J.c(b.a,b.d+o)+(B.a.j(s,3)-8192)
if(!((n&-256)>>>0===0))n=n<0?0:255
J.V(b.a,b.d+o,n)}},
fY(a,b){var s=this,r=null
if(J.c(a.a,a.d)!==0)s.cn(a,b)
if(J.c(a.a,a.d+16)!==0)s.cn(A.r(a,r,16),A.r(b,r,4))
if(J.c(a.a,a.d+32)!==0)s.cn(A.r(a,r,32),A.r(b,r,128))
if(J.c(a.a,a.d+48)!==0)s.cn(A.r(a,r,48),A.r(b,r,132))}}
A.kg.prototype={}
A.kj.prototype={}
A.kl.prototype={}
A.eD.prototype={}
A.kk.prototype={}
A.ka.prototype={}
A.bF.prototype={}
A.hC.prototype={}
A.hE.prototype={}
A.hD.prototype={}
A.hF.prototype={}
A.eF.prototype={
ce(){var s,r,q,p,o=this,n=o.b
if(n.af(8)!==47)return!1
s=n.af(14)+1
r=n.af(14)+1
q=n.af(1)
o.dy=s
o.fr=r
p=o.c
p.f=B.a9
p.a=s
p.b=r
p.d=q!==0
if(n.af(3)!==0)return!1
return!0},
bp(){var s,r,q,p,o,n,m=this,l=null
m.f=0
if(!m.ce())return l
m.c5(m.dy,m.fr,!0)
m.eo(m.dy)
s=m.dy
m.d=A.Q(l,l,B.e,0,B.i,m.fr,l,0,4,l,B.e,s,!1)
s=m.cx
s.toString
r=m.c
q=r.a
p=r.b
if(!m.dj(s,q,p,p,m.gjo()))return l
s=r.w
if(s.length!==0){o=A.q(new A.aV(s),!1,l,0)
s=m.d
s.toString
s.e=A.lA(o)}n=r.r
if(n!=null)m.d.c=new A.bb("ICC_PROFILE",B.a2,n)
return m.d},
eo(a){var s,r=this,q=r.c
q=q.a*q.b+a
s=new Uint32Array(q+a*16)
r.cx=s
r.cy=J.aj(B.l.gA(s),0,null)
r.db=q
return!0},
jR(a){var s,r,q,p=this,o=p.b,n=o.af(2),m=p.CW,l=B.a.M(1,n)
if((m&l)>>>0!==0)return!1
p.CW=(m|l)>>>0
s=new A.hB(B.bC)
p.ch.push(s)
m=B.iG[n]
s.a=m
s.b=a[0]
s.c=a[1]
switch(m.a){case 0:case 1:o=o.af(3)+2
s.e=o
s.d=p.c5(A.bG(s.b,o),A.bG(s.c,s.e),!1)
break
case 3:r=o.af(8)+1
if(r>16)q=0
else if(r>4)q=1
else{o=r>2?2:3
q=o}a[0]=A.bG(s.b,q)
s.e=q
s.d=p.c5(r,1,!1)
p.iC(r,s)
break
case 2:break}return!0},
c5(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(c)for(s=k.b,r=t.t,q=b,p=a;s.af(1)!==0;){o=A.m([p,q],r)
if(!k.jR(o))throw A.e(A.i("Invalid Transform"))
p=o[0]
q=o[1]}else{q=b
p=a}s=k.b
if(s.af(1)!==0){n=s.af(4)
if(!(n>=1&&n<=11))throw A.e(A.i("Invalid Color Cache"))}else n=0
if(!k.jE(p,q,n,c))throw A.e(A.i("Invalid Huffman Codes"))
if(n>0){s=B.a.M(1,n)
k.w=s
k.x=new A.kh(new Uint32Array(s),32-n)}else k.w=0
s=k.c
s.a=p
s.b=q
m=k.z
k.Q=A.bG(p,m)
k.y=m===0?4294967295:B.a.M(1,m)-1
if(c){k.f=0
return null}l=new Uint32Array(p*q)
if(!k.dj(l,p,q,q,null))throw A.e(A.i("Failed to decode image data."))
k.f=0
return l},
dj(b2,b3,b4,b5,b6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=506832829,a7=a5.f,a8=B.a.a5(a7,b3),a9=B.a.a9(a7,b3),b0=b3*b4,b1=b3*b5
if(a7>=b1){if(b6!=null)b6.$2(b5,!1)
return!0}s=a5.eQ(a9,a8)
r=a5.w
q=280+r
p=r>0?a5.x:null
o=a5.y
for(r=b2.$flags|0,n=a5.b,m=b6!=null,l=a7;l<b1;){if((a9&o)>>>0===0){k=a5.c8(a5.as,a5.Q,a5.z,a9,a8)
s=a5.ax[k]}j=0
if(s.d){i=s.c
r&2&&A.a(b2)
b2[l]=i;++l;++a9
if(a9>=b3){++a8
if(m&&a8<=b5)b6.$2(a8,!0)
if(p!=null)for(i=p.a,h=p.b,g=i.$flags|0;a7<l;){f=b2[a7]
e=B.a.U(A.f5(f,a6),h)
g&2&&A.a(i)
i[e]=f;++a7}a9=j}continue}if(n.a>=32)n.bK()
if(s.e){d=s.f[n.cl()&63]
i=d.a
h=n.a
if(i<256){n.a=h+i
i=d.b
r&2&&A.a(b2)
b2[l]=i
c=0}else{n.a=h+(i-256)
c=d.b}if(n.b)break
if(c===0){++l;++a9
if(a9>=b3){++a8
if(m&&a8<=b5)b6.$2(a8,!0)
if(p!=null)for(i=p.a,h=p.b,g=i.$flags|0;a7<l;){f=b2[a7]
e=B.a.U(A.f5(f,a6),h)
g&2&&A.a(i)
i[e]=f;++a7}a9=j}continue}}else c=s.bM(0,n)
if(c<256){if(s.b){i=s.c
r&2&&A.a(b2)
b2[l]=(i|c<<8)>>>0}else{b=s.bM(1,n)
if(n.a>=32)n.bK()
a=A.oE(s.bM(2,n),c,b,s.bM(3,n))
r&2&&A.a(b2)
b2[l]=a}++l;++a9
if(a9>=b3){++a8
if(m&&a8<=b5)b6.$2(a8,!0)
if(p!=null)for(i=p.a,h=p.b,g=i.$flags|0;a7<l;){f=b2[a7]
e=B.a.U(A.f5(f,a6),h)
g&2&&A.a(i)
i[e]=f;++a7}a9=j}}else if(c<280){a0=a5.cJ(c-256)
a1=s.bM(4,n)
if(n.a>=32)n.bK()
a2=a5.f3(b3,a5.cJ(a1))
if(l<a2||b0-l<a0)return!1
else{a3=l-a2
for(a4=0;a4<a0;++a4){i=b2[a3+a4]
r&2&&A.a(b2)
b2[l+a4]=i}}l+=a0
a9+=a0
while(a9>=b3){a9-=b3;++a8
if(m&&a8<=b5)b6.$2(a8,!0)}if((a9&o)>>>0!==0){k=a5.c8(a5.as,a5.Q,a5.z,a9,a8)
s=a5.ax[k]}if(p!=null)for(i=p.a,h=p.b,g=i.$flags|0;a7<l;){f=b2[a7]
e=B.a.U(A.f5(f,a6),h)
g&2&&A.a(i)
i[e]=f;++a7}}else if(c<q){while(a7<l){i=b2[a7]
h=p.a
g=p.b
g=B.a.U(A.f5(i,a6),g)
h.$flags&2&&A.a(h)
h[g]=i;++a7}i=p.a
h=i[c-280]
r&2&&A.a(b2)
b2[l]=h;++l;++a9
if(a9>=b3){++a8
if(m&&a8<=b5)b6.$2(a8,!0)
for(h=p.b,g=i.$flags|0;a7<l;){f=b2[a7]
e=B.a.U(A.f5(f,a6),h)
g&2&&A.a(i)
i[e]=f;++a7}a9=j}}else return!1}if(m)b6.$2(a8>b5?b5:a8,!1)
a5.f=l
return!0},
iW(){var s,r,q,p,o
if(this.w>0)return!1
for(s=this.at,r=this.ax,q=0;q<s;++q){p=r[q].a
o=p[1]
if(o.a[o.b].a>0)return!1
o=p[2]
if(o.a[o.b].a>0)return!1
o=p[3]
if(o.a[o.b].a>0)return!1}return!0},
iF(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this
if(b&&B.a.a9(a,16)!==0)return
s=h.r
r=a-s
q=h.dy
p=q*s
while(r>0){o=r>16?16:r
n=q*o
m=q*s
l=h.db
h.ep(s,o,p)
for(q=h.dx,k=h.cx,j=0;j<n;++j){q.toString
i=k[l+j]
q.$flags&2&&A.a(q)
q[m+j]=i>>>8&255}r-=o
q=h.dy
p+=o*q
s+=o}h.r=a},
i4(a,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.f,e=B.a.a5(f,a),d=B.a.a9(f,a),c=a*a0,b=a*a1
if(f>=b){g.cH(e)
return!0}s=g.eQ(d,e)
r=g.y
q=g.b
for(;;){if(!(!q.b&&f<b))break
if((d&r)>>>0===0){p=g.c8(g.as,g.Q,g.z,d,e)
s=g.ax[p]}if(q.a>=32)q.bK()
o=s.bM(0,q)
if(o<256){n=g.cy
n===$&&A.b()
n.$flags&2&&A.a(n)
n[f]=o;++f;++d
if(d>=a){++e
if(B.a.a9(e,16)===0)g.cH(e)
d=0}}else if(o<280){m=g.cJ(o-256)
l=s.bM(4,q)
if(q.a>=32)q.bK()
k=g.f3(a,g.cJ(l))
if(f>=k&&c-f>=m)for(n=g.cy,j=0;j<m;++j){n===$&&A.b()
i=f+j
h=n[i-k]
n.$flags&2&&A.a(n)
n[i]=h}else{g.f=f
return!0}f+=m
d+=m
while(d>=a){d-=a;++e
if(B.a.a9(e,16)===0)g.cH(e)}if(f<b&&(d&r)>>>0!==0){p=g.c8(g.as,g.Q,g.z,d,e)
s=g.ax[p]}}else return!1}g.cH(e)
g.f=f
return!0},
cH(a){var s,r,q,p=this,o=p.r,n=a-o,m=p.cy
m===$&&A.b()
s=A.q(m,!1,null,p.c.a*o)
if(n>0){r=p.r
o=p.dx
o.toString
q=A.q(o,!1,null,p.dy*r)
p.ch[0].kl(r,r+n,s,q)}p.r=a},
jp(a,b){var s,r,q,p,o,n,m,l,k,j=this,i=j.c.a,h=j.r
if(b)if(B.a.a9(a,16)!==0)return
s=a-h
if(s<=0){j.r=a
return}j.ep(h,s,i*h)
i=j.cx
i.toString
r=j.d.T()
h=j.r
q=j.dy
p=h*q*4
for(o=j.db,h=r.$flags|0,n=0;n<s;++n)for(m=0;m<q;++m,++o){l=i[o]
k=p+1
h&2&&A.a(r)
r[p]=l>>>16&255
p=k+1
r[k]=l>>>8&255
k=p+1
r[p]=l&255
p=k+1
r[k]=l>>>24&255}j.r=a},
ep(a,b,c){var s,r=this,q=r.ch,p=q.length,o=r.c.a,n=a+b,m=r.db,l=r.cx
l.toString
B.l.a_(l,m,m+o*b,l,c)
for(;s=p-1,p>0;p=s){o=q[s]
l=r.cx
l.toString
o.kL(a,n,l,m,l,m)}},
jE(a,b,c,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=1,d=null
if(a0&&f.b.af(1)!==0){s=2+f.b.af(3)
r=A.bG(a,s)
q=A.bG(b,s)
p=r*q
o=f.c5(r,q,!1)
if(o==null)return!1
f.z=s
for(n=o.$flags|0,m=e,l=0;l<p;++l){k=o[l]>>>8&65535
n&2&&A.a(o)
o[l]=k
if(k>=m)m=k+1}if(m>1000||m>a*b){d=new Int32Array(1)
B.E.an(d,0,1,255)
for(e=0,l=0;l<p;++l){j=o[l]
if(d[j]===-1){i=e+1
d[j]=e
e=i}h=d[j]
n&2&&A.a(o)
o[l]=h}}else e=m}else{o=null
m=1}if(f.b.b)return!1
g=f.jF(c,e,m,d)
if(g==null)return!1
f.as=o
f.at=e
f.ax=g
return!0},
dJ(a,b,c,d,e,f){var s,r=a.a,q=a.b,p=d
do{p-=c
s=r[q+(b+p)]
s.a=e
s.b=f}while(p>0)},
j0(a,b,c){var s=B.a.Y(1,b-c)
while(b<15){s-=a[b]
if(s<=0)break;++b
s=s<<1>>>0}return b-c},
eU(a,b){var s=B.a.Y(1,b-1)
while((a&s)>>>0!==0)s=s>>>1
return s!==0?((a&s-1)>>>0)+s:a},
es(a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=B.a.M(1,a5),a2=new Int32Array(16),a3=new Int32Array(16)
for(s=0;s<a7;++s){r=a6[s]
if(r>15)return 0
a2[r]=a2[r]+1}if(a2[0]===a7)return 0
a3[1]=0
for(q=1;q<15;q=p){r=a2[q]
if(r>B.a.M(1,q))return 0
p=q+1
a3[p]=a3[q]+r}for(r=a8!=null,s=0;s<a7;++s){o=a6[s]
if(o>0)if(r){n=a3[o]
if(n>=a7)return 0
a3[o]=n+1
a8.$flags&2&&A.a(a8)
a8[n]=s}else a3[o]=a3[o]+1}if(a3[15]===1){if(r){a4.toString
a0.dJ(a4,0,1,a1,0,a8[0])}return a1}m=a1-1
for(l=0,k=1,j=1,s=0,q=1,i=2;q<=a5;++q,i=i<<1>>>0){j=j<<1>>>0
k+=j
j-=a2[q]
if(j<0)return 0
if(a4==null)continue
for(h=q&255;a2[q]>0;a2[q]=a2[q]-1,s=g){g=s+1
a0.dJ(a4,l,i,a1,h,a8[s])
l=a0.eU(l,q)}}for(q=a5+1,r=a4!=null,f=a1,e=0,d=4294967295,i=2;q<=15;++q,i=i<<1>>>0){j=j<<1>>>0
k+=j
j-=a2[q]
if(j<0)return 0
for(h=q-a5&255;a2[q]>0;a2[q]=a2[q]-1){c=(l&m)>>>0
if(c!==d){if(r)e+=f
b=a0.j0(a2,q,a5)
f=B.a.Y(1,b)
a1+=f
if(r){n=a4.a[a4.b+c]
n.a=b+a5&255
n.b=e-c}d=c}if(r){g=s+1
a=a8[s]
a0.dJ(a4,e+B.a.a0(l,a5),i,f,h,a)
s=g}l=a0.eU(l,q)}}if(k!==2*a3[15]-1)return 0
return a1},
fk(a,b,c,d){var s,r,q,p,o,n,m=this.es(null,b,c,d,null)
if(m===0||a==null)return m
s=a.b
r=s.d
q=s.e
if(r+m>=q){p=new A.dU()
if(m>q)q=m
o=A.lE(q)
p.e=q
p.b=p.a=o
a.b=p
s=p}n=new Uint16Array(d)
this.es(s.b,b,c,d,n)
return m},
jD(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=new A.fv(new A.dU())
c.el(128)
if(this.fk(c,7,a,19)===0)return!1
s=this.b
if(s.af(1)!==0){r=2+s.af(2+2*s.af(3))
if(r>b)return!1}else r=b
for(q=a0.$flags|0,p=8,o=0;o<b;r=n){n=r-1
if(r===0)break
if(s.a>=32)s.bK()
m=c.b.a
m.toString
l=m.a[m.b+(s.cl()&127)]
s.a=s.a+l.a
k=l.b
if(k<16){j=o+1
q&2&&A.a(a0)
a0[o]=k
if(k!==0)p=k
o=j}else{i=k-16
h=B.cP[i]
g=B.cY[i]
f=s.af(h)+g
if(o+f>b)return!1
e=k===16?p:0
for(;d=f-1,f>0;f=d,o=j){j=o+1
q&2&&A.a(a0)
a0[o]=e}}}return!0},
f8(a,b,c){var s,r,q,p,o,n,m=this.b,l=m.af(1)
B.E.an(b,0,a,0)
if(l!==0){s=m.af(1)
r=m.af(m.af(1)===0?1:8)
b.$flags&2&&A.a(b)
b[r]=1
if(s+1===2)b[m.af(8)]=1
q=!0}else{p=new Int32Array(19)
o=m.af(4)+4
for(n=0;n<o;++n)p[B.fj[n]]=m.af(3)
q=this.jD(p,a,b)}return q&&!m.b?this.fk(c,8,b,a):0},
cw(a,b,c){var s=c.a,r=a.a
c.a=s+r
c.b=(c.b|B.a.M(a.b,b))>>>0
return r},
hM(a){var s,r,q,p,o,n,m,l=this
for(s=a.a,r=a.f,q=0;q<64;++q){p=r[q]
o=s[0]
n=o.a[o.b+q]
o=n.b
if(o>=256){p.a=n.a+256
p.b=o}else{p.b=p.a=0
m=B.a.a0(q,l.cw(n,8,p))
o=s[1]
m=B.a.a0(m,l.cw(o.a[o.b+m],16,p))
o=s[2]
m=B.a.a0(m,l.cw(o.a[o.b+m],0,p))
o=s[3]
B.a.a0(m,l.cw(o.a[o.b+m],24,p))}}},
jF(a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=null,a3=a7>0,a4=a3?B.a.M(1,a7):0,a5=B.eb[a7],a6=b0==null
if(a6&&a8!==a9)return a2
s=new Int32Array(280+a4)
r=J.ak(a8,t.ct)
for(q=0;q<a8;++q)r[q]=A.pA()
a4=new A.fv(new A.dU())
a4.el(a8*a5)
a1.ay=a4
for(a4=!a6,p=0;p<a9;++p)if(a4&&b0[p]===-1)for(o=0;o<5;++o){n=B.aY[o]
if(a1.f8(o===0&&a3?n+B.a.M(1,a7):n,s,a2)===0)return a2}else{m=r[a6?p:b0[p]]
l=m.a
for(k=0,j=!0,i=0,o=0;o<5;++o){n=B.aY[o]
if(o===0&&a3)n+=B.a.M(1,a7)
h=a1.f8(n,s,a1.ay)
g=a1.ay.b
f=g.b
f.toString
l[o]=f
if(h===0)return a2
if(j&&B.h1[o]===1)j=f.a[f.b].a===0
e=f.a
f=f.b
i+=e[f].a
g.d+=h
g.b=new A.dT(e,f+h)
if(o<=3){d=s[0]
for(c=1;c<n;++c){b=s[c]
if(b>d)d=b}k+=d}}m.b=j
m.d=!1
g=!1
if(j){f=l[1]
a=f.a[f.b].b
f=l[2]
a0=f.a[f.b].b
f=l[3]
f=(f.a[f.b].b<<24|a<<16|a0)>>>0
m.c=f
if(i===0){g=l[0]
g=g.a[g.b].b<256}if(g){m.d=!0
e=l[0]
m.c=(f|e.a[e.b].b<<8)>>>0}}g=!g&&k<6
m.e=g
if(g)a1.hM(m)}return r},
cJ(a){var s
if(a<4)return a+1
s=B.a.j(a-2,1)
return B.a.M(2+(a&1),s)+this.b.af(s)+1},
f3(a,b){var s,r
if(b>120)return b-120
else{s=B.en[b-1]
r=(s>>>4)*a+(8-(s&15))
return r>=1?r:1}},
iC(a,b){var s,r,q,p,o,n,m=B.a.M(1,B.a.a0(8,b.e)),l=new Uint32Array(m),k=b.d
k.toString
s=J.aj(B.l.gA(k),0,null)
r=J.aj(B.l.gA(l),0,null)
l[0]=b.d[0]
q=4*a
for(k=r.$flags|0,p=4;p<q;++p){o=s[p]
n=r[p-4]
k&2&&A.a(r)
r[p]=o+n&255}for(q=4*m;p<q;++p){k&2&&A.a(r)
r[p]=0}b.d=l
return!0},
c8(a,b,c,d,e){if(c===0||a==null)return 0
return a[b*B.a.j(e,c)+B.a.j(d,c)]},
eQ(a,b){var s=this,r=s.c8(s.as,s.Q,s.z,a,b)
return s.ax[r]}}
A.fO.prototype={
kB(a,b){return this.iF(a,b)}}
A.hA.prototype={
cl(){var s,r,q=this.a
if(q<32){s=this.d
r=B.a.U(s[0],q)+((s[1]&B.am[q])>>>0)*(B.am[32-q]+1)}else{s=this.d
r=q===32?s[1]:B.a.U(s[1],q-32)}return r},
af(a){var s,r,q=this
if(!q.b&&a<25){s=q.cl()
r=B.am[a]
q.a+=a
q.bK()
return(s&r)>>>0}else{q.b=!0
throw A.e(A.i("Not enough data in input."))}},
bK(){var s,r,q,p=this,o=p.c,n=p.d,m=n.$flags|0,l=o.c
for(;;){if(!(p.a>=8&&o.d<l))break
s=J.c(o.a,o.d++)
r=n[0]
q=n[1]
m&2&&A.a(n)
n[0]=(r>>>8)+(q&255)*16777216
n[1]=q>>>8
n[1]=(n[1]|s*16777216)>>>0
p.a-=8}}}
A.kh.prototype={}
A.co.prototype={
a6(){return"VP8LImageTransformType."+this.b}}
A.hB.prototype={
kL(a,b,c,d,e,f){var s,r,q,p,o=this,n=o.b
switch(o.a.a){case 2:o.kh(e,f,(b-a)*n)
break
case 0:o.kQ(a,b,c,d,e,f)
if(b!==o.c){s=f-n
B.l.a_(e,s,s+n,c,f+(b-a-1)*n)}break
case 1:o.km(a,b,c,d,e,f)
break
case 3:if(d===f&&o.e>0){r=b-a
q=r*A.bG(n,o.e)
p=f+r*n-q
B.l.a_(e,p,p+q,c,f)
o.fB(a,b,c,p,e,f)}else o.fB(a,b,c,d,e,f)
break}},
kl(a,b,c,d){var s,r,q,p,o,n,m=this.e,l=B.a.a0(8,m),k=this.b,j=this.d
if(l<8){s=B.a.M(1,m)-1
r=B.a.M(1,l)-1
for(q=a;q<b;++q)for(p=0,o=0;o<k;++o){if((o&s)>>>0===0){p=J.c(c.a,c.d);++c.d}m=j[(p&r)>>>0]
J.V(d.a,d.d,m>>>8&255);++d.d
p=B.a.j(p,l)}}else for(q=a;q<b;++q)for(o=0;o<k;++o){n=J.c(c.a,c.d);++c.d
m=j[n]
J.V(d.a,d.d,m>>>8&255);++d.d}},
fB(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k=this.e,j=B.a.a0(8,k),i=this.b,h=this.d
if(j<8){s=B.a.M(1,k)-1
r=B.a.M(1,j)-1
for(k=e.$flags|0,q=a;q<b;++q)for(p=0,o=0;o<i;++o,f=m){if((o&s)>>>0===0){n=d+1
p=c[d]>>>8&255
d=n}m=f+1
l=h[p&r]
k&2&&A.a(e)
e[f]=l
p=B.a.a0(p,j)}}else for(k=e.$flags|0,q=a;q<b;++q)for(o=0;o<i;++o,f=m,d=n){m=f+1
n=d+1
l=h[c[d]>>>8&255]
k&2&&A.a(e)
e[f]=l}},
km(a3,a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=c.b,a=c.e,a0=B.a.M(1,a)-1,a1=A.bG(b,a),a2=B.a.j(a3,c.e)*a1
for(a=a7.$flags|0,s=a3;s<a4;){r=new Uint8Array(3)
for(q=a2,p=0;p<b;++p){if((p&a0)>>>0===0){o=q+1
n=c.d[q]
r[0]=n&255
r[1]=n>>>8&255
r[2]=n>>>16&255
q=o}n=a5[a6+p]
m=n>>>8&255
l=r[0]
k=$.ai()
k.$flags&2&&A.a(k)
k[0]=l
l=$.at()
j=l[0]
k[0]=m
i=l[0]
h=$.mJ()
h.$flags&2&&A.a(h)
h[0]=j*i
g=$.p0()
f=(n>>>16&255)+(g[0]>>>5)>>>0&255
k[0]=r[1]
j=l[0]
k[0]=m
h[0]=j*l[0]
e=g[0]
k[0]=r[2]
j=l[0]
k[0]=f
h[0]=j*l[0]
d=g[0]
a&2&&A.a(a7)
a7[a8+p]=(n&4278255360|f<<16|((n&255)+(e>>>5)>>>0)+(d>>>5)>>>0&255)>>>0}a8+=b
a6+=b;++s
if((s&a0)>>>0===0)a2+=a1}},
bP(a,b){return(((a&4278255360)>>>0)+((b&4278255360)>>>0)&4278255360|(a&16711935)+(b&16711935)&16711935)>>>0},
kQ(a8,a9,b0,b1,b2,b3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=4278190080,a7=a5.b
if(a8===0){s=a5.bP(b0[b1],a6)
b2.$flags&2&&A.a(b2)
b2[b3]=s
r=b1+1
q=b3+1
p=a7-1
o=b2[b3]
for(n=0;n<p;++n){o=a5.bP(b0[r+n],o)
b2[q+n]=o}b1+=a7
b3+=a7;++a8}s=a5.e
m=B.a.M(1,s)
l=m-1
k=A.bG(a7,s)
j=B.a.j(a8,a5.e)*k
for(s=~l,i=b2.$flags|0,h=a8;h<a9;){g=b2[b3-a7]
f=a5.bP(b0[b1],g)
i&2&&A.a(b2)
b2[b3]=f
for(e=j,d=1;d<a7;d=a0,e=c){c=e+1
b=a5.d[e]>>>8&15
a=$.r0[b]
a0=((d&s)>>>0)+m
if(a0>a7)a0=a7
a1=b1+d
f=b3+d
a2=f-a7
a3=a0-d
if(b===0)for(n=0;n<a3;++n)b2[f+n]=a5.bP(b0[a1+n],a6)
else if(b===1){o=b2[f-1]
for(n=0;n<a3;++n){o=a5.bP(b0[a1+n],o)
b2[f+n]=o}}else for(n=0;n<a3;++n){a4=f+n
g=a.$3(b2[a4-1],b2,a2+n)
b2[a4]=a5.bP(b0[a1+n],g)}}b1+=a7
b3+=a7;++h
if((h&l)>>>0===0)j+=k}},
kh(a,b,c){var s,r,q,p,o
for(s=a.$flags|0,r=0;r<c;++r){q=b+r
p=a[q]
o=p>>>8&255
s&2&&A.a(a)
a[q]=(p&4278255360|(p&16711935)+(o<<16|o)&16711935)>>>0}}}
A.km.prototype={
gfJ(){var s=this,r=s.d
if(r>1||s.e>=4||s.f>1||s.r!==0)return!1
return!0},
kq(a,b,c){var s,r,q,p,o,n,m=this
if(!m.gfJ())return!1
s=B.iV[m.e]
if(m.d===0){r=m.b
q=a*r
p=m.a
B.c.a_(c,q,q+b*r,p.a,p.d-p.b+q)}else{r=a+b
p=m.x
p===$&&A.b()
p.dx=c
o=p.c
if(m.y)r=p.i4(o.a,o.b,r)
else{n=p.cx
n.toString
p=p.dj(n,o.a,o.b,r,p.gkA())
r=p}if(!r)return!1}if(s!=null){r=m.b
s.$6(r,m.c,r,a,b,c)}if(m.f===1)if(!m.iw(c,m.b,m.c,a,b))return!1
if(a+b>=m.c)m.w=!0
return!0},
iw(a,b,c,d,e){if(b<=0||c<=0||d<0||e<0||d+e>c)return!1
return!0}}
A.eG.prototype={
hz(a,b){var s=this,r=a.D()
s.w=0
s.f=(r&1)!==0
s.r=(r&2)===0
s.x=a.d-a.b
s.y=b-16}}
A.fP.prototype={}
A.ft.prototype={}
A.fu.prototype={}
A.dT.prototype={
gp(a){return this.a.length-this.b}}
A.dS.prototype={
bM(a,b){var s,r=b.cl()&255,q=this.a,p=q[a],o=p.a[p.b+r].a-8
if(o>0){b.a+=8
s=b.cl()
q=q[a]
r=r+q.a[q.b+r].b+((s&B.a.Y(1,o)-1)>>>0)}else q=p
p=b.a
q=q.a[q.b+r]
b.a=p+q.a
return q.b}}
A.dU.prototype={}
A.fv.prototype={
el(a){var s=this.b=this.a,r=A.lE(a)
s.e=a
s.b=s.a=r}}
A.dj.prototype={
a6(){return"WebPFormat."+this.b}}
A.dk.prototype={}
A.fQ.prototype={}
A.kn.prototype={
aA(a){var s,r=A.q(a,!1,null,0)
this.c=r
try{r=this.eP(r)
return r}catch(s){return!1}},
au(a){return A.J(new A.kq(this,a))},
ke(a){var s,r,q,p,o=this,n=null,m=A.q(a,!1,n,0)
o.c=m
if(!o.eP(m))return n
m=new A.fQ(B.a_,A.m([],t.J))
o.a=m
s=o.c
s.toString
if(!o.eR(s,m))return n
m=o.a
switch(m.f.a){case 3:s=o.b
A.ag(m.a,m.b,s,!1)
for(m=o.a.z,r=m.length,q=0;q<m.length;m.length===r||(0,A.a5)(m),++q){p=m[q]
A.ag(p.c,p.d,s,!1)}m=o.a
m.as=m.z.length
return m
case 2:s=o.c
s.toString
s.d=m.ay
if(!A.m8(s,m).ce())return n
m=o.a
A.ag(m.a,m.b,o.b,!1)
m=o.a
m.as=m.z.length
return m
case 1:s=o.c
s.toString
s.d=m.ay
if(!A.m6(s,m).ce())return n
m=o.a
A.ag(m.a,m.b,o.b,!1)
m=o.a
m.as=m.z.length
return m
case 0:throw A.e(A.i("Unknown format for WebP"))}},
ab(a){return A.J(new A.ko(this,a))},
ii(a){var s,r,q,p,o=this,n=o.c
if(n==null||o.a==null)return null
s=o.a
if(s.e){s=s.z
r=s.length
if(a>=r)return null
q=s[a]
s=q.y
s===$&&A.b()
r=q.x
r===$&&A.b()
return o.fl(n.bE(s,r),a)}r=s.f
if(r===B.a9){p=n.bE(s.ch,s.ay)
n=o.a
n.toString
return A.m8(p,n).bp()}else if(r===B.av){p=n.bE(s.ch,s.ay)
n=o.a
n.toString
return A.m6(p,n).bp()}return null},
aS(a,b){return A.J(new A.kp(this,a,b))},
kd(a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=null
if(a1.au(a3)==null)return a2
s=a1.a
r=s.e
if(!r)return a1.ab(0)
new A.bh(a1.b).bL(0,s.a*s.as,s.b)
for(s=t.N,r=t.P,q=a2,p=q,o=p,n=0;m=a1.a,n<m.as;++n){a4=m.z[n]
l=a1.ab(n)
if(l==null)continue
m=a4.e
l.y=m
if(o==null||p==null){k=a1.a
j=k.a
k=k.b
i=l.gbs()
h=l.a
h=h==null?a2:h.gH()
if(h==null)h=B.e
g=l.y
f=a1.a
e=f.y
d=f.c
f=f.w
if(f.length===0)f=a2
else{f=new A.aV(f)
c=f.gp(0)
b=f.gp(0)
a=new A.bR(A.O(s,r))
a.bu(new A.a6(f,0,Math.min(c,b),0,!1))
f=a}a0=a1.a.r
o=A.Q(d,f,h,g,B.i,k,a0==null?a2:new A.bb("ICC_PROFILE",B.a2,a0),e,i,a2,B.e,j,!1)
p=o}else{p=A.aK(p,!1,!1)
if(q!=null){k=q.f
k===$&&A.b()}else k=!1
if(k){k=q.a
j=q.b
i=q.c
h=q.d
A.or(p,!1,$.oW(),k,k+i-1,j,j+h-1)}}p.y=m
m=a4.r
m===$&&A.b()
m=m?B.aa:B.a0
A.mr(p,l,m,a2,a2,a4.a,a4.b,a2,a2,a2,a2)
if(p!==o)o.aY(p)
q=a4}return o},
fl(a,b){var s,r,q,p=null,o=A.m([],t.J),n=new A.fQ(B.a_,o)
if(!this.eR(a,n))return p
if(n.f===B.a_)return p
n.as=this.a.as
if(n.e){s=o.length
if(b>=s)return p
r=o[b]
o=r.y
o===$&&A.b()
s=r.x
s===$&&A.b()
return this.fl(a.bE(o,s),b)}else{q=a.bE(n.ch,n.ay)
o=n.f
if(o===B.a9)return A.m8(q,n).bp()
else if(o===B.av)return A.m6(q,n).bp()}return p},
eP(a){if(a.ag(4)!=="RIFF")return!1
a.i()
if(a.ag(4)!=="WEBP")return!1
return!0},
eR(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g
for(s=a.c,r=a.b;a.d<s;){q=a.ag(4)
p=a.i()
o=p+1>>>1<<1>>>0
n=a.d
m=n-r
switch(q){case"VP8X":if(!this.iL(a,b))return!1
break
case"VP8 ":b.ay=m
b.ch=p
b.f=B.av
break
case"VP8L":b.ay=m
b.ch=p
b.f=B.a9
break
case"ALPH":b.toString
n=a.a
l=a.e
k=J.a3(n)
j=k.gp(n)
k=k.gp(n)
n=new A.a6(n,0,Math.min(j,k),0,l)
b.at=n
n.d=a.d
a.d+=o
break
case"ANIM":b.f=B.ke
i=a.i()
n=new Uint8Array(4)
n[0]=i>>>16&255
n[1]=i>>>8&255
n[2]=i&255
n[3]=i>>>24&255
b.c=new A.bO(n)
b.y=a.k()
break
case"ANMF":if(!this.iI(a,b,p))return!1
break
case"ICCP":b.toString
h=a.aq(p)
a.d=a.d+(h.c-h.d)
b.r=h.T()
break
case"EXIF":b.toString
b.w=a.ag(p)
break
case"XMP ":b.toString
a.ag(p)
break
default:a.d=n+o
break}n=a.d
g=o-(n-r-m)
if(g>0)a.d=n+g}if(!b.d)b.d=b.at!=null
return b.f!==B.a_},
iL(a,b){var s,r,q,p,o=a.D()
if((o&192)!==0)return!1
s=B.a.j(o,4)
r=B.a.j(o,1)
if((o&1)!==0)return!1
if(a.b6()!==0)return!1
q=a.b6()
p=a.b6()
b.a=q+1
b.b=p+1
b.e=(r&1)!==0
b.d=(s&1)!==0
return!0},
iI(a,b,c){var s=new A.fP(a.b6()*2,a.b6()*2,a.b6()+1,a.b6()+1,a.b6())
s.hz(a,c)
if(s.w!==0)return!1
b.z.push(s)
return!0}}
A.kq.prototype={
$0(){return this.a.ke(this.b)},
$S:31}
A.ko.prototype={
$0(){return this.a.ii(this.b)},
$S:1}
A.kp.prototype={
$0(){return this.a.kd(this.b,this.c)},
$S:1}
A.fw.prototype={
a6(){return"IccProfileCompression."+this.b}}
A.bb.prototype={}
A.fs.prototype={
a6(){return"FrameType."+this.b}}
A.aw.prototype={
gar(){var s=this.x
return s===$?this.x=A.m([],t.g):s},
hr(a,b,c,d){var s,r,q,p=this,o=a.gH(),n=a.gbs(),m=a.a
p.eF(d,b,o,n,m==null?null:m.gP())
o=a.b
if(o!=null)p.b=A.h1(o,t.N,t.v)
o=a.d
if(o!=null){n=t.N
p.d=A.h1(o,n,n)}p.gar().push(p)
if(!c){s=a.gar().length
for(o=t.g,r=1;r<s;++r){q=a.x
p.aY(A.fC((q===$?a.x=A.m([],o):q)[r],b,!1,d))}}},
hq(a,b,c){var s,r,q,p,o=this,n=a.b
if(n!=null)o.b=A.h1(n,t.N,t.v)
n=a.d
if(n!=null){s=t.N
o.d=A.h1(n,s,s)}o.gar().push(o)
if(!b&&a.gar().length>1){r=a.gar().length
for(n=t.g,q=1;q<r;++q){p=a.x
o.aY(A.aK((p===$?a.x=A.m([],n):p)[q],!1,!1))}}},
aY(a){var s=this
if(a==null)a=A.aK(s,!0,!0)
a.z=s.gar().length
if(s.gar().length===0||B.k.gcX(s.gar())!==a)s.gar().push(a)
return a},
cR(){return this.aY(null)},
eF(a,b,c,d,e){var s,r,q=this,p=null
switch(c.a){case 0:if(e==null){s=B.b.aZ(a*d/8)
r=new A.cU($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.aZ(a/8)
r=new A.cU($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 1:if(e==null){s=B.b.aZ(a*(d<<1>>>0)/8)
r=new A.cV($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.aZ(a/4)
r=new A.cV($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 2:if(e==null){if(d===2)s=a
else if(d===4)s=a*2
else s=d===3?B.b.aZ(a*1.5):B.b.aZ(a/2)
r=new A.cX($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.aZ(a/2)
r=new A.cX($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 3:if(e==null)q.a=A.ng(a,b,d)
else q.a=new A.cY(new Uint8Array(a*b),e,a,b,1)
break
case 4:s=a*b
if(e==null)q.a=new A.c2(new Uint16Array(s*d),p,a,b,d)
else q.a=new A.c2(new Uint16Array(s),e,a,b,1)
break
case 5:q.a=A.pE(a,b,d)
break
case 6:q.a=new A.e_(new Int8Array(a*b*d),a,b,d)
break
case 7:q.a=new A.dY(new Int16Array(a*b*d),a,b,d)
break
case 8:q.a=new A.dZ(new Int32Array(a*b*d),a,b,d)
break
case 9:q.a=A.pC(a,b,d)
break
case 10:q.a=A.pD(a,b,d)
break
case 11:q.a=new A.dX(new Float64Array(a*b*4*d),a,b,d)
break}},
B(a){var s=this
return"Image("+s.gX()+", "+s.gR()+", "+s.gH().b+", "+s.gbs()+")"},
gX(){var s=this.a
s=s==null?null:s.a
return s==null?0:s},
gR(){var s=this.a
s=s==null?null:s.b
return s==null?0:s},
gH(){var s=this.a
s=s==null?null:s.gH()
return s==null?B.e:s},
gbj(){var s=this.e
return s==null?this.e=new A.bR(A.O(t.N,t.P)):s},
h8(a,b){var s=this,r=s.b;(r==null?s.b=A.O(t.N,t.v):r).l(0,a,b)
if(s.b.a===0)s.b=null},
gF(a){var s=this.a
return s.gF(s)},
gA(a){var s=this.a
s=s==null?null:s.gA(s)
if(s==null)s=B.c.gA(new Uint8Array(0))
return s},
T(){var s=this.a
s=s==null?null:J.C(s.gA(s))
return s==null?J.C(this.gA(0)):s},
gbs(){var s=this.a
s=s==null?null:s.gP()
s=s==null?null:s.b
if(s==null){s=this.a
s=s==null?null:s.c}return s==null?0:s},
gbr(){var s=this.a
return(s==null?null:s.gP())!=null},
fH(a,b){return a>=0&&b>=0&&a<this.gX()&&b<this.gR()},
aF(a,b,c,d){var s=this.a
s=s==null?null:s.aF(a,b,c,d)
if(s==null)s=new A.aW(new Uint8Array(0))
return s},
K(a,b,c){var s=this.a
s=s==null?null:s.K(a,b,c)
return s==null?new A.D():s},
aH(a,b){return this.K(a,b,null)},
ad(a,b){if(a<0||a>=this.gX()||b<0||b>=this.gR())return new A.D()
return this.K(a,b,null)},
ea(a,b,c){switch(c.a){case 0:return this.ad(B.b.h(a),B.b.h(b))
case 1:case 3:return this.h5(a,b)
case 2:return this.h4(a,b)}},
h5(a,b){var s,r,q,p,o,n,m=this,l=B.b.h(a),k=l-(a>=0?0:1),j=k+1
l=B.b.h(b)
s=l-(b>=0?0:1)
r=s+1
l=new A.iP(a-k,b-s)
q=m.ad(k,s)
p=r>=m.gR()?q:m.ad(k,r)
o=j>=m.gX()?q:m.ad(j,s)
n=j>=m.gX()||r>=m.gR()?q:m.ad(j,r)
return m.aF(l.$4(q.gq(),o.gq(),p.gq(),n.gq()),l.$4(q.gt(),o.gt(),p.gt(),n.gt()),l.$4(q.gu(),o.gu(),p.gu(),n.gu()),l.$4(q.gv(),o.gv(),p.gv(),n.gv()))},
h4(c8,c9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2=this,c3=B.b.h(c8),c4=c3-(c8>=0?0:1),c5=c4-1,c6=c4+1,c7=c4+2
c3=B.b.h(c9)
s=c3-(c9>=0?0:1)
r=s-1
q=s+1
p=s+2
o=c8-c4
n=c9-s
c3=new A.iO()
m=c2.ad(c4,s)
l=c5<0
k=!l
j=!k||r<0?m:c2.ad(c5,r)
i=r<0
h=i?m:c2.ad(c4,r)
g=i||c6>=c2.gX()?m:c2.ad(c6,r)
f=c7>=c2.gX()||i?m:c2.ad(c7,r)
e=c3.$5(o,j.gq(),h.gq(),g.gq(),f.gq())
d=c3.$5(o,j.gt(),h.gt(),g.gt(),f.gt())
c=c3.$5(o,j.gu(),h.gu(),g.gu(),f.gu())
b=c3.$5(o,j.gv(),h.gv(),g.gv(),f.gv())
a=l?m:c2.ad(c5,s)
a0=c6>=c2.gX()?m:c2.ad(c6,s)
a1=c7>=c2.gX()?m:c2.ad(c7,s)
a2=c3.$5(o,a.gq(),m.gq(),a0.gq(),a1.gq())
a3=c3.$5(o,a.gt(),m.gt(),a0.gt(),a1.gt())
a4=c3.$5(o,a.gu(),m.gu(),a0.gu(),a1.gu())
a5=c3.$5(o,a.gv(),m.gv(),a0.gv(),a1.gv())
a6=!k||q>=c2.gR()?m:c2.ad(c5,q)
a7=q>=c2.gR()?m:c2.ad(c4,q)
a8=c6>=c2.gX()||q>=c2.gR()?m:c2.ad(c6,q)
a9=c7>=c2.gX()||q>=c2.gR()?m:c2.ad(c7,q)
b0=c3.$5(o,a6.gq(),a7.gq(),a8.gq(),a9.gq())
b1=c3.$5(o,a6.gt(),a7.gt(),a8.gt(),a9.gt())
b2=c3.$5(o,a6.gu(),a7.gu(),a8.gu(),a9.gu())
b3=c3.$5(o,a6.gv(),a7.gv(),a8.gv(),a9.gv())
b4=!k||p>=c2.gR()?m:c2.ad(c5,p)
b5=p>=c2.gR()?m:c2.ad(c4,p)
b6=c6>=c2.gX()||p>=c2.gR()?m:c2.ad(c6,p)
b7=c7>=c2.gX()||p>=c2.gR()?m:c2.ad(c7,p)
b8=c3.$5(o,b4.gq(),b5.gq(),b6.gq(),b7.gq())
b9=c3.$5(o,b4.gt(),b5.gt(),b6.gt(),b7.gt())
c0=c3.$5(o,b4.gu(),b5.gu(),b6.gu(),b7.gu())
c1=c3.$5(o,b4.gv(),b5.gv(),b6.gv(),b7.gv())
return c2.aF(c3.$5(n,e,a2,b0,b8),c3.$5(n,d,a3,b1,b9),c3.$5(n,c,a4,b2,c0),c3.$5(n,b,a5,b3,c1))},
bD(a,b,c){var s
if(t.dv.b(c))if(c.gb_().gP()!=null)if(this.gbr()){s=this.a
if(s!=null)s.az(a,b,c.gL(),0,0)
return}s=this.a
if(s!=null)s.ai(a,b,c.gq(),c.gt(),c.gu(),c.gv())},
gC(){var s=this.a
s=s==null?null:s.gC()
return s==null?0:s},
aL(a,b){var s=this.a
return s==null?null:s.aL(0,b)},
cU(a){return this.aL(0,null)},
dV(a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=null,a7=a5.gH(),a8=B.bj.n(0,a7)
a8=a8
s=!1
if(a7===a5.gH())if(a9===a5.gbs()){r=a5.a
s=(r==null?a6:r.gP())==null}if(s){q=A.aK(a5,!1,!1)
return q}for(s=a5.gar(),r=s.length,p=t.N,o=t.p,n=a6,m=0;m<s.length;s.length===r||(0,A.a5)(s),++m,n=d){l=s[m]
k=l.a
j=k==null
i=j?a6:k.a
if(i==null)i=0
k=j?a6:k.b
if(k==null)k=0
j=l.e
j=j==null?a6:A.dK(j)
h=l.c
if(h==null)h=a6
else{g=h.a
f=h.b
h=h.c
h=new A.bb(g,f,new Uint8Array(h.subarray(0,A.i2(0,a6,h.length))))}g=l.f
g=g==null?a6:new A.aW(new Uint8Array(A.t(g.a)))
f=l.w
e=l.r
q=A.Q(g,j,a7,l.y,f,k,h,e,a9,a6,B.e,i,!1)
k=l.d
q.d=k!=null?A.h1(k,p,p):a6
if(n!=null){n.aY(q)
d=n}else d=q
k=q.a
c=k==null?a6:k.gP()
k=q.a
k=k==null?a6:k.gP()
b=k==null?a6:k.gH()
if(b==null)b=a7
k=l.a
if(c!=null){a=A.O(o,o)
a0=k==null?a6:k.K(0,0,a6)
if(a0==null)a0=new A.D()
for(k=q.a,k=k.gF(k),a1=0;k.E();){a2=k.gJ()
a3=A.oE(B.b.bA(a0.ga8()*255),B.b.bA(a0.ga3()*255),B.b.bA(a0.ga7()*255),0)
if(a.am(a3)){j=a.n(0,a3)
j.toString
a2.sL(j)}else{a.l(0,a3,a1)
a2.sL(a1)
a4=A.ms(a0,a8,b,a9,a6)
c.b1(a1,a4.gq(),a4.gt(),a4.gu());++a1}a0.E()}}else{a0=k==null?a6:k.K(0,0,a6)
if(a0==null)a0=new A.D()
for(k=q.a,k=k.gF(k);k.E();){A.ms(a0,a8,a6,a6,k.gJ())
a0.E()}}}n.toString
return n},
ki(a){var s,r,q,p
if(this.d==null){s=t.N
this.d=A.O(s,s)}for(s=new A.ab(a,a.r,a.e,A.j(a).m("ab<1>"));s.E();){r=s.d
q=this.d
q.toString
p=a.n(0,r)
p.toString
q.l(0,r,p)}},
hZ(a,b,c){var s,r=65536
switch(b.a){case 0:return null
case 1:return null
case 2:return null
case 3:s=a===B.m?r:256
return new A.b6(new Uint8Array(s*c),s,c)
case 4:s=a===B.m?r:256
return new A.hb(new Uint16Array(s*c),s,c)
case 5:s=a===B.m?r:256
return new A.hc(new Uint32Array(s*c),s,c)
case 6:s=a===B.m?r:256
return new A.ha(new Int8Array(s*c),s,c)
case 7:s=a===B.m?r:256
return new A.h8(new Int16Array(s*c),s,c)
case 8:s=a===B.m?r:256
return new A.h9(new Int32Array(s*c),s,c)
case 9:s=a===B.m?r:256
return new A.h5(new Uint16Array(s*c),s,c)
case 10:s=a===B.m?r:256
return new A.h6(new Float32Array(s*c),s,c)
case 11:s=a===B.m?r:256
return new A.h7(new Float64Array(s*c),s,c)}}}
A.iP.prototype={
$4(a,b,c,d){var s=this.b
return a+this.a*(b-a+s*(a+d-c-b))+s*(c-a)},
$S:32}
A.iO.prototype={
$5(a,b,c,d,e){var s=-b,r=a*a
return c+0.5*(a*(s+d)+r*(2*b-5*c+4*d-e)+r*a*(s+3*c-3*d+e))},
$S:33}
A.a9.prototype={
gP(){return null}}
A.cS.prototype={
b4(a){var s=this,r=s.d
if(a)r=new Uint16Array(r.length)
else r=new Uint16Array(A.t(r))
return new A.cS(r,s.a,s.b,s.c)},
gH(){return B.z},
gA(a){return B.A.gA(this.d)},
gb3(){return 16},
gaw(){return this.a*this.c*2},
gF(a){return A.lP(this)},
b0(a,b,c,d,e){return A.aZ(A.lP(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gC(){return 1},
aF(a,b,c,d){var s=new Uint16Array(4),r=new A.cy(s)
s[0]=A.G(a)
s[1]=A.G(b)
s[2]=A.G(c)
s[3]=A.G(d)
s=r
return s},
K(a,b,c){if(c==null||!(c instanceof A.c8)||c.d!==this)c=A.lP(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s=this.c,r=this.d,q=A.G(c)
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=q},
az(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=A.G(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=A.G(d)
q[r+2]=A.G(e)}},
ai(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=A.G(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=A.G(f)
else if(s>2){q[r+1]=A.G(d)
q[r+2]=A.G(e)
if(s>3)q[r+3]=A.G(f)}},
B(a){return"ImageDataFloat16("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){}}
A.cT.prototype={
b4(a){var s=this,r=s.d
if(a)r=new Float32Array(r.length)
else r=new Float32Array(A.t(r))
return new A.cT(r,s.a,s.b,s.c)},
gH(){return B.C},
gA(a){return B.R.gA(this.d)},
gb3(){return 32},
gF(a){return A.lQ(this)},
b0(a,b,c,d,e){return A.aZ(A.lQ(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gC(){return 1},
gaw(){return this.a*this.c*4},
aF(a,b,c,d){var s=new Float32Array(4),r=new A.cz(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
K(a,b,c){if(c==null||!(c instanceof A.c9)||c.d!==this)c=A.lQ(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s=this.c,r=this.d
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=c},
az(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d
q.$flags&2&&A.a(q)
q[r]=c
if(s>2){q[r+1]=d
q[r+2]=e}},
ai(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d
q.$flags&2&&A.a(q)
q[r]=c
if(s===2)q[r+1]=f
else if(s>2){q[r+1]=d
q[r+2]=e
if(s>3)q[r+3]=f}},
B(a){return"ImageDataFloat32("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){}}
A.dX.prototype={
b4(a){var s=this,r=s.d
if(a)r=new Float64Array(r.length)
else r=new Float64Array(A.t(r))
return new A.dX(r,s.a,s.b,s.c)},
gH(){return B.I},
gA(a){return B.V.gA(this.d)},
gp(a){return this.d.byteLength},
gb3(){return 64},
gF(a){return A.lR(this)},
b0(a,b,c,d,e){return A.aZ(A.lR(this),b,c,d,e)},
gC(){return 1},
gaw(){return this.a*this.c*8},
aF(a,b,c,d){var s=new Float64Array(4),r=new A.cA(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
K(a,b,c){if(c==null||!(c instanceof A.ca)||c.d!==this)c=A.lR(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s=this.c,r=this.d
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=c},
az(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d
q.$flags&2&&A.a(q)
q[r]=c
if(s>2){q[r+1]=d
q[r+2]=e}},
ai(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d
q.$flags&2&&A.a(q)
q[r]=c
if(s===2)q[r+1]=f
else if(s>2){q[r+1]=d
q[r+2]=e
if(s>3)q[r+3]=f}},
B(a){return"ImageDataFloat64("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){}}
A.dY.prototype={
b4(a){var s=this,r=s.d
if(a)r=new Int16Array(r.length)
else r=new Int16Array(A.t(r))
return new A.dY(r,s.a,s.b,s.c)},
gH(){return B.L},
gA(a){return B.S.gA(this.d)},
gF(a){return A.lS(this)},
b0(a,b,c,d,e){return A.aZ(A.lS(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gC(){return 32767},
gb3(){return 16},
gaw(){return this.a*this.c*2},
aF(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Int16Array(4),n=new A.cB(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
K(a,b,c){if(c==null||!(c instanceof A.cb)||c.d!==this)c=A.lS(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=q},
az(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ai(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataInt16("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){}}
A.dZ.prototype={
b4(a){var s=this,r=s.d
if(a)r=new Int32Array(r.length)
else r=new Int32Array(A.t(r))
return new A.dZ(r,s.a,s.b,s.c)},
gH(){return B.M},
gA(a){return B.E.gA(this.d)},
gb3(){return 32},
gaw(){return this.a*this.c*4},
gF(a){return A.lT(this)},
b0(a,b,c,d,e){return A.aZ(A.lT(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gC(){return 2147483647},
aF(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Int32Array(4),n=new A.cC(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
K(a,b,c){if(c==null||!(c instanceof A.cc)||c.d!==this)c=A.lT(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=q},
az(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ai(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataInt32("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){}}
A.e_.prototype={
b4(a){var s=this,r=s.d
if(a)r=new Int8Array(r.length)
else r=new Int8Array(A.t(r))
return new A.e_(r,s.a,s.b,s.c)},
gH(){return B.K},
gA(a){return B.W.gA(this.d)},
gaw(){return this.a*this.c},
gF(a){return A.lU(this)},
b0(a,b,c,d,e){return A.aZ(A.lU(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gC(){return 127},
gb3(){return 8},
aF(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Int8Array(4),n=new A.cD(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
K(a,b,c){if(c==null||!(c instanceof A.cd)||c.d!==this)c=A.lU(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*(this.a*s)+a*s]=q},
az(a,b,c,d,e){var s=this.c,r=b*(this.a*s)+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ai(a,b,c,d,e,f){var s=this.c,r=b*(this.a*s)+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataInt8("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){}}
A.cU.prototype={
ld(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.y()
this.d=s},
b4(a){var s,r=this,q=r.d
if(a){q===$&&A.b()
q=new Uint8Array(q.length)}else{q===$&&A.b()
q=new Uint8Array(A.t(q))}s=r.f
s=s==null?null:s.N()
return new A.cU(q,r.e,s,r.a,r.b,r.c)},
gH(){return B.u},
gp(a){var s=this.d
s===$&&A.b()
return s.byteLength},
gC(){var s=this.f
s=s==null?null:s.gC()
return s==null?1:s},
gA(a){var s=this.d
s===$&&A.b()
return B.c.gA(s)},
gb3(){return 1},
gF(a){return A.en(this)},
b0(a,b,c,d,e){return A.aZ(A.en(this),b,c,d,e)},
aF(a,b,c,d){var s=new A.cE(4,0)
s.ae(B.b.h(a),B.b.h(b),B.b.h(c),B.b.h(d))
return s},
K(a,b,c){if(c==null||!(c instanceof A.ce)||c.f!==this)c=A.en(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.en(r):s).Z(a,b)
r.r.aj(0,c)},
az(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.en(r):s).Z(a,b)
r.r.ap(c,d,e)},
ai(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.en(r):s).Z(a,b)
r.r.ae(c,d,e,f)},
B(a){return"ImageDataUint1("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){},
gaw(){return this.e},
gP(){return this.f}}
A.c2.prototype={
b4(a){var s,r=this,q=r.d
if(a)q=new Uint16Array(q.length)
else q=new Uint16Array(A.t(q))
s=r.e
s=s==null?null:s.N()
return new A.c2(q,s,r.a,r.b,r.c)},
gH(){return B.m},
gA(a){return B.A.gA(this.d)},
gb3(){return 16},
gC(){var s=this.e
s=s==null?null:s.gC()
return s==null?65535:s},
gaw(){return this.a*this.c*2},
gF(a){return A.lV(this)},
b0(a,b,c,d,e){return A.aZ(A.lV(this),b,c,d,e)},
gp(a){return this.d.byteLength},
aF(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Uint16Array(4),n=new A.cF(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
K(a,b,c){if(c==null||!(c instanceof A.cf)||c.d!==this)c=A.lV(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=q},
az(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ai(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataUint16("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){},
gP(){return this.e}}
A.cV.prototype={
le(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.y()
this.d=s},
b4(a){var s,r=this,q=r.d
if(a){q===$&&A.b()
q=new Uint8Array(q.length)}else{q===$&&A.b()
q=new Uint8Array(A.t(q))}s=r.f
s=s==null?null:s.N()
return new A.cV(q,r.e,s,r.a,r.b,r.c)},
gH(){return B.x},
gb3(){return 2},
gA(a){var s=this.d
s===$&&A.b()
return B.c.gA(s)},
gF(a){return A.eo(this)},
b0(a,b,c,d,e){return A.aZ(A.eo(this),b,c,d,e)},
gp(a){var s=this.d
s===$&&A.b()
return s.byteLength},
gC(){var s=this.f
s=s==null?null:s.gC()
return s==null?3:s},
aF(a,b,c,d){var s=new A.cG(4,0)
s.ae(B.b.h(a),B.b.h(b),B.b.h(c),B.b.h(d))
return s},
K(a,b,c){if(c==null||!(c instanceof A.cg)||c.f!==this)c=A.eo(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eo(r):s).Z(a,b)
r.r.ak(0,c)},
az(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eo(r):s).Z(a,b)
r.r.ap(c,d,e)},
ai(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eo(r):s).Z(a,b)
r.r.ae(c,d,e,f)},
B(a){return"ImageDataUint2("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){},
gaw(){return this.e},
gP(){return this.f}}
A.cW.prototype={
b4(a){var s=this,r=s.d
if(a)r=new Uint32Array(r.length)
else r=new Uint32Array(A.t(r))
return new A.cW(r,s.a,s.b,s.c)},
gH(){return B.J},
gA(a){return B.l.gA(this.d)},
gaw(){return this.a*this.c*4},
gb3(){return 32},
gC(){return 4294967295},
gF(a){return A.lW(this)},
b0(a,b,c,d,e){return A.aZ(A.lW(this),b,c,d,e)},
gp(a){return this.d.byteLength},
aF(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Uint32Array(4),n=new A.cH(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
K(a,b,c){if(c==null||!(c instanceof A.ch)||c.d!==this)c=A.lW(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=q},
az(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ai(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataUint32("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){}}
A.cX.prototype={
lf(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.y()
this.d=s},
b4(a){var s,r=this,q=r.d
if(a){q===$&&A.b()
q=new Uint8Array(q.length)}else{q===$&&A.b()
q=new Uint8Array(A.t(q))}s=r.f
s=s==null?null:s.N()
return new A.cX(q,r.e,s,r.a,r.b,r.c)},
gH(){return B.y},
gA(a){var s=this.d
s===$&&A.b()
return B.c.gA(s)},
gF(a){return A.ep(this)},
b0(a,b,c,d,e){return A.aZ(A.ep(this),b,c,d,e)},
gp(a){var s=this.d
s===$&&A.b()
return s.byteLength},
gC(){var s=this.f
s=s==null?null:s.gC()
return s==null?15:s},
gb3(){return 4},
aF(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new A.cI(4,new Uint8Array(2))
o.ae(s,r,q,p)
s=o
return s},
K(a,b,c){if(c==null||!(c instanceof A.ci)||c.e!==this)c=A.ep(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ep(r):s).Z(a,b)
r.r.al(0,c)},
az(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ep(r):s).Z(a,b)
r.r.ap(c,d,e)},
ai(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ep(r):s).Z(a,b)
r.r.ae(c,d,e,f)},
B(a){return"ImageDataUint4("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){},
gaw(){return this.e},
gP(){return this.f}}
A.cY.prototype={
b4(a){var s,r=this,q=r.d
if(a)q=new Uint8Array(q.length)
else q=new Uint8Array(A.t(q))
s=r.e
s=s==null?null:s.N()
return new A.cY(q,s,r.a,r.b,r.c)},
gH(){return B.e},
gA(a){return B.c.gA(this.d)},
gaw(){return this.a*this.c},
gb3(){return 8},
gF(a){return A.jp(this)},
b0(a,b,c,d,e){return A.aZ(A.jp(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gC(){var s=this.e
s=s==null?null:s.gC()
return s==null?255:s},
aF(a,b,c,d){var s=A.mZ(B.b.h(B.b.I(a,0,255)),B.b.h(B.b.I(b,0,255)),B.b.h(B.b.I(c,0,255)),B.b.h(B.b.I(d,0,255)))
return s},
K(a,b,c){if(c==null||!(c instanceof A.cj)||c.d!==this)c=A.jp(this)
c.Z(a,b)
return c},
aH(a,b){return this.K(a,b,null)},
aB(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*(this.a*s)+a*s]=q},
az(a,b,c,d,e){var s=this.c,r=b*(this.a*s)+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ai(a,b,c,d,e,f){var s=this.c,r=b*(this.a*s)+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataUint8("+this.a+", "+this.b+", "+this.c+")"},
aL(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f=b==null?g:A.ms(b,g,B.e,g,g),e=h.c
if(e===1){s=f==null?0:B.a.I(A.z(f.gq()),0,255)
e=h.d
B.c.an(e,0,e.length,s)}else if(e===2){e=f==null
s=e?0:B.a.I(A.z(f.gq()),0,255)
r=e?0:B.a.I(A.z(f.gv()),0,255)
q=J.p8(B.c.gA(h.d),0,null)
B.A.an(q,0,q.length,(r<<8|s)>>>0)}else if(e===4){e=f==null
s=e?0:B.a.I(A.z(f.gq()),0,255)
p=e?0:B.a.I(A.z(f.gt()),0,255)
o=e?0:B.a.I(A.z(f.gu()),0,255)
r=e?0:B.a.I(A.z(f.gv()),0,255)
n=J.au(B.c.gA(h.d),0,null)
B.l.an(n,0,n.length,(r<<24|o<<16|p<<8|s)>>>0)}else{e=f==null
s=e?0:B.a.I(A.z(f.gq()),0,255)
p=e?0:B.a.I(A.z(f.gt()),0,255)
o=e?0:B.a.I(A.z(f.gu()),0,255)
for(m=A.jp(h),e=m.d,l=e.c>0,e=e.d,k=e.$flags|0;m.E();){if(l){j=m.c
i=B.b.h(B.a.I(s,0,255))
k&2&&A.a(e)
e[j]=i}m.st(p)
m.su(o)}}},
gP(){return this.e}}
A.e2.prototype={
a6(){return"Interpolation."+this.b}}
A.jn.prototype={}
A.h5.prototype={
N(){return new A.h5(new Uint16Array(A.t(this.c)),this.a,this.b)},
gH(){return B.z},
gC(){return 1},
S(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=A.G(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b1(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=A.G(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=A.G(c)
if(q>2)s[a+2]=A.G(d)}},
aW(a,b){var s,r=this.b
if(b<r){r=this.c[a*r+b]
s=$.F
r=(s!=null?s:A.K())[r]}else r=0
return r},
aI(a){var s=this.c[a*this.b],r=$.F
return(r!=null?r:A.K())[s]},
aG(a){var s,r=this.b
if(r<2)return 0
r=this.c[a*r+1]
s=$.F
return(s!=null?s:A.K())[r]},
aE(a){var s,r=this.b
if(r<3)return 0
r=this.c[a*r+2]
s=$.F
return(s!=null?s:A.K())[r]},
aN(a){var s,r=this.b
if(r<4)return 0
r=this.c[a*r+3]
s=$.F
return(s!=null?s:A.K())[r]},
bd(a,b){return this.S(a,0,b)},
bc(a,b){return this.S(a,1,b)},
bb(a,b){return this.S(a,2,b)},
bh(a,b){return this.S(a,3,b)}}
A.h6.prototype={
N(){return new A.h6(new Float32Array(A.t(this.c)),this.a,this.b)},
gH(){return B.C},
gC(){return 1},
S(a,b,c){var s,r=this.b
if(b<r){s=this.c
s.$flags&2&&A.a(s)
s[a*r+b]=c}},
b1(a,b,c,d){var s,r=this.b
a*=r
s=this.c
s.$flags&2&&A.a(s)
s[a]=b
if(r>1){s[a+1]=c
if(r>2)s[a+2]=d}},
aW(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aI(a){return this.c[a*this.b]},
aG(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aE(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aN(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bd(a,b){return this.S(a,0,b)},
bc(a,b){return this.S(a,1,b)},
bb(a,b){return this.S(a,2,b)},
bh(a,b){return this.S(a,3,b)}}
A.h7.prototype={
N(){return new A.h7(new Float64Array(A.t(this.c)),this.a,this.b)},
gH(){return B.I},
gC(){return 1},
S(a,b,c){var s,r=this.b
if(b<r){s=this.c
s.$flags&2&&A.a(s)
s[a*r+b]=c}},
b1(a,b,c,d){var s,r=this.b
a*=r
s=this.c
s.$flags&2&&A.a(s)
s[a]=b
if(r>1){s[a+1]=c
if(r>2)s[a+2]=d}},
aW(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aI(a){return this.c[a*this.b]},
aG(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aE(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aN(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bd(a,b){return this.S(a,0,b)},
bc(a,b){return this.S(a,1,b)},
bb(a,b){return this.S(a,2,b)},
bh(a,b){return this.S(a,3,b)}}
A.h8.prototype={
N(){return new A.h8(new Int16Array(A.t(this.c)),this.a,this.b)},
gH(){return B.L},
gC(){return 32767},
S(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.b.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b1(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
aW(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aI(a){return this.c[a*this.b]},
aG(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aE(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aN(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bd(a,b){return this.S(a,0,b)},
bc(a,b){return this.S(a,1,b)},
bb(a,b){return this.S(a,2,b)},
bh(a,b){return this.S(a,3,b)}}
A.h9.prototype={
N(){return new A.h9(new Int32Array(A.t(this.c)),this.a,this.b)},
gH(){return B.M},
gC(){return 2147483647},
S(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.b.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b1(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
aW(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aI(a){return this.c[a*this.b]},
aG(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aE(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aN(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bd(a,b){return this.S(a,0,b)},
bc(a,b){return this.S(a,1,b)},
bb(a,b){return this.S(a,2,b)},
bh(a,b){return this.S(a,3,b)}}
A.ha.prototype={
N(){return new A.ha(new Int8Array(A.t(this.c)),this.a,this.b)},
gH(){return B.K},
gC(){return 127},
S(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.b.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b1(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
aW(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aI(a){return this.c[a*this.b]},
aG(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aE(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aN(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bd(a,b){return this.S(a,0,b)},
bc(a,b){return this.S(a,1,b)},
bb(a,b){return this.S(a,2,b)},
bh(a,b){return this.S(a,3,b)}}
A.hb.prototype={
N(){return new A.hb(new Uint16Array(A.t(this.c)),this.a,this.b)},
gH(){return B.m},
gC(){return 65535},
S(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.b.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b1(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
aW(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aI(a){return this.c[a*this.b]},
aG(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aE(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aN(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bd(a,b){return this.S(a,0,b)},
bc(a,b){return this.S(a,1,b)},
bb(a,b){return this.S(a,2,b)},
bh(a,b){return this.S(a,3,b)}}
A.hc.prototype={
N(){return new A.hc(new Uint32Array(A.t(this.c)),this.a,this.b)},
gH(){return B.J},
gC(){return 4294967295},
S(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.b.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b1(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
aW(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aI(a){return this.c[a*this.b]},
aG(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aE(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aN(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bd(a,b){return this.S(a,0,b)},
bc(a,b){return this.S(a,1,b)},
bb(a,b){return this.S(a,2,b)},
bh(a,b){return this.S(a,3,b)}}
A.b6.prototype={
N(){return A.nv(this)},
gH(){return B.e},
gC(){return 255},
S(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.b.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b1(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
cu(a,b,c,d,e){var s,r,q=this.b
a*=q
s=this.c
r=B.a.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.a.h(c)
if(q>2){s[a+2]=B.a.h(d)
if(q>3)s[a+3]=B.a.h(e)}}},
aW(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aI(a){var s
a*=this.b
s=this.c
if(a>=s.length)return 0
return s[a]},
aG(a){var s=this.b
if(s<2)return 0
a*=s
s=this.c
if(a>=s.length)return 0
return s[a+1]},
aE(a){var s=this.b
if(s<3)return 0
a*=s
s=this.c
if(a>=s.length)return 0
return s[a+2]},
aN(a){var s=this.b
if(s<4)return 255
a*=s
s=this.c
if(a>=s.length)return 0
return s[a+3]},
bd(a,b){return this.S(a,0,b)},
bc(a,b){return this.S(a,1,b)},
bb(a,b){return this.S(a,2,b)},
bh(a,b){return this.S(a,3,b)}}
A.c8.prototype={
N(){var s=this
return new A.c8(s.a,s.b,s.c,s.d)},
gH(){return B.z},
gp(a){return this.d.c},
gP(){return null},
gC(){return 1},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gJ(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
n(a,b){var s,r=this.d
if(b<r.c){r=r.d[this.c+b]
s=$.F
r=(s!=null?s:A.K())[r]}else r=0
return r},
l(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=A.G(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gL(){return this.gq()},
sL(a){this.sq(a)},
gq(){var s,r=this.d
if(r.c>0){r=r.d[this.c]
s=$.F
r=(s!=null?s:A.K())[r]}else r=0
return r},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=A.G(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gt(){var s=this.d,r=s.c
if(r===2){s=s.d[this.c]
r=$.F
s=(r!=null?r:A.K())[s]}else if(r>1){s=s.d[this.c+1]
r=$.F
s=(r!=null?r:A.K())[s]}else s=0
return s},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=A.G(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=A.G(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gu(){var s=this.d,r=s.c
if(r===2){s=s.d[this.c]
r=$.F
s=(r!=null?r:A.K())[s]}else if(r>2){s=s.d[this.c+2]
r=$.F
s=(r!=null?r:A.K())[s]}else s=0
return s},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=A.G(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=A.G(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gv(){var s=this.d,r=s.c
if(r===2){s=s.d[this.c+1]
r=$.F
s=(r!=null?r:A.K())[s]}else if(r>3){s=s.d[this.c+3]
r=$.F
s=(r!=null?r:A.K())[s]}else s=1
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=A.G(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=A.G(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
ga8(){return this.gq()/1},
sa8(a){this.sq(a)},
ga3(){return this.gt()/1},
sa3(a){this.st(a)},
ga7(){return this.gu()/1},
sa7(a){this.su(a)},
gaa(){return this.gv()/1},
saa(a){this.sv(a)},
gah(){return this.d.c===2?this.gq():A.W(this)},
aJ(a){var s=this
if(s.d.c>0){s.sq(a.gq())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())}},
ap(a,b,c){var s,r,q=this,p=q.d,o=p.c
if(o>0){p=p.d
s=q.c
r=A.G(a)
p.$flags&2&&A.a(p)
p[s]=r
if(o>2){p[q.c+1]=A.G(b)
p[q.c+2]=A.G(c)}}},
ae(a,b,c,d){var s,r,q=this,p=q.d,o=p.c
if(o>0){p=p.d
s=q.c
r=A.G(a)
p.$flags&2&&A.a(p)
p[s]=r
if(o===2)p[q.c+1]=A.G(d)
else if(o>2){p[q.c+1]=A.G(b)
p[q.c+2]=A.G(c)
if(o>3)p[q.c+3]=A.G(d)}}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.c8){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=J.a3(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.n(b,0))return!1
if(q>1){if(r[p.c+1]!==s.n(b,1))return!1
if(q>2){if(r[p.c+2]!==s.n(b,2))return!1
if(q>3)if(r[p.c+3]!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.d}}
A.c9.prototype={
N(){var s=this
return new A.c9(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gP(){return null},
gC(){return 1},
gH(){return B.C},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gJ(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
n(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
l(a,b,c){var s,r=this.d
if(b<r.c){r=r.d
s=this.c
r.$flags&2&&A.a(r)
r[s+b]=c}},
gL(){return this.gq()},
sL(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
r.$flags&2&&A.a(r)
r[s]=a}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
st(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r]=a}else if(r>1){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+1]=a}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
su(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r]=a}else if(r>2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+2]=a}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:1
return s},
sv(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+1]=a}else if(r>3){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+3]=a}},
ga8(){return this.gq()/1},
sa8(a){this.sq(a)},
ga3(){return this.gt()/1},
sa3(a){this.st(a)},
ga7(){return this.gu()/1},
sa7(a){this.su(a)},
gaa(){return this.gv()/1},
saa(a){this.sv(a)},
gah(){return this.d.c===2?this.gq():A.W(this)},
aJ(a){var s=this
s.sq(a.gq())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
ap(a,b,c){var s=this.d,r=s.d,q=this.c
r.$flags&2&&A.a(r)
r[q]=a
if(s.c>2){r[q+1]=b
r[q+2]=c}},
ae(a,b,c,d){var s=this.d,r=s.d,q=this.c
r.$flags&2&&A.a(r)
r[q]=a
s=s.c
if(s===2)r[q+1]=d
else if(s>2){r[q+1]=b
r[q+2]=c
if(s>3)r[q+3]=d}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.c9){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=J.a3(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.n(b,0))return!1
if(q>1){if(r[p.c+1]!==s.n(b,1))return!1
if(q>2){if(r[p.c+2]!==s.n(b,2))return!1
if(q>3)if(r[p.c+3]!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.d}}
A.ca.prototype={
N(){var s=this
return new A.ca(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gP(){return null},
gC(){return 1},
gH(){return B.I},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gJ(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
n(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
l(a,b,c){var s,r=this.d
if(b<r.c){r=r.d
s=this.c
r.$flags&2&&A.a(r)
r[s+b]=c}},
gL(){return this.gq()},
sL(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
r.$flags&2&&A.a(r)
r[s]=a}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
st(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r]=a}else if(r>1){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+1]=a}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
su(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r]=a}else if(r>2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+2]=a}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:1
return s},
sv(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+1]=a}else if(r>3){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+3]=a}},
ga8(){return this.gq()/1},
sa8(a){this.sq(a)},
ga3(){return this.gt()/1},
sa3(a){this.st(a)},
ga7(){return this.gu()/1},
sa7(a){this.su(a)},
gaa(){return this.gv()/1},
saa(a){this.sv(a)},
gah(){return this.d.c===2?this.gq():A.W(this)},
aJ(a){var s=this
s.sq(a.gq())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
ap(a,b,c){var s=this.d,r=s.d,q=this.c
r.$flags&2&&A.a(r)
r[q]=a
if(s.c>2){r[q+1]=b
r[q+2]=c}},
ae(a,b,c,d){var s=this.d,r=s.d,q=this.c
r.$flags&2&&A.a(r)
r[q]=a
s=s.c
if(s===2)r[q+1]=d
else if(s>2){r[q+1]=b
r[q+2]=c
if(s>3)r[q+3]=d}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ca){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=J.a3(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.n(b,0))return!1
if(q>1){if(r[p.c+1]!==s.n(b,1))return!1
if(q>2){if(r[p.c+2]!==s.n(b,2))return!1
if(q>3)if(r[p.c+3]!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.d}}
A.cb.prototype={
N(){var s=this
return new A.cb(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gP(){return null},
gC(){return 32767},
gH(){return B.L},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gJ(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
n(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
l(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gL(){return this.gq()},
sL(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:32767
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
ga8(){return this.gq()/32767},
sa8(a){this.sq(a*32767)},
ga3(){return this.gt()/32767},
sa3(a){this.st(a*32767)},
ga7(){return this.gu()/32767},
sa7(a){this.su(a*32767)},
gaa(){return this.gv()/32767},
saa(a){this.sv(a*32767)},
gah(){return this.d.c===2?this.gq():A.W(this)},
aJ(a){var s=this
s.sq(a.gq())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
ap(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ae(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cb){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=J.a3(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.n(b,0))return!1
if(q>1){if(r[p.c+1]!==s.n(b,1))return!1
if(q>2){if(r[p.c+2]!==s.n(b,2))return!1
if(q>3)if(r[p.c+3]!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.d}}
A.cc.prototype={
N(){var s=this
return new A.cc(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gP(){return null},
gC(){return 2147483647},
gH(){return B.M},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gJ(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
n(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
l(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gL(){return this.gq()},
sL(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:2147483647
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
ga8(){return this.gq()/2147483647},
sa8(a){this.sq(a*2147483647)},
ga3(){return this.gt()/2147483647},
sa3(a){this.st(a*2147483647)},
ga7(){return this.gu()/2147483647},
sa7(a){this.su(a*2147483647)},
gaa(){return this.gv()/2147483647},
saa(a){this.sv(a*2147483647)},
gah(){return this.d.c===2?this.gq():A.W(this)},
aJ(a){var s=this
s.sq(a.gq())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
ap(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ae(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cc){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=J.a3(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.n(b,0))return!1
if(q>1){if(r[p.c+1]!==s.n(b,1))return!1
if(q>2){if(r[p.c+2]!==s.n(b,2))return!1
if(q>3)if(r[p.c+3]!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.d}}
A.cd.prototype={
N(){var s=this
return new A.cd(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gP(){return null},
gC(){return 127},
gH(){return B.K},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gJ(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
n(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
l(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gL(){return this.gq()},
sL(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:127
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
ga8(){return this.gq()/127},
sa8(a){this.sq(a*127)},
ga3(){return this.gt()/127},
sa3(a){this.st(a*127)},
ga7(){return this.gu()/127},
sa7(a){this.su(a*127)},
gaa(){return this.gv()/127},
saa(a){this.sv(a*127)},
gah(){return this.d.c===2?this.gq():A.W(this)},
aJ(a){var s=this
s.sq(a.gq())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
ap(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ae(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cd){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=J.a3(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.n(b,0))return!1
if(q>1){if(r[p.c+1]!==s.n(b,1))return!1
if(q>2){if(r[p.c+2]!==s.n(b,2))return!1
if(q>3)if(r[p.c+3]!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.d}}
A.jo.prototype={
E(){var s=this,r=s.a
if(r.gaV()+1>s.d){r.Z(s.b,r.gaM()+1)
return r.gaM()<=s.e}return r.E()},
gJ(){return this.a}}
A.ce.prototype={
N(){var s=this
return new A.ce(s.a,s.b,s.c,s.d,s.e,s.f)},
gp(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gP(){return this.f.f},
gC(){return this.f.gC()},
gH(){return B.u},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.f
r=b*s.e
q.e=r
s=a*s.c
q.c=r+B.a.j(s,3)
q.d=s&7},
gJ(){return this},
E(){var s,r=this,q=++r.a,p=r.f
if(q===p.a){r.a=0
q=++r.b
r.d=0;++r.c
r.e=r.e+p.e
return q<p.b}s=p.c
if(p.f!=null||s===1){if(++r.d>7){r.d=0;++r.c}}else{q*=s
r.d=q&7
r.c=r.e+B.a.j(q,3)}q=r.c
p=p.d
p===$&&A.b()
return q<p.byteLength},
dE(a){var s,r=this.c,q=7-(this.d+a)
if(q<0){q+=8;++r}s=this.f.d
s===$&&A.b()
if(r>=s.length)return 0
return B.a.U(s[r],q)&1},
aP(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.dE(a):0
else s=r.aW(this.dE(0),a)
return s},
aj(a,b){var s,r,q,p,o,n,m=this.f
if(a>=m.c)return
s=this.c
r=7-(this.d+a)
if(r<0){++s
r+=8}q=m.d
q===$&&A.b()
p=q[s]
o=B.a.I(B.b.h(b),0,1)
n=B.eX[r]
q=B.a.Y(o,r)
m=m.d
m.$flags&2&&A.a(m)
m[s]=(p&n|q)>>>0},
n(a,b){return this.aP(b)},
l(a,b,c){return this.aj(b,c)},
gL(){return this.dE(0)},
sL(a){this.aj(0,a)},
gq(){return this.aP(0)},
sq(a){this.aj(0,a)},
gt(){return this.f.c===2?this.aP(0):this.aP(1)},
st(a){this.aj(this.f.c===2?0:1,a)},
gu(){return this.f.c===2?this.aP(0):this.aP(2)},
su(a){this.aj(this.f.c===2?0:2,a)},
gv(){var s=this.f,r=s.f==null
if(r&&s.c===2)s=this.aP(1)
else s=r&&s.c<4?s.gC():this.aP(3)
return s},
sv(a){this.aj(this.f.c===2?1:3,a)},
ga8(){return this.aP(0)/this.f.gC()},
sa8(a){this.aj(0,a*this.f.gC())},
ga3(){return this.gt()/this.f.gC()},
sa3(a){var s=this.f,r=s.gC()
s=s.c===2?0:1
this.aj(s,a*r)},
ga7(){return this.gu()/this.f.gC()},
sa7(a){var s=this.f,r=s.gC()
s=s.c===2?0:2
this.aj(s,a*r)},
gaa(){return this.gv()/this.f.gC()},
saa(a){var s=this.f,r=s.gC()
s=s.c===2?1:3
this.aj(s,a*r)},
gah(){return this.f.c===2?this.aP(0):A.W(this)},
aJ(a){var s,r,q=this
q.aj(0,a.gq())
s=a.gt()
r=q.f.c===2
q.aj(r?0:1,s)
s=a.gu()
q.aj(r?0:2,s)
s=a.gv()
q.aj(r?1:3,s)},
ap(a,b,c){var s=this,r=s.f.c
if(r>0){s.aj(0,a)
if(r>2){s.aj(1,b)
s.aj(2,c)}}},
ae(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.aj(0,a)
if(r===2)s.aj(1,d)
else if(r>2){s.aj(1,b)
s.aj(2,c)
if(r>3)s.aj(3,d)}}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ce){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.a3(b)
if(s.gp(b)!==q)return!1
if(p.aP(0)!==s.n(b,0))return!1
if(q>1){if(p.aP(1)!==s.n(b,1))return!1
if(q>2){if(p.aP(2)!==s.n(b,2))return!1
if(q>3)if(p.aP(3)!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.f}}
A.cf.prototype={
N(){var s=this
return new A.cf(s.a,s.b,s.c,s.d)},
gp(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gP(){return this.d.e},
gC(){return this.d.gC()},
gH(){return B.m},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gJ(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
ba(a){var s=this.d,r=s.e
if(r!=null)s=r.aW(s.d[this.c],a)
else s=a<s.c?s.d[this.c+a]:0
return s},
n(a,b){return this.ba(b)},
l(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gL(){return this.gq()},
sL(a){this.sq(a)},
gq(){var s=this.d,r=s.e
if(r==null)s=s.c>0?s.d[this.c]:0
else s=r.aI(s.d[this.c])
return s},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gt(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c]
else r=q>1?r.d[s.c+1]:0}else r=q.aG(r.d[s.c])
return r},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gu(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c]
else r=q>2?r.d[s.c+2]:0}else r=q.aE(r.d[s.c])
return r},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gv(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c+1]
else r=q>3?r.d[s.c+3]:r.gC()}else r=q.aN(r.d[s.c])
return r},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
ga8(){return this.gq()/this.d.gC()},
sa8(a){this.sq(a*this.d.gC())},
ga3(){return this.gt()/this.d.gC()},
sa3(a){this.st(a*this.d.gC())},
ga7(){return this.gu()/this.d.gC()},
sa7(a){this.su(a*this.d.gC())},
gaa(){return this.gv()/this.d.gC()},
saa(a){this.sv(a*this.d.gC())},
gah(){return this.d.c===2?this.gq():A.W(this)},
aJ(a){var s=this
s.sq(a.gq())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
ap(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ae(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cf){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.a3(b)
if(s.gp(b)!==q)return!1
if(p.ba(0)!==s.n(b,0))return!1
if(q>1){if(p.ba(1)!==s.n(b,1))return!1
if(q>2){if(p.ba(2)!==s.n(b,2))return!1
if(q>3)if(p.ba(3)!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.d}}
A.cg.prototype={
N(){var s=this
return new A.cg(s.a,s.b,s.c,s.d,s.e,s.f)},
gp(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gP(){return this.f.f},
gC(){return this.f.gC()},
gH(){return B.x},
gfz(){var s=this.f
return s.f!=null?2:s.c<<1>>>0},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q,p=this
p.a=a
p.b=b
s=p.gfz()
r=b*p.f.e
p.e=r
q=a*s
p.c=r+B.a.j(q,3)
p.d=q&7},
gJ(){return this},
E(){var s=this,r=++s.a,q=s.f
if(r===q.a){s.a=0
r=++s.b
s.d=0;++s.c
s.e=s.e+q.e
return r<q.b}if(q.f!=null||q.c===1){if((s.d+=2)>7){s.d=0;++s.c}}else{r*=s.gfz()
s.d=r&7
s.c=s.e+B.a.j(r,3)}r=s.c
q=q.d
q===$&&A.b()
return r<q.length},
dF(a){var s,r=this.c,q=6-(this.d+(a<<1>>>0))
if(q<0){q+=8;++r}s=this.f.d
s===$&&A.b()
return B.a.U(s[r],q)&3},
aQ(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.dF(a):0
else s=r.aW(this.dF(0),a)
return s},
ak(a,b){var s,r,q,p,o,n,m=this.f
if(a>=m.c)return
s=this.c
r=6-(this.d+(a<<1>>>0))
if(r<0){++s
r+=8}q=m.d
q===$&&A.b()
p=q[s]
o=B.a.I(B.b.h(b),0,3)
n=B.cL[B.a.j(r,1)]
q=B.a.Y(o,r)
m=m.d
m.$flags&2&&A.a(m)
m[s]=(p&n|q)>>>0},
n(a,b){return this.aQ(b)},
l(a,b,c){return this.ak(b,c)},
gL(){return this.dF(0)},
sL(a){this.ak(0,a)},
gq(){return this.aQ(0)},
sq(a){this.ak(0,a)},
gt(){return this.f.c===2?this.aQ(0):this.aQ(1)},
st(a){this.ak(this.f.c===2?0:1,a)},
gu(){return this.f.c===2?this.aQ(0):this.aQ(2)},
su(a){this.ak(this.f.c===2?0:2,a)},
gv(){var s=this.f,r=s.f==null
if(r&&s.c===2)s=this.aQ(1)
else s=r&&s.c<4?s.gC():this.aQ(3)
return s},
sv(a){this.ak(this.f.c===2?1:3,a)},
ga8(){return this.aQ(0)/this.f.gC()},
sa8(a){this.ak(0,a*this.f.gC())},
ga3(){return this.gt()/this.f.gC()},
sa3(a){var s=this.f,r=s.gC()
s=s.c===2?0:1
this.ak(s,a*r)},
ga7(){return this.gu()/this.f.gC()},
sa7(a){var s=this.f,r=s.gC()
s=s.c===2?0:2
this.ak(s,a*r)},
gaa(){return this.gv()/this.f.gC()},
saa(a){var s=this.f,r=s.gC()
s=s.c===2?1:3
this.ak(s,a*r)},
gah(){return this.f.c===2?this.aQ(0):A.W(this)},
aJ(a){var s,r,q=this
q.ak(0,a.gq())
s=a.gt()
r=q.f.c===2
q.ak(r?0:1,s)
s=a.gu()
q.ak(r?0:2,s)
s=a.gv()
q.ak(r?1:3,s)},
ap(a,b,c){var s=this,r=s.f.c
if(r>0){s.ak(0,a)
if(r>2){s.ak(1,b)
s.ak(2,c)}}},
ae(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.ak(0,a)
if(r===2)s.ak(1,d)
else if(r>2){s.ak(1,b)
s.ak(2,c)
if(r>3)s.ak(3,d)}}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cg){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.a3(b)
if(s.gp(b)!==q)return!1
if(p.aQ(0)!==s.n(b,0))return!1
if(q>1){if(p.aQ(1)!==s.n(b,1))return!1
if(q>2){if(p.aQ(2)!==s.n(b,2))return!1
if(q>3)if(p.aQ(3)!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.f}}
A.ch.prototype={
N(){var s=this
return new A.ch(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gP(){return null},
gC(){return 4294967295},
gH(){return B.J},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gJ(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
n(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
l(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gL(){return this.gq()},
sL(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:4294967295
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
ga8(){return this.gq()/4294967295},
sa8(a){this.sq(a*4294967295)},
ga3(){return this.gt()/4294967295},
sa3(a){this.st(a*4294967295)},
ga7(){return this.gu()/4294967295},
sa7(a){this.su(a*4294967295)},
gaa(){return this.gv()/4294967295},
saa(a){this.sv(a*4294967295)},
gah(){return this.d.c===2?this.gq():A.W(this)},
aJ(a){var s=this
s.sq(a.gq())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
ap(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ae(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ch){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=J.a3(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.n(b,0))return!1
if(q>1){if(r[p.c+1]!==s.n(b,1))return!1
if(q>2){if(r[p.c+2]!==s.n(b,2))return!1
if(q>3)if(r[p.c+3]!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.d}}
A.ci.prototype={
N(){var s=this
return new A.ci(s.a,s.b,s.c,s.d,s.e)},
gp(a){var s=this.e,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gP(){return this.e.f},
gC(){return this.e.gC()},
gH(){return B.y},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q,p=this
p.a=a
p.b=b
s=p.e
r=s.c*4
q=s.e
if(r===4)s=b*q+B.a.j(a,1)
else if(r===8)s=b*s.a+a
else{s=b*q
s=r===16?s+(a<<1>>>0):s+B.a.j(a*r,3)}p.c=s
s=a*r
p.d=r>7?s&4:s&7},
gJ(){return this},
E(){var s,r,q,p=this,o=p.e
if(++p.a===o.a){p.a=0
s=++p.b
p.d=0
p.c=s*o.e
return s<o.b}r=o.c
s=o.f!=null||r===1
q=p.d
if(s){s=q+4
p.d=s
if(s>7){p.d=0;++p.c}}else{s=p.d=q+(r<<2>>>0)
while(s>7){s-=8
p.d=s;++p.c}}s=p.c
o=o.d
o===$&&A.b()
return s<o.length},
dt(a){var s,r=this.c,q=4-(this.d+(a<<2>>>0))
if(q<0){q+=8;++r}s=this.e.d
s===$&&A.b()
return B.a.U(s[r],q)&15},
aR(a){var s=this.e,r=s.f
if(r==null)s=s.c>a?this.dt(a):0
else s=r.aW(this.dt(0),a)
return s},
al(a,b){var s,r,q,p,o,n,m=this.e
if(a>=m.c)return
s=this.c
r=4-(this.d+(a<<2>>>0))
if(r<0){r+=8;++s}q=m.d
q===$&&A.b()
p=q[s]
o=B.a.I(B.b.h(b),0,15)
n=r===4?15:240
q=B.a.Y(o,r)
m=m.d
m.$flags&2&&A.a(m)
m[s]=(p&n|q)>>>0},
n(a,b){return this.aR(b)},
l(a,b,c){return this.al(b,c)},
gL(){return this.dt(0)},
sL(a){this.al(0,a)},
gq(){return this.aR(0)},
sq(a){this.al(0,a)},
gt(){return this.e.c===2?this.aR(0):this.aR(1)},
st(a){this.al(this.e.c===2?0:1,a)},
gu(){return this.e.c===2?this.aR(0):this.aR(2)},
su(a){this.al(this.e.c===2?0:2,a)},
gv(){var s=this.e,r=s.f==null
if(r&&s.c===2)s=this.aR(1)
else s=r&&s.c<4?s.gC():this.aR(3)
return s},
sv(a){this.al(this.e.c===2?1:3,a)},
ga8(){return this.aR(0)/this.e.gC()},
sa8(a){this.al(0,a*this.e.gC())},
ga3(){return this.gt()/this.e.gC()},
sa3(a){var s=this.e,r=s.gC()
s=s.c===2?0:1
this.al(s,a*r)},
ga7(){return this.gu()/this.e.gC()},
sa7(a){var s=this.e,r=s.gC()
s=s.c===2?0:2
this.al(s,a*r)},
gaa(){return this.gv()/this.e.gC()},
saa(a){var s=this.e,r=s.gC()
s=s.c===2?1:3
this.al(s,a*r)},
gah(){return this.e.c===2?this.aR(0):A.W(this)},
aJ(a){var s,r,q=this
q.al(0,a.gq())
s=a.gt()
r=q.e.c===2
q.al(r?0:1,s)
s=a.gu()
q.al(r?0:2,s)
s=a.gv()
q.al(r?1:3,s)},
ap(a,b,c){var s=this,r=s.e.c
if(r>0){s.al(0,a)
if(r>2){s.al(1,b)
s.al(2,c)}}},
ae(a,b,c,d){var s=this,r=s.e.c
if(r>0){s.al(0,a)
if(r===2)s.al(1,d)
else if(r>2){s.al(1,b)
s.al(2,c)
if(r>3)s.al(3,d)}}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ci){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){q=p.e.c
s=J.a3(b)
if(s.gp(b)!==q)return!1
if(p.aR(0)!==s.n(b,0))return!1
if(q>1){if(p.aR(1)!==s.n(b,1))return!1
if(q>2){if(p.aR(2)!==s.n(b,2))return!1
if(q>3)if(p.aR(3)!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.e}}
A.cj.prototype={
N(){var s=this
return new A.cj(s.a,s.b,s.c,s.d)},
gp(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gP(){return this.d.e},
gC(){return this.d.gC()},
gH(){return B.e},
gaV(){return this.a},
gaM(){return this.b},
Z(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gJ(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
ba(a){var s=this.d,r=s.e
if(r!=null)s=r.aW(s.d[this.c],a)
else s=a<s.c?s.d[this.c+a]:0
return s},
n(a,b){return this.ba(b)},
l(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(B.b.I(c,0,255))
q.$flags&2&&A.a(q)
q[s+b]=r}},
gL(){return this.d.d[this.c]},
sL(a){var s=this.d.d,r=this.c,q=B.b.h(B.b.I(a,0,255))
s.$flags&2&&A.a(s)
s[r]=q},
gq(){var s=this.d,r=s.e
if(r==null)s=s.c>0?s.d[this.c]:0
else s=r.aI(s.d[this.c])
return s},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(B.b.I(a,0,255))
q.$flags&2&&A.a(q)
q[s]=r}},
gt(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c]
else r=q>1?r.d[s.c+1]:0}else r=q.aG(r.d[s.c])
return r},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q+1]=s}},
gu(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c]
else r=q>2?r.d[s.c+2]:0}else r=q.aE(r.d[s.c])
return r},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q+2]=s}},
gv(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c+1]
else r=q>3?r.d[s.c+3]:255}else r=q.aN(r.d[s.c])
return r},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q+3]=s}},
ga8(){return this.gq()/this.d.gC()},
sa8(a){this.sq(a*this.d.gC())},
ga3(){return this.gt()/this.d.gC()},
sa3(a){this.st(a*this.d.gC())},
ga7(){return this.gu()/this.d.gC()},
sa7(a){this.su(a*this.d.gC())},
gaa(){return this.gv()/this.d.gC()},
saa(a){this.sv(a*this.d.gC())},
gah(){return this.d.c===2?this.gq():A.W(this)},
aJ(a){var s=this
if(s.d.e!=null)s.sL(a.gL())
else{s.sq(a.gq())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())}},
ap(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ae(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gF(a){return new A.P(this)},
O(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cj){s=A.p(p,A.j(p).m("d.E"))
s=A.k(s)
r=A.p(b,A.j(b).m("d.E"))
return s===A.k(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.a3(b)
if(s.gp(b)!==q)return!1
if(p.ba(0)!==s.n(b,0))return!1
if(q>1){if(p.ba(1)!==s.n(b,1))return!1
if(q>2){if(p.ba(2)!==s.n(b,2))return!1
if(q>3)if(p.ba(3)!==s.n(b,3))return!1}}return!0}return!1},
gG(a){var s=A.p(this,A.j(this).m("d.E"))
return A.k(s)},
$iw:1,
$iv:1,
gb_(){return this.d}}
A.D.prototype={
N(){return new A.D()},
gb_(){return $.oL()},
gaV(){return 0},
gaM(){return 0},
gp(a){return 0},
gC(){return 0},
gH(){return B.e},
gP(){return null},
n(a,b){return 0},
l(a,b,c){},
gL(){return 0},
sL(a){},
gq(){return 0},
sq(a){},
gt(){return 0},
st(a){},
gu(){return 0},
su(a){},
gv(){return 0},
sv(a){},
ga8(){return 0},
sa8(a){},
ga3(){return 0},
sa3(a){},
ga7(){return 0},
sa7(a){},
gaa(){return 0},
saa(a){},
gah(){return 0},
aJ(a){},
ap(a,b,c){},
ae(a,b,c,d){},
Z(a,b){},
gJ(){return this},
E(){return!1},
O(a,b){if(b==null)return!1
return b instanceof A.D},
gG(a){return 0},
gF(a){return new A.P(this)},
$iw:1,
$iv:1}
A.kS.prototype={
hB(a,b){var s=this,r=a.a.gaw(),q=s.b,p=(a.gX()-1)*q,o=(a.gR()-1)*r,n=s.e
switch(b){case 2:n!==$&&A.y()
s.e=p
s.f!==$&&A.y()
s.f=-q
s.r!==$&&A.y()
s.r=r
break
case 3:n!==$&&A.y()
s.e=o+p
s.f!==$&&A.y()
s.f=-q
s.r!==$&&A.y()
s.r=-r
break
case 4:n!==$&&A.y()
s.e=o
s.f!==$&&A.y()
s.f=q
s.r!==$&&A.y()
s.r=-r
break
case 5:n!==$&&A.y()
s.e=0
s.f!==$&&A.y()
s.f=r
s.r!==$&&A.y()
s.r=q
break
case 6:n!==$&&A.y()
s.e=o
s.f!==$&&A.y()
s.f=-r
s.r!==$&&A.y()
s.r=q
break
case 7:n!==$&&A.y()
s.e=o+p
s.f!==$&&A.y()
s.f=-r
s.r!==$&&A.y()
s.r=-q
break
case 8:n!==$&&A.y()
s.e=p
s.f!==$&&A.y()
s.f=r
s.r!==$&&A.y()
s.r=-q
break
default:n!==$&&A.y()
s.e=0
s.f!==$&&A.y()
s.f=q
s.r!==$&&A.y()
s.r=r
break}}}
A.la.prototype={
$1(a){return A.on(a,this.a.a)},
$S:34}
A.iv.prototype={
a6(){return"FlipDirection."+this.b}}
A.fD.prototype={
B(a){return"ImageException: "+this.a}}
A.a6.prototype={
gp(a){return this.c-this.d},
l(a,b,c){J.V(this.a,this.d+b,c)
return c},
c0(a,b,c,d){var s=this.a,r=J.aB(s),q=this.d+a
if(c instanceof A.a6)r.a_(s,q,q+b,c.a,c.d+d)
else r.a_(s,q,q+b,t.L.a(c),d)},
cY(a,b,c){return this.c0(a,b,c,0)},
kP(a,b,c){var s=this.a,r=this.d+a
J.dB(s,r,r+b,c)},
da(a,b,c){var s=this,r=c!=null?s.b+c:s.d
return A.q(s.a,s.e,a,r+b)},
aq(a){return this.da(a,0,null)},
bE(a,b){return this.da(a,0,b)},
cv(a,b){return this.da(a,b,null)},
D(){return J.c(this.a,this.d++)},
a1(a){var s=this.aq(a)
this.d=this.d+(s.c-s.d)
return s},
ag(a){var s,r,q,p,o,n=this
if(a==null){s=A.m([],t.t)
for(r=n.c;q=n.d,q<r;){p=n.a
n.d=q+1
o=J.c(p,q)
if(o===0)return A.ey(s,0,null)
s.push(o)}throw A.e(A.i("EOF reached without finding string terminator (length: "+A.x(a)+")"))}return A.ey(n.a1(a).T(),0,null)},
cm(){return this.ag(null)},
fR(a){var s,r,q,p,o=this,n=A.m([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.c(q,r)
n.push(p)
if(p===10||n.length>=a)return A.ey(n,0,null)}return A.ey(n,0,null)},
kW(){return this.fR(256)},
kX(){var s,r,q,p,o=this,n=A.m([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.c(q,r)
if(p===0)return new A.i1(!0).eE(n,0,null,!0)
n.push(p)}return B.bY.kp(n,!0)},
k(){var s=this,r=J.c(s.a,s.d++)&255,q=J.c(s.a,s.d++)&255
if(s.e)return r<<8|q
return q<<8|r},
b6(){var s=this,r=J.c(s.a,s.d++)&255,q=J.c(s.a,s.d++)&255,p=J.c(s.a,s.d++)&255
if(s.e)return p|q<<8|r<<16
return r|q<<8|p<<16},
i(){var s=this,r=J.c(s.a,s.d++)&255,q=J.c(s.a,s.d++)&255,p=J.c(s.a,s.d++)&255,o=J.c(s.a,s.d++)&255
if(s.e)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
d1(){return A.ua(this.e5())},
e5(){var s=this,r=J.c(s.a,s.d++)&255,q=J.c(s.a,s.d++)&255,p=J.c(s.a,s.d++)&255,o=J.c(s.a,s.d++)&255,n=J.c(s.a,s.d++)&255,m=J.c(s.a,s.d++)&255,l=J.c(s.a,s.d++)&255,k=J.c(s.a,s.d++)&255
if(s.e)return(B.a.M(r,56)|B.a.M(q,48)|B.a.M(p,40)|B.a.M(o,32)|n<<24|m<<16|l<<8|k)>>>0
return(B.a.M(k,56)|B.a.M(l,48)|B.a.M(m,40)|B.a.M(n,32)|o<<24|p<<16|q<<8|r)>>>0},
e8(a,b,c){var s,r=this,q=r.a
if(t.D.b(q))return r.fX(b,c)
s=r.b+r.d+b
return J.lx(q,s,c<=0?r.c:s+c)},
fX(a,b){var s,r=this,q=b==null?r.c-r.d-a:b,p=r.a
if(t.D.b(p))return J.aj(B.c.gA(p),p.byteOffset+r.d+a,q)
s=r.d+a
s=new Uint8Array(A.t(J.lx(p,s,s+q)))
return s},
T(){return this.fX(0,null)},
d6(){var s=this.a
if(t.D.b(s))return J.au(B.c.gA(s),s.byteOffset+this.d,null)
return J.au(B.c.gA(this.T()),0,null)}}
A.jk.prototype={
aU(a){var s,r=this,q=r.a,p=r.c,o=p.length
if(q===o){s=Math.max(o*3,q+1+8192)
o=new Uint8Array(s)
B.c.aK(o,0,q,p)
r.c=o
q=o}else q=p
p=r.a++
q.$flags&2&&A.a(q)
q[p]=a&255},
h2(a){this.aU(a&255)
this.aU(B.a.j(a,8)&255)},
d7(a){var s=this
s.aU(a&255)
s.aU(a>>>8&255)
s.aU(a>>>16&255)
s.aU(a>>>24&255)},
gp(a){return this.a}}
A.df.prototype={
h(a){var s=this.b
return s===0?0:B.a.a5(this.a,s)},
O(a,b){if(b==null)return!1
return b instanceof A.df&&this.a===b.a&&this.b===b.b},
gG(a){return A.lN(this.a,this.b,B.B,B.B)},
B(a){return""+this.a+"/"+this.b}}
A.j3.prototype={
gdT(){return this.a},
ge2(){var s=this.c
return new A.bH(s,A.j(s).m("bH<1>"))},
dZ(){var s=this.a
if(s.gfI())return
s.geg().by(0,A.c6([B.ae,B.aR],t.M,t.gq))},
d9(a,b){var s=this.a
if(s.gfI())return
s.geg().by(0,A.c6([B.ae,a],t.M,this.$ti.c))},
ct(a){var s=this.a
if(s.gfI())return
s.geg().by(0,A.c6([B.ae,a],t.M,t.gg))},
$ij2:1}
A.d_.prototype={
gdT(){return this.a},
ge2(){return A.X(A.eA("onIsolateMessage is not implemented"))},
dZ(){return A.X(A.eA("initialized method is not implemented"))},
d9(a,b){return A.X(A.eA("sendResult is not implemented"))},
ct(a){return A.X(A.eA("sendResultError is not implemented"))},
bY(){var s=0,r=A.mo(t.H),q=this
var $async$bY=A.mp(function(a,b){if(a===1)return A.mh(b,r)
for(;;)switch(s){case 0:q.a.terminate()
s=2
return A.mg(q.e.bY(),$async$bY)
case 2:return A.mi(null,r)}})
return A.mj($async$bY,r)},
iQ(a){var s,r,q,p,o,n,m,l=this
try{s=t.fF.a(A.mu(a.data))
if(s==null)return
if(J.aG(s.n(0,"type"),"data")){r=s.n(0,"value")
if(t.F.b(A.m([],l.$ti.m("o<1>")))){n=r
if(n==null)n=A.l4(n)
r=A.fB(n,t.f)}l.e.by(0,l.c.$1(r))
return}if(B.aR.fL(s)){n=l.r
if((n.a.a&30)===0)n.kn()
return}if(B.co.fL(s)){l.bY()
return}if(J.aG(s.n(0,"type"),"$IsolateException")){q=A.pH(s)
l.e.dQ(q,q.c)
return}l.e.kg(new A.ax("","Unhandled "+s.B(0)+" from the Isolate",B.H))}catch(m){p=A.ar(m)
o=A.b4(m)
l.e.dQ(new A.ax("",p,o),o)}},
$ij2:1}
A.fT.prototype={
a6(){return"IsolatePort."+this.b}}
A.e3.prototype={
a6(){return"IsolateState."+this.b},
fL(a){return J.aG(a.n(0,"type"),"$IsolateState")&&J.aG(a.n(0,"value"),this.b)}}
A.fR.prototype={}
A.fS.prototype={}
A.hS.prototype={
hA(a,b,c,d){this.a.onmessage=A.o6(new A.kP(this,d))},
ge2(){var s=this.c,r=A.j(s).m("bH<1>")
return new A.dE(new A.bH(s,r),r.m("@<b1.T>").aC(this.$ti.y[1]).m("dE<1,2>"))},
d9(a,b){var s=A.mz(A.c6(["type","data","value",a instanceof A.L?a.gc2():a],t.N,t.X))
this.a.postMessage(s)},
ct(a){var s=t.N
this.a.postMessage(A.mz(A.c6(["type","$IsolateException","name",a.gcZ(),"value",A.c6(["e",J.dC(a.b),"s",a.c.B(0)],s,s)],s,t.z)))},
dZ(){var s=t.N
this.a.postMessage(A.mz(A.c6(["type","$IsolateState","value","initialized"],s,s)))}}
A.kP.prototype={
$1(a){var s,r=A.mu(a.data),q=this.b
if(t.F.b(A.m([],q.m("o<0>")))){s=r==null?A.l4(r):r
r=A.fB(s,t.f)}this.a.c.by(0,q.a(r))},
$S:36}
A.hR.prototype={}
A.lo.prototype={
$1(a){return this.h3(a)},
h3(a){var s=0,r=A.mo(t.H),q=1,p=[],o=this,n,m,l,k,j,i,h
var $async$$1=A.mp(function(b,c){if(b===1){p.push(c)
s=q}for(;;)switch(s){case 0:q=3
k=o.a.$1(a)
j=o.d
s=6
return A.mg(j.m("bu<0>").b(k)?k:A.nQ(k,j),$async$$1)
case 6:n=c
o.b.a.a.d9(n,null)
q=1
s=5
break
case 3:q=2
h=p.pop()
m=A.ar(h)
l=A.b4(h)
k=o.b.a
if(m instanceof A.ax)k.a.ct(m)
else k.a.ct(new A.ax("",m,l))
s=5
break
case 2:s=1
break
case 5:return A.mi(null,r)
case 1:return A.mh(p.at(-1),r)}})
return A.mj($async$$1,r)},
$S(){return this.c.m("bu<~>(0)")}}
A.iS.prototype={}
A.ax.prototype={
B(a){return this.gcZ()+": "+A.x(this.b)+"\n"+this.c.B(0)},
gcZ(){return this.a}}
A.cn.prototype={
gcZ(){return"UnsupportedImTypeException"}}
A.L.prototype={
gc2(){return this.a},
O(a,b){var s,r=this
if(b==null)return!1
if(r!==b)s=A.j(r).m("L<L.T>").b(b)&&A.dz(r)===A.dz(b)&&J.aG(r.a,b.a)
else s=!0
return s},
gG(a){return J.av(this.a)},
B(a){return"ImType("+A.x(this.a)+")"}}
A.iM.prototype={
$1(a){return A.fB(a,t.f)},
$S:37}
A.iN.prototype={
$2(a,b){var s=t.f
return new A.az(A.fB(a,s),A.fB(b,s),t.dq)},
$S:38}
A.fz.prototype={
B(a){return"ImNum("+A.x(this.a)+")"}}
A.fA.prototype={
B(a){return"ImString("+this.a+")"}}
A.fy.prototype={
B(a){return"ImBool("+this.a+")"}}
A.dV.prototype={
O(a,b){var s
if(b==null)return!1
if(this!==b)s=b instanceof A.dV&&A.dz(this)===A.dz(b)&&this.iZ(b.b)
else s=!0
return s},
gG(a){return A.k(this.b)},
iZ(a){var s,r,q=this.b
if(q.gp(q)!==a.gp(a))return!1
s=q.gF(q)
r=a.gF(a)
for(;;){if(!(s.E()&&r.E()))break
if(!s.gJ().O(0,r.gJ()))return!1}return!0},
B(a){return"ImList("+this.b.B(0)+")"}}
A.dW.prototype={
B(a){return"ImMap("+this.b.B(0)+")"}}
A.bq.prototype={
gc2(){return this.b.bC(0,new A.kN(this),A.j(this).m("bq.T"))}}
A.kN.prototype={
$1(a){return a.gc2()},
$S(){return A.j(this.a).m("bq.T(L<bq.T>)")}}
A.ao.prototype={
gc2(){var s=A.j(this)
return this.b.e1(0,new A.kO(this),s.m("ao.K"),s.m("ao.V"))},
O(a,b){var s
if(b==null)return!1
if(this!==b)s=b instanceof A.dW&&A.dz(this)===A.dz(b)&&this.j_(b.b)
else s=!0
return s},
gG(a){var s=this.b
return A.k(new A.be(s,A.j(s).m("be<1,2>")))},
j_(a){var s,r,q=this.b
if(q.a!==a.a)return!1
for(q=new A.be(q,A.j(q).m("be<1,2>")).gF(0);q.E();){s=q.d
r=s.a
if(!a.am(r)||!J.aG(a.n(0,r),s.b))return!1}return!0}}
A.kO.prototype={
$2(a,b){return new A.az(a.gc2(),b.gc2(),A.j(this.a).m("az<ao.K,ao.V>"))},
$S(){return A.j(this.a).m("az<ao.K,ao.V>(L<ao.K>,L<ao.V>)")}};(function aliases(){var s=J.by.prototype
s.hc=s.B
s=A.E.prototype
s.ej=s.a_})();(function installTearOffs(){var s=hunkHelpers._instance_1u,r=hunkHelpers._static_1,q=hunkHelpers._static_0,p=hunkHelpers._static_2,o=hunkHelpers._instance_2u,n=hunkHelpers._instance_0u,m=hunkHelpers.installInstanceTearOff,l=hunkHelpers.installStaticTearOff
s(A.dF.prototype,"gj1","j2",46)
r(A,"tA","r9",9)
r(A,"tB","ra",9)
r(A,"tC","rb",9)
q(A,"ol","tt",2)
r(A,"tD","te",7)
p(A,"tF","tg",13)
q(A,"tE","tf",2)
o(A.R.prototype,"ghS","hT",13)
n(A.eM.prototype,"gj3","j4",2)
m(A.Y.prototype,"gbl",1,0,null,["$1","$0"],["a2","h"],4,0,0)
m(A.bc.prototype,"gbl",1,0,null,["$1","$0"],["a2","h"],4,0,0)
m(A.c1.prototype,"gbl",1,0,null,["$1","$0"],["a2","h"],4,0,0)
m(A.bw.prototype,"gbl",1,0,null,["$1","$0"],["a2","h"],4,0,0)
m(A.bY.prototype,"gbl",1,0,null,["$1","$0"],["a2","h"],4,0,0)
m(A.bx.prototype,"gbl",1,0,null,["$1","$0"],["a2","h"],4,0,0)
m(A.c0.prototype,"gbl",1,0,null,["$1","$0"],["a2","h"],4,0,0)
m(A.bZ.prototype,"gbl",1,0,null,["$1","$0"],["a2","h"],4,0,0)
m(A.c_.prototype,"gbl",1,0,null,["$1","$0"],["a2","h"],4,0,0)
m(A.cP.prototype,"gbl",1,0,null,["$1","$0"],["a2","h"],4,0,0)
s(A.fX.prototype,"gi6","i7",27)
var k
m(k=A.fZ.prototype,"gi8",0,3,null,["$3"],["i9"],6,0,0)
m(k,"gib",0,3,null,["$3"],["ic"],6,0,0)
m(k,"gie",0,3,null,["$3"],["ig"],6,0,0)
m(k,"gi0",0,3,null,["$3"],["i1"],6,0,0)
m(k,"gi2",0,3,null,["$3"],["i3"],6,0,0)
r(A,"uk","qy",0)
r(A,"ud","qq",0)
r(A,"ub","qo",0)
r(A,"ui","qw",0)
r(A,"uj","qx",0)
r(A,"uh","qv",0)
r(A,"ug","qu",0)
r(A,"uf","qt",0)
r(A,"um","qA",0)
r(A,"ul","qz",0)
r(A,"ue","qr",0)
r(A,"uc","qp",0)
r(A,"ux","qL",0)
r(A,"uv","qJ",0)
r(A,"un","qB",0)
r(A,"up","qD",0)
r(A,"uo","qC",0)
r(A,"uq","qE",0)
r(A,"uy","qM",0)
r(A,"uw","qK",0)
r(A,"ur","qF",0)
r(A,"us","qG",0)
r(A,"ut","qH",0)
r(A,"uu","qI",0)
o(A.eF.prototype,"gjo","jp",11)
o(A.fO.prototype,"gkA","kB",11)
l(A,"mB",3,null,["$3"],["qN"],3,0)
l(A,"uz",3,null,["$3"],["qO"],3,0)
l(A,"uE",3,null,["$3"],["qT"],3,0)
l(A,"uF",3,null,["$3"],["qU"],3,0)
l(A,"uG",3,null,["$3"],["qV"],3,0)
l(A,"uH",3,null,["$3"],["qW"],3,0)
l(A,"uI",3,null,["$3"],["qX"],3,0)
l(A,"uJ",3,null,["$3"],["qY"],3,0)
l(A,"uK",3,null,["$3"],["qZ"],3,0)
l(A,"uL",3,null,["$3"],["r_"],3,0)
l(A,"uA",3,null,["$3"],["qP"],3,0)
l(A,"uB",3,null,["$3"],["qQ"],3,0)
l(A,"uC",3,null,["$3"],["qR"],3,0)
l(A,"uD",3,null,["$3"],["qS"],3,0)
s(A.d_.prototype,"giP","iQ",35)
l(A,"tY",1,null,["$3","$1","$2"],["lG",function(a){return A.lG(a,B.H,"")},function(a,b){return A.lG(a,b,"")}],42,0)
l(A,"tZ",1,null,["$2","$1"],["nJ",function(a){return A.nJ(a,B.H)}],43,0)
l(A,"uN",6,null,["$6"],["r6"],8,0)
l(A,"uO",6,null,["$6"],["r7"],8,0)
l(A,"uM",6,null,["$6"],["r5"],8,0)
l(A,"op",1,null,["$1$3$customConverter$enableWasmConverter","$1","$1$1"],["mt",function(a){return A.mt(a,null,!0,t.z)},function(a,b){return A.mt(a,null,!0,b)}],45,0)
r(A,"u7","tM",30)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.n,null)
q(A.n,[A.lJ,J.fI,A.eu,J.f8,A.b1,A.dF,A.S,A.E,A.jN,A.d,A.d4,A.h2,A.hG,A.hr,A.fm,A.dO,A.hy,A.jS,A.cJ,A.bN,A.dq,A.bD,A.k4,A.jj,A.dJ,A.eW,A.bA,A.jd,A.ab,A.bz,A.h0,A.kx,A.i0,A.b0,A.hP,A.i_,A.kW,A.hH,A.aI,A.eJ,A.hJ,A.hK,A.dm,A.R,A.hI,A.hM,A.kz,A.hV,A.eM,A.hY,A.l3,A.hQ,A.kR,A.hT,A.hU,A.fj,A.ff,A.i1,A.fk,A.kB,A.h4,A.ew,A.kC,A.ba,A.az,A.ac,A.eX,A.ex,A.fo,A.ji,A.iC,A.fF,A.iR,A.iU,A.jm,A.P,A.bv,A.hO,A.fn,A.b5,A.Y,A.bh,A.id,A.b9,A.ij,A.dI,A.fp,A.io,A.fq,A.fr,A.it,A.dL,A.hW,A.dQ,A.dR,A.cL,A.iI,A.fx,A.fh,A.bV,A.j9,A.j6,A.c3,A.fX,A.dp,A.hX,A.fY,A.ja,A.fZ,A.er,A.ju,A.hZ,A.b7,A.dc,A.jA,A.db,A.jF,A.hh,A.hk,A.hp,A.et,A.dd,A.ho,A.aL,A.hs,A.jZ,A.ht,A.k2,A.hu,A.k3,A.jg,A.k8,A.eE,A.k9,A.kg,A.kj,A.kl,A.eD,A.kk,A.ka,A.bF,A.hC,A.hE,A.hD,A.hF,A.eF,A.hA,A.kh,A.hB,A.km,A.eG,A.ft,A.fu,A.dT,A.dS,A.dU,A.fv,A.dk,A.bb,A.jn,A.jo,A.kS,A.fD,A.a6,A.jk,A.df,A.j3,A.d_,A.fR,A.hR,A.hS,A.iS,A.ax,A.L])
q(J.fI,[J.fV,J.e7,J.e9,J.d1,J.d2,J.e8,J.d0])
q(J.e9,[J.by,J.o,A.d5,A.eh])
q(J.by,[J.hd,J.eB,J.bd])
r(J.fU,A.eu)
r(J.j5,J.o)
q(J.e8,[J.e6,J.fW])
q(A.b1,[A.dE,A.ds])
q(A.S,[A.d3,A.bm,A.h_,A.hx,A.hq,A.hN,A.f9,A.aT,A.eC,A.hw,A.bE,A.fi])
r(A.dh,A.E)
r(A.aV,A.dh)
q(A.d,[A.u,A.bf,A.eH,A.bk,A.eP,A.cy,A.cz,A.cA,A.cB,A.cC,A.cD,A.cE,A.cF,A.cG,A.cH,A.cI,A.aW,A.aw,A.a9,A.c8,A.c9,A.ca,A.cb,A.cc,A.cd,A.ce,A.cf,A.cg,A.ch,A.ci,A.cj,A.D])
q(A.u,[A.aD,A.bQ,A.c5,A.je,A.be,A.eO])
q(A.aD,[A.ez,A.bg,A.ea])
r(A.bP,A.bf)
r(A.cK,A.bk)
q(A.bN,[A.ih,A.iV,A.ig,A.jU,A.lj,A.ll,A.ks,A.kr,A.l5,A.kL,A.jQ,A.lp,A.lr,A.ls,A.ld,A.i9,A.iu,A.jw,A.iP,A.iO,A.la,A.kP,A.lo,A.iM,A.kN])
q(A.ih,[A.ii,A.lk,A.l6,A.l9,A.kM,A.jf,A.jh,A.iJ,A.iK,A.iL,A.iN,A.kO])
q(A.cJ,[A.dH,A.bU])
q(A.bD,[A.dG,A.eV])
r(A.dP,A.dG)
r(A.e1,A.iV)
r(A.em,A.bm)
q(A.jU,[A.jP,A.dD])
q(A.bA,[A.aY,A.eN])
r(A.c4,A.aY)
q(A.eh,[A.h3,A.d6])
q(A.d6,[A.eR,A.eT])
r(A.eS,A.eR)
r(A.eg,A.eS)
r(A.eU,A.eT)
r(A.aE,A.eU)
q(A.eg,[A.eb,A.ec])
q(A.aE,[A.ed,A.ee,A.ef,A.ei,A.ej,A.ek,A.c7])
r(A.eY,A.hN)
q(A.ig,[A.kt,A.ku,A.kX,A.kD,A.kH,A.kG,A.kF,A.kE,A.kK,A.kJ,A.kI,A.jR,A.kw,A.kv,A.kT,A.kV,A.l8,A.l1,A.l0,A.ic,A.ia,A.ib,A.is,A.iq,A.ir,A.iB,A.iz,A.iA,A.iH,A.iG,A.iF,A.j8,A.jt,A.jr,A.js,A.jy,A.jz,A.jx,A.jD,A.jE,A.jC,A.jM,A.jK,A.jL,A.jX,A.jY,A.jW,A.k0,A.k1,A.kq,A.ko,A.kp])
r(A.eK,A.ds)
r(A.bH,A.eK)
r(A.eL,A.eJ)
r(A.dl,A.eL)
r(A.eI,A.hJ)
r(A.cq,A.hK)
q(A.hM,[A.hL,A.kA])
r(A.kU,A.l3)
r(A.dn,A.eN)
r(A.eQ,A.eV)
q(A.fj,[A.kY,A.hz])
r(A.il,A.ff)
q(A.il,[A.jb,A.k7])
r(A.jc,A.kY)
q(A.aT,[A.bj,A.fE])
q(A.kB,[A.e0,A.dr,A.fe,A.ie,A.ae,A.fb,A.a8,A.a7,A.bT,A.bS,A.aX,A.cN,A.d7,A.eq,A.bB,A.bC,A.b_,A.am,A.cm,A.a1,A.aN,A.co,A.dj,A.fw,A.fs,A.e2,A.iv,A.fT,A.e3])
r(A.f7,A.ba)
q(A.iU,[A.fG,A.fH])
q(A.jm,[A.ky,A.lO])
q(A.aW,[A.fg,A.bO])
r(A.bR,A.bv)
q(A.Y,[A.bc,A.bX,A.c1,A.bw,A.bY,A.bx,A.c0,A.bZ,A.c_,A.cQ,A.cO,A.cR,A.cP])
q(A.ij,[A.fc,A.ip,A.iy,A.iE,A.j7,A.jq,A.jv,A.jB,A.jJ,A.jV,A.k_,A.kn])
r(A.ik,A.fc)
r(A.iY,A.io)
q(A.iY,[A.fJ,A.iZ,A.j_,A.j0,A.fL])
r(A.fK,A.dL)
r(A.fM,A.dR)
r(A.iD,A.b9)
q(A.bV,[A.bW,A.cM])
r(A.fN,A.er)
r(A.j1,A.ju)
r(A.ck,A.dI)
q(A.b7,[A.hf,A.hg,A.hi,A.hj,A.hm,A.hn])
q(A.dc,[A.es,A.hl])
q(A.hp,[A.de,A.al])
r(A.fO,A.eF)
r(A.fP,A.eG)
r(A.fQ,A.dk)
q(A.a9,[A.cS,A.cT,A.dX,A.dY,A.dZ,A.e_,A.cU,A.c2,A.cV,A.cW,A.cX,A.cY])
q(A.jn,[A.h5,A.h6,A.h7,A.h8,A.h9,A.ha,A.hb,A.hc,A.b6])
r(A.fS,A.hR)
r(A.cn,A.ax)
q(A.L,[A.fz,A.fA,A.fy,A.bq,A.ao])
r(A.dV,A.bq)
r(A.dW,A.ao)
s(A.dh,A.hy)
s(A.eR,A.E)
s(A.eS,A.dO)
s(A.eT,A.E)
s(A.eU,A.dO)
s(A.hR,A.iS)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{h:"int",I:"double",l:"num",a4:"String",aq:"bool",ac:"Null",A:"List",n:"Object",ay:"Map",T:"JSObject"},mangledNames:{},types:["~(a6)","aw?()","~()","h(h,bo,h)","h([h])","dI?()","~(c3,cZ,h)","~(@)","~(h,h,h,h,h,b2)","~(~())","ac(@)","~(h,aq)","ac()","~(n,af)","~(a4,b5)","@()","n?(n?)","~(n?,n?)","~(h,Y)","~(@,@)","b9?()","aw()","~(l,l,l,l)","ac(n,af)","bo(h)","~(h,@)","cL?()","~(h)","ac(@,af)","aq(a4)","aq(b2)","dk?()","l(l,l,l,l)","l(l,l,l,l,l)","aq(aw)","~(T)","ac(T)","L<n>(@)","az<L<n>,L<n>>(@,@)","ac(~())","@(a4)","@(@,a4)","ax(n[af,a4])","cn(n[af])","@(@)","0^(@{customConverter:0^(@)?,enableWasmConverter:aq})<n?>","~(n?)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti")}
A.rt(v.typeUniverse,JSON.parse('{"hd":"by","eB":"by","bd":"by","uV":"d5","fV":{"aq":[],"M":[]},"e7":{"M":[]},"e9":{"T":[]},"by":{"T":[]},"o":{"A":["1"],"u":["1"],"T":[],"d":["1"],"aa":["1"]},"fU":{"eu":[]},"j5":{"o":["1"],"A":["1"],"u":["1"],"T":[],"d":["1"],"aa":["1"]},"e8":{"I":[],"l":[]},"e6":{"I":[],"h":[],"l":[],"M":[]},"fW":{"I":[],"l":[],"M":[]},"d0":{"a4":[],"aa":["@"],"M":[]},"dE":{"b1":["2"],"b1.T":"2"},"d3":{"S":[]},"aV":{"E":["h"],"A":["h"],"u":["h"],"d":["h"],"E.E":"h"},"u":{"d":["1"]},"aD":{"u":["1"],"d":["1"]},"ez":{"aD":["1"],"u":["1"],"d":["1"],"d.E":"1","aD.E":"1"},"bf":{"d":["2"],"d.E":"2"},"bP":{"bf":["1","2"],"u":["2"],"d":["2"],"d.E":"2"},"bg":{"aD":["2"],"u":["2"],"d":["2"],"d.E":"2","aD.E":"2"},"eH":{"d":["1"],"d.E":"1"},"bk":{"d":["1"],"d.E":"1"},"cK":{"bk":["1"],"u":["1"],"d":["1"],"d.E":"1"},"bQ":{"u":["1"],"d":["1"],"d.E":"1"},"dh":{"E":["1"],"A":["1"],"u":["1"],"d":["1"]},"cJ":{"ay":["1","2"]},"dH":{"cJ":["1","2"],"ay":["1","2"]},"eP":{"d":["1"],"d.E":"1"},"bU":{"cJ":["1","2"],"ay":["1","2"]},"dG":{"bD":["1"],"ev":["1"],"u":["1"],"d":["1"]},"dP":{"bD":["1"],"ev":["1"],"u":["1"],"d":["1"]},"em":{"bm":[],"S":[]},"h_":{"S":[]},"hx":{"S":[]},"eW":{"af":[]},"hq":{"S":[]},"aY":{"bA":["1","2"],"ay":["1","2"]},"c5":{"u":["1"],"d":["1"],"d.E":"1"},"je":{"u":["1"],"d":["1"],"d.E":"1"},"be":{"u":["az<1,2>"],"d":["az<1,2>"],"d.E":"az<1,2>"},"c4":{"aY":["1","2"],"bA":["1","2"],"ay":["1","2"]},"d5":{"T":[],"fd":[],"M":[]},"eh":{"T":[]},"i0":{"fd":[]},"h3":{"lz":[],"T":[],"M":[]},"d6":{"aC":["1"],"T":[],"aa":["1"]},"eg":{"E":["I"],"A":["I"],"aC":["I"],"u":["I"],"T":[],"aa":["I"],"d":["I"]},"aE":{"E":["h"],"A":["h"],"aC":["h"],"u":["h"],"T":[],"aa":["h"],"d":["h"]},"eb":{"iw":[],"E":["I"],"A":["I"],"aC":["I"],"u":["I"],"T":[],"aa":["I"],"d":["I"],"M":[],"E.E":"I"},"ec":{"ix":[],"E":["I"],"A":["I"],"aC":["I"],"u":["I"],"T":[],"aa":["I"],"d":["I"],"M":[],"E.E":"I"},"ed":{"aE":[],"cZ":[],"E":["h"],"A":["h"],"aC":["h"],"u":["h"],"T":[],"aa":["h"],"d":["h"],"M":[],"E.E":"h"},"ee":{"aE":[],"iW":[],"E":["h"],"A":["h"],"aC":["h"],"u":["h"],"T":[],"aa":["h"],"d":["h"],"M":[],"E.E":"h"},"ef":{"aE":[],"iX":[],"E":["h"],"A":["h"],"aC":["h"],"u":["h"],"T":[],"aa":["h"],"d":["h"],"M":[],"E.E":"h"},"ei":{"aE":[],"hv":[],"E":["h"],"A":["h"],"aC":["h"],"u":["h"],"T":[],"aa":["h"],"d":["h"],"M":[],"E.E":"h"},"ej":{"aE":[],"bo":[],"E":["h"],"A":["h"],"aC":["h"],"u":["h"],"T":[],"aa":["h"],"d":["h"],"M":[],"E.E":"h"},"ek":{"aE":[],"k6":[],"E":["h"],"A":["h"],"aC":["h"],"u":["h"],"T":[],"aa":["h"],"d":["h"],"M":[],"E.E":"h"},"c7":{"aE":[],"b2":[],"E":["h"],"A":["h"],"aC":["h"],"u":["h"],"T":[],"aa":["h"],"d":["h"],"M":[],"E.E":"h"},"hN":{"S":[]},"eY":{"bm":[],"S":[]},"aI":{"S":[]},"bH":{"ds":["1"],"b1":["1"],"b1.T":"1"},"dl":{"eJ":["1"]},"eI":{"hJ":["1"]},"cq":{"hK":["1"]},"R":{"bu":["1"]},"eK":{"ds":["1"],"b1":["1"]},"eL":{"eJ":["1"]},"ds":{"b1":["1"]},"eN":{"bA":["1","2"],"ay":["1","2"]},"dn":{"eN":["1","2"],"bA":["1","2"],"ay":["1","2"]},"eO":{"u":["1"],"d":["1"],"d.E":"1"},"eQ":{"eV":["1"],"bD":["1"],"ev":["1"],"u":["1"],"d":["1"]},"E":{"A":["1"],"u":["1"],"d":["1"]},"bA":{"ay":["1","2"]},"ea":{"aD":["1"],"u":["1"],"d":["1"],"d.E":"1","aD.E":"1"},"bD":{"ev":["1"],"u":["1"],"d":["1"]},"eV":{"bD":["1"],"ev":["1"],"u":["1"],"d":["1"]},"I":{"l":[]},"h":{"l":[]},"A":{"u":["1"],"d":["1"]},"ev":{"u":["1"],"d":["1"]},"f9":{"S":[]},"bm":{"S":[]},"aT":{"S":[]},"bj":{"S":[]},"fE":{"bj":[],"S":[]},"eC":{"S":[]},"hw":{"S":[]},"bE":{"S":[]},"fi":{"S":[]},"h4":{"S":[]},"ew":{"S":[]},"eX":{"af":[]},"cy":{"w":[],"d":["l"],"d.E":"l"},"cz":{"w":[],"d":["l"],"d.E":"l"},"cA":{"w":[],"d":["l"],"d.E":"l"},"cB":{"w":[],"d":["l"],"d.E":"l"},"cC":{"w":[],"d":["l"],"d.E":"l"},"cD":{"w":[],"d":["l"],"d.E":"l"},"cE":{"w":[],"d":["l"],"d.E":"l"},"cF":{"w":[],"d":["l"],"d.E":"l"},"cG":{"w":[],"d":["l"],"d.E":"l"},"cH":{"w":[],"d":["l"],"d.E":"l"},"cI":{"w":[],"d":["l"],"d.E":"l"},"aW":{"w":[],"d":["l"],"d.E":"l"},"fg":{"w":[],"d":["l"],"d.E":"l"},"bO":{"w":[],"d":["l"],"d.E":"l"},"bc":{"Y":[]},"bX":{"Y":[]},"c1":{"Y":[]},"bw":{"Y":[]},"bY":{"Y":[]},"bx":{"Y":[]},"c0":{"Y":[]},"bZ":{"Y":[]},"c_":{"Y":[]},"cQ":{"Y":[]},"cO":{"Y":[]},"cR":{"Y":[]},"cP":{"Y":[]},"fK":{"dL":[]},"fM":{"dR":[]},"bW":{"bV":[]},"cM":{"bV":[]},"fN":{"er":[]},"hf":{"b7":[]},"hg":{"b7":[]},"hi":{"b7":[]},"hj":{"b7":[]},"hm":{"b7":[]},"hn":{"b7":[]},"es":{"dc":[]},"hl":{"dc":[]},"fP":{"eG":[]},"aw":{"d":["v"],"d.E":"v"},"a9":{"d":["v"]},"cS":{"a9":[],"d":["v"],"d.E":"v"},"cT":{"a9":[],"d":["v"],"d.E":"v"},"dX":{"a9":[],"d":["v"],"d.E":"v"},"dY":{"a9":[],"d":["v"],"d.E":"v"},"dZ":{"a9":[],"d":["v"],"d.E":"v"},"e_":{"a9":[],"d":["v"],"d.E":"v"},"cU":{"a9":[],"d":["v"],"d.E":"v"},"c2":{"a9":[],"d":["v"],"d.E":"v"},"cV":{"a9":[],"d":["v"],"d.E":"v"},"cW":{"a9":[],"d":["v"],"d.E":"v"},"cX":{"a9":[],"d":["v"],"d.E":"v"},"cY":{"a9":[],"d":["v"],"d.E":"v"},"c8":{"v":[],"w":[],"d":["l"],"d.E":"l"},"c9":{"v":[],"w":[],"d":["l"],"d.E":"l"},"ca":{"v":[],"w":[],"d":["l"],"d.E":"l"},"cb":{"v":[],"w":[],"d":["l"],"d.E":"l"},"cc":{"v":[],"w":[],"d":["l"],"d.E":"l"},"cd":{"v":[],"w":[],"d":["l"],"d.E":"l"},"ce":{"v":[],"w":[],"d":["l"],"d.E":"l"},"cf":{"v":[],"w":[],"d":["l"],"d.E":"l"},"cg":{"v":[],"w":[],"d":["l"],"d.E":"l"},"ch":{"v":[],"w":[],"d":["l"],"d.E":"l"},"ci":{"v":[],"w":[],"d":["l"],"d.E":"l"},"cj":{"v":[],"w":[],"d":["l"],"d.E":"l"},"D":{"v":[],"w":[],"d":["l"],"d.E":"l"},"j3":{"j2":["1","2"]},"d_":{"j2":["1","2"]},"cn":{"ax":[]},"fz":{"L":["l"],"L.T":"l"},"fA":{"L":["a4"],"L.T":"a4"},"fy":{"L":["aq"],"L.T":"aq"},"dV":{"bq":["n"],"L":["d<n>"],"bq.T":"n","L.T":"d<n>"},"dW":{"ao":["n","n"],"L":["ay<n,n>"],"ao.K":"n","ao.V":"n","L.T":"ay<n,n>"},"bq":{"L":["d<1>"]},"ao":{"L":["ay<1,2>"]},"iX":{"A":["h"],"u":["h"],"d":["h"]},"b2":{"A":["h"],"u":["h"],"d":["h"]},"k6":{"A":["h"],"u":["h"],"d":["h"]},"cZ":{"A":["h"],"u":["h"],"d":["h"]},"hv":{"A":["h"],"u":["h"],"d":["h"]},"iW":{"A":["h"],"u":["h"],"d":["h"]},"bo":{"A":["h"],"u":["h"],"d":["h"]},"iw":{"A":["I"],"u":["I"],"d":["I"]},"ix":{"A":["I"],"u":["I"],"d":["I"]},"v":{"w":[],"d":["l"]}}'))
A.rs(v.typeUniverse,JSON.parse('{"dO":1,"hy":1,"dh":1,"dG":1,"d6":1,"eK":1,"eL":1,"hM":1,"ff":2,"fj":2,"hp":1}'))
var u={c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",h:"handleError callback must take either an Object (the error), or both an Object (the error) and a StackTrace."}
var t=(function rtii(){var s=A.U
return{dI:s("fd"),fd:s("lz"),G:s("w"),R:s("u<@>"),C:s("S"),aX:s("fp"),fe:s("bT"),gV:s("fr"),h4:s("iw"),gN:s("ix"),b8:s("uR"),ct:s("dS"),gj:s("ft"),ak:s("fu"),fa:s("dT"),gx:s("fx"),P:s("b5"),r:s("Y"),f:s("L<n>"),v:s("a9"),cV:s("c2"),W:s("cZ"),an:s("iW"),cu:s("iX"),U:s("j2<@,@>"),gg:s("ax"),M:s("fT"),gq:s("e3"),Y:s("d<@>"),eB:s("o<fh>"),g9:s("o<fq>"),dw:s("o<dL>"),b:s("o<dR>"),Z:s("o<dS>"),g:s("o<aw>"),b7:s("o<c3>"),_:s("o<A<A<A<h>>>>"),o:s("o<A<A<h>>>"),cJ:s("o<A<b2>>"),S:s("o<A<h>>"),dm:s("o<er>"),c:s("o<db>"),af:s("o<b7>"),l:s("o<hk>"),s:s("o<a4>"),aU:s("o<hu>"),h:s("o<b2>"),ao:s("o<bF>"),d:s("o<hB>"),J:s("o<eG>"),gn:s("o<hO>"),e8:s("o<dp>"),cO:s("o<@>"),t:s("o<h>"),f8:s("o<fY?>"),hh:s("o<bo?>"),A:s("o<~(a6)>"),aP:s("aa<@>"),T:s("e7"),m:s("T"),e:s("bd"),eA:s("aC<@>"),d2:s("c3"),ha:s("ea<a4>"),F:s("A<L<n>>"),c7:s("A<eD>"),e6:s("A<bF>"),j:s("A<@>"),L:s("A<h>"),dq:s("az<L<n>,L<n>>"),O:s("ay<@,@>"),bc:s("aE"),bm:s("c7"),a:s("ac"),K:s("n"),dv:s("v"),fW:s("db"),fh:s("hh"),cE:s("es"),hf:s("dc"),fi:s("et"),a7:s("dd"),fL:s("bj"),i:s("df"),gT:s("uX"),gm:s("af"),N:s("a4"),a4:s("ht"),ci:s("M"),eK:s("bm"),h7:s("hv"),w:s("bo"),go:s("k6"),D:s("b2"),bI:s("eB"),dd:s("eD"),fD:s("bF"),ai:s("hC"),cP:s("hD"),dE:s("hF"),cc:s("eH<a4>"),ez:s("cq<~>"),eI:s("R<@>"),fJ:s("R<h>"),q:s("R<~>"),x:s("dn<n?,n?>"),eO:s("hW"),y:s("aq"),V:s("I"),z:s("@"),B:s("@(n)"),Q:s("@(n,af)"),p:s("h"),eH:s("bu<ac>?"),en:s("bV?"),bC:s("cZ?"),bX:s("T?"),eC:s("A<bV?>?"),fF:s("ay<@,@>?"),X:s("n?"),E:s("a4?"),aD:s("b2?"),eW:s("eE?"),dP:s("hE?"),fQ:s("aq?"),cD:s("I?"),I:s("h?"),cg:s("l?"),n:s("l"),H:s("~"),u:s("~(n)"),k:s("~(n,af)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.cl=J.fI.prototype
B.k=J.o.prototype
B.a=J.e6.prototype
B.b=J.e8.prototype
B.D=J.d0.prototype
B.cp=J.bd.prototype
B.cq=J.e9.prototype
B.R=A.eb.prototype
B.V=A.ec.prototype
B.S=A.ed.prototype
B.E=A.ee.prototype
B.W=A.ef.prototype
B.A=A.ei.prototype
B.l=A.ej.prototype
B.c=A.c7.prototype
B.bk=J.hd.prototype
B.au=J.eB.prototype
B.a0=new A.fb(0,"direct")
B.aa=new A.fb(1,"alpha")
B.ax=new A.a7(0,"none")
B.ab=new A.a7(3,"bitfields")
B.ac=new A.a7(6,"alphaBitfields")
B.a1=new A.fe(0,"littleEndian")
B.ay=new A.fe(1,"bigEndian")
B.bQ=new A.fm(A.U("fm<0&>"))
B.az=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.bR=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof HTMLElement == "function";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.bW=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var userAgent = navigator.userAgent;
    if (typeof userAgent != "string") return hooks;
    if (userAgent.indexOf("DumpRenderTree") >= 0) return hooks;
    if (userAgent.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.bS=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.bV=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.bU=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.bT=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.aA=function(hooks) { return hooks; }

B.aB=new A.jb()
B.bX=new A.h4()
B.B=new A.jN()
B.bY=new A.k7()
B.bZ=new A.kz()
B.c_=new A.hX()
B.p=new A.kU()
B.aC=new A.hZ()
B.aD=new A.ie(4,"luminance")
B.c0=new A.bS(0,"red")
B.c1=new A.bS(1,"green")
B.c2=new A.bS(2,"blue")
B.c3=new A.bS(3,"alpha")
B.c4=new A.bS(4,"other")
B.aE=new A.bT(1,"half")
B.aF=new A.bT(2,"float")
B.aG=new A.aX(0,"none")
B.cd=new A.iv(2,"both")
B.ce=new A.ba("Invalid Huffman code length",null,null)
B.cf=new A.ba("Incomplete Huffman table",null,null)
B.cg=new A.ba("Oversubscribed Huffman table",null,null)
B.u=new A.ae(0,"uint1")
B.x=new A.ae(1,"uint2")
B.C=new A.ae(10,"float32")
B.I=new A.ae(11,"float64")
B.y=new A.ae(2,"uint4")
B.e=new A.ae(3,"uint8")
B.m=new A.ae(4,"uint16")
B.J=new A.ae(5,"uint32")
B.K=new A.ae(6,"int8")
B.L=new A.ae(7,"int16")
B.M=new A.ae(8,"int32")
B.z=new A.ae(9,"float16")
B.aH=new A.fs(1,"page")
B.i=new A.fs(2,"sequence")
B.a2=new A.fw(0,"none")
B.ch=new A.fw(1,"deflate")
B.aI=new A.cN(2,"cur")
B.d=new A.a8(0,"none")
B.aJ=new A.a8(1,"byte")
B.aK=new A.a8(10,"sRational")
B.aL=new A.a8(11,"single")
B.aM=new A.a8(12,"double")
B.aN=new A.a8(13,"ifd")
B.j=new A.a8(2,"ascii")
B.h=new A.a8(3,"short")
B.n=new A.a8(4,"long")
B.q=new A.a8(5,"rational")
B.aO=new A.a8(6,"sByte")
B.N=new A.a8(7,"undefined")
B.aP=new A.a8(8,"sShort")
B.aQ=new A.a8(9,"sLong")
B.ad=new A.e0(0,"gzip")
B.O=new A.e0(1,"zlib")
B.ck=new A.e0(2,"raw")
B.T=new A.e2(0,"nearest")
B.cm=new A.e2(1,"linear")
B.cn=new A.e2(3,"average")
B.ae=new A.fT(0,"main")
B.co=new A.e3(0,"dispose")
B.aR=new A.e3(1,"initialized")
B.cr=new A.jc(!1)
B.af=s([0,2,8],t.t)
B.cs=s([0,4,2,1],t.t)
B.ci=new A.cN(0,"invalid")
B.cj=new A.cN(1,"ico")
B.cu=s([B.ci,B.cj,B.aI],A.U("o<cN>"))
B.cL=s([252,243,207,63],t.t)
B.jm=new A.d7(0,"none")
B.bn=new A.d7(1,"background")
B.bo=new A.d7(2,"previous")
B.cM=s([B.jm,B.bn,B.bo],A.U("o<d7>"))
B.aT=s([292,260,226,226],t.t)
B.cP=s([2,3,7],t.t)
B.aU=s([3226,6412,200,168,38,38,134,134,100,100,100,100,68,68,68,68],t.t)
B.cY=s([3,3,11],t.t)
B.ak=s([128,128,128,128,128,128,128,128,128,128,128],t.t)
B.aW=s([B.ak,B.ak,B.ak],t.S)
B.dK=s([253,136,254,255,228,219,128,128,128,128,128],t.t)
B.eJ=s([189,129,242,255,227,213,255,219,128,128,128],t.t)
B.eO=s([106,126,227,252,214,209,255,255,128,128,128],t.t)
B.hj=s([B.dK,B.eJ,B.eO],t.S)
B.hp=s([1,98,248,255,236,226,255,255,128,128,128],t.t)
B.d3=s([181,133,238,254,221,234,255,154,128,128,128],t.t)
B.d1=s([78,134,202,247,198,180,255,219,128,128,128],t.t)
B.hO=s([B.hp,B.d3,B.d1],t.S)
B.dF=s([1,185,249,255,243,255,128,128,128,128,128],t.t)
B.hn=s([184,150,247,255,236,224,128,128,128,128,128],t.t)
B.iF=s([77,110,216,255,236,230,128,128,128,128,128],t.t)
B.fP=s([B.dF,B.hn,B.iF],t.S)
B.fX=s([1,101,251,255,241,255,128,128,128,128,128],t.t)
B.dI=s([170,139,241,252,236,209,255,255,128,128,128],t.t)
B.h2=s([37,116,196,243,228,255,255,255,128,128,128],t.t)
B.ds=s([B.fX,B.dI,B.h2],t.S)
B.f0=s([1,204,254,255,245,255,128,128,128,128,128],t.t)
B.iX=s([207,160,250,255,238,128,128,128,128,128,128],t.t)
B.iW=s([102,103,231,255,211,171,128,128,128,128,128],t.t)
B.e6=s([B.f0,B.iX,B.iW],t.S)
B.dj=s([1,152,252,255,240,255,128,128,128,128,128],t.t)
B.j1=s([177,135,243,255,234,225,128,128,128,128,128],t.t)
B.fJ=s([80,129,211,255,194,224,128,128,128,128,128],t.t)
B.hi=s([B.dj,B.j1,B.fJ],t.S)
B.aX=s([1,1,255,128,128,128,128,128,128,128,128],t.t)
B.hE=s([246,1,255,128,128,128,128,128,128,128,128],t.t)
B.fr=s([255,128,128,128,128,128,128,128,128,128,128],t.t)
B.jc=s([B.aX,B.hE,B.fr],t.S)
B.e_=s([B.aW,B.hj,B.hO,B.fP,B.ds,B.e6,B.hi,B.jc],t.o)
B.iI=s([198,35,237,223,193,187,162,160,145,155,62],t.t)
B.dJ=s([131,45,198,221,172,176,220,157,252,221,1],t.t)
B.iH=s([68,47,146,208,149,167,221,162,255,223,128],t.t)
B.fa=s([B.iI,B.dJ,B.iH],t.S)
B.hP=s([1,149,241,255,221,224,255,255,128,128,128],t.t)
B.i3=s([184,141,234,253,222,220,255,199,128,128,128],t.t)
B.fn=s([81,99,181,242,176,190,249,202,255,255,128],t.t)
B.is=s([B.hP,B.i3,B.fn],t.S)
B.ii=s([1,129,232,253,214,197,242,196,255,255,128],t.t)
B.iS=s([99,121,210,250,201,198,255,202,128,128,128],t.t)
B.hk=s([23,91,163,242,170,187,247,210,255,255,128],t.t)
B.ft=s([B.ii,B.iS,B.hk],t.S)
B.em=s([1,200,246,255,234,255,128,128,128,128,128],t.t)
B.ie=s([109,178,241,255,231,245,255,255,128,128,128],t.t)
B.cN=s([44,130,201,253,205,192,255,255,128,128,128],t.t)
B.ix=s([B.em,B.ie,B.cN],t.S)
B.dc=s([1,132,239,251,219,209,255,165,128,128,128],t.t)
B.cv=s([94,136,225,251,218,190,255,255,128,128,128],t.t)
B.ik=s([22,100,174,245,186,161,255,199,128,128,128],t.t)
B.fV=s([B.dc,B.cv,B.ik],t.S)
B.i2=s([1,182,249,255,232,235,128,128,128,128,128],t.t)
B.hc=s([124,143,241,255,227,234,128,128,128,128,128],t.t)
B.eG=s([35,77,181,251,193,211,255,205,128,128,128],t.t)
B.eQ=s([B.i2,B.hc,B.eG],t.S)
B.jd=s([1,157,247,255,236,231,255,255,128,128,128],t.t)
B.dZ=s([121,141,235,255,225,227,255,255,128,128,128],t.t)
B.ig=s([45,99,188,251,195,217,255,224,128,128,128],t.t)
B.dq=s([B.jd,B.dZ,B.ig],t.S)
B.cw=s([1,1,251,255,213,255,128,128,128,128,128],t.t)
B.cS=s([203,1,248,255,255,128,128,128,128,128,128],t.t)
B.i4=s([137,1,177,255,224,255,128,128,128,128,128],t.t)
B.dk=s([B.cw,B.cS,B.i4],t.S)
B.hW=s([B.fa,B.is,B.ft,B.ix,B.fV,B.eQ,B.dq,B.dk],t.o)
B.ea=s([253,9,248,251,207,208,255,192,128,128,128],t.t)
B.hF=s([175,13,224,243,193,185,249,198,255,255,128],t.t)
B.jb=s([73,17,171,221,161,179,236,167,255,234,128],t.t)
B.hx=s([B.ea,B.hF,B.jb],t.S)
B.hT=s([1,95,247,253,212,183,255,255,128,128,128],t.t)
B.fA=s([239,90,244,250,211,209,255,255,128,128,128],t.t)
B.iE=s([155,77,195,248,188,195,255,255,128,128,128],t.t)
B.i1=s([B.hT,B.fA,B.iE],t.S)
B.f2=s([1,24,239,251,218,219,255,205,128,128,128],t.t)
B.hI=s([201,51,219,255,196,186,128,128,128,128,128],t.t)
B.fz=s([69,46,190,239,201,218,255,228,128,128,128],t.t)
B.hR=s([B.f2,B.hI,B.fz],t.S)
B.eM=s([1,191,251,255,255,128,128,128,128,128,128],t.t)
B.h0=s([223,165,249,255,213,255,128,128,128,128,128],t.t)
B.ho=s([141,124,248,255,255,128,128,128,128,128,128],t.t)
B.ih=s([B.eM,B.h0,B.ho],t.S)
B.fc=s([1,16,248,255,255,128,128,128,128,128,128],t.t)
B.dX=s([190,36,230,255,236,255,128,128,128,128,128],t.t)
B.dL=s([149,1,255,128,128,128,128,128,128,128,128],t.t)
B.dd=s([B.fc,B.dX,B.dL],t.S)
B.hm=s([1,226,255,128,128,128,128,128,128,128,128],t.t)
B.hA=s([247,192,255,128,128,128,128,128,128,128,128],t.t)
B.iD=s([240,128,255,128,128,128,128,128,128,128,128],t.t)
B.cU=s([B.hm,B.hA,B.iD],t.S)
B.iw=s([1,134,252,255,255,128,128,128,128,128,128],t.t)
B.hb=s([213,62,250,255,255,128,128,128,128,128,128],t.t)
B.j_=s([55,93,255,128,128,128,128,128,128,128,128],t.t)
B.hl=s([B.iw,B.hb,B.j_],t.S)
B.dB=s([B.hx,B.i1,B.hR,B.ih,B.dd,B.cU,B.hl,B.aW],t.o)
B.hd=s([202,24,213,235,186,191,220,160,240,175,255],t.t)
B.dH=s([126,38,182,232,169,184,228,174,255,187,128],t.t)
B.df=s([61,46,138,219,151,178,240,170,255,216,128],t.t)
B.i_=s([B.hd,B.dH,B.df],t.S)
B.fI=s([1,112,230,250,199,191,247,159,255,255,128],t.t)
B.dp=s([166,109,228,252,211,215,255,174,128,128,128],t.t)
B.fZ=s([39,77,162,232,172,180,245,178,255,255,128],t.t)
B.hY=s([B.fI,B.dp,B.fZ],t.S)
B.fL=s([1,52,220,246,198,199,249,220,255,255,128],t.t)
B.e4=s([124,74,191,243,183,193,250,221,255,255,128],t.t)
B.eF=s([24,71,130,219,154,170,243,182,255,255,128],t.t)
B.hX=s([B.fL,B.e4,B.eF],t.S)
B.eD=s([1,182,225,249,219,240,255,224,128,128,128],t.t)
B.iZ=s([149,150,226,252,216,205,255,171,128,128,128],t.t)
B.jh=s([28,108,170,242,183,194,254,223,255,255,128],t.t)
B.iP=s([B.eD,B.iZ,B.jh],t.S)
B.ji=s([1,81,230,252,204,203,255,192,128,128,128],t.t)
B.ib=s([123,102,209,247,188,196,255,233,128,128,128],t.t)
B.iB=s([20,95,153,243,164,173,255,203,128,128,128],t.t)
B.ic=s([B.ji,B.ib,B.iB],t.S)
B.fk=s([1,222,248,255,216,213,128,128,128,128,128],t.t)
B.ha=s([168,175,246,252,235,205,255,255,128,128,128],t.t)
B.eI=s([47,116,215,255,211,212,255,255,128,128,128],t.t)
B.dT=s([B.fk,B.ha,B.eI],t.S)
B.fi=s([1,121,236,253,212,214,255,255,128,128,128],t.t)
B.fM=s([141,84,213,252,201,202,255,219,128,128,128],t.t)
B.hv=s([42,80,160,240,162,185,255,205,128,128,128],t.t)
B.eS=s([B.fi,B.fM,B.hv],t.S)
B.j6=s([244,1,255,128,128,128,128,128,128,128,128],t.t)
B.ct=s([238,1,255,128,128,128,128,128,128,128,128],t.t)
B.hB=s([B.aX,B.j6,B.ct],t.S)
B.cJ=s([B.i_,B.hY,B.hX,B.iP,B.ic,B.dT,B.eS,B.hB],t.o)
B.de=s([B.e_,B.hW,B.dB,B.cJ],t._)
B.dg=s([511,1023,2047,4095],t.t)
B.dr=s([63,207,243,252],t.t)
B.dN=s([8,8,4,2],t.t)
B.cF=s([173,148,140],t.t)
B.cG=s([176,155,140,135],t.t)
B.cD=s([180,157,141,134,130],t.t)
B.cR=s([254,254,243,230,196,177,153,140,133,130,129],t.t)
B.dO=s([B.cF,B.cG,B.cD,B.cR],t.S)
B.e1=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095],t.t)
B.a3=s([0,1,1,2,4,8,1,1,2,4,8,4,8,4],t.t)
B.eb=s([2954,2956,2958,2962,2970,2986,3018,3082,3212,3468,3980,5004],t.t)
B.aY=s([280,256,256,256,40],t.t)
B.aZ=s([62,62,30,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,588,588,588,588,588,588,588,588,1680,1680,20499,22547,24595,26643,1776,1776,1808,1808,-24557,-22509,-20461,-18413,1904,1904,1936,1936,-16365,-14317,782,782,782,782,814,814,814,814,-12269,-10221,10257,10257,12305,12305,14353,14353,16403,18451,1712,1712,1744,1744,28691,30739,-32749,-30701,-28653,-26605,2061,2061,2061,2061,2061,2061,2061,2061,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,750,750,750,750,1616,1616,1648,1648,1424,1424,1456,1456,1488,1488,1520,1520,1840,1840,1872,1872,1968,1968,8209,8209,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,1552,1552,1584,1584,2000,2000,2032,2032,976,976,1008,1008,1040,1040,1072,1072,1296,1296,1328,1328,718,718,718,718,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,4113,4113,6161,6161,848,848,880,880,912,912,944,944,622,622,622,622,654,654,654,654,1104,1104,1136,1136,1168,1168,1200,1200,1232,1232,1264,1264,686,686,686,686,1360,1360,1392,1392,12,12,12,12,12,12,12,12,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390],t.t)
B.ai=s([4,5,6,7,8,9,10,10,11,12,13,14,15,16,17,17,18,19,20,20,21,21,22,22,23,23,24,25,25,26,27,28,29,30,31,32,33,34,35,36,37,37,38,39,40,41,42,43,44,45,46,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,76,77,78,79,80,81,82,83,84,85,86,87,88,89,91,93,95,96,98,100,101,102,104,106,108,110,112,114,116,118,122,124,126,128,130,132,134,136,138,140,143,145,148,151,154,157],t.t)
B.en=s([24,7,23,25,40,6,39,41,22,26,38,42,56,5,55,57,21,27,54,58,37,43,72,4,71,73,20,28,53,59,70,74,36,44,88,69,75,52,60,3,87,89,19,29,86,90,35,45,68,76,85,91,51,61,104,2,103,105,18,30,102,106,34,46,84,92,67,77,101,107,50,62,120,1,119,121,83,93,17,31,100,108,66,78,118,122,33,47,117,123,49,63,99,109,82,94,0,116,124,65,79,16,32,98,110,48,115,125,81,95,64,114,126,97,111,80,113,127,96,112],t.t)
B.aj=s([4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,119,122,125,128,131,134,137,140,143,146,149,152,155,158,161,164,167,170,173,177,181,185,189,193,197,201,205,209,213,217,221,225,229,234,239,245,249,254,259,264,269,274,279,284],t.t)
B.c5=new A.bT(0,"uint")
B.ez=s([B.c5,B.aE,B.aF],A.U("o<bT>"))
B.eA=s([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],t.t)
B.eX=s([254,253,251,247,239,223,191,127],t.t)
B.b_=s([A.ur(),A.uj(),A.uy(),A.uw(),A.ut(),A.us(),A.uu()],t.A)
B.ar=new A.a1(0,"whiteIsZero")
B.jM=new A.a1(1,"blackIsZero")
B.jT=new A.a1(2,"rgb")
B.at=new A.a1(3,"palette")
B.jU=new A.a1(4,"transparencyMask")
B.bA=new A.a1(5,"cmyk")
B.jV=new A.a1(6,"yCbCr")
B.jW=new A.a1(7,"reserved7")
B.jX=new A.a1(8,"cieLab")
B.jY=new A.a1(9,"iccLab")
B.jN=new A.a1(10,"ituLab")
B.jO=new A.a1(11,"logL")
B.jP=new A.a1(12,"logLuv")
B.jQ=new A.a1(13,"colorFilterArray")
B.jR=new A.a1(14,"linearRaw")
B.jS=new A.a1(15,"depth")
B.as=new A.a1(16,"unknown")
B.f4=s([B.ar,B.jM,B.jT,B.at,B.jU,B.bA,B.jV,B.jW,B.jX,B.jY,B.jN,B.jO,B.jP,B.jQ,B.jR,B.jS,B.as],A.U("o<a1>"))
B.bl=new A.eq(0,"source")
B.bm=new A.eq(1,"over")
B.fe=s([B.bl,B.bm],A.U("o<eq>"))
B.jE=new A.cm(0,"invalid")
B.by=new A.cm(1,"uint")
B.f=new A.cm(2,"int")
B.Y=new A.cm(3,"float")
B.fh=s([B.jE,B.by,B.f,B.Y],A.U("o<cm>"))
B.fj=s([17,18,0,1,2,3,4,5,16,6,7,8,9,10,11,12,13,14,15],t.t)
B.b2=s([-0.0,1,-1,2,-2,3,4,6,-3,5,-4,-5,-6,7,-7,8,-8,-9],t.t)
B.b3=s([B.d,B.aJ,B.j,B.h,B.n,B.q,B.aO,B.N,B.aP,B.aQ,B.aK,B.aL,B.aM,B.aN],A.U("o<a8>"))
B.fy=s([0,1,4,8,5,2,3,6,9,12,13,10,7,11,14,15],t.t)
B.c6=new A.aX(1,"rle")
B.c7=new A.aX(2,"zips")
B.c8=new A.aX(3,"zip")
B.c9=new A.aX(4,"piz")
B.ca=new A.aX(5,"pxr24")
B.cb=new A.aX(6,"b44")
B.cc=new A.aX(7,"b44a")
B.fB=s([B.aG,B.c6,B.c7,B.c8,B.c9,B.ca,B.cb,B.cc],A.U("o<aX>"))
B.hs=s([231,120,48,89,115,113,120,152,112],t.t)
B.cK=s([152,179,64,126,170,118,46,70,95],t.t)
B.fx=s([175,69,143,80,85,82,72,155,103],t.t)
B.d6=s([56,58,10,171,218,189,17,13,152],t.t)
B.fY=s([114,26,17,163,44,195,21,10,173],t.t)
B.h9=s([121,24,80,195,26,62,44,64,85],t.t)
B.fU=s([144,71,10,38,171,213,144,34,26],t.t)
B.im=s([170,46,55,19,136,160,33,206,71],t.t)
B.eo=s([63,20,8,114,114,208,12,9,226],t.t)
B.f1=s([81,40,11,96,182,84,29,16,36],t.t)
B.cx=s([B.hs,B.cK,B.fx,B.d6,B.fY,B.h9,B.fU,B.im,B.eo,B.f1],t.S)
B.dW=s([134,183,89,137,98,101,106,165,148],t.t)
B.i6=s([72,187,100,130,157,111,32,75,80],t.t)
B.hg=s([66,102,167,99,74,62,40,234,128],t.t)
B.cT=s([41,53,9,178,241,141,26,8,107],t.t)
B.eY=s([74,43,26,146,73,166,49,23,157],t.t)
B.ew=s([65,38,105,160,51,52,31,115,128],t.t)
B.eB=s([104,79,12,27,217,255,87,17,7],t.t)
B.fv=s([87,68,71,44,114,51,15,186,23],t.t)
B.hZ=s([47,41,14,110,182,183,21,17,194],t.t)
B.hD=s([66,45,25,102,197,189,23,18,22],t.t)
B.iC=s([B.dW,B.i6,B.hg,B.cT,B.eY,B.ew,B.eB,B.fv,B.hZ,B.hD],t.S)
B.hr=s([88,88,147,150,42,46,45,196,205],t.t)
B.h_=s([43,97,183,117,85,38,35,179,61],t.t)
B.eH=s([39,53,200,87,26,21,43,232,171],t.t)
B.fq=s([56,34,51,104,114,102,29,93,77],t.t)
B.fQ=s([39,28,85,171,58,165,90,98,64],t.t)
B.es=s([34,22,116,206,23,34,43,166,73],t.t)
B.cy=s([107,54,32,26,51,1,81,43,31],t.t)
B.iq=s([68,25,106,22,64,171,36,225,114],t.t)
B.dV=s([34,19,21,102,132,188,16,76,124],t.t)
B.iM=s([62,18,78,95,85,57,50,48,51],t.t)
B.e8=s([B.hr,B.h_,B.eH,B.fq,B.fQ,B.es,B.cy,B.iq,B.dV,B.iM],t.S)
B.fN=s([193,101,35,159,215,111,89,46,111],t.t)
B.dA=s([60,148,31,172,219,228,21,18,111],t.t)
B.db=s([112,113,77,85,179,255,38,120,114],t.t)
B.iJ=s([40,42,1,196,245,209,10,25,109],t.t)
B.ff=s([88,43,29,140,166,213,37,43,154],t.t)
B.eu=s([61,63,30,155,67,45,68,1,209],t.t)
B.eN=s([100,80,8,43,154,1,51,26,71],t.t)
B.cW=s([142,78,78,16,255,128,34,197,171],t.t)
B.fH=s([41,40,5,102,211,183,4,1,221],t.t)
B.ef=s([51,50,17,168,209,192,23,25,82],t.t)
B.e7=s([B.fN,B.dA,B.db,B.iJ,B.ff,B.eu,B.eN,B.cW,B.fH,B.ef],t.S)
B.eE=s([138,31,36,171,27,166,38,44,229],t.t)
B.e5=s([67,87,58,169,82,115,26,59,179],t.t)
B.hN=s([63,59,90,180,59,166,93,73,154],t.t)
B.iz=s([40,40,21,116,143,209,34,39,175],t.t)
B.d0=s([47,15,16,183,34,223,49,45,183],t.t)
B.dG=s([46,17,33,183,6,98,15,32,183],t.t)
B.jj=s([57,46,22,24,128,1,54,17,37],t.t)
B.eP=s([65,32,73,115,28,128,23,128,205],t.t)
B.hf=s([40,3,9,115,51,192,18,6,223],t.t)
B.eV=s([87,37,9,115,59,77,64,21,47],t.t)
B.fG=s([B.eE,B.e5,B.hN,B.iz,B.d0,B.dG,B.jj,B.eP,B.hf,B.eV],t.S)
B.j5=s([104,55,44,218,9,54,53,130,226],t.t)
B.dn=s([64,90,70,205,40,41,23,26,57],t.t)
B.hM=s([54,57,112,184,5,41,38,166,213],t.t)
B.et=s([30,34,26,133,152,116,10,32,134],t.t)
B.hy=s([39,19,53,221,26,114,32,73,255],t.t)
B.ed=s([31,9,65,234,2,15,1,118,73],t.t)
B.fE=s([75,32,12,51,192,255,160,43,51],t.t)
B.ev=s([88,31,35,67,102,85,55,186,85],t.t)
B.f7=s([56,21,23,111,59,205,45,37,192],t.t)
B.f8=s([55,38,70,124,73,102,1,34,98],t.t)
B.j9=s([B.j5,B.dn,B.hM,B.et,B.hy,B.ed,B.fE,B.ev,B.f7,B.f8],t.S)
B.f6=s([125,98,42,88,104,85,117,175,82],t.t)
B.ey=s([95,84,53,89,128,100,113,101,45],t.t)
B.h4=s([75,79,123,47,51,128,81,171,1],t.t)
B.dl=s([57,17,5,71,102,57,53,41,49],t.t)
B.hH=s([38,33,13,121,57,73,26,1,85],t.t)
B.iY=s([41,10,67,138,77,110,90,47,114],t.t)
B.fC=s([115,21,2,10,102,255,166,23,6],t.t)
B.dY=s([101,29,16,10,85,128,101,196,26],t.t)
B.eL=s([57,18,10,102,102,213,34,20,43],t.t)
B.fd=s([117,20,15,36,163,128,68,1,26],t.t)
B.fu=s([B.f6,B.ey,B.h4,B.dl,B.hH,B.iY,B.fC,B.dY,B.eL,B.fd],t.S)
B.eT=s([102,61,71,37,34,53,31,243,192],t.t)
B.iU=s([69,60,71,38,73,119,28,222,37],t.t)
B.eW=s([68,45,128,34,1,47,11,245,171],t.t)
B.cC=s([62,17,19,70,146,85,55,62,70],t.t)
B.jf=s([37,43,37,154,100,163,85,160,1],t.t)
B.iQ=s([63,9,92,136,28,64,32,201,85],t.t)
B.i9=s([75,15,9,9,64,255,184,119,16],t.t)
B.e3=s([86,6,28,5,64,255,25,248,1],t.t)
B.hC=s([56,8,17,132,137,255,55,116,128],t.t)
B.dh=s([58,15,20,82,135,57,26,121,40],t.t)
B.fT=s([B.eT,B.iU,B.eW,B.cC,B.jf,B.iQ,B.i9,B.e3,B.hC,B.dh],t.S)
B.h7=s([164,50,31,137,154,133,25,35,218],t.t)
B.e2=s([51,103,44,131,131,123,31,6,158],t.t)
B.iO=s([86,40,64,135,148,224,45,183,128],t.t)
B.fw=s([22,26,17,131,240,154,14,1,209],t.t)
B.dD=s([45,16,21,91,64,222,7,1,197],t.t)
B.iA=s([56,21,39,155,60,138,23,102,213],t.t)
B.j8=s([83,12,13,54,192,255,68,47,28],t.t)
B.hh=s([85,26,85,85,128,128,32,146,171],t.t)
B.fs=s([18,11,7,63,144,171,4,4,246],t.t)
B.e9=s([35,27,10,146,174,171,12,26,128],t.t)
B.fl=s([B.h7,B.e2,B.iO,B.fw,B.dD,B.iA,B.j8,B.hh,B.fs,B.e9],t.S)
B.hV=s([190,80,35,99,180,80,126,54,45],t.t)
B.il=s([85,126,47,87,176,51,41,20,32],t.t)
B.hJ=s([101,75,128,139,118,146,116,128,85],t.t)
B.i5=s([56,41,15,176,236,85,37,9,62],t.t)
B.di=s([71,30,17,119,118,255,17,18,138],t.t)
B.fS=s([101,38,60,138,55,70,43,26,142],t.t)
B.fo=s([146,36,19,30,171,255,97,27,20],t.t)
B.hq=s([138,45,61,62,219,1,81,188,64],t.t)
B.iK=s([32,41,20,117,151,142,20,21,163],t.t)
B.io=s([112,19,12,61,195,128,48,4,24],t.t)
B.hQ=s([B.hV,B.il,B.hJ,B.i5,B.di,B.fS,B.fo,B.hq,B.iK,B.io],t.S)
B.fF=s([B.cx,B.iC,B.e8,B.e7,B.fG,B.j9,B.fu,B.fT,B.fl,B.hQ],t.o)
B.a8=new A.am(0,"none")
B.F=new A.am(1,"palette")
B.bx=new A.am(2,"rgb")
B.jy=new A.am(3,"gray")
B.jz=new A.am(4,"reserved4")
B.jA=new A.am(5,"reserved5")
B.jB=new A.am(6,"reserved6")
B.jC=new A.am(7,"reserved7")
B.jD=new A.am(8,"reserved8")
B.G=new A.am(9,"paletteRle")
B.bw=new A.am(10,"rgbRle")
B.jx=new A.am(11,"grayRle")
B.fK=s([B.a8,B.F,B.bx,B.jy,B.jz,B.jA,B.jB,B.jC,B.jD,B.G,B.bw,B.jx],A.U("o<am>"))
B.h1=s([0,1,1,1,0],t.t)
B.h3=s([A.ub(),A.ui(),A.uk(),A.ud(),A.ug(),A.um(),A.uf(),A.ul(),A.uc(),A.ue()],t.A)
B.ah=s([8,0,8,0],t.t)
B.dm=s([5,3,5,3],t.t)
B.cZ=s([3,5,3,5],t.t)
B.aS=s([0,8,0,8],t.t)
B.aV=s([4,4,4,4],t.t)
B.da=s([4,4,0,0],t.t)
B.b4=s([B.ah,B.dm,B.cZ,B.aS,B.ah,B.aV,B.da,B.aS],t.S)
B.b5=s([80,88,23,71,30,30,62,62,4,4,4,4,4,4,4,4,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41],t.t)
B.a4=s([0,1,4,5,16,17,20,21,64,65,68,69,80,81,84,85,256,257,260,261,272,273,276,277,320,321,324,325,336,337,340,341,1024,1025,1028,1029,1040,1041,1044,1045,1088,1089,1092,1093,1104,1105,1108,1109,1280,1281,1284,1285,1296,1297,1300,1301,1344,1345,1348,1349,1360,1361,1364,1365,4096,4097,4100,4101,4112,4113,4116,4117,4160,4161,4164,4165,4176,4177,4180,4181,4352,4353,4356,4357,4368,4369,4372,4373,4416,4417,4420,4421,4432,4433,4436,4437,5120,5121,5124,5125,5136,5137,5140,5141,5184,5185,5188,5189,5200,5201,5204,5205,5376,5377,5380,5381,5392,5393,5396,5397,5440,5441,5444,5445,5456,5457,5460,5461,16384,16385,16388,16389,16400,16401,16404,16405,16448,16449,16452,16453,16464,16465,16468,16469,16640,16641,16644,16645,16656,16657,16660,16661,16704,16705,16708,16709,16720,16721,16724,16725,17408,17409,17412,17413,17424,17425,17428,17429,17472,17473,17476,17477,17488,17489,17492,17493,17664,17665,17668,17669,17680,17681,17684,17685,17728,17729,17732,17733,17744,17745,17748,17749,20480,20481,20484,20485,20496,20497,20500,20501,20544,20545,20548,20549,20560,20561,20564,20565,20736,20737,20740,20741,20752,20753,20756,20757,20800,20801,20804,20805,20816,20817,20820,20821,21504,21505,21508,21509,21520,21521,21524,21525,21568,21569,21572,21573,21584,21585,21588,21589,21760,21761,21764,21765,21776,21777,21780,21781,21824,21825,21828,21829,21840,21841,21844,21845],t.t)
B.b6=s([127,127,191,127,159,191,223,127,143,159,175,191,207,223,239,127,135,143,151,159,167,175,183,191,199,207,215,223,231,239,247,127,131,135,139,143,147,151,155,159,163,167,171,175,179,183,187,191,195,199,203,207,211,215,219,223,227,231,235,239,243,247,251,127,129,131,133,135,137,139,141,143,145,147,149,151,153,155,157,159,161,163,165,167,169,171,173,175,177,179,181,183,185,187,189,191,193,195,197,199,201,203,205,207,209,211,213,215,217,219,221,223,225,227,229,231,233,235,237,239,241,243,245,247,249,251,253,127],t.t)
B.b7=s([7,6,6,5,5,5,5,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],t.t)
B.a5=s([28679,28679,31752,-32759,-31735,-30711,-29687,-28663,29703,29703,30727,30727,-27639,-26615,-25591,-24567],t.t)
B.b8=s([6430,6400,6400,6400,3225,3225,3225,3225,944,944,944,944,976,976,976,976,1456,1456,1456,1456,1488,1488,1488,1488,718,718,718,718,718,718,718,718,750,750,750,750,750,750,750,750,1520,1520,1520,1520,1552,1552,1552,1552,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,654,654,654,654,654,654,654,654,1072,1072,1072,1072,1104,1104,1104,1104,1136,1136,1136,1136,1168,1168,1168,1168,1200,1200,1200,1200,1232,1232,1232,1232,622,622,622,622,622,622,622,622,1008,1008,1008,1008,1040,1040,1040,1040,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,1712,1712,1712,1712,1744,1744,1744,1744,846,846,846,846,846,846,846,846,1264,1264,1264,1264,1296,1296,1296,1296,1328,1328,1328,1328,1360,1360,1360,1360,1392,1392,1392,1392,1424,1424,1424,1424,686,686,686,686,686,686,686,686,910,910,910,910,910,910,910,910,1968,1968,1968,1968,2000,2000,2000,2000,2032,2032,2032,2032,16,16,16,16,10257,10257,10257,10257,12305,12305,12305,12305,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,878,878,878,878,878,878,878,878,1904,1904,1904,1904,1936,1936,1936,1936,-18413,-18413,-16365,-16365,-14317,-14317,-10221,-10221,590,590,590,590,590,590,590,590,782,782,782,782,782,782,782,782,1584,1584,1584,1584,1616,1616,1616,1616,1648,1648,1648,1648,1680,1680,1680,1680,814,814,814,814,814,814,814,814,1776,1776,1776,1776,1808,1808,1808,1808,1840,1840,1840,1840,1872,1872,1872,1872,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,14353,14353,14353,14353,16401,16401,16401,16401,22547,22547,24595,24595,20497,20497,20497,20497,18449,18449,18449,18449,26643,26643,28691,28691,30739,30739,-32749,-32749,-30701,-30701,-28653,-28653,-26605,-26605,-24557,-24557,-22509,-22509,-20461,-20461,8207,8207,8207,8207,8207,8207,8207,8207,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232],t.t)
B.hG=s([],A.U("o<0&>"))
B.hK=s([5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],t.t)
B.b9=s([0,1,2,3,6,4,5,6,6,6,6,6,6,6,6,7,0],t.t)
B.jn=new A.bB(0,"none")
B.jo=new A.bB(1,"sub")
B.jp=new A.bB(2,"up")
B.jq=new A.bB(3,"average")
B.jr=new A.bB(4,"paeth")
B.ba=s([B.jn,B.jo,B.jp,B.jq,B.jr],A.U("o<bB>"))
B.v=s([0,1996959894,3993919788,2567524794,124634137,1886057615,3915621685,2657392035,249268274,2044508324,3772115230,2547177864,162941995,2125561021,3887607047,2428444049,498536548,1789927666,4089016648,2227061214,450548861,1843258603,4107580753,2211677639,325883990,1684777152,4251122042,2321926636,335633487,1661365465,4195302755,2366115317,997073096,1281953886,3579855332,2724688242,1006888145,1258607687,3524101629,2768942443,901097722,1119000684,3686517206,2898065728,853044451,1172266101,3705015759,2882616665,651767980,1373503546,3369554304,3218104598,565507253,1454621731,3485111705,3099436303,671266974,1594198024,3322730930,2970347812,795835527,1483230225,3244367275,3060149565,1994146192,31158534,2563907772,4023717930,1907459465,112637215,2680153253,3904427059,2013776290,251722036,2517215374,3775830040,2137656763,141376813,2439277719,3865271297,1802195444,476864866,2238001368,4066508878,1812370925,453092731,2181625025,4111451223,1706088902,314042704,2344532202,4240017532,1658658271,366619977,2362670323,4224994405,1303535960,984961486,2747007092,3569037538,1256170817,1037604311,2765210733,3554079995,1131014506,879679996,2909243462,3663771856,1141124467,855842277,2852801631,3708648649,1342533948,654459306,3188396048,3373015174,1466479909,544179635,3110523913,3462522015,1591671054,702138776,2966460450,3352799412,1504918807,783551873,3082640443,3233442989,3988292384,2596254646,62317068,1957810842,3939845945,2647816111,81470997,1943803523,3814918930,2489596804,225274430,2053790376,3826175755,2466906013,167816743,2097651377,4027552580,2265490386,503444072,1762050814,4150417245,2154129355,426522225,1852507879,4275313526,2312317920,282753626,1742555852,4189708143,2394877945,397917763,1622183637,3604390888,2714866558,953729732,1340076626,3518719985,2797360999,1068828381,1219638859,3624741850,2936675148,906185462,1090812512,3747672003,2825379669,829329135,1181335161,3412177804,3160834842,628085408,1382605366,3423369109,3138078467,570562233,1426400815,3317316542,2998733608,733239954,1555261956,3268935591,3050360625,752459403,1541320221,2607071920,3965973030,1969922972,40735498,2617837225,3943577151,1913087877,83908371,2512341634,3803740692,2075208622,213261112,2463272603,3855990285,2094854071,198958881,2262029012,4057260610,1759359992,534414190,2176718541,4139329115,1873836001,414664567,2282248934,4279200368,1711684554,285281116,2405801727,4167216745,1634467795,376229701,2685067896,3608007406,1308918612,956543938,2808555105,3495958263,1231636301,1047427035,2932959818,3654703836,1088359270,936918e3,2847714899,3736837829,1202900863,817233897,3183342108,3401237130,1404277552,615818150,3134207493,3453421203,1423857449,601450431,3009837614,3294710456,1567103746,711928724,3020668471,3272380065,1510334235,755167117],t.t)
B.U=s([0,1,3,7,15,31,63,127,255],t.t)
B.ia=s([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],t.t)
B.r=s([255,255,255,255,255,255,255,255,255,255,255],t.t)
B.P=s([B.r,B.r,B.r],t.S)
B.fp=s([176,246,255,255,255,255,255,255,255,255,255],t.t)
B.j0=s([223,241,252,255,255,255,255,255,255,255,255],t.t)
B.dS=s([249,253,253,255,255,255,255,255,255,255,255],t.t)
B.fD=s([B.fp,B.j0,B.dS],t.S)
B.f3=s([255,244,252,255,255,255,255,255,255,255,255],t.t)
B.eR=s([234,254,254,255,255,255,255,255,255,255,255],t.t)
B.be=s([253,255,255,255,255,255,255,255,255,255,255],t.t)
B.e0=s([B.f3,B.eR,B.be],t.S)
B.iN=s([255,246,254,255,255,255,255,255,255,255,255],t.t)
B.hz=s([239,253,254,255,255,255,255,255,255,255,255],t.t)
B.bb=s([254,255,254,255,255,255,255,255,255,255,255],t.t)
B.i7=s([B.iN,B.hz,B.bb],t.S)
B.b0=s([255,248,254,255,255,255,255,255,255,255,255],t.t)
B.ej=s([251,255,254,255,255,255,255,255,255,255,255],t.t)
B.h8=s([B.b0,B.ej,B.r],t.S)
B.ag=s([255,253,254,255,255,255,255,255,255,255,255],t.t)
B.h6=s([251,254,254,255,255,255,255,255,255,255,255],t.t)
B.er=s([B.ag,B.h6,B.bb],t.S)
B.d4=s([255,254,253,255,254,255,255,255,255,255,255],t.t)
B.f_=s([250,255,254,255,254,255,255,255,255,255,255],t.t)
B.a6=s([254,255,255,255,255,255,255,255,255,255,255],t.t)
B.fg=s([B.d4,B.f_,B.a6],t.S)
B.eK=s([B.P,B.fD,B.e0,B.i7,B.h8,B.er,B.fg,B.P],t.o)
B.cI=s([217,255,255,255,255,255,255,255,255,255,255],t.t)
B.fm=s([225,252,241,253,255,255,254,255,255,255,255],t.t)
B.hL=s([234,250,241,250,253,255,253,254,255,255,255],t.t)
B.ip=s([B.cI,B.fm,B.hL],t.S)
B.an=s([255,254,255,255,255,255,255,255,255,255,255],t.t)
B.dU=s([223,254,254,255,255,255,255,255,255,255,255],t.t)
B.dE=s([238,253,254,254,255,255,255,255,255,255,255],t.t)
B.hw=s([B.an,B.dU,B.dE],t.S)
B.eU=s([249,254,255,255,255,255,255,255,255,255,255],t.t)
B.iL=s([B.b0,B.eU,B.r],t.S)
B.ir=s([255,253,255,255,255,255,255,255,255,255,255],t.t)
B.h5=s([247,254,255,255,255,255,255,255,255,255,255],t.t)
B.fW=s([B.ir,B.h5,B.r],t.S)
B.dz=s([252,255,255,255,255,255,255,255,255,255,255],t.t)
B.cV=s([B.ag,B.dz,B.r],t.S)
B.bf=s([255,254,254,255,255,255,255,255,255,255,255],t.t)
B.dC=s([B.bf,B.be,B.r],t.S)
B.hu=s([255,254,253,255,255,255,255,255,255,255,255],t.t)
B.b1=s([250,255,255,255,255,255,255,255,255,255,255],t.t)
B.dy=s([B.hu,B.b1,B.a6],t.S)
B.d7=s([B.ip,B.hw,B.iL,B.fW,B.cV,B.dC,B.dy,B.P],t.o)
B.hS=s([186,251,250,255,255,255,255,255,255,255,255],t.t)
B.eg=s([234,251,244,254,255,255,255,255,255,255,255],t.t)
B.i8=s([251,251,243,253,254,255,254,255,255,255,255],t.t)
B.ep=s([B.hS,B.eg,B.i8],t.S)
B.el=s([236,253,254,255,255,255,255,255,255,255,255],t.t)
B.ht=s([251,253,253,254,254,255,255,255,255,255,255],t.t)
B.f9=s([B.ag,B.el,B.ht],t.S)
B.hU=s([254,254,254,255,255,255,255,255,255,255,255],t.t)
B.eh=s([B.bf,B.hU,B.r],t.S)
B.id=s([254,254,255,255,255,255,255,255,255,255,255],t.t)
B.ek=s([B.an,B.id,B.a6],t.S)
B.bg=s([B.r,B.a6,B.r],t.S)
B.d5=s([B.ep,B.f9,B.eh,B.ek,B.bg,B.P,B.P,B.P],t.o)
B.eZ=s([248,255,255,255,255,255,255,255,255,255,255],t.t)
B.ex=s([250,254,252,254,255,255,255,255,255,255,255],t.t)
B.ee=s([248,254,249,253,255,255,255,255,255,255,255],t.t)
B.fb=s([B.eZ,B.ex,B.ee],t.S)
B.d2=s([255,253,253,255,255,255,255,255,255,255,255],t.t)
B.iv=s([246,253,253,255,255,255,255,255,255,255,255],t.t)
B.eq=s([252,254,251,254,254,255,255,255,255,255,255],t.t)
B.iu=s([B.d2,B.iv,B.eq],t.S)
B.je=s([255,254,252,255,255,255,255,255,255,255,255],t.t)
B.ec=s([248,254,253,255,255,255,255,255,255,255,255],t.t)
B.dx=s([253,255,254,254,255,255,255,255,255,255,255],t.t)
B.he=s([B.je,B.ec,B.dx],t.S)
B.j7=s([255,251,254,255,255,255,255,255,255,255,255],t.t)
B.fO=s([245,251,254,255,255,255,255,255,255,255,255],t.t)
B.fR=s([253,253,254,255,255,255,255,255,255,255,255],t.t)
B.dP=s([B.j7,B.fO,B.fR],t.S)
B.dQ=s([255,251,253,255,255,255,255,255,255,255,255],t.t)
B.f5=s([252,253,254,255,255,255,255,255,255,255,255],t.t)
B.i0=s([B.dQ,B.f5,B.an],t.S)
B.dt=s([255,252,255,255,255,255,255,255,255,255,255],t.t)
B.j4=s([249,255,254,255,255,255,255,255,255,255,255],t.t)
B.eC=s([255,255,254,255,255,255,255,255,255,255,255],t.t)
B.cB=s([B.dt,B.j4,B.eC],t.S)
B.jg=s([255,255,253,255,255,255,255,255,255,255,255],t.t)
B.ei=s([B.jg,B.b1,B.r],t.S)
B.dw=s([B.fb,B.iu,B.he,B.dP,B.i0,B.cB,B.ei,B.bg],t.o)
B.ij=s([B.eK,B.d7,B.d5,B.dw],t._)
B.bF=new A.a7(1,"rle8")
B.bK=new A.a7(2,"rle4")
B.bL=new A.a7(4,"jpeg")
B.bM=new A.a7(5,"png")
B.bN=new A.a7(7,"reserved7")
B.bO=new A.a7(8,"reserved8")
B.bP=new A.a7(9,"reserved9")
B.bG=new A.a7(10,"reserved10")
B.bH=new A.a7(11,"cmyk")
B.bI=new A.a7(12,"cmykRle8")
B.bJ=new A.a7(13,"cmykRle4")
B.bc=s([B.ax,B.bF,B.bK,B.ab,B.bL,B.bM,B.ac,B.bN,B.bO,B.bP,B.bG,B.bH,B.bI,B.bJ],A.U("o<a7>"))
B.al=s([0,128,192,224,240,248,252,254,255],t.t)
B.bd=s([137,80,78,71,13,10,26,10],t.t)
B.am=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535,131071,262143,524287,1048575,2097151,4194303,8388607,16777215,33554431,67108863,134217727,268435455,536870911,1073741823,2147483647,4294967295],t.t)
B.it=s([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],t.t)
B.iy=s([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],t.t)
B.bC=new A.co(0,"predictor")
B.kc=new A.co(1,"crossColor")
B.kd=new A.co(2,"subtractGreen")
B.bD=new A.co(3,"colorIndexing")
B.iG=s([B.bC,B.kc,B.kd,B.bD],A.U("o<co>"))
B.t=s([0,17,34,51,68,85,102,119,136,153,170,187,204,221,238,255],t.t)
B.iR=s([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
B.iT=s([A.un(),A.uh(),A.ux(),A.uv(),A.up(),A.uo(),A.uq()],t.A)
B.bh=s([0,4,8,12,128,132,136,140,256,260,264,268,384,388,392,396],t.t)
B.iV=s([null,A.uN(),A.uO(),A.uM()],A.U("o<~(h,h,h,h,h,b2)?>"))
B.a7=s([0,36,72,109,145,182,218,255],t.t)
B.w=s([0,8,16,24,32,41,49,57,65,74,82,90,98,106,115,123,131,139,148,156,164,172,180,189,197,205,213,222,230,238,246,255],t.t)
B.j2=s([8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8],t.t)
B.js=new A.b_(0,"bitmap")
B.bs=new A.b_(1,"grayscale")
B.jt=new A.b_(2,"indexed")
B.bt=new A.b_(3,"rgb")
B.bu=new A.b_(4,"cmyk")
B.ju=new A.b_(5,"multiChannel")
B.jv=new A.b_(6,"duoTone")
B.bv=new A.b_(7,"lab")
B.j3=s([B.js,B.bs,B.jt,B.bt,B.bu,B.ju,B.jv,B.bv],A.U("o<b_>"))
B.ja=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,0,0],t.t)
B.cQ=s([2,6,2,6],t.t)
B.du=s([6,2,6,2],t.t)
B.cO=s([2,2,6,6],t.t)
B.cH=s([1,3,3,9],t.t)
B.d8=s([4,0,12,0],t.t)
B.cX=s([3,1,9,3],t.t)
B.dM=s([8,8,0,0],t.t)
B.d9=s([4,12,0,0],t.t)
B.cE=s([16,0,0,0],t.t)
B.cA=s([12,4,0,0],t.t)
B.dv=s([6,6,2,2],t.t)
B.d_=s([3,9,1,3],t.t)
B.cz=s([12,0,4,0],t.t)
B.dR=s([9,3,3,1],t.t)
B.o=s([B.aV,B.cQ,B.ah,B.du,B.cO,B.cH,B.d8,B.cX,B.dM,B.d9,B.cE,B.cA,B.dv,B.d_,B.cz,B.dR],t.S)
B.Q=s([0,-128,64,-64,32,-96,96,-32,16,-112,80,-48,48,-80,112,-16,8,-120,72,-56,40,-88,104,-24,24,-104,88,-40,56,-72,120,-8,4,-124,68,-60,36,-92,100,-28,20,-108,84,-44,52,-76,116,-12,12,-116,76,-52,44,-84,108,-20,28,-100,92,-36,60,-68,124,-4,2,-126,66,-62,34,-94,98,-30,18,-110,82,-46,50,-78,114,-14,10,-118,74,-54,42,-86,106,-22,26,-102,90,-38,58,-70,122,-6,6,-122,70,-58,38,-90,102,-26,22,-106,86,-42,54,-74,118,-10,14,-114,78,-50,46,-82,110,-18,30,-98,94,-34,62,-66,126,-2,1,-127,65,-63,33,-95,97,-31,17,-111,81,-47,49,-79,113,-15,9,-119,73,-55,41,-87,105,-23,25,-103,89,-39,57,-71,121,-7,5,-123,69,-59,37,-91,101,-27,21,-107,85,-43,53,-75,117,-11,13,-115,77,-51,45,-83,109,-19,29,-99,93,-35,61,-67,125,-3,3,-125,67,-61,35,-93,99,-29,19,-109,83,-45,51,-77,115,-13,11,-117,75,-53,43,-85,107,-21,27,-101,91,-37,59,-69,123,-5,7,-121,71,-57,39,-89,103,-25,23,-105,87,-41,55,-73,119,-9,15,-113,79,-49,47,-81,111,-17,31,-97,95,-33,63,-65,127,-1],t.t)
B.bi=new A.bU([34665,"exif",40965,"interop",34853,"gps"],A.U("bU<h,a4>"))
B.jl={}
B.jk=new A.dH(B.jl,[],A.U("dH<0&,0&>"))
B.bj=new A.bU([B.u,1,B.x,3,B.y,15,B.e,255,B.m,65535,B.J,4294967295,B.K,127,B.L,32767,B.M,2147483647,B.z,1,B.C,1,B.I,1],A.U("bU<ae,h>"))
B.X=new A.bC(0,"invalid")
B.bp=new A.bC(1,"pbm")
B.bq=new A.bC(2,"pgm2")
B.ao=new A.bC(3,"pgm5")
B.br=new A.bC(4,"ppm3")
B.ap=new A.bC(5,"ppm6")
B.jw=new A.dP([B.z,B.C,B.I],A.U("dP<ae>"))
B.aq=new A.aN(0,"bilevel")
B.jF=new A.aN(1,"gray4bit")
B.jG=new A.aN(2,"gray")
B.jH=new A.aN(3,"grayAlpha")
B.jI=new A.aN(4,"palette")
B.bz=new A.aN(5,"rgb")
B.jJ=new A.aN(6,"rgba")
B.jK=new A.aN(7,"yCbCrSub")
B.Z=new A.aN(8,"generic")
B.jL=new A.aN(9,"invalid")
B.jZ=A.aS("fd")
B.k_=A.aS("lz")
B.k0=A.aS("iw")
B.k1=A.aS("ix")
B.k2=A.aS("cZ")
B.k3=A.aS("iW")
B.k4=A.aS("iX")
B.bB=A.aS("T")
B.k5=A.aS("n")
B.k6=A.aS("hv")
B.k7=A.aS("bo")
B.k8=A.aS("k6")
B.k9=A.aS("b2")
B.ka=new A.hz(!1)
B.kb=new A.hz(!0)
B.a_=new A.dj(0,"undefined")
B.av=new A.dj(1,"lossy")
B.a9=new A.dj(2,"lossless")
B.ke=new A.dj(3,"animated")
B.aw=new A.dr(0,"header")
B.kf=new A.dr(1,"blocks")
B.kg=new A.dr(2,"trailer")
B.bE=new A.dr(3,"done")
B.H=new A.eX("")})();(function staticFields(){$.kQ=null
$.ct=A.m([],A.U("o<n>"))
$.ny=null
$.mW=null
$.mV=null
$.ou=null
$.ok=null
$.oC=null
$.le=null
$.lm=null
$.mx=null
$.dt=null
$.f1=null
$.f2=null
$.mn=!1
$.H=B.p
$.oj=null
$.ml=null
$.nL=!1
$.r0=A.m([A.mB(),A.uz(),A.uE(),A.uF(),A.uG(),A.uH(),A.uI(),A.uJ(),A.uK(),A.uL(),A.uA(),A.uB(),A.uC(),A.uD(),A.mB(),A.mB()],A.U("o<h(h,bo,h)>"))
$.F=null
$.n3=A.rc()
$.pI=A.m([A.tY(),A.tZ()],A.U("o<ax(n,af)>"))})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal,r=hunkHelpers.lazy
s($,"uQ","oI",()=>A.lg("_$dart_dartClosure"))
s($,"uP","mC",()=>A.lg("_$dart_dartClosure_dartJSInterop"))
s($,"vy","p3",()=>A.m([new J.fU()],A.U("o<eu>")))
s($,"uZ","oM",()=>A.bn(A.k5({
toString:function(){return"$receiver$"}})))
s($,"v_","oN",()=>A.bn(A.k5({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"v0","oO",()=>A.bn(A.k5(null)))
s($,"v1","oP",()=>A.bn(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"v4","oS",()=>A.bn(A.k5(void 0)))
s($,"v5","oT",()=>A.bn(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"v3","oR",()=>A.bn(A.nH(null)))
s($,"v2","oQ",()=>A.bn(function(){try{null.$method$}catch(q){return q.message}}()))
s($,"v7","oV",()=>A.bn(A.nH(void 0)))
s($,"v6","oU",()=>A.bn(function(){try{(void 0).$method$}catch(q){return q.message}}()))
s($,"ve","mH",()=>A.r8())
s($,"vh","oZ",()=>A.el(4096))
s($,"vf","oX",()=>new A.l1().$0())
s($,"vg","oY",()=>new A.l0().$0())
s($,"vw","i7",()=>A.i5(B.k5))
s($,"uT","oK",()=>A.lF(B.j2,!1))
s($,"uS","oJ",()=>A.lF(B.hK,!1))
s($,"vA","mM",()=>{var q=null,p="ISOSpeed"
return A.c6([11,A.f("ProcessingSoftware",B.j,q),254,A.f("SubfileType",B.n,1),255,A.f("OldSubfileType",B.n,1),256,A.f("ImageWidth",B.n,1),257,A.f("ImageLength",B.n,1),258,A.f("BitsPerSample",B.h,1),259,A.f("Compression",B.h,1),262,A.f("PhotometricInterpretation",B.h,1),263,A.f("Thresholding",B.h,1),264,A.f("CellWidth",B.h,1),265,A.f("CellLength",B.h,1),266,A.f("FillOrder",B.h,1),269,A.f("DocumentName",B.j,q),270,A.f("ImageDescription",B.j,q),271,A.f("Make",B.j,q),272,A.f("Model",B.j,q),273,A.f("StripOffsets",B.n,q),274,A.f("Orientation",B.h,1),277,A.f("SamplesPerPixel",B.h,1),278,A.f("RowsPerStrip",B.n,1),279,A.f("StripByteCounts",B.n,1),280,A.f("MinSampleValue",B.h,1),281,A.f("MaxSampleValue",B.h,1),282,A.f("XResolution",B.q,1),283,A.f("YResolution",B.q,1),284,A.f("PlanarConfiguration",B.h,1),285,A.f("PageName",B.j,q),286,A.f("XPosition",B.q,1),287,A.f("YPosition",B.q,1),290,A.f("GrayResponseUnit",B.h,1),291,A.f("GrayResponseCurve",B.d,q),292,A.f("T4Options",B.d,q),293,A.f("T6Options",B.d,q),296,A.f("ResolutionUnit",B.h,1),297,A.f("PageNumber",B.h,2),300,A.f("ColorResponseUnit",B.d,q),301,A.f("TransferFunction",B.h,768),305,A.f("Software",B.j,q),306,A.f("DateTime",B.j,q),315,A.f("Artist",B.j,q),316,A.f("HostComputer",B.j,q),317,A.f("Predictor",B.h,1),318,A.f("WhitePoint",B.q,2),319,A.f("PrimaryChromaticities",B.q,6),320,A.f("ColorMap",B.h,q),321,A.f("HalftoneHints",B.h,2),322,A.f("TileWidth",B.n,1),323,A.f("TileLength",B.n,1),324,A.f("TileOffsets",B.n,q),325,A.f("TileByteCounts",B.d,q),326,A.f("BadFaxLines",B.d,q),327,A.f("CleanFaxData",B.d,q),328,A.f("ConsecutiveBadFaxLines",B.d,q),332,A.f("InkSet",B.d,q),333,A.f("InkNames",B.d,q),334,A.f("NumberofInks",B.d,q),336,A.f("DotRange",B.d,q),337,A.f("TargetPrinter",B.j,q),338,A.f("ExtraSamples",B.d,q),339,A.f("SampleFormat",B.h,1),340,A.f("SMinSampleValue",B.d,q),341,A.f("SMaxSampleValue",B.d,q),342,A.f("TransferRange",B.d,q),343,A.f("ClipPath",B.d,q),512,A.f("JPEGProc",B.d,q),513,A.f("JPEGInterchangeFormat",B.d,q),514,A.f("JPEGInterchangeFormatLength",B.d,q),529,A.f("YCbCrCoefficients",B.q,3),530,A.f("YCbCrSubSampling",B.h,1),531,A.f("YCbCrPositioning",B.h,1),532,A.f("ReferenceBlackWhite",B.q,6),700,A.f("ApplicationNotes",B.h,1),18246,A.f("Rating",B.h,1),33421,A.f("CFARepeatPatternDim",B.d,q),33422,A.f("CFAPattern",B.d,q),33423,A.f("BatteryLevel",B.d,q),33432,A.f("Copyright",B.j,q),33434,A.f("ExposureTime",B.q,1),33437,A.f("FNumber",B.q,q),33723,A.f("IPTC-NAA",B.n,1),34665,A.f("ExifOffset",B.d,q),34675,A.f("InterColorProfile",B.d,q),34850,A.f("ExposureProgram",B.h,1),34852,A.f("SpectralSensitivity",B.j,q),34853,A.f("GPSOffset",B.d,q),34855,A.f(p,B.n,1),34856,A.f("OECF",B.d,q),34864,A.f("SensitivityType",B.h,1),34866,A.f("RecommendedExposureIndex",B.n,1),34867,A.f(p,B.n,1),36864,A.f("ExifVersion",B.N,q),36867,A.f("DateTimeOriginal",B.j,q),36868,A.f("DateTimeDigitized",B.j,q),36880,A.f("OffsetTime",B.j,q),36881,A.f("OffsetTimeOriginal",B.j,q),36882,A.f("OffsetTimeDigitized",B.j,q),37121,A.f("ComponentsConfiguration",B.N,q),37122,A.f("CompressedBitsPerPixel",B.d,q),37377,A.f("ShutterSpeedValue",B.d,q),37378,A.f("ApertureValue",B.d,q),37379,A.f("BrightnessValue",B.d,q),37380,A.f("ExposureBiasValue",B.d,q),37381,A.f("MaxApertureValue",B.d,q),37382,A.f("SubjectDistance",B.d,q),37383,A.f("MeteringMode",B.d,q),37384,A.f("LightSource",B.d,q),37385,A.f("Flash",B.d,q),37386,A.f("FocalLength",B.d,q),37396,A.f("SubjectArea",B.d,q),37500,A.f("MakerNote",B.N,q),37510,A.f("UserComment",B.N,q),37520,A.f("SubSecTime",B.d,q),37521,A.f("SubSecTimeOriginal",B.d,q),37522,A.f("SubSecTimeDigitized",B.d,q),40091,A.f("XPTitle",B.d,q),40092,A.f("XPComment",B.d,q),40093,A.f("XPAuthor",B.d,q),40094,A.f("XPKeywords",B.d,q),40095,A.f("XPSubject",B.d,q),40960,A.f("FlashPixVersion",B.d,q),40961,A.f("ColorSpace",B.h,1),40962,A.f("ExifImageWidth",B.h,1),40963,A.f("ExifImageLength",B.h,1),40964,A.f("RelatedSoundFile",B.d,q),40965,A.f("InteroperabilityOffset",B.d,q),41483,A.f("FlashEnergy",B.d,q),41484,A.f("SpatialFrequencyResponse",B.d,q),41486,A.f("FocalPlaneXResolution",B.d,q),41487,A.f("FocalPlaneYResolution",B.d,q),41488,A.f("FocalPlaneResolutionUnit",B.d,q),41492,A.f("SubjectLocation",B.d,q),41493,A.f("ExposureIndex",B.d,q),41495,A.f("SensingMethod",B.d,q),41728,A.f("FileSource",B.d,q),41729,A.f("SceneType",B.d,q),41730,A.f("CVAPattern",B.d,q),41985,A.f("CustomRendered",B.d,q),41986,A.f("ExposureMode",B.d,q),41987,A.f("WhiteBalance",B.d,q),41988,A.f("DigitalZoomRatio",B.d,q),41989,A.f("FocalLengthIn35mmFilm",B.d,q),41990,A.f("SceneCaptureType",B.d,q),41991,A.f("GainControl",B.d,q),41992,A.f("Contrast",B.d,q),41993,A.f("Saturation",B.d,q),41994,A.f("Sharpness",B.d,q),41995,A.f("DeviceSettingDescription",B.d,q),41996,A.f("SubjectDistanceRange",B.d,q),42016,A.f("ImageUniqueID",B.d,q),42032,A.f("CameraOwnerName",B.j,q),42033,A.f("BodySerialNumber",B.j,q),42034,A.f("LensSpecification",B.d,q),42035,A.f("LensMake",B.j,q),42036,A.f("LensModel",B.j,q),42037,A.f("LensSerialNumber",B.j,q),42240,A.f("Gamma",B.q,1),50341,A.f("PrintIM",B.d,q),59932,A.f("Padding",B.d,q),59933,A.f("OffsetSchema",B.d,q),65e3,A.f("OwnerName",B.j,q),65001,A.f("SerialNumber",B.j,q)],t.p,A.U("fn"))})
s($,"vx","p2",()=>new A.fo(new WeakMap(),A.U("fo<hv>")))
s($,"vv","mL",()=>{var q,p=A.el(768),o=J.e5(256,t.p)
for(q=0;q<256;++q)o[q]=q
B.c.aK(p,256,512,o)
B.c.an(p,512,768,255)
return p})
s($,"uU","i6",()=>A.q2(A.m([0,1,8,16,9,2,3,10,17,24,32,25,18,11,4,5,12,19,26,33,40,48,41,34,27,20,13,6,7,14,21,28,35,42,49,56,57,50,43,36,29,22,15,23,30,37,44,51,58,59,52,45,38,31,39,46,53,60,61,54,47,55,62,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63],t.t)))
r($,"v8","mD",()=>A.el(511))
r($,"v9","mE",()=>A.el(511))
r($,"vb","mF",()=>A.nu(2041))
r($,"vc","mG",()=>A.nu(225))
r($,"va","lt",()=>A.el(766))
s($,"vd","oW",()=>A.mZ(0,0,0,0))
s($,"uW","oL",()=>A.ng(0,0,0))
s($,"vt","ai",()=>A.el(1))
s($,"vu","at",()=>A.pF(B.c.gA($.ai()),0,null))
s($,"vm","ah",()=>A.pZ(1))
s($,"vn","as",()=>J.p5(B.A.gA($.ah()),0,null))
s($,"vo","N",()=>A.q0(1))
s($,"vq","a_",()=>J.p6(B.l.gA($.N()),0,null))
s($,"vp","bL",()=>A.pw(B.l.gA($.N())))
s($,"vk","mJ",()=>A.pW(1))
s($,"vl","p0",()=>A.nI(B.E.gA($.mJ()),0))
s($,"vi","mI",()=>A.pT(1))
s($,"vj","p_",()=>A.nI(B.R.gA($.mI()),0))
s($,"vr","mK",()=>A.qk(1))
s($,"vs","p1",()=>{var q=$.mK()
return A.px(q.gA(q))})})();(function nativeSupport(){!function(){var s=function(a){var m={}
m[a]=1
return Object.keys(hunkHelpers.convertToFastObject(m))[0]}
v.getIsolateTag=function(a){return s("___dart_"+a+v.isolateTag)}
var r="___dart_isolate_tags_"
var q=Object[r]||(Object[r]=Object.create(null))
var p="_ZxYxX"
for(var o=0;;o++){var n=s(p+"_"+o+"_")
if(!(n in q)){q[n]=1
v.isolateTag=n
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.d5,SharedArrayBuffer:A.d5,ArrayBufferView:A.eh,DataView:A.h3,Float32Array:A.eb,Float64Array:A.ec,Int16Array:A.ed,Int32Array:A.ee,Int8Array:A.ef,Uint16Array:A.ei,Uint32Array:A.ej,Uint8ClampedArray:A.ek,CanvasPixelArray:A.ek,Uint8Array:A.c7})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,SharedArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.d6.$nativeSuperclassTag="ArrayBufferView"
A.eR.$nativeSuperclassTag="ArrayBufferView"
A.eS.$nativeSuperclassTag="ArrayBufferView"
A.eg.$nativeSuperclassTag="ArrayBufferView"
A.eT.$nativeSuperclassTag="ArrayBufferView"
A.eU.$nativeSuperclassTag="ArrayBufferView"
A.aE.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$0=function(){return this()}
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$6=function(a,b,c,d,e,f){return this(a,b,c,d,e,f)}
Function.prototype.$5=function(a,b,c,d,e){return this(a,b,c,d,e)}
Function.prototype.$1$1=function(a){return this(a)}
Function.prototype.$2$1=function(a){return this(a)}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=A.u0
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=esNitida.js.map
