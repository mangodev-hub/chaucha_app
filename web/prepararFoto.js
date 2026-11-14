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
if(a[b]!==s){A.ue(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.m(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.mB(b)
return new s(c,this)}:function(){if(s===null)s=A.mB(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.mB(a).prototype
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
mK(a,b,c,d){return{i:a,p:b,e:c,x:d}},
lq(a){var s,r,q,p,o,n="_$dart_js",m=a[v.dispatchPropertyName]
if(m==null)if($.mH==null){A.tY()
m=a[v.dispatchPropertyName]}if(m!=null){s=m.p
if(!1===s)return m.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return m.i
if(m.e===r)throw A.e(A.eD("Return interceptor for "+A.x(s(a,m))))}q=a.constructor
if(q==null)p=null
else{o=$.kZ
if(o==null)o=$.kZ=A.lp(n)
p=q[o]}if(p!=null)return p
p=A.u4(a)
if(p!=null)return p
if(typeof a=="function")return B.cA
s=Object.getPrototypeOf(a)
if(s==null)return B.bu
if(s===Object.prototype)return B.bu
if(typeof q=="function"){o=$.kZ
if(o==null)o=$.kZ=A.lp(n)
Object.defineProperty(q,o,{value:B.aw,enumerable:false,writable:true,configurable:true})
return B.aw}return B.aw},
lR(a,b){if(a<0||a>4294967295)throw A.e(A.ae(a,0,4294967295,"length",null))
return J.nv(new Array(a),b)},
al(a,b){if(a<0||a>4294967295)throw A.e(A.ae(a,0,4294967295,"length",null))
return J.nv(new Array(a),b)},
lS(a,b){if(a<0)throw A.e(A.aZ("Length must be a non-negative integer: "+a,null))
return A.m(new Array(a),b.n("p<0>"))},
bB(a,b){return A.m(new Array(a),b.n("p<0>"))},
nv(a,b){var s=A.m(a,b.n("p<0>"))
s.$flags=1
return s},
nw(a){if(a<256)switch(a){case 9:case 10:case 11:case 12:case 13:case 32:case 133:case 160:return!0
default:return!1}switch(a){case 5760:case 8192:case 8193:case 8194:case 8195:case 8196:case 8197:case 8198:case 8199:case 8200:case 8201:case 8202:case 8232:case 8233:case 8239:case 8287:case 12288:case 65279:return!0
default:return!1}},
pQ(a,b){var s,r
for(s=a.length;b<s;){r=a.charCodeAt(b)
if(r!==32&&r!==13&&!J.nw(r))break;++b}return b},
pR(a,b){var s,r
for(;b>0;b=s){s=b-1
r=a.charCodeAt(s)
if(r!==32&&r!==13&&!J.nw(r))break}return b},
cy(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.e8.prototype
return J.h_.prototype}if(typeof a=="string")return J.d2.prototype
if(a==null)return J.e9.prototype
if(typeof a=="boolean")return J.fZ.prototype
if(Array.isArray(a))return J.p.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bh.prototype
if(typeof a=="symbol")return J.d4.prototype
if(typeof a=="bigint")return J.d3.prototype
return a}if(a instanceof A.n)return a
return J.lq(a)},
a6(a){if(typeof a=="string")return J.d2.prototype
if(a==null)return a
if(Array.isArray(a))return J.p.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bh.prototype
if(typeof a=="symbol")return J.d4.prototype
if(typeof a=="bigint")return J.d3.prototype
return a}if(a instanceof A.n)return a
return J.lq(a)},
aC(a){if(a==null)return a
if(Array.isArray(a))return J.p.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bh.prototype
if(typeof a=="symbol")return J.d4.prototype
if(typeof a=="bigint")return J.d3.prototype
return a}if(a instanceof A.n)return a
return J.lq(a)},
bx(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.bh.prototype
if(typeof a=="symbol")return J.d4.prototype
if(typeof a=="bigint")return J.d3.prototype
return a}if(a instanceof A.n)return a
return J.lq(a)},
aK(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.cy(a).P(a,b)},
c(a,b){if(typeof b==="number")if(Array.isArray(a)||A.oH(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.aC(a).k(a,b)},
W(a,b,c){if(typeof b==="number")if((Array.isArray(a)||A.oH(a,a[v.dispatchPropertyName]))&&!(a.$flags&2)&&b>>>0===b&&b<a.length)return a[b]=c
return J.aC(a).m(a,b,c)},
pc(a,b,c){return J.bx(a).fE(a,b,c)},
mW(a,b,c){return J.bx(a).fF(a,b,c)},
pd(a,b,c){return J.bx(a).fG(a,b,c)},
pe(a,b,c){return J.bx(a).fH(a,b,c)},
lD(a,b,c){return J.bx(a).fI(a,b,c)},
pf(a){return J.bx(a).fJ(a)},
mX(a,b,c){return J.bx(a).d3(a,b,c)},
au(a,b,c){return J.bx(a).fK(a,b,c)},
C(a){return J.bx(a).fL(a)},
a2(a,b,c){return J.bx(a).d4(a,b,c)},
mY(a,b){return J.aC(a).bA(a,b)},
dD(a,b,c,d){return J.aC(a).ao(a,b,c,d)},
pg(a){return J.aC(a).gfV(a)},
av(a){return J.cy(a).gH(a)},
f9(a){return J.aC(a).gG(a)},
mZ(a){return J.aC(a).gd8(a)},
by(a){return J.a6(a).gp(a)},
lE(a){return J.cy(a).gap(a)},
n_(a,b,c){return J.aC(a).bN(a,b,c)},
lF(a,b){return J.aC(a).bh(a,b)},
lG(a,b,c){return J.aC(a).bX(a,b,c)},
ph(a,b){return J.aC(a).ha(a,b)},
dE(a){return J.cy(a).B(a)},
fM:function fM(){},
fZ:function fZ(){},
e9:function e9(){},
eb:function eb(){},
bC:function bC(){},
hh:function hh(){},
eE:function eE(){},
bh:function bh(){},
d3:function d3(){},
d4:function d4(){},
p:function p(a){this.$ti=a},
fY:function fY(){},
jc:function jc(a){this.$ti=a},
fb:function fb(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
ea:function ea(){},
e8:function e8(){},
h_:function h_(){},
d2:function d2(){}},A={lT:function lT(){},
nz(a){return new A.d5("Field '"+a+"' has not been initialized.")},
pU(a){return new A.d5("Field '"+a+"' has already been initialized.")},
bp(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
k0(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
f6(a,b,c){return a},
mI(a){var s,r
for(s=$.cv.length,r=0;r<s;++r)if(a===$.cv[r])return!0
return!1},
di(a,b,c,d){A.aR(b,"start")
if(c!=null){A.aR(c,"end")
if(b>c)A.Y(A.ae(b,0,c,"start",null))}return new A.eC(a,b,c,d.n("eC<0>"))},
pY(a,b,c,d){if(t.R.b(a))return new A.bR(a,b,c.n("@<0>").aG(d).n("bR<1,2>"))
return new A.bj(a,b,c.n("@<0>").aG(d).n("bj<1,2>"))},
nO(a,b,c){var s="count"
if(t.R.b(a)){A.ie(b,s)
A.aR(b,s)
return new A.cM(a,b,c.n("cM<0>"))}A.ie(b,s)
A.aR(b,s)
return new A.bo(a,b,c.n("bo<0>"))},
e7(){return new A.bH("No element")},
nu(){return new A.bH("Too few elements")},
dG:function dG(a,b){this.a=a
this.$ti=b},
dH:function dH(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
d5:function d5(a){this.a=a},
aN:function aN(a){this.a=a},
jV:function jV(){},
v:function v(){},
aF:function aF(){},
eC:function eC(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
d6:function d6(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bj:function bj(a,b,c){this.a=a
this.b=b
this.$ti=c},
bR:function bR(a,b,c){this.a=a
this.b=b
this.$ti=c},
h6:function h6(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
bk:function bk(a,b,c){this.a=a
this.b=b
this.$ti=c},
eK:function eK(a,b,c){this.a=a
this.b=b
this.$ti=c},
hK:function hK(a,b,c){this.a=a
this.b=b
this.$ti=c},
bo:function bo(a,b,c){this.a=a
this.b=b
this.$ti=c},
cM:function cM(a,b,c){this.a=a
this.b=b
this.$ti=c},
hv:function hv(a,b,c){this.a=a
this.b=b
this.$ti=c},
bS:function bS(a){this.$ti=a},
fq:function fq(a){this.$ti=a},
dR:function dR(){},
hC:function hC(){},
dj:function dj(){},
k_:function k_(){},
oF(a,b){var s=new A.e4(a,b.n("e4<0>"))
s.hI(a)
return s},
oQ(a){var s=A.oP(a)
if(s!=null)return s
return"minified:"+a},
oH(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.eA.b(a)},
x(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.dE(a)
return s},
db(a){var s,r=$.nI
if(r==null)r=$.nI=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
qj(a,b){var s,r=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(r==null)return null
s=r[3]
if(s!=null)return parseInt(a,10)
if(r[2]!=null)return parseInt(a,16)
return null},
hi(a){var s,r,q,p
if(a instanceof A.n)return A.aI(A.aW(a),null)
s=J.cy(a)
if(s===B.cw||s===B.cB||t.bI.b(a)){r=B.aB(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.aI(A.aW(a),null)},
qk(a){var s,r,q
if(typeof a=="number"||A.i7(a))return J.dE(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.bP)return a.B(0)
s=$.pb()
for(r=0;r<1;++r){q=s[r].lw(a)
if(q!=null)return q}return"Instance of '"+A.hi(a)+"'"},
nH(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
ql(a){var s,r,q,p=A.m([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a0)(a),++r){q=a[r]
if(!A.lg(q))throw A.e(A.cw(q))
if(q<=65535)p.push(q)
else if(q<=1114111){p.push(55296+(B.a.i(q-65536,10)&1023))
p.push(56320+(q&1023))}else throw A.e(A.cw(q))}return A.nH(p)},
nJ(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.lg(q))throw A.e(A.cw(q))
if(q<0)throw A.e(A.cw(q))
if(q>65535)return A.ql(a)}return A.nH(a)},
qm(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
dc(a){var s
if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.a.i(s,10)|55296)>>>0,s&1023|56320)}throw A.e(A.ae(a,0,1114111,null,null))},
da(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
qi(a){var s=A.da(a).getUTCFullYear()+0
return s},
qg(a){var s=A.da(a).getUTCMonth()+1
return s},
qc(a){var s=A.da(a).getUTCDate()+0
return s},
qd(a){var s=A.da(a).getUTCHours()+0
return s},
qf(a){var s=A.da(a).getUTCMinutes()+0
return s},
qh(a){var s=A.da(a).getUTCSeconds()+0
return s},
qe(a){var s=A.da(a).getUTCMilliseconds()+0
return s},
qb(a){var s=a.$thrownJsError
if(s==null)return null
return A.b9(s)},
nK(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.a_(a,s)
a.$thrownJsError=s
s.stack=b.B(0)}},
mF(a,b){var s,r="index",q=null
if(!A.lg(b))return new A.aY(!0,b,r,q)
s=J.by(a)
if(b<0||b>=s)return A.iX(b,s,a,q,r)
return new A.bn(q,q,!0,b,r,"Value not in range")},
tR(a,b,c){if(a<0||a>c)return A.ae(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.ae(b,a,c,"end",null)
return new A.aY(!0,b,"end",null)},
cw(a){return new A.aY(!0,a,null,null)},
e(a){return A.a_(a,new Error())},
a_(a,b){var s
if(a==null)a=new A.bq()
b.dartException=a
s=A.uf
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
uf(){return J.dE(this.dartException)},
Y(a,b){throw A.a_(a,b==null?new Error():b)},
a(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.Y(A.rY(a,b,c),s)},
rY(a,b,c){var s,r,q,p,o,n,m,l,k
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
return new A.eF("'"+s+"': Cannot "+o+" "+l+k+n)},
a0(a){throw A.e(A.aO(a))},
br(a){var s,r,q,p,o,n
a=A.ua(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.m([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.kc(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
kd(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
nR(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
lV(a,b){var s=b==null,r=s?null:b.method
return new A.h3(a,r,s?null:b.receiver)},
ar(a){if(a==null)return new A.js(a)
if(a instanceof A.dM)return A.bN(a,a.a)
if(typeof a!=="object")return a
if("dartException" in a)return A.bN(a,a.dartException)
return A.tG(a)},
bN(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
tG(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.a.i(r,16)&8191)===10)switch(q){case 438:return A.bN(a,A.lV(A.x(s)+" (Error "+q+")",null))
case 445:case 5007:A.x(s)
return A.bN(a,new A.eo())}}if(a instanceof TypeError){p=$.oV()
o=$.oW()
n=$.oX()
m=$.oY()
l=$.p0()
k=$.p1()
j=$.p_()
$.oZ()
i=$.p3()
h=$.p2()
g=p.bq(s)
if(g!=null)return A.bN(a,A.lV(s,g))
else{g=o.bq(s)
if(g!=null){g.method="call"
return A.bN(a,A.lV(s,g))}else if(n.bq(s)!=null||m.bq(s)!=null||l.bq(s)!=null||k.bq(s)!=null||j.bq(s)!=null||m.bq(s)!=null||i.bq(s)!=null||h.bq(s)!=null)return A.bN(a,new A.eo())}return A.bN(a,new A.hB(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.ez()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.bN(a,new A.aY(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.ez()
return a},
b9(a){var s
if(a instanceof A.dM)return a.b
if(a==null)return new A.eZ(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.eZ(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
ia(a){if(a==null)return J.av(a)
if(typeof a=="object")return A.db(a)
return J.av(a)},
tN(a){if(typeof a=="number")return B.b.gH(a)
if(a instanceof A.i3)return A.db(a)
if(a instanceof A.k_)return a.gH(0)
return A.ia(a)},
oz(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.m(0,a[s],a[r])}return b},
t7(a,b,c,d,e,f){switch(b){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.e(new A.kK("Unsupported number of arguments for wrapped closure"))},
f7(a,b){var s=a.$identity
if(!!s)return s
s=A.tO(a,b)
a.$identity=s
return s},
tO(a,b){var s
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
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.t7)},
pq(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.jX().constructor.prototype):Object.create(new A.dF(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.n7(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.pm(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.n7(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
pm(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.e("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.pk)}throw A.e("Error in functionType of tearoff")},
pn(a,b,c,d){var s=A.n6
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
n7(a,b,c,d){if(c)return A.pp(a,b,d)
return A.pn(b.length,d,a,b)},
po(a,b,c,d){var s=A.n6,r=A.pl
switch(b?-1:a){case 0:throw A.e(new A.hu("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
pp(a,b,c){var s,r
if($.n4==null)$.n4=A.n3("interceptor")
if($.n5==null)$.n5=A.n3("receiver")
s=b.length
r=A.po(s,c,a,b)
return r},
mB(a){return A.pq(a)},
pk(a,b){return A.l8(v.typeUniverse,A.aW(a.a),b)},
n6(a){return a.a},
pl(a){return a.b},
n3(a){var s,r,q,p=new A.dF("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.e(A.aZ("Field name "+a+" not found.",null))},
lp(a){return v.getIsolateTag(a)},
vF(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
u4(a){var s,r,q,p,o,n=$.oD.$1(a),m=$.ln[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.lu[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=$.ou.$2(a,n)
if(q!=null){m=$.ln[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.lu[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.ly(s)
$.ln[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.lu[n]=s
return s}if(p==="-"){o=A.ly(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.oK(a,s)
if(p==="*")throw A.e(A.eD(n))
if(v.leafTags[n]===true){o=A.ly(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.oK(a,s)},
oK(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.mK(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
ly(a){return J.mK(a,!1,null,!!a.$iaE)},
u6(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.ly(s)
else return J.mK(s,c,null,null)},
tY(){if(!0===$.mH)return
$.mH=!0
A.tZ()},
tZ(){var s,r,q,p,o,n,m,l
$.ln=Object.create(null)
$.lu=Object.create(null)
A.tX()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.oL.$1(o)
if(n!=null){m=A.u6(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
tX(){var s,r,q,p,o,n,m=B.c0()
m=A.dz(B.c1,A.dz(B.c2,A.dz(B.aC,A.dz(B.aC,A.dz(B.c3,A.dz(B.c4,A.dz(B.c5(B.aB),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.oD=new A.lr(p)
$.ou=new A.ls(o)
$.oL=new A.lt(n)},
dz(a,b){return a(b)||b},
tQ(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
ua(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
cL:function cL(){},
ip:function ip(a,b,c){this.a=a
this.b=b
this.c=c},
dK:function dK(a,b,c){this.a=a
this.b=b
this.$ti=c},
eS:function eS(a,b){this.a=a
this.$ti=b},
ds:function ds(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bW:function bW(a,b){this.a=a
this.$ti=b},
dJ:function dJ(){},
dS:function dS(a,b){this.a=a
this.$ti=b},
j1:function j1(){},
e4:function e4(a,b){this.a=a
this.$ti=b},
ex:function ex(){},
kc:function kc(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
eo:function eo(){},
h3:function h3(a,b,c){this.a=a
this.b=b
this.c=c},
hB:function hB(a){this.a=a},
js:function js(a){this.a=a},
dM:function dM(a,b){this.a=a
this.b=b},
eZ:function eZ(a){this.a=a
this.b=null},
bP:function bP(){},
im:function im(){},
io:function io(){},
k1:function k1(){},
jX:function jX(){},
dF:function dF(a,b){this.a=a
this.b=b},
hu:function hu(a){this.a=a},
b3:function b3(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
jm:function jm(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
c7:function c7(a,b){this.a=a
this.$ti=b},
V:function V(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
jn:function jn(a,b){this.a=a
this.$ti=b},
ag:function ag(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
bi:function bi(a,b){this.a=a
this.$ti=b},
h4:function h4(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
c6:function c6(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
lr:function lr(a){this.a=a},
ls:function ls(a){this.a=a},
lt:function lt(a){this.a=a},
ue(a){throw A.a_(new A.d5("Field '"+a+"' has been assigned during initialization."),new Error())},
b(){throw A.a_(A.nz(""),new Error())},
y(){throw A.a_(A.pU(""),new Error())},
rk(){var s=new A.kF()
return s.b=s},
kF:function kF(){this.b=null},
aq(a,b,c){},
t(a){var s,r,q
if(t.aP.b(a))return a
s=J.a6(a)
r=A.a3(s.gp(a),null,!1,t.z)
for(q=0;q<s.gp(a);++q)r[q]=s.k(a,q)
return r},
pZ(a,b,c){var s
A.aq(a,b,c)
s=new DataView(a,b,c)
return s},
q_(a){return new Float32Array(a)},
q0(a,b,c){A.aq(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Float32Array(a,b,c)},
q1(a,b,c){A.aq(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Int16Array(a,b,c)},
q2(a){return new Int32Array(a)},
q3(a,b,c){A.aq(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Int32Array(a,b,c)},
nE(a){return new Int8Array(a)},
q4(a,b,c){A.aq(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
q5(a){return new Uint16Array(a)},
q6(a,b,c){A.aq(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
q7(a){return new Uint32Array(a)},
q8(a,b,c){A.aq(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
en(a){return new Uint8Array(a)},
q9(a){return new Uint8Array(A.t(a))},
qa(a,b,c){A.aq(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
bw(a,b,c){if(a>>>0!==a||a>=c)throw A.e(A.mF(b,a))},
i6(a,b,c){var s
if(!(a>>>0!==a))if(b==null)s=a>c
else s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.e(A.tR(a,b,c))
if(b==null)return c
return b},
d7:function d7(){},
ej:function ej(){},
i4:function i4(a){this.a=a},
h7:function h7(){},
d8:function d8(){},
ei:function ei(){},
aG:function aG(){},
ed:function ed(){},
ee:function ee(){},
ef:function ef(){},
eg:function eg(){},
eh:function eh(){},
ek:function ek(){},
el:function el(){},
em:function em(){},
c9:function c9(){},
eU:function eU(){},
eV:function eV(){},
eW:function eW(){},
eX:function eX(){},
me(a,b){var s=b.c
return s==null?b.c=A.f2(a,"bz",[b.x]):s},
nN(a){var s=a.w
if(s===6||s===7)return A.nN(a.x)
return s===11||s===12},
qp(a){return a.as},
S(a){return A.l7(v.typeUniverse,a,!1)},
oG(a,b){var s,r,q,p,o
if(a==null)return null
s=b.y
r=a.Q
if(r==null)r=a.Q=new Map()
q=b.as
p=r.get(q)
if(p!=null)return p
o=A.bM(v.typeUniverse,a.x,s,0)
r.set(q,o)
return o},
bM(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.bM(a1,s,a3,a4)
if(r===s)return a2
return A.o6(a1,r,!0)
case 7:s=a2.x
r=A.bM(a1,s,a3,a4)
if(r===s)return a2
return A.o5(a1,r,!0)
case 8:q=a2.y
p=A.dy(a1,q,a3,a4)
if(p===q)return a2
return A.f2(a1,a2.x,p)
case 9:o=a2.x
n=A.bM(a1,o,a3,a4)
m=a2.y
l=A.dy(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.mn(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.dy(a1,j,a3,a4)
if(i===j)return a2
return A.o7(a1,k,i)
case 11:h=a2.x
g=A.bM(a1,h,a3,a4)
f=a2.y
e=A.tC(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.o4(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.dy(a1,d,a3,a4)
o=a2.x
n=A.bM(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.mo(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.e(A.fd("Attempted to substitute unexpected RTI kind "+a0))}},
dy(a,b,c,d){var s,r,q,p,o=b.length,n=A.lb(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.bM(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
tD(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.lb(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.bM(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
tC(a,b,c,d){var s,r=b.a,q=A.dy(a,r,c,d),p=b.b,o=A.dy(a,p,c,d),n=b.c,m=A.tD(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.hT()
s.a=q
s.b=o
s.c=m
return s},
m(a,b){a[v.arrayRti]=b
return a},
i8(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.tW(s)
return a.$S()}return null},
u_(a,b){var s
if(A.nN(b))if(a instanceof A.bP){s=A.i8(a)
if(s!=null)return s}return A.aW(a)},
aW(a){if(a instanceof A.n)return A.i(a)
if(Array.isArray(a))return A.bv(a)
return A.mw(J.cy(a))},
bv(a){var s=a[v.arrayRti],r=t.cO
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
i(a){var s=a.$ti
return s!=null?s:A.mw(a)},
mw(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.t5(a,s)},
t5(a,b){var s=a instanceof A.bP?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.rD(v.typeUniverse,s.name)
b.$ccache=r
return r},
tW(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.l7(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
dB(a){return A.aV(A.i(a))},
mG(a){var s=A.i8(a)
return A.aV(s==null?A.aW(a):s)},
tB(a){var s=a instanceof A.bP?A.i8(a):null
if(s!=null)return s
if(t.ci.b(a))return J.lE(a).a
if(Array.isArray(a))return A.bv(a)
return A.aW(a)},
aV(a){var s=a.r
return s==null?a.r=new A.i3(a):s},
aX(a){return A.aV(A.l7(v.typeUniverse,a,!1))},
t4(a){var s=this
s.b=A.tz(s)
return s.b(a)},
tz(a){var s,r,q,p
if(a===t.K)return A.td
if(A.cz(a))return A.th
s=a.w
if(s===6)return A.t2
if(s===1)return A.ok
if(s===7)return A.t8
r=A.ty(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.cz)){a.f="$i"+q
if(q==="A")return A.tb
if(a===t.m)return A.ta
return A.tg}}else if(s===10){p=A.tQ(a.x,a.y)
return p==null?A.ok:p}return A.t0},
ty(a){if(a.w===8){if(a===t.p)return A.lg
if(a===t.V||a===t.n)return A.tc
if(a===t.N)return A.tf
if(a===t.y)return A.i7}return null},
t3(a){var s=this,r=A.t_
if(A.cz(s))r=A.rR
else if(s===t.K)r=A.ld
else if(A.dC(s)){r=A.t1
if(s===t.I)r=A.rM
else if(s===t.dk)r=A.rQ
else if(s===t.fQ)r=A.rJ
else if(s===t.cg)r=A.rP
else if(s===t.cD)r=A.rL
else if(s===t.bX)r=A.rN}else if(s===t.p)r=A.z
else if(s===t.N)r=A.mp
else if(s===t.y)r=A.rI
else if(s===t.n)r=A.rO
else if(s===t.V)r=A.rK
else if(s===t.m)r=A.oc
s.a=r
return s.a(a)},
t0(a){var s=this
if(a==null)return A.dC(s)
return A.u1(v.typeUniverse,A.u_(a,s),s)},
t2(a){if(a==null)return!0
return this.x.b(a)},
tg(a){var s,r=this
if(a==null)return A.dC(r)
s=r.f
if(a instanceof A.n)return!!a[s]
return!!J.cy(a)[s]},
tb(a){var s,r=this
if(a==null)return A.dC(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.n)return!!a[s]
return!!J.cy(a)[s]},
ta(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.n)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
oj(a){if(typeof a=="object"){if(a instanceof A.n)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
t_(a){var s=this
if(a==null){if(A.dC(s))return a}else if(s.b(a))return a
throw A.a_(A.oe(a,s),new Error())},
t1(a){var s=this
if(a==null||s.b(a))return a
throw A.a_(A.oe(a,s),new Error())},
oe(a,b){return new A.f0("TypeError: "+A.nZ(a,A.aI(b,null)))},
nZ(a,b){return A.iu(a)+": type '"+A.aI(A.tB(a),null)+"' is not a subtype of type '"+b+"'"},
aT(a,b){return new A.f0("TypeError: "+A.nZ(a,b))},
t8(a){var s=this
return s.x.b(a)||A.me(v.typeUniverse,s).b(a)},
td(a){return a!=null},
ld(a){if(a!=null)return a
throw A.a_(A.aT(a,"Object"),new Error())},
th(a){return!0},
rR(a){return a},
ok(a){return!1},
i7(a){return!0===a||!1===a},
rI(a){if(!0===a)return!0
if(!1===a)return!1
throw A.a_(A.aT(a,"bool"),new Error())},
rJ(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.a_(A.aT(a,"bool?"),new Error())},
rK(a){if(typeof a=="number")return a
throw A.a_(A.aT(a,"double"),new Error())},
rL(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a_(A.aT(a,"double?"),new Error())},
lg(a){return typeof a=="number"&&Math.floor(a)===a},
z(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.a_(A.aT(a,"int"),new Error())},
rM(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.a_(A.aT(a,"int?"),new Error())},
tc(a){return typeof a=="number"},
rO(a){if(typeof a=="number")return a
throw A.a_(A.aT(a,"num"),new Error())},
rP(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a_(A.aT(a,"num?"),new Error())},
tf(a){return typeof a=="string"},
mp(a){if(typeof a=="string")return a
throw A.a_(A.aT(a,"String"),new Error())},
rQ(a){if(typeof a=="string")return a
if(a==null)return a
throw A.a_(A.aT(a,"String?"),new Error())},
oc(a){if(A.oj(a))return a
throw A.a_(A.aT(a,"JSObject"),new Error())},
rN(a){if(a==null)return a
if(A.oj(a))return a
throw A.a_(A.aT(a,"JSObject?"),new Error())},
oq(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.aI(a[q],b)
return s},
to(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.oq(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.aI(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
of(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=", ",a0=null
if(a3!=null){s=a3.length
if(a2==null)a2=A.m([],t.s)
else a0=a2.length
r=a2.length
for(q=s;q>0;--q)a2.push("T"+(r+q))
for(p=t.X,o="<",n="",q=0;q<s;++q,n=a){o=o+n+a2[a2.length-1-q]
m=a3[q]
l=m.w
if(!(l===2||l===3||l===4||l===5||m===p))o+=" extends "+A.aI(m,a2)}o+=">"}else o=""
p=a1.x
k=a1.y
j=k.a
i=j.length
h=k.b
g=h.length
f=k.c
e=f.length
d=A.aI(p,a2)
for(c="",b="",q=0;q<i;++q,b=a)c+=b+A.aI(j[q],a2)
if(g>0){c+=b+"["
for(b="",q=0;q<g;++q,b=a)c+=b+A.aI(h[q],a2)
c+="]"}if(e>0){c+=b+"{"
for(b="",q=0;q<e;q+=3,b=a){c+=b
if(f[q+1])c+="required "
c+=A.aI(f[q+2],a2)+" "+f[q]}c+="}"}if(a0!=null){a2.toString
a2.length=a0}return o+"("+c+") => "+d},
aI(a,b){var s,r,q,p,o,n,m=a.w
if(m===5)return"erased"
if(m===2)return"dynamic"
if(m===3)return"void"
if(m===1)return"Never"
if(m===4)return"any"
if(m===6){s=a.x
r=A.aI(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(m===7)return"FutureOr<"+A.aI(a.x,b)+">"
if(m===8){p=A.tF(a.x)
o=a.y
return o.length>0?p+("<"+A.oq(o,b)+">"):p}if(m===10)return A.to(a,b)
if(m===11)return A.of(a,b,null)
if(m===12)return A.of(a.x,b,a.y)
if(m===13){n=a.x
return b[b.length-1-n]}return"?"},
tF(a){var s=A.oP(a)
if(s!=null)return s
return"minified:"+a},
rE(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
rD(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.l7(a,b,!1)
else if(typeof m=="number"){s=m
r=A.f3(a,5,"#")
q=A.lb(s)
for(p=0;p<s;++p)q[p]=r
o=A.f2(a,b,q)
n[b]=o
return o}else return m},
rB(a,b){return A.oa(a.tR,b)},
rA(a,b){return A.oa(a.eT,b)},
l7(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.o8(a,null,b,!1)
r.set(b,s)
return s},
l8(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.o8(a,b,c,!0)
q.set(c,r)
return r},
rC(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.mn(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
o8(a,b,c,d){return A.rs(A.rm(a,b,c,d))},
bL(a,b){b.a=A.t3
b.b=A.t4
return b},
f3(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.b6(null,null)
s.w=b
s.as=c
r=A.bL(a,s)
a.eC.set(c,r)
return r},
o6(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.ry(a,b,r,c)
a.eC.set(r,s)
return s},
ry(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.cz(b))if(!(b===t.a||b===t.T))if(s!==6)r=s===7&&A.dC(b.x)
if(r)return b
else if(s===1)return t.a}q=new A.b6(null,null)
q.w=6
q.x=b
q.as=c
return A.bL(a,q)},
o5(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.rw(a,b,r,c)
a.eC.set(r,s)
return s},
rw(a,b,c,d){var s,r
if(d){s=b.w
if(A.cz(b)||b===t.K)return b
else if(s===1)return A.f2(a,"bz",[b])
else if(b===t.a||b===t.T)return t.eH}r=new A.b6(null,null)
r.w=7
r.x=b
r.as=c
return A.bL(a,r)},
rz(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.b6(null,null)
s.w=13
s.x=b
s.as=q
r=A.bL(a,s)
a.eC.set(q,r)
return r},
f1(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
rv(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
f2(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.f1(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.b6(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.bL(a,r)
a.eC.set(p,q)
return q},
mn(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.f1(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.b6(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.bL(a,o)
a.eC.set(q,n)
return n},
o7(a,b,c){var s,r,q="+"+(b+"("+A.f1(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.b6(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.bL(a,s)
a.eC.set(q,r)
return r},
o4(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.f1(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.f1(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.rv(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.b6(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.bL(a,p)
a.eC.set(r,o)
return o},
mo(a,b,c,d){var s,r=b.as+("<"+A.f1(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.rx(a,b,c,r,d)
a.eC.set(r,s)
return s},
rx(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.lb(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.bM(a,b,r,0)
m=A.dy(a,c,r,0)
return A.mo(a,n,m,c!==m)}}l=new A.b6(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.bL(a,l)},
rm(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
rs(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.ro(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.o2(a,r,l,k,!1)
else if(q===46)r=A.o2(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.cu(a.u,a.e,k.pop()))
break
case 94:k.push(A.rz(a.u,k.pop()))
break
case 35:k.push(A.f3(a.u,5,"#"))
break
case 64:k.push(A.f3(a.u,2,"@"))
break
case 126:k.push(A.f3(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.rq(a,k)
break
case 38:A.rp(a,k)
break
case 63:p=a.u
k.push(A.o6(p,A.cu(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.o5(p,A.cu(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.rn(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.o3(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.rt(a.u,a.e,o)
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
return A.cu(a.u,a.e,m)},
ro(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
o2(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.rE(s,o.x)[p]
if(n==null)A.Y('No "'+p+'" in "'+A.qp(o)+'"')
d.push(A.l8(s,o,n))}else d.push(p)
return m},
rq(a,b){var s,r=a.u,q=A.o1(a,b),p=b.pop()
if(typeof p=="string")b.push(A.f2(r,p,q))
else{s=A.cu(r,a.e,p)
switch(s.w){case 11:b.push(A.mo(r,s,q,a.n))
break
default:b.push(A.mn(r,s,q))
break}}},
rn(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.o1(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.cu(p,a.e,o)
q=new A.hT()
q.a=s
q.b=n
q.c=m
b.push(A.o4(p,r,q))
return
case-4:b.push(A.o7(p,b.pop(),s))
return
default:throw A.e(A.fd("Unexpected state under `()`: "+A.x(o)))}},
rp(a,b){var s=b.pop()
if(0===s){b.push(A.f3(a.u,1,"0&"))
return}if(1===s){b.push(A.f3(a.u,4,"1&"))
return}throw A.e(A.fd("Unexpected extended operation "+A.x(s)))},
o1(a,b){var s=b.splice(a.p)
A.o3(a.u,a.e,s)
a.p=b.pop()
return s},
cu(a,b,c){if(typeof c=="string")return A.f2(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.rr(a,b,c)}else return c},
o3(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.cu(a,b,c[s])},
rt(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.cu(a,b,c[s])},
rr(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.e(A.fd("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.e(A.fd("Bad index "+c+" for "+b.B(0)))},
u1(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.a5(a,b,null,c,null)
r.set(c,s)}return s},
a5(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.cz(d))return!0
s=b.w
if(s===4)return!0
if(A.cz(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.a5(a,c[b.x],c,d,e))return!0
q=d.w
p=t.a
if(b===p||b===t.T){if(q===7)return A.a5(a,b,c,d.x,e)
return d===p||d===t.T||q===6}if(d===t.K){if(s===7)return A.a5(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.a5(a,b.x,c,d,e))return!1
return A.a5(a,A.me(a,b),c,d,e)}if(s===6)return A.a5(a,p,c,d,e)&&A.a5(a,b.x,c,d,e)
if(q===7){if(A.a5(a,b,c,d.x,e))return!0
return A.a5(a,b,c,A.me(a,d),e)}if(q===6)return A.a5(a,b,c,p,e)||A.a5(a,b,c,d.x,e)
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
if(!A.a5(a,j,c,i,e)||!A.a5(a,i,e,j,c))return!1}return A.oi(a,b.x,c,d.x,e)}if(q===11){if(b===t.e)return!0
if(p)return!1
return A.oi(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.t9(a,b,c,d,e)}if(o&&q===10)return A.te(a,b,c,d,e)
return!1},
oi(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.a5(a3,a4.x,a5,a6.x,a7))return!1
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
if(!A.a5(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.a5(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.a5(a3,k[h],a7,g,a5))return!1}f=s.c
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
if(!A.a5(a3,e[a+2],a7,g,a5))return!1
break}}while(b<d){if(f[b+1])return!1
b+=3}return!0},
t9(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.l8(a,b,r[o])
return A.ob(a,p,null,c,d.y,e)}return A.ob(a,b.y,null,c,d.y,e)},
ob(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.a5(a,b[s],d,e[s],f))return!1
return!0},
te(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.a5(a,r[s],c,q[s],e))return!1
return!0},
dC(a){var s=a.w,r=!0
if(!(a===t.a||a===t.T))if(!A.cz(a))if(s!==6)r=s===7&&A.dC(a.x)
return r},
cz(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
oa(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
lb(a){return a>0?new Array(a):v.typeUniverse.sEA},
b6:function b6(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
hT:function hT(){this.c=this.b=this.a=null},
i3:function i3(a){this.a=a},
hR:function hR(){},
f0:function f0(a){this.a=a},
rg(){var s,r,q
if(self.scheduleImmediate!=null)return A.tH()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.f7(new A.kA(s),1)).observe(r,{childList:true})
return new A.kz(s,r,q)}else if(self.setImmediate!=null)return A.tI()
return A.tJ()},
rh(a){self.scheduleImmediate(A.f7(new A.kB(a),0))},
ri(a){self.setImmediate(A.f7(new A.kC(a),0))},
rj(a){A.ru(0,a)},
ru(a,b){var s=new A.l4()
s.hS(a,b)
return s},
my(a){return new A.hL(new A.R($.I,a.n("R<0>")),a.n("hL<0>"))},
mt(a,b){a.$2(0,null)
b.b=!0
return b.a},
mq(a,b){A.rS(a,b)},
ms(a,b){b.d6(a)},
mr(a,b){b.e2(A.ar(a),A.b9(a))},
rS(a,b){var s,r,q=new A.le(b),p=new A.lf(b)
if(a instanceof A.R)a.fu(q,p,t.z)
else{s=t.z
if(a instanceof A.R)a.hb(q,p,s)
else{r=new A.R($.I,t.eI)
r.a=8
r.c=a
r.fu(q,p,s)}}},
mz(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.I.df(new A.li(s))},
lH(a){var s
if(t.C.b(a)){s=a.gce()
if(s!=null)return s}return B.J},
t6(a,b){if($.I===B.p)return null
return null},
oh(a,b){if($.I!==B.p)A.t6(a,b)
if(b==null)if(t.C.b(a)){b=a.gce()
if(b==null){A.nK(a,B.J)
b=B.J}}else b=B.J
else if(t.C.b(a))A.nK(a,b)
return new A.aM(a,b)},
o_(a,b){var s=new A.R($.I,b.n("R<0>"))
s.a=8
s.c=a
return s},
mj(a,b,c){var s,r,q,p={},o=p.a=a
while(s=o.a,(s&4)!==0){o=o.c
p.a=o}if(o===b){s=A.qq()
b.ds(new A.aM(new A.aY(!0,o,null,"Cannot complete a future with itself"),s))
return}r=b.a&1
s=o.a=s|r
if((s&24)===0){q=b.c
b.a=b.a&1|4
b.c=o
o.fg(q)
return}if(!c)if(b.c==null)o=(s&16)===0||r!==0
else o=!1
else o=!0
if(o){q=b.co()
b.cM(p.a)
A.ct(b,q)
return}b.a^=2
A.dx(null,null,b.b,new A.kO(p,b))},
ct(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g={},f=g.a=a
for(;;){s={}
r=f.a
q=(r&16)===0
p=!q
if(b==null){if(p&&(r&1)===0){f=f.c
A.dw(f.a,f.b)}return}s.a=b
o=b.a
for(f=b;o!=null;f=o,o=n){f.a=null
A.ct(g.a,f)
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
if(r){A.dw(m.a,m.b)
return}j=$.I
if(j!==k)$.I=k
else j=null
f=f.c
if((f&15)===8)new A.kS(s,g,p).$0()
else if(q){if((f&1)!==0)new A.kR(s,m).$0()}else if((f&2)!==0)new A.kQ(g,s).$0()
if(j!=null)$.I=j
f=s.c
if(f instanceof A.R){r=s.a.$ti
r=r.n("bz<2>").b(f)||!r.y[1].b(f)}else r=!1
if(r){i=s.a.b
if((f.a&24)!==0){h=i.c
i.c=null
b=i.d_(h)
i.a=f.a&30|i.a&1
i.c=f.c
g.a=f
continue}else A.mj(f,i,!0)
return}}i=s.a.b
h=i.c
i.c=null
b=i.d_(h)
f=s.b
r=s.c
if(!f){i.a=8
i.c=r}else{i.a=i.a&1|16
i.c=r}g.a=i
f=i}},
tp(a,b){if(t.Q.b(a))return b.df(a)
if(t.E.b(a))return a
throw A.e(A.n0(a,"onError",u.c))},
tk(){var s,r
for(s=$.dv;s!=null;s=$.dv){$.f5=null
r=s.b
$.dv=r
if(r==null)$.f4=null
s.a.$0()}},
tA(){$.mx=!0
try{A.tk()}finally{$.f5=null
$.mx=!1
if($.dv!=null)$.mR().$1(A.ov())}},
os(a){var s=new A.hM(a),r=$.f4
if(r==null){$.dv=$.f4=s
if(!$.mx)$.mR().$1(A.ov())}else $.f4=r.b=s},
tx(a){var s,r,q,p=$.dv
if(p==null){A.os(a)
$.f5=$.f4
return}s=new A.hM(a)
r=$.f5
if(r==null){s.b=p
$.dv=$.f5=s}else{q=r.b
s.b=q
$.f5=r.b=s
if(q==null)$.f4=s}},
oO(a){var s=null,r=$.I
if(B.p===r){A.dx(s,s,B.p,a)
return}A.dx(s,s,r,r.fM(a))},
v3(a,b){A.f6(a,"stream",t.K)
return new A.i1(b.n("i1<0>"))},
nP(a){return new A.eL(null,null,a.n("eL<0>"))},
or(a){return},
nX(a,b){return b==null?A.tK():b},
nY(a,b){if(b==null)b=A.tM()
if(t.k.b(b))return a.df(b)
if(t.u.b(b))return b
throw A.e(A.aZ(u.h,null))},
tl(a){},
tn(a,b){A.dw(a,b)},
tm(){},
dw(a,b){A.tx(new A.lh(a,b))},
on(a,b,c,d){var s,r=$.I
if(r===c)return d.$0()
$.I=c
s=r
try{r=d.$0()
return r}finally{$.I=s}},
op(a,b,c,d,e){var s,r=$.I
if(r===c)return d.$1(e)
$.I=c
s=r
try{r=d.$1(e)
return r}finally{$.I=s}},
oo(a,b,c,d,e,f){var s,r=$.I
if(r===c)return d.$2(e,f)
$.I=c
s=r
try{r=d.$2(e,f)
return r}finally{$.I=s}},
dx(a,b,c,d){if(B.p!==c){d=c.fM(d)
d=d}A.os(d)},
kA:function kA(a){this.a=a},
kz:function kz(a,b,c){this.a=a
this.b=b
this.c=c},
kB:function kB(a){this.a=a},
kC:function kC(a){this.a=a},
l4:function l4(){},
l5:function l5(a,b){this.a=a
this.b=b},
hL:function hL(a,b){this.a=a
this.b=!1
this.$ti=b},
le:function le(a){this.a=a},
lf:function lf(a){this.a=a},
li:function li(a){this.a=a},
aM:function aM(a,b){this.a=a
this.b=b},
bK:function bK(a,b){this.a=a
this.$ti=b},
dn:function dn(a,b,c,d,e,f,g){var _=this
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
hN:function hN(){},
eL:function eL(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.r=_.e=_.d=null
_.$ti=c},
hO:function hO(){},
cs:function cs(a,b){this.a=a
this.$ti=b},
dp:function dp(a,b,c,d,e){var _=this
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
kL:function kL(a,b){this.a=a
this.b=b},
kP:function kP(a,b){this.a=a
this.b=b},
kO:function kO(a,b){this.a=a
this.b=b},
kN:function kN(a,b){this.a=a
this.b=b},
kM:function kM(a,b){this.a=a
this.b=b},
kS:function kS(a,b,c){this.a=a
this.b=b
this.c=c},
kT:function kT(a,b){this.a=a
this.b=b},
kU:function kU(a){this.a=a},
kR:function kR(a,b){this.a=a
this.b=b},
kQ:function kQ(a,b){this.a=a
this.b=b},
hM:function hM(a){this.a=a
this.b=null},
b7:function b7(){},
jY:function jY(a,b){this.a=a
this.b=b},
jZ:function jZ(a,b){this.a=a
this.b=b},
eN:function eN(){},
eO:function eO(){},
eM:function eM(){},
kE:function kE(a,b,c){this.a=a
this.b=b
this.c=c},
kD:function kD(a){this.a=a},
du:function du(){},
hQ:function hQ(){},
hP:function hP(a,b){this.b=a
this.a=null
this.$ti=b},
kI:function kI(a,b){this.b=a
this.c=b
this.a=null},
kH:function kH(){},
hZ:function hZ(a){var _=this
_.a=0
_.c=_.b=null
_.$ti=a},
l1:function l1(a,b){this.a=a
this.b=b},
eP:function eP(a,b){var _=this
_.a=1
_.b=a
_.c=null
_.$ti=b},
i1:function i1(a){this.$ti=a},
lc:function lc(){},
l2:function l2(){},
l3:function l3(a,b){this.a=a
this.b=b},
lh:function lh(a,b){this.a=a
this.b=b},
o0(a,b){var s=a[b]
return s===a?null:s},
ml(a,b,c){if(c==null)a[b]=a
else a[b]=c},
mk(){var s=Object.create(null)
A.ml(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
pV(a,b){return new A.b3(a.n("@<0>").aG(b).n("b3<1,2>"))},
c8(a,b,c){return A.oz(a,new A.b3(b.n("@<0>").aG(c).n("b3<1,2>")))},
D(a,b){return new A.b3(a.n("@<0>").aG(b).n("b3<1,2>"))},
nA(a){return new A.eT(a.n("eT<0>"))},
mm(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
h5(a,b,c){var s=A.pV(b,c)
a.bk(0,new A.jo(s,b,c))
return s},
lW(a){var s,r
if(A.mI(a))return"{...}"
s=new A.eA("")
try{r={}
$.cv.push(a)
s.a+="{"
r.a=!0
a.bk(0,new A.jq(r,s))
s.a+="}"}finally{$.cv.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
pW(a){return 8},
pX(a){var s
a=(a<<1>>>0)-1
for(;;a=s){s=(a&a-1)>>>0
if(s===0)return a}},
eQ:function eQ(){},
dq:function dq(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
eR:function eR(a,b){this.a=a
this.$ti=b},
hU:function hU(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
eT:function eT(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
l_:function l_(a){this.a=a
this.b=null},
hX:function hX(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
jo:function jo(a,b,c){this.a=a
this.b=b
this.c=c},
E:function E(){},
bD:function bD(){},
jq:function jq(a,b){this.a=a
this.b=b},
ec:function ec(a,b){var _=this
_.a=a
_.d=_.c=_.b=0
_.$ti=b},
hY:function hY(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.$ti=e},
bG:function bG(){},
eY:function eY(){},
rG(a,b,c){var s,r,q,p=c-b
if(p<=4096)s=$.p7()
else s=new Uint8Array(p)
for(r=0;r<p;++r){q=a[b+r]
if((q&255)!==q)q=255
s[r]=q}return s},
rF(a,b,c,d){var s=a?$.p6():$.p5()
if(s==null)return null
if(0===c&&d===b.length)return A.o9(s,b)
return A.o9(s,b.subarray(c,d))},
o9(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
rH(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
la:function la(){},
l9:function l9(){},
l6:function l6(){},
fi:function fi(){},
fn:function fn(){},
it:function it(){},
jk:function jk(){},
jl:function jl(a){this.a=a},
kf:function kf(){},
hD:function hD(a){this.a=a},
i5:function i5(a){this.a=a
this.b=16
this.c=0},
u0(a){var s=A.qj(a,null)
if(s!=null)return s
throw A.e(A.lM(a,null,null))},
ps(a,b){a=A.a_(a,new Error())
a.stack=b.B(0)
throw a},
a3(a,b,c,d){var s,r=J.lR(a,d)
if(a!==0&&b!=null)for(s=0;s<a;++s)r[s]=b
return r},
nB(a,b){var s,r,q=A.m([],b.n("p<0>"))
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a0)(a),++r)q.push(a[r])
return q},
o(a,b){var s,r
if(Array.isArray(a))return A.m(a.slice(0),b.n("p<0>"))
s=A.m([],b.n("p<0>"))
for(r=J.f9(a);r.E();)s.push(r.gK())
return s},
nC(a,b,c){var s,r=J.lS(a,c)
for(s=0;s<a;++s)r[s]=b.$1(s)
return r},
eB(a,b,c){var s,r,q,p,o
A.aR(b,"start")
s=c==null
r=!s
if(r){q=c-b
if(q<0)throw A.e(A.ae(c,b,null,"end",null))
if(q===0)return""}if(Array.isArray(a)){p=a
o=p.length
if(s)c=o
return A.nJ(b>0||c<o?p.slice(b,c):p)}if(t.bm.b(a))return A.qr(a,b,c)
if(r)a=J.ph(a,c)
if(b>0)a=J.lF(a,b)
s=A.o(a,t.p)
return A.nJ(s)},
qr(a,b,c){var s=a.length
if(b>=s)return""
return A.qm(a,b,c==null||c>s?s:c)},
nQ(a,b,c){var s=J.f9(b)
if(!s.E())return a
if(c.length===0){do a+=A.x(s.gK())
while(s.E())}else{a+=A.x(s.gK())
while(s.E())a=a+c+A.x(s.gK())}return a},
qq(){return A.b9(new Error())},
pr(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
na(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
fp(a){if(a>=10)return""+a
return"0"+a},
iu(a){if(typeof a=="number"||A.i7(a)||a==null)return J.dE(a)
if(typeof a=="string")return JSON.stringify(a)
return A.qk(a)},
pt(a,b){A.f6(a,"error",t.K)
A.f6(b,"stackTrace",t.gm)
A.ps(a,b)},
fd(a){return new A.fc(a)},
aZ(a,b){return new A.aY(!1,null,b,a)},
n0(a,b,c){return new A.aY(!0,a,b,c)},
ie(a,b){return a},
qo(a){var s=null
return new A.bn(s,s,!1,s,s,a)},
ae(a,b,c,d,e){return new A.bn(b,c,!0,a,d,"Invalid value")},
cn(a,b,c){if(0>a||a>c)throw A.e(A.ae(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.e(A.ae(b,a,c,"end",null))
return b}return c},
aR(a,b){if(a<0)throw A.e(A.ae(a,0,null,b,null))
return a},
iX(a,b,c,d,e){return new A.fI(b,!0,a,e,"Index out of range")},
bc(a){return new A.eF(a)},
eD(a){return new A.hA(a)},
jW(a){return new A.bH(a)},
aO(a){return new A.fl(a)},
lM(a,b,c){return new A.be(a,b,c)},
pP(a,b,c){var s,r
if(A.mI(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.m([],t.s)
$.cv.push(a)
try{A.ti(a,s)}finally{$.cv.pop()}r=A.nQ(b,s,", ")+c
return r.charCodeAt(0)==0?r:r},
jb(a,b,c){var s,r
if(A.mI(a))return b+"..."+c
s=new A.eA(b)
$.cv.push(a)
try{r=s
r.a=A.nQ(r.a,a,", ")}finally{$.cv.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
ti(a,b){var s,r,q,p,o,n,m,l=a.gG(a),k=0,j=0
for(;;){if(!(k<80||j<3))break
if(!l.E())return
s=A.x(l.gK())
b.push(s)
k+=s.length+2;++j}if(!l.E()){if(j<=5)return
r=b.pop()
q=b.pop()}else{p=l.gK();++j
if(!l.E()){if(j<=4){b.push(A.x(p))
return}r=A.x(p)
q=b.pop()
k+=r.length+2}else{o=l.gK();++j
for(;l.E();p=o,o=n){n=l.gK();++j
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
lX(a,b,c,d){var s
if(B.B===c){s=J.av(a)
b=J.av(b)
return A.k0(A.bp(A.bp($.id(),s),b))}if(B.B===d){s=J.av(a)
b=J.av(b)
c=J.av(c)
return A.k0(A.bp(A.bp(A.bp($.id(),s),b),c))}s=J.av(a)
b=J.av(b)
c=J.av(c)
d=J.av(d)
d=A.k0(A.bp(A.bp(A.bp(A.bp($.id(),s),b),c),d))
return d},
l(a){var s,r=$.id()
for(s=J.f9(a);s.E();)r=A.bp(r,J.av(s.gK()))
return A.k0(r)},
fo:function fo(a,b,c){this.a=a
this.b=b
this.c=c},
kJ:function kJ(){},
T:function T(){},
fc:function fc(a){this.a=a},
bq:function bq(){},
aY:function aY(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
bn:function bn(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
fI:function fI(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
eF:function eF(a){this.a=a},
hA:function hA(a){this.a=a},
bH:function bH(a){this.a=a},
fl:function fl(a){this.a=a},
h8:function h8(){},
ez:function ez(){},
kK:function kK(a){this.a=a},
be:function be(a,b,c){this.a=a
this.b=b
this.c=c},
d:function d(){},
az:function az(a,b,c){this.a=a
this.b=b
this.$ti=c},
ad:function ad(){},
n:function n(){},
f_:function f_(a){this.a=a},
eA:function eA(a){this.a=a},
fs:function fs(a,b){this.a=a
this.$ti=b},
jr:function jr(a){this.a=a},
og(a){var s
if(typeof a=="function")throw A.e(A.aZ("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.rV,a)
s[$.mM()]=a
return s},
rV(a,b,c){if(c>=1)return a.$1(b)
return a.$0()},
om(a){return a==null||A.i7(a)||typeof a=="number"||typeof a=="string"||t.cu.b(a)||t.D.b(a)||t.go.b(a)||t.W.b(a)||t.h7.b(a)||t.an.b(a)||t.w.b(a)||t.B.b(a)||t.gN.b(a)||t.dI.b(a)||t.fd.b(a)},
mJ(a){if(A.om(a))return a
return new A.lx(new A.dq(t.x)).$1(a)},
u8(a,b){var s=new A.R($.I,b.n("R<0>")),r=new A.cs(s,b.n("cs<0>"))
a.then(A.f7(new A.lz(r),1),A.f7(new A.lA(r),1))
return s},
ol(a){return a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string"||a instanceof Int8Array||a instanceof Uint8Array||a instanceof Uint8ClampedArray||a instanceof Int16Array||a instanceof Uint16Array||a instanceof Int32Array||a instanceof Uint32Array||a instanceof Float32Array||a instanceof Float64Array||a instanceof ArrayBuffer||a instanceof DataView},
mE(a){if(A.ol(a))return a
return new A.lm(new A.dq(t.x)).$1(a)},
lx:function lx(a){this.a=a},
lz:function lz(a){this.a=a},
lA:function lA(a){this.a=a},
lm:function lm(a){this.a=a},
lO(a,b){var s=new A.iJ()
s.hy(a,b)
return s},
iJ:function iJ(){this.a=$
this.b=0
this.c=2147483647},
e3:function e3(a,b){this.a=a
this.b=b},
fJ:function fJ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.r=_.f=_.e=0
_.w=d
_.x=null
_.y=0},
dt:function dt(a,b){this.a=a
this.b=b},
iY:function iY(a,b){var _=this
_.a=a
_.b=null
_.c=b
_.f=!1
_.w=_.r=0},
aL(a){return new A.fa(a,null,null)},
fa:function fa(a,b,c){this.a=a
this.b=b
this.c=c},
fh:function fh(a,b){this.a=a
this.b=b},
nr(a){return new A.fK(new A.kG(a,0,new Uint8Array(65536)),0,null,B.a3)},
ns(a,b,c){return new A.fK(a.b,a.c+b,c,a.a)},
fK:function fK(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=c
_.e=0
_.a=d},
kG:function kG(a,b,c){var _=this
_.b=a
_.c=b
_.d=c
_.r=_.f=_.e=0
_.w=!1},
j_(a,b,c,d){var s,r,q,p,o=new A.fL(b)
if(d==null)d=0
A.aR(d,"offset")
if(d<0)d=0
else{s=a.length
if(d>s)d=s}r=a.length-d
if(c==null)c=r
if(c<0||c>r)c=r
q=t.D.b(a)?a:new Uint8Array(A.t(a))
p=J.a2(B.c.gA(q),q.byteOffset+d,c)
o.b=p
o.d=p.length
return o},
fL:function fL(a){var _=this
_.b=null
_.c=0
_.d=$
_.a=a},
j0:function j0(){},
lY:function lY(a){this.b=0
this.c=a},
ju:function ju(){},
il:function il(a,b){this.a=a
this.b=b},
P:function P(a){this.a=-1
this.b=a},
cA:function cA(a){this.a=a},
cB:function cB(a){this.a=a},
cC:function cC(a){this.a=a},
cD:function cD(a){this.a=a},
cE:function cE(a){this.a=a},
cF:function cF(a){this.a=a},
cG:function cG(a,b){this.a=a
this.b=b},
cH:function cH(a){this.a=a},
cI:function cI(a,b){this.a=a
this.b=b},
cJ:function cJ(a){this.a=a},
cK:function cK(a,b){this.a=a
this.b=b},
n8(a,b,c,d){var s=new A.bQ(new Uint8Array(4))
s.ht(a,b,c,d)
return s},
b_:function b_(a){this.a=a},
fj:function fj(a){this.a=a},
bQ:function bQ(a){this.a=a},
dI:function dI(a){this.a=a},
fm:function fm(a){this.a=a},
dA(a,b,c){var s
if(b===c)return a
switch(b.a){case 0:if(a===0)s=0
else{s=B.bt.k(0,c)
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
case 1:return B.a.i(A.z(a),1)
case 2:return a
case 3:return a*17
case 4:return a*4369
case 5:return a*286331153
case 6:return a*8
case 7:return a*2184
case 8:return a*143165576
case 9:case 10:case 11:return a/3}break
case 3:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.i(A.z(a),6)
case 2:return B.a.i(A.z(a),4)
case 3:return a
case 4:return a*257
case 5:return a*16843009
case 6:return B.a.i(A.z(a),1)
case 7:return a*128
case 8:return a*8421504
case 9:case 10:case 11:return a/255}break
case 4:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.i(A.z(a),14)
case 2:return B.a.i(A.z(a),12)
case 3:return B.a.i(A.z(a),8)
case 4:return a
case 5:return A.z(a)<<8>>>0
case 6:return B.a.i(A.z(a),9)
case 7:return B.a.i(A.z(a),1)
case 8:return a*524296
case 9:case 10:case 11:return a/65535}break
case 5:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.i(A.z(a),30)
case 2:return B.a.i(A.z(a),28)
case 3:return B.a.i(A.z(a),24)
case 4:return B.a.i(A.z(a),16)
case 5:return a
case 6:return B.a.i(A.z(a),25)
case 7:return B.a.i(A.z(a),17)
case 8:return B.a.i(A.z(a),1)
case 9:case 10:case 11:return a/4294967295}break
case 6:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.i(A.z(a),5)
case 2:return a<=0?0:B.a.i(A.z(a),3)
case 3:return a<=0?0:A.z(a)<<1>>>0
case 4:return a<=0?0:A.z(a)*516
case 5:return a<=0?0:A.z(a)*33818640
case 6:return a
case 7:return a*258
case 8:return a*16909320
case 9:case 10:case 11:return a/127}break
case 7:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.i(A.z(a),15)
case 2:return a<=0?0:B.a.i(A.z(a),11)
case 3:return a<=0?0:B.a.i(A.z(a),7)
case 4:return a<=0?0:A.z(a)<<1>>>0
case 5:return a<=0?0:A.z(a)*131076
case 6:return B.a.i(A.z(a),8)
case 7:return a
case 8:return A.z(a)*65538
case 9:case 10:case 11:return a/32767}break
case 8:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.i(A.z(a),29)
case 2:return a<=0?0:B.a.i(A.z(a),27)
case 3:return a<=0?0:B.a.i(A.z(a),23)
case 4:return a<=0?0:B.a.i(A.z(a),16)
case 5:return a<=0?0:A.z(a)<<1>>>0
case 6:return B.a.i(A.z(a),24)
case 7:return B.a.i(A.z(a),16)
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
af:function af(a,b){this.a=a
this.b=b},
fe:function fe(a,b){this.a=a
this.b=b},
dN(a){var s,r=new A.bT(A.D(t.N,t.P))
r.hz(a)
s=a.b
if(s!=null)r.b=new Uint8Array(A.t(s))
return r},
lJ(a){var s=new A.bT(A.D(t.N,t.P))
s.bD(a)
return s},
bT:function bT(a){this.b=null
this.c=0
this.a=a},
hS:function hS(a,b){this.a=a
this.b=b},
f(a,b,c){return new A.fr(a,b)},
fr:function fr(a,b){this.a=a
this.b=b},
b1:function b1(a){this.a=a},
iQ:function iQ(a){this.a=a},
nh(a){var s=new A.aD(A.D(t.p,t.r),new A.b1(A.D(t.N,t.P)))
s.kL(a)
return s},
aD:function aD(a,b){this.a=a
this.b=b},
iR:function iR(a){this.a=a},
iS:function iS(a){this.a=a},
no(a,b){var s=new A.c3(new Uint16Array(b))
s.hE(a,b)
return s},
lP(a){var s=new Uint32Array(1)
s[0]=a
return new A.b2(s)},
nj(a,b){var s=new A.b2(new Uint32Array(b))
s.hB(a,b)
return s},
nk(a,b){var s,r=J.bB(b,t.i)
for(s=0;s<b;++s)r[s]=new A.dh(a.j(),a.j())
return new A.c_(r)},
nn(a,b){var s=new A.c2(new Int16Array(b))
s.hD(a,b)
return s},
nl(a,b){var s=new A.c0(new Int32Array(b))
s.hC(a,b)
return s},
nm(a,b){var s,r,q,p,o=J.bB(b,t.i)
for(s=0;s<b;++s){r=a.j()
q=$.O()
q.$flags&2&&A.a(q)
q[0]=r
r=$.a1()
p=r[0]
q[0]=a.j()
o[s]=new A.dh(p,r[0])}return new A.c1(o)},
np(a,b){var s=new A.cS(new Float32Array(b))
s.hF(a,b)
return s},
ni(a,b){var s=new A.cQ(new Float64Array(b))
s.hA(a,b)
return s},
aa:function aa(a,b){this.a=a
this.b=b},
Z:function Z(){},
bg:function bg(a){this.a=a},
bZ:function bZ(a){this.a=a},
c3:function c3(a){this.a=a},
b2:function b2(a){this.a=a},
c_:function c_(a){this.a=a},
bA:function bA(a){this.a=a},
c2:function c2(a){this.a=a},
c0:function c0(a){this.a=a},
c1:function c1(a){this.a=a},
cS:function cS(a){this.a=a},
cQ:function cQ(a){this.a=a},
cT:function cT(a){this.a=a},
cR:function cR(a){this.a=a},
ai(a,b,c,d){var s
if(d)s=a<0||b<0
else s=a<1||b<1
if(s)throw A.e(A.j("Invalid image dimensions "+a+"x"+b))
if(c>0&&a*b>c)throw A.e(A.j("Image dimensions "+a+"x"+b+" exceed the maximum of "+c+" pixels"))},
bl:function bl(a){this.a=a
this.c=0},
n1(a){var s,r,q=new A.ik()
if(!A.n2(a))A.Y(A.j("Not a bitmap file."))
a.d+=2
s=a.j()
r=$.O()
r.$flags&2&&A.a(r)
r[0]=s
s=$.a1()
a.d+=4
r[0]=a.j()
q.b=s[0]
return q},
n2(a){if(a.c-a.d<2)return!1
return A.r(a,null,0).l()===19778},
pj(a,b){var s,r,q,p,o=b==null?A.n1(a):b,n=a.d,m=a.j(),l=a.j(),k=$.O()
k.$flags&2&&A.a(k)
k[0]=l
l=$.a1()
s=l[0]
k[0]=a.j()
l=l[0]
r=a.l()
q=a.l()
p=a.j()
if(p>=14)A.Y(A.j("Unsupported BMP compression type: "+p))
p=B.bl[p]
a.j()
k[0]=a.j()
k[0]=a.j()
k=a.j()
a.j()
n=new A.bd(o,s,l,m,r,q,p,k,n)
n.ev(a,b)
return n},
a9:function a9(a,b){this.a=a
this.b=b},
ik:function ik(){this.b=$},
bd:function bd(a,b,c,d,e,f,g,h,i){var _=this
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
pi(a,b){return new A.ff(a,b==null?268435456:b)},
ff:function ff(a,b){var _=this
_.a=$
_.b=null
_.c=a
_.d=b},
ij:function ij(a,b){this.a=a
this.b=b},
ih:function ih(a,b){this.a=a
this.b=b},
ig:function ig(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
ii:function ii(a,b,c){this.a=a
this.b=b
this.c=c},
ir:function ir(a,b){var _=this
_.a=$
_.b=null
_.c=a
_.d=b},
dL:function dL(){},
iq:function iq(){},
is:function is(){},
ft:function ft(){},
fN:function fN(a,b,c,d){var _=this
_.r=a
_.w=b
_.x=c
_.b=_.a=0
_.c=d},
bV:function bV(a,b){this.a=a
this.b=b},
bU:function bU(a,b){this.a=a
this.b=b},
fu:function fu(){var _=this
_.w=_.r=_.f=_.d=_.c=_.b=_.a=$},
nb(a,b,c,d){var s,r
switch(a.a){case 1:return new A.j7(c,b)
case 2:return new A.fP(c,d==null?1:d,b)
case 3:return new A.fP(c,d==null?16:d,b)
case 4:s=d==null?32:d
r=new A.j5(c,s,b)
r.hJ(b,c,s)
return r
case 5:return new A.j6(c,d==null?16:d,b)
case 6:return new A.fN(c,d==null?32:d,!1,b)
case 7:return new A.fN(c,d==null?32:d,!0,b)
default:throw A.e(A.j("Invalid compression type: "+a.B(0)))}},
b0:function b0(a,b){this.a=a
this.b=b},
iv:function iv(){},
j4:function j4(){},
px(a,b,c,d){var s,r,q,p,o,n,m,l
if(b===0){if(d!==0)throw A.e(A.j("Incomplete huffman data"))
return}s=a.d
r=a.j()
q=a.j()
a.d+=4
p=a.j()
o=!0
if(r<65537)o=q>=65537
if(o)throw A.e(A.j("Invalid huffman table size"))
a.d+=4
n=A.a3(65537,0,!1,t.p)
m=J.al(16384,t.gV)
for(l=0;l<16384;++l)m[l]=new A.fv()
A.py(a,b-20,r,q,n)
if(p>8*(b-(a.d-s)))throw A.e(A.j("Error in header for Huffman-encoded data (invalid number of bits)."))
A.pu(n,r,q,m)
A.pw(n,m,a,p,q,d,c)},
pw(a,b,c,d,e,f,g){var s,r,q,p,o,n,m,l,k="Error in Huffman-encoded data (invalid code).",j=A.m([0,0],t.t),i=c.d+B.a.W(d+7,8)
for(s=0;c.d<i;){A.lK(j,c)
while(r=j[1],r>=14){q=b[B.a.bu(j[0],r-14)&16383]
p=q.a
if(p!==0){j[1]=r-p
s=A.lL(q.b,e,j,c,g,s,f)}else{if(q.c==null)throw A.e(A.j(k))
for(o=0;o<q.b;++o){n=a[q.c[o]]&63
for(;;){r=j[1]
if(!(r<n&&c.d<i))break
A.lK(j,c)}if(r>=n){p=q.c
r-=n
if(a[p[o]]>>>6===(B.a.bu(j[0],r)&B.a.N(1,n)-1)>>>0){j[1]=r
m=A.lL(p[o],e,j,c,g,s,f)
s=m
break}}}if(o===q.b)throw A.e(A.j(k))}}}l=8-d&7
j[0]=B.a.i(j[0],l)
j[1]=j[1]-l
while(r=j[1],r>0){q=b[B.a.X(j[0],14-r)&16383]
p=q.a
if(p!==0){j[1]=r-p
s=A.lL(q.b,e,j,c,g,s,f)}else throw A.e(A.j(k))}if(s!==f)throw A.e(A.j("Error in Huffman-encoded data (decoded data are shorter than expected)."))},
lL(a,b,c,d,e,f,g){var s,r,q,p,o,n="Error in Huffman-encoded data (decoded data are longer than expected)."
if(a===b){if(c[1]<8)A.lK(c,d)
s=c[1]-8
c[1]=s
r=B.a.bu(c[0],s)&255
if(f+r>g)throw A.e(A.j(n))
q=e[f-1]
for(s=e.$flags|0;p=r-1,r>0;r=p,f=o){o=f+1
s&2&&A.a(e)
e[f]=q}}else{if(f<g){e.toString
o=f+1
e.$flags&2&&A.a(e)
e[f]=a}else throw A.e(A.j(n))
f=o}return f},
pu(a,b,c,d){var s,r,q,p,o,n,m,l="Error in Huffman-encoded data (invalid code table entry)."
for(s=t.t;b<=c;++b){r=a[b]
q=r>>>6
p=r&63
if(B.a.a3(q,p)!==0)throw A.e(A.j(l))
if(p>14){o=d[B.a.Y(q,p-14)]
if(o.a!==0)throw A.e(A.j(l));++o.b
r=o.c;(r==null?o.c=A.m([],s):r).push(b)}else if(p!==0){r=14-p
n=B.a.X(q,r)
for(m=B.a.X(1,r);m>0;--m,++n){o=d[n]
if(o.a!==0||o.c!=null)throw A.e(A.j(l))
o.a=p
o.b=b}}}},
py(a,b,c,d,e){var s,r,q,p,o,n="Error in Huffman-encoded data (unexpected end of code table data).",m="Error in Huffman-encoded data (code table is longer than expected).",l=a.d,k=A.m([0,0],t.t)
for(s=d+1;c<=d;++c){if(a.d-l>b)throw A.e(A.j(n))
r=A.nc(6,k,a)
e[c]=r
if(r===63){if(a.d-l>b)throw A.e(A.j(n))
q=A.nc(8,k,a)+6
if(c+q>s)throw A.e(A.j(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
e[c]=0}--c}else if(r>=59){q=r-59+2
if(c+q>s)throw A.e(A.j(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
e[c]=0}--c}}A.pv(e)},
pv(a){var s,r,q,p,o,n=A.a3(59,0,!1,t.p)
for(s=0;s<65537;++s){r=a[s]
n[r]=n[r]+1}for(q=0,s=58;s>0;--s,q=p){p=q+n[s]>>>1
n[s]=q}for(s=0;s<65537;++s){o=a[s]
if(o>0){r=n[o]
n[o]=r+1
a[s]=(o|r<<6)>>>0}}},
lK(a,b){a[0]=(a[0]<<8|b.F())>>>0
a[1]=a[1]+8>>>0},
nc(a,b,c){var s
while(s=b[1],s<a){b[0]=(b[0]<<8|J.c(c.a,c.d++))>>>0
b[1]=b[1]+8>>>0}s-=a
b[1]=s
return(B.a.bu(b[0],s)&B.a.N(1,a)-1)>>>0},
fv:function fv(){this.b=this.a=0
this.c=null},
pz(a){var s
if(a.length<8)return!1
s=A.q(a,!1,null,0)
if(s.j()!==20000630)return!1
if(s.F()!==2)return!1
if((s.bc()&4294967289)>>>0!==0)return!1
return!0},
iA:function iA(a){var _=this
_.b=_.a=0
_.c=a
_.d=null
_.e=$},
nt(a,b,c,d){var s=new A.fO(a,A.m([],t.g9),A.D(t.N,t.aX),B.aI,b)
s.hw(a,b,c,d)
return s},
dO:function dO(){},
iB:function iB(a,b){this.a=a
this.b=b},
fO:function fO(a,b,c,d,e){var _=this
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
j5:function j5(a,b,c){var _=this
_.r=null
_.w=a
_.x=b
_.y=$
_.z=null
_.b=_.a=0
_.c=c},
i_:function i_(){var _=this
_.f=_.e=_.d=_.c=_.b=_.a=$},
j6:function j6(a,b,c){var _=this
_.r=a
_.w=b
_.x=null
_.b=_.a=0
_.c=c},
j7:function j7(a,b){var _=this
_.r=null
_.w=a
_.b=_.a=0
_.c=b},
fP:function fP(a,b,c){var _=this
_.w=a
_.x=b
_.y=null
_.b=_.a=0
_.c=c},
iw:function iw(a){this.a=null
this.b=a},
iz:function iz(a,b){this.a=a
this.b=b},
ix:function ix(a,b){this.a=a
this.b=b},
iy:function iy(a,b,c){this.a=a
this.b=b
this.c=c},
ne(a){var s=new Uint8Array(a*3)
return new A.dT(A.pG(a),a,null,new A.ba(s,a,3))},
pF(a){return new A.dT(a.a,a.b,a.c,A.nF(a.d))},
pG(a){var s
for(s=1;s<=8;++s)if(B.a.N(1,s)>=a)return s
return 0},
dT:function dT(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dU:function dU(){},
fQ:function fQ(){var _=this
_.e=_.d=_.c=_.b=_.a=$
_.f=null
_.r=80
_.w=0
_.x=-1
_.y=$},
cN:function cN(a){var _=this
_.b=_.a=0
_.e=_.c=null
_.r=a},
iF:function iF(a){var _=this
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
iI:function iI(a,b){this.a=a
this.b=b},
iG:function iG(a,b){this.a=a
this.b=b},
iH:function iH(a,b,c){this.a=a
this.b=b
this.c=c},
ng(a){var s,r,q,p
if(a.l()!==0)return null
s=a.l()
if(s>=3)return null
if(B.cF[s]===B.aK)return null
r=a.l()
q=J.bB(r,t.gx)
for(p=0;p<r;++p){J.c(a.a,a.d++)
J.c(a.a,a.d++)
J.c(a.a,a.d++);++a.d
a.l()
a.l()
q[p]=new A.fB(a.j(),a.j())}return new A.iP(r,q)},
cP:function cP(a,b){this.a=a
this.b=b},
iP:function iP(a,b){this.d=a
this.e=b},
fB:function fB(a,b){this.d=a
this.e=b},
iK:function iK(a,b,c,d,e,f,g,h,i){var _=this
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
iL:function iL(a){this.b=this.a=null
this.c=a},
iO:function iO(a,b){this.a=a
this.b=b},
iN:function iN(a,b,c){this.a=a
this.b=b
this.c=c},
iM:function iM(a,b){this.a=a
this.b=b},
n9(a,b,c,d,e){var s,r
if(a===b)s=0
else s=a===1&&b===4?2:1
if(c===d)r=0
else r=c===1&&d===4?2:1
return new A.fk(e,s,r)},
fk:function fk(a,b,c){this.e=a
this.f=b
this.r=c},
oE(a){var s,r=$.pa()
r=r.a
s=r.get(a)
if(s==null){s=A.rT(a)
r.set(a,s)
r=s}else r=s
return r},
rT(a){var s,r,q,p,o=new Uint16Array(512)
for(s=0;s<512;++s)for(r=a,q=1;q<=9;++q){p=r[B.a.Y(s,9-q)&1]
if(p instanceof A.cO){o[s]=(q<<8|p.a)>>>0
break}if(!(p instanceof A.bY))break
r=p.a}return o},
bX:function bX(){},
bY:function bY(a){this.a=a},
cO:function cO(a){this.a=a},
ny(a){var s,r=a.f.e
r.toString
s=a.b
s=new A.ji(a,B.a.ab(r+s-1,s),a.gdk())
s.hK(a)
return s},
oC(a){var s,r=A.ny(a)
r.hg(0,a.gdk())
s=r.d
s===$&&A.b()
return s},
ji:function ji(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.w=_.r=_.f=_.e=_.d=$},
jd:function jd(){this.d=null},
c5:function c5(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.x=_.w=_.r=_.f=_.e=$
_.y=!1
_.z=0
_.ay=_.ax=_.at=_.as=_.Q=$},
lU(){var s,r,q,p,o=A.a3(4,null,!1,t.bC),n=A.m([],t.f8),m=t.eC,l=J.lS(0,m)
m=J.lS(0,m)
s=A.m([],t.eB)
r=A.m([],t.cJ)
q=new Uint8Array(64)
p=new Int32Array(64)
return new A.h0(new A.bT(A.D(t.N,t.P)),o,n,l,m,s,r,q,p,new Int16Array(0))},
pS(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i,h=B.a.ab(8,b),g=h*h
for(s=g>>>1,r=0;r<b;++r){q=c[d+r]
q.toString
for(p=q.$flags|0,o=r*h,n=0;n<b;++n){for(m=n*h,l=0,k=0;k<h;++k){j=(o+k)*8+m
for(i=0;i<h;++i)l+=a[j+i]}m=B.a.ab(l+s,g)
p&2&&A.a(q)
q[e+n]=m}}},
h0:function h0(a,b,c,d,e,f,g,h,i,j){var _=this
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
dr:function dr(a){this.a=a
this.b=0},
i0:function i0(){},
h1:function h1(a,b){var _=this
_.e=_.d=_.c=_.b=null
_.r=_.f=0
_.x=_.w=$
_.y=a
_.z=b},
jj:function jj(){this.r=this.f=$},
h2:function h2(a,b,c,d,e,f,g,h,i){var _=this
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
nx(){return new A.jf(268435456)},
jf:function jf(a){this.a=a},
jg:function jg(a,b,c){this.a=a
this.b=b
this.c=c},
pT(a,b){return a>0?a:a+B.a.X(1,b)-1},
je:function je(a,b){this.a=a
this.b=b},
jh:function jh(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.w=_.r=_.f=_.e=$
_.x=e
_.y=f
_.z=g
_.Q=null
_.at=_.as=0},
kV:function kV(a,b){this.a=a
this.b=b},
d9:function d9(a,b){this.a=a
this.b=b},
et:function et(a,b){this.a=a
this.b=b},
eu:function eu(){},
fR:function fR(a,b,c,d,e,f,g,h,i){var _=this
_.y=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i},
bE:function bE(a,b){this.a=a
this.b=b},
jC:function jC(){},
j8:function j8(a,b,c){var _=this
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
nG(a){var s=t.N,r=A.m([],t.dm),q=A.m([],t.t),p=a==null?268435456:a
return new A.jy(new A.j8(A.D(s,s),r,q),p)},
jy:function jy(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=0
_.e=$
_.f=0},
jB:function jB(a,b){this.a=a
this.b=b},
jz:function jz(a,b){this.a=a
this.b=b},
jA:function jA(a,b,c){this.a=a
this.b=b
this.c=c},
i2:function i2(){},
bF:function bF(a,b){this.a=a
this.b=b},
cm:function cm(a){this.b=this.a=0
this.e=a},
jD:function jD(a,b){var _=this
_.b=_.a=null
_.c=a
_.d=b},
jG:function jG(a,b,c){this.a=a
this.b=b
this.c=c},
jH:function jH(a,b){this.a=a
this.b=b},
jF:function jF(a,b){this.a=a
this.b=b},
jE:function jE(){},
hj:function hj(){this.a=null},
hk:function hk(){this.a=null},
bb:function bb(){},
hm:function hm(){this.a=null},
hn:function hn(){this.a=null},
hq:function hq(){this.a=null},
hr:function hr(){this.a=null},
ev:function ev(a){this.b=a},
hp:function hp(){},
jI:function jI(){var _=this
_.w=_.r=_.f=_.e=$},
dd:function dd(a){this.a=a
this.c=null},
nL(a,b){var s=A.m([],t.l),r=b==null?268435456:b
r=new A.jN(s,A.D(t.p,t.fh),a.length,r)
r.hM(a,b)
return r},
m9(a,b,c,d){var s=a/255,r=b/255,q=c/255,p=d/255,o=r*(1-q),n=s*(1-p)
return B.b.h(B.b.I((2*s<q?2*r*s+o+n:p*q-2*(q-s)*(p-r)+o+n)*255,0,255))},
jO(a,b){if(b===0)return 0
return B.a.h(B.a.I(B.b.h(255*(1-(1-a/255)/(b/255))),0,255))},
jQ(a,b){return B.a.h(B.a.I(a+b-255,0,255))},
mb(a,b){return B.a.h(B.a.I(255-(255-b)*(255-a),0,255))},
jP(a,b){if(b===255)return 255
return B.b.h(B.b.I(a/255/(1-b/255)*255,0,255))},
mc(a,b){var s=a/255,r=b/255,q=1-r
return B.b.aE(255*(q*r*s+r*(1-q*(1-s))))},
m7(a,b){var s=b/255,r=a/255
if(r<0.5)return B.b.aE(510*s*r)
else return B.b.aE(255*(1-2*(1-s)*(1-r)))},
md(a,b){if(b<128)return A.jO(a,2*b)
else return A.jP(a,2*(b-128))},
m8(a,b){var s
if(b<128)return A.jQ(a,2*b)
else{s=2*(b-128)
return s+a>255?255:a+s}},
ma(a,b){return b<128?Math.min(a,2*b):Math.max(a,2*(b-128))},
m6(a,b){return B.b.aE(b+a-2*b*a/255)},
aA(a,b,c){var s
if(a==null)s=0
else s=c===1?a[b]:(a[b]<<8|a[b+1])>>>8
return s},
nM(b7,b8,b9,c0,c1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=null,b6=A.D(t.p,t.fW)
for(s=c1.length,r=0;q=c1.length,r<q;c1.length===s||(0,A.a0)(c1),++r){p=c1[r]
b6.m(0,p.a,p)}if(b8===8)o=1
else o=b8===16?2:-1
n=A.Q(b5,b5,B.e,0,B.i,c0,b5,0,q,b5,B.e,b9,!1)
if(o===-1)throw A.e(A.j("PSD: unsupported bit depth: "+A.x(b8)))
m=b6.k(0,0)
l=b6.k(0,1)
k=b6.k(0,2)
j=b6.k(0,-1)
i=A.m([0,0,0],t.t)
h=-o
for(s=n.a,s=s.gG(s),g=q>=5,f=q===4,e=q>=2,q=q>=4;s.E();){d=s.gK()
h+=o
switch(b7){case B.bD:d.sq(A.aA(m.c,h,o))
d.su(A.aA(l.c,h,o))
d.sv(A.aA(k.c,h,o))
d.st(q?A.aA(j.c,h,o):255)
if(d.gt()!==0){d.sq((d.gq()+d.gt()-255)*255/d.gt())
d.su((d.gu()+d.gt()-255)*255/d.gt())
d.sv((d.gv()+d.gt()-255)*255/d.gt())}break
case B.bF:c=A.aA(m.c,h,o)
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
b0=[B.b.aE(B.b.I(a7*255,0,255)),B.b.aE(B.b.I(a8*255,0,255)),B.b.aE(B.b.I(a9*255,0,255))]
d.sq(b0[0])
d.su(b0[1])
d.sv(b0[2])
d.st(a0)
break
case B.bC:b1=A.aA(m.c,h,o)
a0=e?A.aA(j.c,h,o):255
d.sq(b1)
d.su(b1)
d.sv(b1)
d.st(a0)
break
case B.bE:b2=A.aA(m.c,h,o)
b3=A.aA(l.c,h,o)
a1=A.aA(k.c,h,o)
b4=A.aA(b6.k(0,f?-1:3).c,h,o)
a0=g?A.aA(j.c,h,o):255
A.ox(255-b2,255-b3,255-a1,255-b4,i)
d.sq(i[0])
d.su(i[1])
d.sv(i[2])
d.st(a0)
break
default:throw A.e(A.j("Unhandled color mode: "+A.x(b7)))}}return n},
b5:function b5(a,b){this.a=a
this.b=b},
jN:function jN(a,b,c,d){var _=this
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
hl:function hl(){},
ho:function ho(a,b,c){var _=this
_.b=_.a=null
_.f=_.e=_.d=_.c=$
_.r=null
_.as=_.y=_.w=$
_.ay=a
_.ch=b
_.cx=null
_.cy=c},
qn(a,b){var s
switch(a){case"lsct":s=b.c-b.d
b.j()
if(s>=12){if(b.aj(4)!=="8BIM")A.Y(A.j("Invalid key in layer additional data"))
b.aj(4)}if(s>=16)b.j()
return new A.hp()
default:return new A.ev(b)}},
de:function de(){},
jJ:function jJ(a){this.a=null
this.b=a},
jL:function jL(a,b,c){this.a=a
this.b=b
this.c=c},
jM:function jM(a,b){this.a=a
this.b=b},
jK:function jK(a,b){this.a=a
this.b=b},
ht:function ht(){},
dg:function dg(a,b,c){this.a=a
this.b=b
this.c=c},
am:function am(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ew:function ew(){var _=this
_.Q=_.z=_.y=_.f=_.d=_.b=_.a=0},
df:function df(a){var _=this
_.b=0
_.c=a
_.Q=_.r=_.f=0},
hs:function hs(){this.y=this.b=this.a=0},
bm(a,b){return(B.a6[a>>>8]<<17|B.a6[b>>>8]<<16|B.a6[a&255]<<1|B.a6[b&255])>>>0},
aQ:function aQ(a){var _=this
_.a=a
_.b=0
_.c=!1
_.d=0
_.e=!1
_.f=0
_.r=!1},
jR:function jR(a){this.b=this.a=null
this.c=a},
jU:function jU(a,b){this.a=a
this.b=b},
jS:function jS(a,b){this.a=a
this.b=b},
jT:function jT(a,b,c){this.a=a
this.b=b
this.c=c},
hw:function hw(a){var _=this
_.b=_.a=0
_.c=a
_.Q=_.z=_.y=_.x=_.f=_.e=0
_.as=null
_.ax=0},
an:function an(a,b){this.a=a
this.b=b},
k2:function k2(a){this.a=null
this.b=$
this.c=a},
k4:function k4(a,b,c){this.a=a
this.b=b
this.c=c},
k5:function k5(a,b){this.a=a
this.b=b},
k3:function k3(a,b){this.a=a
this.b=b},
k6:function k6(a){this.a=a
this.c=this.b=0},
hx:function hx(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.f=e},
mf(a,b,c){var s=new A.ka(b,a),r=t.I
s.e=A.a3(b,null,!1,r)
s.f=A.a3(b,null,!1,r)
return s},
ka:function ka(a,b){var _=this
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
hy:function hy(a,b,c,d){var _=this
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
co:function co(a,b){this.a=a
this.b=b},
a4:function a4(a,b){this.a=a
this.b=b},
aS:function aS(a,b){this.a=a
this.b=b},
kb:function kb(a){var _=this
_.b=_.a=0
_.d=null
_.f=a},
nD(){return new A.jp(new Uint8Array(4096))},
jp:function jp(a){var _=this
_.a=9
_.d=_.c=_.b=0
_.w=_.r=_.f=_.e=$
_.x=a
_.z=_.y=$
_.Q=null
_.as=$},
k7:function k7(a){this.a=null
this.c=$
this.d=a},
k8:function k8(a,b){this.a=a
this.b=b},
k9:function k9(a,b,c){this.a=a
this.b=b
this.c=c},
mg(a,b){var s=new Int32Array(4),r=new Int32Array(4),q=new Int8Array(4),p=new Int8Array(4),o=A.a3(8,null,!1,t.eW),n=A.a3(4,null,!1,t.dP)
return new A.kg(a,b,new A.ko(),new A.kr(),new A.ki(s,r),new A.kt(q,p),o,n,new Uint8Array(4))},
ao(a,b,c,d,e){var s,r,q
for(s=a.$flags|0,r=0;r<e;++r){q=c[d+r]
s&2&&A.a(a)
a[b+r]=q}},
nW(a,b,c){if(c===0)if(a===0)return b===0?6:5
else return b===0?4:0
return c},
kg:function kg(a,b,c,d,e,f,g,h,i){var _=this
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
_.cr=$
_.bL=null
_.e5=$
_.e6=_.fU=null
_.e7=$},
nU(a){var s=new A.eH(a)
s.b=254
s.c=0
s.d=-8
return s},
eH:function eH(a){var _=this
_.a=a
_.d=_.c=_.b=$
_.e=!1},
B(a,b,c){return B.a.aJ(B.a.i(a+2*b+c+2,2),32)},
qG(a){var s,r=A.m([A.B(J.c(a.a,a.d+-33),J.c(a.a,a.d+-32),J.c(a.a,a.d+-31)),A.B(J.c(a.a,a.d+-32),J.c(a.a,a.d+-31),J.c(a.a,a.d+-30)),A.B(J.c(a.a,a.d+-31),J.c(a.a,a.d+-30),J.c(a.a,a.d+-29)),A.B(J.c(a.a,a.d+-30),J.c(a.a,a.d+-29),J.c(a.a,a.d+-28))],t.t)
for(s=0;s<4;++s)a.d9(s*32,4,r)},
qy(a){var s=J.c(a.a,a.d+-33),r=J.c(a.a,a.d+-1),q=J.c(a.a,a.d+31),p=J.c(a.a,a.d+63),o=J.c(a.a,a.d+95),n=A.r(a,null,0),m=n.dj(),l=A.B(s,r,q)
m.$flags&2&&A.a(m)
m[0]=16843009*l
n.d+=32
l=n.dj()
m=A.B(r,q,p)
l.$flags&2&&A.a(l)
l[0]=16843009*m
n.d+=32
m=n.dj()
l=A.B(q,p,o)
m.$flags&2&&A.a(m)
m[0]=16843009*l
n.d+=32
l=n.dj()
m=A.B(p,o,o)
l.$flags&2&&A.a(l)
l[0]=16843009*m},
qw(a){var s,r,q,p
for(s=4,r=0;r<4;++r)s+=J.c(a.a,a.d+(r-32))+J.c(a.a,a.d+(-1+r*32))
s=B.a.i(s,3)
for(r=0;r<4;++r){q=a.a
p=a.d+r*32
J.dD(q,p,p+4,s)}},
mh(a,b){var s,r,q,p,o,n=255-J.c(a.a,a.d+-33)
for(s=0,r=0;r<b;++r){q=n+J.c(a.a,a.d+(s-1))
for(p=0;p<b;++p){o=$.lB()[q+J.c(a.a,a.d+(-32+p))]
J.W(a.a,a.d+(s+p),o)}s+=32}},
qE(a){A.mh(a,4)},
qF(a){A.mh(a,8)},
qD(a){A.mh(a,16)},
qC(a){var s,r=J.c(a.a,a.d+-1),q=J.c(a.a,a.d+31),p=J.c(a.a,a.d+63),o=J.c(a.a,a.d+95),n=J.c(a.a,a.d+-33),m=J.c(a.a,a.d+-32),l=J.c(a.a,a.d+-31),k=J.c(a.a,a.d+-30),j=J.c(a.a,a.d+-29)
a.m(0,96,A.B(q,p,o))
s=A.B(r,q,p)
a.m(0,97,s)
a.m(0,64,s)
s=A.B(n,r,q)
a.m(0,98,s)
a.m(0,65,s)
a.m(0,32,s)
s=A.B(m,n,r)
a.m(0,99,s)
a.m(0,66,s)
a.m(0,33,s)
a.m(0,0,s)
s=A.B(l,m,n)
a.m(0,67,s)
a.m(0,34,s)
a.m(0,1,s)
s=A.B(k,l,m)
a.m(0,35,s)
a.m(0,2,s)
a.m(0,3,A.B(j,k,l))},
qB(a){var s,r=J.c(a.a,a.d+-32),q=J.c(a.a,a.d+-31),p=J.c(a.a,a.d+-30),o=J.c(a.a,a.d+-29),n=J.c(a.a,a.d+-28),m=J.c(a.a,a.d+-27),l=J.c(a.a,a.d+-26),k=J.c(a.a,a.d+-25)
a.m(0,0,A.B(r,q,p))
s=A.B(q,p,o)
a.m(0,32,s)
a.m(0,1,s)
s=A.B(p,o,n)
a.m(0,64,s)
a.m(0,33,s)
a.m(0,2,s)
s=A.B(o,n,m)
a.m(0,96,s)
a.m(0,65,s)
a.m(0,34,s)
a.m(0,3,s)
s=A.B(n,m,l)
a.m(0,97,s)
a.m(0,66,s)
a.m(0,35,s)
s=A.B(m,l,k)
a.m(0,98,s)
a.m(0,67,s)
a.m(0,99,A.B(l,k,k))},
qI(a){var s=J.c(a.a,a.d+-1),r=J.c(a.a,a.d+31),q=J.c(a.a,a.d+63),p=J.c(a.a,a.d+-33),o=J.c(a.a,a.d+-32),n=J.c(a.a,a.d+-31),m=J.c(a.a,a.d+-30),l=J.c(a.a,a.d+-29),k=B.a.aJ(B.a.i(p+o+1,1),32)
a.m(0,65,k)
a.m(0,0,k)
k=B.a.aJ(B.a.i(o+n+1,1),32)
a.m(0,66,k)
a.m(0,1,k)
k=B.a.aJ(B.a.i(n+m+1,1),32)
a.m(0,67,k)
a.m(0,2,k)
a.m(0,3,B.a.aJ(B.a.i(m+l+1,1),32))
a.m(0,96,A.B(q,r,s))
a.m(0,64,A.B(r,s,p))
k=A.B(s,p,o)
a.m(0,97,k)
a.m(0,32,k)
k=A.B(p,o,n)
a.m(0,98,k)
a.m(0,33,k)
k=A.B(o,n,m)
a.m(0,99,k)
a.m(0,34,k)
a.m(0,35,A.B(n,m,l))},
qH(a){var s,r=J.c(a.a,a.d+-32),q=J.c(a.a,a.d+-31),p=J.c(a.a,a.d+-30),o=J.c(a.a,a.d+-29),n=J.c(a.a,a.d+-28),m=J.c(a.a,a.d+-27),l=J.c(a.a,a.d+-26),k=J.c(a.a,a.d+-25)
a.m(0,0,B.a.aJ(B.a.i(r+q+1,1),32))
s=B.a.aJ(B.a.i(q+p+1,1),32)
a.m(0,64,s)
a.m(0,1,s)
s=B.a.aJ(B.a.i(p+o+1,1),32)
a.m(0,65,s)
a.m(0,2,s)
s=B.a.aJ(B.a.i(o+n+1,1),32)
a.m(0,66,s)
a.m(0,3,s)
a.m(0,32,A.B(r,q,p))
s=A.B(q,p,o)
a.m(0,96,s)
a.m(0,33,s)
s=A.B(p,o,n)
a.m(0,97,s)
a.m(0,34,s)
s=A.B(o,n,m)
a.m(0,98,s)
a.m(0,35,s)
a.m(0,67,A.B(n,m,l))
a.m(0,99,A.B(m,l,k))},
qz(a){var s,r=J.c(a.a,a.d+-1),q=J.c(a.a,a.d+31),p=J.c(a.a,a.d+63),o=J.c(a.a,a.d+95)
a.m(0,0,B.a.aJ(B.a.i(r+q+1,1),32))
s=B.a.aJ(B.a.i(q+p+1,1),32)
a.m(0,32,s)
a.m(0,2,s)
s=B.a.aJ(B.a.i(p+o+1,1),32)
a.m(0,64,s)
a.m(0,34,s)
a.m(0,1,A.B(r,q,p))
s=A.B(q,p,o)
a.m(0,33,s)
a.m(0,3,s)
s=A.B(p,o,o)
a.m(0,65,s)
a.m(0,35,s)
a.m(0,99,o)
a.m(0,98,o)
a.m(0,97,o)
a.m(0,96,o)
a.m(0,66,o)
a.m(0,67,o)},
qx(a){var s=J.c(a.a,a.d+-1),r=J.c(a.a,a.d+31),q=J.c(a.a,a.d+63),p=J.c(a.a,a.d+95),o=J.c(a.a,a.d+-33),n=J.c(a.a,a.d+-32),m=J.c(a.a,a.d+-31),l=J.c(a.a,a.d+-30),k=B.a.aJ(B.a.i(s+o+1,1),32)
a.m(0,34,k)
a.m(0,0,k)
k=B.a.aJ(B.a.i(r+s+1,1),32)
a.m(0,66,k)
a.m(0,32,k)
k=B.a.aJ(B.a.i(q+r+1,1),32)
a.m(0,98,k)
a.m(0,64,k)
a.m(0,96,B.a.aJ(B.a.i(p+q+1,1),32))
a.m(0,3,A.B(n,m,l))
a.m(0,2,A.B(o,n,m))
k=A.B(s,o,n)
a.m(0,35,k)
a.m(0,1,k)
k=A.B(r,s,o)
a.m(0,67,k)
a.m(0,33,k)
k=A.B(q,r,s)
a.m(0,99,k)
a.m(0,65,k)
a.m(0,97,A.B(p,q,r))},
qT(a){var s
for(s=0;s<16;++s)a.c9(s*32,16,a,-32)},
qR(a){var s,r,q,p,o
for(s=0,r=16;r>0;--r){q=J.c(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.dD(p,o,o+16,q)
s+=32}},
km(a,b){var s,r,q
for(s=0;s<16;++s){r=b.a
q=b.d+s*32
J.dD(r,q,q+16,a)}},
qJ(a){var s,r
for(s=16,r=0;r<16;++r)s+=J.c(a.a,a.d+(-1+r*32))+J.c(a.a,a.d+(r-32))
A.km(B.a.i(s,5),a)},
qL(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.c(a.a,a.d+(-1+r*32))
A.km(B.a.i(s,4),a)},
qK(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.c(a.a,a.d+(r-32))
A.km(B.a.i(s,4),a)},
qM(a){A.km(128,a)},
qU(a){var s
for(s=0;s<8;++s)a.c9(s*32,8,a,-32)},
qS(a){var s,r,q,p,o
for(s=0,r=0;r<8;++r){q=J.c(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.dD(p,o,o+8,q)
s+=32}},
kn(a,b){var s,r,q
for(s=0;s<8;++s){r=b.a
q=b.d+s*32
J.dD(r,q,q+8,a)}},
qN(a){var s,r
for(s=8,r=0;r<8;++r)s+=J.c(a.a,a.d+(r-32))+J.c(a.a,a.d+(-1+r*32))
A.kn(B.a.i(s,4),a)},
qO(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.c(a.a,a.d+(r-32))
A.kn(B.a.i(s,3),a)},
qP(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.c(a.a,a.d+(-1+r*32))
A.kn(B.a.i(s,3),a)},
qQ(a){A.kn(128,a)},
kj(a,b){return B.a.i(a*b+1073741824,16)-16384},
kk(a,b,c,d,e){var s=b+c+d*32
a.m(0,s,A.qv(J.c(a.a,a.d+s)+(B.a.i(e+65536,3)-8192)))},
kl(a,b,c,d,e){A.kk(a,0,0,b,c+d)
A.kk(a,0,1,b,c+e)
A.kk(a,0,2,b,c-e)
A.kk(a,0,3,b,c-d)},
qA(){var s,r,q,p
if(!$.nV){for(s=-255;s<=255;++s){r=$.mN()
q=255+s
p=s<0?-s:s
r.$flags&2&&A.a(r)
r[q]=p
p=$.mO()
r=B.a.i(r[q],1)
p.$flags&2&&A.a(p)
p[q]=r}for(s=-1020;s<=1020;++s){r=$.mP()
if(s<-128)q=-128
else q=s>127?127:s
r.$flags&2&&A.a(r)
r[1020+s]=q}for(s=-112;s<=112;++s){r=$.mQ()
if(s<-16)q=-16
else q=s>15?15:s
r.$flags&2&&A.a(r)
r[112+s]=q}for(s=-255;s<=510;++s){r=$.lB()
if(s<0)q=0
else q=s>255?255:s
r.$flags&2&&A.a(r)
r[255+s]=q}$.nV=!0}},
qv(a){var s
if((a&-256)>>>0===0)s=a
else s=a<0?0:255
return s},
kh:function kh(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
qu(){var s,r=J.al(3,t.D)
for(s=0;s<3;++s)r[s]=new Uint8Array(11)
return new A.eG(r)},
r9(){var s,r,q,p,o=new Uint8Array(3),n=J.al(4,t.c7)
for(s=t.dd,r=0;r<4;++r){q=J.al(8,s)
for(p=0;p<8;++p)q[p]=A.qu()
n[r]=q}B.c.ao(o,0,3,255)
return new A.ks(o,n)},
ko:function ko(){this.d=$},
kr:function kr(){},
kt:function kt(a,b){var _=this
_.b=_.a=!1
_.c=!0
_.d=a
_.e=b},
eG:function eG(a){this.a=a},
ks:function ks(a,b){this.a=a
this.b=b},
ki:function ki(a,b){var _=this
_.a=$
_.b=null
_.d=_.c=$
_.e=a
_.f=b},
bI:function bI(){var _=this
_.b=_.a=0
_.c=!1
_.d=0},
hG:function hG(){this.b=this.a=0},
hI:function hI(a,b,c){this.a=a
this.b=b
this.c=c},
hH:function hH(a,b){var _=this
_.a=a
_.b=$
_.c=b
_.e=_.d=null
_.f=$},
hJ:function hJ(a,b,c){this.a=a
this.b=b
this.c=c},
mi(a,b){var s,r=A.m([],t.Z),q=A.m([],t.d),p=new Uint32Array(2),o=new A.hE(a,p)
p=o.e=J.a2(B.l.gA(p),0,null)
s=a.F()
p.$flags&2&&A.a(p)
p[0]=s
s=a.F()
p.$flags&2&&A.a(p)
p[1]=s
s=a.F()
p.$flags&2&&A.a(p)
p[2]=s
s=a.F()
p.$flags&2&&A.a(p)
p[3]=s
s=a.F()
p.$flags&2&&A.a(p)
p[4]=s
s=a.F()
p.$flags&2&&A.a(p)
p[5]=s
s=a.F()
p.$flags&2&&A.a(p)
p[6]=s
s=a.F()
p.$flags&2&&A.a(p)
p[7]=s
o.b=!1
return new A.eI(o,b,r,q)},
bJ(a,b){return B.a.i(a+B.a.N(1,b)-1,b)},
eI:function eI(a,b,c,d){var _=this
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
fS:function fS(a,b,c,d){var _=this
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
hE:function hE(a,b){var _=this
_.a=0
_.b=!0
_.c=a
_.d=b
_.e=$},
kp:function kp(a,b){this.a=a
this.b=b},
bt(a,b){return((a^b)>>>1&2139062143)+((a&b)>>>0)},
cr(a){if(a<0)return 0
if(a>255)return 255
return a},
kq(a,b,c){return Math.abs(b-c)-Math.abs(a-c)},
qV(a,b,c){return 4278190080},
qW(a,b,c){return a},
r0(a,b,c){return b[c]},
r1(a,b,c){return b[c+1]},
r2(a,b,c){return b[c-1]},
r3(a,b,c){var s=b[c]
return A.bt(A.bt(a,b[c+1]),s)},
r4(a,b,c){return A.bt(a,b[c-1])},
r5(a,b,c){return A.bt(a,b[c])},
r6(a,b,c){return A.bt(b[c-1],b[c])},
r7(a,b,c){return A.bt(b[c],b[c+1])},
qX(a,b,c){var s=b[c-1],r=b[c],q=b[c+1]
return A.bt(A.bt(a,s),A.bt(r,q))},
qY(a,b,c){var s=b[c],r=b[c-1]
return A.kq(s>>>24,a>>>24,r>>>24)+A.kq(s>>>16&255,a>>>16&255,r>>>16&255)+A.kq(s>>>8&255,a>>>8&255,r>>>8&255)+A.kq(s&255,a&255,r&255)<=0?s:a},
qZ(a,b,c){var s=b[c],r=b[c-1]
return(A.cr((a>>>24)+(s>>>24)-(r>>>24))<<24|A.cr((a>>>16&255)+(s>>>16&255)-(r>>>16&255))<<16|A.cr((a>>>8&255)+(s>>>8&255)-(r>>>8&255))<<8|A.cr((a&255)+(s&255)-(r&255)))>>>0},
r_(a,b,c){var s,r,q,p=b[c],o=b[c-1],n=A.bt(a,p)
p=n>>>24
s=n>>>16&255
r=n>>>8&255
q=n>>>0&255
return(A.cr(p+B.a.W(p-(o>>>24),2))<<24|A.cr(s+B.a.W(s-(o>>>16&255),2))<<16|A.cr(r+B.a.W(r-(o>>>8&255),2))<<8|A.cr(q+B.a.W(q-(o&255),2)))>>>0},
cq:function cq(a,b){this.a=a
this.b=b},
hF:function hF(a){var _=this
_.a=a
_.c=_.b=0
_.d=null
_.e=0},
ku:function ku(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.f=_.e=_.d=0
_.r=1
_.w=!1
_.x=$
_.y=!1},
eJ:function eJ(){},
fT:function fT(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.r=_.f=$
_.w=1
_.y=_.x=$},
lN(a){var s,r=J.bB(a,t.gj)
for(s=0;s<a;++s)r[s]=new A.fx()
return new A.dW(r,0)},
pH(){var s,r,q=J.al(5,t.fa)
for(s=0;s<5;++s)q[s]=A.lN(0)
r=J.al(64,t.ak)
for(s=0;s<64;++s)r[s]=new A.fy()
return new A.dV(q,r)},
fx:function fx(){this.b=this.a=0},
fy:function fy(){this.b=this.a=0},
dW:function dW(a,b){this.a=a
this.b=b},
dV:function dV(a,b){var _=this
_.a=a
_.b=!1
_.c=0
_.e=_.d=!1
_.f=b},
dX:function dX(){var _=this
_.b=_.a=null
_.e=_.d=0},
fz:function fz(a){this.a=a
this.b=null},
dl:function dl(a,b){this.a=a
this.b=b},
dm:function dm(a,b){var _=this
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
fU:function fU(a,b){var _=this
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
kv:function kv(a){this.a=null
this.b=a
this.c=null},
ky:function ky(a,b){this.a=a
this.b=b},
kw:function kw(a,b){this.a=a
this.b=b},
kx:function kx(a,b,c){this.a=a
this.b=b
this.c=c},
nf(a){return new A.bf(a.a,a.b,B.c.hr(a.c,0))},
fA:function fA(a,b){this.a=a
this.b=b},
bf:function bf(a,b,c){this.a=a
this.b=b
this.c=c},
Q(a,b,c,d,e,f,g,h,i,j,k,l,m){var s,r=null,q=new A.aw(r,r,r,a,h,e,d,0)
q.gaB().push(q)
if(l<0||f<0)A.Y(A.aZ("Invalid image dimensions "+l+"x"+f,r))
q.c=g
if(b!=null)q.e=A.dN(b)
s=!1
if(j==null)if(m)s=q.gJ()===B.u||q.gJ()===B.x||q.gJ()===B.y||q.gJ()===B.e||q.gJ()===B.m
q.eP(l,f,c,i,s?q.ih(c,k,i):j)
return q},
fG(a,b,c,d){var s,r,q,p,o=null,n=a.e
n=n==null?o:A.dN(n)
s=a.c
s=s==null?o:A.nf(s)
r=a.w
q=a.r
p=a.f
p=p==null?o:new A.b_(new Uint8Array(A.t(p.a)))
r=new A.aw(o,s,n,p,q,r,a.y,a.z)
r.hH(a,b,c,d)
return r},
aP(a,b,c){var s,r,q,p,o,n=null,m=a.a
m=m==null?n:m.b9(c)
s=a.e
s=s==null?n:A.dN(s)
r=a.c
r=r==null?n:A.nf(r)
q=a.w
p=a.r
o=a.f
o=o==null?n:new A.b_(new Uint8Array(A.t(o.a)))
q=new A.aw(m,r,s,o,p,q,a.y,a.z)
q.hG(a,b,c)
return q},
fw:function fw(a,b){this.a=a
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
iW:function iW(a,b){this.a=a
this.b=b},
iV:function iV(){},
ab:function ab(){},
pI(a,b,c){return new A.cU(new Uint16Array(a*b*c),a,b,c)},
cU:function cU(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
pJ(a,b,c){return new A.cV(new Float32Array(a*b*c),a,b,c)},
cV:function cV(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
e_:function e_(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
e0:function e0(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
e1:function e1(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
e2:function e2(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
cW:function cW(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
c4:function c4(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
cX:function cX(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
pK(a,b,c){return new A.cY(new Uint32Array(a*b*c),a,b,c)},
cY:function cY(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
cZ:function cZ(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
nq(a,b,c){return new A.d_(new Uint8Array(a*b*c),null,a,b,c)},
d_:function d_(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
e5:function e5(a,b){this.a=a
this.b=b},
jv:function jv(){},
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
hd:function hd(a,b,c){this.c=a
this.a=b
this.b=c},
he:function he(a,b,c){this.c=a
this.a=b
this.b=c},
hf:function hf(a,b,c){this.c=a
this.a=b
this.b=c},
hg:function hg(a,b,c){this.c=a
this.a=b
this.b=c},
nF(a){return new A.ba(new Uint8Array(A.t(a.c)),a.a,a.b)},
ba:function ba(a,b,c){this.c=a
this.a=b
this.b=c},
lZ(a){return new A.ca(-1,0,-a.c,a)},
ca:function ca(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m_(a){return new A.cb(-1,0,-a.c,a)},
cb:function cb(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m0(a){return new A.cc(-1,0,-a.c,a)},
cc:function cc(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m1(a){return new A.cd(-1,0,-a.c,a)},
cd:function cd(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m2(a){return new A.ce(-1,0,-a.c,a)},
ce:function ce(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m3(a){return new A.cf(-1,0,-a.c,a)},
cf:function cf(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
b4(a,b,c,d,e){a.a0(b-1,c)
return new A.jw(a,b,b+d-1,c+e-1)},
jw:function jw(a,b,c,d){var _=this
_.a=a
_.b=b
_.d=c
_.e=d},
eq(a){return new A.cg(-1,0,0,-1,0,a)},
cg:function cg(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
m4(a){return new A.ch(-1,0,-a.c,a)},
ch:function ch(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
er(a){return new A.ci(-1,0,0,-2,0,a)},
ci:function ci(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
m5(a){return new A.cj(-1,0,-a.c,a)},
cj:function cj(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
es(a){return new A.ck(-1,0,0,-(a.c<<2>>>0),a)},
ck:function ck(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
jx(a){return new A.cl(-1,0,-a.c,a)},
cl:function cl(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
F:function F(){},
ow(a,b){var s
if(b===B.X)s=A.aU(a)>0
else s=a.gJ()===B.e&&!a.gbB()
return s},
oJ(a,b){return b>=5&&b<=8?a.gS():a.gZ()},
oI(a,b){return b>=5&&b<=8?a.gZ():a.gS()},
ub(a,b,c,d,e,f,g,h,i,j,k,l){var s,r,q,p,o
if(!A.ow(a,c))return!1
s=a.U()
r=A.aU(a)
q=new A.l0(s,r,A.oJ(a,l),A.oI(a,l))
q.hR(a,l)
p=b.U()
o=b.a.gau()
if(c===B.X){if(A.aU(b)!==r)return!1
A.tt(q,p,o,d,e,f,g,j,k)
return!0}if(b.gJ()!==B.e||b.a.c!==a.a.c)return!1
switch(c.a){case 1:A.ts(q,p,o,d,e,f,g,h,i)
return!0
case 3:A.tq(q,p,o,d,e,f,g,h,i)
return!0
case 2:A.tr(q,p,o,d,e,f,g,h,i)
return!0
case 0:return!1}},
tt(a,b,c,d,a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g=a.b,f=a.a,e=new Int32Array(a1)
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
ts(a,b,a0,a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h=a.b,g=a.c-1,f=a.d-1,e=new Int32Array(a3),d=new Int32Array(a3),c=new Float64Array(a3)
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
A.tj(p,j+l*i,j+k*i,b,(a2+n)*a0+o,h,a3,e,d,c,m-l)}},
tj(a,b,c,d,e,a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f
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
tq(a6,a7,a8,a9,b0,b1,b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=a6.b,a4=new Int32Array(b1),a5=new Int32Array(b1)
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
A.tE(m,b+c*a+r*a0,d,a0,a3,o)}a1=1/(f*d)
for(e=0;e<a3;++e,g=a2){a2=g+1
d=B.b.h(o[e]*a1)
n&2&&A.a(a7)
a7[g]=d}}}},
tE(a,b,c,d,e,f){var s,r,q,p,o
for(s=f.$flags|0,r=0;r<c;++r,b+=d)for(q=0;q<e;++q){p=f[q]
o=a[b+q]
s&2&&A.a(f)
f[q]=p+o}},
tr(b6,b7,b8,b9,c0,c1,c2,c3,c4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=b6.b,b1=b6.a,b2=c1*4,b3=new Int32Array(b2),b4=new Uint8Array(b2),b5=new Float64Array(c1)
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
h[a2]=A.od(a5,b1[i[a7]+a6],b1[i[a7+1]+a6],b1[i[a7+2]+a6],b1[i[a7+3]+a6])}a8=A.od(c,h[0],h[1],h[2],h[3])
a9=a+1
if(a8<0)a0=0
else a0=a8>255?255:B.b.h(a8)
b2&2&&A.a(b7)
b7[a]=a0}}}},
od(a,b,c,d,e){var s=-b,r=a*a
return c+0.5*(a*(s+d)+r*(2*b-5*c+4*d-e)+r*a*(s+3*c-3*d+e))},
l0:function l0(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.r=_.f=_.e=$},
tP(f3,f4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,e0,e1,e2,e3,e4,e5,e6,e7,e8,e9,f0=null,f1="ifd0",f2={}
f2.a=s
f2.a=B.X
f3.gbB()
r=1
if(f3.gbj().k(0,f1).a.a5(274)&&f3.gbj().k(0,f1).gbC()!==1){q=f3.gbj().k(0,f1).gbC()
q.toString
if(q>=2&&q<=8&&B.k.kY(f3.gaB(),new A.lj(f2)))r=q
else f3=A.mA(f3)}p=A.oJ(f3,r)
o=A.oI(f3,r)
n=B.b.aE(f4*(o/p))
if(f4<=0)f4=B.b.aE(n*(p/o))
m=n
if(f4===p&&n===o)return r===1?A.aP(f3,!1,!1):A.mA(f3)
l=new Int32Array(f4)
for(k=0;k<f4;++k)l[k]=B.a.ab(k*p,f4)
j=new Int32Array(m)
for(i=0;i<m;++i)j[i]=B.a.ab(i*o,m)
h=f3.gaB().length
for(q=r>=5,g=t.g,f=r<=8,e=f0,d=0;d<h;++d){c=f3.x
b=(c===$?f3.x=A.m([],g):c)[d]
a=A.fG(b,n,!0,f4)
a0=e==null
if(!a0)e.b1(a)
if(a0)e=a
a0=q&&f
a1=b.a
if(a0){a0=a1==null?f0:a1.a
if(a0==null)a0=0}else{a0=a1==null?f0:a1.b
if(a0==null)a0=0}a2=a0/m
if(q&&f){a0=a1==null?f0:a1.b
if(a0==null)a0=0}else{a0=a1==null?f0:a1.a
if(a0==null)a0=0}a3=a0/f4
if(A.ub(b,a,f2.a,0,0,f4,m,a3,a2,l,j,r))continue
a0=f2.a
if(a0===B.cy){a4=b.af(0,0)
for(i=0;i<m;i=a6){a5=B.b.h(i*a2)
a6=i+1
a7=B.b.h(a6*a2)
if(a7===a5)++a7
for(k=0;k<f4;k=a9){a8=B.b.h(k*a3)
a9=k+1
b0=B.b.h(a9*a3)
if(b0===a8)++b0
for(b1=a5,b2=0,b3=0,b4=0,b5=0,b6=0;b1<a7;++b1)for(b7=a8;b7<b0;++b7,++b6){a0=b.a
if(a0!=null)a0.L(b7,b1,a4)
b2+=a4.gq()
b3+=a4.gu()
b4+=a4.gv()
b5+=a4.gt()}b8=1/b6
a0=a.a
if(a0!=null)a0.ak(k,i,b2*b8,b3*b8,b4*b8,b5*b8)}}}else if(a0===B.X){a0=b.a
if((a0==null?f0:a0.gR())!=null)for(i=0;i<m;++i){b9=j[i]
for(k=0;k<f4;++k){a0=l[k]
a1=b.a
a0=a1==null?f0:B.b.h(a1.aM(a0,b9).gM())
if(a0==null)a0=0
a1=a.a
if(a1!=null)a1.aF(k,i,a0)}}else{a4=b.af(0,0)
for(i=0;i<m;++i){b1=j[i]
for(k=0;k<f4;++k){a0=l[k]
a1=b.a
if(a1!=null)a1.L(a0,b1,a4)
a0=a4.gq()
a1=a4.gu()
c0=a4.gv()
c1=a4.gt()
c2=a.a
if(c2!=null)c2.ak(k,i,a0,a1,c0,c1)}}}}else if(a0===B.cx){c3=b.af(0,0)
c4=b.af(0,0)
c5=b.af(0,0)
c6=b.af(0,0)
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
if(a0!=null)a0.L(d4,d0,c3)
a0=b.a
if(a0!=null)a0.L(d4,d2,c4)
a0=b.a
if(a0!=null)a0.L(d6,d0,c5)
a0=b.a
if(a0!=null)a0.L(d6,d2,c6)
a0=c3.gq()
a1=c5.gq()
c0=c4.gq()
c1=c6.gq()
c2=c3.gu()
d7=c5.gu()
d8=c4.gu()
d9=c6.gu()
e0=c3.gv()
e1=c5.gv()
e2=c4.gv()
e3=c6.gv()
e4=c3.gt()
e5=c5.gt()
e6=c4.gt()
e7=c6.gt()
e8=a.a
if(e8!=null)e8.ak(k,i,a0+d5*(a1-a0+d1*(a0+c1-c0-a1))+d1*(c0-a0),c2+d5*(d7-c2+d1*(c2+d9-d8-d7))+d1*(d8-c2),e0+d5*(e1-e0+d1*(e0+e3-e2-e1))+d1*(e2-e0),e4+d5*(e5-e4+d1*(e4+e7-e6-e5))+d1*(e6-e4))}}}else for(i=0;i<m;++i){e9=i*a2
for(k=0;k<f4;++k)a.bP(k,i,b.ek(k*a3,e9,f2.a))}}if(r!==1)e.gbj().k(0,f1).sbC(f0)
e.toString
return e},
lj:function lj(a){this.a=a},
tU(a,b){switch(b.a){case 0:A.lo(a)
break
case 1:A.oB(a)
break
case 2:A.tV(a)
break}return a},
oB(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=null,a2=a3.gaB().length
for(s=t.g,r=0;r<a2;++r){q=a3.x
p=(q===$?a3.x=A.m([],s):q)[r]
o=p.a
n=o==null
m=n?a1:o.a
if(m==null)m=0
l=n?a1:o.b
if(l==null)l=0
k=B.a.W(l,2)
if(!n){j=J.C(o.gA(o))
if(j==null){o=p.a
o=o==null?a1:o.gA(o)
if(o==null)o=B.c.gA(new Uint8Array(0))
j=J.C(o)}i=p.a.gau()
h=new Uint8Array(i)
for(g=l-1,f=0;f<k;++f,--g){e=f*i
d=g*i
B.c.a1(h,0,i,j,e)
B.c.a1(j,e,e+i,j,d)
B.c.aI(j,d,d+i,h)}continue}o=a3.a
if((o==null?a1:o.gR())!=null)for(g=l-1,f=0;f<k;++f,--g)for(c=0;c<m;++c){o=p.a
b=o==null?a1:o.L(c,f,a1)
if(b==null)b=new A.F()
o=p.a
a=o==null?a1:o.L(c,g,a1)
if(a==null)a=new A.F()
a0=b.gM()
b.sM(a.gM())
a.sM(a0)}else for(g=l-1,f=0;f<k;++f,--g)for(c=0;c<m;++c){o=p.a
b=o==null?a1:o.L(c,f,a1)
if(b==null)b=new A.F()
o=p.a
a=o==null?a1:o.L(c,g,a1)
if(a==null)a=new A.F()
a0=b.gq()
b.sq(a.gq())
a.sq(a0)
a0=b.gu()
b.su(a.gu())
a.su(a0)
a0=b.gv()
b.sv(a.gv())
a.sv(a0)
a0=b.gt()
b.st(a.gt())
a.st(a0)}}return a3},
lo(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=null,a1=a2.gaB().length
for(s=t.g,r=0;r<a1;++r){q=a2.x
p=(q===$?a2.x=A.m([],s):q)[r]
o=p.a
n=o==null
m=n?a0:o.a
if(m==null)m=0
l=n?a0:o.b
if(l==null)l=0
k=B.a.W(m,2)
j=A.aU(p)
if(j>0){o=p.a
i=o==null?a0:J.C(o.gA(o))
if(i==null){o=p.a
o=o==null?a0:o.gA(o)
if(o==null)o=B.c.gA(new Uint8Array(0))
i=J.C(o)}h=p.a.gau()
for(g=0;g<l;++g)A.oM(i,g*h,m,j)
continue}o=a2.a
if((o==null?a0:o.gR())!=null)for(f=m-1,g=0;g<l;++g)for(e=f,d=0;d<k;++d,--e){o=p.a
c=o==null?a0:o.L(d,g,a0)
if(c==null)c=new A.F()
o=p.a
b=o==null?a0:o.L(e,g,a0)
if(b==null)b=new A.F()
a=c.gM()
c.sM(b.gM())
b.sM(a)}else for(f=m-1,g=0;g<l;++g)for(e=f,d=0;d<k;++d,--e){o=p.a
c=o==null?a0:o.L(d,g,a0)
if(c==null)c=new A.F()
o=p.a
b=o==null?a0:o.L(e,g,a0)
if(b==null)b=new A.F()
a=c.gq()
c.sq(b.gq())
b.sq(a)
a=c.gu()
c.su(b.gu())
b.su(a)
a=c.gv()
c.sv(b.gv())
b.sv(a)
a=c.gt()
c.st(b.gt())
b.st(a)}}return a2},
tV(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=null,a0=a1.gaB().length
for(s=t.g,r=0;r<a0;++r){q=a1.x
p=(q===$?a1.x=A.m([],s):q)[r]
o=p.a
n=o==null
m=n?a:o.a
if(m==null)m=0
l=n?a:o.b
if(l==null)l=0
k=A.aU(p)
if(k>0){o=p.a
o=o==null?a:J.C(o.gA(o))
if(o==null){o=p.a
o=o==null?a:o.gA(o)
if(o==null)o=B.c.gA(new Uint8Array(0))
o=J.C(o)}A.oM(o,0,m*l,k)
continue}o=p.a
if((o==null?a:o.gR())!=null)for(j=l-1,i=m-1,h=0;h<=j;++h,--j){g=h===j?B.a.W(m,2):m
for(f=i,e=0;e<g;++e,--f){o=p.a
d=o==null?a:o.L(e,h,a)
if(d==null)d=new A.F()
o=p.a
c=o==null?a:o.L(f,j,a)
if(c==null)c=new A.F()
b=d.gM()
d.sM(c.gM())
c.sM(b)}}else for(j=l-1,i=m-1,h=0;h<=j;++h,--j){g=h===j?B.a.W(m,2):m
for(f=i,e=0;e<g;++e,--f){o=p.a
d=o==null?a:o.L(e,h,a)
if(d==null)d=new A.F()
o=p.a
c=o==null?a:o.L(f,j,a)
if(c==null)c=new A.F()
b=d.gq()
d.sq(c.gq())
c.sq(b)
b=d.gu()
d.su(c.gu())
c.su(b)
b=d.gv()
d.sv(c.gv())
c.sv(b)
b=d.gt()
d.st(c.gt())
c.st(b)}}}return a1},
iC:function iC(a,b){this.a=a
this.b=b},
j(a){return new A.fH(a)},
fH:function fH(a){this.a=a},
q(a,b,c,d){var s=J.a6(a),r=s.gp(a)
s=c==null?s.gp(a):d+c
return new A.a8(a,d,Math.min(r,s),d,b)},
r(a,b,c){var s=a.a,r=a.d,q=J.by(s),p=b==null?a.c:a.d+c+b
return new A.a8(s,a.b,Math.min(q,p),r+c,a.e)},
a8:function a8(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
ep(a,b){return new A.jt(a,new Uint8Array(b))},
jt:function jt(a,b){this.a=0
this.b=a
this.c=b},
dh:function dh(a,b){this.a=a
this.b=b},
ja:function ja(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.r=$
_.w=f
_.x=g
_.$ti=h},
d1:function d1(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.e=d
_.f=e
_.r=f
_.$ti=g},
fX:function fX(a,b){this.a=a
this.b=b},
e6:function e6(a,b){this.a=a
this.b=b},
fV:function fV(a,b){this.a=a
this.$ti=b},
rl(a,b,c,d){var s=new A.hW(a,A.nP(d),c.n("@<0>").aG(d).n("hW<1,2>"))
s.hQ(a,b,c,d)
return s},
fW:function fW(a,b){this.a=a
this.$ti=b},
hW:function hW(a,b,c){this.a=a
this.c=b
this.$ti=c},
kY:function kY(a,b){this.a=a
this.b=b},
hV:function hV(){},
lv(a,b,c,d){var s=0,r=A.my(t.H),q,p
var $async$lv=A.mz(function(e,f){if(e===1)return A.mr(f,r)
for(;;)switch(s){case 0:p=v.G.self
p=J.lE(p)===B.bL?A.rl(A.oc(p),null,c,d):A.pM(p,A.oF(A.oy(),c),!1,null,A.oF(A.oy(),c),c,d)
q=A.o_(null,t.H)
s=2
return A.mq(q,$async$lv)
case 2:p.gec().h1(new A.lw(a,new A.fV(new A.fW(p,c.n("@<0>").aG(d).n("fW<1,2>")),c.n("@<0>").aG(d).n("fV<1,2>")),d,c))
p.e8()
return A.ms(null,r)}})
return A.mt($async$lv,r)},
lw:function lw(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
iZ:function iZ(){},
lQ(a,b,c){return new A.ax(c,a,b)},
pN(a){var s,r,q,p=A.mp(a.k(0,"name")),o=t.O.a(a.k(0,"value")),n=o.k(0,"e")
if(n==null)n=A.ld(n)
s=new A.f_(A.mp(o.k(0,"s")))
for(r=0;r<2;++r){q=$.pO[r].$2(n,s)
if(q.gda()===p)return q}return new A.ax("",n,s)},
qt(a,b){return new A.cp("",a,b)},
nT(a,b){return new A.cp("",a,b)},
ax:function ax(a,b,c){this.a=a
this.b=b
this.c=c},
cp:function cp(a,b,c){this.a=a
this.b=b
this.c=c},
fF(a,b){var s
A:{if(b.b(a)){s=a
break A}if(typeof a=="number"){s=new A.fD(a)
break A}if(typeof a=="string"){s=new A.fE(a)
break A}if(A.i7(a)){s=new A.fC(a)
break A}if(t.Y.b(a)){s=new A.dY(J.n_(a,new A.iT(),t.f),B.hT)
break A}if(t.O.b(a)){s=t.f
s=new A.dZ(a.eb(0,new A.iU(),s,s),B.jx)
break A}s=A.Y(A.qt("Unsupported type "+J.lE(a).B(0)+" when wrapping an IsolateType",B.J))}return b.a(s)},
M:function M(){},
iT:function iT(){},
iU:function iU(){},
fD:function fD(a){this.a=a},
fE:function fE(a){this.a=a},
fC:function fC(a){this.a=a},
dY:function dY(a,b){this.b=a
this.a=b},
dZ:function dZ(a,b){this.b=a
this.a=b},
bu:function bu(){},
kW:function kW(a){this.a=a},
ap:function ap(){},
kX:function kX(a){this.a=a},
qs(a){throw A.e(A.bc("Uint64List not supported on the web."))},
pL(a,b,c){return J.lD(a,b,c)},
nS(a,b){return J.au(a,b,null)},
pD(a){return J.mW(a,0,null)},
pE(a){return a.lF(0,0,null)},
oP(a){return v.mangledGlobalNames[a]},
cx(a,b){var s,r,q,p
if(t.D.b(a)&&a.length>=32)return A.rX(a,b)
s=J.a6(a)
r=s.gp(a)
b^=4294967295
for(q=0;r>=8;){p=q+1
b=B.v[(b^s.k(a,q))&255]^b>>>8
q=p+1
b=B.v[(b^s.k(a,p))&255]^b>>>8
p=q+1
b=B.v[(b^s.k(a,q))&255]^b>>>8
q=p+1
b=B.v[(b^s.k(a,p))&255]^b>>>8
p=q+1
b=B.v[(b^s.k(a,q))&255]^b>>>8
q=p+1
b=B.v[(b^s.k(a,p))&255]^b>>>8
p=q+1
b=B.v[(b^s.k(a,q))&255]^b>>>8
q=p+1
b=B.v[(b^s.k(a,p))&255]^b>>>8
r-=8}if(r>0)do{p=q+1
b=B.v[(b^s.k(a,q))&255]^b>>>8
if(--r,r>0){q=p
continue}else break}while(!0)
return(b^4294967295)>>>0},
rU(a){var s,r,q,p,o,n=new Uint32Array(8192)
for(s=0;s<256;++s)n[s]=a[s]
for(r=1;r<32;++r)for(q=(r-1)*256,p=r*256,s=0;s<256;++s){o=n[q+s]
n[p+s]=(o>>>8^n[o&255])>>>0}return n},
rX(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=$.ot
if(e==null)e=$.ot=A.rU(B.v)
s=a.length
r=J.pc(B.c.gA(a),a.byteOffset,s)
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
mC(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n,m,l
if(j==null)j=0
if(k==null)k=0
if(i==null)i=b.gZ()
if(h==null)h=b.gS()
if(e==null)e=a.gZ()<b.gZ()?a.gZ():b.gZ()
if(d==null)d=a.gS()<b.gS()?a.gS():b.gS()
s=c===B.a2
if(!s&&a.gbB())a=a.fS(a.gbO())
r=h/d
q=i/e
p=t.p
o=J.al(d,p)
for(n=0;n<d;++n)o[n]=k+B.b.h(n*r)
m=J.al(e,p)
for(l=0;l<e;++l)m[l]=j+B.b.h(l*q)
if(s)A.rZ(b,a,f,g,e,d,m,o,null,B.aF)
else A.rW(b,a,f,g,e,d,m,o,c,!1,null,B.aF)
return a},
rZ(a3,a4,a5,a6,a7,a8,a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a4.gZ(),a1=a4.gS(),a2=A.aU(a3)
if(a2>0&&A.aU(a4)===a2&&a3.gJ()===a4.gJ()&&a3.gbB()===a4.gbB()&&a5>=0&&a6>=0){s=a3.U()
r=a4.U()
q=a3.a.gau()
p=a4.a.gau()
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
d=a==null?null:a.L(m,e,d)
if(d==null)d=new A.F()
a4.bP(b,c,d)}},
rW(a,b,c,d,e,f,g,h,i,j,k,l){var s,r,q,p,o,n,m
for(s=null,r=0;r<f;++r)for(q=d+r,p=0;p<e;++p){o=g[p]
n=h[r]
m=a.a
s=m==null?null:m.L(o,n,s)
if(s==null)s=new A.F()
A.tS(b,c+p,q,s,i,!1,k,l)}},
tS(a8,a9,b0,b1,b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7
if(!a8.fX(a9,b0))return a8
if(b2===B.a2||a8.gbB())if(a8.fX(a9,b0)){a8.aM(a9,b0).aN(b1)
return a8}s=b1.gad()
r=b1.ga9()
q=b1.gac()
p=b1.gp(b1)<4?1:b1.gV()
if(p===0)return a8
o=a8.aM(a9,b0)
n=o.gad()
m=o.ga9()
l=o.gac()
k=o.gV()
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
o.sad((s*p+n*k*a5)*a7)
o.sa9((r*p+m*k*a5)*a7)
o.sac((q*p+l*k*a5)*a7)
o.sV(a6)
return a8},
oA(a,b,c,d,e,f,g){var s,r=B.b.I(Math.min(d,e),0,a.gZ()-1),q=B.b.I(Math.min(f,g),0,a.gS()-1),p=B.b.I(Math.max(d,e),0,a.gZ()-1),o=B.b.I(Math.max(f,g),0,a.gS()-1),n=a.a.b5(0,r,q,p-r+1,o-q+1)
for(s=n.a;n.E();)s.aN(c)
return a},
K(a){var s,r,q
try{r=a.$0()
return r}catch(q){s=A.ar(q)
if(s instanceof A.fH)throw q
throw A.e(A.j("Invalid image data: "+A.x(s)))}},
pA(a6,a7,a8,a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=b2<16384,a5=a8>b0?b0:a8
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
if(a4){A.dP(a6[e],a6[c],q)
a=q[0]
a0=q[1]
A.dP(a6[d],a6[b],q)
a1=q[0]
a2=q[1]
A.dP(a,a1,q)
a3=q[0]
p&2&&A.a(a6)
a6[e]=a3
a6[d]=q[1]
A.dP(a0,a2,q)
a6[c]=q[0]
a6[b]=q[1]}else{A.dQ(a6[e],a6[c],q)
a=q[0]
a0=q[1]
A.dQ(a6[d],a6[b],q)
a1=q[0]
a2=q[1]
A.dQ(a,a1,q)
a3=q[0]
p&2&&A.a(a6)
a6[e]=a3
a6[d]=q[1]
A.dQ(a0,a2,q)
a6[c]=q[0]
a6[b]=q[1]}}if(i){c=e+m
if(a4){A.dP(a6[e],a6[c],q)
a=q[0]
a3=q[1]
p&2&&A.a(a6)
a6[c]=a3}else{A.dQ(a6[e],a6[c],q)
a=q[0]
a3=q[1]
p&2&&A.a(a6)
a6[c]=a3}p&2&&A.a(a6)
a6[e]=a}}if((b0&s)>>>0!==0){f=g+h
for(e=g;e<=f;e+=j){d=e+k
if(a4){A.dP(a6[e],a6[d],q)
a=q[0]
i=q[1]
p&2&&A.a(a6)
a6[d]=i}else{A.dQ(a6[e],a6[d],q)
a=q[0]
i=q[1]
p&2&&A.a(a6)
a6[d]=i}p&2&&A.a(a6)
a6[e]=a}}r=s>>>1}},
dP(a,b,c){var s,r,q,p,o=$.aj()
o.$flags&2&&A.a(o)
o[0]=a
s=$.as()
r=s[0]
o[0]=b
q=s[0]
p=r+(q&1)+B.a.i(q,1)
c[0]=p
c[1]=p-q},
dQ(a,b,c){var s=a-B.a.i(b,1)&65535
c[1]=s
c[0]=b+s-32768&65535},
tT(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=null,f=268435456,e=A.nx()
if(e.aD(a))return e
s=A.nG(g)
if(s.aD(a))return s
r=new A.iF(f)
if(r.aD(a))return r
q=new A.kv(f)
if(q.aD(a))return q
p=new A.k7(f)
if(p.fj(A.q(a,!1,g,0),!0)!=null)return p
o=new A.jJ(f)
if(o.aD(a))return o
if(A.pz(a))return new A.iw(f)
n=A.pi(!1,g)
if(n.aD(a))return n
m=A.a3(A.pW(g),g,!1,t.dk)
l=new A.jD(new A.ec(m,t.ha),f)
if(l.aD(a))return l
k=new A.k2(f)
j=A.q(a,!1,g,0)
m=k.a=new A.hw(B.aa)
m.bD(j)
if(m.h_())return k
i=new A.iL(f)
if(i.aD(a))return i
h=new A.jR(f)
if(h.aD(a))return h
return g},
u9(b3,b4,b5,b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2
if($.mv==null){s=new Uint8Array(768)
for(r=0;r<256;++r)s[256+r]=r
for(r=256;r<512;++r)s[256+r]=255
$.mv=s}for(q=b7.$flags|0,r=0;r<64;++r){p=b4[b5+r]
o=b3[r]
q&2&&A.a(b7)
b7[r]=p*o}for(n=0,r=0;r<8;++r,n+=8){p=1+n
o=b7[p]
if(o===0&&b7[2+n]===0&&b7[3+n]===0&&b7[4+n]===0&&b7[5+n]===0&&b7[6+n]===0&&b7[7+n]===0){p=B.a.i(5793*b7[n]+512,10)
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
continue}l=B.a.i(5793*b7[n]+128,8)
k=(l&2147483647)-((l&2147483648)>>>0)
l=4+n
j=B.a.i(5793*b7[l]+128,8)
i=(j&2147483647)-((j&2147483648)>>>0)
j=2+n
h=b7[j]
g=6+n
f=b7[g]
e=7+n
d=b7[e]
c=B.a.i(2896*(o-d)+128,8)
b=(c&2147483647)-((c&2147483648)>>>0)
d=B.a.i(2896*(o+d)+128,8)
a=(d&2147483647)-((d&2147483648)>>>0)
d=3+n
o=b7[d]<<4
a0=(o&2147483647)-((o&2147483648)>>>0)
o=5+n
c=b7[o]<<4
a1=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.i(k-i+1,1)
m=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.i(k+i+1,1)
k=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.i(h*3784+f*1567+128,8)
c=(c&2147483647)-((c&2147483648)>>>0)
a2=B.a.i(h*1567-f*3784+128,8)
h=(a2&2147483647)-((a2&2147483648)>>>0)
a2=B.a.i(b-a1+1,1)
a2=(a2&2147483647)-((a2&2147483648)>>>0)
a3=B.a.i(b+a1+1,1)
b=(a3&2147483647)-((a3&2147483648)>>>0)
a3=B.a.i(a+a0+1,1)
a3=(a3&2147483647)-((a3&2147483648)>>>0)
a4=B.a.i(a-a0+1,1)
a0=(a4&2147483647)-((a4&2147483648)>>>0)
a4=B.a.i(k-c+1,1)
a4=(a4&2147483647)-((a4&2147483648)>>>0)
c=B.a.i(k+c+1,1)
k=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.i(m-h+1,1)
c=(c&2147483647)-((c&2147483648)>>>0)
a5=B.a.i(m+h+1,1)
i=(a5&2147483647)-((a5&2147483648)>>>0)
a5=B.a.i(b*2276+a3*3406+2048,12)
m=(a5&2147483647)-((a5&2147483648)>>>0)
a3=B.a.i(b*3406-a3*2276+2048,12)
b=(a3&2147483647)-((a3&2147483648)>>>0)
a3=B.a.i(a0*799+a2*4017+2048,12)
a3=(a3&2147483647)-((a3&2147483648)>>>0)
a2=B.a.i(a0*4017-a2*799+2048,12)
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
if(p===0&&b7[a7]===0&&b7[a8]===0&&b7[a9]===0&&b7[b0]===0&&b7[b1]===0&&b7[b2]===0){p=B.a.i(5793*b7[r]+8192,14)
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
continue}o=B.a.i(5793*b7[r]+2048,12)
k=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.i(5793*b7[a9]+2048,12)
i=(o&2147483647)-((o&2147483648)>>>0)
h=b7[a7]
f=b7[b1]
o=b7[b2]
l=B.a.i(2896*(p-o)+2048,12)
b=(l&2147483647)-((l&2147483648)>>>0)
o=B.a.i(2896*(p+o)+2048,12)
a=(o&2147483647)-((o&2147483648)>>>0)
a0=b7[a8]
a1=b7[b0]
o=B.a.i(k-i+1,1)
m=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.i(k+i+1,1)
k=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.i(h*3784+f*1567+2048,12)
p=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.i(h*1567-f*3784+2048,12)
h=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.i(b-a1+1,1)
o=(o&2147483647)-((o&2147483648)>>>0)
l=B.a.i(b+a1+1,1)
b=(l&2147483647)-((l&2147483648)>>>0)
l=B.a.i(a+a0+1,1)
l=(l&2147483647)-((l&2147483648)>>>0)
j=B.a.i(a-a0+1,1)
a0=(j&2147483647)-((j&2147483648)>>>0)
j=B.a.i(k-p+1,1)
j=(j&2147483647)-((j&2147483648)>>>0)
p=B.a.i(k+p+1,1)
k=(p&2147483647)-((p&2147483648)>>>0)
p=B.a.i(m-h+1,1)
p=(p&2147483647)-((p&2147483648)>>>0)
g=B.a.i(m+h+1,1)
i=(g&2147483647)-((g&2147483648)>>>0)
g=B.a.i(b*2276+l*3406+2048,12)
m=(g&2147483647)-((g&2147483648)>>>0)
l=B.a.i(b*3406-l*2276+2048,12)
b=(l&2147483647)-((l&2147483648)>>>0)
l=B.a.i(a0*799+o*4017+2048,12)
l=(l&2147483647)-((l&2147483648)>>>0)
o=B.a.i(a0*4017-o*799+2048,12)
a0=(o&2147483647)-((o&2147483648)>>>0)
q&2&&A.a(b7)
b7[r]=k+m
b7[b2]=k-m
b7[a6]=i+l
b7[b1]=i-l
b7[a7]=p+a0
b7[b0]=p-a0
b7[a8]=j+b
b7[a9]=j-b}for(q=$.mv,p=b6.$flags|0,r=0;r<64;++r){q.toString
o=B.a.i(b7[r]+8,4)
o=q[384+((o&2147483647)-((o&2147483648)>>>0))]
p&2&&A.a(b6)
b6[r]=o}},
f8(a,b){return(a&65535)*b+((a>>>16)*b&65535)*65536>>>0},
re(a,b,c,d,e,f){A.rb(f,a,b,c,d,e,!0,f)},
rf(a,b,c,d,e,f){A.rc(f,a,b,c,d,e,!0,f)},
rd(a,b,c,d,e,f){A.ra(f,a,b,c,d,e,!0,f)},
dk(a,b,c,d,e){var s,r,q
for(s=0;s<d;++s){r=J.c(a.a,a.d+s)
q=J.c(b.a,b.d+s)
J.W(c.a,c.d+s,r+q)}},
rb(a,b,c,d,e,f,g,h){var s,r,q=null,p=e*d,o=e+f,n=A.q(a,!1,q,p),m=A.q(h,!1,q,p),l=A.r(m,q,0)
if(e===0){m.m(0,0,J.c(n.a,n.d))
A.dk(A.r(n,q,1),l,A.r(m,q,1),b-1,!0)
l.d+=d
n.d+=d
m.d+=d
e=1}for(s=-d,r=b-1;e<o;){A.dk(n,A.r(l,q,s),m,1,!0)
A.dk(A.r(n,q,1),l,A.r(m,q,1),r,!0);++e
l.d+=d
n.d+=d
m.d+=d}},
rc(a,b,c,d,e,f,g,h){var s=null,r=e*d,q=e+f,p=A.q(a,!1,s,r),o=A.q(h,!1,s,r),n=A.r(o,s,0)
if(e===0){o.m(0,0,J.c(p.a,p.d))
A.dk(A.r(p,s,1),n,A.r(o,s,1),b-1,!0)
p.d+=d
o.d+=d
e=1}else n.d-=d
while(e<q){A.dk(p,n,o,b,!0);++e
n.d+=d
p.d+=d
o.d+=d}},
ra(a,b,c,d,e,f,g,h){var s,r,q,p,o,n=null,m=e*d,l=e+f,k=A.q(a,!1,n,m),j=A.q(h,!1,n,m),i=A.r(j,n,0)
if(e===0){j.m(0,0,J.c(k.a,k.d))
A.dk(A.r(k,n,1),i,A.r(j,n,1),b-1,!0)
i.d+=d
k.d+=d
j.d+=d
e=1}for(s=-d;e<l;){A.dk(k,A.r(i,n,s),j,1,!0)
for(r=1;r<b;++r){q=r-d
p=J.c(i.a,i.d+(r-1))+J.c(i.a,i.d+q)-J.c(i.a,i.d+(q-1))
if((p&4294967040)>>>0===0)o=p
else o=p<0?0:255
q=J.c(k.a,k.d+r)
J.W(j.a,j.d+r,q+o)}++e
i.d+=d
k.d+=d
j.d+=d}},
aU(a){var s,r,q,p=a.a
if(p==null)return 0
s=p.gb8()
if(s==null)s=0
r=s*p.c
if((r&7)!==0)return 0
q=B.a.i(r,3)
return p.gau()===a.gZ()*q?q:0},
uc(a,b,c,d){var s,r,q,p,o,n
for(s=a.$flags|0,r=0;r<d;++r){q=b+r
p=a[q]
o=c+r
n=a[o]
s&2&&A.a(a)
a[q]=n
a[o]=p}},
oM(a,b,c,d){var s,r
for(s=b+(c-1)*d,r=b;r<s;r+=d,s-=d)A.uc(a,r,s,d)},
mA(a){var s,r="ifd0"
if(!a.gbj().k(0,r).a.a5(274)||a.gbj().k(0,r).gbC()===1)return A.aP(a,!1,!1)
switch(a.gbj().k(0,r).gbC()){case 2:s=A.lo(A.aP(a,!1,!1))
break
case 3:s=A.tU(A.aP(a,!1,!1),B.co)
break
case 4:s=A.oB(A.aP(a,!1,!1))
break
case 5:s=A.lo(A.lk(a,90))
break
case 6:s=A.lk(a,90)
break
case 7:s=A.lo(A.lk(a,-90))
break
case 8:s=A.lk(a,-90)
break
default:s=A.aP(a,!1,!1)
break}s.e=A.dN(a.gbj())
s.gbj().k(0,r).sbC(null)
return s},
lk(b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=null,b0=B.a.a2(b2,360)
b1.gbB()
if(B.a.a2(b0,90)===0)switch(B.a.W(b0,90)){case 1:return A.tw(b1)
case 2:return A.tu(b1)
case 3:return A.tv(b1)
default:return A.aP(b1,!1,!1)}s=b0*3.141592653589793/180
r=Math.cos(s)
q=Math.sin(s)
p=b1.gZ()
o=b1.gZ()
n=b1.gS()
m=b1.gS()
l=0.5*b1.gZ()
k=0.5*b1.gS()
n=Math.abs(p*r)+Math.abs(n*q)
j=0.5*n
m=Math.abs(o*q)+Math.abs(m*r)
i=0.5*m
h=b1.gaB().length
for(p=t.g,g=b1.f,f=a9,e=0;e<h;++e){d=b1.x
c=(d===$?b1.x=A.m([],p):d)[e]
o=f==null
b=o?a9:f.d2()
if(b==null){a=B.b.h(n)
b=A.fG(b1,B.b.h(m),!0,a)}if(o)f=b
a0=c.f
if(a0==null)a0=g
if(a0!=null){o=b.a
if(o!=null)o.aO(0,a0)}for(o=b.a,o=o.gG(o);o.E();){a1=o.gK()
a2=a1.gaZ()
a3=a1.gaP()
a=a2-j
a4=a3-i
a5=l+a*r+a4*q
a6=k-a*q+a4*r
a=!1
if(a5>=0)if(a6>=0){a4=c.a
a7=a4==null
a8=a7?a9:a4.a
if(a5<(a8==null?0:a8)){a=a7?a9:a4.b
a=a6<(a==null?0:a)}}if(a)b.bP(a2,a3,c.ek(a5,a6,B.X))}}f.toString
return f},
tw(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=null
for(s=a.gaB(),r=s.length,q=b,p=0;p<s.length;s.length===r||(0,A.a0)(s),++p){o=s[p]
n=q==null
m=n?b:q.d2()
if(m==null){l=o.a
k=l==null
j=k?b:l.b
if(j==null)j=0
l=k?b:l.a
m=A.fG(o,l==null?0:l,!0,j)}if(n)q=m
n=o.a
n=n==null?b:n.b
i=(n==null?0:n)-1
h=A.aU(o)
if(h>0&&A.aU(m)===h){n=o.a
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
A.mu(f,(i*k+d)*h,g,e,d*j*h,n,h);++d}continue}d=0
for(;;){n=m.a
n=n==null?b:n.b
if(!(d<(n==null?0:n)))break
c=0
for(;;){n=m.a
n=n==null?b:n.a
if(!(c<(n==null?0:n)))break
n=o.a
n=n==null?b:n.L(d,i-c,b)
m.bP(c,d,n==null?new A.F():n);++c}++d}}q.toString
return q},
tu(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=null
for(s=a.gaB(),r=s.length,q=c,p=0;p<s.length;s.length===r||(0,A.a0)(s),++p){o=s[p]
n=o.a
m=n==null
l=m?c:n.a
k=(l==null?0:l)-1
n=m?c:n.b
j=(n==null?0:n)-1
n=q==null
i=n?c:q.d2()
if(i==null)i=A.aP(o,!0,!0)
if(n)q=i
h=A.aU(o)
if(h>0&&A.aU(i)===h){n=o.a
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
m=J.C(m)}A.mu(n,(f-1)*h,-h,m,0,f,h)
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
m=m==null?c:m.L(k-d,n,c)
i.bP(d,e,m==null?new A.F():m);++d}++e}}q.toString
return q},
tv(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=null
for(s=a.gaB(),r=s.length,q=b,p=0;p<s.length;s.length===r||(0,A.a0)(s),++p){o=s[p]
n=a.a
n=n==null?b:n.a
m=(n==null?0:n)-1
n=q==null
l=n?b:q.d2()
if(l==null){k=o.a
j=k==null
i=j?b:k.b
if(i==null)i=0
k=j?b:k.a
l=A.fG(o,k==null?0:k,!0,i)}if(n)q=l
h=A.aU(o)
n=!1
if(h>0)if(A.aU(l)===h){n=o.a
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
A.mu(f,(m-d)*h,g,e,d*j*h,n,h);++d}continue}d=0
for(;;){n=l.a
n=n==null?b:n.b
if(!(d<(n==null?0:n)))break
n=m-d
c=0
for(;;){k=l.a
k=k==null?b:k.a
if(!(c<(k==null?0:k)))break
k=o.a
k=k==null?b:k.L(n,c,b)
l.bP(c,d,k==null?new A.F():k);++c}++d}}q.toString
return q},
mu(a,b,c,d,e,f,g){var s,r,q,p,o
for(s=d.$flags|0,r=0;r<f;++r,b+=c)for(q=0;q<g;++q,e=p){p=e+1
o=a[b+q]
s&2&&A.a(d)
d[e]=o}},
i9(a,b){var s=A.j_(a,B.a3,null,null),r=A.nr(new A.fJ(s,B.S,!1,B.ay))
try{s=r.a7(b).U()
return s}finally{r.fP()}},
ll(a){var s
a=(a&-a)>>>0
s=a!==0?31:32
if((a&65535)!==0)s-=16
if((a&16711935)!==0)s-=8
if((a&252645135)!==0)s-=4
if((a&858993459)!==0)s-=2
return(a&1431655765)!==0?s-1:s},
ug(a){$.mT().m(0,0,a)
return $.p9()[0]},
oN(a,b,c,d){return(B.a.I(a,0,255)|B.a.I(b,0,255)<<8|B.a.I(c,0,255)<<16|B.a.I(d,0,255)<<24)>>>0},
b8(a,b,c){var s,r,q,p,o,n=b.gp(b),m=b.gJ(),l=a.gR(),k=l==null?null:l.gJ()
if(k==null)k=a.gJ()
s=a.gp(a)
if(n===1)b.m(0,0,A.dA(B.b.ba(a.gp(a)>2?a.gah():a.k(0,0)),k,m))
else if(n===2){r=s>2?a.gah():a.k(0,0)
b.m(0,0,A.dA(!B.jJ.by(0,k)?B.b.ba(r):r,k,m))
b.m(0,1,A.dA(s===2?a.k(0,1):a.gt(),k,m))}else if(n<=s)for(q=0;q<n;++q)b.m(0,q,A.dA(a.k(0,q),k,m))
else if(s===2){p=A.dA(a.k(0,0),k,m)
if(n===3){b.m(0,0,p)
b.m(0,1,p)
b.m(0,2,p)}else{c=A.dA(a.k(0,1),k,m)
b.m(0,0,p)
b.m(0,1,p)
b.m(0,2,p)
b.m(0,3,c)}}else{for(q=0;q<s;++q)b.m(0,q,A.dA(a.k(0,q),k,m))
o=s===1?b.k(0,0):0
for(q=s;q<n;++q)b.m(0,q,q===3?c:o)}return b},
aB(a,b,c,d,e){var s,r,q=a.gR(),p=q==null?null:q.gJ()
if(p==null)p=a.gJ()
q=e==null
s=q?null:e.gJ()
c=s==null?c:s
if(c==null)c=a.gJ()
s=q?null:e.gp(e)
d=s==null?d:s
if(d==null)d=a.gp(a)
if(b==null)b=0
if(c===p&&d===a.gp(a)){if(q)return a.O()
e.aN(a)
return e}switch(c.a){case 3:if(q)r=new A.b_(new Uint8Array(d))
else r=e
return A.b8(a,r,b)
case 0:return A.b8(a,q?new A.cG(d,0):e,b)
case 1:return A.b8(a,q?new A.cI(d,0):e,b)
case 2:if(q){q=d<3?1:2
r=new A.cK(d,new Uint8Array(q))}else r=e
return A.b8(a,r,b)
case 4:if(q)r=new A.cH(new Uint16Array(d))
else r=e
return A.b8(a,r,b)
case 5:if(q)r=new A.cJ(new Uint32Array(d))
else r=e
return A.b8(a,r,b)
case 6:if(q)r=new A.cF(new Int8Array(d))
else r=e
return A.b8(a,r,b)
case 7:if(q)r=new A.cD(new Int16Array(d))
else r=e
return A.b8(a,r,b)
case 8:if(q)r=new A.cE(new Int32Array(d))
else r=e
return A.b8(a,r,b)
case 9:if(q)r=new A.cA(new Uint16Array(d))
else r=e
return A.b8(a,r,b)
case 10:if(q)r=new A.cB(new Float32Array(d))
else r=e
return A.b8(a,r,b)
case 11:if(q)r=new A.cC(new Float64Array(d))
else r=e
return A.b8(a,r,b)}},
X(a){return 0.299*a.gq()+0.587*a.gu()+0.114*a.gv()},
ox(a,b,c,d,e){var s=1-d/255
e[0]=B.b.aE(255*(1-a/255)*s)
e[1]=B.b.aE(255*(1-b/255)*s)
e[2]=B.b.aE(255*(1-c/255)*s)},
H(a){var s,r,q,p=$.mS()
p.$flags&2&&A.a(p)
p[0]=a
s=$.p8()[0]
if(a===0)return s>>>16
if($.G==null)A.L()
r=$.nd.jS()[s>>>23&511]
if(r!==0){q=s&8388607
return r+(q+4095+(q>>>13&1)>>>13)}return A.pB(s)},
pB(a){var s,r,q=a>>>16&32768,p=(a>>>23&255)-112,o=a&8388607
if(p<=0){if(p<-10)return q
o|=8388608
s=14-p
return(q|B.a.bu(o+(B.a.X(1,s-1)-1)+(B.a.Y(o,s)&1),s))>>>0}else if(p===143)if(o===0)return q|31744
else{o=o>>>13
r=o===0?1:0
return q|o|r|31744}else{o=o+4095+(o>>>13&1)
if((o&8388608)!==0){++p
o=0}if(p>30)return q|31744
return(q|p<<10|o>>>13)>>>0}},
L(){var s,r,q,p,o=$.G
if(o!=null)return o
s=new Uint32Array(65536)
$.G=J.mW(B.l.gA(s),0,null)
o=new Uint16Array(512)
$.nd.b=o
for(r=0;r<256;++r){q=(r&255)-112
if(q<=0||q>=30){o[r]=0
o[(r|256)>>>0]=0}else{p=q<<10>>>0
o[r]=p
o[(r|256)>>>0]=(p|32768)>>>0}}for(r=0;r<65536;++r)s[r]=A.pC(r)
o=$.G
o.toString
return o},
pC(a){var s,r=a>>>15&1,q=a>>>10&31,p=a&1023
if(q===0)if(p===0)return r<<31>>>0
else{while((p&1024)===0){p=p<<1;--q}++q
p&=4294966271}else if(q===31){s=r<<31
if(p===0)return(s|2139095040)>>>0
else return(s|p<<13|2139095040)>>>0}return(r<<31|q+112<<23|p<<13)>>>0},
pM(a,b,c,d,e,f,g){var s,r,q
if(t.j.b(a))t.U.a(J.mZ(a)).ge3()
s=$.I
r=t.j.b(a)
q=r?t.U.a(J.mZ(a)).ge3():a
if(r)J.pg(a)
s=new A.d1(q,d,e,A.nP(f),!1,new A.cs(new A.R(s,t.q),t.ez),f.n("@<0>").aG(g).n("d1<1,2>"))
q.onmessage=A.og(s.gj5())
return s},
mD(a,b,c,d){var s=b==null?null:b.$1(a)
return s==null?d.a(a):s},
u5(){var s=t.D
A.lv(A.ud(),null,s,s)},
u7(a){var s,r,q,p,o,n,m,l=A.tT(a),k=l==null?null:l.aY(a,null)
if(k==null)return a
s=A.mA(k)
if(s.gZ()>1280)s=A.tP(s,1280)
r=new Uint8Array(64)
q=new Uint8Array(64)
p=new Float32Array(64)
o=new Float32Array(64)
n=new Int32Array(64)
m=new Int32Array(64)
r=new A.jh(r,q,p,o,n,m,new Int32Array(2048))
r.e=r.cO(B.br,B.a4)
r.f=r.cO(B.b9,B.a4)
r.r=r.cO(B.aX,B.b1)
r.w=r.cO(B.b5,B.bc)
r.jb()
r.ho(82)
return r.kX(s,B.aU)}},B={}
var w=[A,J,B]
var $={}
A.lT.prototype={}
J.fM.prototype={
P(a,b){return a===b},
gH(a){return A.db(a)},
B(a){return"Instance of '"+A.hi(a)+"'"},
gap(a){return A.aV(A.mw(this))}}
J.fZ.prototype={
B(a){return String(a)},
gH(a){return a?519018:218159},
gap(a){return A.aV(t.y)},
$iN:1,
$iaJ:1}
J.e9.prototype={
P(a,b){return null==b},
B(a){return"null"},
gH(a){return 0},
gap(a){return A.aV(t.a)},
$iN:1}
J.eb.prototype={$iU:1}
J.bC.prototype={
gH(a){return 0},
gap(a){return B.bL},
B(a){return String(a)}}
J.hh.prototype={}
J.eE.prototype={}
J.bh.prototype={
B(a){var s=a[$.oR()]
if(s==null)s=a[$.mM()]
if(s==null)return this.hs(a)
return"JavaScript function for "+J.dE(s)}}
J.d3.prototype={
gH(a){return 0},
B(a){return String(a)}}
J.d4.prototype={
gH(a){return 0},
B(a){return String(a)}}
J.p.prototype={
e_(a,b){var s
a.$flags&1&&A.a(a,"addAll",2)
for(s=b.gG(b);s.E();)a.push(s.gK())},
d5(a){a.$flags&1&&A.a(a,"clear","clear")
a.length=0},
bN(a,b,c){return new A.bk(a,b,A.bv(a).n("@<1>").aG(c).n("bk<1,2>"))},
lb(a,b){var s,r=A.a3(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)r[s]=A.x(a[s])
return r.join(b)},
ha(a,b){return A.di(a,0,A.f6(b,"count",t.p),A.bv(a).c)},
bh(a,b){return A.di(a,b,null,A.bv(a).c)},
bA(a,b){return a[b]},
bX(a,b,c){if(b<0||b>a.length)throw A.e(A.ae(b,0,a.length,"start",null))
if(c<b||c>a.length)throw A.e(A.ae(c,b,a.length,"end",null))
if(b===c)return A.m([],A.bv(a))
return A.m(a.slice(b,c),A.bv(a))},
gfV(a){if(a.length>0)return a[0]
throw A.e(A.e7())},
gd8(a){var s=a.length
if(s>0)return a[s-1]
throw A.e(A.e7())},
a1(a,b,c,d,e){var s,r,q,p,o
a.$flags&2&&A.a(a,5)
A.cn(b,c,a.length)
s=c-b
if(s===0)return
A.aR(e,"skipCount")
if(t.j.b(d)){r=d
q=e}else{r=J.lF(d,e).dh(0,!1)
q=0}p=J.a6(r)
if(q+s>p.gp(r))throw A.e(A.nu())
if(q<b)for(o=s-1;o>=0;--o)a[b+o]=p.k(r,q+o)
else for(o=0;o<s;++o)a[b+o]=p.k(r,q+o)},
ao(a,b,c,d){var s
a.$flags&2&&A.a(a,"fillRange")
A.cn(b,c,a.length)
for(s=b;s<c;++s)a[s]=d},
kY(a,b){var s,r=a.length
for(s=0;s<r;++s){if(!b.$1(a[s]))return!1
if(a.length!==r)throw A.e(A.aO(a))}return!0},
by(a,b){var s
for(s=0;s<a.length;++s)if(J.aK(a[s],b))return!0
return!1},
B(a){return A.jb(a,"[","]")},
gG(a){return new J.fb(a,a.length,A.bv(a).n("fb<1>"))},
gH(a){return A.db(a)},
gp(a){return a.length},
sp(a,b){a.$flags&1&&A.a(a,"set length","change the length of")
if(b<0)throw A.e(A.ae(b,0,null,"newLength",null))
if(b>a.length)A.bv(a).c.a(null)
a.length=b},
k(a,b){if(!(b>=0&&b<a.length))throw A.e(A.mF(a,b))
return a[b]},
m(a,b,c){a.$flags&2&&A.a(a)
if(!(b>=0&&b<a.length))throw A.e(A.mF(a,b))
a[b]=c},
gap(a){return A.aV(A.bv(a))},
$iac:1,
$iv:1,
$id:1,
$iA:1}
J.fY.prototype={
lw(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.hi(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.jc.prototype={}
J.fb.prototype={
gK(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a,p=q.length
if(r.b!==p)throw A.e(A.a0(q))
s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0}}
J.ea.prototype={
e1(a,b){var s
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.gea(b)
if(this.gea(a)===s)return 0
if(this.gea(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
gea(a){return a===0?1/a<0:a<0},
h(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.e(A.bc(""+a+".toInt()"))},
b2(a){var s,r
if(a>=0){if(a<=2147483647){s=a|0
return a===s?s:s+1}}else if(a>=-2147483648)return a|0
r=Math.ceil(a)
if(isFinite(r))return r
throw A.e(A.bc(""+a+".ceil()"))},
ba(a){var s,r
if(a>=0){if(a<=2147483647)return a|0}else if(a>=-2147483648){s=a|0
return a===s?s:s-1}r=Math.floor(a)
if(isFinite(r))return r
throw A.e(A.bc(""+a+".floor()"))},
aE(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw A.e(A.bc(""+a+".round()"))},
I(a,b,c){if(this.e1(b,c)>0)throw A.e(A.cw(b))
if(this.e1(a,b)<0)return b
if(this.e1(a,c)>0)return c
return a},
di(a,b){var s,r,q,p
if(b<2||b>36)throw A.e(A.ae(b,2,36,"radix",null))
s=a.toString(b)
if(s.charCodeAt(s.length-1)!==41)return s
r=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(r==null)A.Y(A.bc("Unexpected toString result: "+s))
s=r[1]
q=+r[3]
p=r[2]
if(p!=null){s+=p
q-=p.length}return s+B.E.hm("0",q)},
B(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gH(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
a2(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
if(b<0)return s-b
else return s+b},
ab(a,b){if((a|0)===a)if(b>=1||b<-1)return a/b|0
return this.ft(a,b)},
W(a,b){return(a|0)===a?a/b|0:this.ft(a,b)},
ft(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.e(A.bc("Result of truncating division is "+A.x(s)+": "+A.x(a)+" ~/ "+b))},
X(a,b){if(b<0)throw A.e(A.cw(b))
return b>31?0:a<<b>>>0},
N(a,b){return b>31?0:a<<b>>>0},
bu(a,b){var s
if(b<0)throw A.e(A.cw(b))
if(a>0)s=this.a3(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
i(a,b){var s
if(a>0)s=this.a3(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
Y(a,b){if(0>b)throw A.e(A.cw(b))
return this.a3(a,b)},
a3(a,b){return b>31?0:a>>>b},
gap(a){return A.aV(t.n)},
$iJ:1,
$ik:1}
J.e8.prototype={
aJ(a,b){var s=this.X(1,b-1)
return((a&s-1)>>>0)-((a&s)>>>0)},
gfN(a){var s,r=a<0?-a-1:a,q=r
for(s=32;q>=4294967296;){q=this.W(q,4294967296)
s+=32}return s-Math.clz32(q)},
gap(a){return A.aV(t.p)},
$iN:1,
$ih:1}
J.h_.prototype={
gap(a){return A.aV(t.V)},
$iN:1}
J.d2.prototype={
er(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
he(a){var s,r,q,p=a.trim(),o=p.length
if(o===0)return p
if(p.charCodeAt(0)===133){s=J.pQ(p,1)
if(s===o)return""}else s=0
r=o-1
q=p.charCodeAt(r)===133?J.pR(p,r):o
if(s===0&&q===o)return p
return p.substring(s,q)},
hm(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.e(B.c6)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
B(a){return a},
gH(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gap(a){return A.aV(t.N)},
gp(a){return a.length},
$iac:1,
$iN:1,
$ia7:1}
A.dG.prototype={
c8(a,b,c,d){var s=this.a.h2(null,b,c),r=new A.dH(s,$.I,this.$ti.n("dH<1,2>"))
s.dc(r.gjj())
r.dc(a)
r.dd(d)
return r},
h1(a){return this.c8(a,null,null,null)},
h2(a,b,c){return this.c8(a,b,c,null)}}
A.dH.prototype={
dc(a){this.c=a==null?null:a},
dd(a){var s=this
s.a.dd(a)
if(a==null)s.d=null
else if(t.k.b(a))s.d=s.b.df(a)
else if(t.u.b(a))s.d=a
else throw A.e(A.aZ(u.h,null))},
jk(a){var s,r,q,p,o,n=this,m=n.c
if(m==null)return
s=null
try{s=n.$ti.y[1].a(a)}catch(o){r=A.ar(o)
q=A.b9(o)
p=n.d
if(p==null)A.dw(r,q)
else{m=n.b
if(t.k.b(p))m.h9(p,r,q)
else m.dg(t.u.a(p),r)}return}n.b.dg(m,s)}}
A.d5.prototype={
B(a){return"LateInitializationError: "+this.a}}
A.aN.prototype={
gp(a){return this.a.length},
k(a,b){return this.a.charCodeAt(b)}}
A.jV.prototype={}
A.v.prototype={}
A.aF.prototype={
gG(a){var s=this
return new A.d6(s,s.gp(s),A.i(s).n("d6<aF.E>"))},
bN(a,b,c){return new A.bk(this,b,A.i(this).n("@<aF.E>").aG(c).n("bk<1,2>"))},
bh(a,b){return A.di(this,b,null,A.i(this).n("aF.E"))}}
A.eC.prototype={
giR(){var s=J.by(this.a),r=this.c
if(r==null||r>s)return s
return r},
gko(){var s=J.by(this.a),r=this.b
if(r>s)return s
return r},
gp(a){var s,r=J.by(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
bA(a,b){var s=this,r=s.gko()+b
if(b<0||r>=s.giR())throw A.e(A.iX(b,s.gp(0),s,null,"index"))
return J.mY(s.a,r)},
bh(a,b){var s,r,q=this
A.aR(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.bS(q.$ti.n("bS<1>"))
return A.di(q.a,s,r,q.$ti.c)},
dh(a,b){var s,r,q,p=this,o=p.b,n=p.a,m=J.a6(n),l=m.gp(n),k=p.c
if(k!=null&&k<l)l=k
s=l-o
if(s<=0){n=J.lR(0,p.$ti.c)
return n}r=A.a3(s,m.bA(n,o),!1,p.$ti.c)
for(q=1;q<s;++q){r[q]=m.bA(n,o+q)
if(m.gp(n)<l)throw A.e(A.aO(p))}return r}}
A.d6.prototype={
gK(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a,p=J.a6(q),o=p.gp(q)
if(r.b!==o)throw A.e(A.aO(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.bA(q,s);++r.c
return!0}}
A.bj.prototype={
gG(a){var s=this.a
return new A.h6(s.gG(s),this.b,A.i(this).n("h6<1,2>"))},
gp(a){var s=this.a
return s.gp(s)}}
A.bR.prototype={$iv:1}
A.h6.prototype={
E(){var s=this,r=s.b
if(r.E()){s.a=s.c.$1(r.gK())
return!0}s.a=null
return!1},
gK(){var s=this.a
return s==null?this.$ti.y[1].a(s):s}}
A.bk.prototype={
gp(a){return J.by(this.a)},
bA(a,b){return this.b.$1(J.mY(this.a,b))}}
A.eK.prototype={
gG(a){return new A.hK(J.f9(this.a),this.b,this.$ti.n("hK<1>"))},
bN(a,b,c){return new A.bj(this,b,this.$ti.n("@<1>").aG(c).n("bj<1,2>"))}}
A.hK.prototype={
E(){var s,r
for(s=this.a,r=this.b;s.E();)if(r.$1(s.gK()))return!0
return!1},
gK(){return this.a.gK()}}
A.bo.prototype={
bh(a,b){A.ie(b,"count")
A.aR(b,"count")
return new A.bo(this.a,this.b+b,A.i(this).n("bo<1>"))},
gG(a){var s=this.a
return new A.hv(s.gG(s),this.b,A.i(this).n("hv<1>"))}}
A.cM.prototype={
gp(a){var s=this.a,r=s.gp(s)-this.b
if(r>=0)return r
return 0},
bh(a,b){A.ie(b,"count")
A.aR(b,"count")
return new A.cM(this.a,this.b+b,this.$ti)},
$iv:1}
A.hv.prototype={
E(){var s,r
for(s=this.a,r=0;r<this.b;++r)s.E()
this.b=0
return s.E()},
gK(){return this.a.gK()}}
A.bS.prototype={
gG(a){return B.c_},
gp(a){return 0},
bN(a,b,c){return new A.bS(c.n("bS<0>"))},
bh(a,b){A.aR(b,"count")
return this},
dh(a,b){var s=J.lR(0,this.$ti.c)
return s}}
A.fq.prototype={
E(){return!1},
gK(){throw A.e(A.e7())}}
A.dR.prototype={}
A.hC.prototype={
m(a,b,c){throw A.e(A.bc("Cannot modify an unmodifiable list"))},
a1(a,b,c,d,e){throw A.e(A.bc("Cannot modify an unmodifiable list"))},
aI(a,b,c,d){return this.a1(0,b,c,d,0)},
ao(a,b,c,d){throw A.e(A.bc("Cannot modify an unmodifiable list"))}}
A.dj.prototype={}
A.k_.prototype={}
A.cL.prototype={
B(a){return A.lW(this)},
eb(a,b,c,d){var s=A.D(c,d)
this.bk(0,new A.ip(this,b,s))
return s},
$iay:1}
A.ip.prototype={
$2(a,b){var s=this.b.$2(a,b)
this.c.m(0,s.a,s.b)},
$S(){return A.i(this.a).n("~(1,2)")}}
A.dK.prototype={
gp(a){return this.b.length},
gfa(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
a5(a){if(typeof a!="string")return!1
if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
k(a,b){if(!this.a5(b))return null
return this.b[this.a[b]]},
bk(a,b){var s,r,q=this.gfa(),p=this.b
for(s=q.length,r=0;r<s;++r)b.$2(q[r],p[r])},
gbM(){return new A.eS(this.gfa(),this.$ti.n("eS<1>"))}}
A.eS.prototype={
gp(a){return this.a.length},
gG(a){var s=this.a
return new A.ds(s,s.length,this.$ti.n("ds<1>"))}}
A.ds.prototype={
gK(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0}}
A.bW.prototype={
c2(){var s=this,r=s.$map
if(r==null){r=new A.c6(s.$ti.n("c6<1,2>"))
A.oz(s.a,r)
s.$map=r}return r},
k(a,b){return this.c2().k(0,b)},
bk(a,b){this.c2().bk(0,b)},
gbM(){var s=this.c2()
return new A.c7(s,A.i(s).n("c7<1>"))},
gp(a){return this.c2().a}}
A.dJ.prototype={}
A.dS.prototype={
gp(a){return this.a.length},
gG(a){var s=this.a
return new A.ds(s,s.length,this.$ti.n("ds<1>"))},
c2(){var s,r,q,p,o=this,n=o.$map
if(n==null){n=new A.c6(o.$ti.n("c6<1,1>"))
for(s=o.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.a0)(s),++q){p=s[q]
n.m(0,p,p)}o.$map=n}return n},
by(a,b){return this.c2().a5(b)}}
A.j1.prototype={
hI(a){if(false)A.oG(0,0)},
P(a,b){if(b==null)return!1
return b instanceof A.e4&&this.a.P(0,b.a)&&A.mG(this)===A.mG(b)},
gH(a){return A.lX(this.a,A.mG(this),B.B,B.B)},
B(a){var s=B.k.lb([A.aV(this.$ti.c)],", ")
return this.a.B(0)+" with "+("<"+s+">")}}
A.e4.prototype={
$1(a){return this.a.$1$1(a,this.$ti.y[0])},
$S(){return A.oG(A.i8(this.a),this.$ti)}}
A.ex.prototype={}
A.kc.prototype={
bq(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
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
A.eo.prototype={
B(a){return"Null check operator used on a null value"}}
A.h3.prototype={
B(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.hB.prototype={
B(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.js.prototype={
B(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.dM.prototype={}
A.eZ.prototype={
B(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$iah:1}
A.bP.prototype={
B(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.oQ(r==null?"unknown":r)+"'"},
gap(a){var s=A.i8(this)
return A.aV(s==null?A.aW(this):s)},
glB(){return this},
$C:"$1",
$R:1,
$D:null}
A.im.prototype={$C:"$0",$R:0}
A.io.prototype={$C:"$2",$R:2}
A.k1.prototype={}
A.jX.prototype={
B(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.oQ(s)+"'"}}
A.dF.prototype={
P(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.dF))return!1
return this.$_target===b.$_target&&this.a===b.a},
gH(a){return(A.ia(this.a)^A.db(this.$_target))>>>0},
B(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.hi(this.a)+"'")}}
A.hu.prototype={
B(a){return"RuntimeError: "+this.a}}
A.b3.prototype={
gp(a){return this.a},
gbM(){return new A.c7(this,A.i(this).n("c7<1>"))},
a5(a){var s,r
if(typeof a=="string"){s=this.b
if(s==null)return!1
return s[a]!=null}else if(typeof a=="number"&&(a&0x3fffffff)===a){r=this.c
if(r==null)return!1
return r[a]!=null}else return this.l5(a)},
l5(a){var s=this.d
if(s==null)return!1
return this.ct(this.f_(s,a),a)>=0},
k(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.l6(b)},
l6(a){var s,r,q=this.d
if(q==null)return null
s=this.f_(q,a)
r=this.ct(s,a)
if(r<0)return null
return s[r].b},
m(a,b,c){var s,r,q=this
if(typeof b=="string"){s=q.b
q.ex(s==null?q.b=q.dK():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=q.c
q.ex(r==null?q.c=q.dK():r,b,c)}else q.l8(b,c)},
l8(a,b){var s,r,q,p=this,o=p.d
if(o==null)o=p.d=p.dK()
s=p.d7(a)
r=o[s]
if(r==null)o[s]=[p.dL(a,b)]
else{q=p.ct(r,a)
if(q>=0)r[q].b=b
else r.push(p.dL(a,b))}},
ca(a,b){var s=this
if(typeof b=="string")return s.fm(s.b,b)
else if(typeof b=="number"&&(b&0x3fffffff)===b)return s.fm(s.c,b)
else return s.l7(b)},
l7(a){var s,r,q,p,o=this,n=o.d
if(n==null)return null
s=o.d7(a)
r=n[s]
q=o.ct(r,a)
if(q<0)return null
p=r.splice(q,1)[0]
o.fw(p)
if(r.length===0)delete n[s]
return p.b},
bk(a,b){var s=this,r=s.e,q=s.r
while(r!=null){b.$2(r.a,r.b)
if(q!==s.r)throw A.e(A.aO(s))
r=r.c}},
ex(a,b,c){var s=a[b]
if(s==null)a[b]=this.dL(b,c)
else s.b=c},
fm(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.fw(s)
delete a[b]
return s.b},
fb(){this.r=this.r+1&1073741823},
dL(a,b){var s,r=this,q=new A.jm(a,b)
if(r.e==null)r.e=r.f=q
else{s=r.f
s.toString
q.d=s
r.f=s.c=q}++r.a
r.fb()
return q},
fw(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.fb()},
d7(a){return J.av(a)&1073741823},
f_(a,b){return a[this.d7(b)]},
ct(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.aK(a[r].a,b))return r
return-1},
B(a){return A.lW(this)},
dK(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s}}
A.jm.prototype={}
A.c7.prototype={
gp(a){return this.a.a},
gG(a){var s=this.a
return new A.V(s,s.r,s.e,this.$ti.n("V<1>"))}}
A.V.prototype={
gK(){return this.d},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.e(A.aO(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}}}
A.jn.prototype={
gp(a){return this.a.a},
gG(a){var s=this.a
return new A.ag(s,s.r,s.e,this.$ti.n("ag<1>"))}}
A.ag.prototype={
gK(){return this.d},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.e(A.aO(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.b
r.c=s.c
return!0}}}
A.bi.prototype={
gp(a){return this.a.a},
gG(a){var s=this.a
return new A.h4(s,s.r,s.e,this.$ti.n("h4<1,2>"))}}
A.h4.prototype={
gK(){var s=this.d
s.toString
return s},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.e(A.aO(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=new A.az(s.a,s.b,r.$ti.n("az<1,2>"))
r.c=s.c
return!0}}}
A.c6.prototype={
d7(a){return A.tN(a)&1073741823},
ct(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.aK(a[r].a,b))return r
return-1}}
A.lr.prototype={
$1(a){return this.a(a)},
$S:44}
A.ls.prototype={
$2(a,b){return this.a(a,b)},
$S:41}
A.lt.prototype={
$1(a){return this.a(a)},
$S:40}
A.kF.prototype={
jS(){var s=this.b
if(s===this)throw A.e(A.nz(""))
return s}}
A.d7.prototype={
gap(a){return B.kb},
d4(a,b,c){A.aq(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
fL(a){return this.d4(a,0,null)},
fI(a,b,c){A.aq(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
d3(a,b,c){A.aq(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
fJ(a){return this.d3(a,0,null)},
fG(a,b,c){A.aq(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Int16Array(a,b,c)},
fK(a,b,c){A.aq(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
fH(a,b,c){A.aq(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Int32Array(a,b,c)},
fF(a,b,c){A.aq(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Float32Array(a,b,c)},
fE(a,b,c){var s
A.aq(a,b,c)
s=new DataView(a,b,c)
return s},
$iN:1,
$ifg:1}
A.ej.prototype={
gA(a){if(((a.$flags|0)&2)!==0)return new A.i4(a.buffer)
else return a.buffer},
jc(a,b,c,d){var s=A.ae(b,0,c,d,null)
throw A.e(s)},
eH(a,b,c,d){if(b>>>0!==b||b>c)this.jc(a,b,c,d)}}
A.i4.prototype={
d4(a,b,c){var s=A.qa(this.a,b,c)
s.$flags=3
return s},
fL(a){return this.d4(0,0,null)},
fI(a,b,c){var s=A.q4(this.a,b,c)
s.$flags=3
return s},
d3(a,b,c){var s=A.q6(this.a,b,c)
s.$flags=3
return s},
fJ(a){return this.d3(0,0,null)},
fG(a,b,c){var s=A.q1(this.a,b,c)
s.$flags=3
return s},
fK(a,b,c){var s=A.q8(this.a,b,c)
s.$flags=3
return s},
fH(a,b,c){var s=A.q3(this.a,b,c)
s.$flags=3
return s},
fF(a,b,c){var s=A.q0(this.a,b,c)
s.$flags=3
return s},
fE(a,b,c){var s=A.pZ(this.a,b,c)
s.$flags=3
return s},
$ifg:1}
A.h7.prototype={
gap(a){return B.kc},
$iN:1,
$ilI:1}
A.d8.prototype={
gp(a){return a.length},
kk(a,b,c,d,e){var s,r,q=a.length
this.eH(a,b,q,"start")
this.eH(a,c,q,"end")
if(b>c)throw A.e(A.ae(b,0,c,null,null))
s=c-b
if(e<0)throw A.e(A.aZ(e,null))
r=d.length
if(r-e<s)throw A.e(A.jW("Not enough elements"))
if(e!==0||r!==s)d=d.subarray(e,e+s)
a.set(d,b)},
$iac:1,
$iaE:1}
A.ei.prototype={
k(a,b){A.bw(b,a,a.length)
return a[b]},
m(a,b,c){a.$flags&2&&A.a(a)
A.bw(b,a,a.length)
a[b]=c},
a1(a,b,c,d,e){a.$flags&2&&A.a(a,5)
this.eu(a,b,c,d,e)},
aI(a,b,c,d){return this.a1(a,b,c,d,0)},
$iv:1,
$id:1,
$iA:1}
A.aG.prototype={
m(a,b,c){a.$flags&2&&A.a(a)
A.bw(b,a,a.length)
a[b]=c},
a1(a,b,c,d,e){a.$flags&2&&A.a(a,5)
if(t.bc.b(d)){this.kk(a,b,c,d,e)
return}this.eu(a,b,c,d,e)},
aI(a,b,c,d){return this.a1(a,b,c,d,0)},
$iv:1,
$id:1,
$iA:1}
A.ed.prototype={
gap(a){return B.kd},
$iN:1,
$iiD:1}
A.ee.prototype={
gap(a){return B.ke},
$iN:1,
$iiE:1}
A.ef.prototype={
gap(a){return B.kf},
k(a,b){A.bw(b,a,a.length)
return a[b]},
bX(a,b,c){return new Int16Array(a.subarray(b,A.i6(b,c,a.length)))},
$iN:1,
$id0:1}
A.eg.prototype={
gap(a){return B.kg},
k(a,b){A.bw(b,a,a.length)
return a[b]},
$iN:1,
$ij2:1}
A.eh.prototype={
gap(a){return B.kh},
k(a,b){A.bw(b,a,a.length)
return a[b]},
$iN:1,
$ij3:1}
A.ek.prototype={
gap(a){return B.kj},
k(a,b){A.bw(b,a,a.length)
return a[b]},
$iN:1,
$ihz:1}
A.el.prototype={
gap(a){return B.kk},
k(a,b){A.bw(b,a,a.length)
return a[b]},
$iN:1,
$ibs:1}
A.em.prototype={
gap(a){return B.kl},
gp(a){return a.length},
k(a,b){A.bw(b,a,a.length)
return a[b]},
$iN:1,
$ike:1}
A.c9.prototype={
gap(a){return B.km},
gp(a){return a.length},
k(a,b){A.bw(b,a,a.length)
return a[b]},
bX(a,b,c){return new Uint8Array(a.subarray(b,A.i6(b,c,a.length)))},
hr(a,b){return this.bX(a,b,null)},
$iN:1,
$ic9:1,
$iaH:1}
A.eU.prototype={}
A.eV.prototype={}
A.eW.prototype={}
A.eX.prototype={}
A.b6.prototype={
n(a){return A.l8(v.typeUniverse,this,a)},
aG(a){return A.rC(v.typeUniverse,this,a)}}
A.hT.prototype={}
A.i3.prototype={
B(a){return A.aI(this.a,null)}}
A.hR.prototype={
B(a){return this.a}}
A.f0.prototype={$ibq:1}
A.kA.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:10}
A.kz.prototype={
$1(a){var s,r
this.a.a=a
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:39}
A.kB.prototype={
$0(){this.a.$0()},
$S:12}
A.kC.prototype={
$0(){this.a.$0()},
$S:12}
A.l4.prototype={
hS(a,b){if(self.setTimeout!=null)self.setTimeout(A.f7(new A.l5(this,b),0),a)
else throw A.e(A.bc("`setTimeout()` not found."))}}
A.l5.prototype={
$0(){this.b.$0()},
$S:2}
A.hL.prototype={
d6(a){var s,r=this
if(a==null)a=r.$ti.c.a(a)
if(!r.b)r.a.cK(a)
else{s=r.a
if(r.$ti.n("bz<1>").b(a))s.eG(a)
else s.eM(a)}},
e2(a,b){var s=this.a
if(this.b)s.cN(new A.aM(a,b))
else s.ds(new A.aM(a,b))}}
A.le.prototype={
$1(a){return this.a.$2(0,a)},
$S:7}
A.lf.prototype={
$2(a,b){this.a.$2(1,new A.dM(a,b))},
$S:28}
A.li.prototype={
$2(a,b){this.a(a,b)},
$S:25}
A.aM.prototype={
B(a){return A.x(this.a)},
$iT:1,
gce(){return this.b}}
A.bK.prototype={}
A.dn.prototype={
dM(){},
dN(){}}
A.hN.prototype={
gdJ(){return this.c<4},
kh(a){var s=a.CW,r=a.ch
if(s==null)this.d=r
else s.ch=r
if(r==null)this.e=s
else r.CW=s
a.CW=a
a.ch=a},
kp(a,b,c,d){var s,r,q,p,o,n,m,l,k=this
if((k.c&4)!==0){s=new A.eP($.I,A.i(k).n("eP<1>"))
A.oO(s.gjl())
if(c!=null)s.c=c
return s}s=$.I
r=d?1:0
q=b!=null?32:0
p=A.nX(s,a)
o=A.nY(s,b)
n=c==null?A.tL():c
m=new A.dn(k,p,o,n,s,r|q,A.i(k).n("dn<1>"))
m.CW=m
m.ch=m
m.ay=k.c&1
l=k.e
k.e=m
m.ch=null
m.CW=l
if(l==null)k.d=m
else l.ch=m
if(k.d===m)A.or(k.a)
return m},
kg(a){var s,r=this
A.i(r).n("dn<1>").a(a)
if(a.ch===a)return null
s=a.ay
if((s&2)!==0)a.ay=s|4
else{r.kh(a)
if((r.c&2)===0&&r.d==null)r.i6()}return null},
dn(){if((this.c&4)!==0)return new A.bH("Cannot add new events after calling close")
return new A.bH("Cannot add new events while doing an addStream")},
bK(a,b){if(!this.gdJ())throw A.e(this.dn())
this.dX(b)},
e0(a,b){var s
if(!this.gdJ())throw A.e(this.dn())
s=A.oh(a,b)
this.dZ(s.a,s.b)},
kD(a){return this.e0(a,null)},
c6(){var s,r,q=this
if((q.c&4)!==0){s=q.r
s.toString
return s}if(!q.gdJ())throw A.e(q.dn())
q.c|=4
r=q.r
if(r==null)r=q.r=new A.R($.I,t.q)
q.dY()
return r},
i6(){if((this.c&4)!==0){var s=this.r
if((s.a&30)===0)s.cK(null)}A.or(this.b)}}
A.eL.prototype={
dX(a){var s,r
for(s=this.d,r=this.$ti.n("hP<1>");s!=null;s=s.ch)s.dr(new A.hP(a,r))},
dZ(a,b){var s
for(s=this.d;s!=null;s=s.ch)s.dr(new A.kI(a,b))},
dY(){var s=this.d
if(s!=null)for(;s!=null;s=s.ch)s.dr(B.c8)
else this.r.cK(null)}}
A.hO.prototype={
e2(a,b){var s=this.a
if((s.a&30)!==0)throw A.e(A.jW("Future already completed"))
s.ds(A.oh(a,b))},
fR(a){return this.e2(a,null)}}
A.cs.prototype={
d6(a){var s=this.a
if((s.a&30)!==0)throw A.e(A.jW("Future already completed"))
s.cK(a)},
kK(){return this.d6(null)}}
A.dp.prototype={
lc(a){if((this.c&15)!==6)return!0
return this.b.b.eh(this.d,a.a)},
l2(a){var s,r=this.e,q=null,p=a.a,o=this.b.b
if(t.Q.b(r))q=o.lq(r,p,a.b)
else q=o.eh(r,p)
try{p=q
return p}catch(s){if(t.eK.b(A.ar(s))){if((this.c&1)!==0)throw A.e(A.aZ("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.e(A.aZ("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.R.prototype={
hb(a,b,c){var s,r=$.I
if(r===B.p){if(!t.Q.b(b)&&!t.E.b(b))throw A.e(A.n0(b,"onError",u.c))}else b=A.tp(b,r)
s=new A.R(r,c.n("R<0>"))
this.dq(new A.dp(s,3,a,b,this.$ti.n("@<1>").aG(c).n("dp<1,2>")))
return s},
fu(a,b,c){var s=new A.R($.I,c.n("R<0>"))
this.dq(new A.dp(s,19,a,b,this.$ti.n("@<1>").aG(c).n("dp<1,2>")))
return s},
kj(a){this.a=this.a&1|16
this.c=a},
cM(a){this.a=a.a&30|this.a&1
this.c=a.c},
dq(a){var s=this,r=s.a
if(r<=3){a.a=s.c
s.c=a}else{if((r&4)!==0){r=s.c
if((r.a&24)===0){r.dq(a)
return}s.cM(r)}A.dx(null,null,s.b,new A.kL(s,a))}},
fg(a){var s,r,q,p,o,n=this,m={}
m.a=a
if(a==null)return
s=n.a
if(s<=3){r=n.c
n.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){s=n.c
if((s.a&24)===0){s.fg(a)
return}n.cM(s)}m.a=n.d_(a)
A.dx(null,null,n.b,new A.kP(m,n))}},
co(){var s=this.c
this.c=null
return this.d_(s)},
d_(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
eM(a){var s=this,r=s.co()
s.a=8
s.c=a
A.ct(s,r)},
ia(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.co()
q.cM(a)
A.ct(q,r)},
cN(a){var s=this.co()
this.kj(a)
A.ct(this,s)},
i9(a,b){this.cN(new A.aM(a,b))},
cK(a){if(this.$ti.n("bz<1>").b(a)){this.eG(a)
return}this.hV(a)},
hV(a){this.a^=2
A.dx(null,null,this.b,new A.kN(this,a))},
eG(a){A.mj(a,this,!1)
return},
ds(a){this.a^=2
A.dx(null,null,this.b,new A.kM(this,a))},
$ibz:1}
A.kL.prototype={
$0(){A.ct(this.a,this.b)},
$S:2}
A.kP.prototype={
$0(){A.ct(this.b,this.a.a)},
$S:2}
A.kO.prototype={
$0(){A.mj(this.a.a,this.b,!0)},
$S:2}
A.kN.prototype={
$0(){this.a.eM(this.b)},
$S:2}
A.kM.prototype={
$0(){this.a.cN(this.b)},
$S:2}
A.kS.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.lo(q.d)}catch(p){s=A.ar(p)
r=A.b9(p)
if(k.c&&k.b.a.c.a===s){q=k.a
q.c=k.b.a.c}else{q=s
o=r
if(o==null)o=A.lH(q)
n=k.a
n.c=new A.aM(q,o)
q=n}q.b=!0
return}if(j instanceof A.R&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=j.c
q.b=!0}return}if(j instanceof A.R){m=k.b.a
l=new A.R(m.b,m.$ti)
j.hb(new A.kT(l,m),new A.kU(l),t.H)
q=k.a
q.c=l
q.b=!1}},
$S:2}
A.kT.prototype={
$1(a){this.a.ia(this.b)},
$S:10}
A.kU.prototype={
$2(a,b){this.a.cN(new A.aM(a,b))},
$S:23}
A.kR.prototype={
$0(){var s,r,q,p,o,n
try{q=this.a
p=q.a
q.c=p.b.b.eh(p.d,this.b)}catch(o){s=A.ar(o)
r=A.b9(o)
q=s
p=r
if(p==null)p=A.lH(q)
n=this.a
n.c=new A.aM(q,p)
n.b=!0}},
$S:2}
A.kQ.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=l.a.a.c
p=l.b
if(p.a.lc(s)&&p.a.e!=null){p.c=p.a.l2(s)
p.b=!1}}catch(o){r=A.ar(o)
q=A.b9(o)
p=l.a.a.c
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.lH(p)
m=l.b
m.c=new A.aM(p,n)
p=m}p.b=!0}},
$S:2}
A.hM.prototype={}
A.b7.prototype={
gp(a){var s={},r=new A.R($.I,t.fJ)
s.a=0
this.c8(new A.jY(s,this),!0,new A.jZ(s,r),r.gi8())
return r}}
A.jY.prototype={
$1(a){++this.a.a},
$S(){return A.i(this.b).n("~(b7.T)")}}
A.jZ.prototype={
$0(){var s=this.b,r=this.a.a,q=s.co()
s.a=8
s.c=r
A.ct(s,q)},
$S:2}
A.eN.prototype={
gH(a){return(A.db(this.a)^892482866)>>>0},
P(a,b){if(b==null)return!1
if(this===b)return!0
return b instanceof A.bK&&b.a===this.a}}
A.eO.prototype={
fe(){return this.w.kg(this)},
dM(){},
dN(){}}
A.eM.prototype={
dc(a){this.a=A.nX(this.d,a)},
dd(a){var s=this,r=s.e
if(a==null)s.e=r&4294967263
else s.e=r|32
s.b=A.nY(s.d,a)},
eF(){var s,r=this,q=r.e|=8
if((q&128)!==0){s=r.r
if(s.a===1)s.a=3}if((q&64)===0)r.r=null
r.f=r.fe()},
dM(){},
dN(){},
fe(){return null},
dr(a){var s,r,q=this,p=q.r
if(p==null)p=q.r=new A.hZ(A.i(q).n("hZ<1>"))
s=p.c
if(s==null)p.b=p.c=a
else{s.scu(a)
p.c=a}r=q.e
if((r&128)===0){r|=128
q.e=r
if(r<256)p.el(q)}},
dX(a){var s=this,r=s.e
s.e=r|64
s.d.dg(s.a,a)
s.e&=4294967231
s.eI((r&4)!==0)},
dZ(a,b){var s=this,r=s.e,q=new A.kE(s,a,b)
if((r&1)!==0){s.e=r|16
s.eF()
q.$0()}else{q.$0()
s.eI((r&4)!==0)}},
dY(){this.eF()
this.e|=16
new A.kD(this).$0()},
eI(a){var s,r,q=this,p=q.e
if((p&128)!==0&&q.r.c==null){p=q.e=p&4294967167
s=!1
if((p&4)!==0)if(p<256){s=q.r
s=s==null?null:s.c==null
s=s!==!1}if(s){p&=4294967291
q.e=p}}for(;;a=r){if((p&8)!==0){q.r=null
return}r=(p&4)!==0
if(a===r)break
q.e=p^64
if(r)q.dM()
else q.dN()
p=q.e&=4294967231}if((p&128)!==0&&p<256)q.r.el(q)}}
A.kE.prototype={
$0(){var s,r,q=this.a,p=q.e
if((p&8)!==0&&(p&16)===0)return
q.e=p|64
s=q.b
p=this.b
r=q.d
if(t.k.b(s))r.h9(s,p,this.c)
else r.dg(s,p)
q.e&=4294967231},
$S:2}
A.kD.prototype={
$0(){var s=this.a,r=s.e
if((r&16)===0)return
s.e=r|74
s.d.eg(s.c)
s.e&=4294967231},
$S:2}
A.du.prototype={
c8(a,b,c,d){return this.a.kp(a,d,c,b===!0)},
h1(a){return this.c8(a,null,null,null)},
h2(a,b,c){return this.c8(a,b,c,null)}}
A.hQ.prototype={
gcu(){return this.a},
scu(a){return this.a=a}}
A.hP.prototype={
ed(a){a.dX(this.b)}}
A.kI.prototype={
ed(a){a.dZ(this.b,this.c)}}
A.kH.prototype={
ed(a){a.dY()},
gcu(){return null},
scu(a){throw A.e(A.jW("No events after a done."))}}
A.hZ.prototype={
el(a){var s=this,r=s.a
if(r===1)return
if(r>=1){s.a=1
return}A.oO(new A.l1(s,a))
s.a=1}}
A.l1.prototype={
$0(){var s,r,q=this.a,p=q.a
q.a=0
if(p===3)return
s=q.b
r=s.gcu()
q.b=r
if(r==null)q.c=null
s.ed(this.b)},
$S:2}
A.eP.prototype={
dc(a){},
dd(a){},
jm(){var s,r=this,q=r.a-1
if(q===0){r.a=-1
s=r.c
if(s!=null){r.c=null
r.b.eg(s)}}else r.a=q}}
A.i1.prototype={}
A.lc.prototype={}
A.l2.prototype={
eg(a){var s,r,q
try{if(B.p===$.I){a.$0()
return}A.on(null,null,this,a)}catch(q){s=A.ar(q)
r=A.b9(q)
A.dw(s,r)}},
lu(a,b){var s,r,q
try{if(B.p===$.I){a.$1(b)
return}A.op(null,null,this,a,b)}catch(q){s=A.ar(q)
r=A.b9(q)
A.dw(s,r)}},
dg(a,b){return this.lu(a,b,t.z)},
ls(a,b,c){var s,r,q
try{if(B.p===$.I){a.$2(b,c)
return}A.oo(null,null,this,a,b,c)}catch(q){s=A.ar(q)
r=A.b9(q)
A.dw(s,r)}},
h9(a,b,c){var s=t.z
return this.ls(a,b,c,s,s)},
fM(a){return new A.l3(this,a)},
lp(a){if($.I===B.p)return a.$0()
return A.on(null,null,this,a)},
lo(a){return this.lp(a,t.z)},
lt(a,b){if($.I===B.p)return a.$1(b)
return A.op(null,null,this,a,b)},
eh(a,b){var s=t.z
return this.lt(a,b,s,s)},
lr(a,b,c){if($.I===B.p)return a.$2(b,c)
return A.oo(null,null,this,a,b,c)},
lq(a,b,c){var s=t.z
return this.lr(a,b,c,s,s,s)},
lm(a){return a},
df(a){var s=t.z
return this.lm(a,s,s,s)}}
A.l3.prototype={
$0(){return this.a.eg(this.b)},
$S:2}
A.lh.prototype={
$0(){A.pt(this.a,this.b)},
$S:2}
A.eQ.prototype={
gp(a){return this.a},
gbM(){return new A.eR(this,this.$ti.n("eR<1>"))},
a5(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.ie(a)},
ie(a){var s=this.d
if(s==null)return!1
return this.ci(this.eL(s,a),a)>=0},
k(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.o0(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.o0(q,b)
return r}else return this.i7(b)},
i7(a){var s,r,q=this.d
if(q==null)return null
s=this.eL(q,a)
r=this.ci(s,a)
return r<0?null:s[r+1]},
m(a,b,c){var s,r,q,p,o,n,m=this
if(typeof b=="string"&&b!=="__proto__"){s=m.b
m.eK(s==null?m.b=A.mk():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=m.c
m.eK(r==null?m.c=A.mk():r,b,c)}else{q=m.d
if(q==null)q=m.d=A.mk()
p=A.ia(b)&1073741823
o=q[p]
if(o==null){A.ml(q,p,[b,c]);++m.a
m.e=null}else{n=m.ci(o,b)
if(n>=0)o[n+1]=c
else{o.push(b,c);++m.a
m.e=null}}}},
bk(a,b){var s,r,q,p,o,n=this,m=n.eN()
for(s=m.length,r=n.$ti.y[1],q=0;q<s;++q){p=m[q]
o=n.k(0,p)
b.$2(p,o==null?r.a(o):o)
if(m!==n.e)throw A.e(A.aO(n))}},
eN(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.a3(i.a,null,!1,t.z)
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
eK(a,b,c){if(a[b]==null){++this.a
this.e=null}A.ml(a,b,c)},
eL(a,b){return a[A.ia(b)&1073741823]}}
A.dq.prototype={
ci(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.eR.prototype={
gp(a){return this.a.a},
gG(a){var s=this.a
return new A.hU(s,s.eN(),this.$ti.n("hU<1>"))}}
A.hU.prototype={
gK(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.e(A.aO(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}}}
A.eT.prototype={
gG(a){var s=this,r=new A.hX(s,s.r,A.i(s).n("hX<1>"))
r.c=s.e
return r},
gp(a){return this.a},
bK(a,b){var s,r,q=this
if(typeof b=="string"&&b!=="__proto__"){s=q.b
return q.eJ(s==null?q.b=A.mm():s,b)}else if(typeof b=="number"&&(b&1073741823)===b){r=q.c
return q.eJ(r==null?q.c=A.mm():r,b)}else return q.hT(b)},
hT(a){var s,r,q=this,p=q.d
if(p==null)p=q.d=A.mm()
s=q.ic(a)
r=p[s]
if(r==null)p[s]=[q.dv(a)]
else{if(q.ci(r,a)>=0)return!1
r.push(q.dv(a))}return!0},
eJ(a,b){if(a[b]!=null)return!1
a[b]=this.dv(b)
return!0},
dv(a){var s=this,r=new A.l_(a)
if(s.e==null)s.e=s.f=r
else s.f=s.f.b=r;++s.a
s.r=s.r+1&1073741823
return r},
ic(a){return J.av(a)&1073741823},
ci(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.aK(a[r].a,b))return r
return-1}}
A.l_.prototype={}
A.hX.prototype={
gK(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.c,q=s.a
if(s.b!==q.r)throw A.e(A.aO(q))
else if(r==null){s.d=null
return!1}else{s.d=r.a
s.c=r.b
return!0}}}
A.jo.prototype={
$2(a,b){this.a.m(0,this.b.a(a),this.c.a(b))},
$S:19}
A.E.prototype={
gG(a){return new A.d6(a,this.gp(a),A.aW(a).n("d6<E.E>"))},
bA(a,b){return this.k(a,b)},
ga4(a){return this.gp(a)===0},
gfV(a){if(this.gp(a)===0)throw A.e(A.e7())
return this.k(a,0)},
gd8(a){if(this.gp(a)===0)throw A.e(A.e7())
return this.k(a,this.gp(a)-1)},
by(a,b){var s,r=this.gp(a)
for(s=0;s<r;++s){if(J.aK(this.k(a,s),b))return!0
if(r!==this.gp(a))throw A.e(A.aO(a))}return!1},
bN(a,b,c){return new A.bk(a,b,A.aW(a).n("@<E.E>").aG(c).n("bk<1,2>"))},
bh(a,b){return A.di(a,b,null,A.aW(a).n("E.E"))},
ha(a,b){return A.di(a,0,A.f6(b,"count",t.p),A.aW(a).n("E.E"))},
bX(a,b,c){var s,r=this.gp(a)
A.cn(b,c,r)
s=A.o(this.hl(a,b,c),A.aW(a).n("E.E"))
return s},
hl(a,b,c){A.cn(b,c,this.gp(a))
return A.di(a,b,c,A.aW(a).n("E.E"))},
ao(a,b,c,d){var s
A.cn(b,c,this.gp(a))
for(s=b;s<c;++s)this.m(a,s,d)},
a1(a,b,c,d,e){var s,r,q,p,o
A.cn(b,c,this.gp(a))
s=c-b
if(s===0)return
A.aR(e,"skipCount")
if(t.j.b(d)){r=e
q=d}else{q=J.lF(d,e).dh(0,!1)
r=0}p=J.a6(q)
if(r+s>p.gp(q))throw A.e(A.nu())
if(r<b)for(o=s-1;o>=0;--o)this.m(a,b+o,p.k(q,r+o))
else for(o=0;o<s;++o)this.m(a,b+o,p.k(q,r+o))},
aI(a,b,c,d){return this.a1(a,b,c,d,0)},
em(a,b,c){this.aI(a,b,b+c.length,c)},
B(a){return A.jb(a,"[","]")},
$iv:1,
$id:1,
$iA:1}
A.bD.prototype={
bk(a,b){var s,r,q,p
for(s=this.gbM(),s=s.gG(s),r=A.i(this).y[1];s.E();){q=s.gK()
p=this.k(0,q)
b.$2(q,p==null?r.a(p):p)}},
eb(a,b,c,d){var s,r,q,p,o,n=A.D(c,d)
for(s=this.gbM(),s=s.gG(s),r=A.i(this).y[1];s.E();){q=s.gK()
p=this.k(0,q)
o=b.$2(q,p==null?r.a(p):p)
n.m(0,o.a,o.b)}return n},
gp(a){var s=this.gbM()
return s.gp(s)},
B(a){return A.lW(this)},
$iay:1}
A.jq.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.x(a)
r.a=(r.a+=s)+": "
s=A.x(b)
r.a+=s},
$S:17}
A.ec.prototype={
gG(a){var s=this
return new A.hY(s,s.c,s.d,s.b,s.$ti.n("hY<1>"))},
ga4(a){return this.b===this.c},
gp(a){return(this.c-this.b&this.a.length-1)>>>0},
bA(a,b){var s=this,r=s.gp(0)
if(0>b||b>=r)A.Y(A.iX(b,r,s,null,"index"))
r=s.a
r=r[(s.b+b&r.length-1)>>>0]
return r==null?s.$ti.c.a(r):r},
e_(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this
if(t.j.b(b)){s=b.length
r=h.gp(0)
q=r+s
p=h.a
o=p.length
if(q>=o){n=A.a3(A.pX(q+(q>>>1)),null,!1,h.$ti.n("1?"))
h.c=h.kC(n)
h.a=n
h.b=0
B.k.a1(n,r,q,b,0)
h.c+=s}else{q=h.c
m=o-q
if(s<m){B.k.a1(p,q,q+s,b,0)
h.c+=s}else{l=s-m
B.k.a1(p,q,q+m,b,0)
B.k.a1(h.a,0,l,b,m)
h.c=l}}++h.d}else for(q=J.f9(b),p=h.$ti.n("1?");q.E();){k=q.gK()
o=h.a
j=h.c
o[j]=k
o=o.length
j=(j+1&o-1)>>>0
h.c=j
if(h.b===j){n=A.a3(o*2,null,!1,p)
o=h.a
j=h.b
i=o.length-j
B.k.a1(n,0,i,o,j)
B.k.a1(n,i,i+h.b,h.a,0)
h.b=0
h.c=h.a.length
h.a=n}++h.d}},
B(a){return A.jb(this,"{","}")},
h8(){var s,r,q=this,p=q.b
if(p===q.c)throw A.e(A.e7());++q.d
s=q.a
r=s[p]
if(r==null)r=q.$ti.c.a(r)
s[p]=null
q.b=(p+1&s.length-1)>>>0
return r},
kC(a){var s,r,q=this,p=q.b,o=q.c,n=q.a
if(p<=o){s=o-p
B.k.a1(a,0,s,n,p)
return s}else{r=n.length-p
B.k.a1(a,0,r,n,p)
B.k.a1(a,r,r+q.c,q.a,0)
return q.c+r}}}
A.hY.prototype={
gK(){var s=this.e
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a
if(r.c!==q.d)A.Y(A.aO(q))
s=r.d
if(s===r.b){r.e=null
return!1}q=q.a
r.e=q[s]
r.d=(s+1&q.length-1)>>>0
return!0}}
A.bG.prototype={
bN(a,b,c){return new A.bR(this,b,A.i(this).n("@<1>").aG(c).n("bR<1,2>"))},
B(a){return A.jb(this,"{","}")},
bh(a,b){return A.nO(this,b,A.i(this).c)},
$iv:1,
$id:1,
$iey:1}
A.eY.prototype={}
A.la.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:15}
A.l9.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:15}
A.l6.prototype={
e4(a){var s,r,q=A.cn(0,null,a.length)
for(s=0;s<q;++s){r=a[s]
if((r&4294967040)!==0){if(!this.a)throw A.e(A.lM("Invalid value in input: "+r,null,null))
return this.ig(a,0,q)}}return A.eB(a,0,q)},
ig(a,b,c){var s,r,q
for(s=b,r="";s<c;++s){q=a[s]
r+=A.dc((q&4294967040)!==0?65533:q)}return r.charCodeAt(0)==0?r:r}}
A.fi.prototype={}
A.fn.prototype={}
A.it.prototype={}
A.jk.prototype={
c7(a){var s=B.cC.e4(a)
return s}}
A.jl.prototype={}
A.kf.prototype={
kM(a,b){return(b===!0?B.ko:B.kn).e4(a)}}
A.hD.prototype={
e4(a){return new A.i5(this.a).eO(a,0,null,!0)}}
A.i5.prototype={
eO(a,b,c,d){var s,r,q,p,o,n,m=this,l=A.cn(b,c,a.length)
if(b===l)return""
if(a instanceof Uint8Array){s=a
r=s
q=0}else{r=A.rG(a,b,l)
l-=b
q=b
b=0}if(l-b>=15){p=m.a
o=A.rF(p,r,b,l)
if(o!=null){if(!p)return o
if(o.indexOf("\ufffd")<0)return o}}o=m.dA(r,b,l,!0)
p=m.b
if((p&1)!==0){n=A.rH(p)
m.b=0
throw A.e(A.lM(n,a,q+m.c))}return o},
dA(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.a.W(b+c,2)
r=q.dA(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.dA(a,s,c,d)}return q.kR(a,b,c,d)},
kR(a,b,c,d){var s,r,q,p,o,n,m,l=this,k=65533,j=l.b,i=l.c,h=new A.eA(""),g=b+1,f=a[b]
A:for(s=l.a;;){for(;;g=p){r="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE".charCodeAt(f)&31
i=j<=32?f&61694>>>r:(f&63|i<<6)>>>0
j=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA".charCodeAt(j+r)
if(j===0){q=A.dc(i)
h.a+=q
if(g===c)break A
break}else if((j&1)!==0){if(s)switch(j){case 69:case 67:q=A.dc(k)
h.a+=q
break
case 65:q=A.dc(k)
h.a+=q;--g
break
default:q=A.dc(k)
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
break}p=n}if(o-g<20)for(m=g;m<o;++m){q=A.dc(a[m])
h.a+=q}else{q=A.eB(a,g,o)
h.a+=q}if(o===c)break A
g=p}else g=p}if(d&&j>32)if(s){s=A.dc(k)
h.a+=s}else{l.b=77
l.c=c
return""}l.b=j
l.c=i
s=h.a
return s.charCodeAt(0)==0?s:s}}
A.fo.prototype={
P(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.fo)if(this.a===b.a)s=this.b===b.b
return s},
gH(a){return A.lX(this.a,this.b,B.B,B.B)},
B(a){var s=this,r=A.pr(A.qi(s)),q=A.fp(A.qg(s)),p=A.fp(A.qc(s)),o=A.fp(A.qd(s)),n=A.fp(A.qf(s)),m=A.fp(A.qh(s)),l=A.na(A.qe(s)),k=s.b,j=k===0?"":A.na(k)
return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"}}
A.kJ.prototype={
B(a){return this.a6()}}
A.T.prototype={
gce(){return A.qb(this)}}
A.fc.prototype={
B(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.iu(s)
return"Assertion failed"}}
A.bq.prototype={}
A.aY.prototype={
gdD(){return"Invalid argument"+(!this.a?"(s)":"")},
gdC(){return""},
B(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.x(p),n=s.gdD()+q+o
if(!s.a)return n
return n+s.gdC()+": "+A.iu(s.ge9())},
ge9(){return this.b}}
A.bn.prototype={
ge9(){return this.b},
gdD(){return"RangeError"},
gdC(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.x(q):""
else if(q==null)s=": Not greater than or equal to "+A.x(r)
else if(q>r)s=": Not in inclusive range "+A.x(r)+".."+A.x(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.x(r)
return s}}
A.fI.prototype={
ge9(){return this.b},
gdD(){return"RangeError"},
gdC(){if(this.b<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
$ibn:1,
gp(a){return this.f}}
A.eF.prototype={
B(a){return"Unsupported operation: "+this.a}}
A.hA.prototype={
B(a){return"UnimplementedError: "+this.a}}
A.bH.prototype={
B(a){return"Bad state: "+this.a}}
A.fl.prototype={
B(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.iu(s)+"."}}
A.h8.prototype={
B(a){return"Out of Memory"},
gce(){return null},
$iT:1}
A.ez.prototype={
B(a){return"Stack Overflow"},
gce(){return null},
$iT:1}
A.kK.prototype={
B(a){return"Exception: "+this.a}}
A.be.prototype={
B(a){var s=this.a,r=""!==s?"FormatException: "+s:"FormatException",q=this.c
return q!=null?r+(" (at offset "+A.x(q)+")"):r}}
A.d.prototype={
bN(a,b,c){return A.pY(this,b,A.i(this).n("d.E"),c)},
dh(a,b){var s=A.i(this).n("d.E")
if(b)s=A.o(this,s)
else{s=A.o(this,s)
s.$flags=1
s=s}return s},
gp(a){var s,r=this.gG(this)
for(s=0;r.E();)++s
return s},
bh(a,b){return A.nO(this,b,A.i(this).n("d.E"))},
bA(a,b){var s,r
A.aR(b,"index")
s=this.gG(this)
for(r=b;s.E();){if(r===0)return s.gK();--r}throw A.e(A.iX(b,b-r,this,null,"index"))},
B(a){return A.pP(this,"(",")")}}
A.az.prototype={
B(a){return"MapEntry("+A.x(this.a)+": "+A.x(this.b)+")"}}
A.ad.prototype={
gH(a){return A.n.prototype.gH.call(this,0)},
B(a){return"null"}}
A.n.prototype={$in:1,
P(a,b){return this===b},
gH(a){return A.db(this)},
B(a){return"Instance of '"+A.hi(this)+"'"},
gap(a){return A.dB(this)},
toString(){return this.B(this)}}
A.f_.prototype={
B(a){return this.a},
$iah:1}
A.eA.prototype={
gp(a){return this.a.length},
B(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.fs.prototype={
B(a){return"Expando:null"}}
A.jr.prototype={
B(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.lx.prototype={
$1(a){var s,r,q,p
if(A.om(a))return a
s=this.a
if(s.a5(a))return s.k(0,a)
if(t.O.b(a)){r={}
s.m(0,a,r)
for(s=a.gbM(),s=s.gG(s);s.E();){q=s.gK()
r[q]=this.$1(a.k(0,q))}return r}else if(t.Y.b(a)){p=[]
s.m(0,a,p)
B.k.e_(p,J.n_(a,this,t.z))
return p}else return a},
$S:16}
A.lz.prototype={
$1(a){return this.a.d6(a)},
$S:7}
A.lA.prototype={
$1(a){if(a==null)return this.a.fR(new A.jr(a===undefined))
return this.a.fR(a)},
$S:7}
A.lm.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h
if(A.ol(a))return a
s=this.a
a.toString
if(s.a5(a))return s.k(0,a)
if(a instanceof Date){r=a.getTime()
if(r<-864e13||r>864e13)A.Y(A.ae(r,-864e13,864e13,"millisecondsSinceEpoch",null))
A.f6(!0,"isUtc",t.y)
return new A.fo(r,0,!0)}if(a instanceof RegExp)throw A.e(A.aZ("structured clone of RegExp",null))
if(a instanceof Promise)return A.u8(a,t.X)
q=Object.getPrototypeOf(a)
if(q===Object.prototype||q===null){p=t.X
o=A.D(p,p)
s.m(0,a,o)
n=Object.keys(a)
m=[]
for(s=J.aC(n),p=s.gG(n);p.E();)m.push(A.mE(p.gK()))
for(l=0;l<s.gp(n);++l){k=s.k(n,l)
j=m[l]
if(k!=null)o.m(0,j,this.$1(a[k]))}return o}if(a instanceof Array){i=a
o=[]
s.m(0,a,o)
h=a.length
for(s=J.aC(i),l=0;l<h;++l)o.push(this.$1(s.k(i,l)))
return o}return a},
$S:16}
A.iJ.prototype={
hy(a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=a0.length
for(s=0;s<a;++s){r=a0[s]
if(r>b.b)b.b=r
if(r<b.c)b.c=r}r=b.b
if(r>15)throw A.e(B.cp)
q=new Uint16Array(r+1)
for(p=a0.length,o=0;o<p;++o){n=a0[o]
if(n!==0)q[n]=q[n]+1}for(m=1,l=1;l<=r;++l){m=(m<<1>>>0)-q[l]
if(m<0)throw A.e(B.cr)}if(m>0)p=r>(a1?0:1)
else p=!1
if(p)throw A.e(B.cq)
k=B.a.X(1,r)
r=new Uint32Array(k)
b.a=r
for(p=b.b,j=1,i=0,h=2;j<=p;){for(g=j<<16,s=0;s<a;++s)if(a0[s]===j){for(f=i,e=0,d=0;d<j;++d){e=(e<<1|f&1)>>>0
f=f>>>1}for(c=(g|s)>>>0,d=e;d<k;d+=h)r[d]=c;++i}++j
i=i<<1>>>0
h=h<<1>>>0}}}
A.e3.prototype={
a6(){return"InflateFormat."+this.b}}
A.fJ.prototype={
gl3(){var s,r=this.x
if(r==null)return 32768
s=r.e+r.f-this.y
return s>32768?s:32768},
kQ(a){var s,r,q,p,o,n,m,l,k=this,j="Truncated zlib stream"
switch(k.w.a){case 0:s=k.a
r=s.c
q=s.d
q===$&&A.b()
if(r>=q){if(k.e===0&&k.b!==B.cv)throw A.e(A.aL("Empty input is not a "+k.b.b+" stream"))
k.w=B.bO
return!1}if(k.b===B.af)if(!k.jU()){if(k.e!==0)throw A.e(A.aL("Data after the last gzip member"))
s.c=r
k.b=B.S}if(k.b===B.S){if(s.gp(0)<2)A.Y(A.aL(j))
p=s.F()
o=s.F()
if((p&15)!==8)A.Y(A.aL("Only deflate compression is supported"))
if(B.a.a2(p*256+o,31)!==0)A.Y(A.aL("Invalid zlib header"))
if((o&32)!==0)A.Y(A.aL("zlib preset dictionaries are not supported"))}k.f=a.e+a.f
k.r=k.b===B.S?1:0
k.d=new A.iY(s,a)
k.w=B.ks
return!0
case 1:if(!k.d.l4())k.w=B.kt
k.x=null
return!0
case 2:s=k.b
if(s===B.af){s=k.a
if(s.gp(0)<8)throw A.e(A.aL("Truncated gzip stream"))
s.j()
n=s.j()
if(B.a.a2(a.e+a.f-k.f,4294967296)!==n)throw A.e(A.aL("gzip member length does not match"))}else if(s===B.S){s=k.a
if(s.gp(0)<4)throw A.e(A.aL(j))
for(m=0,l=0;l<4;++l){r=s.b
r.toString
m=m<<8|r[s.c++]}}++k.e
s=k.b===B.af
k.w=s?B.ay:B.bO
return s
case 3:return!1}},
jU(){var s,r,q=this.a
if(q.gp(0)<10)return!1
if(q.l()!==35615)return!1
if(q.F()!==8)return!1
s=q.F()
q.j()
q.F()
q.F()
if((s&4)!==0){if(q.gp(0)<2)return!1
r=q.l()
if(q.gp(0)<r)return!1
q.bh(0,r)}if((s&8)!==0&&!this.fp())return!1
if((s&16)!==0&&!this.fp())return!1
if((s&2)!==0){if(q.gp(0)<2)return!1
q.l()}return!0},
fp(){var s,r,q=this.a
for(;;){s=q.c
r=q.d
r===$&&A.b()
if(!(s<r))break
r=q.b
r.toString
q.c=s+1
if(r[s]===0)return!0}return!1}}
A.dt.prototype={
a6(){return"_State."+this.b}}
A.iY.prototype={
l4(){var s,r="Invalid deflate data",q=null
try{q=this.jo()}catch(s){if(t.fL.b(A.ar(s)))throw A.e(A.aL(r))
else throw s}if(!q&&!this.f)throw A.e(A.aL(r))
return q},
gbH(){var s=this.a
if(s==null)return s
s.d===$&&A.b()
return s},
jo(){var s,r,q,p=this,o=p.gbH()
if(o!=null){s=o.c
r=o.d
r===$&&A.b()
r=s>=r
s=r}else s=!0
if(s)return!1
q=p.b7(3)
s=(q&1)===0
switch(B.a.i(q,1)){case 0:if(p.jy()===-1)return!1
break
case 1:if(p.eS($.oT(),$.oS())===-1)return!1
break
case 2:if(p.jp()===-1)return!1
break
default:return!1}if(!s)p.f=!0
return s},
b7(a){var s,r,q,p,o=this
if(a===0)return 0
while(s=o.w,s<a){s=o.gbH()
r=s.c
s=s.d
s===$&&A.b()
if(r>=s)return-1
s=o.gbH()
r=s.b
r.toString
q=r[s.c++]
s=o.r
r=o.w
o.r=(s|B.a.X(q,r))>>>0
o.w=r+8}r=o.r
p=B.a.N(1,a)
o.r=B.a.a3(r,a)
o.w=s-a
return(r&p-1)>>>0},
dS(a){var s,r,q,p,o,n,m=this,l=a.a
l===$&&A.b()
s=a.b
while(m.w<s){r=m.gbH()
q=r.c
r=r.d
r===$&&A.b()
if(q>=r)break
r=m.gbH()
q=r.b
q.toString
p=q[r.c++]
r=m.r
q=m.w
m.r=(r|B.a.X(p,q))>>>0
m.w=q+8}r=m.r
o=l[(r&B.a.X(1,s)-1)>>>0]
n=o>>>16
if(n===0||n>m.w)return-1
m.r=B.a.a3(r,n)
m.w-=n
return o&65535},
jy(){var s,r=this
r.w=r.r=0
s=r.b7(16)
if(s!==(r.b7(16)^65535)>>>0)return-1
if(s>r.gbH().gp(0))return-1
r.c.hh(r.gbH().a7(s))
return 0},
jp(){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.b7(5)
if(f===-1)return-1
f+=257
if(f>286)return-1
s=g.b7(5)
if(s===-1)return-1;++s
if(s>32)return-1
r=g.b7(4)
if(r===-1)return-1
r+=4
if(r>19)return-1
q=new Uint8Array(19)
for(p=0;p<r;++p){o=g.b7(3)
if(o===-1)return-1
q[B.ip[p]]=o}n=g.fs(q,!0)
if(n==null)return-1
m=f+s
l=new Uint8Array(m)
k=J.a2(B.c.gA(l),0,f)
j=J.a2(B.c.gA(l),f,s)
if(g.ii(m,n,l)===-1)return-1
i=g.fq(k)
m=i==null
h=m?null:g.fq(j)
if(m||h==null)return-1
return g.eS(i,h)},
fs(a,b){var s,r
try{s=A.lO(a,b)
return s}catch(r){if(A.ar(r) instanceof A.be)return null
else throw r}},
fq(a){return this.fs(a,!1)},
eS(a,b){var s,r,q,p,o,n,m,l,k,j=this
for(s=j.c;;){r=j.dS(a)
if(r<0||r>285)return-1
if(r===256)break
if(r<256){s.C(r&255)
continue}q=r-257
p=j.b7(B.jn[q])
if(p<0)return-1
o=B.iG[q]
n=j.dS(b)
if(n<0||n>29)return-1
m=j.b7(B.eM[n])
if(m<0)return-1
l=B.iL[n]+m
if(l<1||l>s.gp(s))return-1
s.hf(l,o+p)}while(s=j.w,s>=8){j.w=s-8
s=j.gbH()
o=s.c
if(1>=o)s.c=0
else{k=s.d
k===$&&A.b()
if(1<=o-k)s.c=k
else s.c=o-1}}return 0},
ii(a,b,c){var s,r,q,p,o,n,m,l,k=this
for(s=c.$flags|0,r=0,q=0;q<a;){p=k.dS(b)
if(p===-1)return-1
o=0
switch(p){case 16:if(q===0)return-1
n=k.b7(2)
if(n===-1)return-1
n+=3
if(q+n>a)return-1
for(;m=n-1,n>0;n=m,q=l){l=q+1
s&2&&A.a(c)
c[q]=r}break
case 17:n=k.b7(3)
if(n===-1)return-1
n+=3
if(q+n>a)return-1
for(;m=n-1,n>0;n=m,q=l){l=q+1
s&2&&A.a(c)
c[q]=0}r=o
break
case 18:n=k.b7(7)
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
A.fa.prototype={}
A.fh.prototype={
a6(){return"ByteOrder."+this.b}}
A.fK.prototype={
gee(){return this.e},
en(a){return this.e=a},
gp(a){var s=this,r=s.d
if(r!=null)return Math.max(0,r-s.e)
return s.b.h7(s.c+s.e)},
gla(){var s,r,q=this,p=q.d
if(p!=null&&q.e>=p)return!0
s=q.b
r=q.c+q.e
s.cS(r,1)
return r>=s.e+s.f},
fP(){if(this.c===0&&this.d==null){var s=this.b
s.d=new Uint8Array(0)
s.e=s.e+s.f
s.f=0
s.w=!0}},
es(a,b){var s=this.d
if(s!=null)a=Math.min(a,Math.max(0,s-b))
return A.ns(this,b,a)},
F(){var s,r=this
if(r.gla())return 0
s=r.b.kG(r.c+r.e);++r.e
return s},
a7(a){var s,r,q=this,p=q.d
if(p!=null)a=Math.max(0,Math.min(a,p-q.e))
s=q.e
r=A.ns(q,s,a)
q.e=s+a
return r},
U(){var s,r,q=this,p=q.d
if(p!=null){s=q.e
return q.b.h4(q.c+s,Math.max(0,p-s))}s=q.b
r=q.c+q.e
return s.h4(r,s.h7(r))}}
A.kG.prototype={
gp(a){return this.e+this.f},
cS(a,b){var s,r=this,q=r.e
if(a<q)throw A.e(A.aL("Position "+a+" of the decoded data has already been read past, only the last "+r.f+" bytes from "+q+" are still held"))
r.r=a
q=r.b
s=a+b
for(;;){if(!(!r.w&&r.e+r.f<s))break
if(!q.kQ(r))r.w=!0}},
kG(a){var s,r=this
r.cS(a,1)
s=r.e
if(a>=s+r.f)return 0
return r.d[a-s]},
h4(a,b){var s,r,q=this
q.cS(a,b)
s=q.e
r=Math.max(0,Math.min(b,s+q.f-a))
if(r===0)return new Uint8Array(0)
s=a-s
return B.c.bX(q.d,s,s+r)},
h7(a){this.cS(a,1125899906842624)
return Math.max(0,this.e+this.f-a)},
dV(a){var s,r,q,p,o=this,n=o.f,m=o.d
if(n+a<=m.length)return
s=o.e
r=Math.max(s,Math.min(o.r-o.c,s+n-o.b.gl3()))-s
if(r>0){B.c.a1(m,0,n-r,m,r)
n=o.f-=r
o.e+=r}m=n+a
s=o.d
q=s.length
if(m>q){m=Math.max(q*2,m)
p=new Uint8Array(m)
B.c.aI(p,0,n,s)
o.d=p}},
C(a){var s,r,q=this
if(q.f===q.d.length)q.dV(1)
s=q.d
r=q.f++
s.$flags&2&&A.a(s)
s[r]=a},
bt(a){var s,r,q=this,p=a.length
q.dV(p)
s=q.d
r=q.f
B.c.aI(s,r,r+p,a)
q.f+=p},
hh(a){return this.bt(a.U())},
hf(a,b){var s,r,q,p,o,n,m,l,k,j=this
j.dV(b)
s=j.f
r=s-a
if(r<0)throw A.e(A.aL("Back reference before the start of the data"))
q=s+b
if(a>=b){p=j.d
B.c.a1(p,s,q,p,r)}else for(p=j.d,o=p.$flags|0,n=r;s<q;s=m,n=l){m=s+1
l=n+1
k=p[n]
o&2&&A.a(p)
p[s]=k}j.f+=b}}
A.fL.prototype={
gee(){return this.c},
gp(a){var s=this.b
return s==null?0:s.length-this.c},
en(a){this.c=a},
bh(a,b){var s,r=this,q=r.d
q===$&&A.b()
s=r.c
if(b>=q-s)r.c=q
else if(b<=-s)r.c=0
else r.c=s+b},
es(a,b){var s=this.b
if(s==null)return A.j_(A.m([],t.t),B.a3,null,null)
return A.j_(s,this.a,a,b)},
F(){var s=this.b
s.toString
return s[this.c++]},
U(){var s,r,q,p,o=this,n=o.b
if(n==null)return new Uint8Array(0)
s=o.gp(0)
r=n.length
q=o.c
p=r-q
if(s<0||s>p)s=p
if(q<0)throw A.e(A.ae(q,0,r,"position",null))
return J.a2(B.c.gA(n),o.b.byteOffset+o.c,s)}}
A.j0.prototype={
l(){var s=this.F(),r=this.F()
if(this.a===B.aA)return(s<<8|r)>>>0
return(r<<8|s)>>>0},
j(){var s=this,r=s.F(),q=s.F(),p=s.F(),o=s.F()
if(s.a===B.aA)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
a7(a){var s=this,r=s.es(a,s.gee())
s.en(s.gee()+r.gp(r))
return r}}
A.lY.prototype={
C(a){var s,r,q=this
if(q.b===q.c.length)q.jn()
s=q.c
r=q.b++
s.$flags&2&&A.a(s)
s[r]=a},
hh(a){var s,r,q,p,o=this
while(s=o.b,r=a.gp(a),q=o.c,s+r>q.length)o.dO(o.b+a.gp(a)-o.c.length)
if(a instanceof A.fL){s=a.b
if(s!=null){r=o.b
B.c.a1(q,r,r+a.gp(0),s,a.c)}}else{p=a.U()
s=o.c
r=o.b
q=p.length
B.c.a1(s,r,r+q,p,0)
o.b+=q
return}o.b=o.b+a.gp(0)},
hf(a,b){var s,r,q,p,o,n,m,l,k,j=this
while(s=j.b,r=s+b,q=j.c,p=q.length,r>p)j.dO(r-p)
o=s-a
if(a>=b)B.c.a1(q,s,r,q,o)
else for(p=q.$flags|0,n=o;s<r;s=m,n=l){m=s+1
l=n+1
k=q[n]
p&2&&A.a(q)
q[s]=k}j.b+=b},
dO(a){var s,r=this.c,q=r.length,p=q+(a==null?1:a),o=q===0?32768:q*2
if(o<p)o=p
s=new Uint8Array(o)
B.c.aI(s,0,q,r)
this.c=s},
jn(){return this.dO(null)},
gp(a){return this.b}}
A.ju.prototype={}
A.il.prototype={
a6(){return"Channel."+this.b}}
A.P.prototype={
E(){var s=this.b
return++this.a<s.gp(s)},
gK(){return this.b.k(0,this.a)}}
A.cA.prototype={
O(){return new A.cA(new Uint16Array(A.t(this.a)))},
gJ(){return B.z},
gp(a){return this.a.length},
gR(){return null},
k(a,b){var s,r=this.a
if(b<r.length){r=r[b]
s=$.G
r=(s!=null?s:A.L())[r]}else r=0
return r},
m(a,b,c){var s,r=this.a
if(b<r.length){s=A.H(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gM(){return this.gq()},
gq(){var s,r=this.a
if(!B.A.ga4(r)){r=r[0]
s=$.G
r=(s!=null?s:A.L())[r]}else r=0
return r},
gu(){var s=this.a,r=s.length
if(r===2){s=s[0]
r=$.G
s=(r!=null?r:A.L())[s]}else if(r>1){s=s[1]
r=$.G
s=(r!=null?r:A.L())[s]}else s=0
return s},
gv(){var s=this.a,r=s.length
if(r===2){s=s[0]
r=$.G
s=(r!=null?r:A.L())[s]}else if(r>2){s=s[2]
r=$.G
s=(r!=null?r:A.L())[s]}else s=0
return s},
gt(){var s=this.a,r=s.length
if(r===2){s=s[1]
r=$.G
s=(r!=null?r:A.L())[s]}else if(r>3){s=s[3]
r=$.G
s=(r!=null?r:A.L())[s]}else s=0
return s},
gV(){return this.gt()/1},
gah(){return this.a.length===2?this.gq():A.X(this)},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1}
A.cB.prototype={
O(){return new A.cB(new Float32Array(A.t(this.a)))},
gJ(){return B.C},
gp(a){return this.a.length},
gR(){return null},
k(a,b){var s=this.a
return b<s.length?s[b]:0},
m(a,b,c){var s=this.a
if(b<s.length){s.$flags&2&&A.a(s)
s[b]=c}},
gM(){var s=this.a
return!B.M.ga4(s)?s[0]:0},
gq(){var s=this.a
return!B.M.ga4(s)?s[0]:0},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gt(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:1
return s},
gV(){return this.gt()/1},
gah(){var s=this.a
if(s.length===2)s=!B.M.ga4(s)?s[0]:0
else s=A.X(this)
return s},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1}
A.cC.prototype={
O(){return new A.cC(new Float64Array(A.t(this.a)))},
gJ(){return B.K},
gp(a){return this.a.length},
gR(){return null},
k(a,b){var s=this.a
return b<s.length?s[b]:0},
m(a,b,c){var s=this.a
if(b<s.length){s.$flags&2&&A.a(s)
s[b]=c}},
gM(){var s=this.a
return!B.V.ga4(s)?s[0]:0},
gq(){var s=this.a
return!B.V.ga4(s)?s[0]:0},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gt(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:1
return s},
gV(){return this.gt()/1},
gah(){var s=this.a
if(s.length===2)s=!B.V.ga4(s)?s[0]:0
else s=A.X(this)
return s},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1}
A.cD.prototype={
O(){return new A.cD(new Int16Array(A.t(this.a)))},
gJ(){return B.P},
gp(a){return this.a.length},
gR(){return null},
k(a,b){var s=this.a
return b<s.length?s[b]:0},
m(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gM(){var s=this.a
return!B.N.ga4(s)?s[0]:0},
gq(){var s=this.a
return!B.N.ga4(s)?s[0]:0},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gt(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:0
return s},
gV(){return this.gt()/32767},
gah(){var s=this.a
if(s.length===2)s=!B.N.ga4(s)?s[0]:0
else s=A.X(this)
return s},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1}
A.cE.prototype={
O(){return new A.cE(new Int32Array(A.t(this.a)))},
gJ(){return B.Q},
gp(a){return this.a.length},
gR(){return null},
k(a,b){var s=this.a
return b<s.length?s[b]:0},
m(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gM(){var s=this.a
return!B.G.ga4(s)?s[0]:0},
gq(){var s=this.a
return!B.G.ga4(s)?s[0]:0},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gt(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:0
return s},
gV(){return this.gt()/2147483647},
gah(){var s=this.a
if(s.length===2)s=!B.G.ga4(s)?s[0]:0
else s=A.X(this)
return s},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1}
A.cF.prototype={
O(){return new A.cF(new Int8Array(A.t(this.a)))},
gJ(){return B.O},
gp(a){return this.a.length},
gR(){return null},
k(a,b){var s=this.a
return b<s.length?s[b]:0},
m(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gM(){var s=this.a
return!B.W.ga4(s)?s[0]:0},
gq(){var s=this.a
return!B.W.ga4(s)?s[0]:0},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gt(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:0
return s},
gV(){return this.gt()/127},
gah(){var s=this.a
if(s.length===2)s=!B.W.ga4(s)?s[0]:0
else s=A.X(this)
return s},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1}
A.cG.prototype={
O(){var s=this.b
s===$&&A.b()
return new A.cG(this.a,s)},
gJ(){return B.u},
gR(){return null},
bE(a){var s
if(a<this.a){s=this.b
s===$&&A.b()
s=B.a.Y(s,7-a)&1}else s=0
return s},
bZ(a,b){var s
if(a>=this.a)return
a=7-a
s=this.b
s===$&&A.b()
this.b=b!==0?(s|B.a.X(1,a))>>>0:(s&~(B.a.X(1,a)&255))>>>0},
k(a,b){return this.bE(b)},
m(a,b,c){return this.bZ(b,c)},
gM(){return this.bE(0)},
gq(){return this.bE(0)},
gu(){return this.bE(this.a===2?0:1)},
gv(){return this.bE(this.a===2?0:2)},
gt(){return this.bE(this.a===2?1:3)},
gV(){return this.bE(this.a===2?1:3)/1},
gah(){return this.a===2?this.bE(0):A.X(this)},
ag(a,b,c,d){var s,r=this
r.bZ(0,a)
s=r.a
if(s===2)r.bZ(1,d)
else if(s>2){r.bZ(1,b)
r.bZ(2,c)
r.bZ(3,d)}},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1,
gp(a){return this.a}}
A.cH.prototype={
O(){return new A.cH(new Uint16Array(A.t(this.a)))},
gJ(){return B.m},
gp(a){return this.a.length},
gR(){return null},
k(a,b){var s=this.a
return b<s.length?s[b]:0},
m(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gM(){var s=this.a
return!B.A.ga4(s)?s[0]:0},
gq(){var s=this.a
return!B.A.ga4(s)?s[0]:0},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gt(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:0
return s},
gV(){return this.gt()/65535},
gah(){var s=this.a
if(s.length===2)s=!B.A.ga4(s)?s[0]:0
else s=A.X(this)
return s},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1}
A.cI.prototype={
O(){var s=this.b
s===$&&A.b()
return new A.cI(this.a,s)},
gJ(){return B.x},
gR(){return null},
bF(a){var s
if(a<this.a){s=this.b
s===$&&A.b()
s=B.a.Y(s,6-(a<<1>>>0))&3}else s=0
return s},
c_(a,b){var s,r,q
if(a>=this.a)return
s=B.dC[a]
r=B.b.h(b)
q=this.b
q===$&&A.b()
this.b=(q&s|B.a.X(r&3,6-(a<<1>>>0)))>>>0},
k(a,b){return this.bF(b)},
m(a,b,c){return this.c_(b,c)},
gM(){return this.bF(0)},
gq(){return this.bF(0)},
gu(){return this.bF(this.a===2?0:1)},
gv(){return this.bF(this.a===2?0:2)},
gt(){return this.bF(this.a===2?1:3)},
gV(){return this.bF(this.a===2?1:3)/3},
gah(){return this.a===2?this.bF(0):A.X(this)},
ag(a,b,c,d){var s,r=this
r.c_(0,a)
s=r.a
if(s===2)r.c_(1,d)
else if(s>2){r.c_(1,b)
r.c_(2,c)
r.c_(3,d)}},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1,
gp(a){return this.a}}
A.cJ.prototype={
O(){return new A.cJ(new Uint32Array(A.t(this.a)))},
gJ(){return B.L},
gp(a){return this.a.length},
gR(){return null},
k(a,b){var s=this.a
return b<s.length?s[b]:0},
m(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gM(){var s=this.a
return!B.l.ga4(s)?s[0]:0},
gq(){var s=this.a
return!B.l.ga4(s)?s[0]:0},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gt(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:0
return s},
gV(){return this.gt()/4294967295},
gah(){var s=this.a
if(s.length===2)s=!B.l.ga4(s)?s[0]:0
else s=A.X(this)
return s},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1}
A.cK.prototype={
O(){return new A.cK(this.a,new Uint8Array(A.t(this.b)))},
gJ(){return B.y},
gR(){return null},
bG(a){var s
if(a<0||a>=this.a)s=0
else{s=this.b
s=a<2?B.a.Y(s[0],4-(a<<2>>>0))&15:B.a.Y(s[1],4-((a&1)<<2))&15}return s},
c5(a,b){var s,r,q,p
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
k(a,b){return this.bG(b)},
m(a,b,c){return this.c5(b,c)},
gM(){return this.bG(0)},
gq(){return this.bG(0)},
gu(){return this.bG(this.a===2?0:1)},
gv(){return this.bG(this.a===2?0:2)},
gt(){return this.bG(this.a===2?1:3)},
gV(){return this.bG(this.a===2?1:3)/15},
gah(){return this.a===2?this.bG(0):A.X(this)},
ag(a,b,c,d){var s,r=this
r.c5(0,a)
s=r.a
if(s===2)r.c5(1,d)
else if(s>2){r.c5(1,b)
r.c5(2,c)
r.c5(3,d)}},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1,
gp(a){return this.a}}
A.b_.prototype={
ht(a,b,c,d){var s=this.a
s.$flags&2&&A.a(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d},
O(){return new A.b_(new Uint8Array(A.t(this.a)))},
gJ(){return B.e},
gp(a){return this.a.length},
gR(){return null},
k(a,b){var s=this.a
return b<s.length?s[b]:0},
m(a,b,c){var s,r=this.a
if(b<r.length){s=B.b.h(c)
r.$flags&2&&A.a(r)
r[b]=s}},
gM(){var s=this.a
return!B.c.ga4(s)?s[0]:0},
gq(){var s=this.a
return!B.c.ga4(s)?s[0]:0},
gu(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>1?s[1]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2)s=s[0]
else s=r>2?s[2]:0
return s},
gt(){var s=this.a,r=s.length
if(r===2)s=s[1]
else s=r>3?s[3]:255
return s},
gV(){return this.gt()/255},
gah(){var s=this.a
if(s.length===2)s=!B.c.ga4(s)?s[0]:0
else s=A.X(this)
return s},
gG(a){return new A.P(this)},
P(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===this.a.length){s=b.gH(b)
r=A.o(this,A.i(this).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1}
A.fj.prototype={}
A.bQ.prototype={}
A.dI.prototype={
O(){return new A.dI(this.a)},
gJ(){return B.e},
gp(a){return 4},
gR(){return null},
k(a,b){var s
if(b>=0&&b<4){s=b<<3>>>0
s=B.a.a3((this.a&B.a.N(255,s))>>>0,s)}else s=0
return s},
m(a,b,c){},
gM(){return this.k(0,0)},
gq(){return this.k(0,0)},
gu(){return this.k(0,1)},
gv(){return this.k(0,2)},
gt(){return this.k(0,3)},
gV(){return this.gt()/255},
gah(){return A.X(this)},
gG(a){return new A.P(this)},
P(a,b){var s,r,q=this
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gp(b)===q.gp(q)){s=b.gH(b)
r=A.o(q,A.i(q).n("d.E"))
s=s===A.l(r)}return s},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
$iu:1}
A.fm.prototype={
gt(){return 255},
gV(){return 1},
gp(a){return 3}}
A.af.prototype={
a6(){return"Format."+this.b}}
A.fe.prototype={
a6(){return"BlendMode."+this.b}}
A.bT.prototype={
cF(a){var s=$.mV()
if(!s.a5(a))return"<unknown>"
return s.k(0,a).a},
B(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
for(s=e.a,r=new A.V(s,s.r,s.e,A.i(s).n("V<1>")),q=t.p,p=t.r,o=t.N,n=t.P,m="";r.E();){l=r.d
m+=l+"\n"
k=s.k(0,l)
for(l=k.a,l=new A.V(l,l.r,l.e,A.i(l).n("V<1>"));l.E();){j=l.d
i=k.k(0,j)
m=i==null?m+("\t"+e.cF(j)+"\n"):m+("\t"+e.cF(j)+": "+i.B(0)+"\n")}for(l=k.b.a,j=new A.V(l,l.r,l.e,A.i(l).n("V<1>"));j.E();){h=j.d
m+=h+"\n"
if(!l.a5(h))l.m(0,h,new A.aD(A.D(q,p),new A.b1(A.D(o,n))))
g=l.k(0,h)
for(h=g.a,h=new A.V(h,h.r,h.e,A.i(h).n("V<1>"));h.E();){f=h.d
i=g.k(0,f)
m=i==null?m+("\t"+e.cF(f)+"\n"):m+("\t"+e.cF(f)+": "+i.B(0)+"\n")}}}return m.charCodeAt(0)==0?m:m},
aK(a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5="exif",a6="interop",a7=a8.b
a8.b=!0
a8.aw(19789)
a8.aw(42)
a8.aH(8)
s=a4.a
if(s.k(0,"ifd0")==null)s.m(0,"ifd0",new A.aD(A.D(t.p,t.r),new A.b1(A.D(t.N,t.P))))
r=s.k(0,"ifd1")
q=a4.b
p=q!=null&&!B.c.ga4(q)&&r!=null
if(p){r.m(0,513,A.lP(0))
r.m(0,514,A.lP(q.length))}else if(r!=null){o=r.a
o.ca(0,513)
o.ca(0,514)}n=A.m(["ifd0"],t.s)
for(o=new A.V(s,s.r,s.e,A.i(s).n("V<1>"));o.E();){m=o.d
if(m!=="ifd0")n.push(m)}o=t.N
m=t.p
l=A.D(o,m)
for(k=n.length,j=t.r,i=t.P,h=8,g=0;g<n.length;n.length===k||(0,A.a0)(n),++g){f=n[g]
e=s.k(0,f)
e.toString
l.m(0,f,h)
d=e.b.a
if(d.a5(a5)){c=new Uint32Array(1)
c[0]=0
e.m(0,34665,new A.b2(c))}else e.a.ca(0,34665)
if(d.a5(a6)){c=new Uint32Array(1)
c[0]=0
e.m(0,40965,new A.b2(c))}else e.a.ca(0,40965)
if(d.a5("gps")){c=new Uint32Array(1)
c[0]=0
e.m(0,34853,new A.b2(c))}else e.a.ca(0,34853)
e=e.a
h+=2+12*e.a+4
for(e=new A.ag(e,e.r,e.e,A.i(e).n("ag<2>"));e.E();){c=e.d
b=B.F[c.gav().a]*c.gp(c)
if(b>4)h+=b}for(e=new A.V(d,d.r,d.e,A.i(d).n("V<1>"));e.E();){c=e.d
if(!d.a5(c))d.m(0,c,new A.aD(A.D(m,j),new A.b1(A.D(o,i))))
a=d.k(0,c)
a.toString
l.m(0,c,h)
a=a.a
a0=2+12*a.a
for(c=new A.ag(a,a.r,a.e,A.i(a).n("ag<2>"));c.E();){a=c.d
b=B.F[a.gav().a]*a.gp(a)
if(b>4)a0+=b}h+=a0}}if(p)r.k(0,513).bg(h)
a1=n.length
for(k=a1-1,a2=0;a2<a1;++a2){f=n[a2]
a3=s.k(0,f)
e=a3.b.a
if(e.a5(a5)){d=a3.k(0,34665)
d.toString
c=l.k(0,a5)
c.toString
d.bg(c)}if(e.a5(a6)){d=a3.k(0,40965)
d.toString
c=l.k(0,a6)
c.toString
d.bg(c)}if(e.a5("gps")){d=a3.k(0,34853)
d.toString
c=l.k(0,"gps")
c.toString
d.bg(c)}d=l.k(0,f)
d.toString
a4.fB(a8,a3,d+2+12*a3.a.a+4)
if(a2===k)a8.aH(0)
else{d=l.k(0,n[a2+1])
d.toString
a8.aH(d)}a4.fC(a8,a3)
for(d=new A.V(e,e.r,e.e,A.i(e).n("V<1>"));d.E();){c=d.d
if(!e.a5(c))e.m(0,c,new A.aD(A.D(m,j),new A.b1(A.D(o,i))))
a=e.k(0,c)
a.toString
c=l.k(0,c)
c.toString
a4.fB(a8,a,c+2+12*a.a.a)
a4.fC(a8,a)}}if(p)a8.bt(q)
a8.b=a7},
fB(a,b,c){var s,r,q,p,o,n,m=b.a
a.aw(m.a)
for(m=new A.V(m,m.r,m.e,A.i(m).n("V<1>"));m.E();){s=m.d
r=b.k(0,s)
r.toString
q=s===273
p=q&&r.gav()===B.D?B.n:r.gav()
o=q&&r.gav()===B.D?1:r.gp(r)
a.aw(s)
a.aw(p.a)
a.aH(o)
n=B.F[r.gav().a]*r.gp(r)
if(n<=4){r.aK(a)
while(n<4){a.C(0);++n}}else{a.aH(c)
c+=n}}return c},
fC(a,b){var s,r
for(s=b.a,s=new A.ag(s,s.r,s.e,A.i(s).n("ag<2>"));s.E();){r=s.d
if(B.F[r.gav().a]*r.gp(r)>4)r.aK(a)}},
bD(c6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3=this,c4="Length must be a non-negative integer: ",c5=c6.e
c6.e=!0
s=c6.d
a1=c6.l()
if(a1===18761){c6.e=!1
if(c6.l()!==42){c6.e=c5
return!1}}else if(a1===19789){c6.e=!0
if(c6.l()!==42){c6.e=c5
return!1}}else return!1
r=c6.j()
c3.c=0
q=0
a2=t.p
a3=A.nA(a2)
a4=c3.a
a5=t.gn
a6=c6.c
a7=t.r
a8=t.N
a9=t.P
for(;;){if(!(r>0&&q<64&&a3.bK(0,r)))break
try{b0=s+r
c6.d=b0
if(a6-b0<2)break
p=new A.aD(A.D(a2,a7),new A.b1(A.D(a8,a9)))
o=c6.l()
if(o*12>a6-c6.d)break
n=o
b0=n
if(b0<0)A.Y(A.aZ(c4+A.x(b0),null))
m=A.m(new Array(b0),a5)
for(l=0;l<n;++l)J.W(m,l,c3.fi(c6,s))
k=m
for(b0=k,b1=b0.length,b2=0;b2<b0.length;b0.length===b1||(0,A.a0)(b0),++b2){j=b0[b2]
if(j.b!=null){b3=j.a
b4=j.b
b4.toString
J.W(p,b3,b4)}}a4.m(0,"ifd"+A.x(q),p);++q
r=c6.j()}catch(b5){break}}for(b0=new A.ag(a4,a4.r,a4.e,A.i(a4).n("ag<2>"));b0.E();){i=b0.d
for(b1=B.bs.gbM(),b1=b1.gG(b1);b1.E();){h=b1.gK()
if(i.a.a5(h))try{g=J.c(i,h).h(0)
c6.d=s+g
f=new A.aD(A.D(a2,a7),new A.b1(A.D(a8,a9)))
e=c6.l()
d=e
b3=d
if(b3<0)A.Y(A.aZ(c4+A.x(b3),null))
c=A.m(new Array(b3),a5)
for(b=0;b<d;++b)J.W(c,b,c3.fi(c6,s))
a=c
for(b3=a,b4=b3.length,b2=0;b2<b3.length;b3.length===b4||(0,A.a0)(b3),++b2){a0=b3[b2]
if(a0.b!=null){b6=a0.a
b7=a0.b
b7.toString
J.W(f,b6,b7)}}b3=i.b
b4=B.bs.k(0,h)
b4.toString
b3.a.m(0,b4,f)}catch(b5){continue}}}c3.b=null
b8=a4.k(0,"ifd1")
if(b8!=null){a2=b8.a
a2=a2.a5(513)&&a2.a5(514)}else a2=!1
if(a2){b9=b8.k(0,513).h(0)
c0=b8.k(0,514).h(0)
c1=s+b9
if(c0>0&&c1>=s&&c1+c0<=a6){c2=c6.d
c6.d=c1
c3.b=c6.a7(c0).U()
c6.d=c2}}c6.e=c5
return!1},
fi(a,b){var s,r,q,p,o,n,m,l=a.l(),k=a.l(),j=a.j(),i=new A.hS(l,null)
if(k>=14)return i
s=B.bb[k]
r=j*B.F[k]
if(this.c+r>16777216)return i
q=a.d
if((r>4?a.d=a.j()+b:q)+r>a.c)return i
p=a.a7(r)
this.c+=r
switch(s.a){case 0:break
case 6:i.b=new A.bA(new Int8Array(A.t(J.lD(B.c.gA(p.U()),0,j))))
break
case 1:i.b=new A.bg(new Uint8Array(A.t(p.a7(j).U())))
break
case 7:i.b=new A.cT(new Uint8Array(A.t(p.a7(j).U())))
break
case 2:i.b=new A.bZ(j===0?"":p.aj(j-1))
break
case 3:i.b=A.no(p,j)
break
case 4:i.b=A.nj(p,j)
break
case 5:i.b=A.nk(p,j)
break
case 10:i.b=A.nm(p,j)
break
case 8:i.b=A.nn(p,j)
break
case 9:i.b=A.nl(p,j)
break
case 11:i.b=A.np(p,j)
break
case 12:i.b=A.ni(p,j)
break
case 13:if(j===1){o=new A.cR(0)
n=p.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=n
o.a=$.a1()[0]
i.b=o}break}a.d=q+4
return i}}
A.hS.prototype={}
A.fr.prototype={}
A.b1.prototype={
hz(a){a.a.bk(0,new A.iQ(this))},
ga4(a){var s,r=this.a
if(r.a===0)return!0
for(r=new A.ag(r,r.r,r.e,A.i(r).n("ag<2>"));r.E();){s=r.d
if(!(s.a.a===0&&s.b.ga4(0)))return!1}return!0},
k(a,b){var s=this.a
if(!s.a5(b))s.m(0,b,new A.aD(A.D(t.p,t.r),new A.b1(A.D(t.N,t.P))))
s=s.k(0,b)
s.toString
return s}}
A.iQ.prototype={
$2(a,b){var s=A.nh(b)
this.a.a.m(0,a,s)
return s},
$S:14}
A.aD.prototype={
kL(a){a.a.bk(0,new A.iR(this))
a.b.a.bk(0,new A.iS(this))},
k(a,b){var s=this.a.k(0,b)
return s},
m(a,b,c){this.a.m(0,b,c)},
gbC(){var s=this.a.k(0,274)
return s==null?null:s.h(0)},
sbC(a){this.a.ca(0,274)}}
A.iR.prototype={
$2(a,b){var s=b.O()
this.a.a.m(0,a,s)
return s},
$S:18}
A.iS.prototype={
$2(a,b){var s=A.nh(b)
this.a.b.a.m(0,a,s)
return s},
$S:14}
A.aa.prototype={
a6(){return"IfdValueType."+this.b}}
A.Z.prototype={
a8(a,b){return 0},
h(a){return this.a8(0,0)},
bd(){return new Uint8Array(0)},
B(a){return""},
P(a,b){var s=this
if(b==null)return!1
return b instanceof A.Z&&s.gav()===b.gav()&&s.gp(s)===b.gp(b)&&s.gH(s)===b.gH(b)},
gH(a){return 0},
bg(a){}}
A.bg.prototype={
O(){return new A.bg(new Uint8Array(A.t(this.a)))},
gav(){return B.aL},
gp(a){return this.a.length},
P(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bg){s=this.a
r=b.a
s=s.length===r.length&&A.l(s)===A.l(r)}else s=!1
return s},
gH(a){return A.l(this.a)},
a8(a,b){return this.a[b]},
h(a){return this.a8(0,0)},
bg(a){var s=this.a
s.$flags&2&&A.a(s)
s[0]=a},
bd(){return this.a},
aK(a){a.bt(this.a)},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.bZ.prototype={
O(){return new A.bZ(this.a)},
gav(){return B.j},
gp(a){return this.a.length+1},
P(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bZ){s=this.a
r=b.a
s=s.length+1===r.length+1&&B.E.gH(s)===B.E.gH(r)}else s=!1
return s},
gH(a){return B.E.gH(this.a)},
bd(){return new Uint8Array(A.t(new A.aN(this.a)))},
aK(a){a.bt(new A.aN(this.a))
a.C(0)},
B(a){return this.a}}
A.c3.prototype={
hE(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.l()
r&2&&A.a(s)
s[q]=p}},
O(){return new A.c3(new Uint16Array(A.t(this.a)))},
gav(){return B.h},
gp(a){return this.a.length},
P(a,b){var s,r
if(b==null)return!1
if(b instanceof A.c3){s=this.a
r=b.a
s=s.length===r.length&&A.l(s)===A.l(r)}else s=!1
return s},
gH(a){return A.l(this.a)},
a8(a,b){return this.a[b]},
h(a){return this.a8(0,0)},
bg(a){var s=this.a
s.$flags&2&&A.a(s)
s[0]=a},
bd(){return J.C(B.A.gA(this.a))},
aK(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.aw(r[s])},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.b2.prototype={
hB(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.j()
r&2&&A.a(s)
s[q]=p}},
O(){return new A.b2(new Uint32Array(A.t(this.a)))},
gav(){return B.n},
gp(a){return this.a.length},
P(a,b){var s,r
if(b==null)return!1
if(b instanceof A.b2){s=this.a
r=b.a
s=s.length===r.length&&A.l(s)===A.l(r)}else s=!1
return s},
gH(a){return A.l(this.a)},
a8(a,b){return this.a[b]},
h(a){return this.a8(0,0)},
bg(a){var s=this.a
s.$flags&2&&A.a(s)
s[0]=a},
bd(){return J.C(B.l.gA(this.a))},
aK(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.aH(r[s])},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.c_.prototype={
O(){return new A.c_(A.nB(this.a,t.i))},
gav(){return B.q},
gp(a){return this.a.length},
a8(a,b){return this.a[b].h(0)},
h(a){return this.a8(0,0)},
P(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.c_){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.l(s)===A.l(q)}else s=!1
return s},
gH(a){return A.l(this.a)},
aK(a){var s,r,q,p
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.a0)(s),++q){p=s[q]
a.aH(p.a)
a.aH(p.b)}},
B(a){var s=this.a
return s.length===1?s[0].B(0):A.x(s)}}
A.bA.prototype={
O(){return new A.bA(new Int8Array(A.t(this.a)))},
gav(){return B.aQ},
gp(a){return this.a.length},
P(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bA){s=this.a
r=b.a
s=s.length===r.length&&A.l(s)===A.l(r)}else s=!1
return s},
gH(a){return A.l(this.a)},
a8(a,b){return this.a[b]},
h(a){return this.a8(0,0)},
bg(a){var s=this.a
s.$flags&2&&A.a(s)
s[0]=a},
bd(){return J.C(B.W.gA(this.a))},
aK(a){a.bt(J.a2(B.W.gA(this.a),0,null))},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.c2.prototype={
hD(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.l()
o=$.aj()
o.$flags&2&&A.a(o)
o[0]=p
p=$.as()[0]
r&2&&A.a(s)
s[q]=p}},
O(){return new A.c2(new Int16Array(A.t(this.a)))},
gav(){return B.aR},
gp(a){return this.a.length},
P(a,b){var s,r
if(b==null)return!1
if(b instanceof A.c2){s=this.a
r=b.a
s=s.length===r.length&&A.l(s)===A.l(r)}else s=!1
return s},
gH(a){return A.l(this.a)},
a8(a,b){return this.a[b]},
h(a){return this.a8(0,0)},
bg(a){var s=this.a
s.$flags&2&&A.a(s)
s[0]=a},
bd(){return J.C(B.N.gA(this.a))},
aK(a){var s,r=new Int16Array(1),q=J.mX(B.N.gA(r),0,null),p=this.a,o=p.length
for(s=0;s<o;++s){r[0]=p[s]
a.aw(q[0])}},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.c0.prototype={
hC(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.j()
o=$.O()
o.$flags&2&&A.a(o)
o[0]=p
p=$.a1()[0]
r&2&&A.a(s)
s[q]=p}},
O(){return new A.c0(new Int32Array(A.t(this.a)))},
gav(){return B.aS},
gp(a){return this.a.length},
P(a,b){var s,r
if(b==null)return!1
if(b instanceof A.c0){s=this.a
r=b.a
s=s.length===r.length&&A.l(s)===A.l(r)}else s=!1
return s},
gH(a){return A.l(this.a)},
a8(a,b){return this.a[b]},
h(a){return this.a8(0,0)},
bg(a){var s=this.a
s.$flags&2&&A.a(s)
s[0]=a},
bd(){return J.C(B.G.gA(this.a))},
aK(a){var s,r,q,p=this.a,o=p.length
for(s=0;s<o;++s){r=p[s]
q=$.ic()
q.$flags&2&&A.a(q)
q[0]=r
a.aH($.lC()[0])}},
B(a){var s=this.a
return s.length===1?""+s[0]:A.x(s)}}
A.c1.prototype={
O(){return new A.c1(A.nB(this.a,t.i))},
gav(){return B.aM},
gp(a){return this.a.length},
P(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.c1){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.l(s)===A.l(q)}else s=!1
return s},
gH(a){return A.l(this.a)},
a8(a,b){return this.a[b].h(0)},
h(a){return this.a8(0,0)},
aK(a){var s,r,q,p,o,n
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.a0)(s),++q){p=s[q]
o=$.ic()
o.$flags&2&&A.a(o)
o[0]=p.a
n=$.lC()
a.aH(n[0])
o[0]=p.b
a.aH(n[0])}},
B(a){var s=this.a
return s.length===1?s[0].B(0):A.x(s)}}
A.cS.prototype={
hF(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.j()
o=$.O()
o.$flags&2&&A.a(o)
o[0]=p
p=$.bO()[0]
r&2&&A.a(s)
s[q]=p}},
O(){return new A.cS(new Float32Array(A.t(this.a)))},
gav(){return B.aN},
gp(a){return this.a.length},
P(a,b){var s,r
if(b==null)return!1
if(b instanceof A.cS){s=this.a
r=b.a
s=s.length===r.length&&A.l(s)===A.l(r)}else s=!1
return s},
gH(a){return A.l(this.a)},
bd(){return J.C(B.M.gA(this.a))},
aK(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.lz(r[s])},
B(a){var s=this.a
return s.length===1?A.x(s[0]):A.x(s)}}
A.cQ.prototype={
hA(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.de()
r&2&&A.a(s)
s[q]=p}},
O(){return new A.cQ(new Float64Array(A.t(this.a)))},
gav(){return B.aO},
gp(a){return this.a.length},
P(a,b){var s,r
if(b==null)return!1
if(b instanceof A.cQ){s=this.a
r=b.a
s=s.length===r.length&&A.l(s)===A.l(r)}else s=!1
return s},
gH(a){return A.l(this.a)},
bd(){return J.C(B.V.gA(this.a))},
aK(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.lA(r[s])},
B(a){var s=this.a
return s.length===1?A.x(s[0]):A.x(s)}}
A.cT.prototype={
O(){return new A.cT(new Uint8Array(A.t(this.a)))},
gav(){return B.D},
gp(a){return this.a.length},
bd(){return this.a},
P(a,b){var s,r
if(b==null)return!1
if(b instanceof A.cT){s=this.a
r=b.a
s=s.length===r.length&&A.l(s)===A.l(r)}else s=!1
return s},
gH(a){return A.l(this.a)},
aK(a){a.bt(this.a)},
B(a){return"<data>"}}
A.cR.prototype={
O(){return A.lP(this.a)},
gav(){return B.aP},
gp(a){return 1},
P(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.cR)s=this.a===b.a
return s},
gH(a){return this.a},
a8(a,b){if(b!==0)throw A.e(A.qo("Ifd tags must have exactly one entry (the offset)"))
return this.a},
h(a){return this.a8(0,0)},
bg(a){this.a=a},
bd(){var s=this.a
return new Uint8Array(A.t(A.m([B.a.i(s,24),B.a.i(s,16),B.a.i(s,8),s],t.t)))},
aK(a){a.aH(this.a)},
B(a){return"Ifd@"+this.a}}
A.bl.prototype={
bU(a,b,c){var s,r=this.c+b*c
this.c=r
s=this.a
if(s>0&&r>s)throw A.e(A.j("Animation frames exceed the maximum of "+s+" pixels"))}}
A.a9.prototype={
a6(){return"BmpCompression."+this.b}}
A.ik.prototype={}
A.bd.prototype={
ev(a,b){var s,r,q,p,o,n,m,l=this,k=l.d,j=k<=40
if(j){s=l.r
s=s===B.ad||s===B.ae}else s=!0
if(s){s=l.as=a.j()
r=A.ll(s)
l.CW=r
q=B.a.Y(s,r)
s=q>0
l.cx=s?255/q:0
r=l.at=a.j()
p=A.ll(r)
l.cy=p
o=B.a.Y(r,p)
l.db=s?255/o:0
r=l.ax=a.j()
p=A.ll(r)
l.dx=p
n=B.a.Y(r,p)
l.dy=s?255/n:0
if(!j||l.r===B.ae){j=l.ay=a.j()
s=A.ll(j)
l.fr=s
m=B.a.Y(j,s)
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
if(l.f<=8)l.li(a)},
gcs(){var s=this.d
if(s!==40)if(s===124){s=this.ay
s===$&&A.b()
s=s===0}else s=!1
else s=!0
return s},
gS(){return Math.abs(this.c)},
li(a){var s,r,q,p,o,n=this,m=n.z
if(m===0)m=B.a.N(1,n.f)
n.ch=new A.ba(new Uint8Array(m*3),m,3)
for(s=0;s<m;++s){r=J.c(a.a,a.d++)
q=J.c(a.a,a.d++)
p=J.c(a.a,a.d++)
o=J.c(a.a,a.d++)
n.ch.cH(s,p,q,r,o)}},
kU(a,b){var s,r,q,p,o,n,m,l,k,j=this
if(j.ch!=null){s=j.f
if(s===1){r=a.F()
for(q=7;q>=0;--q)b.$4(B.a.bu(r,q)&1,0,0,0)
return}else if(s===2){r=a.F()
for(q=6;q>=0;q-=2)b.$4(B.a.bu(r,q)&2,0,0,0)}else if(s===4){r=a.F()
b.$4(B.a.i(r,4)&15,0,0,0)
b.$4(r&15,0,0,0)
return}else if(s===8){b.$4(a.F(),0,0,0)
return}}s=j.r
if(s===B.ad&&j.f===32){p=a.j()
s=j.as
s===$&&A.b()
o=j.CW
o===$&&A.b()
o=B.a.Y((p&s)>>>0,o)
s=j.cx
s===$&&A.b()
n=B.b.h(o*s)
s=j.at
s===$&&A.b()
o=j.cy
o===$&&A.b()
o=B.a.Y((p&s)>>>0,o)
s=j.db
s===$&&A.b()
m=B.b.h(o*s)
s=j.ax
s===$&&A.b()
o=j.dx
o===$&&A.b()
o=B.a.Y((p&s)>>>0,o)
s=j.dy
s===$&&A.b()
l=B.b.h(o*s)
if(j.gcs())k=255
else{s=j.ay
s===$&&A.b()
o=j.fr
o===$&&A.b()
o=B.a.Y((p&s)>>>0,o)
s=j.fx
s===$&&A.b()
k=B.b.h(o*s)}return b.$4(n,m,l,k)}else{o=j.f
if(o===32&&s===B.az){l=a.F()
m=a.F()
n=a.F()
k=a.F()
return b.$4(n,m,l,j.gcs()?255:k)}else if(o===24){l=a.F()
m=a.F()
return b.$4(a.F(),m,l,255)}else if(o===16){p=a.l()
s=j.as
s===$&&A.b()
o=j.CW
o===$&&A.b()
o=B.a.Y((p&s)>>>0,o)
s=j.cx
s===$&&A.b()
n=B.b.h(o*s)
s=j.at
s===$&&A.b()
o=j.cy
o===$&&A.b()
o=B.a.Y((p&s)>>>0,o)
s=j.db
s===$&&A.b()
m=B.b.h(o*s)
s=j.ax
s===$&&A.b()
o=j.dx
o===$&&A.b()
o=B.a.Y((p&s)>>>0,o)
s=j.dy
s===$&&A.b()
l=B.b.h(o*s)
if(j.gcs())k=255
else{s=j.ay
s===$&&A.b()
o=j.fr
o===$&&A.b()
o=B.a.Y((p&s)>>>0,o)
s=j.fx
s===$&&A.b()
k=B.b.h(o*s)}return b.$4(n,m,l,k)}else throw A.e(A.j("Unsupported bitsPerPixel ("+o+") or compression ("+s.B(0)+")."))}}}
A.ff.prototype={
aD(a){var s,r
if(!A.n2(A.q(a,!1,null,0))||a.length<18)return!1
s=A.q(a,!1,null,0)
s.d+=14
r=s.j()
return r>=12&&r<=124},
az(a){return A.K(new A.ij(this,a))},
hZ(a){var s
if(!this.aD(a))return null
s=A.q(a,!1,null,0)
this.a=s
return this.b=A.pj(s,null)},
ae(a){return A.K(new A.ih(this,a))},
hY(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.b
if(a0==null)return new A.aw(a,a,a,a,0,B.i,0,0)
s=b.a
s===$&&A.b()
r=a0.a.b
r===$&&A.b()
s.d=r
r=a0.b
A.ai(r,a0.gS(),b.d,!1)
q=a0.f
p=B.a.W(r*q+31,32)*4
s=a0.gS()
o=b.a
if(p*s>o.c-o.d)throw A.e(A.j("Truncated BMP data"))
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
k=A.Q(a,a,m,0,B.i,a0.gS(),a,0,n,l,B.e,r,!1)
for(j=k.gS()-1,s=a0.c,r=1/s<0,o=s<0,s=s===0;j>=0;--j){i={}
if(!(s?r:o))h=j
else{g=k.a
g=g==null?a:g.b
h=(g==null?0:g)-1-j}g=b.a
f=g.ar(p)
g.d=g.d+(f.c-f.d)
g=k.a
e=g==null
d=e?a:g.a
if(d==null)d=0
i.a=0
c=e?a:g.L(0,h,a)
if(c==null)c=new A.F()
while(i.a<d)a0.kU(f,new A.ig(i,b,d,a0,c))}return k},
aY(a,b){return A.K(new A.ii(this,a,b))},
hX(a,b){var s=this.az(a)
if(s==null||s.b<1||s.gS()<1)return null
return this.ae(0)}}
A.ij.prototype={
$0(){return this.a.hZ(this.b)},
$S:20}
A.ih.prototype={
$0(){return this.a.hY(this.b)},
$S:21}
A.ig.prototype={
$4(a,b,c,d){var s,r,q=this,p=q.a
if(p.a<q.c){s=q.b.c&&q.d.ch!=null
r=q.e
if(s){s=q.d
r.ag(s.ch.aT(a),s.ch.aS(a),s.ch.aR(a),s.ch.aQ(a))}else r.ag(a,b,c,d)
r.E();++p.a}},
$S:22}
A.ii.prototype={
$0(){return this.a.hX(this.b,this.c)},
$S:1}
A.ir.prototype={}
A.dL.prototype={}
A.iq.prototype={}
A.is.prototype={}
A.ft.prototype={}
A.fN.prototype={
cv(){return this.w},
be(a,b,c,d,e){throw A.e(A.j("B44 compression not yet supported."))},
cb(a,b,c){return this.be(a,b,c,null,null)},
B(a){return A.x(this.r)+" "+this.x}}
A.bV.prototype={
a6(){return"ExrChannelType."+this.b}}
A.bU.prototype={
a6(){return"ExrChannelName."+this.b}}
A.fu.prototype={
hu(a){var s=this,r=a.cz()
s.a=r
if(r.length===0)return
s.c=B.eL[a.j()]
a.F()
a.d+=3
s.f=a.j()
s.r=a.j()
r=s.a
if(r==="R"){s.w=!0
s.b=B.cb}else if(r==="G"){s.w=!0
s.b=B.cc}else if(r==="B"){s.w=!0
s.b=B.cd}else if(r==="A"){s.w=!0
s.b=B.ce}else{s.w=!1
s.b=B.cf}switch(s.c.a){case 0:s.d=4
break
case 1:s.d=2
break
case 2:s.d=4
break}}}
A.b0.prototype={
a6(){return"ExrCompressorType."+this.b}}
A.iv.prototype={
be(a,b,c,d,e){throw A.e(A.j("Unsupported compression type"))},
cb(a,b,c){return this.be(a,b,c,null,null)}}
A.j4.prototype={}
A.fv.prototype={}
A.iA.prototype={
hv(a,b){var s,r,q,p,o,n=this,m=A.q(a,!1,null,0)
if(m.j()!==20000630)throw A.e(A.j("File is not an OpenEXR image file."))
s=n.d=m.F()
if(s!==2)throw A.e(A.j("Cannot read version "+s+" image files."))
s=n.e=m.bc()
if((s&4294967289)>>>0!==0)throw A.e(A.j("The file format version number's flag field contains unrecognized flags."))
r=new A.bl(b)
if((s&16)===0){q=n.c
p=A.nt(q.length,(s&2)!==0,m,b)
if(p.w>0)q.push(p)}else for(s=n.c;;){p=A.nt(s.length,(n.e&2)!==0,m,b)
q=p.w
if(q<=0)break
r.bU(0,q,p.x)
s.push(p)}s=n.c
q=s.length
if(q===0)throw A.e(A.j("Error reading image header"))
for(o=0;o<s.length;s.length===q||(0,A.a0)(s),++o)s[o].lh(m)
n.k0(m)},
k0(a){var s,r,q,p,o=this
for(s=o.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.a0)(s),++q){p=s[q]
o.a=Math.max(o.a,p.w)
o.b=Math.max(o.b,p.x)
if(p.db)o.kd(p,a)
else o.kc(p,a)}},
kd(b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=null,b5=this.e
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
if(s)if(p.j()!==n)throw A.e(A.j("Invalid Image Data"))
f=p.j()
e=p.j()
p.j()
p.j()
d=p.ar(p.j())
p.d=p.d+(d.c-d.d)
c=b6.dy
c.toString
b=e*c
a=b6.dx
a.toString
c=r.be(d,f*a,b,a,c)
a=c.length
a=Math.min(a,a)
a0=new A.a8(c,0,a,0,!1)
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
switch(c.a){case 1:c=a0.l()
b0=$.G
b1=(b0!=null?b0:A.L())[c]
break
case 2:b1=a0.l()
break
case 0:b1=a0.j()
break
default:b1=b4}c=a7.d
c===$&&A.b()
a4+=c
c=a7.w
c===$&&A.b()
if(c){c=b5.a
b2=c==null?b4:c.L(a8,b,b4)
if(b2==null)b2=new A.F()
c=a7.b
c===$&&A.b()
b2.m(0,c.a,b1)}else{c=a7.a
c===$&&A.b()
b0=b5.b
b3=b0!=null?b0.k(0,c):b4
if(b3!=null)b3.aC(a8,b,b1,0,0)}}}++a5;++b}}++j;++l}++m}},
kc(a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6=null,a7=this.e
a7===$&&A.b()
s=(a7&16)!==0
a7=a8.b
a7.toString
r=a8.CW
q=a8.ay[0]
p=a8.cx
o=A.r(a9,a6,0)
for(n=q.length,m=a8.c,l=r!=null,k=0,j=0;j<n;++j){o.d=q[j]
if(s)if(o.j()!==3.141592653589793)throw A.e(A.j("Invalid Image Data"))
i=o.j()
h=$.O()
h.$flags&2&&A.a(h)
h[0]=i
i=$.a1()
h[0]=o.j()
g=o.ar(i[0])
o.d=o.d+(g.c-g.d)
if(l){i=r.cb(g,0,k)
h=i.length
f=new A.a8(i,0,Math.min(h,h),0,!1)}else f=g
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
switch(i.a){case 1:i=f.l()
h=$.G
a3=(h!=null?h:A.L())[i]
break
case 2:a3=f.l()
break
case 0:a3=f.j()
break
default:a3=a6}i=a0.d
i===$&&A.b()
b+=i
i=a0.w
i===$&&A.b()
if(i){i=a7.a
a4=i==null?a6:i.L(a2,k,a6)
if(a4==null)a4=new A.F()
i=a0.b
i===$&&A.b()
a4.m(0,i.a,a3)}else{i=a0.a
i===$&&A.b()
h=a7.b
a5=h!=null?h.k(0,i):a6
if(a5!=null)a5.aC(a2,k,a3,0,0)}}}++c;++k}}}}
A.dO.prototype={
hw(b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=this,b0=null,b1=A.D(t.N,t.fe)
for(s=a9.e,r=t.t,q=a9.c,p=B.z;;){o=b4.cz()
if(o.length===0)break
b4.cz()
n=b4.ar(b4.j())
b4.d=b4.d+(n.c-n.d)
s.m(0,o,new A.ft())
switch(o){case"channels":for(;;){m=new A.fu()
m.hu(n)
l=m.a
l===$&&A.b()
if(l.length===0)break
k=m.w
k===$&&A.b()
if(k){++a9.d
l=m.c
l===$&&A.b()
if(l===B.aG)p=B.z
else p=l===B.aH?B.C:B.L}else{k=m.c
k===$&&A.b()
b1.m(0,l,k)}q.push(m)}break
case"chromaticities":l=new Float32Array(8)
a9.at=l
k=n.j()
j=$.O()
j.$flags&2&&A.a(j)
j[0]=k
k=$.bO()
l[0]=k[0]
l=a9.at
j[0]=n.j()
i=k[0]
l.$flags&2&&A.a(l)
l[1]=i
i=a9.at
j[0]=n.j()
l=k[0]
i.$flags&2&&A.a(i)
i[2]=l
l=a9.at
j[0]=n.j()
i=k[0]
l.$flags&2&&A.a(l)
l[3]=i
i=a9.at
j[0]=n.j()
l=k[0]
i.$flags&2&&A.a(i)
i[4]=l
l=a9.at
j[0]=n.j()
i=k[0]
l.$flags&2&&A.a(l)
l[5]=i
i=a9.at
j[0]=n.j()
l=k[0]
i.$flags&2&&A.a(i)
i[6]=l
l=a9.at
j[0]=n.j()
k=k[0]
l.$flags&2&&A.a(l)
l[7]=k
break
case"compression":a9.ax=B.fN[J.c(n.a,n.d++)]
break
case"dataWindow":l=n.j()
k=$.O()
k.$flags&2&&A.a(k)
k[0]=l
l=$.a1()
j=l[0]
k[0]=n.j()
i=l[0]
k[0]=n.j()
h=l[0]
k[0]=n.j()
l=a9.r=A.m([j,i,h,l[0]],r)
a9.w=l[2]-l[0]+1
a9.x=l[3]-l[1]+1
break
case"displayWindow":l=n.j()
k=$.O()
k.$flags&2&&A.a(k)
k[0]=l
$.a1()
k[0]=n.j()
k[0]=n.j()
k[0]=n.j()
break
case"lineOrder":break
case"pixelAspectRatio":l=n.j()
k=$.O()
k.$flags&2&&A.a(k)
k[0]=l
$.bO()
break
case"screenWindowCenter":l=n.j()
k=$.O()
k.$flags&2&&A.a(k)
k[0]=l
$.bO()
k[0]=n.j()
break
case"screenWindowWidth":l=n.j()
k=$.O()
k.$flags&2&&A.a(k)
k[0]=l
$.bO()
break
case"tiles":a9.dx=n.j()
a9.dy=n.j()
g=J.c(n.a,n.d++)
a9.fr=g&15
a9.fx=B.a.i(g,4)&15
break
case"type":f=n.cz()
if(f!=="deepscanline")if(f!=="deeptile")throw A.e(A.j("EXR Invalid type: "+f))
break
default:break}}s=a9.w
if(s===0&&a9.x===0)return
A.ai(s,a9.x,b5,!1)
s=a9.w
a9.b=A.Q(b0,b0,p,0,B.i,a9.x,b0,0,a9.d,b0,B.e,s,!1)
for(s=new A.bi(b1,b1.$ti.n("bi<1,2>")).gG(0);s.E();){e=s.d
switch(e.b.a){case 1:r=a9.w
l=a9.x
r=new A.cU(new Uint16Array(r*l),r,l,1)
break
case 2:r=a9.w
l=a9.x
r=new A.cV(new Float32Array(r*l),r,l,1)
break
case 0:r=a9.w
l=a9.x
r=new A.cY(new Uint32Array(r*l),r,l,1)
break
default:r=b0}l=a9.b
l.toString
l.hn(e.a,r)}if(a9.db){d={}
c=a9.dx
if(c==null)c=0
b=a9.dy
if(b==null)b=0
if(c<1||b<1)throw A.e(A.j("Invalid EXR tile size"))
A.ai(c,b,b5,!1)
s=a9.r
s===$&&A.b()
a9.id=a9.i3(s[0],s[2],s[1],s[3])
s=a9.r
a9.k1=a9.i4(s[0],s[2],s[1],s[3])
if(a9.fr!==2)a9.k1=1
s=a9.id
s.toString
r=a9.r
a9.fy=a9.eE(s,r[0],r[2],a9.dx,a9.fx)
r=a9.k1
r.toString
s=a9.r
a9.go=a9.eE(r,s[1],s[3],a9.dy,a9.fx)
s=a9.i2()
a9.k2=s
r=a9.dx
r.toString
r=s*r
a9.k3=r
a9.CW=A.nb(a9.ax,a9,r,a9.dy)
s=a9.k1
s.toString
r=a9.id
q=a9.fy
l=a9.go
a=0
a0=0
for(;a0<s;++a0){r.toString
a1=0
for(;a1<r;++a1)a+=q[a1]*l[a0]}if(a*8>b4.c-b4.d)throw A.e(A.j("Truncated EXR data"))
d.a=d.b=0
s=a9.id
s.toString
r=a9.k1
r.toString
a9.ay=A.nC(s*r,new A.iB(d,a9),t.w)}else{s=a9.x
r=a9.ch=new Uint32Array(s+1)
for(l=q.length,k=a9.r,j=a9.w,a2=0;a2<l;++a2){a3=q[a2]
i=a3.d
i===$&&A.b()
h=a3.f
h===$&&A.b()
a4=B.a.ab(i*j,h)
for(i=a3.r,a5=0;a5<s;++a5){k===$&&A.b()
h=k[1]
i===$&&A.b()
if(B.a.a2(a5+h,i)===0)r[a5]=r[a5]+a4}}for(a6=0,a5=0;a5<s;++a5)a6=Math.max(a6,r[a5])
s=A.nb(a9.ax,a9,a6,b0)
a9.CW=s
s=a9.cx=s.cv()
r=a9.ch
q=r.length
l=new Uint32Array(q)
a9.cy=l
for(--q,a7=0,a8=0;a8<=q;++a8){if(B.a.a2(a8,s)===0)a7=0
l[a8]=a7
a7+=r[a8]}s=B.a.ab(a9.x+s,s)
a9.ay=A.m([new Uint32Array(s-1)],t.hh)}},
i3(a,b,c,d){var s,r,q,p=this
switch(p.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
s=(p.fx===0?p.cU(r):p.cL(r))+1
break
case 2:q=b-a+1
s=(p.fx===0?p.cU(q):p.cL(q))+1
break
default:throw A.e(A.j("Unknown LevelMode format."))}return s},
i4(a,b,c,d){var s,r,q,p=this
switch(p.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
s=(p.fx===0?p.cU(r):p.cL(r))+1
break
case 2:q=d-c+1
s=(p.fx===0?p.cU(q):p.cL(q))+1
break
default:throw A.e(A.j("Unknown LevelMode format."))}return s},
cU(a){var s
for(s=0;a>1;){++s
a=B.a.i(a,1)}return s},
cL(a){var s,r
for(s=0,r=0;a>1;){if((a&1)!==0)r=1;++s
a=B.a.i(a,1)}return s+r},
i2(){var s,r,q,p,o
for(s=this.c,r=s.length,q=0,p=0;p<r;++p){o=s[p].d
o===$&&A.b()
q+=o}return q},
eE(a,b,c,d,e){var s,r,q,p,o,n,m=J.al(a,t.p)
for(s=e===1,r=c-b+1,q=0;q<a;++q){p=B.a.N(1,q)
o=B.a.ab(r,p)
if(s&&o*p<r)++o
n=Math.max(o,1)
d.toString
m[q]=B.a.ab(n+d-1,d)}return m}}
A.iB.prototype={
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
A.fO.prototype={
lh(a){var s,r,q,p,o,n=this
if(n.db)for(s=0;s<n.ay.length;++s)for(r=0;q=n.ay[s],r<q.length;++r){p=a.ef()
q.$flags&2&&A.a(q)
q[r]=p}else{o=n.ay[0].length
for(s=0;s<o;++s){q=n.ay[0]
p=a.ef()
q.$flags&2&&A.a(q)
q[s]=p}}}}
A.j5.prototype={
hJ(a,b,c){var s,r,q,p=this,o=a.c.length,n=J.al(o,t.eO)
for(s=0;s<o;++s)n[s]=new A.i_()
p.y=n
r=p.w
r.toString
q=B.a.W(r*p.x,2)
p.z=new Uint16Array(q)},
cv(){return this.x},
be(a6,a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this
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
i=B.a.ab(a7,q)
h=B.a.ab(s,q)
q=i*q<a7?0:1
q=h-i+q
j.c=q
p=k.r
p===$&&A.b()
i=B.a.ab(a8,p)
h=B.a.ab(r,p)
g=i*p<a8?0:1
g=h-i+g
j.d=g
j.e=p
p=k.d
p===$&&A.b()
p=p/2|0
j.f=p
m+=q*g*p}f=a6.l()
e=a6.l()
if(e>=8192)throw A.e(A.j("Error in header for PIZ-compressed data (invalid bitmap size)."))
d=new Uint8Array(8192)
if(f<=e){c=a6.a7(e-f+1)
b=c.c-c.d
for(a=f,l=0;l<b;++l,a=a0){a0=a+1
d[a]=J.c(c.a,c.d+l)}}a1=new Uint16Array(65536)
a2=a5.ki(d,a1)
A.px(a6,a6.j(),a5.z,m)
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
A.pA(p,g+a,a3,q,a4,a3*q,a2);++a}}q=a5.z
q.toString
a5.hU(a1,q,m)
q=a5.r
if(q==null){q=a5.w
q.toString
q=a5.r=A.ep(!1,q*a5.x+73728)}q.a=0
for(;a8<=r;++a8)for(l=0;l<n;++l){q=a5.y
q===$&&A.b()
j=q[l]
q=j.e
q===$&&A.b()
if(B.a.a2(a8,q)!==0)continue
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
q.aw(p[g])}}q=a5.r
return J.a2(B.c.gA(q.c),0,q.a)},
cb(a,b,c){return this.be(a,b,c,null,null)},
hU(a,b,c){var s,r,q
for(s=b.$flags|0,r=0;r<c;++r){q=a[b[r]]
s&2&&A.a(b)
b[r]=q}},
ki(a,b){var s,r,q,p,o
for(s=b.$flags|0,r=0,q=0;q<65536;++q)if(q===0||(a[q>>>3]&1<<(q&7))>>>0!==0){p=r+1
s&2&&A.a(b)
b[r]=q
r=p}for(p=r;p<65536;p=o){o=p+1
s&2&&A.a(b)
b[p]=0}return r-1}}
A.i_.prototype={}
A.j6.prototype={
cv(){return this.w},
be(a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a2.U(),a1=a.r
a1.toString
a1=a.w*a1
s=A.i9(a0,a1)
a0=a.x;(a0==null?a.x=A.ep(!1,a1):a0).a=0
r=A.m([0,0,0,0],t.t)
q=new Uint32Array(1)
p=J.a2(B.l.gA(q),0,null)
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
if(B.a.a2(a4,a1)!==0)continue
a1=i.f
a1===$&&A.b()
h=B.a.ab(a3,a1)
g=B.a.ab(o,a1)
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
for(b=0;b<4;++b)a.x.C(p[b])}break
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
for(b=0;b<2;++b)a.x.C(p[b])}break
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
for(b=0;b<4;++b)a.x.C(p[b])}break}}a0=a.x
return J.a2(B.c.gA(a0.c),0,a0.a)},
cb(a,b,c){return this.be(a,b,c,null,null)}}
A.j7.prototype={
cv(){return 1},
be(a,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=a.c,b=A.ep(!1,(c-a.d)*2)
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
p=$.ak()
p.$flags&2&&A.a(p)
p[0]=q
o=$.at()[0]
if(o<0){n=-o
for(;m=n-1,n>0;n=m)b.C(J.c(a.a,a.d++))}else for(n=o;m=n-1,n>=0;n=m)b.C(J.c(a.a,a.d++))}l=J.a2(B.c.gA(b.c),0,b.a)
k=l.length
for(c=l.$flags|0,j=1;j<k;++j){q=l[j-1]
p=l[j]
c&2&&A.a(l)
l[j]=q+p-128}c=d.r
if(c==null||c.length!==k)c=d.r=new Uint8Array(k)
q=B.a.W(k+1,2)
for(i=0,h=0;;q=e,i=f){if(h<k){g=h+1
f=i+1
p=l[i]
c.$flags&2&&A.a(c)
c[h]=p}else break
if(g<k){h=g+1
e=q+1
c[g]=l[q]}else break}return c},
cb(a,b,c){return this.be(a,b,c,null,null)},
B(a){return A.x(this.w)}}
A.fP.prototype={
cv(){return this.x},
be(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=a.U(),f=h.w
if(f==null)f=0
s=A.i9(g,f*h.x)
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
f=B.a.W(p+1,2)
for(m=0,l=0;;f=i,m=j){if(l<p){k=l+1
j=m+1
n=s[m]
g.$flags&2&&A.a(g)
g[l]=n}else break
if(k<p){l=k+1
i=f+1
g[k]=s[f]}else break}return g},
cb(a,b,c){return this.be(a,b,c,null,null)},
B(a){return A.x(this.w)}}
A.iw.prototype={
az(a){return A.K(new A.iz(this,a))},
ae(a){return A.K(new A.ix(this,a))},
iU(a){var s=this.a
if(s==null)return null
return s.c[a].b},
aY(a,b){return A.K(new A.iy(this,a,b))},
iT(a,b){if(this.az(a)==null)return null
return this.ae(0)}}
A.iz.prototype={
$0(){var s=this.a,r=new A.iA(A.m([],t.dw))
r.hv(this.b,s.b)
return s.a=r},
$S:5}
A.ix.prototype={
$0(){return this.a.iU(this.b)},
$S:1}
A.iy.prototype={
$0(){return this.a.iT(this.b,this.c)},
$S:1}
A.dT.prototype={
l0(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
if(d===0&&e.c!=null){s=e.c
s.toString
return s}for(s=e.b,r=e.d,q=-1,p=-1,o=0;o<s;++o){n=r.aT(o)
m=r.aS(o)
l=r.aR(o)
k=r.aQ(o)
if(n===a&&m===b&&l===c&&k===d)return o
j=a-n
i=b-m
h=c-l
g=d-k
f=j*j+i*i+h*h+g*g
if(p===-1){p=o
q=f}else if(f<q){p=o
q=f}}return p},
ej(){var s,r,q,p,o,n,m,l=this
if(l.c==null)return l.d
s=l.d
r=s.a
q=new A.ba(new Uint8Array(r*4),r,4)
for(p=0;p<r;++p){o=s.aT(p)
n=s.aS(p)
m=s.aR(p)
q.cH(p,o,n,m,p===l.c?0:255)}return q}}
A.dU.prototype={
hx(a){var s,r,q,p,o,n,m=this
m.a=a.l()
m.b=a.l()
m.c=a.l()
m.d=a.l()
s=a.F()
m.e=(s&64)!==0
if((s&128)!==0){m.f=A.ne(B.a.N(1,(s&7)+1))
for(r=0;q=m.f,r<q.b;++r){p=J.c(a.a,a.d++)
o=J.c(a.a,a.d++)
n=J.c(a.a,a.d++)
q.d.b6(r,p,o,n)}}m.y=a.d-a.b}}
A.fQ.prototype={}
A.cN.prototype={}
A.iF.prototype={
aD(a){var s,r
this.r=A.q(a,!1,null,0)
this.a=new A.cN(A.m([],t.b))
try{s=this.f7()
return s}catch(r){return!1}},
az(a){return A.K(new A.iI(this,a))},
j4(a){var s,r,q,p,o,n,m,l,k,j,i=this
i.r=A.q(a,!1,null,0)
i.a=new A.cN(A.m([],t.b))
if(!i.f7())return null
p=i.a
A.ai(p.a,p.b,i.b,!0)
try{while(p=i.r,o=p.d,o<p.c){n=p.a
p.d=o+1
s=J.c(n,o)
switch(s){case 44:r=i.fo()
if(r==null){p=i.a
return p}p=r
p.r=i.f
p.w=i.d
if(i.c!==0){if(r.f==null&&i.a.e!=null){p=i.a.e
o=p.a
n=p.b
m=p.c
p=p.d
r.f=new A.dT(o,n,m,new A.ba(new Uint8Array(A.t(p.c)),p.a,p.b))}if(r.f!=null)r.f.c=i.e}i.a.r.push(r)
break
case 33:p=i.r
q=J.c(p.a,p.d++)
if(J.aK(q,255)){p=i.r
if(p.aj(J.c(p.a,p.d++))==="NETSCAPE2.0"){l=J.c(p.a,p.d++)
k=J.c(p.a,p.d++)
if(l===3&&k===1)i.w=p.l()}else i.d0()}else if(J.aK(q,249)){p=i.r
p.toString
i.jV(p)}else i.d0()
break
case 59:p=i.a
return p
default:break}}}catch(j){}return i.a},
jV(a){var s,r,q,p=this
a.F()
s=a.F()
p.f=a.l()
p.e=a.F()
a.F()
p.d=B.a.i(s,2)&7
p.c=s&1
r=a.cI(1,0)
if(J.c(r.a,r.d)===44){++a.d
q=p.fo()
if(q==null)return
q.r=p.f
q.w=p.d
r=p.c!==0
q.x=r?p.e:-1
if(r){r=q.f
if(r==null&&p.a.e!=null){r=p.a.e
r.toString
r=q.f=A.pF(r)}if(r!=null)r.c=p.e}p.a.r.push(q)}},
ae(a){return A.K(new A.iG(this,a))},
j3(a){var s,r,q,p=this,o=p.r
if(o==null||p.a==null)return null
s=p.a.r
r=s.length
if(a>=r)return null
q=s[a]
s=q.y
s===$&&A.b()
o.d=s
return p.iB(q)},
aY(a,b){return A.K(new A.iH(this,a,b))},
j2(a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5=null
if(a4.az(a6)==null)return a5
s=a4.a
r=s.r.length
if(r===1)return a4.ae(0)
new A.bl(a4.b).bU(0,s.a*r,s.b)
for(s=t.p,q=a5,p=q,o=0;r=a4.a.r,o<r.length;++o){a7=r[o]
n=a4.ae(o)
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
if(r){p.b1(n)
q=n
continue}g=a7.f
if(!(g!=null)){r=a4.a.e
r.toString
g=r}r=j?a5:k.a
if(r==null)r=0
m=j?a5:k.b
if(m==null)m=0
f=A.Q(a5,a5,B.e,0,B.i,m,a5,0,1,g.ej(),B.e,r,!1)
r=a7.w
if(r===2){r=f.a
e=r==null?a5:J.C(r.gA(r))
if(e==null){r=f.a
r=r==null?a5:r.gA(r)
if(r==null)r=B.c.gA(new Uint8Array(0))
e=J.C(r)}r=a7.x
m=e.length
if(r!==-1)B.c.ao(e,0,m,r)
else{r=a4.a.c.a
B.c.ao(e,0,m,!B.c.ga4(r)?r[0]:0)}}else if(r!==3)if(a7.f!=null){r=q.a
d=r==null?a5:r.gR()
c=A.D(s,s)
for(r=d.a,b=0;b<r;++b)c.m(0,b,g.l0(d.aT(b),d.aS(b),d.aR(b),d.aQ(b)))
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
a0=J.C(r)}for(a1=a.length,r=a.$flags|0,a2=0;a2<a1;++a2){a3=c.k(0,a0[a2])
if(a3!=null&&a3!==-1){r&2&&A.a(a)
a[a2]=a3}}}f.y=n.y
r=a7.a
r===$&&A.b()
m=a7.b
m===$&&A.b()
a4.ib(n,f,r,m)
p.b1(f)
q=f}return p},
fo(){var s,r=this.r
if(r.d>=r.c)return null
s=new A.fQ()
s.hx(r);++this.r.d
this.d0()
return s},
iB(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=null
if(f.x==null){f.x=new Uint8Array(256)
f.y=new Uint8Array(4095)
f.z=new Uint8Array(4096)
f.Q=new Uint32Array(4096)}s=f.as=f.r.F()
r=B.a.X(1,s)
f.fr=r;++r
f.dy=r
f.dx=r+1;++s
f.db=s
f.cy=B.a.X(1,s)
f.ch=0
f.cx=4098
f.ax=f.ay=0
s=f.x
s.toString
s.$flags&2&&A.a(s)
s[0]=0
s=f.Q
s.toString
B.l.ao(s,0,4096,4098)
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
n=A.Q(e,e,B.e,0,B.i,r,e,0,1,o.ej(),B.e,s,!1)
m=new Uint8Array(s)
q=a.e
q===$&&A.b()
if(q){q=a.b
q===$&&A.b()
for(r=q+r,l=0,k=0;l<4;++l)for(j=q+B.cD[l];j<r;j+=B.dZ[l],++k){if(!f.f3(m))return n
p=n.a
i=p==null
h=i?e:p.a
g=j*(h==null?0:h)
p=i?e:J.C(p.gA(p))
if(p==null){p=n.a
p=p==null?e:p.gA(p)
if(p==null)p=B.c.gA(new Uint8Array(0))
p=J.C(p)}B.c.aI(p,g,g+s,m)}}else for(j=0;j<r;++j){if(!f.f3(m))return n
q=n.a
p=q==null
i=p?e:q.a
g=j*(i==null?0:i)
q=p?e:J.C(q.gA(q))
if(q==null){q=n.a
q=q==null?e:q.gA(q)
if(q==null)q=B.c.gA(new Uint8Array(0))
q=J.C(q)}B.c.aI(q,g,g+s,m)}return n},
ib(a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=a0.a,c=d==null?null:d.gR(),b=c.a,a=J.bB(b,t.y)
for(s=0;s<b;++s)a[s]=c.aQ(s)!==0
r=a0.U()
q=a1.U()
p=a0.gZ()
o=a1.gZ()
n=a1.gS()
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
f7(){var s,r,q,p,o,n=this,m=n.r.aj(6)
if(m!=="GIF87a"&&m!=="GIF89a")return!1
s=n.a
s.toString
s.a=n.r.l()
s=n.a
s.toString
s.b=n.r.l()
r=n.r.F()
s=n.a
s.toString
s.c=new A.b_(new Uint8Array(A.t(A.m([n.r.F()],t.t))));++n.r.d
if((r&128)!==0){s=n.a
s.toString
s.e=A.ne(B.a.N(1,(r&7)+1))
for(q=0;q<n.a.e.b;++q){s=n.r
p=J.c(s.a,s.d++)
s=n.r
o=J.c(s.a,s.d++)
s=n.r
r=J.c(s.a,s.d++)
n.a.e.d.b6(q,p,o,r)}}n.a.toString
return!0},
f3(a){var s=this,r=s.at
r.toString
s.at=r-a.length
if(!s.iM(a))return!1
if(s.at===0)s.d0()
return!0},
d0(){var s,r,q,p=this.r
if(p.d>=p.c)return!0
s=p.F()
for(;;){if(s!==0){p=this.r
p=p.d<p.c}else p=!1
if(!p)break
p=this.r
r=p.d+=s
if(r>=p.c)return!0
q=p.a
p.d=r+1
s=J.c(q,r)}return!0},
iM(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.ch
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
r=p}}for(f=a.$flags|0;r<s;){n=g.CW=g.iL()
if(n==null)return!1
q=g.dy
if(n===q)return!1
o=g.fr
if(n===o){for(o=g.Q,m=0;m<=4095;++m){o.toString
o.$flags&2&&A.a(o)
o[m]=4098}g.dx=q+1
q=g.as+1
g.db=q
g.cy=B.a.X(1,q)
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
o=g.dI(q,n,o)
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
q=g.dI(o,q,i)
j.$flags&2&&A.a(j)
j[l]=q}else{j===$&&A.b()
k.toString
q=g.dI(o,k,i)
j.$flags&2&&A.a(j)
j[l]=q}}q=g.CW
q.toString
g.cx=q}}return!0},
iL(){var s,r,q,p,o=this
if(o.db>12)return null
while(s=o.ay,r=o.db,s<r){s=o.i_()
s.toString
r=o.ax
q=o.ay
o.ax=(r|B.a.X(s,q))>>>0
o.ay=q+8}q=o.ax
p=B.ed[r]
o.ax=B.a.Y(q,r)
o.ay=s-r
s=o.dx
if(s<4097){++s
o.dx=s
s=s>o.cy&&r<12}else s=!1
if(s){o.cy=o.cy<<1>>>0
o.db=r+1}return q&p},
dI(a,b,c){var s,r,q=0
for(;;){if(b>c){s=q+1
r=q<=4095
q=s}else r=!1
if(!r)break
if(b>4095)return 4098
b=a[b]}return b},
i_(){var s,r,q=this,p=q.x,o=p[0],n=p.$flags|0
if(o===0){o=q.r.F()
n&2&&A.a(p)
p[0]=o
p=q.x
o=p[0]
if(o===0)return null
B.c.aI(p,1,1+o,q.r.a7(o).U())
p=q.x
s=p[1]
p.$flags&2&&A.a(p)
p[1]=2
p[0]=p[0]-1}else{r=p[1]
n&2&&A.a(p)
p[1]=r+1
s=p[r]
p[0]=o-1}return s}}
A.iI.prototype={
$0(){return this.a.j4(this.b)},
$S:26}
A.iG.prototype={
$0(){return this.a.j3(this.b)},
$S:1}
A.iH.prototype={
$0(){return this.a.j2(this.b,this.c)},
$S:1}
A.cP.prototype={
a6(){return"IcoType."+this.b}}
A.iP.prototype={}
A.fB.prototype={}
A.iK.prototype={
gS(){return B.a.W(A.bd.prototype.gS.call(this),2)},
gcs(){return!(this.d===40&&this.f===32)&&A.bd.prototype.gcs.call(this)}}
A.iL.prototype={
aD(a){var s,r=this,q=A.q(a,!1,null,0)
r.a=q
try{r.b=A.ng(q)}catch(s){r.b=null}return r.b!=null},
az(a){return A.K(new A.iO(this,a))},
aY(a,b){return A.K(new A.iN(this,a,b))},
j7(a,b){var s,r,q,p,o,n,m=this,l=null
if(m.az(a)==null)return l
s=m.b.e.length
if(s===1)return m.ae(0)
r=new A.bl(m.c)
for(q=l,p=0;p<m.b.e.length;++p){b=m.ae(p)
if(b==null)continue
s=b.a
o=s==null
n=o?l:s.a
if(n==null)n=0
s=o?l:s.b
r.bU(0,n,s==null?0:s)
if(q==null){b.w=B.i
q=b}else q.b1(b)}return q},
ae(a){return A.K(new A.iM(this,a))},
j8(b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=this,b0=null,b1=a9.a
if(b1!=null){s=a9.b
s=s==null||b2>=s.d}else s=!0
if(s)return b0
r=a9.b.e[b2]
s=b1.a
b1=b1.b+r.e
q=r.d
p=J.lG(s,b1,b1+q)
b1=a9.c
o=A.nG(b1)
t.D.a(p)
if(o.aD(p))return o.aY(p,0)
n=A.ep(!1,14)
n.aw(19778)
n.aH(q)
n.aH(0)
n.aH(0)
s=A.q(p,!1,b0,0)
q=A.n1(A.q(J.a2(B.c.gA(n.c),0,n.a),!1,b0,0))
m=s.d
l=s.j()
k=s.j()
j=$.O()
j.$flags&2&&A.a(j)
j[0]=k
k=$.a1()
i=k[0]
j[0]=s.j()
k=k[0]
h=s.l()
g=s.l()
f=s.j()
if(f>=14)A.Y(A.j("Unsupported BMP compression type: "+f))
f=B.bl[f]
s.j()
j[0]=s.j()
j[0]=s.j()
j=s.j()
s.j()
e=new A.iK(q,i,k,l,h,g,f,j,m)
e.ev(s,q)
if(l!==40&&h!==1)return b0
d=j===0&&g<=8?40+4*B.a.N(1,g):40+4*j
q.b=d
n.a-=4
n.aH(d)
c=A.q(p,!1,b0,0)
b=new A.ir(!0,b1)
b.a=c
b.b=e
a=b.ae(0)
if(g>=32)return a
a0=32-B.a.a2(i,32)
a1=B.a.W(a0===32?i:i+a0,8)
for(b1=k<0,s=k===0,k=1/k<0,a2=0;a2<B.a.W(A.bd.prototype.gS.call(e),2);++a2){if(!(s?k:b1))a3=a2
else{q=a.a
q=q==null?b0:q.b
a3=(q==null?0:q)-1-a2}a4=c.ar(a1)
c.d=c.d+(a4.c-a4.d)
q=a.a
a5=q==null?b0:q.L(0,a3,b0)
if(a5==null)a5=new A.F()
for(a6=0;a6<i;){a7=J.c(a4.a,a4.d++)
a8=7
for(;;){if(!(a8>-1&&a6<i))break
if((a7&B.a.X(1,a8))>>>0!==0)a5.st(0)
a5.E();++a6;--a8}}}return a}}
A.iO.prototype={
$0(){var s=this.a,r=A.q(this.b,!1,null,0)
s.a=r
return s.b=A.ng(r)},
$S:5}
A.iN.prototype={
$0(){return this.a.j7(this.b,this.c)},
$S:1}
A.iM.prototype={
$0(){return this.a.j8(this.b)},
$S:1}
A.fk.prototype={}
A.bX.prototype={}
A.bY.prototype={}
A.cO.prototype={}
A.ji.prototype={
hK(a){var s,r,q,p,o,n,m,l=this,k=null,j="ifd0",i=l.a,h=i.y
if(h.k(0,j).a.a5(274)){s=h.k(0,j).gbC()
s.toString
r=s}else r=0
q=r>=5&&r<=8
p=q?l.c:l.b
s=A.Q(k,k,B.e,0,B.i,q?l.b:l.c,k,0,3,k,B.e,p,!1)
s.e=A.dN(h)
s.gbj().k(0,j).sbC(k)
s.c=i.x
l.d!==$&&A.y()
l.d=s
i=s.a
i=J.C(i.gA(i))
l.e!==$&&A.y()
l.e=i
o=s.a.gau()
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
hg(c2,c3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9=this,c0=b9.a,c1=c0.ax
switch(c1.length){case 1:s=c1[0]
r=s.f
q=s.r
c0=b9.f
c0===$&&A.b()
p=b9.w
p===$&&A.b()
o=c0+c2*p
for(c0=b9.b,n=b9.r,m=b9.e,l=s.e,k=c2;k<c3;++k,o+=p){j=l[B.a.i(k,q)]
j.toString
i=o
h=0
while(h<c0){g=j[B.a.a3(h,r)]
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
a1=$.mU()
c0=b9.f
c0===$&&A.b()
p=b9.w
p===$&&A.b()
o=c0+c2*p
for(c0=b9.b,n=b9.r,m=b9.e,l=s.e,j=e.e,a2=d.e,k=c2;k<c3;++k,o+=p){a3=l[B.a.i(k,q)]
a3.toString
a4=j[B.a.i(k,b)]
a4.toString
a5=a2[B.a.i(k,a0)]
a5.toString
if(f){i=o
h=0
while(h<c0){g=(a3[B.a.a3(h,r)]<<8>>>0)+65536
a6=a4[B.a.a3(h,c)]-128
a7=a5[B.a.a3(h,a)]-128
m===$&&A.b()
a8=a1[B.a.i(g+359*a7,8)]
m.$flags&2&&A.a(m)
m[i]=a8
m[i+1]=a1[B.a.i(g-88*a6-183*a7,8)]
m[i+2]=a1[B.a.i(g+454*a6,8)];++h
n===$&&A.b()
i+=n}}else{i=o
h=0
while(h<c0){m===$&&A.b()
a8=a3[B.a.a3(h,r)]
m.$flags&2&&A.a(m)
m[i]=a8
m[i+1]=a4[B.a.a3(h,c)]
m[i+2]=a5[B.a.a3(h,a)];++h
n===$&&A.b()
i+=n}}}break
case 4:c0=c0.e
if(c0==null)throw A.e(A.j("Unsupported color mode (4 components)"))
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
a1=$.mU()
p=b9.f
p===$&&A.b()
n=b9.w
n===$&&A.b()
o=p+c2*n
for(p=b9.b,m=b9.r,l=b9.e,j=s.e,a2=e.e,a3=d.e,a4=a9.e,k=c2;k<c3;++k,o+=n){a5=j[B.a.i(k,q)]
a5.toString
a8=a2[B.a.i(k,b)]
a8.toString
b2=a3[B.a.i(k,a0)]
b2.toString
b3=a4[B.a.i(k,b1)]
b3.toString
i=o
h=0
while(h<p){b4=b3[B.a.a3(h,b0)]
if(c0){b5=a5[B.a.a3(h,r)]
b6=a8[B.a.a3(h,c)]
g=b2[B.a.a3(h,a)]}else{b7=(a5[B.a.a3(h,r)]<<8>>>0)+65536
a6=a8[B.a.a3(h,c)]-128
a7=b2[B.a.a3(h,a)]-128
b5=255-a1[B.a.i(b7+359*a7,8)]
b6=255-a1[B.a.i(b7-88*a6-183*a7,8)]
g=255-a1[B.a.i(b7+454*a6,8)]}l===$&&A.b()
b8=B.a.i(b5*b4,8)
l.$flags&2&&A.a(l)
l[i]=b8
l[i+1]=B.a.i(b6*b4,8)
l[i+2]=B.a.i(g*b4,8);++h
m===$&&A.b()
i+=m}}break
default:throw A.e(A.j("Unsupported color mode"))}}}
A.jd.prototype={}
A.c5.prototype={}
A.h0.prototype={
ly(a){var s,r,q,p,o,n=this,m=A.q(a,!0,null,0)
n.c=m
s=m.cI(2,0)
if(J.c(s.a,s.d)!==255||J.c(s.a,s.d+1)!==216)return!1
if(n.bR()!==216)return!1
r=n.bR()
q=!1
p=!1
for(;;){if(r!==217){m=n.c
m=m.d<m.c}else m=!1
if(!m)break
o=n.c.l()
if(o<2)break
m=n.c
m.d=m.d+(o-2)
switch(r){case 192:case 193:case 194:q=!0
break
case 218:if(q)return!0
p=!0
break}r=n.bR()}return q&&p},
bD(a){var s,r,q,p,o,n,m=this
m.c=A.q(a,!0,null,0)
m.jN()
if(m.Q.length!==1)throw A.e(A.j("Only single frame JPEGs supported"))
s=m.f
s.toString
if(m.cy!=null)return
if(!m.ay){m.ay=!0
s.lf(m.b===8)}for(r=s.z,q=s.y,p=m.ax,o=0;o<r.length;++o){n=q.k(0,r[o])
p.push(A.n9(n.a,s.f,n.b,s.r,m.i0(s,n)))}},
gdk(){var s,r=this.f.d
r.toString
s=this.b
return B.a.ab(r+s-1,s)},
jN(){var s,r,q,p,o,n=this
n.ch=0
if(n.bR()!==216)throw A.e(A.j("Start Of Image marker not found."))
s=n.bR()
for(;;){if(s!==217){r=n.c
r===$&&A.b()
r=r.d<r.c}else r=!1
if(!r)break
A:{if(s>=208&&s<=215||s===1){s=n.bR()
break A}r=n.c
r===$&&A.b()
q=r.l()
if(q<2)A.Y(A.j("Invalid Block"))
r=n.c
p=r.ar(q-2)
r.d=r.d+(p.c-p.d)
switch(s){case 224:case 225:case 226:case 227:case 228:case 229:case 230:case 231:case 232:case 233:case 234:case 235:case 236:case 237:case 238:case 239:case 254:n.jO(s,p)
break
case 219:n.jQ(p)
break
case 192:case 193:case 194:n.jT(s,p)
break
case 195:case 197:case 198:case 199:case 200:case 201:case 202:case 203:case 205:case 206:case 207:throw A.e(A.j("Unhandled frame type "+B.a.di(s,16)))
case 196:n.jP(p)
break
case 221:n.r=p.l()
break
case 218:n.kb(p)
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
break}if(s!==0)throw A.e(A.j("Unknown JPEG marker "+B.a.di(s,16)))
break}s=n.bR()}}},
bR(){var s,r=this,q=r.c
q===$&&A.b()
if(q.d>=q.c)return 0
do{do{s=r.c.F()
if(s!==255){q=r.c
q=q.d<q.c}else q=!1}while(q)
q=r.c
if(q.d>=q.c)return s
do{s=r.c.F()
if(s===255){q=r.c
q=q.d<q.c}else q=!1}while(q)
if(s===0){q=r.c
q=q.d<q.c}else q=!1}while(q)
return s},
k_(a){var s
for(s=0;s<12;++s)if(J.c(a.a,a.d++)!==B.j3[s])return
this.x=new A.bf("ICC_PROFILE",B.R,a.U())},
jR(a){if(a.j()!==1165519206)return
if(a.l()!==0)return
this.y.bD(a)},
jO(a,b){var s,r,q,p,o,n=this,m=b
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
if(s){s=new A.jj()
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
m.cI(14+3*r*q,14)}}else if(a===225)n.jR(m)
else if(a===226)n.k_(m)
else if(a===238){s=m
r=!1
if(J.c(s.a,s.d)===65){s=m
if(J.c(s.a,s.d+1)===100){s=m
if(J.c(s.a,s.d+2)===111){s=m
if(J.c(s.a,s.d+3)===98){s=m
if(J.c(s.a,s.d+4)===101){s=m
s=J.c(s.a,s.d+5)===0}else s=r}else s=r}else s=r}else s=r}else s=r
if(s){p=new A.jd()
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
n.e=p}}else if(a===254)try{m.ll()}catch(o){}},
jQ(a){var s,r,q,p,o,n,m,l,k
for(s=a.c,r=this.z;q=a.d,p=q<s,p;){p=a.a
a.d=q+1
o=J.c(p,q)
n=B.a.i(o,4)
o&=15
if(o>=4)throw A.e(A.j("Invalid number of quantization tables"))
q=r[o]
if(q==null){q=new Int16Array(64)
r[o]=q}for(p=n!==0,m=0;m<64;++m){l=p?a.l():J.c(a.a,a.d++)
k=$.ib()[m]
q.$flags&2&&A.a(q)
q[k]=l}}if(p)throw A.e(A.j("Bad length for DQT block"))},
jT(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
if(i.f!=null)throw A.e(A.j("Duplicate JPG frame data found."))
s=A.D(t.p,t.d2)
r=A.m([],t.t)
q=new A.h1(s,r)
q.b=a===194
q.c=b.F()
q.d=b.l()
q.e=b.l()
p=b.F()
for(o=i.z,n=0;n<p;++n){m=J.c(b.a,b.d++)
l=J.c(b.a,b.d++)
k=B.a.i(l,4)
j=J.c(b.a,b.d++)
r.push(m)
s.m(0,m,new A.c5(k&15,l&15,o,j))}i.kw(q)
i.f=q
i.Q.push(q)},
kw(a){var s,r,q,p=a.e
p.toString
s=a.d
s.toString
if(p===0||s===0)throw A.e(A.j("Invalid JPEG dimensions "+p+"x"+s))
r=this.a
if(r>0&&p*s>r)throw A.e(A.j("JPEG dimensions "+p+"x"+s+" exceed the maximum of "+r+" pixels"))
p=a.y
s=p.a
if(s===0||s>4)throw A.e(A.j("Unsupported number of JPEG components: "+s))
for(p=new A.ag(p,p.r,p.e,A.i(p).n("ag<2>"));p.E();){s=p.d
r=s.a
q=!0
if(r>=1)if(r<=4){s=s.b
s=s<1||s>4}else s=q
else s=q
if(s)throw A.e(A.j("Invalid JPEG sampling factor"))}},
jP(a){var s,r,q,p,o,n,m,l,k,j,i,h
for(s=a.c,r=this.at,q=this.as;p=a.d,p<s;){o=a.a
a.d=p+1
n=J.c(o,p)
m=new Uint8Array(16)
for(l=0,k=0;k<16;++k){m[k]=J.c(a.a,a.d++)
l+=m[k]}j=a.ar(l)
a.d=a.d+(j.c-j.d)
i=j.U()
if((n&16)!==0){n-=16
h=q}else h=r
if(h.length<=n)B.k.sp(h,n+1)
h[n]=this.jf(m,i)}},
kb(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this
if(++a.ch>1000)throw A.e(A.j("Too many JPEG scans"))
s=a0.F()
if(s<1||s>4)throw A.e(A.j("Invalid SOS block"))
r=a.f
r.toString
q=A.m([],t.b7)
for(p=a.as,o=a.at,n=r.y,m=0;m<s;++m){l=J.c(a0.a,a0.d++)
k=J.c(a0.a,a0.d++)
if(!n.a5(l))throw A.e(A.j("Invalid Component in SOS block"))
j=n.k(0,l)
j.toString
i=B.a.i(k,4)&15
h=k&15
if(i<o.length){g=o[i]
g.toString
j.Q=g
j.at=A.oE(g)}if(h<p.length){g=p[h]
g.toString
j.as=g
j.ax=A.oE(g)}q.push(j)}f=a0.F()
e=a0.F()
d=a0.F()
p=B.a.i(d,4)
o=r.b
o.toString
if(o&&a.b===8&&f>0)return
if(a.cy!=null)throw A.e(B.c9)
c=!1
if(!a.ay){a.ay=!0
o=n.k(0,r.z[0])
o.toString
if(a.CW){j=r.b
j.toString
if(!j){j=q.length
if(j===n.a)if(j<=1)o=o.a===1&&o.b===1
else o=!0
else o=c
c=o}}r.h3(c,a.b===8)
if(c)a.km(r)}o=a.c
o===$&&A.b()
n=a.r
b=new A.h2(o,r,q,n,f,e,p&15,d&15,new Int16Array(64))
p=r.w
p===$&&A.b()
b.f=p
b.r=r.b
if(c)b.ay=a.giq()
b.bz()},
jf(a,b){var s,r,q,p,o,n,m,l=A.m([],t.e8),k=16
for(;;){if(!(k>0&&a[k-1]===0))break;--k}s=t.en
l.push(new A.dr(A.a3(2,null,!1,s)))
r=l[0]
for(q=0,p=0;p<k;){for(o=0;o<a[p];++o){r=l.pop()
r.a[r.b]=new A.cO(b[q])
while(n=r.b,n>0)r=l.pop()
r.b=n+1
l.push(r)
for(;l.length<=p;r=m){n=A.a3(2,null,!1,s)
m=new A.dr(n)
l.push(m)
r.a[r.b]=new A.bY(n)}++q}++p
if(p<k){n=A.a3(2,null,!1,s)
m=new A.dr(n)
l.push(m)
r.a[r.b]=new A.bY(n)
r=m}}return l[0].a},
i0(a,b){var s,r,q,p,o,n,m,l,k=b.e
k===$&&A.b()
s=b.f
s===$&&A.b()
r=B.a.ab(8,this.b)
q=k*r
p=new Int32Array(64)
o=new Uint8Array(64)
n=A.a3(s*r,null,!1,t.aD)
for(m=0;m<s;++m){for(k=m*r,l=0;l<r;++l)n[k+l]=new Uint8Array(q)
this.eC(b,m,n,k,o,p)}b.x=new Int16Array(0)
return n},
eC(a,b,c,d,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=B.a.ab(8,this.b),e=a.x
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
j=128+B.b.ba((B.b.ba((5793*B.b.ba((5793*(k*r[0])+512)/1024)+8192)/16384)+8)/16)
if(j<0)i=0
else i=j>255?255:j
n.$flags&2&&A.a(n)
n[o]=i
break A}A.u9(r,e,l,a0,a1)
h=o*f
if(q)for(n=h+8,g=0;g<8;++g){i=c[d+g]
if(i!=null)B.c.a1(i,h,n,a0,g<<3>>>0)}else A.pS(a0,f,c,d,h)}++o}},
kT(a){var s,r,q,p=this
p.CW=!0
try{p.bD(a)}catch(s){if(A.ar(s) instanceof A.i0)return p.eR(a)
else throw s}r=p.cy
if(r==null)return A.oC(p)
if(p.cx)return p.eR(a)
q=r.d
q===$&&A.b()
q.c=p.x
return q},
eR(a){var s=A.lU()
s.a=this.a
s.b=this.b
s.bD(a)
return A.oC(s)},
km(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=B.a.ab(8,c.b),a=c.db
B.k.d5(a)
for(s=a0.z,r=s.length,q=t.h,p=a0.y,o=c.ax,n=t.aD,m=0;m<s.length;s.length===r||(0,A.a0)(s),++m){l=p.k(0,s[m])
k=l.a
j=a0.f
i=l.b
h=a0.r
g=l.f
g===$&&A.b()
o.push(A.n9(k,j,i,h,A.a3(g*b,null,!1,n)))
f=i*b
e=A.m(new Array(f),q)
for(k=l.e,d=0;d<f;++d){k===$&&A.b()
e[d]=new Uint8Array(k*b)}a.push(e)}c.cy=A.ny(c)},
ir(a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5=a4.f
a5.toString
s=B.a.ab(8,a4.b)
for(r=a5.z,q=a4.dx,p=a4.dy,o=a5.y,n=a4.ax,m=a4.db,l=0;l<r.length;++l){k=o.k(0,r[l])
j=n[l].e
i=m[l]
for(h=k.b,g=a6*h,f=0;f<h;++f){e=g+f
d=k.f
d===$&&A.b()
if(e>=d)break
for(d=e*s,c=f*s,b=0;b<s;++b)j[d+b]=i[c+b]
a4.eC(k,f,j,d,q,p)}h=k.x
h===$&&A.b()
g=a4.fr
d=h.length
if(g.length<d)g=a4.fr=new Int16Array(d)
B.N.aI(h,0,d,g)}a=a5.r*s
a0=a6*a
a1=Math.min(a0+a,a4.gdk())
if(a0<a1)a4.cy.hg(a0,a1)
for(l=0;l<r.length;++l){k=o.k(0,r[l])
j=n[l].e
a5=k.b
a2=a6*a5*s
a5=a2+a5*s
q=j.length
a3=a2
for(;;){if(!(a3<a5&&a3<q))break
j[a3]=null;++a3}}}}
A.dr.prototype={}
A.i0.prototype={}
A.h1.prototype={
h3(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
for(s=i.y,r=A.i(s).n("V<1>"),q=new A.V(s,s.r,s.e,r);q.E();){p=s.k(0,q.d)
i.f=Math.max(i.f,p.a)
i.r=Math.max(i.r,p.b)}q=i.e
q.toString
i.w=B.b.b2(q/8/i.f)
q=i.d
q.toString
i.x=B.b.b2(q/8/i.r)
for(r=new A.V(s,s.r,s.e,r);r.E();){q=s.k(0,r.d)
q.toString
o=i.e
o.toString
n=q.a
m=B.b.b2(B.b.b2(o/8)*n/i.f)
o=i.d
o.toString
l=q.b
k=B.b.b2(B.b.b2(o/8)*l/i.r)
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
lf(a){return this.h3(!1,a)}}
A.jj.prototype={}
A.h2.prototype={
bz(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=b.y,a0=a.length,a1=b.r
a1.toString
if(a1)if(b.Q===0)s=b.at===0?b.giv():b.gix()
else s=b.at===0?b.gij():b.gil()
else s=b.gis()
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
k=B.a.ab(o,q)
j=B.a.a2(o,q)
q=m.z
q=q>0?B.a.a2(k,q):k
i=m.r
i===$&&A.b()
b.eT(m,s,q*i+j);++o
if(b.ay!=null&&B.a.a2(o,m.e)===0)b.dW(B.a.ab(o,m.e));++l}}else{l=0
for(;;){q=b.z
q.toString
if(!(l<q))break
for(n=0;n<a0;++n){m=a[n]
h=m.a
g=m.b
for(f=0;f<g;++f)for(e=0;e<h;++e)b.iC(m,s,o,f,e)}++o
if(b.ay!=null){q=b.f
q===$&&A.b()
q=B.a.a2(o,q)===0}else q=!1
if(q){q=b.f
q===$&&A.b()
b.dW(B.a.ab(o,q))}++l}}b.cx=b.CW=0
q=b.cy=!1
if(o>=p)break
d=J.c(r.a,r.d)
c=J.c(r.a,r.d+1)
if(d===255)if(c>=208?c<=215:q)r.d+=2
else break}if(b.ay!=null){if(a1){a=a[0].f
a===$&&A.b()}else{a=b.b.x
a===$&&A.b()}b.dW(a)}},
dW(a){var s,r
while(s=this.ch,s<a){r=this.ay
r.toString
this.ch=s+1
r.$1(s)}},
dE(){var s,r,q=this,p=q.a,o=p.c
for(;;){if(!(q.cx<=24&&!q.cy))break
s=p.d
if(s>=o){q.cy=!0
break}r=J.c(p.a,s)
if(r===255){s=p.d
if(o-s<2||J.c(p.a,s+1)!==0){q.cy=!0
break}p.d+=2}else ++p.d
q.CW=(q.CW<<8|r)>>>0
q.cx+=8}},
c3(){var s=this,r=s.cx
if(r===0){s.dE()
r=s.cx
if(r===0)return null}--r
s.cx=r
return B.a.Y(s.CW,r)&1},
cl(a,b){var s,r,q,p,o,n=this
if(n.cx<9)n.dE()
s=n.cx
if(s>=9){r=b[B.a.Y(n.CW,s-9)&511]
if(r!==0){n.cx=s-(r>>>8)
return r&255}}for(q=a;;){p=n.c3()
if(p==null)return null
o=q[p]
if(o instanceof A.cO)return o.a
if(!(o instanceof A.bY))return null
q=o.a}},
dT(a){var s=this,r=s.cx
if(r<a){s.dE()
r=s.cx
if(r<a){s.cx=0
return null}}r-=a
s.cx=r
return(B.a.Y(s.CW,r)&B.a.N(1,a)-1)>>>0},
cn(a){var s
if(a==null)return 0
if(a===1)return this.c3()===1?1:-1
s=this.dT(a)
if(s==null)return 0
if(s>=B.a.X(1,a-1))return s
return s+B.a.N(-1,a)+1},
it(a,b,c){var s,r,q,p,o,n,m,l=this,k=a.Q
k===$&&A.b()
s=a.at
s===$&&A.b()
r=l.cl(k,s)
q=r===0?0:l.cn(r)
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
o=l.cl(k,s)
if(o==null)break
n=o&15
m=o>>>4
if(n===0){if(m<15)break
p+=16
continue}p+=m
n=l.cn(n)
b[c+$.ib()[p]]=n;++p}},
iw(a,b,c){var s,r,q,p=a.Q
p===$&&A.b()
s=a.at
s===$&&A.b()
r=this.cl(p,s)
q=r===0?0:B.a.N(this.cn(r),this.ax)
p=a.ay
p===$&&A.b()
p+=q
a.ay=p
b.$flags&2&&A.a(b)
b[c]=p},
iy(a,b,c){var s=b[c],r=this.c3()
r.toString
r=B.a.N(r,this.ax)
b.$flags&2&&A.a(b)
b[c]=(s|r)>>>0},
ik(a,b,c){var s,r,q,p,o,n,m,l,k=this,j=k.db
if(j>0){k.db=j-1
return}s=k.Q
r=k.as
for(j=k.ax,q=b.$flags|0;s<=r;){p=a.as
p===$&&A.b()
o=a.ax
o===$&&A.b()
o=k.cl(p,o)
o.toString
n=o&15
m=o>>>4
if(n===0){if(m<15){j=k.dT(m)
j.toString
k.db=j+B.a.N(1,m)-1
break}s+=16
continue}s+=m
l=$.ib()[s]
p=k.cn(n)
o=B.a.N(1,j)
q&2&&A.a(b)
b[c+l]=p*o;++s}},
im(a,b,c){var s,r,q,p,o,n,m,l,k=this,j=k.Q,i=k.as
A:for(s=k.ax,r=b.$flags|0,q=0;j<=i;){p=c+$.ib()[j]
o=k.dx
switch(o){case 0:o=a.as
o===$&&A.b()
n=a.ax
n===$&&A.b()
m=k.cl(o,n)
if(m==null)throw A.e(A.j("Invalid progressive encoding"))
l=m&15
q=m>>>4
if(l===0)if(q<15){o=k.dT(q)
o.toString
k.db=o+B.a.N(1,q)
k.dx=4}else{k.dx=1
q=16}else{if(l!==1)throw A.e(A.j("invalid ACn encoding"))
k.dy=k.cn(l)
k.dx=q!==0?2:3}continue A
case 1:case 2:n=b[p]
if(n!==0){o=k.c3()
o.toString
o=B.a.N(o,s)
r&2&&A.a(b)
b[p]=n+o}else{--q
if(q===0)k.dx=o===2?3:0}break
case 3:o=b[p]
if(o!==0){n=k.c3()
n.toString
n=B.a.N(n,s)
r&2&&A.a(b)
b[p]=o+n}else{o=k.dy
o===$&&A.b()
o=B.a.N(o,s)
r&2&&A.a(b)
b[p]=o
k.dx=0}break
case 4:o=b[p]
if(o!==0){n=k.c3()
n.toString
n=B.a.N(n,s)
r&2&&A.a(b)
b[p]=o+n}break}++j}if(k.dx===4)if(--k.db===0)k.dx=0},
iC(a,b,c,d,e){var s,r,q,p=this.f
p===$&&A.b()
s=B.a.ab(c,p)*a.b+d
r=B.a.a2(c,p)*a.a+e
p=a.w
p===$&&A.b()
if(s<p){p=a.r
p===$&&A.b()
p=r>=p}else p=!0
if(p)return
p=a.z
p=p>0?B.a.a2(s,p):s
q=a.r
q===$&&A.b()
this.eT(a,b,p*q+r)},
eT(a,b,c){var s,r,q=a.x
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
A.jf.prototype={
aD(a){var s,r
if(a.length<2||a[0]!==255||a[1]!==216)return!1
try{s=A.lU().ly(a)
return s}catch(r){return!1}},
aY(a,b){return A.K(new A.jg(this,a,b))},
c7(a){return this.aY(a,null)}}
A.jg.prototype={
$0(){var s=A.lU()
s.a=this.a.a
s.b=1
return s.kT(this.b)},
$S:1}
A.je.prototype={
a6(){return"JpegChroma."+this.b}}
A.jh.prototype={
ho(a){a=B.a.h(B.a.I(a,1,100))
if(this.Q===a)return
this.ja(a<50?B.b.ba(5000/a):B.a.ba(200-a*2))
this.Q=a},
kX(b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=this
if(b6.gZ()<1||b6.gS()<1||b6.a==null)A.Y(A.j("Cannot encode an empty image"))
s=A.ep(!0,8192)
b5.bx(s,216)
b5.bx(s,224)
s.aw(16)
s.C(74)
s.C(70)
s.C(73)
s.C(70)
s.C(0)
s.C(1)
s.C(1)
s.C(0)
s.aw(1)
s.aw(1)
s.C(0)
s.C(0)
b5.kB(s,b6.gbj())
r=b6.c
if(r!=null){b5.bx(s,226)
q=r.kW()
p=A.m([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
s.aw(14+q.length)
s.bt(p)
s.bt(q)}b5.kA(s)
r=b6.gZ()
o=b6.gS()
b5.bx(s,192)
s.aw(17)
s.C(8)
s.aw(o)
s.aw(r)
s.C(3)
s.C(1)
r=b7===B.aU
s.C(r?17:34)
s.C(0)
s.C(2)
s.C(17)
s.C(1)
s.C(3)
s.C(17)
s.C(1)
b5.kz(s)
b5.bx(s,218)
s.aw(12)
s.C(3)
s.C(1)
s.C(0)
s.C(2)
s.C(17)
s.C(3)
s.C(17)
s.C(0)
s.C(63)
s.C(0)
b5.at=b5.as=0
n=b6.gZ()
m=b6.gS()
l=b6.f
if(l==null)l=B.ca
if(r){k=new Float32Array(64)
j=new Float32Array(64)
i=new Float32Array(64)
for(r=b5.c,o=b5.d,h=0,g=0,f=0,e=0;e<m;e+=8)for(d=0;d<n;d+=8){b5.cf(b6,d,e,n,m,k,j,i,l)
c=b5.e
c===$&&A.b()
b=b5.r
b===$&&A.b()
h=b5.bv(s,k,r,h,c,b)
b=b5.f
b===$&&A.b()
c=b5.w
c===$&&A.b()
g=b5.bv(s,j,o,g,b,c)
f=b5.bv(s,i,o,f,b5.f,b5.w)}}else{r=t.B
k=J.bB(4,r)
for(a=0;a<4;++a)k[a]=new Float32Array(64)
j=J.bB(4,r)
for(a=0;a<4;++a)j[a]=new Float32Array(64)
i=J.bB(4,r)
for(a=0;a<4;++a)i[a]=new Float32Array(64)
a0=new Float32Array(64)
a1=new Float32Array(64)
for(r=b5.c,o=b5.d,h=0,g=0,f=0,e=0;e<m;e+=16)for(c=e+8,d=0;d<n;d+=16){b=k[0]
a2=j[0]
a3=i[0]
b5.cf(b6,d,e,n,m,b,a2,a3,l)
a4=d+8
a5=k[1]
a6=j[1]
a7=i[1]
b5.cf(b6,a4,e,n,m,a5,a6,a7,l)
a8=k[2]
a9=j[2]
b0=i[2]
b5.cf(b6,d,c,n,m,a8,a9,b0,l)
b1=k[3]
b2=j[3]
b3=i[3]
b5.cf(b6,a4,c,n,m,b1,b2,b3,l)
b5.eY(a0,a2,a6,a9,b2)
b5.eY(a1,a3,a7,b0,b3)
b3=b5.e
b3===$&&A.b()
b0=b5.r
b0===$&&A.b()
h=b5.bv(s,b1,r,b5.bv(s,a8,r,b5.bv(s,a5,r,b5.bv(s,b,r,h,b3,b0),b5.e,b5.r),b5.e,b5.r),b5.e,b5.r)
b0=b5.f
b0===$&&A.b()
b3=b5.w
b3===$&&A.b()
g=b5.bv(s,a0,o,g,b0,b3)
f=b5.bv(s,a1,o,f,b5.f,b5.w)}}b4=8-b5.at
b5.bw(s,B.a.X(1,b4)-1,b4)
b5.bx(s,217)
return J.a2(B.c.gA(s.c),0,s.a)},
cf(a,b,a0,a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c
if(a.gJ()===B.e&&!a.gbB()&&a.gbO()>=3){s=a.a
this.i5(J.C(s.gA(s)),a.a.gau(),a.gbO(),b,a0,a1,a2,a3,a4,a5,a6)
return}for(s=this.z,r=a3.$flags|0,q=a4.$flags|0,p=a5.$flags|0,o=a0+1,n=null,m=0;m<64;++m){l=m>>>3
k=a0+l
j=b+(m&7)
if(k>=a2)k-=o+l-a2
if(j>=a1)j-=j-a1+1
i=a.a
n=i==null?null:i.L(j,k,n)
if(n==null)n=new A.F()
h=n.gJ()!==B.e?n.b3(B.e):n
g=B.b.h(h.gq())
f=B.b.h(h.gu())
e=B.b.h(h.gv())
if(h.gp(h)>3){d=h.gV()
c=1-d
g=B.a.I(B.b.aE(g*d+a6.gq()*c),0,255)
f=B.a.I(B.b.aE(f*d+a6.gu()*c),0,255)
e=B.a.I(B.b.aE(e*d+a6.gv()*c),0,255)}i=B.a.i(s[g]+s[f+256]+s[e+512],16)
r&2&&A.a(a3)
a3[m]=i-128
i=B.a.i(s[g+768]+s[f+1024]+s[e+1280],16)
q&2&&A.a(a4)
a4[m]=i-128
i=B.a.i(s[g+1280]+s[f+1536]+s[e+1792],16)
p&2&&A.a(a5)
a5[m]=i-128}},
i5(a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this.z,a1=b4.gq(),a2=b4.gu(),a3=b4.gv()
for(s=b1.$flags|0,r=b2.$flags|0,q=b3.$flags|0,p=a6>3,o=a9-1,n=b0-1,m=0,l=0;m<8;++m){k=a8+m
j=(k<b0?k:n)*a5
for(i=0;i<8;++i,++l){h=a7+i
g=j+(h<a9?h:o)*a6
f=a4[g]
e=a4[g+1]
d=a4[g+2]
if(p){c=a4[g+3]/255
b=1-c
f=B.a.I(B.b.aE(f*c+a1*b),0,255)
e=B.a.I(B.b.aE(e*c+a2*b),0,255)
d=B.a.I(B.b.aE(d*c+a3*b),0,255)}a=B.a.i(a0[f]+a0[e+256]+a0[d+512],16)
s&2&&A.a(b1)
b1[l]=a-128
a=B.a.i(a0[f+768]+a0[e+1024]+a0[d+1280],16)
r&2&&A.a(b2)
b2[l]=a-128
a=B.a.i(a0[f+1280]+a0[e+1536]+a0[d+1792],16)
q&2&&A.a(b3)
b3[l]=a-128}}},
eY(a,b,c,d,e){var s,r,q,p,o,n,m,l
for(s=a.$flags|0,r=0;r<64;++r){if(r<32)q=B.a.a2(r,8)<4?b:c
else q=B.a.a2(r,8)<4?d:e
p=(B.a.W(B.a.a2(r,32),8)<<4>>>0)+(B.a.a2(r,4)<<1>>>0)
o=q[p]
n=q[p+1]
m=q[p+8]
l=q[p+9]
s&2&&A.a(a)
a[r]=(o+n+m+l)/4}},
bx(a,b){a.C(255)
a.C(b&255)},
ja(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
for(s=b.a,r=s.$flags|0,q=0;q<64;++q){p=B.b.ba((B.hA[q]*a+50)/100)
if(p<1)p=1
else if(p>255)p=255
o=B.a5[q]
r&2&&A.a(s)
s[o]=p}for(r=b.b,o=r.$flags|0,n=0;n<64;++n){m=B.b.ba((B.dK[n]*a+50)/100)
if(m<1)m=1
else if(m>255)m=255
l=B.a5[n]
o&2&&A.a(r)
r[l]=m}for(o=b.c,l=o.$flags|0,k=b.d,j=k.$flags|0,i=0,h=0;h<8;++h)for(g=0;g<8;++g){f=B.a5[i]
e=s[f]
d=B.b0[h]
c=B.b0[g]
l&2&&A.a(o)
o[i]=1/(e*d*c*8)
f=r[f]
j&2&&A.a(k)
k[i]=1/(f*d*c*8);++i}},
cO(a,b){var s,r,q,p,o,n=new Int32Array(256),m=new Uint8Array(256)
for(s=0,r=0,q=1;q<=16;++q){for(p=1;p<=a[q];++p){o=b[r]
n[o]=s
m[o]=q;++r;++s}s*=2}return new A.kV(n,m)},
jb(){var s,r,q
for(s=this.z,r=s.$flags|0,q=0;q<256;++q){r&2&&A.a(s)
s[q]=19595*q
s[q+256]=38470*q
s[q+512]=7471*q+32768
s[q+768]=-11059*q
s[q+1024]=-21709*q
s[q+1280]=32768*q+8421375
s[q+1536]=-27439*q
s[q+1792]=-5329*q}},
iW(d6,d7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5
for(s=d6.$flags|0,r=0,q=0;q<8;++q){p=d6[r]
o=r+1
n=d6[o]
m=r+2
l=d6[m]
k=r+3
j=d6[k]
i=r+4
h=d6[i]
g=r+5
f=d6[g]
e=r+6
d=d6[e]
c=r+7
b=d6[c]
a=p+b
a0=p-b
a1=n+d
a2=n-d
a3=l+f
a4=l-f
a5=j+h
a6=a+a5
a7=a-a5
a8=a1+a3
s&2&&A.a(d6)
d6[r]=a6+a8
d6[i]=a6-a8
a9=(a1-a3+a7)*0.707106781
d6[m]=a7+a9
d6[e]=a7-a9
a6=j-h+a4
b0=a2+a0
b1=(a6-b0)*0.382683433
b2=0.5411961*a6+b1
b3=1.306562965*b0+b1
b4=(a4+a2)*0.707106781
b5=a0+b4
b6=a0-b4
d6[g]=b6+b2
d6[k]=b6-b2
d6[o]=b5+b3
d6[c]=b5-b3
r+=8}for(r=0,q=0;q<8;++q){p=d6[r]
o=r+8
n=d6[o]
m=r+16
l=d6[m]
k=r+24
j=d6[k]
i=r+32
h=d6[i]
g=r+40
f=d6[g]
e=r+48
d=d6[e]
c=r+56
b=d6[c]
b7=p+b
b8=p-b
b9=n+d
c0=n-d
c1=l+f
c2=l-f
c3=j+h
c4=b7+c3
c5=b7-c3
c6=b9+c1
s&2&&A.a(d6)
d6[r]=c4+c6
d6[i]=c4-c6
c7=(b9-c1+c5)*0.707106781
d6[m]=c5+c7
d6[e]=c5-c7
c4=j-h+c2
c8=c0+b8
c9=(c4-c8)*0.382683433
d0=0.5411961*c4+c9
d1=1.306562965*c8+c9
d2=(c2+c0)*0.707106781
d3=b8+d2
d4=b8-d2
d6[g]=d4+d0
d6[k]=d4-d0
d6[o]=d3+d1
d6[c]=d3-d1;++r}for(s=this.x,q=0;q<64;++q){d5=d6[q]*d7[q]
o=d5>0?B.b.h(d5+0.5):B.b.h(d5-0.5)
s.$flags&2&&A.a(s)
s[q]=o}return s},
kB(a,b){var s,r
if(b.ga4(0))return
s=A.ep(!1,8192)
b.aK(s)
r=J.a2(B.c.gA(s.c),0,s.a)
this.bx(a,225)
a.aw(r.length+8)
a.aH(1165519206)
a.aw(0)
a.bt(r)},
kA(a){var s,r,q
this.bx(a,219)
a.aw(132)
a.C(0)
for(s=this.a,r=0;r<64;++r)a.C(s[r])
a.C(1)
for(s=this.b,q=0;q<64;++q)a.C(s[q])},
kz(a){var s,r,q,p,o,n,m,l
this.bx(a,196)
a.aw(418)
a.C(0)
for(s=0;s<16;){++s
a.C(B.br[s])}for(r=0;r<=11;++r)a.C(B.a4[r])
a.C(16)
for(q=0;q<16;){++q
a.C(B.aX[q])}for(p=0;p<=161;++p)a.C(B.b1[p])
a.C(1)
for(o=0;o<16;){++o
a.C(B.b9[o])}for(n=0;n<=11;++n)a.C(B.a4[n])
a.C(17)
for(m=0;m<16;){++m
a.C(B.b5[m])}for(l=0;l<=161;++l)a.C(B.bc[l])},
bv(a,b,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=e.iW(b,a0),c=e.y
for(s=c.$flags|0,r=0;r<64;++r){q=B.a5[r]
p=d[r]
s&2&&A.a(c)
c[q]=p}s=c[0]
o=s-a1
if(o===0)e.bw(a,a2.a[0],a2.b[0])
else{n=B.a.gfN(o<0?-o:o)
e.bw(a,a2.a[n],a2.b[n])
e.bw(a,A.pT(o,n),n)}m=63
for(;;){if(!(m>0&&c[m]===0))break;--m}if(m===0){e.bw(a,a3.a[0],a3.b[0])
return s}for(q=a3.a,p=a3.b,l=1;l<=m;){k=l
for(;;){if(!(c[k]===0&&k<=m))break;++k}j=k-l
if(j>=16){i=B.a.i(j,4)
for(h=1;h<=i;++h)e.bw(a,q[240],p[240])
j&=15}g=c[k]
n=B.a.gfN(g<0?-g:g)
f=(j<<4>>>0)+n
e.bw(a,q[f],p[f])
e.bw(a,g>0?g:g+B.a.X(1,n)-1,n)
l=k+1}if(m!==63)e.bw(a,q[0],p[0])
return s},
bw(a,b,c){var s,r,q=this
q.as=(B.a.X(q.as,c)|b)>>>0
q.at+=c
while(s=q.at,s>=8){s-=8
q.at=s
r=B.a.Y(q.as,s)&255
a.C(r)
if(r===255)a.C(0)}q.as=(q.as&B.a.X(1,s)-1)>>>0}}
A.kV.prototype={
gp(a){return this.b}}
A.d9.prototype={
a6(){return"PngDisposeMode."+this.b}}
A.et.prototype={
a6(){return"PngBlendMode."+this.b}}
A.eu.prototype={}
A.fR.prototype={}
A.bE.prototype={
a6(){return"PngFilterType."+this.b}}
A.jC.prototype={}
A.j8.prototype={}
A.jy.prototype={
aD(a){var s
if(a.length<8)return!1
for(s=0;s<8;++s)if(a[s]!==B.bm[s])return!1
return!0},
az(a){return A.K(new A.jB(this,a))},
jB(b8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=this,b6=null,b7=A.q(b8,!0,b6,0)
b5.e=b7
s=b7.a7(8)
for(r=0;r<8;++r)if(J.c(s.a,s.d+r)!==B.bm[r])return b6
for(b7=b5.a,q=b7.cy,p=t.t,o=b7.db,n=t.L,m=b5.b,l=b7.ax;;){k=b5.e
j=k.d-k.b
i=k.j()
h=b5.e.aj(4)
switch(h){case"tEXt":k=b5.e
g=k.ar(i)
k.d=k.d+(g.c-g.d)
f=g.U()
e=f.length
for(r=0;r<e;++r)if(f[r]===0){k=r+1
l.m(0,B.aD.c7(new Uint8Array(f.subarray(0,A.i6(0,r,e)))),B.aD.c7(new Uint8Array(f.subarray(k,A.i6(k,b6,e)))))
break}b5.e.d+=4
break
case"pHYs":k=b5.e
g=k.ar(i)
k.d=k.d+(g.c-g.d)
d=A.r(g,b6,0)
d.j()
d.j()
J.c(d.a,d.d++)
b5.e.d+=4
break
case"IHDR":k=b5.e
g=k.ar(i)
k.d=k.d+(g.c-g.d)
c=A.r(g,b6,0)
b=c.U()
b7.a=c.j()
k=c.j()
b7.b=k
A.ai(b7.a,k,m,!1)
b7.c=J.c(c.a,c.d++)
b7.d=J.c(c.a,c.d++)
J.c(c.a,c.d++)
b7.f=J.c(c.a,c.d++)
b7.r=J.c(c.a,c.d++)
k=b7.d
if(!(k===0||k===2||k===3||k===4||k===6))return b6
if(b7.f!==0)return b6
switch(k){case 0:if(!B.k.by(A.m([1,2,4,8,16],p),b7.c))return b6
break
case 2:if(!B.k.by(A.m([8,16],p),b7.c))return b6
break
case 3:if(!B.k.by(A.m([1,2,4,8],p),b7.c))return b6
break
case 4:if(!B.k.by(A.m([8,16],p),b7.c))return b6
break
case 6:if(!B.k.by(A.m([8,16],p),b7.c))return b6
break}if(b5.e.j()!==A.cx(b,A.cx(new A.aN(h),0)))throw A.e(A.j("Invalid "+h+" checksum"))
break
case"PLTE":k=b5.e
g=k.ar(i)
k.d=k.d+(g.c-g.d)
b7.w=g.U()
if(b5.e.j()!==A.cx(n.a(b7.w),A.cx(new A.aN(h),0)))throw A.e(A.j("Invalid "+h+" checksum"))
break
case"tRNS":k=b5.e
g=k.ar(i)
k.d=k.d+(g.c-g.d)
b7.x=g.U()
a=b5.e.j()
k=b7.x
k.toString
if(a!==A.cx(k,A.cx(new A.aN(h),0)))throw A.e(A.j("Invalid "+h+" checksum"))
break
case"IEND":b5.e.d+=4
break
case"gAMA":if(i!==4)throw A.e(A.j("Invalid gAMA chunk"))
b5.e.j()
b5.e.d+=4
break
case"IDAT":o.push(j)
k=b5.e
k.d=(k.d+=i)+4
break
case"acTL":b7.CW=b5.e.j()
b5.e.j()
b5.e.d+=4
break
case"fcTL":b5.e.j()
a0=b5.e.j()
a1=b5.e.j()
a2=b5.e.j()
a3=b5.e.j()
a4=b5.e.l()
a5=b5.e.l()
k=b5.e
a6=J.c(k.a,k.d++)
k=b5.e
a7=J.c(k.a,k.d++)
k=B.cX[a6]
a8=B.fq[a7]
q.push(new A.fR(A.m([],p),a0,a1,a2,a3,a4,a5,k,a8))
b5.e.d+=4
break
case"fdAT":b5.e.j()
B.k.gd8(q).y.push(j)
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
if(k!=null){k=B.c.by(k,a9)?0:255
a8=new Uint8Array(4)
a8[0]=b1
a8[1]=b2
a8[2]=b3
a8[3]=k
b7.z=new A.bQ(a8)}else{k=new Uint8Array(3)
k[0]=b1
k[1]=b2
k[2]=b3
b7.z=new A.fj(k)}}else if(k===0||k===4){b5.e.l()
i-=2}else if(k===2||k===6){k=b5.e
k.l()
k.l()
k.l()
i-=24}if(i>0)b5.e.d+=i
b5.e.d+=4
break
case"iCCP":b7.Q=b5.e.cz()
k=b5.e
J.c(k.a,k.d++)
k=b7.Q
a8=b5.e
g=a8.ar(i-(k.length+2))
a8.d=a8.d+(g.c-g.d)
b7.at=g.U()
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
ae(a){return A.K(new A.jz(this,a))},
jA(c0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3=this,b4=null,b5=b3.a,b6=b5.a,b7=b5.b,b8=b5.cy,b9=b8.length
if(b9===0||c0===0){m=A.m([],t.h)
b8=b5.db
l=b8.length
for(k=0,j=0;j<l;++j){b9=b3.e
b9===$&&A.b()
b9.d=b8[j]
i=b9.j()
h=b3.e.aj(4)
b9=b3.e
g=b9.ar(i)
b9.d=b9.d+(g.c-g.d)
f=g.U()
k+=f.length
m.push(f)
if(b3.e.j()!==A.cx(f,A.cx(new A.aN(h),0)))throw A.e(A.j("Invalid "+h+" checksum"))}e=new Uint8Array(k)
for(b8=m.length,d=0,c=0;c<m.length;m.length===b8||(0,A.a0)(m),++c){f=m[c]
B.c.em(e,d,f)
d+=f.length}}else{if(c0>=b9)throw A.e(A.j("Invalid Frame Number: "+c0))
b=b8[c0]
b6=b.b
b7=b.c
A.ai(b6,b7,b3.b,!1)
m=A.m([],t.h)
for(b8=b.y,k=0,j=0;j<b8.length;++j){b9=b3.e
b9===$&&A.b()
b9.d=b8[j]
i=b9.j()
b9=b3.e
b9.aj(4)
b9.d+=4
b9=b3.e
g=b9.ar(i-4)
b9.d=b9.d+(g.c-g.d)
f=g.U()
k+=f.length
m.push(f)}e=new Uint8Array(k)
for(b8=m.length,d=0,c=0;c<m.length;m.length===b8||(0,A.a0)(m),++c){f=m[c]
B.c.em(e,d,f)
d+=f.length}}b8=b5.d
a=1
if(!(b8===3))if(!(b8===0)){if(b8===4)b8=2
else b8=b8===6?4:3
a=b8}b8=A.j_(e,B.a3,b4,b4)
s=A.nr(new A.fJ(b8,B.S,!1,B.ay))
b3.d=b3.c=0
a0=b4
if(b5.d===3){b8=b5.w
if(b8!=null){a1=b8.length/3|0
a2=b5.x
b9=a2!=null
a3=b9?a2.length:0
a4=b9?4:3
a0=new A.ba(new Uint8Array(a1*a4),a1,a4)
for(b9=a4===4,j=0,a5=0;j<a1;++j,a5+=3){a6=b9&&j<a3?a2[j]:255
a0.cH(j,b8[a5],b8[a5+1],b8[a5+2],a6)}}}if(b5.d===0&&b5.x!=null&&a0==null&&b5.c<=8){a2=b5.x
a7=a2.length
b8=b5.c
a1=B.a.X(1,b8)
b9=new Uint8Array(a1*4)
a0=new A.ba(b9,a1,4)
if(b8===1)a8=255
else if(b8===2)a8=85
else{b8=b8===4?17:1
a8=b8}for(j=0;j<a1;++j){a9=j*a8
a0.cH(j,a9,a9,a9,255)}for(j=0;j<a7;j+=2){b0=(a2[j]&255)<<8|a2[j+1]&255
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
try{if(b5.r!==0){b3.bS(s,r,0,0,8,8,B.b.i(o+7,3),B.b.i(n+7,3))
b3.bS(s,r,4,0,8,8,B.b.i(o+3,3),B.b.i(n+7,3))
b3.bS(s,r,0,4,4,8,B.b.i(o+3,2),B.b.i(n+3,3))
b3.bS(s,r,2,0,4,4,B.b.i(o+1,2),B.b.i(n+3,2))
b3.bS(s,r,0,2,2,4,B.b.i(o+1,1),B.b.i(n+1,2))
b3.bS(s,r,1,0,2,2,B.b.i(o,1),B.b.i(n+1,1))
b3.bS(s,r,0,1,1,2,o,B.b.i(n,1))}else b3.jG(s,r)}catch(b2){b8=A.ar(b2)
if(b8 instanceof A.fa)return b4
else if(b8 instanceof A.be)return b4
else if(b8 instanceof A.i2)return b4
else throw b2}finally{s.fP()
b5.a=q
b5.b=p}b8=b5.at
if(b8!=null)r.c=new A.bf(b5.Q,B.cs,b8)
b5=b5.ax
if(b5.a!==0)r.kF(b5)
return r},
aY(a,b){return A.K(new A.jA(this,a,b))},
jz(a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null
if(a.az(a1)==null)return a0
s=a.a
r=s.cy
q=r.length
if(q===0||a2!=null)return a.ae(a2==null?0:a2)
p=Math.min(s.CW,q)
new A.bl(a.b).bU(0,s.a*p,s.b)
for(q=t.g,o=a0,n=o,m=0;m<p;++m){a2=r[m]
l=a.ae(m)
if(l==null)continue
if(n==null||o==null){n=l.fS(l.gbO())
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
i=i===(h==null?0:h)&&a2.d===0&&a2.e===0&&a2.x===B.bv}else i=!1
if(i){k=a2.f
l.y=B.b.h((k===0||a2.r===0?0:k/a2.r)*1000)
n.b1(l)
o=l
continue}c=n.x
o=A.aP((c===$?n.x=A.m([],q):c)[k],!1,!1)
b=j.w
if(b===B.bx){k=j.d
i=j.e
h=s.z
if(h==null){h=new Uint8Array(4)
g=new A.bQ(h)
h[0]=0
h[1]=0
h[2]=0
h[3]=0
h=g}A.oA(o,!1,h,k,k+j.b-1,i,i+j.c-1)}else if(b===B.by&&m>1){c=n.x
if(c===$)c=n.x=A.m([],q)
k=j.d
i=j.e
h=j.b
g=j.c
o=A.mC(o,c[m-2],B.ac,g,h,k,i,g,h,k,i)}k=a2.f
o.y=B.b.h((k===0||a2.r===0?0:k/a2.r)*1000)
k=a2.x===B.bw?B.ac:B.a2
o=A.mC(o,l,k,a0,a0,a2.d,a2.e,a0,a0,a0,a0)
n.b1(o)}return n},
gdR(){var s=this.a.d
if(s===4)s=2
else if(s===2)s=3
else s=s===6?4:1
return s},
bS(a,b,a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this
if(a4===0||a5===0)return
s=c.gdR()
r=c.a.c
q=s*r
p=B.a.i(q+7,3)
o=B.a.W(q*a4+7,8)
n=r===8||r===16
m=A.m([0,0,0,0],t.t)
for(l=a1,k=null,j=null,i=0;i<a5;++i,l+=a3,++c.f,j=g){h=B.bj[a.F()]
g=a.a7(o).U()
s=g.length
if(s!==o)throw A.e(B.aE)
c.fv(h,p,g,j)
if(n){c.fD(g,b,l,a0,a2,a4)
continue}c.d=c.c=0
f=new A.a8(g,0,Math.min(s,s),0,!0)
for(e=a0,d=0;d<a4;++d,e+=a2){c.fl(f,m)
s=b.a
k=s==null?null:s.L(e,l,k)
if(k==null)k=new A.F()
c.fn(k,m)}}},
jG(a,a0){var s,r,q,p,o,n,m,l=this,k=l.gdR(),j=l.a,i=j.c,h=k*i,g=j.a,f=j.b,e=B.a.W(g*h+7,8),d=B.a.i(h+7,3),c=i===8||i===16,b=A.m([0,0,0,0],t.t)
k=a0.a
s=k.gG(k)
s.E()
for(r=null,q=0;q<f;++q,r=o){p=B.bj[a.F()]
o=a.a7(e).U()
k=o.length
if(k!==e)throw A.e(B.aE)
l.fv(p,d,o,r)
if(c){l.fD(o,a0,q,0,1,g)
continue}l.d=l.c=0
n=new A.a8(o,0,Math.min(k,k),0,!0)
for(m=0;m<g;++m){l.fl(n,b)
l.fn(s.gK(),b)
s.E()}}},
fD(a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this.gdR(),d=a1.a,c=d.c,b=this.a,a=b.x
if(b.c===8){s=J.C(d.gA(d))
r=a2*a1.a.gau()+a3*c
q=a4*c
if(c===e){if(a4===1){B.c.aI(s,r,r+a5*e,a0)
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
r=(a2*a1.gZ()+a3)*c
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
fv(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h=c.length,g=b<h?b:h
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
bi(a,b){var s,r,q,p,o,n=this
if(b===0)return 0
if(b===8)return a.F()
if(b===16)return a.l()
for(s=a.c;r=n.d,r<b;){r=a.d
if(r>=s)throw A.e(A.j("Invalid PNG data."))
q=a.a
a.d=r+1
p=J.c(q,r)
r=n.d
n.c=B.a.X(p,r)
n.d=r+8}if(b===1)o=1
else if(b===2)o=3
else{if(b===4)s=15
else s=0
o=s}s=r-b
r=B.a.Y(n.c,s)
n.d=s
return r&o},
fl(a,b){var s=this,r=s.a,q=r.d
switch(q){case 0:b[0]=s.bi(a,r.c)
return
case 2:b[0]=s.bi(a,r.c)
b[1]=s.bi(a,r.c)
b[2]=s.bi(a,r.c)
return
case 3:b[0]=s.bi(a,r.c)
return
case 4:b[0]=s.bi(a,r.c)
b[1]=s.bi(a,r.c)
return
case 6:b[0]=s.bi(a,r.c)
b[1]=s.bi(a,r.c)
b[2]=s.bi(a,r.c)
b[3]=s.bi(a,r.c)
return}throw A.e(A.j("Invalid color type: "+q+"."))},
fn(a,b){var s,r,q,p,o,n,m,l=this.a,k=l.d
switch(k){case 0:k=l.x
if(k!=null&&l.c>8){l=k[0]
k=k[1]
s=b[0]
a.ag(s,s,s,s!==((l&255)<<8|k&255)?a.gD():0)
return}a.aq(b[0],0,0)
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
if(r!==((k&255)<<8|p&255)||s!==((o&255)<<8|n&255)||q!==((m&255)<<8|l&255)){a.ag(r,s,q,a.gD())
return}}a.aq(r,s,q)
return
case 3:a.sM(b[0])
return
case 4:a.ag(b[0],0,0,b[1])
return
case 6:a.ag(b[0],b[1],b[2],b[3])
return}throw A.e(A.j("Invalid color type: "+k+"."))}}
A.jB.prototype={
$0(){return this.a.jB(this.b)},
$S:5}
A.jz.prototype={
$0(){return this.a.jA(this.b)},
$S:1}
A.jA.prototype={
$0(){return this.a.jz(this.b,this.c)},
$S:1}
A.i2.prototype={}
A.bF.prototype={
a6(){return"PnmFormat."+this.b}}
A.cm.prototype={}
A.jD.prototype={
aD(a){var s
this.b=A.q(a,!1,null,0)
s=this.cW()
if(s==="P1"||s==="P2"||s==="P5"||s==="P3"||s==="P6")return!0
return!1},
aY(a,b){return A.K(new A.jG(this,a,b))},
jC(a,b){if(this.az(a)==null)return null
return this.ae(0)},
az(a){return A.K(new A.jH(this,a))},
jE(a){var s,r,q,p=this
p.b=A.q(a,!1,null,0)
s=p.cW()
if(s==="P1"){r=p.a=new A.cm(B.Z)
r.e=B.bz}else if(s==="P2"){r=p.a=new A.cm(B.Z)
r.e=B.bA}else if(s==="P5"){r=p.a=new A.cm(B.Z)
r.e=B.aq}else if(s==="P3"){r=p.a=new A.cm(B.Z)
r.e=B.bB}else if(s==="P6"){r=p.a=new A.cm(B.Z)
r.e=B.ar}else return p.b=null
r.a=p.cm()
r=p.a
r.toString
r.b=p.cm()
r=p.a
q=r.a
if(q<1||r.b<1)return p.a=p.b=null
A.ai(q,r.b,p.d,!1)
return p.a},
ae(a){return A.K(new A.jF(this,a))},
jD(a){var s,r,q,p,o,n=this,m=null,l=n.a
if(l==null)return m
l=l.e
if(l===B.bz){n.dt(1)
l=n.a
s=l.a
r=A.Q(m,m,B.u,0,B.i,l.b,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gG(l);l.E();){q=l.gK()
if(n.cW()==="1")q.aq(1,1,1)
else q.aq(0,0,0)}return r}else if(l===B.bA||l===B.aq){p=n.cm()
if(p===0)return m
n.dt(1)
l=n.a
s=l.a
l=l.b
r=A.Q(m,m,n.fW(p),0,B.i,l,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gG(l);l.E();){q=l.gK()
o=n.cZ(n.a.e,p)
q.aq(o,o,o)}return r}else if(l===B.bB||l===B.ar){p=n.cm()
if(p===0)return m
n.dt(3)
l=n.a
s=l.a
l=l.b
r=A.Q(m,m,n.fW(p),0,B.i,l,m,0,3,m,B.e,s,!1)
for(l=r.a,l=l.gG(l);l.E();)l.gK().aq(n.cZ(n.a.e,p),n.cZ(n.a.e,p),n.cZ(n.a.e,p))
return r}return m},
dt(a){var s,r=this.a,q=r.a
r=r.b
s=this.b
if(s.c-s.d+this.c.gp(0)<q*r*a)throw A.e(A.j("Truncated PNM data"))},
fW(a){if(a>255)return B.m
if(a>15)return B.e
if(a>3)return B.y
if(a>1)return B.x
return B.u},
cZ(a,b){if(a===B.aq||a===B.ar)return this.b.F()
return this.cm()},
cm(){var s,r,q=this.cW()
if(J.by(q)===0)return 0
try{s=A.u0(q)
return s}catch(r){return 0}},
cW(){var s,r,q,p,o=this.b
if(o==null)return""
s=this.c
if(!s.ga4(0))return s.h8()
r=B.E.he(o.lk())
if(r.length===0)return""
while(B.E.er(r,"#"))r=B.E.he(this.b.h6(70))
o=t.cc
q=A.o(new A.eK(A.m(r.split(" "),t.s),new A.jE(),o),o.n("d.E"))
for(o=q.length,p=0;p<o;++p)if(B.E.er(q[p],"#")){B.k.sp(q,p)
break}s.e_(0,q)
if(s.b===s.c)return""
return s.h8()}}
A.jG.prototype={
$0(){return this.a.jC(this.b,this.c)},
$S:1}
A.jH.prototype={
$0(){return this.a.jE(this.b)},
$S:5}
A.jF.prototype={
$0(){return this.a.jD(this.b)},
$S:1}
A.jE.prototype={
$1(a){return a!==""},
$S:29}
A.hj.prototype={}
A.hk.prototype={}
A.bb.prototype={}
A.hm.prototype={}
A.hn.prototype={}
A.hq.prototype={}
A.hr.prototype={}
A.ev.prototype={}
A.hp.prototype={}
A.jI.prototype={
hL(a){var s,r,q,p,o=this
a.l()
a.l()
a.l()
a.l()
s=B.a.W(a.c-a.d,8)
if(s>0){o.e=new Uint16Array(s)
o.f=new Uint16Array(s)
o.r=new Uint16Array(s)
o.w=new Uint16Array(s)
for(r=0;r<s;++r){q=o.e
p=a.l()
q.$flags&2&&A.a(q)
q[r]=p
p=o.f
q=a.l()
p.$flags&2&&A.a(p)
p[r]=q
q=o.r
p=a.l()
q.$flags&2&&A.a(q)
q[r]=p
p=o.w
q=a.l()
p.$flags&2&&A.a(p)
p[r]=q}}}}
A.dd.prototype={
h5(a,b,c,d,e,f,g){if(a.c-a.d<2)return
if(e==null)e=a.l()
switch(e){case 0:d.toString
this.ka(a,b,c,d)
break
case 1:if(f==null)f=this.k7(a,c)
d.toString
this.k9(a,b,c,d,f,g)
break
default:throw A.e(A.j("Unsupported compression: "+e))}},
lj(a,b,c,d){return this.h5(a,b,c,d,null,null,0)},
k7(a,b){var s,r=new Uint16Array(b)
for(s=0;s<b;++s)r[s]=a.l()
return r},
ka(a,b,c,d){var s,r=b*c
if(d===16)r*=2
if(r>a.c-a.d){s=new Uint8Array(r)
this.c=s
B.c.ao(s,0,r,255)
return}this.c=a.a7(r).U()},
k9(a,b,c,d,e,f){var s,r,q,p,o,n,m=b*c
if(d===16)m*=2
s=new Uint8Array(m)
this.c=s
r=f*c
if(r>=e.length){B.c.ao(s,0,m,255)
return}for(q=0,p=0;p<c;++p,r=o){o=r+1
n=a.ar(e[r])
a.d=a.d+(n.c-n.d)
s=this.c
s.toString
this.iH(n,s,q)
q+=b}},
iH(a,b,c){var s,r,q,p,o,n,m,l,k
for(s=a.c,r=b.$flags|0,q=b.length;p=a.d,p<s;){o=a.a
a.d=p+1
p=J.c(o,p)
o=$.ak()
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
A.b5.prototype={
a6(){return"PsdColorMode."+this.b}}
A.jN.prototype={
gkH(){var s=this.e
s===$&&A.b()
return s},
hM(a,b){var s,r,q=this
q.as=A.q(a,!0,null,0)
q.jK()
if(q.c!==943870035)return
s=q.as.j()
q.as.a7(s)
s=q.as.j()
q.ax=q.as.a7(s)
s=q.as.j()
q.ay=q.as.a7(s)
r=q.as
q.ch=r.a7(r.c-r.d)},
bz(){var s,r=this
if(r.c===943870035){s=r.as
s===$&&A.b()
s=s==null}else s=!0
if(s)return!1
A.ai(r.a,r.b,r.CW,!1)
s=r.e
s===$&&A.b()
if(s<1||s>56)throw A.e(A.j("Invalid number of PSD channels: "+r.gkH()))
r.k5()
r.k6()
r.k8()
r.ch=r.ay=r.ax=r.as=null
return!0},
kS(){if(!this.bz())return null
return this.ln()},
ln(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=null,a2=a0.y
if(a2!=null)return a2
a2=a0.a
a2=A.Q(a1,a1,B.e,0,B.i,a0.b,a1,0,4,a1,B.e,a2,!1)
a0.y=a2
a2.d5(0)
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
g=h==null?a1:h.L(i,l,a1)
if(g==null)g=new A.F()
f=B.b.h(g.gq())
e=B.b.h(g.gu())
d=B.b.h(g.gv())
c=B.b.h(g.gt())
j.toString
if(j>=0&&j<a0.a&&q&&m<a0.b){h=r.b
h.toString
b=a0.y.a
a=b==null?a1:b.L(h+i,k,a1)
if(a==null)a=new A.F()
a0.hW(B.b.h(a.gq()),B.b.h(a.gu()),B.b.h(a.gv()),B.b.h(a.gt()),f,e,d,c,o,p,a)}++i;++j}++l;++m}}a2=a0.y
a2.toString
return a2},
hW(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n=h/255*j
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
case 1836411936:p=B.a.i(a*e,8)
q=B.a.i(b*f,8)
r=B.a.i(c*g,8)
s=h
break
case 1768188278:p=A.jO(a,e)
q=A.jO(b,f)
r=A.jO(c,g)
s=h
break
case 1818391150:p=A.jQ(a,e)
q=A.jQ(b,f)
r=A.jQ(c,g)
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
case 1935897198:p=A.mb(a,e)
q=A.mb(b,f)
r=A.mb(c,g)
s=h
break
case 1684633120:p=A.jP(a,e)
q=A.jP(b,f)
r=A.jP(c,g)
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
case 1870030194:p=A.m9(a,e,d,h)
q=A.m9(b,f,d,h)
r=A.m9(c,g,d,h)
s=h
break
case 1934387572:p=A.mc(a,e)
q=A.mc(b,f)
r=A.mc(c,g)
s=h
break
case 1749838196:p=A.m7(a,e)
q=A.m7(b,f)
r=A.m7(c,g)
s=h
break
case 1984719220:p=A.md(a,e)
q=A.md(b,f)
r=A.md(c,g)
s=h
break
case 1816947060:p=A.m8(a,e)
q=A.m8(b,f)
r=A.m8(c,g)
s=h
break
case 1884055924:p=A.ma(a,e)
q=A.ma(b,f)
r=A.ma(c,g)
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
case 1936553316:p=A.m6(a,e)
q=A.m6(b,f)
r=A.m6(c,g)
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
k.su(B.b.h(b*o+q*n))
k.sv(B.b.h(c*o+r*n))
k.st(B.b.h(d*o+s*n))},
jK(){var s,r,q=this,p=q.as
p===$&&A.b()
q.c=p.j()
p=q.as.l()
q.d=p
if(p!==1){q.c=0
return}s=q.as.a7(6)
for(r=0;r<6;++r)if(J.c(s.a,s.d+r)!==0){q.c=0
return}q.e=q.as.l()
q.b=q.as.j()
q.a=q.as.j()
q.f=q.as.l()
q.r=B.jg[q.as.l()]},
k5(){var s,r,q,p,o,n=this,m=n.ax
m.d=m.b
for(m=n.z;s=n.ax,s.d<s.c;){r=s.j()
q=n.ax.l()
s=n.ax
p=J.c(s.a,s.d++)
n.ax.aj(p)
if((p&1)===0)++n.ax.d
p=n.ax.j()
s=n.ax
o=s.ar(p)
s.d=s.d+(o.c-o.d)
if((p&1)===1)++n.ax.d
if(r===943868237)m.m(0,q,new A.hl())}},
k6(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=d.ay
c.d=c.b
s=c.j()
if((s&1)!==0)++s
r=d.ay.a7(s)
c=d.w
B.k.d5(c)
if(s>0){q=r.l()
p=$.aj()
p.$flags&2&&A.a(p)
p[0]=q
o=$.as()[0]
if(o<0)o=-o
for(q=t.N,p=t.hf,n=t.l,m=t.af,l=0;l<o;++l){k=new A.ho(A.D(q,p),A.m([],n),A.m([],m))
k.hN(r)
c.push(k)}}q=d.CW
j=new A.bl(q)
i=d.f===16?2:1
p=d.a
n=d.b
m=d.e
m===$&&A.b()
h=p*n*m*i
for(p=c.length,g=0;g<c.length;c.length===p||(0,A.a0)(c),++g){k=c[g]
n=k.e
n===$&&A.b()
m=k.f
m===$&&A.b()
A.ai(n,m,q,!0)
j.bU(0,k.e,k.f)
m=k.e
n=k.f
f=k.as
f===$&&A.b()
h+=m*n*f.length*i}if(h>Math.max(128*d.at,16777216))throw A.e(A.j("PSD data is too small for its size"))
for(l=0;l<c.length;++l)c[l].lg(r,d)
s=d.ay.j()
e=d.ay.a7(s)
if(s>0){e.l()
e.l()
e.l()
e.l()
e.l()
e.l()
e.F()}},
k8(){var s,r,q,p,o,n,m=this,l=m.ch
l.d=l.b
s=l.l()
if(s===1){l=m.b
r=m.e
r===$&&A.b()
q=l*r
p=new Uint16Array(q)
for(o=0;o<q;++o)p[o]=m.ch.l()}else p=null
m.x=A.m([],t.c)
o=0
for(;;){l=m.e
l===$&&A.b()
if(!(o<l))break
l=m.x
r=m.ch
r.toString
n=o===3?-1:o
n=new A.dd(n)
n.h5(r,m.a,m.b,m.f,s,p,o)
l.push(n);++o}m.y=A.nM(m.r,m.f,m.a,m.b,m.x)}}
A.hl.prototype={}
A.ho.prototype={
hN(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=a3.j(),a2=$.O()
a2.$flags&2&&A.a(a2)
a2[0]=a1
a1=$.a1()
a0.a=a1[0]
a2[0]=a3.j()
a0.b=a1[0]
a2[0]=a3.j()
a0.c=a1[0]
a2[0]=a3.j()
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
s=a3.l()
for(r=0;r<s;++r){a1=a3.l()
a2=$.aj()
a2.$flags&2&&A.a(a2)
a2[0]=a1
q=$.as()[0]
a3.j()
a0.as.push(new A.dd(q))}p=a3.j()
if(p!==943868237)throw A.e(A.j("Invalid PSD layer signature: "+B.a.di(p,16)))
a0.r=a3.j()
a0.w=a3.F()
a3.F()
a0.y=a3.F()
if(a3.F()!==0)throw A.e(A.j("Invalid PSD layer data"))
o=a3.j()
n=a3.a7(o)
if(o>0){o=n.j()
if(o>0){m=n.a7(o)
a1=m.d
m.j()
m.j()
m.j()
m.j()
m.F()
m.F()
if(m.c-a1===20)m.d+=2
else{m.F()
m.F()
m.j()
m.j()
m.j()
m.j()}}o=n.j()
if(o>0)new A.jI().hL(n.a7(o))
o=n.F()
n.aj(o)
l=4-B.a.a2(o,4)-1
if(l>0)n.d+=l
for(a1=n.c,a2=a0.ay,k=a0.cy,j=t.cE;n.d<a1;){p=n.j()
if(p!==943868237)throw A.e(A.j("PSD invalid signature for layer additional data: "+B.a.di(p,16)))
i=n.aj(4)
o=n.j()
h=n.ar(o)
g=n.d+(h.c-h.d)
n.d=g
if((o&1)===1)n.d=g+1
a2.m(0,i,A.qn(i,h))
if(i==="lrFX"){f=A.r(j.a(a2.k(0,"lrFX")).b,null,0)
f.l()
e=f.l()
for(d=0;d<e;++d){f.aj(4)
c=f.aj(4)
b=f.j()
if(c==="dsdw"){a=new A.hk()
k.push(a)
a.a=f.j()
f.j()
f.j()
f.j()
f.j()
f.l()
f.l()
f.l()
f.l()
f.l()
f.aj(8)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
f.l()
f.l()
f.l()
f.l()
f.l()}else if(c==="isdw"){a=new A.hn()
k.push(a)
a.a=f.j()
f.j()
f.j()
f.j()
f.j()
f.l()
f.l()
f.l()
f.l()
f.l()
f.aj(8)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
f.l()
f.l()
f.l()
f.l()
f.l()}else if(c==="oglw"){a=new A.hq()
k.push(a)
a.a=f.j()
f.j()
f.j()
f.l()
f.l()
f.l()
f.l()
f.l()
f.aj(8)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
if(a.a===2){f.l()
f.l()
f.l()
f.l()
f.l()}}else if(c==="iglw"){a=new A.hm()
k.push(a)
a.a=f.j()
f.j()
f.j()
f.l()
f.l()
f.l()
f.l()
f.l()
f.aj(8)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
if(a.a===2){J.c(f.a,f.d++)
f.l()
f.l()
f.l()
f.l()
f.l()}}else if(c==="bevl"){a=new A.hj()
k.push(a)
a.a=f.j()
f.j()
f.j()
f.j()
f.aj(8)
f.aj(8)
f.l()
f.l()
f.l()
f.l()
f.l()
f.l()
f.l()
f.l()
f.l()
f.l()
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
J.c(f.a,f.d++)
if(a.a===2){f.l()
f.l()
f.l()
f.l()
f.l()
f.l()
f.l()
f.l()
f.l()
f.l()}}else if(c==="sofi"){a=new A.hr()
k.push(a)
a.a=f.j()
f.aj(4)
f.l()
f.l()
f.l()
f.l()
f.l()
J.c(f.a,f.d++)
J.c(f.a,f.d++)
f.l()
f.l()
f.l()
f.l()
f.l()}else f.d+=b}}}}},
lg(a,b){var s,r,q,p,o,n=this,m=0
for(;;){s=n.as
s===$&&A.b()
if(!(m<s.length))break
s=s[m]
r=n.e
r===$&&A.b()
q=n.f
q===$&&A.b()
s.lj(a,r,q,b.f);++m}r=b.r
q=b.f
p=n.e
p===$&&A.b()
o=n.f
o===$&&A.b()
n.cx=A.nM(r,q,p,o,s)}}
A.de.prototype={}
A.jJ.prototype={
aD(a){var s,r
try{s=A.nL(a,null).c
return s===943870035}catch(r){return!1}},
aY(a,b){return A.K(new A.jL(this,a,b))},
jJ(a,b){var s,r,q,p=this
if(p.az(a)==null)return null
s=p.a==null?null:1
if(s==null)s=0
if(s===1)return p.ae(0)
for(r=null,q=0;q<s;++q){b=p.ae(q)
if(b==null)continue
if(r==null){b.w=B.aJ
r=b}else r.b1(b)}return r},
az(a){return A.K(new A.jM(this,a))},
ae(a){return A.K(new A.jK(this,a))}}
A.jL.prototype={
$0(){return this.a.jJ(this.b,this.c)},
$S:1}
A.jM.prototype={
$0(){var s=this.a
return s.a=A.nL(this.b,s.b)},
$S:5}
A.jK.prototype={
$0(){var s=this.a.a
return s==null?null:s.kS()},
$S:1}
A.ht.prototype={}
A.dg.prototype={}
A.am.prototype={
bW(a,b){var s=this
return new A.am(s.a+b.a,s.b+b.b,s.c+b.c,s.d+b.d)}}
A.ew.prototype={
gZ(){return this.a},
gS(){return this.b}}
A.df.prototype={
gS(){return this.f},
gZ(){return this.r}}
A.hs.prototype={
gZ(){return this.a},
gS(){return this.b}}
A.aQ.prototype={
scp(a){var s=this.a,r=this.b
s.$flags&2&&A.a(s)
s[r+1]=a},
cB(){var s=this.e,r=this.d
if(s)return new A.dg(B.w[r>>>9],B.w[r>>>4&31],B.t[r&15])
else return new A.dg(B.t[r>>>7&15],B.t[r>>>3&15],B.a9[r&7])},
cD(){var s=this.e,r=this.d
if(s)return new A.am(B.w[r>>>9],B.w[r>>>4&31],B.t[r&15],255)
else return new A.am(B.t[r>>>7&15],B.t[r>>>3&15],B.a9[r&7],B.a9[r>>>11&7])},
cC(){var s=this.r,r=this.f
if(s)return new A.dg(B.w[r>>>10],B.w[r>>>5&31],B.w[r&31])
else return new A.dg(B.t[r>>>8&15],B.t[r>>>4&15],B.t[r&15])},
cE(){var s=this.r,r=this.f
if(s)return new A.am(B.w[r>>>10],B.w[r>>>5&31],B.w[r&31],255)
else return new A.am(B.t[r>>>8&15],B.t[r>>>4&15],B.t[r&15],B.a9[r>>>12&7])},
cj(){var s=this,r=s.c?1:0,q=s.d,p=s.e?1:0,o=s.f,n=s.r?1:0
return(r|(q&16383)<<1|p<<15|(o&32767)<<16|n<<31)>>>0},
bp(){var s=this,r=s.a[s.b+1]
s.c=(r&1)===1
s.scp(s.cj())
s.d=r>>>1&16383
s.scp(s.cj())
s.e=(r>>>15&1)===1
s.scp(s.cj())
s.f=r>>>16&32767
s.scp(s.cj())
s.r=(r>>>31&1)===1
s.scp(s.cj())}}
A.jR.prototype={
aD(a){var s,r
try{s=this.az(a)
return s!=null}catch(r){return!1}},
az(a){return A.K(new A.jU(this,a))},
kn(a){var s,r=this,q=a.length,p=q-(q>>>1&1431655765)>>>0
p=(p&858993459)+(p>>>2&858993459)
if((p+(p>>>4)>>>0&252645135)*16843009>>>0>>>24===1){s=r.ip(a)
if(s!=null){r.a=a
return r.b=s}}s=r.iG(a)
if(s!=null){r.a=a
return r.b=s}s=r.iE(a)
if(s!=null){r.a=a
return r.b=s}return null},
iG(a){var s,r,q=A.q(a,!1,null,0)
if(q.c-q.d<52)return null
if(q.j()!==55727696)return null
s=A.m([0,0,0,0],t.t)
r=new A.df(s)
q.j()
r.b=q.j()
s[0]=q.F()
s[1]=q.F()
s[2]=q.F()
s[3]=q.F()
q.j()
q.j()
r.f=q.j()
r.r=q.j()
q.j()
q.j()
q.j()
q.j()
r.Q=q.j()
return r},
iE(a){var s,r,q=A.q(a,!1,null,0)
if(q.j()!==52)return null
s=new A.ew()
s.b=q.j()
s.a=q.j()
q.j()
s.d=q.j()
q.j()
s.f=q.j()
q.j()
q.j()
q.j()
s.y=q.j()
r=q.j()
s.z=r
s.Q=q.j()
if(r!==559044176)return null
return s},
ip(a){var s,r,q,p,o,n,m=null,l=a.length,k=A.q(a,!1,m,0)
if(k.j()!==0)return m
s=new A.hs()
s.b=k.j()
s.a=k.j()
k.j()
k.j()
k.j()
k.j()
k.j()
k.j()
k.j()
r=k.j()
s.y=r
if(r===559044176)return m
q=0
p=8
if(!(l===32)){o=0
for(;;){if(!(o<10)){q=1
break}n=o<<1>>>0
if((B.a.N(64,n)&l)>>>0!==0){p=B.a.N(16,o)
q=1
break}if((B.a.N(128,n)&l)>>>0!==0){p=B.a.N(16,o)
break}++o}if(o===10)return m}if((q+1)*2===4)return m
s.b=s.a=p
return s},
ae(a){return A.K(new A.jS(this,a))},
iz(a){var s,r,q=this,p=q.b
if(p==null||q.a==null)return null
A.ai(p.gZ(),q.b.gS(),q.c,!1)
p=q.b
if(p instanceof A.hs){p=p.a
s=q.b.gS()
r=q.a
r.toString
return q.dB(p,s,r)}else if(p instanceof A.ew){p=q.a
p.toString
return q.iD(p)}else if(p instanceof A.df){p=q.a
p.toString
return q.iF(p)}return null},
aY(a,b){return A.K(new A.jT(this,a,b))},
jM(a,b){if(this.az(a)==null)return null
return this.ae(0)},
iD(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=a.length
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
for(s=n.a,s=s.gG(s);s.E();){m=s.gK()
l=J.c(r.a,r.d++)
k=J.c(r.a,r.d++)
m.sq(k&240)
m.su((k&15)<<4)
m.sv(l&240)
m.st((l&15)<<4)}return n
case 17:n=A.Q(f,f,B.e,0,B.i,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gG(s);s.E();){m=s.gK()
j=r.l()
i=(j&1)!==0?255:0
m.sq(j>>>8&248)
m.su(j>>>3&248)
m.sv((j&62)<<2)
m.st(i)}return n
case 18:n=A.Q(f,f,B.e,0,B.i,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gG(s);s.E();){m=s.gK()
m.sq(J.c(r.a,r.d++))
m.su(J.c(r.a,r.d++))
m.sv(J.c(r.a,r.d++))
m.st(J.c(r.a,r.d++))}return n
case 19:n=A.Q(f,f,B.e,0,B.i,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gG(s);s.E();){m=s.gK()
j=r.l()
m.sq(j>>>8&248)
m.su(j>>>3&252)
m.sv((j&31)<<3)}return n
case 20:n=A.Q(f,f,B.e,0,B.i,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gG(s);s.E();){m=s.gK()
j=r.l()
m.sq((j&31)<<3)
m.su(j>>>2&248)
m.sv(j>>>7&248)}return n
case 21:n=A.Q(f,f,B.e,0,B.i,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gG(s);s.E();){m=s.gK()
m.sq(J.c(r.a,r.d++))
m.su(J.c(r.a,r.d++))
m.sv(J.c(r.a,r.d++))}return n
case 22:n=A.Q(f,f,B.e,0,B.i,o,f,0,1,f,B.e,p,!1)
for(s=n.a,s=s.gG(s);s.E();)s.gK().sq(J.c(r.a,r.d++))
return n
case 23:n=A.Q(f,f,B.e,0,B.i,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gG(s);s.E();){m=s.gK()
i=J.c(r.a,r.d++)
h=J.c(r.a,r.d++)
m.sq(h)
m.su(h)
m.sv(h)
m.st(i)}return n
case 24:return f
case 25:return s.y===0?g.eW(p,o,r.U()):g.dB(p,o,r.U())}return f},
iF(a){var s,r,q,p=this
if(!(p.b instanceof A.df))return null
s=A.q(a,!1,null,0)
r=s.d+=52
q=t.a7.a(p.b)
s.d=r+q.Q
if(q.c[0]===0)switch(q.b){case 2:return p.eW(q.r,q.f,s.U())
case 3:return p.dB(q.r,q.f,s.U())}return null},
eW(c5,c6,c7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=null,b6=A.Q(b5,b5,B.e,0,B.i,c6,b5,0,3,b5,B.e,c5,!1),b7=c5/4|0,b8=b7-1,b9=J.au(B.c.gA(c7),0,null),c0=new A.aQ(b9),c1=new A.aQ(J.au(B.c.gA(c7),0,null)),c2=new A.aQ(J.au(B.c.gA(c7),0,null)),c3=new A.aQ(J.au(B.c.gA(c7),0,null)),c4=new A.aQ(J.au(B.c.gA(c7),0,null))
for(s=0,r=0;s<b7;++s,r+=4)for(q=0,p=0;q<b7;++q,p+=4){c0.b=A.bm(q,s)<<1>>>0
c0.bp()
o=b9[c0.b]
n=c0.c?4:0
for(m=0,l=0;l<4;++l){k=(s+(l<2?-1:0)&b8)>>>0
j=(k+1&b8)>>>0
for(i=l+r,h=0;h<4;++h){g=(q+(h<2?-1:0)&b8)>>>0
f=(g+1&b8)>>>0
c1.b=A.bm(g,k)<<1>>>0
c1.bp()
c2.b=A.bm(f,k)<<1>>>0
c2.bp()
c3.b=A.bm(g,j)<<1>>>0
c3.bp()
c4.b=A.bm(f,j)<<1>>>0
c4.bp()
e=c1.cB()
d=B.o[m][0]
c=c2.cB()
b=B.o[m][1]
a=c3.cB()
a0=B.o[m][2]
a1=c4.cB()
a2=B.o[m][3]
a3=c1.cC()
a4=B.o[m][0]
a5=c2.cC()
a6=B.o[m][1]
a7=c3.cC()
a8=B.o[m][2]
a9=c4.cC()
b0=B.o[m][3]
b1=B.bd[n+o&3]
b2=b1[0]
b3=b1[1]
b4=b6.a
if(b4!=null)b4.aC(h+p,i,(e.a*d+c.a*b+a.a*a0+a1.a*a2)*b2+(a3.a*a4+a5.a*a6+a7.a*a8+a9.a*b0)*b3>>>7,(e.b*d+c.b*b+a.b*a0+a1.b*a2)*b2+(a3.b*a4+a5.b*a6+a7.b*a8+a9.b*b0)*b3>>>7,(e.c*d+c.c*b+a.c*a0+a1.c*a2)*b2+(a3.c*a4+a5.c*a6+a7.c*a8+a9.c*b0)*b3>>>7)
o=o>>>2;++m}}}return b6},
dB(b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=null,a4=A.Q(a3,a3,B.e,0,B.i,b4,a3,0,4,a3,B.e,b3,!1),a5=b3/4|0,a6=a5-1,a7=J.au(B.c.gA(b5),0,null),a8=new A.aQ(a7),a9=new A.aQ(J.au(B.c.gA(b5),0,null)),b0=new A.aQ(J.au(B.c.gA(b5),0,null)),b1=new A.aQ(J.au(B.c.gA(b5),0,null)),b2=new A.aQ(J.au(B.c.gA(b5),0,null))
for(s=0,r=0;s<a5;++s,r+=4)for(q=0,p=0;q<a5;++q,p+=4){a8.b=A.bm(q,s)<<1>>>0
a8.bp()
o=a7[a8.b]
n=a8.c?4:0
for(m=0,l=0;l<4;++l){k=(s+(l<2?-1:0)&a6)>>>0
j=(k+1&a6)>>>0
for(i=l+r,h=0;h<4;++h){g=(q+(h<2?-1:0)&a6)>>>0
f=(g+1&a6)>>>0
a9.b=A.bm(g,k)<<1>>>0
a9.bp()
b0.b=A.bm(f,k)<<1>>>0
b0.bp()
b1.b=A.bm(g,j)<<1>>>0
b1.bp()
b2.b=A.bm(f,j)<<1>>>0
b2.bp()
e=a9.cD()
d=B.o[m][0]
c=b0.cD()
b=B.o[m][1]
b=new A.am(e.a*d,e.b*d,e.c*d,e.d*d).bW(0,new A.am(c.a*b,c.b*b,c.c*b,c.d*b))
c=b1.cD()
d=B.o[m][2]
d=b.bW(0,new A.am(c.a*d,c.b*d,c.c*d,c.d*d))
c=b2.cD()
b=B.o[m][3]
a=d.bW(0,new A.am(c.a*b,c.b*b,c.c*b,c.d*b))
b=a9.cE()
c=B.o[m][0]
d=b0.cE()
e=B.o[m][1]
e=new A.am(b.a*c,b.b*c,b.c*c,b.d*c).bW(0,new A.am(d.a*e,d.b*e,d.c*e,d.d*e))
d=b1.cE()
c=B.o[m][2]
c=e.bW(0,new A.am(d.a*c,d.b*c,d.c*c,d.d*c))
d=b2.cE()
e=B.o[m][3]
a0=c.bW(0,new A.am(d.a*e,d.b*e,d.c*e,d.d*e))
a1=B.bd[n+o&3]
e=a1[0]
d=a1[1]
c=a1[2]
b=a1[3]
a2=a4.a
if(a2!=null)a2.ak(h+p,i,a.a*e+a0.a*d>>>7,a.b*e+a0.b*d>>>7,a.c*e+a0.c*d>>>7,a.d*c+a0.d*b>>>7)
o=o>>>2;++m}}}return a4}}
A.jU.prototype={
$0(){return this.a.kn(this.b)},
$S:5}
A.jS.prototype={
$0(){return this.a.iz(this.b)},
$S:1}
A.jT.prototype={
$0(){return this.a.jM(this.b,this.c)},
$S:1}
A.hw.prototype={
bD(a){var s,r=this
if(a.c-a.d<18)return
r.a=a.F()
r.b=a.F()
s=a.F()
r.c=s<12?B.fW[s]:B.aa
a.l()
r.e=a.l()
r.f=a.F()
a.l()
a.l()
r.x=a.l()
r.y=a.l()
r.z=a.F()
r.Q=a.F()},
h_(){var s=this,r=s.z
if(r!==8&&r!==16&&r!==24&&r!==32)return!1
r=s.c
if(r===B.H||r===B.I){if(s.e>256||s.b!==1)return!1
r=s.f
if(r!==16&&r!==24&&r!==32)return!1}else if(s.b===1)return!1
return!0}}
A.an.prototype={
a6(){return"TgaImageType."+this.b}}
A.k2.prototype={
aY(a,b){return A.K(new A.k4(this,a,b))},
kq(a,b){if(this.az(a)==null)return null
return this.ae(0)},
az(a){return A.K(new A.k5(this,a))},
ks(a){var s,r,q,p,o=this
o.a=new A.hw(B.aa)
s=A.q(a,!1,null,0)
o.b=s
r=s.a7(18)
o.a.bD(r)
s=o.a
if(!s.h_()||s.x<1||s.y<1)return null
q=o.b
q.d+=s.a
p=s.c
if(p===B.H||p===B.I)s.as=q.a7(s.e*B.a.i(s.f,3)).U()
s=o.a
s.ax=o.b.d
return s},
ae(a){return A.K(new A.k3(this,a))},
kr(a){var s=this,r=s.a
if(r==null)return null
A.ai(r.x,r.y,s.c,!1)
r=s.a.c
if(r===B.bH)return s.eV()
else if(r===B.bG||r===B.I)return s.iI()
else if(r===B.H)return s.eV()
return null},
eQ(a,b){var s,r,q,p,o,n,m,l=this,k=A.q(a,!1,null,0),j=l.a.f
if(j===16){j=l.b
j===$&&A.b()
s=j.l()
r=s>>>7&248
q=s>>>2&248
p=(s&31)<<3
o=(s&32768)!==0?0:255
for(n=0;n<l.a.e;++n){b.bo(n,r)
b.bn(n,q)
b.bm(n,p)
b.bl(n,o)}}else{m=j===32
for(n=0;n<l.a.e;++n){p=J.c(k.a,k.d++)
q=J.c(k.a,k.d++)
r=J.c(k.a,k.d++)
o=m?J.c(k.a,k.d++):255
b.bo(n,r)
b.bn(n,q)
b.bm(n,p)
b.bl(n,o)}}},
iI(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=null,c=e.a,b=c.z,a=b===16,a0=a||b===32,a1=c.x,a2=c.y,a3=a0?4:3
c=c.c
s=A.Q(d,d,B.e,0,B.i,a2,d,0,a3,d,B.e,a1,c===B.H||c===B.I)
c=s.a
if((c==null?d:c.gR())!=null){c=e.a.as
c.toString
a1=s.a
a1=a1==null?d:a1.gR()
a1.toString
e.eQ(c,a1)}r=s.gZ()
q=s.gS()-1
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
if(a1!=null)a1.aF(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}else{a1=e.b
if(a){i=a1.l()
l=i>>>7&248
h=i>>>2&248
g=(i&31)<<3
f=(i&32768)!==0?0:255
for(k=0;k<n;++k){j=p+1
a1=s.a
if(a1!=null)a1.ak(p,q,l,h,g,f)
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
if(a1!=null)a1.ak(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}}else if(c)for(k=0;k<n;++k){a1=e.b
l=J.c(a1.a,a1.d++)
j=p+1
a1=s.a
if(a1!=null)a1.aF(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}else if(a)for(k=0;k<n;++k){i=e.b.l()
f=(i&32768)!==0?0:255
j=p+1
a1=s.a
if(a1!=null)a1.ak(p,q,i>>>7&248,i>>>2&248,(i&31)<<3,f)
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
if(a1!=null)a1.ak(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}if(p>=r){--q
if(q<0)break
p=0}}return s},
eV(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=d.b
b===$&&A.b()
s=d.a
b.d=s.ax
r=s.z
b=r===16
q=!0
if(!b)if(r!==32){p=s.c
if(p===B.H||p===B.I){p=s.f
p=p===16||p===32}else p=!1
q=p}p=s.x
o=s.y
n=q?4:3
s=s.c
m=A.Q(c,c,B.e,0,B.i,o,c,0,n,c,B.e,p,s===B.H||s===B.I)
s=d.a
p=s.c
if(p===B.H||p===B.I){s=s.as
s.toString
p=m.a
p=p==null?c:p.gR()
p.toString
d.eQ(s,p)}if(r===8)for(l=m.gS()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
b=d.b
j=J.c(b.a,b.d++)
b=m.a
if(b!=null)b.aF(k,l,j);++k}}else if(b)for(l=m.gS()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
i=d.b.l()
h=(i&32768)!==0?0:255
b=m.a
if(b!=null)b.ak(k,l,i>>>7&248,i>>>2&248,(i&31)<<3,h);++k}}else for(l=m.gS()-1;l>=0;--l){k=0
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
if(b!=null)b.ak(k,l,e,f,g,h);++k}}return m}}
A.k4.prototype={
$0(){return this.a.kq(this.b,this.c)},
$S:1}
A.k5.prototype={
$0(){return this.a.ks(this.b)},
$S:5}
A.k3.prototype={
$0(){return this.a.kr(this.b)},
$S:1}
A.k6.prototype={
ai(a){var s,r,q,p,o=this
if(a===0)return 0
if(o.c===0){o.c=8
o.b=o.a.F()}for(s=o.a,r=0;q=o.c,a>q;){r=B.a.X(r,q)+(o.b&B.Y[q])
a-=q
o.c=8
o.b=J.c(s.a,s.d++)}if(a>0){if(q===0){o.c=8
o.b=s.F()}s=B.a.X(r,a)
q=o.b
p=o.c-a
r=s+(B.a.bu(q,p)&B.Y[a])
o.c=p}return r}}
A.hx.prototype={
B(a){var s=this,r=s.a,q=$.mV().k(0,r)
if(q!=null)return q.a+": "+s.b.B(0)+" "+s.c
return"<"+r+">: "+s.b.B(0)+" "+s.c},
bb(){var s,r,q,p,o,n=this,m=n.e
if(m!=null)return m
m=n.f
s=n.d
m.d=s
r=n.c
q=n.b
p=q!==B.d
if(r*(p?B.F[q.a]:0)>m.c-s)throw A.e(A.j("Invalid TIFF tag "+n.a+" count: "+r))
o=m.a7(r*(p?B.F[q.a]:0))
switch(q.a){case 1:return n.e=new A.bg(new Uint8Array(A.t(o.a7(r).U())))
case 2:return n.e=new A.bZ(r===0?"":o.aj(r-1))
case 7:return n.e=new A.bg(new Uint8Array(A.t(o.a7(r).U())))
case 3:return n.e=A.no(o,r)
case 4:return n.e=A.nj(o,r)
case 5:return n.e=A.nk(o,r)
case 11:return n.e=A.np(o,r)
case 12:return n.e=A.ni(o,r)
case 6:return n.e=new A.bA(new Int8Array(A.t(J.lD(B.c.gA(o.U()),0,r))))
case 8:return n.e=A.nn(o,r)
case 9:return n.e=A.nl(o,r)
case 10:return n.e=A.nm(o,r)
case 13:case 0:return null}}}
A.ka.prototype={
kO(a,b,c,d){var s,r,q,p=this
p.r=b
p.x=p.w=0
s=B.a.W(p.a+7,8)
for(r=0,q=0;q<d;++q){p.dz(a,r,c)
r+=s}},
dz(a,b,c){var s,r,q,p,o,n,m,l,k=this
k.d=0
for(s=k.a,r=!0;c<s;){while(r){q=k.bI(10)
p=B.bh[q]
o=B.a.i(p,1)&15
if(o===12){p=B.a7[(q<<2&12|k.aU(2))>>>0]
n=B.a.i(p,1)
c+=B.a.i(p,4)&4095
k.aA(4-(n&7))}else if(o===0)throw A.e(A.j("TIFFFaxDecoder0"))
else if(o===15)throw A.e(A.j("TIFFFaxDecoder1"))
else{c+=B.a.i(p,5)&2047
k.aA(10-o)
if((p&1)===0){k.f[k.d++]=c
r=!1}}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}while(!r){p=B.aY[k.aU(4)]
m=p>>>5&2047
l=!0
if(m===100){p=B.b4[k.bI(9)]
o=B.a.i(p,1)&15
m=B.a.i(p,5)&2047
if(o===12){k.aA(5)
p=B.a7[k.aU(4)]
n=B.a.i(p,1)
m=B.a.i(p,4)&4095
k.b0(a,b,c,m)
c+=m
k.aA(4-(n&7))}else if(o===15)throw A.e(A.j("TIFFFaxDecoder2"))
else{k.b0(a,b,c,m)
c+=m
k.aA(9-o)
if((p&1)===0){k.f[k.d++]=c
r=l}}}else{if(m===200){p=B.aW[k.aU(2)]
m=p>>>5&2047
k.b0(a,b,c,m)
c+=m
k.aA(2-(p>>>1&15))
k.f[k.d++]=c}else{k.b0(a,b,c,m)
c+=m
k.aA(4-(p>>>1&15))
k.f[k.d++]=c}r=l}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}}k.f[k.d++]=c},
kP(a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
a0.r=a2
a0.z=3
a0.x=a0.w=0
s=a0.a
r=B.a.W(s+7,8)
q=A.a3(2,null,!1,t.I)
a0.at=a5&1
a0.as=a5>>>2&1
if(a0.fh()!==1)throw A.e(A.j("TIFFFaxDecoder3"))
a0.dz(a1,0,a3)
for(p=r,o=1;o<a4;++o){if(a0.fh()===0){n=a0.e
a0.e=a0.f
a0.f=n
a0.y=0
m=a3
l=-1
k=!0
j=0
for(;;){m.toString
if(!(m<s))break
a0.f4(l,k,q)
i=q[0]
h=q[1]
g=B.be[a0.aU(7)]&255
f=g>>>3&15
e=g&7
if(f===0){if(!k){h.toString
a0.b0(a1,p,m,h-m)}a0.aA(7-e)
m=h
l=m}else if(f===1){a0.aA(7-e)
d=j+1
c=d+1
if(k){m+=a0.cQ()
a0.f[j]=m
b=a0.cP()
a0.b0(a1,p,m,b)
m+=b
a0.f[d]=m}else{b=a0.cP()
a0.b0(a1,p,m,b)
m+=b
a0.f[j]=m
m+=a0.cQ()
a0.f[d]=m}j=c
l=m}else{if(f<=8){i.toString
a=i+(f-5)
d=j+1
a0.f[j]=a
k=!k
if(k)a0.b0(a1,p,m,a-m)
a0.aA(7-e)}else throw A.e(A.j("TIFFFaxDecoder4"))
m=a
j=d
l=m}}a0.f[j]=m
a0.d=j+1}else a0.dz(a1,p,a3)
p+=r}},
kV(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this
a4.r=a6
a4.z=4
a4.x=a4.w=0
s=a4.a
r=B.a.W(s+7,8)
q=A.a3(2,null,!1,t.I)
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
a4.f4(k,j,q)
h=q[0]
g=q[1]
f=B.be[a4.aU(7)]&255
e=f>>>3&15
d=f&7
if(e===0){if(!j){g.toString
a4.b0(a5,o,l,g-l)}a4.aA(7-d)
l=g
k=l}else if(e===1){a4.aA(7-d)
c=i+1
b=c+1
if(j){l+=a4.cQ()
m[i]=l
a=a4.cP()
a4.b0(a5,o,l,a)
l+=a
m[c]=l}else{a=a4.cP()
a4.b0(a5,o,l,a)
l+=a
m[i]=l
l+=a4.cQ()
m[c]=l}i=b
k=l}else if(e<=8){h.toString
a0=h+(e-5)
c=i+1
m[i]=a0
j=!j
if(j)a4.b0(a5,o,l,a0-l)
a4.aA(7-d)
l=a0
i=c
k=l}else if(e===11){if(a4.aU(3)!==7)throw A.e(A.j("TIFFFaxDecoder5"))
for(a1=0,a2=!1;!a2;j=a3){while(a4.aU(1)!==1)++a1
if(a1>5){a1-=6
if(!j&&a1>0){c=i+1
m[i]=l
i=c}l+=a1
if(a1>0)j=!0
a3=a4.aU(1)===0
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
a4.b0(a5,o,l,1);++l
i=c}}}else throw A.e(A.j("TIFFFaxDecoder5 "+e))}m[i]=l
a4.d=i+1
o+=r}},
cQ(){var s,r,q,p,o,n,m=this
for(s=0,r=!0;r;){q=m.bI(10)
p=B.bh[q]
o=B.a.i(p,1)&15
if(o===12){p=B.a7[(q<<2&12|m.aU(2))>>>0]
n=B.a.i(p,1)
s+=B.a.i(p,4)&4095
m.aA(4-(n&7))}else if(o===0)throw A.e(A.j("TIFFFaxDecoder0"))
else if(o===15)throw A.e(A.j("TIFFFaxDecoder1"))
else{s+=B.a.i(p,5)&2047
m.aA(10-o)
if((p&1)===0)r=!1}}return s},
cP(){var s,r,q,p,o,n,m=this
for(s=0,r=!1;!r;){q=B.aY[m.aU(4)]
p=q>>>5&2047
if(p===100){q=B.b4[m.bI(9)]
o=B.a.i(q,1)&15
n=B.a.i(q,5)
if(o===12){m.aA(5)
q=B.a7[m.aU(4)]
n=B.a.i(q,1)
s+=B.a.i(q,4)&4095
m.aA(4-(n&7))}else if(o===15)throw A.e(A.j("TIFFFaxDecoder2"))
else{s+=n&2047
m.aA(9-o)
if((q&1)===0)r=!0}}else{if(p===200){q=B.aW[m.aU(2)]
s+=q>>>5&2047
m.aA(2-(q>>>1&15))}else{s+=p
m.aA(4-(q>>>1&15))}r=!0}}return s},
fh(){var s,r,q=this,p="TIFFFaxDecoder8",o=q.as
if(o===0){if(q.bI(12)!==1)throw A.e(A.j("TIFFFaxDecoder6"))}else if(o===1){o=q.w
o.toString
s=8-o
if(q.bI(s)!==0)throw A.e(A.j(p))
if(s<4)if(q.bI(8)!==0)throw A.e(A.j(p))
while(r=q.bI(8),r!==1)if(r!==0)throw A.e(A.j(p))}if(q.at===0)return 1
else return q.aU(1)},
f4(a,b,c){var s,r=this,q=r.e,p=r.d,o=r.y,n=o>0?o-1:0
n=b?(n&4294967294)>>>0:(n|1)>>>0
for(s=n;s<p;s+=2){o=q[s]
o.toString
a.toString
if(o>a){r.y=s
c[0]=o
break}}o=s+1
if(o<p)c[1]=q[o]},
b0(a,b,c,d){var s,r,q,p,o,n=8*b+c,m=n+d,l=B.a.i(n,3),k=n&7
if(k>0){s=B.a.X(1,7-k)
r=J.c(a.a,a.d+l)
for(;;){if(!(s>0&&n<m))break
r=(r|s)>>>0
s=s>>>1;++n}a.m(0,l,r)}l=B.a.i(n,3)
for(q=m-7;n<q;l=p){p=l+1
J.W(a.a,a.d+l,255)
n+=8}while(n<m){l=B.a.i(n,3)
q=J.c(a.a,a.d+l)
o=B.a.X(1,7-(n&7))
J.W(a.a,a.d+l,(q|o)>>>0);++n}},
bI(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.r
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
m=B.U[J.c(e.a,s+q)&255]
if(!(q===r)){e=q+1
s=f.r
p=s.a
s=s.d
if(e===r)o=B.U[J.c(p,s+e)&255]
else{o=B.U[J.c(p,s+e)&255]
e=f.r
n=B.U[J.c(e.a,e.d+(q+2))&255]}}}else throw A.e(A.j("TIFFFaxDecoder7"))
e=f.w
e.toString
l=8-e
k=a-l
if(k>8){j=k-8
i=8}else{i=k
j=0}e=f.x
e.toString
e=f.x=e+1
h=B.a.X(m&B.Y[l],k)
g=B.a.Y(o&B.an[i],8-i)
if(j!==0){g=B.a.X(g,j)|B.a.Y(n&B.an[j],8-j)
f.x=e+1
f.w=j}else if(i===8){f.w=0
f.x=e+1}else f.w=i
return(h|g)>>>0},
aU(a){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.r
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
n=B.U[J.c(h.a,s+q)&255]
if(!(q===r)){h=i.r
o=B.U[J.c(h.a,h.d+(q+1))&255]}}else throw A.e(A.j("TIFFFaxDecoder7"))
h=i.w
h.toString
m=8-h
l=a-m
k=m-a
if(k>=0){j=B.a.Y(n&B.Y[m],k)
h+=a
i.w=h
if(h===8){i.w=0
h=i.x
h.toString
i.x=h+1}}else{j=(B.a.X(n&B.Y[m],-k)|B.a.Y(o&B.an[l],8-l))>>>0
h=i.x
h.toString
i.x=h+1
i.w=l}return j},
aA(a){var s,r=this,q=r.w
q.toString
s=q-a
if(s<0){q=r.x
q.toString
r.x=q-1
r.w=8+s}else r.w=s}}
A.hy.prototype={
hO(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=A.r(a0,c,0),a=a0.l()
for(s=d.a,r=0;r<a;++r){q=a0.l()
p=a0.l()
o=a0.j()
if(p>13){a0.d+=4
continue}n=B.bb[p]
if(o*B.F[p]>4)m=a0.j()
else{m=a0.d
a0.d=m+4}l=new A.hx(q,n,o,m,b)
s.m(0,q,l)
if(q===256){k=l.bb()
k=k==null?c:k.h(0)
d.b=k==null?0:k}else if(q===257){k=l.bb()
k=k==null?c:k.h(0)
d.c=k==null?0:k}else if(q===262){j=l.bb()
i=j==null?c:j.h(0)
if(i==null)i=17
if(i<17)d.d=B.fg[i]
else d.d=B.au}else if(q===259){k=l.bb()
k=k==null?c:k.h(0)
d.e=k==null?0:k}else if(q===258){k=l.bb()
k=k==null?c:k.h(0)
d.f=k==null?0:k}else if(q===277){k=l.bb()
k=k==null?c:k.h(0)
d.r=k==null?0:k}else if(q===317){k=l.bb()
k=k==null?c:k.h(0)
d.Q=k==null?0:k}else if(q===339){k=l.bb()
j=k==null?c:k.h(0)
d.x=B.ft[j==null?0:j]}else if(q===320){j=l.bb()
if(j!=null){k=J.pf(B.c.gA(j.bd()))
d.id=k
d.k1=0
k=k.length/3|0
d.k2=k
d.k3=k*2}}}k=d.id
h=k!=null
if(h&&d.d===B.av)d.r=1
if(d.b===0||d.c===0)return
if(h&&d.f===8){g=k.length
for(h=k.$flags|0,r=0;r<g;++r){f=k[r]
h&2&&A.a(k)
k[r]=f>>>8}}if(d.d===B.at)d.z=!0
d.w=d.r
if(s.a5(324)){d.ay=d.c4(322)
d.ch=d.c4(323)
d.CW=d.cY(324)
d.cx=d.cY(325)}else{d.ay=d.cX(322,d.b)
if(!s.a5(278))k=d.ch=d.cX(323,d.c)
else{e=d.c4(278)
if(e===-1){k=d.c
d.ch=k}else{d.ch=e
k=e}}h=d.c
if(k>h)d.ch=h
d.CW=d.cY(273)
d.cx=d.cY(279)}k=d.b
h=d.ay
d.cy=B.a.ab(k+h-1,h)
h=d.c
k=d.ch
d.db=B.a.ab(h+k-1,k)
d.dy=d.cX(266,1)
d.fr=d.c4(292)
d.fx=d.c4(293)
d.c4(338)
switch(d.d.a){case 0:case 1:s=d.f
if(s===1&&d.r===1)d.y=B.as
else if(s===4&&d.r===1)d.y=B.jS
else if(B.a.a2(s,8)===0){s=d.r
if(s===1)d.y=B.jT
else if(s===2)d.y=B.jU
else d.y=B.a0}break
case 2:if(B.a.a2(d.f,8)===0){s=d.r
if(s===3)d.y=B.bJ
else if(s===4)d.y=B.jW
else d.y=B.a0}break
case 3:s=!1
if(d.r===1)if(d.id!=null){s=d.f
s=s===4||s===8||s===16}if(s)d.y=B.jV
break
case 4:if(d.f===1&&d.r===1)d.y=B.as
break
case 6:if(d.e===7&&d.f===8&&d.r===3)d.y=B.bJ
else{if(s.a5(530)){j=s.k(0,530).bb()
d.as=j.h(0)
s=d.at=j.a8(0,1)}else s=d.at=d.as=2
k=d.as
k===$&&A.b()
if(k*s===1)d.y=B.a0
else if(d.f===8&&d.r===3)d.y=B.jX}break
case 5:if(B.a.a2(d.f,8)===0)d.y=B.a0
s=d.r
if(s===4)d.w=3
else if(s===5)d.w=4
break
default:if(B.a.a2(d.f,8)===0)d.y=B.a0
break}},
c7(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.x,a1=a0===B.a_,a2=a0===B.f
a0=b.f
if(a0===1)s=B.u
else if(a0===2)s=B.x
else{if(a0===4)a0=B.y
else if(a1&&a0===16)a0=B.z
else if(a1&&a0===32)a0=B.C
else if(a1&&a0===64)a0=B.K
else if(a2&&a0===8)a0=B.O
else if(a2&&a0===16)a0=B.P
else if(a2&&a0===32)a0=B.Q
else if(a0===16)a0=B.m
else a0=a0===32?B.L:B.e
s=a0}r=b.id!=null&&b.d===B.av
q=r?3:b.w
a0=b.b
p=A.Q(a,a,s,0,B.i,b.c,a,0,q,a,s,a0,r)
if(r){a0=p.a
a0=a0==null?a:a0.gR()
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
a0.b6(f,o[g],o[h],o[i])}}e=0
d=0
for(;;){a0=b.db
a0===$&&A.b()
if(!(e<a0))break
c=0
for(;;){a0=b.cy
a0===$&&A.b()
if(!(c<a0))break
b.iJ(a3,p,c,e);++c;++d}++e}return p},
iJ(b5,b6,b7,b8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3=this,b4=null
if(b3.y===B.as){b3.iu(b5,b6,b7,b8)
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
q=A.nD()
try{q.fT(A.r(b5,s,0),r.a)}catch(j){}if(b3.Q===2)for(i=0;i<b3.ch;++i){h=b3.r
p=b3.ay
g=h*(i*p+1)
f=p*h
for(;h<f;++h){p=r
m=J.c(p.a,p.d+g)
e=r
d=b3.r
d=J.c(e.a,e.d+(g-d))
J.W(p.a,p.d+g,m+d);++g}}}else if(p===32773){r=A.q(new Uint8Array(k),!1,b4,0)
b3.eU(b5,k,r.a)}else if(p===32946||p===8){c=b5.ei(0,0,s)
p=b3.f
b=p<8?1:B.a.i(p+7,3)
r=A.q(A.i9(c,b3.ay*b3.ch*b3.r*b),!1,b4,0)}else if(p===6||p===7){c=b5.ei(0,0,s)
a=A.nx().c7(t.D.a(c))
if(a!=null)b3.je(a,b6,n,l,b3.ay,b3.ch)
return}else throw A.e(A.j("Unsupported Compression Type: "+p))
a0=A.m([0,0,0],t.t)
for(a1=l,a2=0;a2<b3.ch;++a2,++a1)for(a3=n,a4=0;a4<b3.ay;++a4,++a3){p=r
if(p.d>=p.c||a3>=b3.b||a1>=b3.c)break
p=b3.r
if(p===1){p=b3.x
if(p===B.a_){p=b3.f
if(p===32){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
a5=$.bO()[0]}else if(p===64)a5=r.de()
else if(p===16){p=r.l()
m=$.G
a5=(m!=null?m:A.L())[p]}else a5=0
if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aF(a3,a1,a5)}}else{m=b3.f
if(m===8)if(p===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
a5=$.at()[0]}else{p=r
a5=J.c(p.a,p.d++)}else if(m===16)if(p===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
a5=$.as()[0]}else a5=r.l()
else if(m===32)if(p===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
a5=$.a1()[0]}else a5=r.j()
else a5=0
if(b3.d===B.at){p=b6.a
a6=p==null?b4:p.gD()
a5=(a6==null?0:a6)-a5}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aF(a3,a1,a5)}}}else if(p===2){p=b3.f
if(p===8){if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
a7=$.at()[0]}else{p=r
a7=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.at()[0]}else{p=r
a8=J.c(p.a,p.d++)}}else if(p===16){if(b3.x===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
a7=$.as()[0]}else a7=r.l()
if(b3.x===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.as()[0]}else a8=r.l()}else if(p===32){if(b3.x===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
a7=$.a1()[0]}else a7=r.j()
if(b3.x===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.a1()[0]}else a8=r.j()}else{a7=0
a8=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.ak(a3,a1,a7,0,0,a8)}}else if(p===3){p=b3.x
if(p===B.a_){p=b3.f
if(p===32){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
p=$.bO()
a9=p[0]
m[0]=r.j()
b0=p[0]
m[0]=r.j()
b1=p[0]}else{b0=0
b1=0
if(p===64)a9=r.de()
else if(p===16){p=r.l()
m=$.G
a9=(m!=null?m:A.L())[p]
p=r.l()
m=$.G
b0=(m!=null?m:A.L())[p]
p=r.l()
m=$.G
b1=(m!=null?m:A.L())[p]}else a9=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aC(a3,a1,a9,b0,b1)}}else{m=b3.f
if(m===8){if(p===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.at()[0]}else{p=r
a9=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.at()[0]}else{p=r
b0=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.at()[0]}else{p=r
b1=J.c(p.a,p.d++)}}else if(m===16){if(p===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.as()[0]}else a9=r.l()
if(b3.x===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.as()[0]}else b0=r.l()
if(b3.x===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.as()[0]}else b1=r.l()}else if(m===32){if(p===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.a1()[0]}else a9=r.j()
if(b3.x===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.a1()[0]}else b0=r.j()
if(b3.x===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.a1()[0]}else b1=r.j()}else{a9=0
b0=0
b1=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aC(a3,a1,a9,b0,b1)}}}else if(p>=4)if(b3.x===B.a_){p=b3.f
if(p===32){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
p=$.bO()
a9=p[0]
m[0]=r.j()
b0=p[0]
m[0]=r.j()
b1=p[0]
m[0]=r.j()
b2=p[0]}else{b0=0
b1=0
b2=0
if(p===64)a9=r.de()
else if(p===16){p=r.l()
m=$.G
a9=(m!=null?m:A.L())[p]
p=r.l()
m=$.G
b0=(m!=null?m:A.L())[p]
p=r.l()
m=$.G
b1=(m!=null?m:A.L())[p]
p=r.l()
m=$.G
b2=(m!=null?m:A.L())[p]}else a9=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.ak(a3,a1,a9,b0,b1,b2)}}else{p=b6.a
a8=p==null?b4:p.gD()
if(a8==null)a8=0
p=b3.f
if(p===8){if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.at()[0]}else{p=r
a9=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.at()[0]}else{p=r
b0=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.at()[0]}else{p=r
b1=J.c(p.a,p.d++)}if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
b2=$.at()[0]}else{p=r
b2=J.c(p.a,p.d++)}if(b3.r===5)if(b3.x===B.f){p=r
p=J.c(p.a,p.d++)
m=$.ak()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.at()[0]}else{p=r
a8=J.c(p.a,p.d++)}}else if(p===16){if(b3.x===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.as()[0]}else a9=r.l()
if(b3.x===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.as()[0]}else b0=r.l()
if(b3.x===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.as()[0]}else b1=r.l()
if(b3.x===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
b2=$.as()[0]}else b2=r.l()
if(b3.r===5)if(b3.x===B.f){p=r.l()
m=$.aj()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.as()[0]}else a8=r.l()}else if(p===32){if(b3.x===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
a9=$.a1()[0]}else a9=r.j()
if(b3.x===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
b0=$.a1()[0]}else b0=r.j()
if(b3.x===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
b1=$.a1()[0]}else b1=r.j()
if(b3.x===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
b2=$.a1()[0]}else b2=r.j()
if(b3.r===5)if(b3.x===B.f){p=r.j()
m=$.O()
m.$flags&2&&A.a(m)
m[0]=p
a8=$.a1()[0]}else a8=r.j()}else{a9=0
b0=0
b1=0
b2=0}if(b3.d===B.bK){A.ox(a9,b0,b1,b2,a0)
a9=a0[0]
b0=a0[1]
b1=a0[2]
b2=a8}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.ak(a3,a1,a9,b0,b1,b2)}}}}else throw A.e(A.j("Unsupported bitsPerSample: "+p))},
je(a,b,c,d,e,f){var s,r,q,p
for(s=0;s<f;++s)for(r=s+d,q=0;q<e;++q){p=a.a
p=p==null?null:p.L(q,s,null)
if(p==null)p=new A.F()
b.bP(q+c,r,p)}},
iu(a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=null,a4=a2.cy
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
if(m===32773){l=B.a.a2(a4,8)===0?B.a.W(a4,8)*p:(B.a.W(a4,8)+1)*p
s=A.q(new Uint8Array(a4*p),!1,a3,0)
a2.eU(a5,l,s.a)}else if(m===5){s=A.q(new Uint8Array(a4*p),!1,a3,0)
A.nD().fT(A.r(a5,n,0),s.a)
if(a2.Q===2)for(k=0;k<a2.c;++k){j=a2.r
i=j*(k*a2.b+1)
for(;j<a2.b*a2.r;++j){a4=s
p=J.c(a4.a,a4.d+i)
m=s
h=a2.r
h=J.c(m.a,m.d+(i-h))
J.W(a4.a,a4.d+i,p+h);++i}}}else if(m===2){s=A.q(new Uint8Array(a4*p),!1,a3,0)
try{A.mf(a2.dy,a2.ay,a2.ch).kO(s,a5,0,a2.ch)}catch(g){}}else if(m===3){s=A.q(new Uint8Array(a4*p),!1,a3,0)
try{A.mf(a2.dy,a2.ay,a2.ch).kP(s,a5,0,a2.ch,a2.fr)}catch(g){}}else if(m===4){s=A.q(new Uint8Array(a4*p),!1,a3,0)
try{A.mf(a2.dy,a2.ay,a2.ch).kV(s,a5,0,a2.ch,a2.fx)}catch(g){}}else if(m===8||m===32946)s=A.q(A.i9(a5.ei(0,0,n),B.a.i(a2.ay+7,3)*a2.ch),!1,a3,0)
else if(m===1)s=a5
else throw A.e(A.j("Unsupported Compression Type: "+m))
f=new A.k6(s)
e=a6.gD()
a4=a2.z
d=a4?e:0
c=a4?0:e
for(b=o,a=0;a<a2.ch;++a,++b){for(a0=q,a1=0;a1<a2.ay;++a1,++a0){a4=a6.a
p=a4==null
m=p?a3:a4.b
if(b<(m==null?0:m)){a4=p?a3:a4.a
a4=a0>=(a4==null?0:a4)}else a4=!0
if(a4)break
a4=f.ai(1)
p=a6.a
if(a4===0){if(p!=null)p.aC(a0,b,d,0,0)}else if(p!=null)p.aC(a0,b,c,0,0)}f.c=0}},
eU(a,b,c){var s,r,q,p,o,n,m,l,k,j
for(s=J.aC(c),r=0,q=0;q<b;){p=r+1
o=J.c(a.a,a.d+r)
n=$.ak()
n.$flags&2&&A.a(n)
n[0]=o
m=$.at()[0]
if(m>=0&&m<=127)for(o=m+1,r=p,l=0;l<o;++l,q=k,r=p){k=q+1
p=r+1
s.m(c,q,J.c(a.a,a.d+r))}else{o=m<=-1&&m>=-127
r=p+1
if(o){j=J.c(a.a,a.d+p)
for(o=-m+1,l=0;l<o;++l,q=k){k=q+1
s.m(c,q,j)}}}}},
cX(a,b){var s=this.a
if(!s.a5(a))return b
s=s.k(0,a).bb()
s=s==null?null:s.h(0)
return s==null?0:s},
c4(a){return this.cX(a,0)},
cY(a){var s,r=this.a
if(!r.a5(a))return null
s=r.k(0,a)
r=s.bb()
r.toString
return A.nC(s.c,r.gbr(r),t.p)}}
A.co.prototype={
a6(){return"TiffFormat."+this.b}}
A.a4.prototype={
a6(){return"TiffPhotometricType."+this.b}}
A.aS.prototype={
a6(){return"TiffImageType."+this.b}}
A.kb.prototype={}
A.jp.prototype={
fT(a,b){var s,r,q,p,o,n,m=this
m.r=b
s=J.by(b)
m.w=0
r=t.D.a(a.a)
m.e=r
m.f=r.length
m.b=a.d
if(r[0]===0&&r[1]===1)throw A.e(A.j("Invalid LZW Data"))
m.f9()
m.d=m.c=0
q=m.dH()
r=m.x
p=0
for(;;){if(!(q!==257&&m.w<s))break
if(q===256){m.f9()
q=m.dH()
m.as=0
if(q===257)break
J.W(m.r,m.w++,q)
p=q}else{o=m.Q
o.toString
if(q<o){m.f6(q)
o=m.as
o===$&&A.b()
n=o-1
for(;n>=0;--n)J.W(m.r,m.w++,r[n])
m.ey(p,r[m.as-1])}else{m.f6(p)
o=m.as
o===$&&A.b()
n=o-1
for(;n>=0;--n)J.W(m.r,m.w++,r[n])
J.W(m.r,m.w++,r[m.as-1])
m.ey(p,r[m.as-1])}p=q}q=m.dH()}},
ey(a,b){var s,r=this,q=r.y
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
f6(a){var s,r,q,p,o,n,m=this
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
dH(){var s,r,q,p,o=this,n=o.b,m=o.f
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
return B.a.Y(o.c,n)&B.ds[r-9]},
f9(){var s,r,q=this
q.y=new Uint8Array(4096)
s=new Uint32Array(4096)
q.z=s
B.l.ao(s,0,4096,4098)
for(s=q.y,r=0;r<256;++r){s.$flags&2&&A.a(s)
s[r]=r}q.a=9
q.Q=258}}
A.k7.prototype={
ae(a){return A.K(new A.k8(this,a))},
ku(a){var s,r,q=this.a
if(q==null)return null
s=q.f[a]
q=this.d
A.ai(s.b,s.c,q,!1)
A.ai(s.ay,s.ch,q,!1)
q=this.c
q===$&&A.b()
r=s.c7(q)
return r},
aY(a,b){return A.K(new A.k9(this,a,b))},
kt(a,b){var s,r,q,p,o,n,m=this,l=null,k=A.q(a,!1,l,0)
m.c=k
k=m.a=m.jW(k)
if(k==null)return l
k=k.f
s=k.length
r=new A.bl(m.d)
for(q=0;q<k.length;k.length===s||(0,A.a0)(k),++q){p=k[q]
r.bU(0,p.b,p.c)}o=m.ae(0)
if(o==null)return l
o.e=A.lJ(A.q(a,!1,l,0))
o.w=B.aJ
for(n=1;n<s;++n)o.b1(m.ae(n))
return o},
fj(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=null,g=A.m([],t.aU),f=new A.kb(g),e=a.c
if(e-a.d<8)return h
q=a.l()
if(q!==18761&&q!==19789)return h
if(q===19789)a.e=!0
else a.e=!1
p=a.l()
f.d=p
if(p!==42)return h
o=a.j()
n=A.r(a,h,0)
n.d=o
s=n
p=t.p
m=A.nA(p)
l=t.a4
for(;;){if(!(o!==0&&o<e&&g.length<1024&&m.bK(0,o)))break
r=null
try{k=new A.hy(A.D(p,l),B.au,B.bI,B.jY)
k.hO(s)
r=k
j=r
if(!(j.b!==0&&j.c!==0))break}catch(i){break}g.push(r)
if(g.length===1){j=g[0]
f.a=j.b
f.b=j.c}if(b)break
o=s.j()
if(o!==0)s.d=o}return g.length!==0?f:h},
jW(a){return this.fj(a,!1)}}
A.k8.prototype={
$0(){return this.a.ku(this.b)},
$S:1}
A.k9.prototype={
$0(){return this.a.kt(this.b,this.c)},
$S:1}
A.kg.prototype={
cq(){var s,r=this.a,q=r.bc()
if((q&1)!==0)return!1
if((q>>>1&7)>3)return!1
if((q>>>4&1)===0)return!1
this.f.d=q>>>5
if(r.bc()!==2752925)return!1
s=this.b
s.a=r.l()
s.b=r.l()
return!0},
bz(){var s,r,q,p,o=this,n=null
if(!o.j_())return n
s=o.b
r=s.a
o.d=A.Q(n,n,B.e,0,B.i,s.b,n,0,4,n,B.e,r,!1)
o.j9()
if(!o.jr())return n
r=s.w
if(r.length!==0){q=A.q(new A.aN(r),!1,n,0)
r=o.d
r.toString
r.e=A.lJ(q)}p=s.r
if(p!=null)o.d.c=new A.bf("ICC_PROFILE",B.R,p)
return o.d},
j_(){var s,r,q,p,o=this
if(!o.cq())return!1
o.fr=A.r9()
for(s=o.dy,r=0;r<4;++r){q=new Int32Array(2)
p=new Int32Array(2)
s[r]=new A.hI(q,p,new Int32Array(2))}o.y=o.Q=0
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
p=A.nU(s.ar(p))
o.c=p
s.d+=q.d
p.a_(1)
o.c.a_(1)
o.jx(o.x,o.fr)
o.jq()
if(!o.jt(s))return!1
o.jv()
o.c.a_(1)
o.ju()
return!0},
jx(a,b){var s,r,q,p=this,o=p.c
o===$&&A.b()
o=o.a_(1)!==0
a.a=o
if(o){a.b=p.c.a_(1)!==0
if(p.c.a_(1)!==0){a.c=p.c.a_(1)!==0
for(o=a.d,s=0;s<4;++s){if(p.c.a_(1)!==0){r=p.c
q=r.a_(7)
r=r.a_(1)===1?-q:q}else r=0
o.$flags&2&&A.a(o)
o[s]=r}for(o=a.e,s=0;s<4;++s){if(p.c.a_(1)!==0){r=p.c
q=r.a_(6)
r=r.a_(1)===1?-q:q}else r=0
o.$flags&2&&A.a(o)
o[s]=r}}if(a.b)for(s=0;s<3;++s){o=b.a
r=p.c.a_(1)!==0?p.c.a_(8):255
o.$flags&2&&A.a(o)
o[s]=r}}else a.b=!1
return!0},
jq(){var s,r,q,p=this,o=p.w,n=p.c
n===$&&A.b()
o.a=n.a_(1)!==0
o.b=p.c.a_(6)
o.c=p.c.a_(3)
n=p.c.a_(1)!==0
o.d=n
if(n)if(p.c.a_(1)!==0){for(n=o.e,s=0;s<4;++s)if(p.c.a_(1)!==0){r=p.c
q=r.a_(6)
r=r.a_(1)===1?-q:q
n.$flags&2&&A.a(n)
n[s]=r}for(n=o.f,s=0;s<4;++s)if(p.c.a_(1)!==0){r=p.c
q=r.a_(6)
r=r.a_(1)===1?-q:q
n.$flags&2&&A.a(n)
n[s]=r}}if(o.b===0)n=0
else n=o.a?1:2
p.bL=n
return!0},
jt(a){var s,r,q,p,o,n,m,l=a.c-a.d,k=this.c
k===$&&A.b()
k=B.a.N(1,k.a_(2))
this.cy=k
s=k-1
r=s*3
if(l<r)return!1
for(k=this.db,q=0,p=0;p<s;++p,r=n){o=a.cI(3,q)
n=r+((J.c(o.a,o.d)|J.c(o.a,o.d+1)<<8|J.c(o.a,o.d+2)<<16)>>>0)
if(n>l)n=l
m=new A.eH(a.bQ(n-r,r))
m.b=254
m.c=0
m.d=-8
k[p]=m
q+=3}k[s]=A.nU(a.bQ(l-r,a.d-a.b+r))
return r<l},
jv(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=d.c
c===$&&A.b()
s=c.a_(7)
r=d.c.a_(1)!==0?d.c.cd(4):0
q=d.c.a_(1)!==0?d.c.cd(4):0
p=d.c.a_(1)!==0?d.c.cd(4):0
o=d.c.a_(1)!==0?d.c.cd(4):0
n=d.c.a_(1)!==0?d.c.cd(4):0
m=d.x
for(c=d.dy,l=m.a,k=!m.c,j=m.d,i=0;i<4;++i){if(l){h=j[i]
if(k)h+=s}else{if(i>0){c[i]=c[0]
continue}h=s}g=c[i]
f=g.a
e=h+r
if(e<0)e=0
else if(e>127)e=127
e=B.ak[e]
f.$flags&2&&A.a(f)
f[0]=e
if(h<0)e=0
else e=h>127?127:h
f[1]=B.al[e]
e=g.b
f=h+q
if(f<0)f=0
else if(f>127)f=127
f=B.ak[f]
e.$flags&2&&A.a(e)
e[0]=f*2
f=h+p
if(f<0)f=0
else if(f>127)f=127
e[1]=B.al[f]*101581>>>16
if(e[1]<8)e[1]=8
f=g.c
e=h+o
if(e<0)e=0
else if(e>117)e=117
e=B.ak[e]
f.$flags&2&&A.a(f)
f[0]=e
e=h+n
if(e<0)e=0
else if(e>127)e=127
f[1]=B.al[e]}},
ju(){var s,r,q,p,o,n,m=this,l=m.fr
for(s=0;s<4;++s)for(r=0;r<8;++r)for(q=0;q<3;++q)for(p=0;p<11;++p){o=m.c
o===$&&A.b()
n=o.aa(B.ix[s][r][q][p])!==0?m.c.a_(8):B.dq[s][r][q][p]
o=l.b[s][r].a[q]
o.$flags&2&&A.a(o)
o[p]=n}o=m.c
o===$&&A.b()
o=o.a_(1)!==0
m.fx=o
if(o)m.fy=m.c.a_(8)},
jF(){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.bL
f.toString
if(f>0){s=g.w
for(f=s.e,r=s.f,q=g.x,p=q.e,o=0;o<4;++o){if(q.a){n=p[o]
if(!q.c){m=s.b
m.toString
n+=m}}else n=s.b
for(l=0;l<=1;++l){m=g.e5
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
if(m>0){i=m>4?B.a.i(j,2):B.a.i(j,1)
h=9-m
if(i>h)i=h}else i=j
if(i<1)i=1
k.b=i
k.a=2*j+i
if(j>=40)m=2
else m=j>=15?1:0
k.d=m}else k.a=0
k.c=l!==0}}}},
j9(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=null,d=f.b,c=d.at
if(c!=null)f.e6=c
s=J.al(4,t.e6)
for(c=t.ao,r=0;r<4;++r)s[r]=A.m([new A.bI(),new A.bI()],c)
f.e5=s
c=f.at
c.toString
s=J.al(c,t.dE)
for(q=0;q<c;++q){p=new Uint8Array(16)
o=new Uint8Array(8)
s[q]=new A.hJ(p,o,new Uint8Array(8))}f.k2=s
f.ok=new Uint8Array(832)
c=f.at
c.toString
f.go=new Uint8Array(4*c)
p=f.p4=16*c
c=8*c
f.R8=c
o=f.bL
o.toString
n=B.ah[o]
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
d=f.bL
d.toString
j=B.ah[d]
if(d===2)f.ch=f.ay=0
else{d=B.a.W(f.y-j,16)
f.ay=d
c=B.a.W(f.Q-j,16)
f.ch=c
if(d<0)f.ay=0
if(c<0)f.ch=0}d=B.a.W(f.as+15+j,16)
f.cx=d
c=B.a.W(f.z+15+j,16)
f.CW=c
p=f.at
p.toString
if(c>p)f.CW=p
c=f.ax
c.toString
if(d>c)f.cx=c
i=p+1
s=J.al(i,t.ai)
for(q=0;q<i;++q)s[q]=new A.hG()
f.k3=s
d=f.at
d.toString
s=J.al(d,t.cP)
for(q=0;q<d;++q){c=new Int16Array(384)
s[q]=new A.hH(c,new Uint8Array(16))}f.cr=s
d=f.at
d.toString
s=J.al(d,t.fD)
for(q=0;q<d;++q)s[q]=new A.bI()
f.k4=s
f.jF()
d=$.mN()
c=$.mO()
p=$.mP()
o=$.mQ()
h=$.lB()
g=new Int32Array(16)
A.qA()
f.e=new A.kh(d,c,p,o,h,g)
return!0},
jr(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this
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
o=f.cr
o===$&&A.b()
k=o[p]
if(r.b){p=f.c
p===$&&A.b()
p=p.aa(f.fr.a[0])
o=f.c
j=f.fr
f.k1=p===0?o.aa(j.a[1]):2+o.aa(j.a[2])}p=f.fx
p===$&&A.b()
if(p){p=f.c
p===$&&A.b()
o=f.fy
o===$&&A.b()
i=p.aa(o)!==0}else i=!1
f.js()
if(!i)i=f.jw(l,n)
else{m.a=l.a=0
p=k.b
p===$&&A.b()
if(!p)m.b=l.b=0
k.f=k.e=0}p=f.bL
p.toString
if(p>0){p=f.e5
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
B.c.ao(s,0,4,0)
f.y1=0
f.kf()
p=f.bL
p.toString
g=!1
if(p>0){p=f.y2
o=f.ch
o===$&&A.b()
if(p>=o){o=f.cx
o.toString
o=p<=o
g=o}}if(!f.iY(g))return!1
p=++f.y2}return!0},
kf(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=this,b0=null,b1=a9.y2,b2=a9.ok
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
h=a9.cr
h===$&&A.b()
g=h[i]
if(i>0){for(f=-1;f<16;++f){h=40+f*32
A.ao(b2,h-4,b2,h+12,4)}for(f=-1;f<8;++f){h=f*32
e=584+h
A.ao(b2,e-4,b2,e+4,4)
h=600+h
A.ao(b2,h-4,b2,h+4,4)}}else{for(f=0;f<16;++f){j&2&&A.a(b2)
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
if(k){A.ao(b2,8,d.a,0,16)
A.ao(b2,552,d.b,0,8)
A.ao(b2,568,d.c,0,8)}else if(i===0){B.c.ao(b2,7,28,127)
B.c.ao(b2,551,560,127)
B.c.ao(b2,567,576,127)}h=g.b
h===$&&A.b()
if(h){if(k){h=a9.at
h.toString
if(i>=h-1)B.c.ao(b2,24,28,d.a[15])
else A.ao(b2,24,a9.k2[i+1].a,0,4)}A.ao(b2,152,b2,24,4)
A.ao(b2,280,b2,24,4)
A.ao(b2,408,b2,24,4)
for(h=g.c,a=0;a<16;++a,b=b<<2>>>0){a0=A.r(s,b0,B.bq[a])
B.hf[h[a]].$1(a0)
b.toString
e=a*16
a9.eX(b,new A.a8(c,e,Math.min(384,384),e,!1),a0)}}else{h=A.nW(i,b1,g.c[0])
h.toString
B.j5[h].$1(s)
if(b!==0)for(a=0;a<16;++a,b=b<<2>>>0){a0=A.r(s,b0,B.bq[a])
b.toString
h=a*16
a9.eX(b,new A.a8(c,h,Math.min(384,384),h,!1),a0)}}h=g.f
h===$&&A.b()
e=A.nW(i,b1,g.d)
e.toString
B.b6[e].$1(r)
B.b6[e].$1(q)
e=Math.min(384,384)
a1=new A.a8(c,256,e,256,!1)
if((h&255)!==0){a2=a9.e
if((h&170)!==0){a2===$&&A.b()
a2.bs(a1,r)
a2.bs(A.r(a1,b0,16),A.r(r,b0,4))
a3=A.r(a1,b0,32)
a4=A.r(r,b0,128)
a2.bs(a3,a4)
a2.bs(A.r(a3,b0,16),A.r(a4,b0,4))}else{a2===$&&A.b()
a2.hd(a1,r)}}a5=new A.a8(c,320,e,320,!1)
h=h>>>8
if((h&255)!==0){e=a9.e
if((h&170)!==0){e===$&&A.b()
e.bs(a5,q)
e.bs(A.r(a5,b0,16),A.r(q,b0,4))
h=A.r(a5,b0,32)
a2=A.r(q,b0,128)
e.bs(h,a2)
e.bs(A.r(h,b0,16),A.r(a2,b0,4))}else{e===$&&A.b()
e.hd(a5,q)}}h=a9.ax
h.toString
if(b1<h-1){A.ao(d.a,0,b2,520,16)
A.ao(d.b,0,b2,808,8)
A.ao(d.c,0,b2,824,8)}a6=a9.p1.d+i*16
h=i*8
a7=a9.p2.d+h
a8=a9.p3.d+h
for(f=0;f<16;++f)A.ao(n,a6+f*p,b2,40+f*32,16)
for(f=0;f<8;++f){h=f*o
e=f*32
A.ao(m,a7+h,b2,584+e,8)
A.ao(l,a8+h,b2,600+e,8)}++i}},
eX(a,b,c){var s,r,q,p,o,n
switch(a>>>30){case 3:s=this.e
s===$&&A.b()
s.lv(b,c,!1)
break
case 2:this.e===$&&A.b()
r=J.c(b.a,b.d)+4
q=A.kj(J.c(b.a,b.d+4),35468)
p=A.kj(J.c(b.a,b.d+4),85627)
o=A.kj(J.c(b.a,b.d+1),35468)
n=A.kj(J.c(b.a,b.d+1),85627)
A.kl(c,0,r+p,n,o)
A.kl(c,1,r+q,n,o)
A.kl(c,2,r-q,n,o)
A.kl(c,3,r-p,n,o)
break
case 1:s=this.e
s===$&&A.b()
s.cA(b,c)
break
default:break}},
iO(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=e.p4
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
if(e.bL===1){if(a>0){s=e.e
s===$&&A.b()
s.eo(p,o,d,n+4)}if(r.c){s=e.e
s===$&&A.b()
s.hp(p,o,d,n)}if(b>0){s=e.e
s===$&&A.b()
s.ep(p,o,d,n+4)}if(r.c){s=e.e
s===$&&A.b()
s.hq(p,o,d,n)}}else{m=r.b
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
q.c1(p,o,1,d,16,l,m,f)
q.c1(k,i,1,s,8,l,m,f)
q.c1(h,g,1,s,8,l,m,f)}if(r.c){q=e.e
q===$&&A.b()
q.l1(p,o,d,n,m,f)
q.c0(k,i+4,1,s,8,n,m,f)
q.c0(h,g+4,1,s,8,n,m,f)}if(b>0){q=e.e
q===$&&A.b()
l=n+4
q.c1(p,o,d,1,16,l,m,f)
q.c1(k,i,s,1,8,l,m,f)
q.c1(h,g,s,1,8,l,m,f)}if(r.c){q=e.e
q===$&&A.b()
q.lx(p,o,d,n,m,f)
d=4*s
q.c0(k,i+d,s,1,8,n,m,f)
q.c0(h,g+d,s,1,8,n,m,f)}}},
iX(){var s,r=this,q=r.ay
q===$&&A.b()
s=q
for(;;){q=r.CW
q.toString
if(!(s<q))break
r.iO(s,r.y2);++s}},
iY(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=a.bL
a1.toString
s=B.ah[a1]
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
if(a2)a.iX()
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
if(a.e6!=null&&j<i){g=a.xr=a.iK(j,i-j)
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
d*=B.a.i(e,1)
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
a.jL(j-f,a.z-b,i-j)}if(a1){a1=a.p1
g=a.p4
g.toString
a1.c9(p,r,o,16*g)
g=a.p2
p=a.R8
p.toString
g.c9(n,q,m,8*p)
p=a.p3
g=a.R8
g.toString
p.c9(n,q,l,8*g)}return!0},
jL(a,b,c){if(b<=0||c<=0)return!1
this.iQ(a,b,c)
this.iP(a,b,c)
return!0},
du(a){var s
if((a&-4194304)>>>0===0)s=B.a.i(a,14)
else s=a<0?0:255
return s},
bJ(a,b,c,d,e){var s=19077*a,r=this.du(s+26149*c+-3644112)
d.$flags&2&&A.a(d)
d[e]=r
d[e+1]=this.du(s-6419*b-13320*c+2229552)
d[e+2]=this.du(s+33050*b+-4527440)
d[e+3]=255},
d1(b6,b7,b8,b9,c0,c1,c2,c3,c4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=t.D,a1=a0.a(b6.a),a2=b6.d,a3=a0.a(b8.a),a4=b8.d,a5=a0.a(b9.a),a6=b9.d,a7=a0.a(c0.a),a8=c0.d,a9=a0.a(c1.a),b0=c1.d,b1=a0.a(c2.a),b2=c2.d,b3=b7==null,b4=b3?a:a0.a(b7.a),b5=b3?a:b7.d
if(b5==null)b5=0
b3=c3==null
s=b3?a:a0.a(c3.a)
r=b3?a:c3.d
if(r==null)r=0
a0=c4-1
q=B.a.i(a0,1)
p=(a3[a4]|a5[a6]<<16)>>>0
o=(a7[a8]|a9[b0]<<16)>>>0
n=3*p+o+131074>>>2
b.bJ(a1[a2],n&255,n>>>16,b1,b2)
b3=b4!=null
if(b3){n=3*o+p+131074>>>2
m=b4[b5]
s.toString
b.bJ(m,n&255,n>>>16,s,r)}for(l=1;l<=q;++l,o=j,p=k){k=(a3[a4+l]|a5[a6+l]<<16)>>>0
j=(a7[a8+l]|a9[b0+l]<<16)>>>0
i=p+k+o+j+524296
h=i+2*(k+o)>>>3
g=i+2*(p+j)>>>3
n=h+p>>>1
f=g+k>>>1
m=2*l
e=a2+m
d=(m-1)*4
b.bJ(a1[e-1],n&255,n>>>16,b1,b2+d)
c=m*4
b.bJ(a1[e],f&255,f>>>16,b1,b2+c)
if(b3){n=g+o>>>1
f=h+j>>>1
m=b5+m
e=b4[m-1]
s.toString
b.bJ(e,n&255,n>>>16,s,r+d)
b.bJ(b4[m],f&255,f>>>16,s,r+c)}}if((c4&1)===0){n=3*p+o+131074>>>2
a0*=4
b.bJ(a1[a2+c4-1],n&255,n>>>16,b1,b2+a0)
if(b3){n=3*o+p+131074>>>2
b3=b4[b5+c4-1]
s.toString
b.bJ(b3,n&255,n>>>16,s,r+a0)}}},
iP(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=h.xr
if(g==null)return
s=t.D.a(g.a)
r=g.d
if(a===0){q=c-1
p=a}else{p=a-1
r-=h.b.a
q=c}g=h.Q
o=h.as
if(g+a+c===o)q=o-g-p
n=h.d.U()
m=h.d.gZ()*4
for(g=h.b.a,o=n.$flags|0,l=0;l<q;++l){k=(l+p)*m+3
for(j=0;j<b;++j,k+=4){i=s[r+j]
o&2&&A.a(n)
n[k]=i}r+=g}},
iQ(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=g.b,d=A.q(J.a2(g.d.gA(0),0,null),!1,f,a*e.a*4),c=g.to
c===$&&A.b()
s=A.r(c,f,0)
c=g.x1
c===$&&A.b()
r=A.r(c,f,0)
c=g.x2
c===$&&A.b()
q=A.r(c,f,0)
p=a+a0
o=B.a.i(b+1,1)
n=e.a*4
e=g.rx
e===$&&A.b()
m=A.r(e,f,0)
e=g.ry
e===$&&A.b()
l=A.r(e,f,0)
if(a===0){g.d1(s,f,r,q,r,q,d,f,b)
k=a0}else{e=g.RG
e===$&&A.b()
g.d1(e,s,m,l,r,q,A.r(d,f,-n),d,b)
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
g.d1(A.r(s,f,-i),s,m,l,r,q,A.r(d,f,c),d,b)}e=s.d
c=g.p4
c.toString
s.d=e+c
if(g.Q+p<g.as){e=g.RG
e===$&&A.b()
e.d9(0,b,s)
g.rx.d9(0,o,r)
g.ry.d9(0,o,q);--k}else if((p&1)===0)g.d1(s,f,r,q,r,q,A.r(d,f,n),f,b)
return k},
iK(a,b){var s,r,q,p,o,n,m,l,k,j=this,i=j.b,h=i.a,g=i.b
if(a<0||b<=0||a+b>g)return null
if(a===0){i=h*g
j.e7=new Uint8Array(i)
s=j.e6
r=new A.ku(s,h,g)
q=s.F()
p=r.d=q&3
r.e=B.a.i(q,2)&3
r.f=B.a.i(q,4)&3
r.r=B.a.i(q,6)&3
if(r.gfZ())if(p===0){if(s.c-s.d<i)r.r=1}else if(p===1){o=new A.dm(B.a1,A.m([],t.J))
o.a=h
o.b=g
i=A.m([],t.Z)
p=A.m([],t.d)
n=new Uint32Array(2)
m=new A.hE(s,n)
n=m.e=J.a2(B.l.gA(n),0,null)
l=s.F()
n.$flags&2&&A.a(n)
n[0]=l
l=s.F()
n.$flags&2&&A.a(n)
n[1]=l
l=s.F()
n.$flags&2&&A.a(n)
n[2]=l
l=s.F()
n.$flags&2&&A.a(n)
n[3]=l
l=s.F()
n.$flags&2&&A.a(n)
n[4]=l
l=s.F()
n.$flags&2&&A.a(n)
n[5]=l
l=s.F()
n.$flags&2&&A.a(n)
n[6]=l
s=s.F()
n.$flags&2&&A.a(n)
n[7]=s
m.b=!1
p=new A.fS(m,o,i,p)
p.dy=h
p.fr=g
r.x=p
p.cg(h,g,!0)
i=r.x
s=i.ch
if(s.length===1&&s[0].a===B.bN&&i.jd()){r.y=!0
i=r.x
s=i.c
k=s.a*s.b
i.db=0
s=B.a.a2(k,4)
s=new Uint8Array(k+(4-s))
i.cy=s
i.cx=J.au(B.c.gA(s),0,null)}else{r.y=!1
r.x.ez(h)}}else r.r=1
j.fU=r}i=j.fU
if(i!=null)if(!i.w){s=j.e7
s===$&&A.b()
if(!i.kN(a,b,s))return null}i=j.e7
i===$&&A.b()
return A.q(i,!1,null,a*h)},
jw(a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4=a3.fr.b,a5=a3.k1
a5===$&&A.b()
s=a3.dy[a5]
a5=a3.cr
a5===$&&A.b()
r=a5[a3.y1]
q=A.q(r.a,!1,null,0)
a5=a3.k3
a5===$&&A.b()
p=a5[0]
q.ld(0,q.c-q.d,0)
a5=r.b
a5===$&&A.b()
if(!a5){o=A.q(new Int16Array(16),!1,null,0)
a5=a6.b
n=p.b
m=a3.dG(a7,a4[1],a5+n,s.b,0,o)
a6.b=p.b=m>0?1:0
if(m>1)a3.kv(o,q)
else{l=B.a.i(J.c(o.a,o.d)+3,3)
for(k=0;k<256;k+=16)J.W(q.a,q.d+k,l)}j=a4[0]
i=1}else{j=a4[3]
i=0}h=a6.a&15
g=p.a&15
for(f=0,e=0;e<4;++e){d=g&1
for(c=0,b=0;b<4;++b){m=a3.dG(a7,j,d+(h&1),s.a,i,q)
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
h=B.a.a3(a6.a,a5)
g=B.a.a3(p.a,a5)
for(c=0,e=0;e<2;++e){d=g&1
for(b=0;b<2;++b){m=a3.dG(a7,a4[2],d+(h&1),s.c,0,q)
d=m>0?1:0
h=h>>>1|d<<3
a5=J.c(q.a,q.d)!==0?1:0
if(m>3)a5=3
else if(m>1)a5=2
c=(c<<2|a5)>>>0
q.d+=16}h=h>>>2
g=g>>>1|d<<5}a1=(a1|B.a.N(c,4*a2))>>>0
a0=(a0|B.a.N(h<<4>>>0,a2))>>>0
a=(a|B.a.N(g&240,a2))>>>0}a6.a=a0
p.a=a
r.e=f
r.f=a1
if((a1&43690)===0)s.toString
return(f|a1)>>>0===0},
kv(a,b){var s,r,q,p,o,n,m,l,k,j,i=new Int32Array(16)
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
p=B.a.i(q+n,3)
J.W(b.a,b.d+k,p)
p=B.a.i(l+m,3)
J.W(b.a,b.d+(k+16),p)
p=B.a.i(q-n,3)
J.W(b.a,b.d+(k+32),p)
p=B.a.i(l-m,3)
J.W(b.a,b.d+(k+48),p)
k+=64}},
j0(a,b){var s,r,q,p,o,n
if(a.aa(b[3])===0)s=a.aa(b[4])===0?2:3+a.aa(b[5])
else if(a.aa(b[6])===0)s=a.aa(b[7])===0?5+a.aa(159):7+2*a.aa(165)+a.aa(145)
else{r=a.aa(b[8])
q=2*r+a.aa(b[9+r])
p=B.e_[q]
o=p.length
for(s=0,n=0;n<o;++n)s+=s+a.aa(p[n])
s+=3+B.a.N(8,q)}return s},
dG(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k=b[e].a[c]
for(;e<16;e=s){if(a.aa(k[0])===0)return e
while(a.aa(k[1])===0){++e
k=b[B.bi[e]].a[0]
if(e===16)return 16}s=e+1
r=b[B.bi[s]].a
if(a.aa(k[2])===0){k=r[1]
q=1}else{q=this.j0(a,k)
k=r[2]}p=B.fK[e]
o=a.b
o===$&&A.b()
n=a.eB(B.a.i(o,1))
o=a.b
m=B.bg[o]
a.b=B.bf[o]
o=a.d
o===$&&A.b()
a.d=o-m
o=n!==0?-q:q
l=d[e>0?1:0]
J.W(f.a,f.d+p,o*l)}return 16},
js(){var s,r,q,p,o,n,m,l,k,j=this,i=j.y1,h=4*i,g=j.go,f=j.id,e=j.cr
e===$&&A.b()
s=e[i]
i=j.c
i===$&&A.b()
i=i.aa(145)===0
s.b=i
if(!i){if(j.c.aa(156)!==0)r=j.c.aa(128)!==0?1:3
else r=j.c.aa(163)!==0?2:0
i=s.c
i.$flags&2&&A.a(i)
i[0]=r
g.toString
B.c.ao(g,h,h+4,r)
B.c.ao(f,0,4,r)}else{q=s.c
for(i=f.$flags|0,p=0,o=0;o<4;++o,p=k){r=f[o]
for(n=0;n<4;++n){e=h+n
m=B.fR[g[e]][r]
l=B.ba[j.c.aa(m[0])]
while(l>0)l=B.ba[2*l+j.c.aa(m[l])]
r=-l
g.$flags&2&&A.a(g)
g[e]=r}k=p+4
g.toString
B.c.a1(q,p,k,g,h)
i&2&&A.a(f)
f[o]=r}}if(j.c.aa(142)===0)i=0
else if(j.c.aa(114)===0)i=2
else i=j.c.aa(183)!==0?1:3
s.d=i}}
A.eH.prototype={
a_(a){var s,r
for(s=0;r=a-1,a>0;a=r)s=(s|B.a.X(this.aa(128),r))>>>0
return s},
cd(a){var s=this.a_(a)
return this.a_(1)===1?-s:s},
aa(a){var s,r=this,q=r.b
q===$&&A.b()
s=r.eB(B.a.i(q*a,8))
if(r.b<=126)r.kl()
return s},
eB(a){var s,r,q,p,o,n=this,m=n.d
m===$&&A.b()
if(m<0){s=n.a
r=s.c
q=s.d
if(r-q>=1){p=s.F()
m=n.c
m===$&&A.b()
n.c=(p|m<<8)>>>0
m=n.d+8
n.d=m
o=m}else{if(q<r){m=s.F()
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
if(B.a.bu(m,o)>a){s=n.b
s===$&&A.b()
r=a+1
n.b=s-r
n.c=m-B.a.X(r,o)
return 1}else{n.b=a
return 0}},
kl(){var s,r=this,q=r.b
q===$&&A.b()
s=B.bg[q]
r.b=B.bf[q]
q=r.d
q===$&&A.b()
r.d=q-s}}
A.kh.prototype={
ep(a,b,c,d){var s,r
for(s=0;s<16;++s){r=b+s
if(this.fc(a,r,c,d))this.cR(a,r,c)}},
eo(a,b,c,d){var s,r
for(s=0;s<16;++s){r=b+s*c
if(this.fc(a,r,1,d))this.cR(a,r,1)}},
hq(a,b,c,d){var s
for(s=1;s<=3;++s)this.ep(a,b+4*s*c,c,d)},
hp(a,b,c,d){var s
for(s=1;s<=3;++s)this.eo(a,b+4*s,c,d)},
lx(a,b,c,d,e,f){var s
for(s=1;s<=3;++s)this.c0(a,b+4*s*c,c,1,16,d,e,f)},
l1(a,b,c,d,e,f){var s
for(s=1;s<=3;++s)this.c0(a,b+4*s,1,c,16,d,e,f)},
c1(a4,a5,a6,a7,a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this
for(s=3*a6,r=2*a6,q=a3.c,p=a3.e,o=a4.$flags|0,n=0;n<a8;++n,a5+=a7)if(a3.fd(a4,a5,a6,a9,b0))if(a3.f8(a4,a5,a6,b1))a3.cR(a4,a5,a6)
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
a=B.a.i(27*b+63+3456,7)-27
a0=B.a.i(18*b+63+2304,7)-18
a1=B.a.i(9*b+63+1152,7)-9
a2=p[255+l+a1]
o&2&&A.a(a4)
a4[m]=a2
a4[k]=p[255+j+a0]
a4[i]=p[255+h+a]
a4[a5]=p[255+g-a]
a4[f]=p[255+e-a0]
a4[d]=p[255+c-a1]}},
c0(a,a0,a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
for(s=2*a1,r=b.d,q=b.e,p=a.$flags|0,o=0;o<a3;++o,a0+=a2)if(b.fd(a,a0,a1,a4,a5))if(b.f8(a,a0,a1,a6))b.cR(a,a0,a1)
else{n=a0-s
m=a[n]
l=a0-a1
k=a[l]
j=a[a0]
i=a0+a1
h=a[i]
g=3*(j-k)
f=r[B.a.i(g+4+1024,3)-128+112]
e=r[B.a.i(g+3+1024,3)-128+112]
d=B.a.i(f+1+16,1)-8
c=q[255+m+d]
p&2&&A.a(a)
a[n]=c
a[l]=q[255+k+e]
a[a0]=q[255+j-f]
a[i]=q[255+h-d]}},
cR(a,b,c){var s=a[b-2*c],r=b-c,q=a[r],p=a[b],o=3*(p-q)+this.c[1020+s-a[b+c]],n=this.d,m=n[B.a.i(o+4+1024,3)-128+112],l=this.e
n=l[255+q+n[B.a.i(o+3+1024,3)-128+112]]
a.$flags&2&&A.a(a)
a[r]=n
a[b]=l[255+p-m]},
f8(a,b,c,d){var s=a[b-2*c],r=a[b-c],q=a[b],p=a[b+c],o=this.a
return o[255+s-r]>d||o[255+p-q]>d},
fc(a,b,c,d){var s=a[b-2*c],r=a[b-c],q=a[b],p=a[b+c]
return 2*this.a[255+r-q]+this.b[255+s-p]<=d},
fd(a,b,c,d,e){var s=a[b-4*c],r=3*c,q=a[b-r],p=2*c,o=a[b-p],n=a[b-c],m=a[b],l=a[b+c],k=a[b+p],j=a[b+r]
r=this.a
p=255+o
if(2*r[255+n-m]+this.b[p-l]>d)return!1
return r[255+s-q]<=e&&r[255+q-o]<=e&&r[p-n]<=e&&r[255+j-k]<=e&&r[255+k-l]<=e&&r[255+l-m]<=e},
bs(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=t.W.a(a.a),e=t.D.a(b.a),d=this.f,c=a.d
for(s=d.$flags|0,r=0,q=0;q<4;++q){p=f[c]
o=f[c+8]
n=p+o
m=p-o
o=f[c+4]
p=B.a.i(o*35468+1073741824,16)
l=f[c+12]
k=p-16384-(B.a.i(l*85627+1073741824,16)-16384)
j=B.a.i(o*85627+1073741824,16)-16384+(B.a.i(l*35468+1073741824,16)-16384)
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
o=B.a.i(p*35468+1073741824,16)
l=d[r+12]
k=o-16384-(B.a.i(l*85627+1073741824,16)-16384)
j=B.a.i(p*85627+1073741824,16)-16384+(B.a.i(l*35468+1073741824,16)-16384)
l=e[h]+(B.a.i(n+j+65536,3)-8192)
if((l&-256)>>>0===0)p=l
else p=l<0?0:255
s&2&&A.a(e)
e[h]=p
p=h+1
o=e[p]+(B.a.i(m+k+65536,3)-8192)
if(!((o&-256)>>>0===0))o=o<0?0:255
e[p]=o
o=h+2
p=e[o]+(B.a.i(m-k+65536,3)-8192)
if(!((p&-256)>>>0===0))p=p<0?0:255
e[o]=p
p=h+3
o=e[p]+(B.a.i(n-j+65536,3)-8192)
if(!((o&-256)>>>0===0))o=o<0?0:255
e[p]=o;++r
h+=32}},
lv(a,b,c){this.bs(a,b)
if(c)this.bs(A.r(a,null,16),A.r(b,null,4))},
cA(a,b){var s,r,q,p,o,n
for(s=J.c(a.a,a.d)+4+65536,r=0;r<4;++r)for(q=r*32,p=0;p<4;++p){o=p+q
n=J.c(b.a,b.d+o)+(B.a.i(s,3)-8192)
if(!((n&-256)>>>0===0))n=n<0?0:255
J.W(b.a,b.d+o,n)}},
hd(a,b){var s=this,r=null
if(J.c(a.a,a.d)!==0)s.cA(a,b)
if(J.c(a.a,a.d+16)!==0)s.cA(A.r(a,r,16),A.r(b,r,4))
if(J.c(a.a,a.d+32)!==0)s.cA(A.r(a,r,32),A.r(b,r,128))
if(J.c(a.a,a.d+48)!==0)s.cA(A.r(a,r,48),A.r(b,r,132))}}
A.ko.prototype={}
A.kr.prototype={}
A.kt.prototype={}
A.eG.prototype={}
A.ks.prototype={}
A.ki.prototype={}
A.bI.prototype={}
A.hG.prototype={}
A.hI.prototype={}
A.hH.prototype={}
A.hJ.prototype={}
A.eI.prototype={
cq(){var s,r,q,p,o=this,n=o.b
if(n.ai(8)!==47)return!1
s=n.ai(14)+1
r=n.ai(14)+1
q=n.ai(1)
o.dy=s
o.fr=r
p=o.c
p.f=B.ab
p.a=s
p.b=r
p.d=q!==0
if(n.ai(3)!==0)return!1
return!0},
bz(){var s,r,q,p,o,n,m=this,l=null
m.f=0
if(!m.cq())return l
m.cg(m.dy,m.fr,!0)
m.ez(m.dy)
s=m.dy
m.d=A.Q(l,l,B.e,0,B.i,m.fr,l,0,4,l,B.e,s,!1)
s=m.cx
s.toString
r=m.c
q=r.a
p=r.b
if(!m.dw(s,q,p,p,m.gjH()))return l
s=r.w
if(s.length!==0){o=A.q(new A.aN(s),!1,l,0)
s=m.d
s.toString
s.e=A.lJ(o)}n=r.r
if(n!=null)m.d.c=new A.bf("ICC_PROFILE",B.R,n)
return m.d},
ez(a){var s,r=this,q=r.c
q=q.a*q.b+a
s=new Uint32Array(q+a*16)
r.cx=s
r.cy=J.a2(B.l.gA(s),0,null)
r.db=q
return!0},
ke(a){var s,r,q,p=this,o=p.b,n=o.ai(2),m=p.CW,l=B.a.N(1,n)
if((m&l)>>>0!==0)return!1
p.CW=(m|l)>>>0
s=new A.hF(B.bM)
p.ch.push(s)
m=B.iT[n]
s.a=m
s.b=a[0]
s.c=a[1]
switch(m.a){case 0:case 1:o=o.ai(3)+2
s.e=o
s.d=p.cg(A.bJ(s.b,o),A.bJ(s.c,s.e),!1)
break
case 3:r=o.ai(8)+1
if(r>16)q=0
else if(r>4)q=1
else{o=r>2?2:3
q=o}a[0]=A.bJ(s.b,q)
s.e=q
s.d=p.cg(r,1,!1)
p.iS(r,s)
break
case 2:break}return!0},
cg(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(c)for(s=k.b,r=t.t,q=b,p=a;s.ai(1)!==0;){o=A.m([p,q],r)
if(!k.ke(o))throw A.e(A.j("Invalid Transform"))
p=o[0]
q=o[1]}else{q=b
p=a}s=k.b
if(s.ai(1)!==0){n=s.ai(4)
if(!(n>=1&&n<=11))throw A.e(A.j("Invalid Color Cache"))}else n=0
if(!k.jY(p,q,n,c))throw A.e(A.j("Invalid Huffman Codes"))
if(n>0){s=B.a.N(1,n)
k.w=s
k.x=new A.kp(new Uint32Array(s),32-n)}else k.w=0
s=k.c
s.a=p
s.b=q
m=k.z
k.Q=A.bJ(p,m)
k.y=m===0?4294967295:B.a.N(1,m)-1
if(c){k.f=0
return null}l=new Uint32Array(p*q)
if(!k.dw(l,p,q,q,null))throw A.e(A.j("Failed to decode image data."))
k.f=0
return l},
dw(b2,b3,b4,b5,b6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=506832829,a7=a5.f,a8=B.a.ab(a7,b3),a9=B.a.a2(a7,b3),b0=b3*b4,b1=b3*b5
if(a7>=b1){if(b6!=null)b6.$2(b5,!1)
return!0}s=a5.f1(a9,a8)
r=a5.w
q=280+r
p=r>0?a5.x:null
o=a5.y
for(r=b2.$flags|0,n=a5.b,m=b6!=null,l=a7;l<b1;){if((a9&o)>>>0===0){k=a5.ck(a5.as,a5.Q,a5.z,a9,a8)
s=a5.ax[k]}j=0
if(s.d){i=s.c
r&2&&A.a(b2)
b2[l]=i;++l;++a9
if(a9>=b3){++a8
if(m&&a8<=b5)b6.$2(a8,!0)
if(p!=null)for(i=p.a,h=p.b,g=i.$flags|0;a7<l;){f=b2[a7]
e=B.a.Y(A.f8(f,a6),h)
g&2&&A.a(i)
i[e]=f;++a7}a9=j}continue}if(n.a>=32)n.bT()
if(s.e){d=s.f[n.cw()&63]
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
e=B.a.Y(A.f8(f,a6),h)
g&2&&A.a(i)
i[e]=f;++a7}a9=j}continue}}else c=s.bV(0,n)
if(c<256){if(s.b){i=s.c
r&2&&A.a(b2)
b2[l]=(i|c<<8)>>>0}else{b=s.bV(1,n)
if(n.a>=32)n.bT()
a=A.oN(s.bV(2,n),c,b,s.bV(3,n))
r&2&&A.a(b2)
b2[l]=a}++l;++a9
if(a9>=b3){++a8
if(m&&a8<=b5)b6.$2(a8,!0)
if(p!=null)for(i=p.a,h=p.b,g=i.$flags|0;a7<l;){f=b2[a7]
e=B.a.Y(A.f8(f,a6),h)
g&2&&A.a(i)
i[e]=f;++a7}a9=j}}else if(c<280){a0=a5.cV(c-256)
a1=s.bV(4,n)
if(n.a>=32)n.bT()
a2=a5.ff(b3,a5.cV(a1))
if(l<a2||b0-l<a0)return!1
else{a3=l-a2
for(a4=0;a4<a0;++a4){i=b2[a3+a4]
r&2&&A.a(b2)
b2[l+a4]=i}}l+=a0
a9+=a0
while(a9>=b3){a9-=b3;++a8
if(m&&a8<=b5)b6.$2(a8,!0)}if((a9&o)>>>0!==0){k=a5.ck(a5.as,a5.Q,a5.z,a9,a8)
s=a5.ax[k]}if(p!=null)for(i=p.a,h=p.b,g=i.$flags|0;a7<l;){f=b2[a7]
e=B.a.Y(A.f8(f,a6),h)
g&2&&A.a(i)
i[e]=f;++a7}}else if(c<q){while(a7<l){i=b2[a7]
h=p.a
g=p.b
g=B.a.Y(A.f8(i,a6),g)
h.$flags&2&&A.a(h)
h[g]=i;++a7}i=p.a
h=i[c-280]
r&2&&A.a(b2)
b2[l]=h;++l;++a9
if(a9>=b3){++a8
if(m&&a8<=b5)b6.$2(a8,!0)
for(h=p.b,g=i.$flags|0;a7<l;){f=b2[a7]
e=B.a.Y(A.f8(f,a6),h)
g&2&&A.a(i)
i[e]=f;++a7}a9=j}}else return!1}if(m)b6.$2(a8>b5?b5:a8,!1)
a5.f=l
return!0},
jd(){var s,r,q,p,o
if(this.w>0)return!1
for(s=this.at,r=this.ax,q=0;q<s;++q){p=r[q].a
o=p[1]
if(o.a[o.b].a>0)return!1
o=p[2]
if(o.a[o.b].a>0)return!1
o=p[3]
if(o.a[o.b].a>0)return!1}return!0},
iV(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this
if(b&&B.a.a2(a,16)!==0)return
s=h.r
r=a-s
q=h.dy
p=q*s
while(r>0){o=r>16?16:r
n=q*o
m=q*s
l=h.db
h.eA(s,o,p)
for(q=h.dx,k=h.cx,j=0;j<n;++j){q.toString
i=k[l+j]
q.$flags&2&&A.a(q)
q[m+j]=i>>>8&255}r-=o
q=h.dy
p+=o*q
s+=o}h.r=a},
io(a,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.f,e=B.a.ab(f,a),d=B.a.a2(f,a),c=a*a0,b=a*a1
if(f>=b){g.cT(e)
return!0}s=g.f1(d,e)
r=g.y
q=g.b
for(;;){if(!(!q.b&&f<b))break
if((d&r)>>>0===0){p=g.ck(g.as,g.Q,g.z,d,e)
s=g.ax[p]}if(q.a>=32)q.bT()
o=s.bV(0,q)
if(o<256){n=g.cy
n===$&&A.b()
n.$flags&2&&A.a(n)
n[f]=o;++f;++d
if(d>=a){++e
if(B.a.a2(e,16)===0)g.cT(e)
d=0}}else if(o<280){m=g.cV(o-256)
l=s.bV(4,q)
if(q.a>=32)q.bT()
k=g.ff(a,g.cV(l))
if(f>=k&&c-f>=m)for(n=g.cy,j=0;j<m;++j){n===$&&A.b()
i=f+j
h=n[i-k]
n.$flags&2&&A.a(n)
n[i]=h}else{g.f=f
return!0}f+=m
d+=m
while(d>=a){d-=a;++e
if(B.a.a2(e,16)===0)g.cT(e)}if(f<b&&(d&r)>>>0!==0){p=g.ck(g.as,g.Q,g.z,d,e)
s=g.ax[p]}}else return!1}g.cT(e)
g.f=f
return!0},
cT(a){var s,r,q,p=this,o=p.r,n=a-o,m=p.cy
m===$&&A.b()
s=A.q(m,!1,null,p.c.a*o)
if(n>0){r=p.r
o=p.dx
o.toString
q=A.q(o,!1,null,p.dy*r)
p.ch[0].kI(r,r+n,s,q)}p.r=a},
jI(a,b){var s,r,q,p,o,n,m,l,k,j=this,i=j.c.a,h=j.r
if(b)if(B.a.a2(a,16)!==0)return
s=a-h
if(s<=0){j.r=a
return}j.eA(h,s,i*h)
i=j.cx
i.toString
r=j.d.U()
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
eA(a,b,c){var s,r=this,q=r.ch,p=q.length,o=r.c.a,n=a+b,m=r.db,l=r.cx
l.toString
B.l.a1(l,m,m+o*b,l,c)
for(;s=p-1,p>0;p=s){o=q[s]
l=r.cx
l.toString
o.l9(a,n,l,m,l,m)}},
jY(a,b,c,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=1,d=null
if(a0&&f.b.ai(1)!==0){s=2+f.b.ai(3)
r=A.bJ(a,s)
q=A.bJ(b,s)
p=r*q
o=f.cg(r,q,!1)
if(o==null)return!1
f.z=s
for(n=o.$flags|0,m=e,l=0;l<p;++l){k=o[l]>>>8&65535
n&2&&A.a(o)
o[l]=k
if(k>=m)m=k+1}if(m>1000||m>a*b){d=new Int32Array(1)
B.G.ao(d,0,1,255)
for(e=0,l=0;l<p;++l){j=o[l]
if(d[j]===-1){i=e+1
d[j]=e
e=i}h=d[j]
n&2&&A.a(o)
o[l]=h}}else e=m}else{o=null
m=1}if(f.b.b)return!1
g=f.jZ(c,e,m,d)
if(g==null)return!1
f.as=o
f.at=e
f.ax=g
return!0},
dU(a,b,c,d,e,f){var s,r=a.a,q=a.b,p=d
do{p-=c
s=r[q+(b+p)]
s.a=e
s.b=f}while(p>0)},
ji(a,b,c){var s=B.a.X(1,b-c)
while(b<15){s-=a[b]
if(s<=0)break;++b
s=s<<1>>>0}return b-c},
f5(a,b){var s=B.a.X(1,b-1)
while((a&s)>>>0!==0)s=s>>>1
return s!==0?((a&s-1)>>>0)+s:a},
eD(a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=B.a.N(1,a5),a2=new Int32Array(16),a3=new Int32Array(16)
for(s=0;s<a7;++s){r=a6[s]
if(r>15)return 0
a2[r]=a2[r]+1}if(a2[0]===a7)return 0
a3[1]=0
for(q=1;q<15;q=p){r=a2[q]
if(r>B.a.N(1,q))return 0
p=q+1
a3[p]=a3[q]+r}for(r=a8!=null,s=0;s<a7;++s){o=a6[s]
if(o>0)if(r){n=a3[o]
if(n>=a7)return 0
a3[o]=n+1
a8.$flags&2&&A.a(a8)
a8[n]=s}else a3[o]=a3[o]+1}if(a3[15]===1){if(r){a4.toString
a0.dU(a4,0,1,a1,0,a8[0])}return a1}m=a1-1
for(l=0,k=1,j=1,s=0,q=1,i=2;q<=a5;++q,i=i<<1>>>0){j=j<<1>>>0
k+=j
j-=a2[q]
if(j<0)return 0
if(a4==null)continue
for(h=q&255;a2[q]>0;a2[q]=a2[q]-1,s=g){g=s+1
a0.dU(a4,l,i,a1,h,a8[s])
l=a0.f5(l,q)}}for(q=a5+1,r=a4!=null,f=a1,e=0,d=4294967295,i=2;q<=15;++q,i=i<<1>>>0){j=j<<1>>>0
k+=j
j-=a2[q]
if(j<0)return 0
for(h=q-a5&255;a2[q]>0;a2[q]=a2[q]-1){c=(l&m)>>>0
if(c!==d){if(r)e+=f
b=a0.ji(a2,q,a5)
f=B.a.X(1,b)
a1+=f
if(r){n=a4.a[a4.b+c]
n.a=b+a5&255
n.b=e-c}d=c}if(r){g=s+1
a=a8[s]
a0.dU(a4,e+B.a.a3(l,a5),i,f,h,a)
s=g}l=a0.f5(l,q)}}if(k!==2*a3[15]-1)return 0
return a1},
fz(a,b,c,d){var s,r,q,p,o,n,m=this.eD(null,b,c,d,null)
if(m===0||a==null)return m
s=a.b
r=s.d
q=s.e
if(r+m>=q){p=new A.dX()
if(m>q)q=m
o=A.lN(q)
p.e=q
p.b=p.a=o
a.b=p
s=p}n=new Uint16Array(d)
this.eD(s.b,b,c,d,n)
return m},
jX(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=new A.fz(new A.dX())
c.ew(128)
if(this.fz(c,7,a,19)===0)return!1
s=this.b
if(s.ai(1)!==0){r=2+s.ai(2+2*s.ai(3))
if(r>b)return!1}else r=b
for(q=a0.$flags|0,p=8,o=0;o<b;r=n){n=r-1
if(r===0)break
if(s.a>=32)s.bT()
m=c.b.a
m.toString
l=m.a[m.b+(s.cw()&127)]
s.a=s.a+l.a
k=l.b
if(k<16){j=o+1
q&2&&A.a(a0)
a0[o]=k
if(k!==0)p=k
o=j}else{i=k-16
h=B.d_[i]
g=B.d8[i]
f=s.ai(h)+g
if(o+f>b)return!1
e=k===16?p:0
for(;d=f-1,f>0;f=d,o=j){j=o+1
q&2&&A.a(a0)
a0[o]=e}}}return!0},
fk(a,b,c){var s,r,q,p,o,n,m=this.b,l=m.ai(1)
B.G.ao(b,0,a,0)
if(l!==0){s=m.ai(1)
r=m.ai(m.ai(1)===0?1:8)
b.$flags&2&&A.a(b)
b[r]=1
if(s+1===2)b[m.ai(8)]=1
q=!0}else{p=new Int32Array(19)
o=m.ai(4)+4
for(n=0;n<o;++n)p[B.fv[n]]=m.ai(3)
q=this.jX(p,a,b)}return q&&!m.b?this.fz(c,8,b,a):0},
cJ(a,b,c){var s=c.a,r=a.a
c.a=s+r
c.b=(c.b|B.a.N(a.b,b))>>>0
return r},
i1(a){var s,r,q,p,o,n,m,l=this
for(s=a.a,r=a.f,q=0;q<64;++q){p=r[q]
o=s[0]
n=o.a[o.b+q]
o=n.b
if(o>=256){p.a=n.a+256
p.b=o}else{p.b=p.a=0
m=B.a.a3(q,l.cJ(n,8,p))
o=s[1]
m=B.a.a3(m,l.cJ(o.a[o.b+m],16,p))
o=s[2]
m=B.a.a3(m,l.cJ(o.a[o.b+m],0,p))
o=s[3]
B.a.a3(m,l.cJ(o.a[o.b+m],24,p))}}},
jZ(a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=null,a3=a7>0,a4=a3?B.a.N(1,a7):0,a5=B.en[a7],a6=b0==null
if(a6&&a8!==a9)return a2
s=new Int32Array(280+a4)
r=J.al(a8,t.ct)
for(q=0;q<a8;++q)r[q]=A.pH()
a4=new A.fz(new A.dX())
a4.ew(a8*a5)
a1.ay=a4
for(a4=!a6,p=0;p<a9;++p)if(a4&&b0[p]===-1)for(o=0;o<5;++o){n=B.b3[o]
if(a1.fk(o===0&&a3?n+B.a.N(1,a7):n,s,a2)===0)return a2}else{m=r[a6?p:b0[p]]
l=m.a
for(k=0,j=!0,i=0,o=0;o<5;++o){n=B.b3[o]
if(o===0&&a3)n+=B.a.N(1,a7)
h=a1.fk(n,s,a1.ay)
g=a1.ay.b
f=g.b
f.toString
l[o]=f
if(h===0)return a2
if(j&&B.hd[o]===1)j=f.a[f.b].a===0
e=f.a
f=f.b
i+=e[f].a
g.d+=h
g.b=new A.dW(e,f+h)
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
if(g)a1.i1(m)}return r},
cV(a){var s
if(a<4)return a+1
s=B.a.i(a-2,1)
return B.a.N(2+(a&1),s)+this.b.ai(s)+1},
ff(a,b){var s,r
if(b>120)return b-120
else{s=B.ez[b-1]
r=(s>>>4)*a+(8-(s&15))
return r>=1?r:1}},
iS(a,b){var s,r,q,p,o,n,m=B.a.N(1,B.a.a3(8,b.e)),l=new Uint32Array(m),k=b.d
k.toString
s=J.a2(B.l.gA(k),0,null)
r=J.a2(B.l.gA(l),0,null)
l[0]=b.d[0]
q=4*a
for(k=r.$flags|0,p=4;p<q;++p){o=s[p]
n=r[p-4]
k&2&&A.a(r)
r[p]=o+n&255}for(q=4*m;p<q;++p){k&2&&A.a(r)
r[p]=0}b.d=l
return!0},
ck(a,b,c,d,e){if(c===0||a==null)return 0
return a[b*B.a.i(e,c)+B.a.i(d,c)]},
f1(a,b){var s=this,r=s.ck(s.as,s.Q,s.z,a,b)
return s.ax[r]}}
A.fS.prototype={
l_(a,b){return this.iV(a,b)}}
A.hE.prototype={
cw(){var s,r,q=this.a
if(q<32){s=this.d
r=B.a.Y(s[0],q)+((s[1]&B.ao[q])>>>0)*(B.ao[32-q]+1)}else{s=this.d
r=q===32?s[1]:B.a.Y(s[1],q-32)}return r},
ai(a){var s,r,q=this
if(!q.b&&a<25){s=q.cw()
r=B.ao[a]
q.a+=a
q.bT()
return(s&r)>>>0}else{q.b=!0
throw A.e(A.j("Not enough data in input."))}},
bT(){var s,r,q,p=this,o=p.c,n=p.d,m=n.$flags|0,l=o.c
for(;;){if(!(p.a>=8&&o.d<l))break
s=J.c(o.a,o.d++)
r=n[0]
q=n[1]
m&2&&A.a(n)
n[0]=(r>>>8)+(q&255)*16777216
n[1]=q>>>8
n[1]=(n[1]|s*16777216)>>>0
p.a-=8}}}
A.kp.prototype={}
A.cq.prototype={
a6(){return"VP8LImageTransformType."+this.b}}
A.hF.prototype={
l9(a,b,c,d,e,f){var s,r,q,p,o=this,n=o.b
switch(o.a.a){case 2:o.kE(e,f,(b-a)*n)
break
case 0:o.le(a,b,c,d,e,f)
if(b!==o.c){s=f-n
B.l.a1(e,s,s+n,c,f+(b-a-1)*n)}break
case 1:o.kJ(a,b,c,d,e,f)
break
case 3:if(d===f&&o.e>0){r=b-a
q=r*A.bJ(n,o.e)
p=f+r*n-q
B.l.a1(e,p,p+q,c,f)
o.fQ(a,b,c,p,e,f)}else o.fQ(a,b,c,d,e,f)
break}},
kI(a,b,c,d){var s,r,q,p,o,n,m=this.e,l=B.a.a3(8,m),k=this.b,j=this.d
if(l<8){s=B.a.N(1,m)-1
r=B.a.N(1,l)-1
for(q=a;q<b;++q)for(p=0,o=0;o<k;++o){if((o&s)>>>0===0){p=J.c(c.a,c.d);++c.d}m=j[(p&r)>>>0]
J.W(d.a,d.d,m>>>8&255);++d.d
p=B.a.i(p,l)}}else for(q=a;q<b;++q)for(o=0;o<k;++o){n=J.c(c.a,c.d);++c.d
m=j[n]
J.W(d.a,d.d,m>>>8&255);++d.d}},
fQ(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k=this.e,j=B.a.a3(8,k),i=this.b,h=this.d
if(j<8){s=B.a.N(1,k)-1
r=B.a.N(1,j)-1
for(k=e.$flags|0,q=a;q<b;++q)for(p=0,o=0;o<i;++o,f=m){if((o&s)>>>0===0){n=d+1
p=c[d]>>>8&255
d=n}m=f+1
l=h[p&r]
k&2&&A.a(e)
e[f]=l
p=B.a.a3(p,j)}}else for(k=e.$flags|0,q=a;q<b;++q)for(o=0;o<i;++o,f=m,d=n){m=f+1
n=d+1
l=h[c[d]>>>8&255]
k&2&&A.a(e)
e[f]=l}},
kJ(a3,a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=c.b,a=c.e,a0=B.a.N(1,a)-1,a1=A.bJ(b,a),a2=B.a.i(a3,c.e)*a1
for(a=a7.$flags|0,s=a3;s<a4;){r=new Uint8Array(3)
for(q=a2,p=0;p<b;++p){if((p&a0)>>>0===0){o=q+1
n=c.d[q]
r[0]=n&255
r[1]=n>>>8&255
r[2]=n>>>16&255
q=o}n=a5[a6+p]
m=n>>>8&255
l=r[0]
k=$.ak()
k.$flags&2&&A.a(k)
k[0]=l
l=$.at()
j=l[0]
k[0]=m
i=l[0]
h=$.ic()
h.$flags&2&&A.a(h)
h[0]=j*i
g=$.lC()
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
bY(a,b){return(((a&4278255360)>>>0)+((b&4278255360)>>>0)&4278255360|(a&16711935)+(b&16711935)&16711935)>>>0},
le(a8,a9,b0,b1,b2,b3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=4278190080,a7=a5.b
if(a8===0){s=a5.bY(b0[b1],a6)
b2.$flags&2&&A.a(b2)
b2[b3]=s
r=b1+1
q=b3+1
p=a7-1
o=b2[b3]
for(n=0;n<p;++n){o=a5.bY(b0[r+n],o)
b2[q+n]=o}b1+=a7
b3+=a7;++a8}s=a5.e
m=B.a.N(1,s)
l=m-1
k=A.bJ(a7,s)
j=B.a.i(a8,a5.e)*k
for(s=~l,i=b2.$flags|0,h=a8;h<a9;){g=b2[b3-a7]
f=a5.bY(b0[b1],g)
i&2&&A.a(b2)
b2[b3]=f
for(e=j,d=1;d<a7;d=a0,e=c){c=e+1
b=a5.d[e]>>>8&15
a=$.r8[b]
a0=((d&s)>>>0)+m
if(a0>a7)a0=a7
a1=b1+d
f=b3+d
a2=f-a7
a3=a0-d
if(b===0)for(n=0;n<a3;++n)b2[f+n]=a5.bY(b0[a1+n],a6)
else if(b===1){o=b2[f-1]
for(n=0;n<a3;++n){o=a5.bY(b0[a1+n],o)
b2[f+n]=o}}else for(n=0;n<a3;++n){a4=f+n
g=a.$3(b2[a4-1],b2,a2+n)
b2[a4]=a5.bY(b0[a1+n],g)}}b1+=a7
b3+=a7;++h
if((h&l)>>>0===0)j+=k}},
kE(a,b,c){var s,r,q,p,o
for(s=a.$flags|0,r=0;r<c;++r){q=b+r
p=a[q]
o=p>>>8&255
s&2&&A.a(a)
a[q]=(p&4278255360|(p&16711935)+(o<<16|o)&16711935)>>>0}}}
A.ku.prototype={
gfZ(){var s=this,r=s.d
if(r>1||s.e>=4||s.f>1||s.r!==0)return!1
return!0},
kN(a,b,c){var s,r,q,p,o,n,m=this
if(!m.gfZ())return!1
s=B.j7[m.e]
if(m.d===0){r=m.b
q=a*r
p=m.a
B.c.a1(c,q,q+b*r,p.a,p.d-p.b+q)}else{r=a+b
p=m.x
p===$&&A.b()
p.dx=c
o=p.c
if(m.y)r=p.io(o.a,o.b,r)
else{n=p.cx
n.toString
p=p.dw(n,o.a,o.b,r,p.gkZ())
r=p}if(!r)return!1}if(s!=null){r=m.b
s.$6(r,m.c,r,a,b,c)}if(m.f===1)if(!m.iN(c,m.b,m.c,a,b))return!1
if(a+b>=m.c)m.w=!0
return!0},
iN(a,b,c,d,e){if(b<=0||c<=0||d<0||e<0||d+e>c)return!1
return!0}}
A.eJ.prototype={
hP(a,b){var s=this,r=a.F()
s.w=0
s.f=(r&1)!==0
s.r=(r&2)===0
s.x=a.d-a.b
s.y=b-16}}
A.fT.prototype={}
A.fx.prototype={}
A.fy.prototype={}
A.dW.prototype={
gp(a){return this.a.length-this.b}}
A.dV.prototype={
bV(a,b){var s,r=b.cw()&255,q=this.a,p=q[a],o=p.a[p.b+r].a-8
if(o>0){b.a+=8
s=b.cw()
q=q[a]
r=r+q.a[q.b+r].b+((s&B.a.X(1,o)-1)>>>0)}else q=p
p=b.a
q=q.a[q.b+r]
b.a=p+q.a
return q.b}}
A.dX.prototype={}
A.fz.prototype={
ew(a){var s=this.b=this.a,r=A.lN(a)
s.e=a
s.b=s.a=r}}
A.dl.prototype={
a6(){return"WebPFormat."+this.b}}
A.dm.prototype={}
A.fU.prototype={}
A.kv.prototype={
aD(a){var s,r=A.q(a,!1,null,0)
this.c=r
try{r=this.f0(r)
return r}catch(s){return!1}},
az(a){return A.K(new A.ky(this,a))},
ky(a){var s,r,q,p,o=this,n=null,m=A.q(a,!1,n,0)
o.c=m
if(!o.f0(m))return n
m=new A.fU(B.a1,A.m([],t.J))
o.a=m
s=o.c
s.toString
if(!o.f2(s,m))return n
m=o.a
switch(m.f.a){case 3:s=o.b
A.ai(m.a,m.b,s,!1)
for(m=o.a.z,r=m.length,q=0;q<m.length;m.length===r||(0,A.a0)(m),++q){p=m[q]
A.ai(p.c,p.d,s,!1)}m=o.a
m.as=m.z.length
return m
case 2:s=o.c
s.toString
s.d=m.ay
if(!A.mi(s,m).cq())return n
m=o.a
A.ai(m.a,m.b,o.b,!1)
m=o.a
m.as=m.z.length
return m
case 1:s=o.c
s.toString
s.d=m.ay
if(!A.mg(s,m).cq())return n
m=o.a
A.ai(m.a,m.b,o.b,!1)
m=o.a
m.as=m.z.length
return m
case 0:throw A.e(A.j("Unknown format for WebP"))}},
ae(a){return A.K(new A.kw(this,a))},
iA(a){var s,r,q,p,o=this,n=o.c
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
return o.fA(n.bQ(s,r),a)}r=s.f
if(r===B.ab){p=n.bQ(s.ch,s.ay)
n=o.a
n.toString
return A.mi(p,n).bz()}else if(r===B.ax){p=n.bQ(s.ch,s.ay)
n=o.a
n.toString
return A.mg(p,n).bz()}return null},
aY(a,b){return A.K(new A.kx(this,a,b))},
kx(a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=null
if(a1.az(a3)==null)return a2
s=a1.a
r=s.e
if(!r)return a1.ae(0)
new A.bl(a1.b).bU(0,s.a*s.as,s.b)
for(s=t.N,r=t.P,q=a2,p=q,o=p,n=0;m=a1.a,n<m.as;++n){a4=m.z[n]
l=a1.ae(n)
if(l==null)continue
m=a4.e
l.y=m
if(o==null||p==null){k=a1.a
j=k.a
k=k.b
i=l.gbO()
h=l.a
h=h==null?a2:h.gJ()
if(h==null)h=B.e
g=l.y
f=a1.a
e=f.y
d=f.c
f=f.w
if(f.length===0)f=a2
else{f=new A.aN(f)
c=f.gp(0)
b=f.gp(0)
a=new A.bT(A.D(s,r))
a.bD(new A.a8(f,0,Math.min(c,b),0,!1))
f=a}a0=a1.a.r
o=A.Q(d,f,h,g,B.i,k,a0==null?a2:new A.bf("ICC_PROFILE",B.R,a0),e,i,a2,B.e,j,!1)
p=o}else{p=A.aP(p,!1,!1)
if(q!=null){k=q.f
k===$&&A.b()}else k=!1
if(k){k=q.a
j=q.b
i=q.c
h=q.d
A.oA(p,!1,$.p4(),k,k+i-1,j,j+h-1)}}p.y=m
m=a4.r
m===$&&A.b()
m=m?B.ac:B.a2
A.mC(p,l,m,a2,a2,a4.a,a4.b,a2,a2,a2,a2)
if(p!==o)o.b1(p)
q=a4}return o},
fA(a,b){var s,r,q,p=null,o=A.m([],t.J),n=new A.fU(B.a1,o)
if(!this.f2(a,n))return p
if(n.f===B.a1)return p
n.as=this.a.as
if(n.e){s=o.length
if(b>=s)return p
r=o[b]
o=r.y
o===$&&A.b()
s=r.x
s===$&&A.b()
return this.fA(a.bQ(o,s),b)}else{q=a.bQ(n.ch,n.ay)
o=n.f
if(o===B.ab)return A.mi(q,n).bz()
else if(o===B.ax)return A.mg(q,n).bz()}return p},
f0(a){if(a.aj(4)!=="RIFF")return!1
a.j()
if(a.aj(4)!=="WEBP")return!1
return!0},
f2(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g
for(s=a.c,r=a.b;a.d<s;){q=a.aj(4)
p=a.j()
o=p+1>>>1<<1>>>0
n=a.d
m=n-r
switch(q){case"VP8X":if(!this.j1(a,b))return!1
break
case"VP8 ":b.ay=m
b.ch=p
b.f=B.ax
break
case"VP8L":b.ay=m
b.ch=p
b.f=B.ab
break
case"ALPH":b.toString
n=a.a
l=a.e
k=J.a6(n)
j=k.gp(n)
k=k.gp(n)
n=new A.a8(n,0,Math.min(j,k),0,l)
b.at=n
n.d=a.d
a.d+=o
break
case"ANIM":b.f=B.kr
i=a.j()
n=new Uint8Array(4)
n[0]=i>>>16&255
n[1]=i>>>8&255
n[2]=i&255
n[3]=i>>>24&255
b.c=new A.bQ(n)
b.y=a.l()
break
case"ANMF":if(!this.iZ(a,b,p))return!1
break
case"ICCP":b.toString
h=a.ar(p)
a.d=a.d+(h.c-h.d)
b.r=h.U()
break
case"EXIF":b.toString
b.w=a.aj(p)
break
case"XMP ":b.toString
a.aj(p)
break
default:a.d=n+o
break}n=a.d
g=o-(n-r-m)
if(g>0)a.d=n+g}if(!b.d)b.d=b.at!=null
return b.f!==B.a1},
j1(a,b){var s,r,q,p,o=a.F()
if((o&192)!==0)return!1
s=B.a.i(o,4)
r=B.a.i(o,1)
if((o&1)!==0)return!1
if(a.bc()!==0)return!1
q=a.bc()
p=a.bc()
b.a=q+1
b.b=p+1
b.e=(r&1)!==0
b.d=(s&1)!==0
return!0},
iZ(a,b,c){var s=new A.fT(a.bc()*2,a.bc()*2,a.bc()+1,a.bc()+1,a.bc())
s.hP(a,c)
if(s.w!==0)return!1
b.z.push(s)
return!0}}
A.ky.prototype={
$0(){return this.a.ky(this.b)},
$S:31}
A.kw.prototype={
$0(){return this.a.iA(this.b)},
$S:1}
A.kx.prototype={
$0(){return this.a.kx(this.b,this.c)},
$S:1}
A.fA.prototype={
a6(){return"IccProfileCompression."+this.b}}
A.bf.prototype={
kW(){var s,r=this
if(r.b===B.R)return r.c
s=A.i9(r.c,16777216)
r.c=s
r.b=B.R
return s}}
A.fw.prototype={
a6(){return"FrameType."+this.b}}
A.aw.prototype={
gaB(){var s=this.x
return s===$?this.x=A.m([],t.g):s},
hH(a,b,c,d){var s,r,q,p=this,o=a.gJ(),n=a.gbO(),m=a.a
p.eP(d,b,o,n,m==null?null:m.gR())
o=a.b
if(o!=null)p.b=A.h5(o,t.N,t.v)
o=a.d
if(o!=null){n=t.N
p.d=A.h5(o,n,n)}p.gaB().push(p)
if(!c){s=a.gaB().length
for(o=t.g,r=1;r<s;++r){q=a.x
p.b1(A.fG((q===$?a.x=A.m([],o):q)[r],b,!1,d))}}},
hG(a,b,c){var s,r,q,p,o=this,n=a.b
if(n!=null)o.b=A.h5(n,t.N,t.v)
n=a.d
if(n!=null){s=t.N
o.d=A.h5(n,s,s)}o.gaB().push(o)
if(!b&&a.gaB().length>1){r=a.gaB().length
for(n=t.g,q=1;q<r;++q){p=a.x
o.b1(A.aP((p===$?a.x=A.m([],n):p)[q],!1,!1))}}},
b1(a){var s=this
if(a==null)a=A.aP(s,!0,!0)
a.z=s.gaB().length
if(s.gaB().length===0||B.k.gd8(s.gaB())!==a)s.gaB().push(a)
return a},
d2(){return this.b1(null)},
eP(a,b,c,d,e){var s,r,q=this,p=null
switch(c.a){case 0:if(e==null){s=B.b.b2(a*d/8)
r=new A.cW($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.b2(a/8)
r=new A.cW($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 1:if(e==null){s=B.b.b2(a*(d<<1>>>0)/8)
r=new A.cX($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.b2(a/4)
r=new A.cX($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 2:if(e==null){if(d===2)s=a
else if(d===4)s=a*2
else s=d===3?B.b.b2(a*1.5):B.b.b2(a/2)
r=new A.cZ($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.b2(a/2)
r=new A.cZ($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 3:if(e==null)q.a=A.nq(a,b,d)
else q.a=new A.d_(new Uint8Array(a*b),e,a,b,1)
break
case 4:s=a*b
if(e==null)q.a=new A.c4(new Uint16Array(s*d),p,a,b,d)
else q.a=new A.c4(new Uint16Array(s),e,a,b,1)
break
case 5:q.a=A.pK(a,b,d)
break
case 6:q.a=new A.e2(new Int8Array(a*b*d),a,b,d)
break
case 7:q.a=new A.e0(new Int16Array(a*b*d),a,b,d)
break
case 8:q.a=new A.e1(new Int32Array(a*b*d),a,b,d)
break
case 9:q.a=A.pI(a,b,d)
break
case 10:q.a=A.pJ(a,b,d)
break
case 11:q.a=new A.e_(new Float64Array(a*b*4*d),a,b,d)
break}},
B(a){var s=this
return"Image("+s.gZ()+", "+s.gS()+", "+s.gJ().b+", "+s.gbO()+")"},
gZ(){var s=this.a
s=s==null?null:s.a
return s==null?0:s},
gS(){var s=this.a
s=s==null?null:s.b
return s==null?0:s},
gJ(){var s=this.a
s=s==null?null:s.gJ()
return s==null?B.e:s},
gbj(){var s=this.e
return s==null?this.e=new A.bT(A.D(t.N,t.P)):s},
hn(a,b){var s=this,r=s.b;(r==null?s.b=A.D(t.N,t.v):r).m(0,a,b)
if(s.b.a===0)s.b=null},
gG(a){var s=this.a
return s.gG(s)},
gA(a){var s=this.a
s=s==null?null:s.gA(s)
if(s==null)s=B.c.gA(new Uint8Array(0))
return s},
U(){var s=this.a
s=s==null?null:J.C(s.gA(s))
return s==null?J.C(this.gA(0)):s},
gbO(){var s=this.a
s=s==null?null:s.gR()
s=s==null?null:s.b
if(s==null){s=this.a
s=s==null?null:s.c}return s==null?0:s},
gbB(){var s=this.a
return(s==null?null:s.gR())!=null},
fX(a,b){return a>=0&&b>=0&&a<this.gZ()&&b<this.gS()},
aL(a,b,c,d){var s=this.a
s=s==null?null:s.aL(a,b,c,d)
if(s==null)s=new A.b_(new Uint8Array(0))
return s},
L(a,b,c){var s=this.a
s=s==null?null:s.L(a,b,c)
return s==null?new A.F():s},
aM(a,b){return this.L(a,b,null)},
af(a,b){if(a<0||a>=this.gZ()||b<0||b>=this.gS())return new A.F()
return this.L(a,b,null)},
ek(a,b,c){switch(c.a){case 0:return this.af(B.b.h(a),B.b.h(b))
case 1:case 3:return this.hk(a,b)
case 2:return this.hj(a,b)}},
hk(a,b){var s,r,q,p,o,n,m=this,l=B.b.h(a),k=l-(a>=0?0:1),j=k+1
l=B.b.h(b)
s=l-(b>=0?0:1)
r=s+1
l=new A.iW(a-k,b-s)
q=m.af(k,s)
p=r>=m.gS()?q:m.af(k,r)
o=j>=m.gZ()?q:m.af(j,s)
n=j>=m.gZ()||r>=m.gS()?q:m.af(j,r)
return m.aL(l.$4(q.gq(),o.gq(),p.gq(),n.gq()),l.$4(q.gu(),o.gu(),p.gu(),n.gu()),l.$4(q.gv(),o.gv(),p.gv(),n.gv()),l.$4(q.gt(),o.gt(),p.gt(),n.gt()))},
hj(c8,c9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2=this,c3=B.b.h(c8),c4=c3-(c8>=0?0:1),c5=c4-1,c6=c4+1,c7=c4+2
c3=B.b.h(c9)
s=c3-(c9>=0?0:1)
r=s-1
q=s+1
p=s+2
o=c8-c4
n=c9-s
c3=new A.iV()
m=c2.af(c4,s)
l=c5<0
k=!l
j=!k||r<0?m:c2.af(c5,r)
i=r<0
h=i?m:c2.af(c4,r)
g=i||c6>=c2.gZ()?m:c2.af(c6,r)
f=c7>=c2.gZ()||i?m:c2.af(c7,r)
e=c3.$5(o,j.gq(),h.gq(),g.gq(),f.gq())
d=c3.$5(o,j.gu(),h.gu(),g.gu(),f.gu())
c=c3.$5(o,j.gv(),h.gv(),g.gv(),f.gv())
b=c3.$5(o,j.gt(),h.gt(),g.gt(),f.gt())
a=l?m:c2.af(c5,s)
a0=c6>=c2.gZ()?m:c2.af(c6,s)
a1=c7>=c2.gZ()?m:c2.af(c7,s)
a2=c3.$5(o,a.gq(),m.gq(),a0.gq(),a1.gq())
a3=c3.$5(o,a.gu(),m.gu(),a0.gu(),a1.gu())
a4=c3.$5(o,a.gv(),m.gv(),a0.gv(),a1.gv())
a5=c3.$5(o,a.gt(),m.gt(),a0.gt(),a1.gt())
a6=!k||q>=c2.gS()?m:c2.af(c5,q)
a7=q>=c2.gS()?m:c2.af(c4,q)
a8=c6>=c2.gZ()||q>=c2.gS()?m:c2.af(c6,q)
a9=c7>=c2.gZ()||q>=c2.gS()?m:c2.af(c7,q)
b0=c3.$5(o,a6.gq(),a7.gq(),a8.gq(),a9.gq())
b1=c3.$5(o,a6.gu(),a7.gu(),a8.gu(),a9.gu())
b2=c3.$5(o,a6.gv(),a7.gv(),a8.gv(),a9.gv())
b3=c3.$5(o,a6.gt(),a7.gt(),a8.gt(),a9.gt())
b4=!k||p>=c2.gS()?m:c2.af(c5,p)
b5=p>=c2.gS()?m:c2.af(c4,p)
b6=c6>=c2.gZ()||p>=c2.gS()?m:c2.af(c6,p)
b7=c7>=c2.gZ()||p>=c2.gS()?m:c2.af(c7,p)
b8=c3.$5(o,b4.gq(),b5.gq(),b6.gq(),b7.gq())
b9=c3.$5(o,b4.gu(),b5.gu(),b6.gu(),b7.gu())
c0=c3.$5(o,b4.gv(),b5.gv(),b6.gv(),b7.gv())
c1=c3.$5(o,b4.gt(),b5.gt(),b6.gt(),b7.gt())
return c2.aL(c3.$5(n,e,a2,b0,b8),c3.$5(n,d,a3,b1,b9),c3.$5(n,c,a4,b2,c0),c3.$5(n,b,a5,b3,c1))},
bP(a,b,c){var s
if(t.dv.b(c))if(c.gb4().gR()!=null)if(this.gbB()){s=this.a
if(s!=null)s.aC(a,b,c.gM(),0,0)
return}s=this.a
if(s!=null)s.ak(a,b,c.gq(),c.gu(),c.gv(),c.gt())},
gD(){var s=this.a
s=s==null?null:s.gD()
return s==null?0:s},
aO(a,b){var s=this.a
return s==null?null:s.aO(0,b)},
d5(a){return this.aO(0,null)},
fS(a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=null,a7=a5.gJ(),a8=B.bt.k(0,a7)
a8=a8
s=!1
if(a7===a5.gJ())if(a9===a5.gbO()){r=a5.a
s=(r==null?a6:r.gR())==null}if(s){q=A.aP(a5,!1,!1)
return q}for(s=a5.gaB(),r=s.length,p=t.N,o=t.p,n=a6,m=0;m<s.length;s.length===r||(0,A.a0)(s),++m,n=d){l=s[m]
k=l.a
j=k==null
i=j?a6:k.a
if(i==null)i=0
k=j?a6:k.b
if(k==null)k=0
j=l.e
j=j==null?a6:A.dN(j)
h=l.c
if(h==null)h=a6
else{g=h.a
f=h.b
h=h.c
h=new A.bf(g,f,new Uint8Array(h.subarray(0,A.i6(0,a6,h.length))))}g=l.f
g=g==null?a6:new A.b_(new Uint8Array(A.t(g.a)))
f=l.w
e=l.r
q=A.Q(g,j,a7,l.y,f,k,h,e,a9,a6,B.e,i,!1)
k=l.d
q.d=k!=null?A.h5(k,p,p):a6
if(n!=null){n.b1(q)
d=n}else d=q
k=q.a
c=k==null?a6:k.gR()
k=q.a
k=k==null?a6:k.gR()
b=k==null?a6:k.gJ()
if(b==null)b=a7
k=l.a
if(c!=null){a=A.D(o,o)
a0=k==null?a6:k.L(0,0,a6)
if(a0==null)a0=new A.F()
for(k=q.a,k=k.gG(k),a1=0;k.E();){a2=k.gK()
a3=A.oN(B.b.ba(a0.gad()*255),B.b.ba(a0.ga9()*255),B.b.ba(a0.gac()*255),0)
if(a.a5(a3)){j=a.k(0,a3)
j.toString
a2.sM(j)}else{a.m(0,a3,a1)
a2.sM(a1)
a4=A.aB(a0,a8,b,a9,a6)
c.b6(a1,a4.gq(),a4.gu(),a4.gv());++a1}a0.E()}}else{a0=k==null?a6:k.L(0,0,a6)
if(a0==null)a0=new A.F()
for(k=q.a,k=k.gG(k);k.E();){A.aB(a0,a8,a6,a6,k.gK())
a0.E()}}}n.toString
return n},
kF(a){var s,r,q,p
if(this.d==null){s=t.N
this.d=A.D(s,s)}for(s=new A.V(a,a.r,a.e,A.i(a).n("V<1>"));s.E();){r=s.d
q=this.d
q.toString
p=a.k(0,r)
p.toString
q.m(0,r,p)}},
ih(a,b,c){var s,r=65536
switch(b.a){case 0:return null
case 1:return null
case 2:return null
case 3:s=a===B.m?r:256
return new A.ba(new Uint8Array(s*c),s,c)
case 4:s=a===B.m?r:256
return new A.hf(new Uint16Array(s*c),s,c)
case 5:s=a===B.m?r:256
return new A.hg(new Uint32Array(s*c),s,c)
case 6:s=a===B.m?r:256
return new A.he(new Int8Array(s*c),s,c)
case 7:s=a===B.m?r:256
return new A.hc(new Int16Array(s*c),s,c)
case 8:s=a===B.m?r:256
return new A.hd(new Int32Array(s*c),s,c)
case 9:s=a===B.m?r:256
return new A.h9(new Uint16Array(s*c),s,c)
case 10:s=a===B.m?r:256
return new A.ha(new Float32Array(s*c),s,c)
case 11:s=a===B.m?r:256
return new A.hb(new Float64Array(s*c),s,c)}}}
A.iW.prototype={
$4(a,b,c,d){var s=this.b
return a+this.a*(b-a+s*(a+d-c-b))+s*(c-a)},
$S:32}
A.iV.prototype={
$5(a,b,c,d,e){var s=-b,r=a*a
return c+0.5*(a*(s+d)+r*(2*b-5*c+4*d-e)+r*a*(s+3*c-3*d+e))},
$S:33}
A.ab.prototype={
gR(){return null}}
A.cU.prototype={
b9(a){var s=this,r=s.d
if(a)r=new Uint16Array(r.length)
else r=new Uint16Array(A.t(r))
return new A.cU(r,s.a,s.b,s.c)},
gJ(){return B.z},
gA(a){return B.A.gA(this.d)},
gb8(){return 16},
gau(){return this.a*this.c*2},
gG(a){return A.lZ(this)},
b5(a,b,c,d,e){return A.b4(A.lZ(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gD(){return 1},
aL(a,b,c,d){var s=new Uint16Array(4),r=new A.cA(s)
s[0]=A.H(a)
s[1]=A.H(b)
s[2]=A.H(c)
s[3]=A.H(d)
s=r
return s},
L(a,b,c){if(c==null||!(c instanceof A.ca)||c.d!==this)c=A.lZ(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s=this.c,r=this.d,q=A.H(c)
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=q},
aC(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=A.H(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=A.H(d)
q[r+2]=A.H(e)}},
ak(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=A.H(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=A.H(f)
else if(s>2){q[r+1]=A.H(d)
q[r+2]=A.H(e)
if(s>3)q[r+3]=A.H(f)}},
B(a){return"ImageDataFloat16("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){}}
A.cV.prototype={
b9(a){var s=this,r=s.d
if(a)r=new Float32Array(r.length)
else r=new Float32Array(A.t(r))
return new A.cV(r,s.a,s.b,s.c)},
gJ(){return B.C},
gA(a){return B.M.gA(this.d)},
gb8(){return 32},
gG(a){return A.m_(this)},
b5(a,b,c,d,e){return A.b4(A.m_(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gD(){return 1},
gau(){return this.a*this.c*4},
aL(a,b,c,d){var s=new Float32Array(4),r=new A.cB(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
L(a,b,c){if(c==null||!(c instanceof A.cb)||c.d!==this)c=A.m_(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s=this.c,r=this.d
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=c},
aC(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d
q.$flags&2&&A.a(q)
q[r]=c
if(s>2){q[r+1]=d
q[r+2]=e}},
ak(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d
q.$flags&2&&A.a(q)
q[r]=c
if(s===2)q[r+1]=f
else if(s>2){q[r+1]=d
q[r+2]=e
if(s>3)q[r+3]=f}},
B(a){return"ImageDataFloat32("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){}}
A.e_.prototype={
b9(a){var s=this,r=s.d
if(a)r=new Float64Array(r.length)
else r=new Float64Array(A.t(r))
return new A.e_(r,s.a,s.b,s.c)},
gJ(){return B.K},
gA(a){return B.V.gA(this.d)},
gp(a){return this.d.byteLength},
gb8(){return 64},
gG(a){return A.m0(this)},
b5(a,b,c,d,e){return A.b4(A.m0(this),b,c,d,e)},
gD(){return 1},
gau(){return this.a*this.c*8},
aL(a,b,c,d){var s=new Float64Array(4),r=new A.cC(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
L(a,b,c){if(c==null||!(c instanceof A.cc)||c.d!==this)c=A.m0(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s=this.c,r=this.d
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=c},
aC(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d
q.$flags&2&&A.a(q)
q[r]=c
if(s>2){q[r+1]=d
q[r+2]=e}},
ak(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d
q.$flags&2&&A.a(q)
q[r]=c
if(s===2)q[r+1]=f
else if(s>2){q[r+1]=d
q[r+2]=e
if(s>3)q[r+3]=f}},
B(a){return"ImageDataFloat64("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){}}
A.e0.prototype={
b9(a){var s=this,r=s.d
if(a)r=new Int16Array(r.length)
else r=new Int16Array(A.t(r))
return new A.e0(r,s.a,s.b,s.c)},
gJ(){return B.P},
gA(a){return B.N.gA(this.d)},
gG(a){return A.m1(this)},
b5(a,b,c,d,e){return A.b4(A.m1(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gD(){return 32767},
gb8(){return 16},
gau(){return this.a*this.c*2},
aL(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Int16Array(4),n=new A.cD(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
L(a,b,c){if(c==null||!(c instanceof A.cd)||c.d!==this)c=A.m1(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=q},
aC(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ak(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataInt16("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){}}
A.e1.prototype={
b9(a){var s=this,r=s.d
if(a)r=new Int32Array(r.length)
else r=new Int32Array(A.t(r))
return new A.e1(r,s.a,s.b,s.c)},
gJ(){return B.Q},
gA(a){return B.G.gA(this.d)},
gb8(){return 32},
gau(){return this.a*this.c*4},
gG(a){return A.m2(this)},
b5(a,b,c,d,e){return A.b4(A.m2(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gD(){return 2147483647},
aL(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Int32Array(4),n=new A.cE(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
L(a,b,c){if(c==null||!(c instanceof A.ce)||c.d!==this)c=A.m2(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=q},
aC(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ak(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataInt32("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){}}
A.e2.prototype={
b9(a){var s=this,r=s.d
if(a)r=new Int8Array(r.length)
else r=new Int8Array(A.t(r))
return new A.e2(r,s.a,s.b,s.c)},
gJ(){return B.O},
gA(a){return B.W.gA(this.d)},
gau(){return this.a*this.c},
gG(a){return A.m3(this)},
b5(a,b,c,d,e){return A.b4(A.m3(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gD(){return 127},
gb8(){return 8},
aL(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Int8Array(4),n=new A.cF(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
L(a,b,c){if(c==null||!(c instanceof A.cf)||c.d!==this)c=A.m3(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*(this.a*s)+a*s]=q},
aC(a,b,c,d,e){var s=this.c,r=b*(this.a*s)+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ak(a,b,c,d,e,f){var s=this.c,r=b*(this.a*s)+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataInt8("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){}}
A.cW.prototype={
lC(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.y()
this.d=s},
b9(a){var s,r=this,q=r.d
if(a){q===$&&A.b()
q=new Uint8Array(q.length)}else{q===$&&A.b()
q=new Uint8Array(A.t(q))}s=r.f
s=s==null?null:s.O()
return new A.cW(q,r.e,s,r.a,r.b,r.c)},
gJ(){return B.u},
gp(a){var s=this.d
s===$&&A.b()
return s.byteLength},
gD(){var s=this.f
s=s==null?null:s.gD()
return s==null?1:s},
gA(a){var s=this.d
s===$&&A.b()
return B.c.gA(s)},
gb8(){return 1},
gG(a){return A.eq(this)},
b5(a,b,c,d,e){return A.b4(A.eq(this),b,c,d,e)},
aL(a,b,c,d){var s=new A.cG(4,0)
s.ag(B.b.h(a),B.b.h(b),B.b.h(c),B.b.h(d))
return s},
L(a,b,c){if(c==null||!(c instanceof A.cg)||c.f!==this)c=A.eq(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eq(r):s).a0(a,b)
r.r.al(0,c)},
aC(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eq(r):s).a0(a,b)
r.r.aq(c,d,e)},
ak(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eq(r):s).a0(a,b)
r.r.ag(c,d,e,f)},
B(a){return"ImageDataUint1("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){},
gau(){return this.e},
gR(){return this.f}}
A.c4.prototype={
b9(a){var s,r=this,q=r.d
if(a)q=new Uint16Array(q.length)
else q=new Uint16Array(A.t(q))
s=r.e
s=s==null?null:s.O()
return new A.c4(q,s,r.a,r.b,r.c)},
gJ(){return B.m},
gA(a){return B.A.gA(this.d)},
gb8(){return 16},
gD(){var s=this.e
s=s==null?null:s.gD()
return s==null?65535:s},
gau(){return this.a*this.c*2},
gG(a){return A.m4(this)},
b5(a,b,c,d,e){return A.b4(A.m4(this),b,c,d,e)},
gp(a){return this.d.byteLength},
aL(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Uint16Array(4),n=new A.cH(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
L(a,b,c){if(c==null||!(c instanceof A.ch)||c.d!==this)c=A.m4(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=q},
aC(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ak(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataUint16("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){},
gR(){return this.e}}
A.cX.prototype={
lD(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.y()
this.d=s},
b9(a){var s,r=this,q=r.d
if(a){q===$&&A.b()
q=new Uint8Array(q.length)}else{q===$&&A.b()
q=new Uint8Array(A.t(q))}s=r.f
s=s==null?null:s.O()
return new A.cX(q,r.e,s,r.a,r.b,r.c)},
gJ(){return B.x},
gb8(){return 2},
gA(a){var s=this.d
s===$&&A.b()
return B.c.gA(s)},
gG(a){return A.er(this)},
b5(a,b,c,d,e){return A.b4(A.er(this),b,c,d,e)},
gp(a){var s=this.d
s===$&&A.b()
return s.byteLength},
gD(){var s=this.f
s=s==null?null:s.gD()
return s==null?3:s},
aL(a,b,c,d){var s=new A.cI(4,0)
s.ag(B.b.h(a),B.b.h(b),B.b.h(c),B.b.h(d))
return s},
L(a,b,c){if(c==null||!(c instanceof A.ci)||c.f!==this)c=A.er(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.er(r):s).a0(a,b)
r.r.am(0,c)},
aC(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.er(r):s).a0(a,b)
r.r.aq(c,d,e)},
ak(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.er(r):s).a0(a,b)
r.r.ag(c,d,e,f)},
B(a){return"ImageDataUint2("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){},
gau(){return this.e},
gR(){return this.f}}
A.cY.prototype={
b9(a){var s=this,r=s.d
if(a)r=new Uint32Array(r.length)
else r=new Uint32Array(A.t(r))
return new A.cY(r,s.a,s.b,s.c)},
gJ(){return B.L},
gA(a){return B.l.gA(this.d)},
gau(){return this.a*this.c*4},
gb8(){return 32},
gD(){return 4294967295},
gG(a){return A.m5(this)},
b5(a,b,c,d,e){return A.b4(A.m5(this),b,c,d,e)},
gp(a){return this.d.byteLength},
aL(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Uint32Array(4),n=new A.cJ(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
L(a,b,c){if(c==null||!(c instanceof A.cj)||c.d!==this)c=A.m5(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*this.a*s+a*s]=q},
aC(a,b,c,d,e){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ak(a,b,c,d,e,f){var s=this.c,r=b*this.a*s+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataUint32("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){}}
A.cZ.prototype={
lE(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.y()
this.d=s},
b9(a){var s,r=this,q=r.d
if(a){q===$&&A.b()
q=new Uint8Array(q.length)}else{q===$&&A.b()
q=new Uint8Array(A.t(q))}s=r.f
s=s==null?null:s.O()
return new A.cZ(q,r.e,s,r.a,r.b,r.c)},
gJ(){return B.y},
gA(a){var s=this.d
s===$&&A.b()
return B.c.gA(s)},
gG(a){return A.es(this)},
b5(a,b,c,d,e){return A.b4(A.es(this),b,c,d,e)},
gp(a){var s=this.d
s===$&&A.b()
return s.byteLength},
gD(){var s=this.f
s=s==null?null:s.gD()
return s==null?15:s},
gb8(){return 4},
aL(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new A.cK(4,new Uint8Array(2))
o.ag(s,r,q,p)
s=o
return s},
L(a,b,c){if(c==null||!(c instanceof A.ck)||c.e!==this)c=A.es(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.es(r):s).a0(a,b)
r.r.an(0,c)},
aC(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.es(r):s).a0(a,b)
r.r.aq(c,d,e)},
ak(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.es(r):s).a0(a,b)
r.r.ag(c,d,e,f)},
B(a){return"ImageDataUint4("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){},
gau(){return this.e},
gR(){return this.f}}
A.d_.prototype={
b9(a){var s,r=this,q=r.d
if(a)q=new Uint8Array(q.length)
else q=new Uint8Array(A.t(q))
s=r.e
s=s==null?null:s.O()
return new A.d_(q,s,r.a,r.b,r.c)},
gJ(){return B.e},
gA(a){return B.c.gA(this.d)},
gau(){return this.a*this.c},
gb8(){return 8},
gG(a){return A.jx(this)},
b5(a,b,c,d,e){return A.b4(A.jx(this),b,c,d,e)},
gp(a){return this.d.byteLength},
gD(){var s=this.e
s=s==null?null:s.gD()
return s==null?255:s},
aL(a,b,c,d){var s=A.n8(B.b.h(B.b.I(a,0,255)),B.b.h(B.b.I(b,0,255)),B.b.h(B.b.I(c,0,255)),B.b.h(B.b.I(d,0,255)))
return s},
L(a,b,c){if(c==null||!(c instanceof A.cl)||c.d!==this)c=A.jx(this)
c.a0(a,b)
return c},
aM(a,b){return this.L(a,b,null)},
aF(a,b,c){var s=this.c,r=this.d,q=B.b.h(c)
r.$flags&2&&A.a(r)
r[b*(this.a*s)+a*s]=q},
aC(a,b,c,d,e){var s=this.c,r=b*(this.a*s)+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)}},
ak(a,b,c,d,e,f){var s=this.c,r=b*(this.a*s)+a*s,q=this.d,p=B.b.h(c)
q.$flags&2&&A.a(q)
q[r]=p
if(s===2)q[r+1]=B.b.h(f)
else if(s>2){q[r+1]=B.b.h(d)
q[r+2]=B.b.h(e)
if(s>3)q[r+3]=B.b.h(f)}},
B(a){return"ImageDataUint8("+this.a+", "+this.b+", "+this.c+")"},
aO(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f=b==null?g:A.aB(b,g,B.e,g,g),e=h.c
if(e===1){s=f==null?0:B.a.I(A.z(f.gq()),0,255)
e=h.d
B.c.ao(e,0,e.length,s)}else if(e===2){e=f==null
s=e?0:B.a.I(A.z(f.gq()),0,255)
r=e?0:B.a.I(A.z(f.gt()),0,255)
q=J.mX(B.c.gA(h.d),0,null)
B.A.ao(q,0,q.length,(r<<8|s)>>>0)}else if(e===4){e=f==null
s=e?0:B.a.I(A.z(f.gq()),0,255)
p=e?0:B.a.I(A.z(f.gu()),0,255)
o=e?0:B.a.I(A.z(f.gv()),0,255)
r=e?0:B.a.I(A.z(f.gt()),0,255)
n=J.au(B.c.gA(h.d),0,null)
B.l.ao(n,0,n.length,(r<<24|o<<16|p<<8|s)>>>0)}else{e=f==null
s=e?0:B.a.I(A.z(f.gq()),0,255)
p=e?0:B.a.I(A.z(f.gu()),0,255)
o=e?0:B.a.I(A.z(f.gv()),0,255)
for(m=A.jx(h),e=m.d,l=e.c>0,e=e.d,k=e.$flags|0;m.E();){if(l){j=m.c
i=B.b.h(B.a.I(s,0,255))
k&2&&A.a(e)
e[j]=i}m.su(p)
m.sv(o)}}},
gR(){return this.e}}
A.e5.prototype={
a6(){return"Interpolation."+this.b}}
A.jv.prototype={}
A.h9.prototype={
O(){return new A.h9(new Uint16Array(A.t(this.c)),this.a,this.b)},
gJ(){return B.z},
gD(){return 1},
T(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=A.H(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b6(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=A.H(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=A.H(c)
if(q>2)s[a+2]=A.H(d)}},
b_(a,b){var s,r=this.b
if(b<r){r=this.c[a*r+b]
s=$.G
r=(s!=null?s:A.L())[r]}else r=0
return r},
aT(a){var s=this.c[a*this.b],r=$.G
return(r!=null?r:A.L())[s]},
aS(a){var s,r=this.b
if(r<2)return 0
r=this.c[a*r+1]
s=$.G
return(s!=null?s:A.L())[r]},
aR(a){var s,r=this.b
if(r<3)return 0
r=this.c[a*r+2]
s=$.G
return(s!=null?s:A.L())[r]},
aQ(a){var s,r=this.b
if(r<4)return 0
r=this.c[a*r+3]
s=$.G
return(s!=null?s:A.L())[r]},
bo(a,b){return this.T(a,0,b)},
bn(a,b){return this.T(a,1,b)},
bm(a,b){return this.T(a,2,b)},
bl(a,b){return this.T(a,3,b)}}
A.ha.prototype={
O(){return new A.ha(new Float32Array(A.t(this.c)),this.a,this.b)},
gJ(){return B.C},
gD(){return 1},
T(a,b,c){var s,r=this.b
if(b<r){s=this.c
s.$flags&2&&A.a(s)
s[a*r+b]=c}},
b6(a,b,c,d){var s,r=this.b
a*=r
s=this.c
s.$flags&2&&A.a(s)
s[a]=b
if(r>1){s[a+1]=c
if(r>2)s[a+2]=d}},
b_(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aT(a){return this.c[a*this.b]},
aS(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aR(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aQ(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bo(a,b){return this.T(a,0,b)},
bn(a,b){return this.T(a,1,b)},
bm(a,b){return this.T(a,2,b)},
bl(a,b){return this.T(a,3,b)}}
A.hb.prototype={
O(){return new A.hb(new Float64Array(A.t(this.c)),this.a,this.b)},
gJ(){return B.K},
gD(){return 1},
T(a,b,c){var s,r=this.b
if(b<r){s=this.c
s.$flags&2&&A.a(s)
s[a*r+b]=c}},
b6(a,b,c,d){var s,r=this.b
a*=r
s=this.c
s.$flags&2&&A.a(s)
s[a]=b
if(r>1){s[a+1]=c
if(r>2)s[a+2]=d}},
b_(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aT(a){return this.c[a*this.b]},
aS(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aR(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aQ(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bo(a,b){return this.T(a,0,b)},
bn(a,b){return this.T(a,1,b)},
bm(a,b){return this.T(a,2,b)},
bl(a,b){return this.T(a,3,b)}}
A.hc.prototype={
O(){return new A.hc(new Int16Array(A.t(this.c)),this.a,this.b)},
gJ(){return B.P},
gD(){return 32767},
T(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.a.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b6(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
b_(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aT(a){return this.c[a*this.b]},
aS(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aR(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aQ(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bo(a,b){return this.T(a,0,b)},
bn(a,b){return this.T(a,1,b)},
bm(a,b){return this.T(a,2,b)},
bl(a,b){return this.T(a,3,b)}}
A.hd.prototype={
O(){return new A.hd(new Int32Array(A.t(this.c)),this.a,this.b)},
gJ(){return B.Q},
gD(){return 2147483647},
T(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.a.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b6(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
b_(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aT(a){return this.c[a*this.b]},
aS(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aR(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aQ(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bo(a,b){return this.T(a,0,b)},
bn(a,b){return this.T(a,1,b)},
bm(a,b){return this.T(a,2,b)},
bl(a,b){return this.T(a,3,b)}}
A.he.prototype={
O(){return new A.he(new Int8Array(A.t(this.c)),this.a,this.b)},
gJ(){return B.O},
gD(){return 127},
T(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.a.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b6(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
b_(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aT(a){return this.c[a*this.b]},
aS(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aR(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aQ(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bo(a,b){return this.T(a,0,b)},
bn(a,b){return this.T(a,1,b)},
bm(a,b){return this.T(a,2,b)},
bl(a,b){return this.T(a,3,b)}}
A.hf.prototype={
O(){return new A.hf(new Uint16Array(A.t(this.c)),this.a,this.b)},
gJ(){return B.m},
gD(){return 65535},
T(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.a.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b6(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
b_(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aT(a){return this.c[a*this.b]},
aS(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aR(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aQ(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bo(a,b){return this.T(a,0,b)},
bn(a,b){return this.T(a,1,b)},
bm(a,b){return this.T(a,2,b)},
bl(a,b){return this.T(a,3,b)}}
A.hg.prototype={
O(){return new A.hg(new Uint32Array(A.t(this.c)),this.a,this.b)},
gJ(){return B.L},
gD(){return 4294967295},
T(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.a.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b6(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
b_(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aT(a){return this.c[a*this.b]},
aS(a){var s=this.b
if(s<2)return 0
return this.c[a*s+1]},
aR(a){var s=this.b
if(s<3)return 0
return this.c[a*s+2]},
aQ(a){var s=this.b
if(s<4)return 0
return this.c[a*s+3]},
bo(a,b){return this.T(a,0,b)},
bn(a,b){return this.T(a,1,b)},
bm(a,b){return this.T(a,2,b)},
bl(a,b){return this.T(a,3,b)}}
A.ba.prototype={
O(){return A.nF(this)},
gJ(){return B.e},
gD(){return 255},
T(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
r=B.a.h(c)
s.$flags&2&&A.a(s)
s[a*q+b]=r}},
b6(a,b,c,d){var s,r,q=this.b
a*=q
s=this.c
r=B.b.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.b.h(c)
if(q>2)s[a+2]=B.b.h(d)}},
cH(a,b,c,d,e){var s,r,q=this.b
a*=q
s=this.c
r=B.a.h(b)
s.$flags&2&&A.a(s)
s[a]=r
if(q>1){s[a+1]=B.a.h(c)
if(q>2){s[a+2]=B.a.h(d)
if(q>3)s[a+3]=B.a.h(e)}}},
b_(a,b){var s=this.b
return b<s?this.c[a*s+b]:0},
aT(a){var s
a*=this.b
s=this.c
if(a>=s.length)return 0
return s[a]},
aS(a){var s=this.b
if(s<2)return 0
a*=s
s=this.c
if(a>=s.length)return 0
return s[a+1]},
aR(a){var s=this.b
if(s<3)return 0
a*=s
s=this.c
if(a>=s.length)return 0
return s[a+2]},
aQ(a){var s=this.b
if(s<4)return 255
a*=s
s=this.c
if(a>=s.length)return 0
return s[a+3]},
bo(a,b){return this.T(a,0,b)},
bn(a,b){return this.T(a,1,b)},
bm(a,b){return this.T(a,2,b)},
bl(a,b){return this.T(a,3,b)}}
A.ca.prototype={
O(){var s=this
return new A.ca(s.a,s.b,s.c,s.d)},
gJ(){return B.z},
gp(a){return this.d.c},
gR(){return null},
gD(){return 1},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gK(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
k(a,b){var s,r=this.d
if(b<r.c){r=r.d[this.c+b]
s=$.G
r=(s!=null?s:A.L())[r]}else r=0
return r},
m(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=A.H(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gM(){return this.gq()},
sM(a){this.sq(a)},
gq(){var s,r=this.d
if(r.c>0){r=r.d[this.c]
s=$.G
r=(s!=null?s:A.L())[r]}else r=0
return r},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=A.H(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gu(){var s=this.d,r=s.c
if(r===2){s=s.d[this.c]
r=$.G
s=(r!=null?r:A.L())[s]}else if(r>1){s=s.d[this.c+1]
r=$.G
s=(r!=null?r:A.L())[s]}else s=0
return s},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=A.H(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=A.H(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gv(){var s=this.d,r=s.c
if(r===2){s=s.d[this.c]
r=$.G
s=(r!=null?r:A.L())[s]}else if(r>2){s=s.d[this.c+2]
r=$.G
s=(r!=null?r:A.L())[s]}else s=0
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=A.H(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=A.H(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gt(){var s=this.d,r=s.c
if(r===2){s=s.d[this.c+1]
r=$.G
s=(r!=null?r:A.L())[s]}else if(r>3){s=s.d[this.c+3]
r=$.G
s=(r!=null?r:A.L())[s]}else s=1
return s},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=A.H(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=A.H(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
gad(){return this.gq()/1},
sad(a){this.sq(a)},
ga9(){return this.gu()/1},
sa9(a){this.su(a)},
gac(){return this.gv()/1},
sac(a){this.sv(a)},
gV(){return this.gt()/1},
sV(a){this.st(a)},
gah(){return this.d.c===2?this.gq():A.X(this)},
aN(a){var s=this
if(s.d.c>0){s.sq(a.gq())
s.su(a.gu())
s.sv(a.gv())
s.st(a.gt())}},
aq(a,b,c){var s,r,q=this,p=q.d,o=p.c
if(o>0){p=p.d
s=q.c
r=A.H(a)
p.$flags&2&&A.a(p)
p[s]=r
if(o>2){p[q.c+1]=A.H(b)
p[q.c+2]=A.H(c)}}},
ag(a,b,c,d){var s,r,q=this,p=q.d,o=p.c
if(o>0){p=p.d
s=q.c
r=A.H(a)
p.$flags&2&&A.a(p)
p[s]=r
if(o===2)p[q.c+1]=A.H(d)
else if(o>2){p[q.c+1]=A.H(b)
p[q.c+2]=A.H(c)
if(o>3)p[q.c+3]=A.H(d)}}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ca){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=J.a6(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.k(b,0))return!1
if(q>1){if(r[p.c+1]!==s.k(b,1))return!1
if(q>2){if(r[p.c+2]!==s.k(b,2))return!1
if(q>3)if(r[p.c+3]!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.d}}
A.cb.prototype={
O(){var s=this
return new A.cb(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gR(){return null},
gD(){return 1},
gJ(){return B.C},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gK(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
k(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
m(a,b,c){var s,r=this.d
if(b<r.c){r=r.d
s=this.c
r.$flags&2&&A.a(r)
r[s+b]=c}},
gM(){return this.gq()},
sM(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
r.$flags&2&&A.a(r)
r[s]=a}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
su(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r]=a}else if(r>1){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+1]=a}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
sv(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r]=a}else if(r>2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+2]=a}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:1
return s},
st(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+1]=a}else if(r>3){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+3]=a}},
gad(){return this.gq()/1},
sad(a){this.sq(a)},
ga9(){return this.gu()/1},
sa9(a){this.su(a)},
gac(){return this.gv()/1},
sac(a){this.sv(a)},
gV(){return this.gt()/1},
sV(a){this.st(a)},
gah(){return this.d.c===2?this.gq():A.X(this)},
aN(a){var s=this
s.sq(a.gq())
s.su(a.gu())
s.sv(a.gv())
s.st(a.gt())},
aq(a,b,c){var s=this.d,r=s.d,q=this.c
r.$flags&2&&A.a(r)
r[q]=a
if(s.c>2){r[q+1]=b
r[q+2]=c}},
ag(a,b,c,d){var s=this.d,r=s.d,q=this.c
r.$flags&2&&A.a(r)
r[q]=a
s=s.c
if(s===2)r[q+1]=d
else if(s>2){r[q+1]=b
r[q+2]=c
if(s>3)r[q+3]=d}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cb){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=J.a6(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.k(b,0))return!1
if(q>1){if(r[p.c+1]!==s.k(b,1))return!1
if(q>2){if(r[p.c+2]!==s.k(b,2))return!1
if(q>3)if(r[p.c+3]!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.d}}
A.cc.prototype={
O(){var s=this
return new A.cc(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gR(){return null},
gD(){return 1},
gJ(){return B.K},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gK(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
k(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
m(a,b,c){var s,r=this.d
if(b<r.c){r=r.d
s=this.c
r.$flags&2&&A.a(r)
r[s+b]=c}},
gM(){return this.gq()},
sM(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
r.$flags&2&&A.a(r)
r[s]=a}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
su(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r]=a}else if(r>1){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+1]=a}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
sv(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r]=a}else if(r>2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+2]=a}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:1
return s},
st(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+1]=a}else if(r>3){s=s.d
r=this.c
s.$flags&2&&A.a(s)
s[r+3]=a}},
gad(){return this.gq()/1},
sad(a){this.sq(a)},
ga9(){return this.gu()/1},
sa9(a){this.su(a)},
gac(){return this.gv()/1},
sac(a){this.sv(a)},
gV(){return this.gt()/1},
sV(a){this.st(a)},
gah(){return this.d.c===2?this.gq():A.X(this)},
aN(a){var s=this
s.sq(a.gq())
s.su(a.gu())
s.sv(a.gv())
s.st(a.gt())},
aq(a,b,c){var s=this.d,r=s.d,q=this.c
r.$flags&2&&A.a(r)
r[q]=a
if(s.c>2){r[q+1]=b
r[q+2]=c}},
ag(a,b,c,d){var s=this.d,r=s.d,q=this.c
r.$flags&2&&A.a(r)
r[q]=a
s=s.c
if(s===2)r[q+1]=d
else if(s>2){r[q+1]=b
r[q+2]=c
if(s>3)r[q+3]=d}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cc){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=J.a6(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.k(b,0))return!1
if(q>1){if(r[p.c+1]!==s.k(b,1))return!1
if(q>2){if(r[p.c+2]!==s.k(b,2))return!1
if(q>3)if(r[p.c+3]!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.d}}
A.cd.prototype={
O(){var s=this
return new A.cd(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gR(){return null},
gD(){return 32767},
gJ(){return B.P},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gK(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
k(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
m(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gM(){return this.gq()},
sM(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:32767
return s},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
gad(){return this.gq()/32767},
sad(a){this.sq(a*32767)},
ga9(){return this.gu()/32767},
sa9(a){this.su(a*32767)},
gac(){return this.gv()/32767},
sac(a){this.sv(a*32767)},
gV(){return this.gt()/32767},
sV(a){this.st(a*32767)},
gah(){return this.d.c===2?this.gq():A.X(this)},
aN(a){var s=this
s.sq(a.gq())
s.su(a.gu())
s.sv(a.gv())
s.st(a.gt())},
aq(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ag(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cd){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=J.a6(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.k(b,0))return!1
if(q>1){if(r[p.c+1]!==s.k(b,1))return!1
if(q>2){if(r[p.c+2]!==s.k(b,2))return!1
if(q>3)if(r[p.c+3]!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.d}}
A.ce.prototype={
O(){var s=this
return new A.ce(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gR(){return null},
gD(){return 2147483647},
gJ(){return B.Q},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gK(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
k(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
m(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gM(){return this.gq()},
sM(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:2147483647
return s},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
gad(){return this.gq()/2147483647},
sad(a){this.sq(a*2147483647)},
ga9(){return this.gu()/2147483647},
sa9(a){this.su(a*2147483647)},
gac(){return this.gv()/2147483647},
sac(a){this.sv(a*2147483647)},
gV(){return this.gt()/2147483647},
sV(a){this.st(a*2147483647)},
gah(){return this.d.c===2?this.gq():A.X(this)},
aN(a){var s=this
s.sq(a.gq())
s.su(a.gu())
s.sv(a.gv())
s.st(a.gt())},
aq(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ag(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ce){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=J.a6(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.k(b,0))return!1
if(q>1){if(r[p.c+1]!==s.k(b,1))return!1
if(q>2){if(r[p.c+2]!==s.k(b,2))return!1
if(q>3)if(r[p.c+3]!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.d}}
A.cf.prototype={
O(){var s=this
return new A.cf(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gR(){return null},
gD(){return 127},
gJ(){return B.O},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gK(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
k(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
m(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gM(){return this.gq()},
sM(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:127
return s},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
gad(){return this.gq()/127},
sad(a){this.sq(a*127)},
ga9(){return this.gu()/127},
sa9(a){this.su(a*127)},
gac(){return this.gv()/127},
sac(a){this.sv(a*127)},
gV(){return this.gt()/127},
sV(a){this.st(a*127)},
gah(){return this.d.c===2?this.gq():A.X(this)},
aN(a){var s=this
s.sq(a.gq())
s.su(a.gu())
s.sv(a.gv())
s.st(a.gt())},
aq(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ag(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cf){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=J.a6(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.k(b,0))return!1
if(q>1){if(r[p.c+1]!==s.k(b,1))return!1
if(q>2){if(r[p.c+2]!==s.k(b,2))return!1
if(q>3)if(r[p.c+3]!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.d}}
A.jw.prototype={
E(){var s=this,r=s.a
if(r.gaZ()+1>s.d){r.a0(s.b,r.gaP()+1)
return r.gaP()<=s.e}return r.E()},
gK(){return this.a}}
A.cg.prototype={
O(){var s=this
return new A.cg(s.a,s.b,s.c,s.d,s.e,s.f)},
gp(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gR(){return this.f.f},
gD(){return this.f.gD()},
gJ(){return B.u},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.f
r=b*s.e
q.e=r
s=a*s.c
q.c=r+B.a.i(s,3)
q.d=s&7},
gK(){return this},
E(){var s,r=this,q=++r.a,p=r.f
if(q===p.a){r.a=0
q=++r.b
r.d=0;++r.c
r.e=r.e+p.e
return q<p.b}s=p.c
if(p.f!=null||s===1){if(++r.d>7){r.d=0;++r.c}}else{q*=s
r.d=q&7
r.c=r.e+B.a.i(q,3)}q=r.c
p=p.d
p===$&&A.b()
return q<p.byteLength},
dP(a){var s,r=this.c,q=7-(this.d+a)
if(q<0){q+=8;++r}s=this.f.d
s===$&&A.b()
if(r>=s.length)return 0
return B.a.Y(s[r],q)&1},
aV(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.dP(a):0
else s=r.b_(this.dP(0),a)
return s},
al(a,b){var s,r,q,p,o,n,m=this.f
if(a>=m.c)return
s=this.c
r=7-(this.d+a)
if(r<0){++s
r+=8}q=m.d
q===$&&A.b()
p=q[s]
o=B.a.I(B.b.h(b),0,1)
n=B.f8[r]
q=B.a.X(o,r)
m=m.d
m.$flags&2&&A.a(m)
m[s]=(p&n|q)>>>0},
k(a,b){return this.aV(b)},
m(a,b,c){return this.al(b,c)},
gM(){return this.dP(0)},
sM(a){this.al(0,a)},
gq(){return this.aV(0)},
sq(a){this.al(0,a)},
gu(){return this.f.c===2?this.aV(0):this.aV(1)},
su(a){this.al(this.f.c===2?0:1,a)},
gv(){return this.f.c===2?this.aV(0):this.aV(2)},
sv(a){this.al(this.f.c===2?0:2,a)},
gt(){var s=this.f,r=s.f==null
if(r&&s.c===2)s=this.aV(1)
else s=r&&s.c<4?s.gD():this.aV(3)
return s},
st(a){this.al(this.f.c===2?1:3,a)},
gad(){return this.aV(0)/this.f.gD()},
sad(a){this.al(0,a*this.f.gD())},
ga9(){return this.gu()/this.f.gD()},
sa9(a){var s=this.f,r=s.gD()
s=s.c===2?0:1
this.al(s,a*r)},
gac(){return this.gv()/this.f.gD()},
sac(a){var s=this.f,r=s.gD()
s=s.c===2?0:2
this.al(s,a*r)},
gV(){return this.gt()/this.f.gD()},
sV(a){var s=this.f,r=s.gD()
s=s.c===2?1:3
this.al(s,a*r)},
gah(){return this.f.c===2?this.aV(0):A.X(this)},
aN(a){var s,r,q=this
q.al(0,a.gq())
s=a.gu()
r=q.f.c===2
q.al(r?0:1,s)
s=a.gv()
q.al(r?0:2,s)
s=a.gt()
q.al(r?1:3,s)},
aq(a,b,c){var s=this,r=s.f.c
if(r>0){s.al(0,a)
if(r>2){s.al(1,b)
s.al(2,c)}}},
ag(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.al(0,a)
if(r===2)s.al(1,d)
else if(r>2){s.al(1,b)
s.al(2,c)
if(r>3)s.al(3,d)}}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cg){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.a6(b)
if(s.gp(b)!==q)return!1
if(p.aV(0)!==s.k(b,0))return!1
if(q>1){if(p.aV(1)!==s.k(b,1))return!1
if(q>2){if(p.aV(2)!==s.k(b,2))return!1
if(q>3)if(p.aV(3)!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.f}}
A.ch.prototype={
O(){var s=this
return new A.ch(s.a,s.b,s.c,s.d)},
gp(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gR(){return this.d.e},
gD(){return this.d.gD()},
gJ(){return B.m},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gK(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
bf(a){var s=this.d,r=s.e
if(r!=null)s=r.b_(s.d[this.c],a)
else s=a<s.c?s.d[this.c+a]:0
return s},
k(a,b){return this.bf(b)},
m(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gM(){return this.gq()},
sM(a){this.sq(a)},
gq(){var s=this.d,r=s.e
if(r==null)s=s.c>0?s.d[this.c]:0
else s=r.aT(s.d[this.c])
return s},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gu(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c]
else r=q>1?r.d[s.c+1]:0}else r=q.aS(r.d[s.c])
return r},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gv(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c]
else r=q>2?r.d[s.c+2]:0}else r=q.aR(r.d[s.c])
return r},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gt(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c+1]
else r=q>3?r.d[s.c+3]:r.gD()}else r=q.aQ(r.d[s.c])
return r},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
gad(){return this.gq()/this.d.gD()},
sad(a){this.sq(a*this.d.gD())},
ga9(){return this.gu()/this.d.gD()},
sa9(a){this.su(a*this.d.gD())},
gac(){return this.gv()/this.d.gD()},
sac(a){this.sv(a*this.d.gD())},
gV(){return this.gt()/this.d.gD()},
sV(a){this.st(a*this.d.gD())},
gah(){return this.d.c===2?this.gq():A.X(this)},
aN(a){var s=this
s.sq(a.gq())
s.su(a.gu())
s.sv(a.gv())
s.st(a.gt())},
aq(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ag(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ch){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.a6(b)
if(s.gp(b)!==q)return!1
if(p.bf(0)!==s.k(b,0))return!1
if(q>1){if(p.bf(1)!==s.k(b,1))return!1
if(q>2){if(p.bf(2)!==s.k(b,2))return!1
if(q>3)if(p.bf(3)!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.d}}
A.ci.prototype={
O(){var s=this
return new A.ci(s.a,s.b,s.c,s.d,s.e,s.f)},
gp(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gR(){return this.f.f},
gD(){return this.f.gD()},
gJ(){return B.x},
gfO(){var s=this.f
return s.f!=null?2:s.c<<1>>>0},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q,p=this
p.a=a
p.b=b
s=p.gfO()
r=b*p.f.e
p.e=r
q=a*s
p.c=r+B.a.i(q,3)
p.d=q&7},
gK(){return this},
E(){var s=this,r=++s.a,q=s.f
if(r===q.a){s.a=0
r=++s.b
s.d=0;++s.c
s.e=s.e+q.e
return r<q.b}if(q.f!=null||q.c===1){if((s.d+=2)>7){s.d=0;++s.c}}else{r*=s.gfO()
s.d=r&7
s.c=s.e+B.a.i(r,3)}r=s.c
q=q.d
q===$&&A.b()
return r<q.length},
dQ(a){var s,r=this.c,q=6-(this.d+(a<<1>>>0))
if(q<0){q+=8;++r}s=this.f.d
s===$&&A.b()
return B.a.Y(s[r],q)&3},
aW(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.dQ(a):0
else s=r.b_(this.dQ(0),a)
return s},
am(a,b){var s,r,q,p,o,n,m=this.f
if(a>=m.c)return
s=this.c
r=6-(this.d+(a<<1>>>0))
if(r<0){++s
r+=8}q=m.d
q===$&&A.b()
p=q[s]
o=B.a.I(B.b.h(b),0,3)
n=B.cW[B.a.i(r,1)]
q=B.a.X(o,r)
m=m.d
m.$flags&2&&A.a(m)
m[s]=(p&n|q)>>>0},
k(a,b){return this.aW(b)},
m(a,b,c){return this.am(b,c)},
gM(){return this.dQ(0)},
sM(a){this.am(0,a)},
gq(){return this.aW(0)},
sq(a){this.am(0,a)},
gu(){return this.f.c===2?this.aW(0):this.aW(1)},
su(a){this.am(this.f.c===2?0:1,a)},
gv(){return this.f.c===2?this.aW(0):this.aW(2)},
sv(a){this.am(this.f.c===2?0:2,a)},
gt(){var s=this.f,r=s.f==null
if(r&&s.c===2)s=this.aW(1)
else s=r&&s.c<4?s.gD():this.aW(3)
return s},
st(a){this.am(this.f.c===2?1:3,a)},
gad(){return this.aW(0)/this.f.gD()},
sad(a){this.am(0,a*this.f.gD())},
ga9(){return this.gu()/this.f.gD()},
sa9(a){var s=this.f,r=s.gD()
s=s.c===2?0:1
this.am(s,a*r)},
gac(){return this.gv()/this.f.gD()},
sac(a){var s=this.f,r=s.gD()
s=s.c===2?0:2
this.am(s,a*r)},
gV(){return this.gt()/this.f.gD()},
sV(a){var s=this.f,r=s.gD()
s=s.c===2?1:3
this.am(s,a*r)},
gah(){return this.f.c===2?this.aW(0):A.X(this)},
aN(a){var s,r,q=this
q.am(0,a.gq())
s=a.gu()
r=q.f.c===2
q.am(r?0:1,s)
s=a.gv()
q.am(r?0:2,s)
s=a.gt()
q.am(r?1:3,s)},
aq(a,b,c){var s=this,r=s.f.c
if(r>0){s.am(0,a)
if(r>2){s.am(1,b)
s.am(2,c)}}},
ag(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.am(0,a)
if(r===2)s.am(1,d)
else if(r>2){s.am(1,b)
s.am(2,c)
if(r>3)s.am(3,d)}}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ci){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.a6(b)
if(s.gp(b)!==q)return!1
if(p.aW(0)!==s.k(b,0))return!1
if(q>1){if(p.aW(1)!==s.k(b,1))return!1
if(q>2){if(p.aW(2)!==s.k(b,2))return!1
if(q>3)if(p.aW(3)!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.f}}
A.cj.prototype={
O(){var s=this
return new A.cj(s.a,s.b,s.c,s.d)},
gp(a){return this.d.c},
gR(){return null},
gD(){return 4294967295},
gJ(){return B.L},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gK(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
k(a,b){var s=this.d
return b<s.c?s.d[this.c+b]:0},
m(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(c)
q.$flags&2&&A.a(q)
q[s+b]=r}},
gM(){return this.gq()},
sM(a){this.sq(a)},
gq(){var s=this.d
return s.c>0?s.d[this.c]:0},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.a(q)
q[s]=r}},
gu(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>1?s.d[this.c+1]:0
return s},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}},
gv(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c]
else s=r>2?s.d[this.c+2]:0
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+2]=s}},
gt(){var s=this.d,r=s.c
if(r===2)s=s.d[this.c+1]
else s=r>3?s.d[this.c+3]:4294967295
return s},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.a(r)
r[q+3]=s}},
gad(){return this.gq()/4294967295},
sad(a){this.sq(a*4294967295)},
ga9(){return this.gu()/4294967295},
sa9(a){this.su(a*4294967295)},
gac(){return this.gv()/4294967295},
sac(a){this.sv(a*4294967295)},
gV(){return this.gt()/4294967295},
sV(a){this.st(a*4294967295)},
gah(){return this.d.c===2?this.gq():A.X(this)},
aN(a){var s=this
s.sq(a.gq())
s.su(a.gu())
s.sv(a.gv())
s.st(a.gt())},
aq(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ag(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cj){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=J.a6(b)
r=p.d
q=r.c
if(s.gp(b)!==q)return!1
r=r.d
if(r[p.c]!==s.k(b,0))return!1
if(q>1){if(r[p.c+1]!==s.k(b,1))return!1
if(q>2){if(r[p.c+2]!==s.k(b,2))return!1
if(q>3)if(r[p.c+3]!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.d}}
A.ck.prototype={
O(){var s=this
return new A.ck(s.a,s.b,s.c,s.d,s.e)},
gp(a){var s=this.e,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gR(){return this.e.f},
gD(){return this.e.gD()},
gJ(){return B.y},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q,p=this
p.a=a
p.b=b
s=p.e
r=s.c*4
q=s.e
if(r===4)s=b*q+B.a.i(a,1)
else if(r===8)s=b*s.a+a
else{s=b*q
s=r===16?s+(a<<1>>>0):s+B.a.i(a*r,3)}p.c=s
s=a*r
p.d=r>7?s&4:s&7},
gK(){return this},
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
dF(a){var s,r=this.c,q=4-(this.d+(a<<2>>>0))
if(q<0){q+=8;++r}s=this.e.d
s===$&&A.b()
return B.a.Y(s[r],q)&15},
aX(a){var s=this.e,r=s.f
if(r==null)s=s.c>a?this.dF(a):0
else s=r.b_(this.dF(0),a)
return s},
an(a,b){var s,r,q,p,o,n,m=this.e
if(a>=m.c)return
s=this.c
r=4-(this.d+(a<<2>>>0))
if(r<0){r+=8;++s}q=m.d
q===$&&A.b()
p=q[s]
o=B.a.I(B.b.h(b),0,15)
n=r===4?15:240
q=B.a.X(o,r)
m=m.d
m.$flags&2&&A.a(m)
m[s]=(p&n|q)>>>0},
k(a,b){return this.aX(b)},
m(a,b,c){return this.an(b,c)},
gM(){return this.dF(0)},
sM(a){this.an(0,a)},
gq(){return this.aX(0)},
sq(a){this.an(0,a)},
gu(){return this.e.c===2?this.aX(0):this.aX(1)},
su(a){this.an(this.e.c===2?0:1,a)},
gv(){return this.e.c===2?this.aX(0):this.aX(2)},
sv(a){this.an(this.e.c===2?0:2,a)},
gt(){var s=this.e,r=s.f==null
if(r&&s.c===2)s=this.aX(1)
else s=r&&s.c<4?s.gD():this.aX(3)
return s},
st(a){this.an(this.e.c===2?1:3,a)},
gad(){return this.aX(0)/this.e.gD()},
sad(a){this.an(0,a*this.e.gD())},
ga9(){return this.gu()/this.e.gD()},
sa9(a){var s=this.e,r=s.gD()
s=s.c===2?0:1
this.an(s,a*r)},
gac(){return this.gv()/this.e.gD()},
sac(a){var s=this.e,r=s.gD()
s=s.c===2?0:2
this.an(s,a*r)},
gV(){return this.gt()/this.e.gD()},
sV(a){var s=this.e,r=s.gD()
s=s.c===2?1:3
this.an(s,a*r)},
gah(){return this.e.c===2?this.aX(0):A.X(this)},
aN(a){var s,r,q=this
q.an(0,a.gq())
s=a.gu()
r=q.e.c===2
q.an(r?0:1,s)
s=a.gv()
q.an(r?0:2,s)
s=a.gt()
q.an(r?1:3,s)},
aq(a,b,c){var s=this,r=s.e.c
if(r>0){s.an(0,a)
if(r>2){s.an(1,b)
s.an(2,c)}}},
ag(a,b,c,d){var s=this,r=s.e.c
if(r>0){s.an(0,a)
if(r===2)s.an(1,d)
else if(r>2){s.an(1,b)
s.an(2,c)
if(r>3)s.an(3,d)}}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ck){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){q=p.e.c
s=J.a6(b)
if(s.gp(b)!==q)return!1
if(p.aX(0)!==s.k(b,0))return!1
if(q>1){if(p.aX(1)!==s.k(b,1))return!1
if(q>2){if(p.aX(2)!==s.k(b,2))return!1
if(q>3)if(p.aX(3)!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.e}}
A.cl.prototype={
O(){var s=this
return new A.cl(s.a,s.b,s.c,s.d)},
gp(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gR(){return this.d.e},
gD(){return this.d.gD()},
gJ(){return B.e},
gaZ(){return this.a},
gaP(){return this.b},
a0(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gK(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
bf(a){var s=this.d,r=s.e
if(r!=null)s=r.b_(s.d[this.c],a)
else s=a<s.c?s.d[this.c+a]:0
return s},
k(a,b){return this.bf(b)},
m(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c
r=B.b.h(B.b.I(c,0,255))
q.$flags&2&&A.a(q)
q[s+b]=r}},
gM(){return this.d.d[this.c]},
sM(a){var s=this.d.d,r=this.c,q=B.b.h(B.b.I(a,0,255))
s.$flags&2&&A.a(s)
s[r]=q},
gq(){var s=this.d,r=s.e
if(r==null)s=s.c>0?s.d[this.c]:0
else s=r.aT(s.d[this.c])
return s},
sq(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(B.b.I(a,0,255))
q.$flags&2&&A.a(q)
q[s]=r}},
gu(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c]
else r=q>1?r.d[s.c+1]:0}else r=q.aS(r.d[s.c])
return r},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q]=s}else if(q>1){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q+1]=s}},
gv(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c]
else r=q>2?r.d[s.c+2]:0}else r=q.aR(r.d[s.c])
return r},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q]=s}else if(q>2){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q+2]=s}},
gt(){var s=this,r=s.d,q=r.e
if(q==null){q=r.c
if(q===2)r=r.d[s.c+1]
else r=q>3?r.d[s.c+3]:255}else r=q.aQ(r.d[s.c])
return r},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q+1]=s}else if(q>3){r=r.d
q=this.c
s=B.b.h(B.b.I(a,0,255))
r.$flags&2&&A.a(r)
r[q+3]=s}},
gad(){return this.gq()/this.d.gD()},
sad(a){this.sq(a*this.d.gD())},
ga9(){return this.gu()/this.d.gD()},
sa9(a){this.su(a*this.d.gD())},
gac(){return this.gv()/this.d.gD()},
sac(a){this.sv(a*this.d.gD())},
gV(){return this.gt()/this.d.gD()},
sV(a){this.st(a*this.d.gD())},
gah(){return this.d.c===2?this.gq():A.X(this)},
aN(a){var s=this
if(s.d.e!=null)s.sM(a.gM())
else{s.sq(a.gq())
s.su(a.gu())
s.sv(a.gv())
s.st(a.gt())}},
aq(a,b,c){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)}}},
ag(a,b,c,d){var s,r,q=this.d,p=q.c
if(p>0){q=q.d
s=this.c
r=B.a.h(a)
q.$flags&2&&A.a(q)
q[s]=r
if(p===2)q[s+1]=B.a.h(d)
else if(p>2){q[s+1]=B.a.h(b)
q[s+2]=B.a.h(c)
if(p>3)q[s+3]=B.a.h(d)}}},
gG(a){return new A.P(this)},
P(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cl){s=A.o(p,A.i(p).n("d.E"))
s=A.l(s)
r=A.o(b,A.i(b).n("d.E"))
return s===A.l(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.a6(b)
if(s.gp(b)!==q)return!1
if(p.bf(0)!==s.k(b,0))return!1
if(q>1){if(p.bf(1)!==s.k(b,1))return!1
if(q>2){if(p.bf(2)!==s.k(b,2))return!1
if(q>3)if(p.bf(3)!==s.k(b,3))return!1}}return!0}return!1},
gH(a){var s=A.o(this,A.i(this).n("d.E"))
return A.l(s)},
b3(a){return A.aB(this,null,a,null,null)},
$iu:1,
$iw:1,
gb4(){return this.d}}
A.F.prototype={
O(){return new A.F()},
gb4(){return $.oU()},
gaZ(){return 0},
gaP(){return 0},
gp(a){return 0},
gD(){return 0},
gJ(){return B.e},
gR(){return null},
k(a,b){return 0},
m(a,b,c){},
gM(){return 0},
sM(a){},
gq(){return 0},
sq(a){},
gu(){return 0},
su(a){},
gv(){return 0},
sv(a){},
gt(){return 0},
st(a){},
gad(){return 0},
sad(a){},
ga9(){return 0},
sa9(a){},
gac(){return 0},
sac(a){},
gV(){return 0},
sV(a){},
gah(){return 0},
aN(a){},
aq(a,b,c){},
ag(a,b,c,d){},
a0(a,b){},
gK(){return this},
E(){return!1},
P(a,b){if(b==null)return!1
return b instanceof A.F},
gH(a){return 0},
gG(a){return new A.P(this)},
b3(a){return this},
$iu:1,
$iw:1}
A.l0.prototype={
hR(a,b){var s=this,r=a.a.gau(),q=s.b,p=(a.gZ()-1)*q,o=(a.gS()-1)*r,n=s.e
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
A.lj.prototype={
$1(a){return A.ow(a,this.a.a)},
$S:34}
A.iC.prototype={
a6(){return"FlipDirection."+this.b}}
A.fH.prototype={
B(a){return"ImageException: "+this.a}}
A.a8.prototype={
gp(a){return this.c-this.d},
m(a,b,c){J.W(this.a,this.d+b,c)
return c},
c9(a,b,c,d){var s=this.a,r=J.aC(s),q=this.d+a
if(c instanceof A.a8)r.a1(s,q,q+b,c.a,c.d+d)
else r.a1(s,q,q+b,t.L.a(c),d)},
d9(a,b,c){return this.c9(a,b,c,0)},
ld(a,b,c){var s=this.a,r=this.d+a
J.dD(s,r,r+b,c)},
dm(a,b,c){var s=this,r=c!=null?s.b+c:s.d
return A.q(s.a,s.e,a,r+b)},
ar(a){return this.dm(a,0,null)},
bQ(a,b){return this.dm(a,0,b)},
cI(a,b){return this.dm(a,b,null)},
F(){return J.c(this.a,this.d++)},
a7(a){var s=this.ar(a)
this.d=this.d+(s.c-s.d)
return s},
aj(a){var s,r,q,p,o,n=this
if(a==null){s=A.m([],t.t)
for(r=n.c;q=n.d,q<r;){p=n.a
n.d=q+1
o=J.c(p,q)
if(o===0)return A.eB(s,0,null)
s.push(o)}throw A.e(A.j("EOF reached without finding string terminator (length: "+A.x(a)+")"))}return A.eB(n.a7(a).U(),0,null)},
cz(){return this.aj(null)},
h6(a){var s,r,q,p,o=this,n=A.m([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.c(q,r)
n.push(p)
if(p===10||n.length>=a)return A.eB(n,0,null)}return A.eB(n,0,null)},
lk(){return this.h6(256)},
ll(){var s,r,q,p,o=this,n=A.m([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.c(q,r)
if(p===0)return new A.i5(!0).eO(n,0,null,!0)
n.push(p)}return B.c7.kM(n,!0)},
l(){var s=this,r=J.c(s.a,s.d++)&255,q=J.c(s.a,s.d++)&255
if(s.e)return r<<8|q
return q<<8|r},
bc(){var s=this,r=J.c(s.a,s.d++)&255,q=J.c(s.a,s.d++)&255,p=J.c(s.a,s.d++)&255
if(s.e)return p|q<<8|r<<16
return r|q<<8|p<<16},
j(){var s=this,r=J.c(s.a,s.d++)&255,q=J.c(s.a,s.d++)&255,p=J.c(s.a,s.d++)&255,o=J.c(s.a,s.d++)&255
if(s.e)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
de(){return A.ug(this.ef())},
ef(){var s=this,r=J.c(s.a,s.d++)&255,q=J.c(s.a,s.d++)&255,p=J.c(s.a,s.d++)&255,o=J.c(s.a,s.d++)&255,n=J.c(s.a,s.d++)&255,m=J.c(s.a,s.d++)&255,l=J.c(s.a,s.d++)&255,k=J.c(s.a,s.d++)&255
if(s.e)return(B.a.N(r,56)|B.a.N(q,48)|B.a.N(p,40)|B.a.N(o,32)|n<<24|m<<16|l<<8|k)>>>0
return(B.a.N(k,56)|B.a.N(l,48)|B.a.N(m,40)|B.a.N(n,32)|o<<24|p<<16|q<<8|r)>>>0},
ei(a,b,c){var s,r=this,q=r.a
if(t.D.b(q))return r.hc(b,c)
s=r.b+r.d+b
return J.lG(q,s,c<=0?r.c:s+c)},
hc(a,b){var s,r=this,q=b==null?r.c-r.d-a:b,p=r.a
if(t.D.b(p))return J.a2(B.c.gA(p),p.byteOffset+r.d+a,q)
s=r.d+a
s=new Uint8Array(A.t(J.lG(p,s,s+q)))
return s},
U(){return this.hc(0,null)},
dj(){var s=this.a
if(t.D.b(s))return J.au(B.c.gA(s),s.byteOffset+this.d,null)
return J.au(B.c.gA(this.U()),0,null)}}
A.jt.prototype={
C(a){var s,r=this,q=r.a
if(q===r.c.length)r.eZ(q+1)
q=r.c
s=r.a++
q.$flags&2&&A.a(q)
q[s]=a&255},
bt(a){var s,r=this,q=J.by(a),p=r.a+q
if(p>r.c.length)r.eZ(p)
p=r.c
s=r.a
B.c.aI(p,s,s+q,a)
r.a+=q},
aw(a){var s=this
if(s.b){s.C(B.a.i(a,8)&255)
s.C(a&255)
return}s.C(a&255)
s.C(B.a.i(a,8)&255)},
aH(a){var s=this
if(s.b){s.C(B.a.i(a,24)&255)
s.C(B.a.i(a,16)&255)
s.C(B.a.i(a,8)&255)
s.C(a&255)
return}s.C(a&255)
s.C(B.a.i(a,8)&255)
s.C(B.a.i(a,16)&255)
s.C(B.a.i(a,24)&255)},
lz(a){var s,r=this,q=new Float32Array(1)
q[0]=a
s=J.a2(B.M.gA(q),0,null)
if(r.b){r.C(s[3])
r.C(s[2])
r.C(s[1])
r.C(s[0])
return}r.C(s[0])
r.C(s[1])
r.C(s[2])
r.C(s[3])},
lA(a){var s,r=this,q=new Float64Array(1)
q[0]=a
s=J.a2(B.V.gA(q),0,null)
if(r.b){r.C(s[7])
r.C(s[6])
r.C(s[5])
r.C(s[4])
r.C(s[3])
r.C(s[2])
r.C(s[1])
r.C(s[0])
return}r.C(s[0])
r.C(s[1])
r.C(s[2])
r.C(s[3])
r.C(s[4])
r.C(s[5])
r.C(s[6])
r.C(s[7])},
eZ(a){var s=this.c,r=Math.max(s.length*3,a+8192),q=new Uint8Array(r)
B.c.aI(q,0,this.a,s)
this.c=q},
gp(a){return this.a}}
A.dh.prototype={
h(a){var s=this.b
return s===0?0:B.a.ab(this.a,s)},
P(a,b){if(b==null)return!1
return b instanceof A.dh&&this.a===b.a&&this.b===b.b},
gH(a){return A.lX(this.a,this.b,B.B,B.B)},
B(a){return""+this.a+"/"+this.b}}
A.ja.prototype={
ge3(){return this.a},
gec(){var s=this.c
return new A.bK(s,A.i(s).n("bK<1>"))},
e8(){var s=this.a
if(s.gfY())return
s.geq().bK(0,A.c8([B.ag,B.aT],t.M,t.gq))},
dl(a,b){var s=this.a
if(s.gfY())return
s.geq().bK(0,A.c8([B.ag,a],t.M,this.$ti.c))},
cG(a){var s=this.a
if(s.gfY())return
s.geq().bK(0,A.c8([B.ag,a],t.M,t.gg))},
$ij9:1}
A.d1.prototype={
ge3(){return this.a},
gec(){return A.Y(A.eD("onIsolateMessage is not implemented"))},
e8(){return A.Y(A.eD("initialized method is not implemented"))},
dl(a,b){return A.Y(A.eD("sendResult is not implemented"))},
cG(a){return A.Y(A.eD("sendResultError is not implemented"))},
c6(){var s=0,r=A.my(t.H),q=this
var $async$c6=A.mz(function(a,b){if(a===1)return A.mr(b,r)
for(;;)switch(s){case 0:q.a.terminate()
s=2
return A.mq(q.e.c6(),$async$c6)
case 2:return A.ms(null,r)}})
return A.mt($async$c6,r)},
j6(a){var s,r,q,p,o,n,m,l=this
try{s=t.fF.a(A.mE(a.data))
if(s==null)return
if(J.aK(s.k(0,"type"),"data")){r=s.k(0,"value")
if(t.F.b(A.m([],l.$ti.n("p<1>")))){n=r
if(n==null)n=A.ld(n)
r=A.fF(n,t.f)}l.e.bK(0,l.c.$1(r))
return}if(B.aT.h0(s)){n=l.r
if((n.a.a&30)===0)n.kK()
return}if(B.cz.h0(s)){l.c6()
return}if(J.aK(s.k(0,"type"),"$IsolateException")){q=A.pN(s)
l.e.e0(q,q.c)
return}l.e.kD(new A.ax("","Unhandled "+s.B(0)+" from the Isolate",B.J))}catch(m){p=A.ar(m)
o=A.b9(m)
l.e.e0(new A.ax("",p,o),o)}},
$ij9:1}
A.fX.prototype={
a6(){return"IsolatePort."+this.b}}
A.e6.prototype={
a6(){return"IsolateState."+this.b},
h0(a){return J.aK(a.k(0,"type"),"$IsolateState")&&J.aK(a.k(0,"value"),this.b)}}
A.fV.prototype={}
A.fW.prototype={}
A.hW.prototype={
hQ(a,b,c,d){this.a.onmessage=A.og(new A.kY(this,d))},
gec(){var s=this.c,r=A.i(s).n("bK<1>")
return new A.dG(new A.bK(s,r),r.n("@<b7.T>").aG(this.$ti.y[1]).n("dG<1,2>"))},
dl(a,b){var s=A.mJ(A.c8(["type","data","value",a instanceof A.M?a.gcc():a],t.N,t.X))
this.a.postMessage(s)},
cG(a){var s=t.N
this.a.postMessage(A.mJ(A.c8(["type","$IsolateException","name",a.gda(),"value",A.c8(["e",J.dE(a.b),"s",a.c.B(0)],s,s)],s,t.z)))},
e8(){var s=t.N
this.a.postMessage(A.mJ(A.c8(["type","$IsolateState","value","initialized"],s,s)))}}
A.kY.prototype={
$1(a){var s,r=A.mE(a.data),q=this.b
if(t.F.b(A.m([],q.n("p<0>")))){s=r==null?A.ld(r):r
r=A.fF(s,t.f)}this.a.c.bK(0,q.a(r))},
$S:36}
A.hV.prototype={}
A.lw.prototype={
$1(a){return this.hi(a)},
hi(a){var s=0,r=A.my(t.H),q=1,p=[],o=this,n,m,l,k,j,i,h
var $async$$1=A.mz(function(b,c){if(b===1){p.push(c)
s=q}for(;;)switch(s){case 0:q=3
k=o.a.$1(a)
j=o.d
s=6
return A.mq(j.n("bz<0>").b(k)?k:A.o_(k,j),$async$$1)
case 6:n=c
o.b.a.a.dl(n,null)
q=1
s=5
break
case 3:q=2
h=p.pop()
m=A.ar(h)
l=A.b9(h)
k=o.b.a
if(m instanceof A.ax)k.a.cG(m)
else k.a.cG(new A.ax("",m,l))
s=5
break
case 2:s=1
break
case 5:return A.ms(null,r)
case 1:return A.mr(p.at(-1),r)}})
return A.mt($async$$1,r)},
$S(){return this.c.n("bz<~>(0)")}}
A.iZ.prototype={}
A.ax.prototype={
B(a){return this.gda()+": "+A.x(this.b)+"\n"+this.c.B(0)},
gda(){return this.a}}
A.cp.prototype={
gda(){return"UnsupportedImTypeException"}}
A.M.prototype={
gcc(){return this.a},
P(a,b){var s,r=this
if(b==null)return!1
if(r!==b)s=A.i(r).n("M<M.T>").b(b)&&A.dB(r)===A.dB(b)&&J.aK(r.a,b.a)
else s=!0
return s},
gH(a){return J.av(this.a)},
B(a){return"ImType("+A.x(this.a)+")"}}
A.iT.prototype={
$1(a){return A.fF(a,t.f)},
$S:37}
A.iU.prototype={
$2(a,b){var s=t.f
return new A.az(A.fF(a,s),A.fF(b,s),t.dq)},
$S:38}
A.fD.prototype={
B(a){return"ImNum("+A.x(this.a)+")"}}
A.fE.prototype={
B(a){return"ImString("+this.a+")"}}
A.fC.prototype={
B(a){return"ImBool("+this.a+")"}}
A.dY.prototype={
P(a,b){var s
if(b==null)return!1
if(this!==b)s=b instanceof A.dY&&A.dB(this)===A.dB(b)&&this.jg(b.b)
else s=!0
return s},
gH(a){return A.l(this.b)},
jg(a){var s,r,q=this.b
if(q.gp(q)!==a.gp(a))return!1
s=q.gG(q)
r=a.gG(a)
for(;;){if(!(s.E()&&r.E()))break
if(!s.gK().P(0,r.gK()))return!1}return!0},
B(a){return"ImList("+this.b.B(0)+")"}}
A.dZ.prototype={
B(a){return"ImMap("+this.b.B(0)+")"}}
A.bu.prototype={
gcc(){return this.b.bN(0,new A.kW(this),A.i(this).n("bu.T"))}}
A.kW.prototype={
$1(a){return a.gcc()},
$S(){return A.i(this.a).n("bu.T(M<bu.T>)")}}
A.ap.prototype={
gcc(){var s=A.i(this)
return this.b.eb(0,new A.kX(this),s.n("ap.K"),s.n("ap.V"))},
P(a,b){var s
if(b==null)return!1
if(this!==b)s=b instanceof A.dZ&&A.dB(this)===A.dB(b)&&this.jh(b.b)
else s=!0
return s},
gH(a){var s=this.b
return A.l(new A.bi(s,A.i(s).n("bi<1,2>")))},
jh(a){var s,r,q=this.b
if(q.a!==a.a)return!1
for(q=new A.bi(q,A.i(q).n("bi<1,2>")).gG(0);q.E();){s=q.d
r=s.a
if(!a.a5(r)||!J.aK(a.k(0,r),s.b))return!1}return!0}}
A.kX.prototype={
$2(a,b){return new A.az(a.gcc(),b.gcc(),A.i(this.a).n("az<ap.K,ap.V>"))},
$S(){return A.i(this.a).n("az<ap.K,ap.V>(M<ap.K>,M<ap.V>)")}};(function aliases(){var s=J.bC.prototype
s.hs=s.B
s=A.E.prototype
s.eu=s.a1})();(function installTearOffs(){var s=hunkHelpers._instance_1u,r=hunkHelpers._static_1,q=hunkHelpers._static_0,p=hunkHelpers._static_2,o=hunkHelpers._instance_2u,n=hunkHelpers._instance_0u,m=hunkHelpers.installInstanceTearOff,l=hunkHelpers.installStaticTearOff
s(A.dH.prototype,"gjj","jk",46)
r(A,"tH","rh",9)
r(A,"tI","ri",9)
r(A,"tJ","rj",9)
q(A,"ov","tA",2)
r(A,"tK","tl",7)
p(A,"tM","tn",13)
q(A,"tL","tm",2)
o(A.R.prototype,"gi8","i9",13)
n(A.eP.prototype,"gjl","jm",2)
m(A.Z.prototype,"gbr",1,0,null,["$1","$0"],["a8","h"],4,0,0)
m(A.bg.prototype,"gbr",1,0,null,["$1","$0"],["a8","h"],4,0,0)
m(A.c3.prototype,"gbr",1,0,null,["$1","$0"],["a8","h"],4,0,0)
m(A.b2.prototype,"gbr",1,0,null,["$1","$0"],["a8","h"],4,0,0)
m(A.c_.prototype,"gbr",1,0,null,["$1","$0"],["a8","h"],4,0,0)
m(A.bA.prototype,"gbr",1,0,null,["$1","$0"],["a8","h"],4,0,0)
m(A.c2.prototype,"gbr",1,0,null,["$1","$0"],["a8","h"],4,0,0)
m(A.c0.prototype,"gbr",1,0,null,["$1","$0"],["a8","h"],4,0,0)
m(A.c1.prototype,"gbr",1,0,null,["$1","$0"],["a8","h"],4,0,0)
m(A.cR.prototype,"gbr",1,0,null,["$1","$0"],["a8","h"],4,0,0)
s(A.h0.prototype,"giq","ir",27)
var k
m(k=A.h2.prototype,"gis",0,3,null,["$3"],["it"],6,0,0)
m(k,"giv",0,3,null,["$3"],["iw"],6,0,0)
m(k,"gix",0,3,null,["$3"],["iy"],6,0,0)
m(k,"gij",0,3,null,["$3"],["ik"],6,0,0)
m(k,"gil",0,3,null,["$3"],["im"],6,0,0)
r(A,"uq","qG",0)
r(A,"uj","qy",0)
r(A,"uh","qw",0)
r(A,"uo","qE",0)
r(A,"up","qF",0)
r(A,"un","qD",0)
r(A,"um","qC",0)
r(A,"ul","qB",0)
r(A,"us","qI",0)
r(A,"ur","qH",0)
r(A,"uk","qz",0)
r(A,"ui","qx",0)
r(A,"uD","qT",0)
r(A,"uB","qR",0)
r(A,"ut","qJ",0)
r(A,"uv","qL",0)
r(A,"uu","qK",0)
r(A,"uw","qM",0)
r(A,"uE","qU",0)
r(A,"uC","qS",0)
r(A,"ux","qN",0)
r(A,"uy","qO",0)
r(A,"uz","qP",0)
r(A,"uA","qQ",0)
o(A.eI.prototype,"gjH","jI",11)
o(A.fS.prototype,"gkZ","l_",11)
l(A,"mL",3,null,["$3"],["qV"],3,0)
l(A,"uF",3,null,["$3"],["qW"],3,0)
l(A,"uK",3,null,["$3"],["r0"],3,0)
l(A,"uL",3,null,["$3"],["r1"],3,0)
l(A,"uM",3,null,["$3"],["r2"],3,0)
l(A,"uN",3,null,["$3"],["r3"],3,0)
l(A,"uO",3,null,["$3"],["r4"],3,0)
l(A,"uP",3,null,["$3"],["r5"],3,0)
l(A,"uQ",3,null,["$3"],["r6"],3,0)
l(A,"uR",3,null,["$3"],["r7"],3,0)
l(A,"uG",3,null,["$3"],["qX"],3,0)
l(A,"uH",3,null,["$3"],["qY"],3,0)
l(A,"uI",3,null,["$3"],["qZ"],3,0)
l(A,"uJ",3,null,["$3"],["r_"],3,0)
s(A.d1.prototype,"gj5","j6",35)
l(A,"u2",1,null,["$3","$1","$2"],["lQ",function(a){return A.lQ(a,B.J,"")},function(a,b){return A.lQ(a,b,"")}],42,0)
l(A,"u3",1,null,["$2","$1"],["nT",function(a){return A.nT(a,B.J)}],43,0)
l(A,"uT",6,null,["$6"],["re"],8,0)
l(A,"uU",6,null,["$6"],["rf"],8,0)
l(A,"uS",6,null,["$6"],["rd"],8,0)
l(A,"oy",1,null,["$1$3$customConverter$enableWasmConverter","$1","$1$1"],["mD",function(a){return A.mD(a,null,!0,t.z)},function(a,b){return A.mD(a,null,!0,b)}],45,0)
r(A,"ud","u7",30)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.n,null)
q(A.n,[A.lT,J.fM,A.ex,J.fb,A.b7,A.dH,A.T,A.E,A.jV,A.d,A.d6,A.h6,A.hK,A.hv,A.fq,A.dR,A.hC,A.k_,A.cL,A.bP,A.ds,A.bG,A.kc,A.js,A.dM,A.eZ,A.bD,A.jm,A.V,A.ag,A.h4,A.kF,A.i4,A.b6,A.hT,A.i3,A.l4,A.hL,A.aM,A.eM,A.hN,A.hO,A.dp,A.R,A.hM,A.hQ,A.kH,A.hZ,A.eP,A.i1,A.lc,A.hU,A.l_,A.hX,A.hY,A.fn,A.fi,A.i5,A.fo,A.kJ,A.h8,A.ez,A.kK,A.be,A.az,A.ad,A.f_,A.eA,A.fs,A.jr,A.iJ,A.fJ,A.iY,A.j0,A.ju,A.P,A.b1,A.hS,A.fr,A.aD,A.Z,A.bl,A.ik,A.bd,A.iq,A.dL,A.is,A.ft,A.iv,A.fu,A.fv,A.iA,A.dO,A.i_,A.dT,A.dU,A.cN,A.iP,A.fB,A.fk,A.bX,A.ji,A.jd,A.c5,A.h0,A.dr,A.i0,A.h1,A.jj,A.h2,A.kV,A.eu,A.jC,A.i2,A.bb,A.de,A.jI,A.dd,A.jN,A.hl,A.ho,A.ht,A.ew,A.df,A.hs,A.aQ,A.hw,A.k6,A.hx,A.ka,A.hy,A.kb,A.jp,A.kg,A.eH,A.kh,A.ko,A.kr,A.kt,A.eG,A.ks,A.ki,A.bI,A.hG,A.hI,A.hH,A.hJ,A.eI,A.hE,A.kp,A.hF,A.ku,A.eJ,A.fx,A.fy,A.dW,A.dV,A.dX,A.fz,A.dm,A.bf,A.jv,A.jw,A.l0,A.fH,A.a8,A.jt,A.dh,A.ja,A.d1,A.fV,A.hV,A.hW,A.iZ,A.ax,A.M])
q(J.fM,[J.fZ,J.e9,J.eb,J.d3,J.d4,J.ea,J.d2])
q(J.eb,[J.bC,J.p,A.d7,A.ej])
q(J.bC,[J.hh,J.eE,J.bh])
r(J.fY,A.ex)
r(J.jc,J.p)
q(J.ea,[J.e8,J.h_])
q(A.b7,[A.dG,A.du])
q(A.T,[A.d5,A.bq,A.h3,A.hB,A.hu,A.hR,A.fc,A.aY,A.eF,A.hA,A.bH,A.fl])
r(A.dj,A.E)
r(A.aN,A.dj)
q(A.d,[A.v,A.bj,A.eK,A.bo,A.eS,A.cA,A.cB,A.cC,A.cD,A.cE,A.cF,A.cG,A.cH,A.cI,A.cJ,A.cK,A.b_,A.dI,A.aw,A.ab,A.ca,A.cb,A.cc,A.cd,A.ce,A.cf,A.cg,A.ch,A.ci,A.cj,A.ck,A.cl,A.F])
q(A.v,[A.aF,A.bS,A.c7,A.jn,A.bi,A.eR])
q(A.aF,[A.eC,A.bk,A.ec])
r(A.bR,A.bj)
r(A.cM,A.bo)
q(A.bP,[A.io,A.j1,A.im,A.k1,A.lr,A.lt,A.kA,A.kz,A.le,A.kT,A.jY,A.lx,A.lz,A.lA,A.lm,A.ig,A.iB,A.jE,A.iW,A.iV,A.lj,A.kY,A.lw,A.iT,A.kW])
q(A.io,[A.ip,A.ls,A.lf,A.li,A.kU,A.jo,A.jq,A.iQ,A.iR,A.iS,A.iU,A.kX])
q(A.cL,[A.dK,A.bW])
q(A.bG,[A.dJ,A.eY])
r(A.dS,A.dJ)
r(A.e4,A.j1)
r(A.eo,A.bq)
q(A.k1,[A.jX,A.dF])
q(A.bD,[A.b3,A.eQ])
r(A.c6,A.b3)
q(A.ej,[A.h7,A.d8])
q(A.d8,[A.eU,A.eW])
r(A.eV,A.eU)
r(A.ei,A.eV)
r(A.eX,A.eW)
r(A.aG,A.eX)
q(A.ei,[A.ed,A.ee])
q(A.aG,[A.ef,A.eg,A.eh,A.ek,A.el,A.em,A.c9])
r(A.f0,A.hR)
q(A.im,[A.kB,A.kC,A.l5,A.kL,A.kP,A.kO,A.kN,A.kM,A.kS,A.kR,A.kQ,A.jZ,A.kE,A.kD,A.l1,A.l3,A.lh,A.la,A.l9,A.ij,A.ih,A.ii,A.iz,A.ix,A.iy,A.iI,A.iG,A.iH,A.iO,A.iN,A.iM,A.jg,A.jB,A.jz,A.jA,A.jG,A.jH,A.jF,A.jL,A.jM,A.jK,A.jU,A.jS,A.jT,A.k4,A.k5,A.k3,A.k8,A.k9,A.ky,A.kw,A.kx])
r(A.eN,A.du)
r(A.bK,A.eN)
r(A.eO,A.eM)
r(A.dn,A.eO)
r(A.eL,A.hN)
r(A.cs,A.hO)
q(A.hQ,[A.hP,A.kI])
r(A.l2,A.lc)
r(A.dq,A.eQ)
r(A.eT,A.eY)
q(A.fn,[A.l6,A.hD])
r(A.it,A.fi)
q(A.it,[A.jk,A.kf])
r(A.jl,A.l6)
q(A.aY,[A.bn,A.fI])
q(A.kJ,[A.e3,A.dt,A.fh,A.il,A.af,A.fe,A.aa,A.a9,A.bV,A.bU,A.b0,A.cP,A.je,A.d9,A.et,A.bE,A.bF,A.b5,A.an,A.co,A.a4,A.aS,A.cq,A.dl,A.fA,A.fw,A.e5,A.iC,A.fX,A.e6])
r(A.fa,A.be)
q(A.j0,[A.fK,A.fL])
q(A.ju,[A.kG,A.lY])
q(A.b_,[A.fj,A.bQ])
r(A.fm,A.dI)
r(A.bT,A.b1)
q(A.Z,[A.bg,A.bZ,A.c3,A.b2,A.c_,A.bA,A.c2,A.c0,A.c1,A.cS,A.cQ,A.cT,A.cR])
q(A.iq,[A.ff,A.iw,A.iF,A.iL,A.jf,A.jy,A.jD,A.jJ,A.jR,A.k2,A.k7,A.kv])
r(A.ir,A.ff)
r(A.j4,A.iv)
q(A.j4,[A.fN,A.j5,A.j6,A.j7,A.fP])
r(A.fO,A.dO)
r(A.fQ,A.dU)
r(A.iK,A.bd)
q(A.bX,[A.bY,A.cO])
r(A.jh,A.is)
r(A.fR,A.eu)
r(A.j8,A.jC)
r(A.cm,A.dL)
q(A.bb,[A.hj,A.hk,A.hm,A.hn,A.hq,A.hr])
q(A.de,[A.ev,A.hp])
q(A.ht,[A.dg,A.am])
r(A.fS,A.eI)
r(A.fT,A.eJ)
r(A.fU,A.dm)
q(A.ab,[A.cU,A.cV,A.e_,A.e0,A.e1,A.e2,A.cW,A.c4,A.cX,A.cY,A.cZ,A.d_])
q(A.jv,[A.h9,A.ha,A.hb,A.hc,A.hd,A.he,A.hf,A.hg,A.ba])
r(A.fW,A.hV)
r(A.cp,A.ax)
q(A.M,[A.fD,A.fE,A.fC,A.bu,A.ap])
r(A.dY,A.bu)
r(A.dZ,A.ap)
s(A.dj,A.hC)
s(A.eU,A.E)
s(A.eV,A.dR)
s(A.eW,A.E)
s(A.eX,A.dR)
s(A.hV,A.iZ)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{h:"int",J:"double",k:"num",a7:"String",aJ:"bool",ad:"Null",A:"List",n:"Object",ay:"Map",U:"JSObject"},mangledNames:{},types:["~(a8)","aw?()","~()","h(h,bs,h)","h([h])","dL?()","~(c5,d0,h)","~(@)","~(h,h,h,h,h,aH)","~(~())","ad(@)","~(h,aJ)","ad()","~(n,ah)","~(a7,aD)","@()","n?(n?)","~(n?,n?)","~(h,Z)","~(@,@)","bd?()","aw()","~(k,k,k,k)","ad(n,ah)","bs(h)","~(h,@)","cN?()","~(h)","ad(@,ah)","aJ(a7)","aH(aH)","dm?()","k(k,k,k,k)","k(k,k,k,k,k)","aJ(aw)","~(U)","ad(U)","M<n>(@)","az<M<n>,M<n>>(@,@)","ad(~())","@(a7)","@(@,a7)","ax(n[ah,a7])","cp(n[ah])","@(@)","0^(@{customConverter:0^(@)?,enableWasmConverter:aJ})<n?>","~(n?)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti")}
A.rB(v.typeUniverse,JSON.parse('{"hh":"bC","eE":"bC","bh":"bC","v0":"d7","fZ":{"aJ":[],"N":[]},"e9":{"N":[]},"eb":{"U":[]},"bC":{"U":[]},"p":{"A":["1"],"v":["1"],"U":[],"d":["1"],"ac":["1"]},"fY":{"ex":[]},"jc":{"p":["1"],"A":["1"],"v":["1"],"U":[],"d":["1"],"ac":["1"]},"ea":{"J":[],"k":[]},"e8":{"J":[],"h":[],"k":[],"N":[]},"h_":{"J":[],"k":[],"N":[]},"d2":{"a7":[],"ac":["@"],"N":[]},"dG":{"b7":["2"],"b7.T":"2"},"d5":{"T":[]},"aN":{"E":["h"],"A":["h"],"v":["h"],"d":["h"],"E.E":"h"},"v":{"d":["1"]},"aF":{"v":["1"],"d":["1"]},"eC":{"aF":["1"],"v":["1"],"d":["1"],"d.E":"1","aF.E":"1"},"bj":{"d":["2"],"d.E":"2"},"bR":{"bj":["1","2"],"v":["2"],"d":["2"],"d.E":"2"},"bk":{"aF":["2"],"v":["2"],"d":["2"],"d.E":"2","aF.E":"2"},"eK":{"d":["1"],"d.E":"1"},"bo":{"d":["1"],"d.E":"1"},"cM":{"bo":["1"],"v":["1"],"d":["1"],"d.E":"1"},"bS":{"v":["1"],"d":["1"],"d.E":"1"},"dj":{"E":["1"],"A":["1"],"v":["1"],"d":["1"]},"cL":{"ay":["1","2"]},"dK":{"cL":["1","2"],"ay":["1","2"]},"eS":{"d":["1"],"d.E":"1"},"bW":{"cL":["1","2"],"ay":["1","2"]},"dJ":{"bG":["1"],"ey":["1"],"v":["1"],"d":["1"]},"dS":{"bG":["1"],"ey":["1"],"v":["1"],"d":["1"]},"eo":{"bq":[],"T":[]},"h3":{"T":[]},"hB":{"T":[]},"eZ":{"ah":[]},"hu":{"T":[]},"b3":{"bD":["1","2"],"ay":["1","2"]},"c7":{"v":["1"],"d":["1"],"d.E":"1"},"jn":{"v":["1"],"d":["1"],"d.E":"1"},"bi":{"v":["az<1,2>"],"d":["az<1,2>"],"d.E":"az<1,2>"},"c6":{"b3":["1","2"],"bD":["1","2"],"ay":["1","2"]},"d7":{"U":[],"fg":[],"N":[]},"ej":{"U":[]},"i4":{"fg":[]},"h7":{"lI":[],"U":[],"N":[]},"d8":{"aE":["1"],"U":[],"ac":["1"]},"ei":{"E":["J"],"A":["J"],"aE":["J"],"v":["J"],"U":[],"ac":["J"],"d":["J"]},"aG":{"E":["h"],"A":["h"],"aE":["h"],"v":["h"],"U":[],"ac":["h"],"d":["h"]},"ed":{"iD":[],"E":["J"],"A":["J"],"aE":["J"],"v":["J"],"U":[],"ac":["J"],"d":["J"],"N":[],"E.E":"J"},"ee":{"iE":[],"E":["J"],"A":["J"],"aE":["J"],"v":["J"],"U":[],"ac":["J"],"d":["J"],"N":[],"E.E":"J"},"ef":{"aG":[],"d0":[],"E":["h"],"A":["h"],"aE":["h"],"v":["h"],"U":[],"ac":["h"],"d":["h"],"N":[],"E.E":"h"},"eg":{"aG":[],"j2":[],"E":["h"],"A":["h"],"aE":["h"],"v":["h"],"U":[],"ac":["h"],"d":["h"],"N":[],"E.E":"h"},"eh":{"aG":[],"j3":[],"E":["h"],"A":["h"],"aE":["h"],"v":["h"],"U":[],"ac":["h"],"d":["h"],"N":[],"E.E":"h"},"ek":{"aG":[],"hz":[],"E":["h"],"A":["h"],"aE":["h"],"v":["h"],"U":[],"ac":["h"],"d":["h"],"N":[],"E.E":"h"},"el":{"aG":[],"bs":[],"E":["h"],"A":["h"],"aE":["h"],"v":["h"],"U":[],"ac":["h"],"d":["h"],"N":[],"E.E":"h"},"em":{"aG":[],"ke":[],"E":["h"],"A":["h"],"aE":["h"],"v":["h"],"U":[],"ac":["h"],"d":["h"],"N":[],"E.E":"h"},"c9":{"aG":[],"aH":[],"E":["h"],"A":["h"],"aE":["h"],"v":["h"],"U":[],"ac":["h"],"d":["h"],"N":[],"E.E":"h"},"hR":{"T":[]},"f0":{"bq":[],"T":[]},"aM":{"T":[]},"bK":{"du":["1"],"b7":["1"],"b7.T":"1"},"dn":{"eM":["1"]},"eL":{"hN":["1"]},"cs":{"hO":["1"]},"R":{"bz":["1"]},"eN":{"du":["1"],"b7":["1"]},"eO":{"eM":["1"]},"du":{"b7":["1"]},"eQ":{"bD":["1","2"],"ay":["1","2"]},"dq":{"eQ":["1","2"],"bD":["1","2"],"ay":["1","2"]},"eR":{"v":["1"],"d":["1"],"d.E":"1"},"eT":{"eY":["1"],"bG":["1"],"ey":["1"],"v":["1"],"d":["1"]},"E":{"A":["1"],"v":["1"],"d":["1"]},"bD":{"ay":["1","2"]},"ec":{"aF":["1"],"v":["1"],"d":["1"],"d.E":"1","aF.E":"1"},"bG":{"ey":["1"],"v":["1"],"d":["1"]},"eY":{"bG":["1"],"ey":["1"],"v":["1"],"d":["1"]},"J":{"k":[]},"h":{"k":[]},"A":{"v":["1"],"d":["1"]},"ey":{"v":["1"],"d":["1"]},"fc":{"T":[]},"bq":{"T":[]},"aY":{"T":[]},"bn":{"T":[]},"fI":{"bn":[],"T":[]},"eF":{"T":[]},"hA":{"T":[]},"bH":{"T":[]},"fl":{"T":[]},"h8":{"T":[]},"ez":{"T":[]},"f_":{"ah":[]},"cA":{"u":[],"d":["k"],"d.E":"k"},"cB":{"u":[],"d":["k"],"d.E":"k"},"cC":{"u":[],"d":["k"],"d.E":"k"},"cD":{"u":[],"d":["k"],"d.E":"k"},"cE":{"u":[],"d":["k"],"d.E":"k"},"cF":{"u":[],"d":["k"],"d.E":"k"},"cG":{"u":[],"d":["k"],"d.E":"k"},"cH":{"u":[],"d":["k"],"d.E":"k"},"cI":{"u":[],"d":["k"],"d.E":"k"},"cJ":{"u":[],"d":["k"],"d.E":"k"},"cK":{"u":[],"d":["k"],"d.E":"k"},"b_":{"u":[],"d":["k"],"d.E":"k"},"fj":{"u":[],"d":["k"],"d.E":"k"},"bQ":{"u":[],"d":["k"],"d.E":"k"},"dI":{"u":[],"d":["k"],"d.E":"k"},"fm":{"u":[],"d":["k"],"d.E":"k"},"bg":{"Z":[]},"bZ":{"Z":[]},"c3":{"Z":[]},"b2":{"Z":[]},"c_":{"Z":[]},"bA":{"Z":[]},"c2":{"Z":[]},"c0":{"Z":[]},"c1":{"Z":[]},"cS":{"Z":[]},"cQ":{"Z":[]},"cT":{"Z":[]},"cR":{"Z":[]},"fO":{"dO":[]},"fQ":{"dU":[]},"bY":{"bX":[]},"cO":{"bX":[]},"fR":{"eu":[]},"hj":{"bb":[]},"hk":{"bb":[]},"hm":{"bb":[]},"hn":{"bb":[]},"hq":{"bb":[]},"hr":{"bb":[]},"ev":{"de":[]},"hp":{"de":[]},"fT":{"eJ":[]},"aw":{"d":["w"],"d.E":"w"},"ab":{"d":["w"]},"cU":{"ab":[],"d":["w"],"d.E":"w"},"cV":{"ab":[],"d":["w"],"d.E":"w"},"e_":{"ab":[],"d":["w"],"d.E":"w"},"e0":{"ab":[],"d":["w"],"d.E":"w"},"e1":{"ab":[],"d":["w"],"d.E":"w"},"e2":{"ab":[],"d":["w"],"d.E":"w"},"cW":{"ab":[],"d":["w"],"d.E":"w"},"c4":{"ab":[],"d":["w"],"d.E":"w"},"cX":{"ab":[],"d":["w"],"d.E":"w"},"cY":{"ab":[],"d":["w"],"d.E":"w"},"cZ":{"ab":[],"d":["w"],"d.E":"w"},"d_":{"ab":[],"d":["w"],"d.E":"w"},"ca":{"w":[],"u":[],"d":["k"],"d.E":"k"},"cb":{"w":[],"u":[],"d":["k"],"d.E":"k"},"cc":{"w":[],"u":[],"d":["k"],"d.E":"k"},"cd":{"w":[],"u":[],"d":["k"],"d.E":"k"},"ce":{"w":[],"u":[],"d":["k"],"d.E":"k"},"cf":{"w":[],"u":[],"d":["k"],"d.E":"k"},"cg":{"w":[],"u":[],"d":["k"],"d.E":"k"},"ch":{"w":[],"u":[],"d":["k"],"d.E":"k"},"ci":{"w":[],"u":[],"d":["k"],"d.E":"k"},"cj":{"w":[],"u":[],"d":["k"],"d.E":"k"},"ck":{"w":[],"u":[],"d":["k"],"d.E":"k"},"cl":{"w":[],"u":[],"d":["k"],"d.E":"k"},"F":{"w":[],"u":[],"d":["k"],"d.E":"k"},"ja":{"j9":["1","2"]},"d1":{"j9":["1","2"]},"cp":{"ax":[]},"fD":{"M":["k"],"M.T":"k"},"fE":{"M":["a7"],"M.T":"a7"},"fC":{"M":["aJ"],"M.T":"aJ"},"dY":{"bu":["n"],"M":["d<n>"],"bu.T":"n","M.T":"d<n>"},"dZ":{"ap":["n","n"],"M":["ay<n,n>"],"ap.K":"n","ap.V":"n","M.T":"ay<n,n>"},"bu":{"M":["d<1>"]},"ap":{"M":["ay<1,2>"]},"j3":{"A":["h"],"v":["h"],"d":["h"]},"aH":{"A":["h"],"v":["h"],"d":["h"]},"ke":{"A":["h"],"v":["h"],"d":["h"]},"d0":{"A":["h"],"v":["h"],"d":["h"]},"hz":{"A":["h"],"v":["h"],"d":["h"]},"j2":{"A":["h"],"v":["h"],"d":["h"]},"bs":{"A":["h"],"v":["h"],"d":["h"]},"iD":{"A":["J"],"v":["J"],"d":["J"]},"iE":{"A":["J"],"v":["J"],"d":["J"]},"w":{"u":[],"d":["k"]}}'))
A.rA(v.typeUniverse,JSON.parse('{"dR":1,"hC":1,"dj":1,"dJ":1,"d8":1,"eN":1,"eO":1,"hQ":1,"fi":2,"fn":2,"ht":1}'))
var u={c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",h:"handleError callback must take either an Object (the error), or both an Object (the error) and a StackTrace."}
var t=(function rtii(){var s=A.S
return{dI:s("fg"),fd:s("lI"),G:s("u"),R:s("v<@>"),C:s("T"),aX:s("ft"),fe:s("bV"),gV:s("fv"),B:s("iD"),gN:s("iE"),b8:s("uX"),ct:s("dV"),gj:s("fx"),ak:s("fy"),fa:s("dW"),gx:s("fB"),P:s("aD"),r:s("Z"),f:s("M<n>"),v:s("ab"),cV:s("c4"),W:s("d0"),an:s("j2"),cu:s("j3"),U:s("j9<@,@>"),gg:s("ax"),M:s("fX"),gq:s("e6"),Y:s("d<@>"),eB:s("p<fk>"),g9:s("p<fu>"),dw:s("p<dO>"),b:s("p<dU>"),Z:s("p<dV>"),g:s("p<aw>"),b7:s("p<c5>"),_:s("p<A<A<A<h>>>>"),o:s("p<A<A<h>>>"),cJ:s("p<A<aH>>"),S:s("p<A<h>>"),dm:s("p<eu>"),c:s("p<dd>"),af:s("p<bb>"),l:s("p<ho>"),s:s("p<a7>"),aU:s("p<hy>"),h:s("p<aH>"),ao:s("p<bI>"),d:s("p<hF>"),J:s("p<eJ>"),gn:s("p<hS>"),e8:s("p<dr>"),cO:s("p<@>"),t:s("p<h>"),f8:s("p<h1?>"),hh:s("p<bs?>"),A:s("p<~(a8)>"),aP:s("ac<@>"),T:s("e9"),m:s("U"),e:s("bh"),eA:s("aE<@>"),d2:s("c5"),ha:s("ec<a7>"),F:s("A<M<n>>"),c7:s("A<eG>"),e6:s("A<bI>"),j:s("A<@>"),L:s("A<h>"),dq:s("az<M<n>,M<n>>"),O:s("ay<@,@>"),bc:s("aG"),bm:s("c9"),a:s("ad"),K:s("n"),dv:s("w"),fW:s("dd"),fh:s("hl"),cE:s("ev"),hf:s("de"),fi:s("ew"),a7:s("df"),fL:s("bn"),i:s("dh"),gT:s("v2"),gm:s("ah"),N:s("a7"),a4:s("hx"),ci:s("N"),eK:s("bq"),h7:s("hz"),w:s("bs"),go:s("ke"),D:s("aH"),bI:s("eE"),dd:s("eG"),fD:s("bI"),ai:s("hG"),cP:s("hH"),dE:s("hJ"),cc:s("eK<a7>"),ez:s("cs<~>"),eI:s("R<@>"),fJ:s("R<h>"),q:s("R<~>"),x:s("dq<n?,n?>"),eO:s("i_"),y:s("aJ"),V:s("J"),z:s("@"),E:s("@(n)"),Q:s("@(n,ah)"),p:s("h"),eH:s("bz<ad>?"),en:s("bX?"),bC:s("d0?"),bX:s("U?"),eC:s("A<bX?>?"),fF:s("ay<@,@>?"),X:s("n?"),dk:s("a7?"),aD:s("aH?"),eW:s("eH?"),dP:s("hI?"),fQ:s("aJ?"),cD:s("J?"),I:s("h?"),cg:s("k?"),n:s("k"),H:s("~"),u:s("~(n)"),k:s("~(n,ah)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.cw=J.fM.prototype
B.k=J.p.prototype
B.a=J.e8.prototype
B.b=J.ea.prototype
B.E=J.d2.prototype
B.cA=J.bh.prototype
B.cB=J.eb.prototype
B.M=A.ed.prototype
B.V=A.ee.prototype
B.N=A.ef.prototype
B.G=A.eg.prototype
B.W=A.eh.prototype
B.A=A.ek.prototype
B.l=A.el.prototype
B.c=A.c9.prototype
B.bu=J.hh.prototype
B.aw=J.eE.prototype
B.a2=new A.fe(0,"direct")
B.ac=new A.fe(1,"alpha")
B.az=new A.a9(0,"none")
B.ad=new A.a9(3,"bitfields")
B.ae=new A.a9(6,"alphaBitfields")
B.a3=new A.fh(0,"littleEndian")
B.aA=new A.fh(1,"bigEndian")
B.c_=new A.fq(A.S("fq<0&>"))
B.aB=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.c0=function() {
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
B.c5=function(getTagFallback) {
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
B.c1=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.c4=function(hooks) {
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
B.c3=function(hooks) {
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
B.c2=function(hooks) {
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
B.aC=function(hooks) { return hooks; }

B.aD=new A.jk()
B.c6=new A.h8()
B.B=new A.jV()
B.c7=new A.kf()
B.c8=new A.kH()
B.c9=new A.i0()
B.p=new A.l2()
B.aE=new A.i2()
B.aF=new A.il(4,"luminance")
B.ca=new A.fm(4294967295)
B.cb=new A.bU(0,"red")
B.cc=new A.bU(1,"green")
B.cd=new A.bU(2,"blue")
B.ce=new A.bU(3,"alpha")
B.cf=new A.bU(4,"other")
B.aG=new A.bV(1,"half")
B.aH=new A.bV(2,"float")
B.aI=new A.b0(0,"none")
B.co=new A.iC(2,"both")
B.cp=new A.be("Invalid Huffman code length",null,null)
B.cq=new A.be("Incomplete Huffman table",null,null)
B.cr=new A.be("Oversubscribed Huffman table",null,null)
B.u=new A.af(0,"uint1")
B.x=new A.af(1,"uint2")
B.C=new A.af(10,"float32")
B.K=new A.af(11,"float64")
B.y=new A.af(2,"uint4")
B.e=new A.af(3,"uint8")
B.m=new A.af(4,"uint16")
B.L=new A.af(5,"uint32")
B.O=new A.af(6,"int8")
B.P=new A.af(7,"int16")
B.Q=new A.af(8,"int32")
B.z=new A.af(9,"float16")
B.aJ=new A.fw(1,"page")
B.i=new A.fw(2,"sequence")
B.R=new A.fA(0,"none")
B.cs=new A.fA(1,"deflate")
B.aK=new A.cP(2,"cur")
B.d=new A.aa(0,"none")
B.aL=new A.aa(1,"byte")
B.aM=new A.aa(10,"sRational")
B.aN=new A.aa(11,"single")
B.aO=new A.aa(12,"double")
B.aP=new A.aa(13,"ifd")
B.j=new A.aa(2,"ascii")
B.h=new A.aa(3,"short")
B.n=new A.aa(4,"long")
B.q=new A.aa(5,"rational")
B.aQ=new A.aa(6,"sByte")
B.D=new A.aa(7,"undefined")
B.aR=new A.aa(8,"sShort")
B.aS=new A.aa(9,"sLong")
B.af=new A.e3(0,"gzip")
B.S=new A.e3(1,"zlib")
B.cv=new A.e3(2,"raw")
B.X=new A.e5(0,"nearest")
B.cx=new A.e5(1,"linear")
B.cy=new A.e5(3,"average")
B.ag=new A.fX(0,"main")
B.cz=new A.e6(0,"dispose")
B.aT=new A.e6(1,"initialized")
B.aU=new A.je(0,"yuv444")
B.cC=new A.jl(!1)
B.ah=s([0,2,8],t.t)
B.cD=s([0,4,2,1],t.t)
B.ct=new A.cP(0,"invalid")
B.cu=new A.cP(1,"ico")
B.cF=s([B.ct,B.cu,B.aK],A.S("p<cP>"))
B.cW=s([252,243,207,63],t.t)
B.jz=new A.d9(0,"none")
B.bx=new A.d9(1,"background")
B.by=new A.d9(2,"previous")
B.cX=s([B.jz,B.bx,B.by],A.S("p<d9>"))
B.aW=s([292,260,226,226],t.t)
B.aX=s([0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,125],t.t)
B.d_=s([2,3,7],t.t)
B.aY=s([3226,6412,200,168,38,38,134,134,100,100,100,100,68,68,68,68],t.t)
B.d8=s([3,3,11],t.t)
B.am=s([128,128,128,128,128,128,128,128,128,128,128],t.t)
B.b_=s([B.am,B.am,B.am],t.S)
B.dW=s([253,136,254,255,228,219,128,128,128,128,128],t.t)
B.eV=s([189,129,242,255,227,213,255,219,128,128,128],t.t)
B.f_=s([106,126,227,252,214,209,255,255,128,128,128],t.t)
B.hv=s([B.dW,B.eV,B.f_],t.S)
B.hC=s([1,98,248,255,236,226,255,255,128,128,128],t.t)
B.de=s([181,133,238,254,221,234,255,154,128,128,128],t.t)
B.dc=s([78,134,202,247,198,180,255,219,128,128,128],t.t)
B.i0=s([B.hC,B.de,B.dc],t.S)
B.dR=s([1,185,249,255,243,255,128,128,128,128,128],t.t)
B.hz=s([184,150,247,255,236,224,128,128,128,128,128],t.t)
B.iS=s([77,110,216,255,236,230,128,128,128,128,128],t.t)
B.h0=s([B.dR,B.hz,B.iS],t.S)
B.h8=s([1,101,251,255,241,255,128,128,128,128,128],t.t)
B.dU=s([170,139,241,252,236,209,255,255,128,128,128],t.t)
B.he=s([37,116,196,243,228,255,255,255,128,128,128],t.t)
B.dD=s([B.h8,B.dU,B.he],t.S)
B.fc=s([1,204,254,255,245,255,128,128,128,128,128],t.t)
B.j9=s([207,160,250,255,238,128,128,128,128,128,128],t.t)
B.j8=s([102,103,231,255,211,171,128,128,128,128,128],t.t)
B.ei=s([B.fc,B.j9,B.j8],t.S)
B.dv=s([1,152,252,255,240,255,128,128,128,128,128],t.t)
B.je=s([177,135,243,255,234,225,128,128,128,128,128],t.t)
B.fV=s([80,129,211,255,194,224,128,128,128,128,128],t.t)
B.hu=s([B.dv,B.je,B.fV],t.S)
B.b2=s([1,1,255,128,128,128,128,128,128,128,128],t.t)
B.hR=s([246,1,255,128,128,128,128,128,128,128,128],t.t)
B.fD=s([255,128,128,128,128,128,128,128,128,128,128],t.t)
B.jp=s([B.b2,B.hR,B.fD],t.S)
B.eb=s([B.b_,B.hv,B.i0,B.h0,B.dD,B.ei,B.hu,B.jp],t.o)
B.iV=s([198,35,237,223,193,187,162,160,145,155,62],t.t)
B.dV=s([131,45,198,221,172,176,220,157,252,221,1],t.t)
B.iU=s([68,47,146,208,149,167,221,162,255,223,128],t.t)
B.fm=s([B.iV,B.dV,B.iU],t.S)
B.i1=s([1,149,241,255,221,224,255,255,128,128,128],t.t)
B.ih=s([184,141,234,253,222,220,255,199,128,128,128],t.t)
B.fz=s([81,99,181,242,176,190,249,202,255,255,128],t.t)
B.iF=s([B.i1,B.ih,B.fz],t.S)
B.iw=s([1,129,232,253,214,197,242,196,255,255,128],t.t)
B.j4=s([99,121,210,250,201,198,255,202,128,128,128],t.t)
B.hw=s([23,91,163,242,170,187,247,210,255,255,128],t.t)
B.fF=s([B.iw,B.j4,B.hw],t.S)
B.ey=s([1,200,246,255,234,255,128,128,128,128,128],t.t)
B.it=s([109,178,241,255,231,245,255,255,128,128,128],t.t)
B.cY=s([44,130,201,253,205,192,255,255,128,128,128],t.t)
B.iK=s([B.ey,B.it,B.cY],t.S)
B.dn=s([1,132,239,251,219,209,255,165,128,128,128],t.t)
B.cG=s([94,136,225,251,218,190,255,255,128,128,128],t.t)
B.iy=s([22,100,174,245,186,161,255,199,128,128,128],t.t)
B.h6=s([B.dn,B.cG,B.iy],t.S)
B.ig=s([1,182,249,255,232,235,128,128,128,128,128],t.t)
B.ho=s([124,143,241,255,227,234,128,128,128,128,128],t.t)
B.eS=s([35,77,181,251,193,211,255,205,128,128,128],t.t)
B.f1=s([B.ig,B.ho,B.eS],t.S)
B.jq=s([1,157,247,255,236,231,255,255,128,128,128],t.t)
B.ea=s([121,141,235,255,225,227,255,255,128,128,128],t.t)
B.iu=s([45,99,188,251,195,217,255,224,128,128,128],t.t)
B.dB=s([B.jq,B.ea,B.iu],t.S)
B.cH=s([1,1,251,255,213,255,128,128,128,128,128],t.t)
B.d2=s([203,1,248,255,255,128,128,128,128,128,128],t.t)
B.ii=s([137,1,177,255,224,255,128,128,128,128,128],t.t)
B.dw=s([B.cH,B.d2,B.ii],t.S)
B.i8=s([B.fm,B.iF,B.fF,B.iK,B.h6,B.f1,B.dB,B.dw],t.o)
B.em=s([253,9,248,251,207,208,255,192,128,128,128],t.t)
B.hS=s([175,13,224,243,193,185,249,198,255,255,128],t.t)
B.jo=s([73,17,171,221,161,179,236,167,255,234,128],t.t)
B.hK=s([B.em,B.hS,B.jo],t.S)
B.i5=s([1,95,247,253,212,183,255,255,128,128,128],t.t)
B.fM=s([239,90,244,250,211,209,255,255,128,128,128],t.t)
B.iR=s([155,77,195,248,188,195,255,255,128,128,128],t.t)
B.ie=s([B.i5,B.fM,B.iR],t.S)
B.fe=s([1,24,239,251,218,219,255,205,128,128,128],t.t)
B.hV=s([201,51,219,255,196,186,128,128,128,128,128],t.t)
B.fL=s([69,46,190,239,201,218,255,228,128,128,128],t.t)
B.i3=s([B.fe,B.hV,B.fL],t.S)
B.eY=s([1,191,251,255,255,128,128,128,128,128,128],t.t)
B.hc=s([223,165,249,255,213,255,128,128,128,128,128],t.t)
B.hB=s([141,124,248,255,255,128,128,128,128,128,128],t.t)
B.iv=s([B.eY,B.hc,B.hB],t.S)
B.fo=s([1,16,248,255,255,128,128,128,128,128,128],t.t)
B.e8=s([190,36,230,255,236,255,128,128,128,128,128],t.t)
B.dX=s([149,1,255,128,128,128,128,128,128,128,128],t.t)
B.dp=s([B.fo,B.e8,B.dX],t.S)
B.hy=s([1,226,255,128,128,128,128,128,128,128,128],t.t)
B.hN=s([247,192,255,128,128,128,128,128,128,128,128],t.t)
B.iQ=s([240,128,255,128,128,128,128,128,128,128,128],t.t)
B.d4=s([B.hy,B.hN,B.iQ],t.S)
B.iJ=s([1,134,252,255,255,128,128,128,128,128,128],t.t)
B.hn=s([213,62,250,255,255,128,128,128,128,128,128],t.t)
B.jc=s([55,93,255,128,128,128,128,128,128,128,128],t.t)
B.hx=s([B.iJ,B.hn,B.jc],t.S)
B.dN=s([B.hK,B.ie,B.i3,B.iv,B.dp,B.d4,B.hx,B.b_],t.o)
B.hp=s([202,24,213,235,186,191,220,160,240,175,255],t.t)
B.dT=s([126,38,182,232,169,184,228,174,255,187,128],t.t)
B.dr=s([61,46,138,219,151,178,240,170,255,216,128],t.t)
B.ic=s([B.hp,B.dT,B.dr],t.S)
B.fU=s([1,112,230,250,199,191,247,159,255,255,128],t.t)
B.dA=s([166,109,228,252,211,215,255,174,128,128,128],t.t)
B.ha=s([39,77,162,232,172,180,245,178,255,255,128],t.t)
B.ia=s([B.fU,B.dA,B.ha],t.S)
B.fX=s([1,52,220,246,198,199,249,220,255,255,128],t.t)
B.eg=s([124,74,191,243,183,193,250,221,255,255,128],t.t)
B.eR=s([24,71,130,219,154,170,243,182,255,255,128],t.t)
B.i9=s([B.fX,B.eg,B.eR],t.S)
B.eP=s([1,182,225,249,219,240,255,224,128,128,128],t.t)
B.jb=s([149,150,226,252,216,205,255,171,128,128,128],t.t)
B.ju=s([28,108,170,242,183,194,254,223,255,255,128],t.t)
B.j1=s([B.eP,B.jb,B.ju],t.S)
B.jv=s([1,81,230,252,204,203,255,192,128,128,128],t.t)
B.iq=s([123,102,209,247,188,196,255,233,128,128,128],t.t)
B.iO=s([20,95,153,243,164,173,255,203,128,128,128],t.t)
B.ir=s([B.jv,B.iq,B.iO],t.S)
B.fw=s([1,222,248,255,216,213,128,128,128,128,128],t.t)
B.hm=s([168,175,246,252,235,205,255,255,128,128,128],t.t)
B.eU=s([47,116,215,255,211,212,255,255,128,128,128],t.t)
B.e4=s([B.fw,B.hm,B.eU],t.S)
B.fu=s([1,121,236,253,212,214,255,255,128,128,128],t.t)
B.fY=s([141,84,213,252,201,202,255,219,128,128,128],t.t)
B.hI=s([42,80,160,240,162,185,255,205,128,128,128],t.t)
B.f3=s([B.fu,B.fY,B.hI],t.S)
B.jj=s([244,1,255,128,128,128,128,128,128,128,128],t.t)
B.cE=s([238,1,255,128,128,128,128,128,128,128,128],t.t)
B.hO=s([B.b2,B.jj,B.cE],t.S)
B.cU=s([B.ic,B.ia,B.i9,B.j1,B.ir,B.e4,B.f3,B.hO],t.o)
B.dq=s([B.eb,B.i8,B.dN,B.cU],t._)
B.ds=s([511,1023,2047,4095],t.t)
B.dC=s([63,207,243,252],t.t)
B.dK=s([17,18,24,47,99,99,99,99,18,21,26,66,99,99,99,99,24,26,56,99,99,99,99,99,47,66,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99],t.t)
B.a4=s([0,1,2,3,4,5,6,7,8,9,10,11],t.t)
B.dZ=s([8,8,4,2],t.t)
B.cQ=s([173,148,140],t.t)
B.cR=s([176,155,140,135],t.t)
B.cO=s([180,157,141,134,130],t.t)
B.d1=s([254,254,243,230,196,177,153,140,133,130,129],t.t)
B.e_=s([B.cQ,B.cR,B.cO,B.d1],t.S)
B.b0=s([1,1.387039845,1.306562965,1.175875602,1,0.785694958,0.5411961,0.275899379],A.S("p<J>"))
B.ed=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095],t.t)
B.b1=s([1,2,3,0,4,17,5,18,33,49,65,6,19,81,97,7,34,113,20,50,129,145,161,8,35,66,177,193,21,82,209,240,36,51,98,114,130,9,10,22,23,24,25,26,37,38,39,40,41,42,52,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,225,226,227,228,229,230,231,232,233,234,241,242,243,244,245,246,247,248,249,250],t.t)
B.F=s([0,1,1,2,4,8,1,1,2,4,8,4,8,4],t.t)
B.en=s([2954,2956,2958,2962,2970,2986,3018,3082,3212,3468,3980,5004],t.t)
B.b3=s([280,256,256,256,40],t.t)
B.a5=s([0,1,5,6,14,15,27,28,2,4,7,13,16,26,29,42,3,8,12,17,25,30,41,43,9,11,18,24,31,40,44,53,10,19,23,32,39,45,52,54,20,22,33,38,46,51,55,60,21,34,37,47,50,56,59,61,35,36,48,49,57,58,62,63],t.t)
B.b4=s([62,62,30,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,588,588,588,588,588,588,588,588,1680,1680,20499,22547,24595,26643,1776,1776,1808,1808,-24557,-22509,-20461,-18413,1904,1904,1936,1936,-16365,-14317,782,782,782,782,814,814,814,814,-12269,-10221,10257,10257,12305,12305,14353,14353,16403,18451,1712,1712,1744,1744,28691,30739,-32749,-30701,-28653,-26605,2061,2061,2061,2061,2061,2061,2061,2061,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,750,750,750,750,1616,1616,1648,1648,1424,1424,1456,1456,1488,1488,1520,1520,1840,1840,1872,1872,1968,1968,8209,8209,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,1552,1552,1584,1584,2000,2000,2032,2032,976,976,1008,1008,1040,1040,1072,1072,1296,1296,1328,1328,718,718,718,718,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,4113,4113,6161,6161,848,848,880,880,912,912,944,944,622,622,622,622,654,654,654,654,1104,1104,1136,1136,1168,1168,1200,1200,1232,1232,1264,1264,686,686,686,686,1360,1360,1392,1392,12,12,12,12,12,12,12,12,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390],t.t)
B.ak=s([4,5,6,7,8,9,10,10,11,12,13,14,15,16,17,17,18,19,20,20,21,21,22,22,23,23,24,25,25,26,27,28,29,30,31,32,33,34,35,36,37,37,38,39,40,41,42,43,44,45,46,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,76,77,78,79,80,81,82,83,84,85,86,87,88,89,91,93,95,96,98,100,101,102,104,106,108,110,112,114,116,118,122,124,126,128,130,132,134,136,138,140,143,145,148,151,154,157],t.t)
B.ez=s([24,7,23,25,40,6,39,41,22,26,38,42,56,5,55,57,21,27,54,58,37,43,72,4,71,73,20,28,53,59,70,74,36,44,88,69,75,52,60,3,87,89,19,29,86,90,35,45,68,76,85,91,51,61,104,2,103,105,18,30,102,106,34,46,84,92,67,77,101,107,50,62,120,1,119,121,83,93,17,31,100,108,66,78,118,122,33,47,117,123,49,63,99,109,82,94,0,116,124,65,79,16,32,98,110,48,115,125,81,95,64,114,126,97,111,80,113,127,96,112],t.t)
B.al=s([4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,119,122,125,128,131,134,137,140,143,146,149,152,155,158,161,164,167,170,173,177,181,185,189,193,197,201,205,209,213,217,221,225,229,234,239,245,249,254,259,264,269,274,279,284],t.t)
B.b5=s([0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,119],t.t)
B.cg=new A.bV(0,"uint")
B.eL=s([B.cg,B.aG,B.aH],A.S("p<bV>"))
B.eM=s([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],t.t)
B.f8=s([254,253,251,247,239,223,191,127],t.t)
B.b6=s([A.ux(),A.up(),A.uE(),A.uC(),A.uz(),A.uy(),A.uA()],t.A)
B.at=new A.a4(0,"whiteIsZero")
B.jZ=new A.a4(1,"blackIsZero")
B.k5=new A.a4(2,"rgb")
B.av=new A.a4(3,"palette")
B.k6=new A.a4(4,"transparencyMask")
B.bK=new A.a4(5,"cmyk")
B.k7=new A.a4(6,"yCbCr")
B.k8=new A.a4(7,"reserved7")
B.k9=new A.a4(8,"cieLab")
B.ka=new A.a4(9,"iccLab")
B.k_=new A.a4(10,"ituLab")
B.k0=new A.a4(11,"logL")
B.k1=new A.a4(12,"logLuv")
B.k2=new A.a4(13,"colorFilterArray")
B.k3=new A.a4(14,"linearRaw")
B.k4=new A.a4(15,"depth")
B.au=new A.a4(16,"unknown")
B.fg=s([B.at,B.jZ,B.k5,B.av,B.k6,B.bK,B.k7,B.k8,B.k9,B.ka,B.k_,B.k0,B.k1,B.k2,B.k3,B.k4,B.au],A.S("p<a4>"))
B.b9=s([0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0],t.t)
B.bv=new A.et(0,"source")
B.bw=new A.et(1,"over")
B.fq=s([B.bv,B.bw],A.S("p<et>"))
B.jR=new A.co(0,"invalid")
B.bI=new A.co(1,"uint")
B.f=new A.co(2,"int")
B.a_=new A.co(3,"float")
B.ft=s([B.jR,B.bI,B.f,B.a_],A.S("p<co>"))
B.fv=s([17,18,0,1,2,3,4,5,16,6,7,8,9,10,11,12,13,14,15],t.t)
B.ba=s([-0.0,1,-1,2,-2,3,4,6,-3,5,-4,-5,-6,7,-7,8,-8,-9],t.t)
B.bb=s([B.d,B.aL,B.j,B.h,B.n,B.q,B.aQ,B.D,B.aR,B.aS,B.aM,B.aN,B.aO,B.aP],A.S("p<aa>"))
B.fK=s([0,1,4,8,5,2,3,6,9,12,13,10,7,11,14,15],t.t)
B.ch=new A.b0(1,"rle")
B.ci=new A.b0(2,"zips")
B.cj=new A.b0(3,"zip")
B.ck=new A.b0(4,"piz")
B.cl=new A.b0(5,"pxr24")
B.cm=new A.b0(6,"b44")
B.cn=new A.b0(7,"b44a")
B.fN=s([B.aI,B.ch,B.ci,B.cj,B.ck,B.cl,B.cm,B.cn],A.S("p<b0>"))
B.hF=s([231,120,48,89,115,113,120,152,112],t.t)
B.cV=s([152,179,64,126,170,118,46,70,95],t.t)
B.fJ=s([175,69,143,80,85,82,72,155,103],t.t)
B.dh=s([56,58,10,171,218,189,17,13,152],t.t)
B.h9=s([114,26,17,163,44,195,21,10,173],t.t)
B.hl=s([121,24,80,195,26,62,44,64,85],t.t)
B.h5=s([144,71,10,38,171,213,144,34,26],t.t)
B.iA=s([170,46,55,19,136,160,33,206,71],t.t)
B.eA=s([63,20,8,114,114,208,12,9,226],t.t)
B.fd=s([81,40,11,96,182,84,29,16,36],t.t)
B.cI=s([B.hF,B.cV,B.fJ,B.dh,B.h9,B.hl,B.h5,B.iA,B.eA,B.fd],t.S)
B.e7=s([134,183,89,137,98,101,106,165,148],t.t)
B.ik=s([72,187,100,130,157,111,32,75,80],t.t)
B.hs=s([66,102,167,99,74,62,40,234,128],t.t)
B.d3=s([41,53,9,178,241,141,26,8,107],t.t)
B.f9=s([74,43,26,146,73,166,49,23,157],t.t)
B.eI=s([65,38,105,160,51,52,31,115,128],t.t)
B.eN=s([104,79,12,27,217,255,87,17,7],t.t)
B.fH=s([87,68,71,44,114,51,15,186,23],t.t)
B.ib=s([47,41,14,110,182,183,21,17,194],t.t)
B.hQ=s([66,45,25,102,197,189,23,18,22],t.t)
B.iP=s([B.e7,B.ik,B.hs,B.d3,B.f9,B.eI,B.eN,B.fH,B.ib,B.hQ],t.S)
B.hE=s([88,88,147,150,42,46,45,196,205],t.t)
B.hb=s([43,97,183,117,85,38,35,179,61],t.t)
B.eT=s([39,53,200,87,26,21,43,232,171],t.t)
B.fC=s([56,34,51,104,114,102,29,93,77],t.t)
B.h1=s([39,28,85,171,58,165,90,98,64],t.t)
B.eE=s([34,22,116,206,23,34,43,166,73],t.t)
B.cJ=s([107,54,32,26,51,1,81,43,31],t.t)
B.iD=s([68,25,106,22,64,171,36,225,114],t.t)
B.e6=s([34,19,21,102,132,188,16,76,124],t.t)
B.iZ=s([62,18,78,95,85,57,50,48,51],t.t)
B.ek=s([B.hE,B.hb,B.eT,B.fC,B.h1,B.eE,B.cJ,B.iD,B.e6,B.iZ],t.S)
B.fZ=s([193,101,35,159,215,111,89,46,111],t.t)
B.dM=s([60,148,31,172,219,228,21,18,111],t.t)
B.dm=s([112,113,77,85,179,255,38,120,114],t.t)
B.iW=s([40,42,1,196,245,209,10,25,109],t.t)
B.fr=s([88,43,29,140,166,213,37,43,154],t.t)
B.eG=s([61,63,30,155,67,45,68,1,209],t.t)
B.eZ=s([100,80,8,43,154,1,51,26,71],t.t)
B.d6=s([142,78,78,16,255,128,34,197,171],t.t)
B.fT=s([41,40,5,102,211,183,4,1,221],t.t)
B.er=s([51,50,17,168,209,192,23,25,82],t.t)
B.ej=s([B.fZ,B.dM,B.dm,B.iW,B.fr,B.eG,B.eZ,B.d6,B.fT,B.er],t.S)
B.eQ=s([138,31,36,171,27,166,38,44,229],t.t)
B.eh=s([67,87,58,169,82,115,26,59,179],t.t)
B.i_=s([63,59,90,180,59,166,93,73,154],t.t)
B.iM=s([40,40,21,116,143,209,34,39,175],t.t)
B.db=s([47,15,16,183,34,223,49,45,183],t.t)
B.dS=s([46,17,33,183,6,98,15,32,183],t.t)
B.jw=s([57,46,22,24,128,1,54,17,37],t.t)
B.f0=s([65,32,73,115,28,128,23,128,205],t.t)
B.hr=s([40,3,9,115,51,192,18,6,223],t.t)
B.f6=s([87,37,9,115,59,77,64,21,47],t.t)
B.fS=s([B.eQ,B.eh,B.i_,B.iM,B.db,B.dS,B.jw,B.f0,B.hr,B.f6],t.S)
B.ji=s([104,55,44,218,9,54,53,130,226],t.t)
B.dz=s([64,90,70,205,40,41,23,26,57],t.t)
B.hZ=s([54,57,112,184,5,41,38,166,213],t.t)
B.eF=s([30,34,26,133,152,116,10,32,134],t.t)
B.hL=s([39,19,53,221,26,114,32,73,255],t.t)
B.ep=s([31,9,65,234,2,15,1,118,73],t.t)
B.fQ=s([75,32,12,51,192,255,160,43,51],t.t)
B.eH=s([88,31,35,67,102,85,55,186,85],t.t)
B.fj=s([56,21,23,111,59,205,45,37,192],t.t)
B.fk=s([55,38,70,124,73,102,1,34,98],t.t)
B.jm=s([B.ji,B.dz,B.hZ,B.eF,B.hL,B.ep,B.fQ,B.eH,B.fj,B.fk],t.S)
B.fi=s([125,98,42,88,104,85,117,175,82],t.t)
B.eK=s([95,84,53,89,128,100,113,101,45],t.t)
B.hg=s([75,79,123,47,51,128,81,171,1],t.t)
B.dx=s([57,17,5,71,102,57,53,41,49],t.t)
B.hU=s([38,33,13,121,57,73,26,1,85],t.t)
B.ja=s([41,10,67,138,77,110,90,47,114],t.t)
B.fO=s([115,21,2,10,102,255,166,23,6],t.t)
B.e9=s([101,29,16,10,85,128,101,196,26],t.t)
B.eX=s([57,18,10,102,102,213,34,20,43],t.t)
B.fp=s([117,20,15,36,163,128,68,1,26],t.t)
B.fG=s([B.fi,B.eK,B.hg,B.dx,B.hU,B.ja,B.fO,B.e9,B.eX,B.fp],t.S)
B.f4=s([102,61,71,37,34,53,31,243,192],t.t)
B.j6=s([69,60,71,38,73,119,28,222,37],t.t)
B.f7=s([68,45,128,34,1,47,11,245,171],t.t)
B.cN=s([62,17,19,70,146,85,55,62,70],t.t)
B.js=s([37,43,37,154,100,163,85,160,1],t.t)
B.j2=s([63,9,92,136,28,64,32,201,85],t.t)
B.io=s([75,15,9,9,64,255,184,119,16],t.t)
B.ef=s([86,6,28,5,64,255,25,248,1],t.t)
B.hP=s([56,8,17,132,137,255,55,116,128],t.t)
B.dt=s([58,15,20,82,135,57,26,121,40],t.t)
B.h4=s([B.f4,B.j6,B.f7,B.cN,B.js,B.j2,B.io,B.ef,B.hP,B.dt],t.S)
B.hj=s([164,50,31,137,154,133,25,35,218],t.t)
B.ee=s([51,103,44,131,131,123,31,6,158],t.t)
B.j0=s([86,40,64,135,148,224,45,183,128],t.t)
B.fI=s([22,26,17,131,240,154,14,1,209],t.t)
B.dP=s([45,16,21,91,64,222,7,1,197],t.t)
B.iN=s([56,21,39,155,60,138,23,102,213],t.t)
B.jl=s([83,12,13,54,192,255,68,47,28],t.t)
B.ht=s([85,26,85,85,128,128,32,146,171],t.t)
B.fE=s([18,11,7,63,144,171,4,4,246],t.t)
B.el=s([35,27,10,146,174,171,12,26,128],t.t)
B.fx=s([B.hj,B.ee,B.j0,B.fI,B.dP,B.iN,B.jl,B.ht,B.fE,B.el],t.S)
B.i7=s([190,80,35,99,180,80,126,54,45],t.t)
B.iz=s([85,126,47,87,176,51,41,20,32],t.t)
B.hW=s([101,75,128,139,118,146,116,128,85],t.t)
B.ij=s([56,41,15,176,236,85,37,9,62],t.t)
B.du=s([71,30,17,119,118,255,17,18,138],t.t)
B.h3=s([101,38,60,138,55,70,43,26,142],t.t)
B.fA=s([146,36,19,30,171,255,97,27,20],t.t)
B.hD=s([138,45,61,62,219,1,81,188,64],t.t)
B.iX=s([32,41,20,117,151,142,20,21,163],t.t)
B.iB=s([112,19,12,61,195,128,48,4,24],t.t)
B.i2=s([B.i7,B.iz,B.hW,B.ij,B.du,B.h3,B.fA,B.hD,B.iX,B.iB],t.S)
B.fR=s([B.cI,B.iP,B.ek,B.ej,B.fS,B.jm,B.fG,B.h4,B.fx,B.i2],t.o)
B.aa=new A.an(0,"none")
B.H=new A.an(1,"palette")
B.bH=new A.an(2,"rgb")
B.jL=new A.an(3,"gray")
B.jM=new A.an(4,"reserved4")
B.jN=new A.an(5,"reserved5")
B.jO=new A.an(6,"reserved6")
B.jP=new A.an(7,"reserved7")
B.jQ=new A.an(8,"reserved8")
B.I=new A.an(9,"paletteRle")
B.bG=new A.an(10,"rgbRle")
B.jK=new A.an(11,"grayRle")
B.fW=s([B.aa,B.H,B.bH,B.jL,B.jM,B.jN,B.jO,B.jP,B.jQ,B.I,B.bG,B.jK],A.S("p<an>"))
B.bc=s([0,1,2,3,17,4,5,33,49,6,18,65,81,7,97,113,19,34,50,129,8,20,66,145,161,177,193,9,35,51,82,240,21,98,114,209,10,22,36,52,225,37,241,23,24,25,26,38,39,40,41,42,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,130,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,226,227,228,229,230,231,232,233,234,242,243,244,245,246,247,248,249,250],t.t)
B.hd=s([0,1,1,1,0],t.t)
B.hf=s([A.uh(),A.uo(),A.uq(),A.uj(),A.um(),A.us(),A.ul(),A.ur(),A.ui(),A.uk()],t.A)
B.aj=s([8,0,8,0],t.t)
B.dy=s([5,3,5,3],t.t)
B.d9=s([3,5,3,5],t.t)
B.aV=s([0,8,0,8],t.t)
B.aZ=s([4,4,4,4],t.t)
B.dl=s([4,4,0,0],t.t)
B.bd=s([B.aj,B.dy,B.d9,B.aV,B.aj,B.aZ,B.dl,B.aV],t.S)
B.be=s([80,88,23,71,30,30,62,62,4,4,4,4,4,4,4,4,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41],t.t)
B.hA=s([16,11,10,16,24,40,51,61,12,12,14,19,26,58,60,55,14,13,16,24,40,57,69,56,14,17,22,29,51,87,80,62,18,22,37,56,68,109,103,77,24,35,55,64,81,104,113,92,49,64,78,87,103,121,120,101,72,92,95,98,112,100,103,99],t.t)
B.a6=s([0,1,4,5,16,17,20,21,64,65,68,69,80,81,84,85,256,257,260,261,272,273,276,277,320,321,324,325,336,337,340,341,1024,1025,1028,1029,1040,1041,1044,1045,1088,1089,1092,1093,1104,1105,1108,1109,1280,1281,1284,1285,1296,1297,1300,1301,1344,1345,1348,1349,1360,1361,1364,1365,4096,4097,4100,4101,4112,4113,4116,4117,4160,4161,4164,4165,4176,4177,4180,4181,4352,4353,4356,4357,4368,4369,4372,4373,4416,4417,4420,4421,4432,4433,4436,4437,5120,5121,5124,5125,5136,5137,5140,5141,5184,5185,5188,5189,5200,5201,5204,5205,5376,5377,5380,5381,5392,5393,5396,5397,5440,5441,5444,5445,5456,5457,5460,5461,16384,16385,16388,16389,16400,16401,16404,16405,16448,16449,16452,16453,16464,16465,16468,16469,16640,16641,16644,16645,16656,16657,16660,16661,16704,16705,16708,16709,16720,16721,16724,16725,17408,17409,17412,17413,17424,17425,17428,17429,17472,17473,17476,17477,17488,17489,17492,17493,17664,17665,17668,17669,17680,17681,17684,17685,17728,17729,17732,17733,17744,17745,17748,17749,20480,20481,20484,20485,20496,20497,20500,20501,20544,20545,20548,20549,20560,20561,20564,20565,20736,20737,20740,20741,20752,20753,20756,20757,20800,20801,20804,20805,20816,20817,20820,20821,21504,21505,21508,21509,21520,21521,21524,21525,21568,21569,21572,21573,21584,21585,21588,21589,21760,21761,21764,21765,21776,21777,21780,21781,21824,21825,21828,21829,21840,21841,21844,21845],t.t)
B.bf=s([127,127,191,127,159,191,223,127,143,159,175,191,207,223,239,127,135,143,151,159,167,175,183,191,199,207,215,223,231,239,247,127,131,135,139,143,147,151,155,159,163,167,171,175,179,183,187,191,195,199,203,207,211,215,219,223,227,231,235,239,243,247,251,127,129,131,133,135,137,139,141,143,145,147,149,151,153,155,157,159,161,163,165,167,169,171,173,175,177,179,181,183,185,187,189,191,193,195,197,199,201,203,205,207,209,211,213,215,217,219,221,223,225,227,229,231,233,235,237,239,241,243,245,247,249,251,253,127],t.t)
B.bg=s([7,6,6,5,5,5,5,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],t.t)
B.a7=s([28679,28679,31752,-32759,-31735,-30711,-29687,-28663,29703,29703,30727,30727,-27639,-26615,-25591,-24567],t.t)
B.bh=s([6430,6400,6400,6400,3225,3225,3225,3225,944,944,944,944,976,976,976,976,1456,1456,1456,1456,1488,1488,1488,1488,718,718,718,718,718,718,718,718,750,750,750,750,750,750,750,750,1520,1520,1520,1520,1552,1552,1552,1552,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,654,654,654,654,654,654,654,654,1072,1072,1072,1072,1104,1104,1104,1104,1136,1136,1136,1136,1168,1168,1168,1168,1200,1200,1200,1200,1232,1232,1232,1232,622,622,622,622,622,622,622,622,1008,1008,1008,1008,1040,1040,1040,1040,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,1712,1712,1712,1712,1744,1744,1744,1744,846,846,846,846,846,846,846,846,1264,1264,1264,1264,1296,1296,1296,1296,1328,1328,1328,1328,1360,1360,1360,1360,1392,1392,1392,1392,1424,1424,1424,1424,686,686,686,686,686,686,686,686,910,910,910,910,910,910,910,910,1968,1968,1968,1968,2000,2000,2000,2000,2032,2032,2032,2032,16,16,16,16,10257,10257,10257,10257,12305,12305,12305,12305,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,878,878,878,878,878,878,878,878,1904,1904,1904,1904,1936,1936,1936,1936,-18413,-18413,-16365,-16365,-14317,-14317,-10221,-10221,590,590,590,590,590,590,590,590,782,782,782,782,782,782,782,782,1584,1584,1584,1584,1616,1616,1616,1616,1648,1648,1648,1648,1680,1680,1680,1680,814,814,814,814,814,814,814,814,1776,1776,1776,1776,1808,1808,1808,1808,1840,1840,1840,1840,1872,1872,1872,1872,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,14353,14353,14353,14353,16401,16401,16401,16401,22547,22547,24595,24595,20497,20497,20497,20497,18449,18449,18449,18449,26643,26643,28691,28691,30739,30739,-32749,-32749,-30701,-30701,-28653,-28653,-26605,-26605,-24557,-24557,-22509,-22509,-20461,-20461,8207,8207,8207,8207,8207,8207,8207,8207,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232],t.t)
B.hT=s([],A.S("p<0&>"))
B.hX=s([5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],t.t)
B.bi=s([0,1,2,3,6,4,5,6,6,6,6,6,6,6,6,7,0],t.t)
B.jA=new A.bE(0,"none")
B.jB=new A.bE(1,"sub")
B.jC=new A.bE(2,"up")
B.jD=new A.bE(3,"average")
B.jE=new A.bE(4,"paeth")
B.bj=s([B.jA,B.jB,B.jC,B.jD,B.jE],A.S("p<bE>"))
B.v=s([0,1996959894,3993919788,2567524794,124634137,1886057615,3915621685,2657392035,249268274,2044508324,3772115230,2547177864,162941995,2125561021,3887607047,2428444049,498536548,1789927666,4089016648,2227061214,450548861,1843258603,4107580753,2211677639,325883990,1684777152,4251122042,2321926636,335633487,1661365465,4195302755,2366115317,997073096,1281953886,3579855332,2724688242,1006888145,1258607687,3524101629,2768942443,901097722,1119000684,3686517206,2898065728,853044451,1172266101,3705015759,2882616665,651767980,1373503546,3369554304,3218104598,565507253,1454621731,3485111705,3099436303,671266974,1594198024,3322730930,2970347812,795835527,1483230225,3244367275,3060149565,1994146192,31158534,2563907772,4023717930,1907459465,112637215,2680153253,3904427059,2013776290,251722036,2517215374,3775830040,2137656763,141376813,2439277719,3865271297,1802195444,476864866,2238001368,4066508878,1812370925,453092731,2181625025,4111451223,1706088902,314042704,2344532202,4240017532,1658658271,366619977,2362670323,4224994405,1303535960,984961486,2747007092,3569037538,1256170817,1037604311,2765210733,3554079995,1131014506,879679996,2909243462,3663771856,1141124467,855842277,2852801631,3708648649,1342533948,654459306,3188396048,3373015174,1466479909,544179635,3110523913,3462522015,1591671054,702138776,2966460450,3352799412,1504918807,783551873,3082640443,3233442989,3988292384,2596254646,62317068,1957810842,3939845945,2647816111,81470997,1943803523,3814918930,2489596804,225274430,2053790376,3826175755,2466906013,167816743,2097651377,4027552580,2265490386,503444072,1762050814,4150417245,2154129355,426522225,1852507879,4275313526,2312317920,282753626,1742555852,4189708143,2394877945,397917763,1622183637,3604390888,2714866558,953729732,1340076626,3518719985,2797360999,1068828381,1219638859,3624741850,2936675148,906185462,1090812512,3747672003,2825379669,829329135,1181335161,3412177804,3160834842,628085408,1382605366,3423369109,3138078467,570562233,1426400815,3317316542,2998733608,733239954,1555261956,3268935591,3050360625,752459403,1541320221,2607071920,3965973030,1969922972,40735498,2617837225,3943577151,1913087877,83908371,2512341634,3803740692,2075208622,213261112,2463272603,3855990285,2094854071,198958881,2262029012,4057260610,1759359992,534414190,2176718541,4139329115,1873836001,414664567,2282248934,4279200368,1711684554,285281116,2405801727,4167216745,1634467795,376229701,2685067896,3608007406,1308918612,956543938,2808555105,3495958263,1231636301,1047427035,2932959818,3654703836,1088359270,936918e3,2847714899,3736837829,1202900863,817233897,3183342108,3401237130,1404277552,615818150,3134207493,3453421203,1423857449,601450431,3009837614,3294710456,1567103746,711928724,3020668471,3272380065,1510334235,755167117],t.t)
B.Y=s([0,1,3,7,15,31,63,127,255],t.t)
B.ip=s([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],t.t)
B.r=s([255,255,255,255,255,255,255,255,255,255,255],t.t)
B.T=s([B.r,B.r,B.r],t.S)
B.fB=s([176,246,255,255,255,255,255,255,255,255,255],t.t)
B.jd=s([223,241,252,255,255,255,255,255,255,255,255],t.t)
B.e3=s([249,253,253,255,255,255,255,255,255,255,255],t.t)
B.fP=s([B.fB,B.jd,B.e3],t.S)
B.ff=s([255,244,252,255,255,255,255,255,255,255,255],t.t)
B.f2=s([234,254,254,255,255,255,255,255,255,255,255],t.t)
B.bn=s([253,255,255,255,255,255,255,255,255,255,255],t.t)
B.ec=s([B.ff,B.f2,B.bn],t.S)
B.j_=s([255,246,254,255,255,255,255,255,255,255,255],t.t)
B.hM=s([239,253,254,255,255,255,255,255,255,255,255],t.t)
B.bk=s([254,255,254,255,255,255,255,255,255,255,255],t.t)
B.il=s([B.j_,B.hM,B.bk],t.S)
B.b7=s([255,248,254,255,255,255,255,255,255,255,255],t.t)
B.ev=s([251,255,254,255,255,255,255,255,255,255,255],t.t)
B.hk=s([B.b7,B.ev,B.r],t.S)
B.ai=s([255,253,254,255,255,255,255,255,255,255,255],t.t)
B.hi=s([251,254,254,255,255,255,255,255,255,255,255],t.t)
B.eD=s([B.ai,B.hi,B.bk],t.S)
B.df=s([255,254,253,255,254,255,255,255,255,255,255],t.t)
B.fb=s([250,255,254,255,254,255,255,255,255,255,255],t.t)
B.a8=s([254,255,255,255,255,255,255,255,255,255,255],t.t)
B.fs=s([B.df,B.fb,B.a8],t.S)
B.eW=s([B.T,B.fP,B.ec,B.il,B.hk,B.eD,B.fs,B.T],t.o)
B.cT=s([217,255,255,255,255,255,255,255,255,255,255],t.t)
B.fy=s([225,252,241,253,255,255,254,255,255,255,255],t.t)
B.hY=s([234,250,241,250,253,255,253,254,255,255,255],t.t)
B.iC=s([B.cT,B.fy,B.hY],t.S)
B.ap=s([255,254,255,255,255,255,255,255,255,255,255],t.t)
B.e5=s([223,254,254,255,255,255,255,255,255,255,255],t.t)
B.dQ=s([238,253,254,254,255,255,255,255,255,255,255],t.t)
B.hJ=s([B.ap,B.e5,B.dQ],t.S)
B.f5=s([249,254,255,255,255,255,255,255,255,255,255],t.t)
B.iY=s([B.b7,B.f5,B.r],t.S)
B.iE=s([255,253,255,255,255,255,255,255,255,255,255],t.t)
B.hh=s([247,254,255,255,255,255,255,255,255,255,255],t.t)
B.h7=s([B.iE,B.hh,B.r],t.S)
B.dL=s([252,255,255,255,255,255,255,255,255,255,255],t.t)
B.d5=s([B.ai,B.dL,B.r],t.S)
B.bo=s([255,254,254,255,255,255,255,255,255,255,255],t.t)
B.dO=s([B.bo,B.bn,B.r],t.S)
B.hH=s([255,254,253,255,255,255,255,255,255,255,255],t.t)
B.b8=s([250,255,255,255,255,255,255,255,255,255,255],t.t)
B.dJ=s([B.hH,B.b8,B.a8],t.S)
B.di=s([B.iC,B.hJ,B.iY,B.h7,B.d5,B.dO,B.dJ,B.T],t.o)
B.i4=s([186,251,250,255,255,255,255,255,255,255,255],t.t)
B.es=s([234,251,244,254,255,255,255,255,255,255,255],t.t)
B.im=s([251,251,243,253,254,255,254,255,255,255,255],t.t)
B.eB=s([B.i4,B.es,B.im],t.S)
B.ex=s([236,253,254,255,255,255,255,255,255,255,255],t.t)
B.hG=s([251,253,253,254,254,255,255,255,255,255,255],t.t)
B.fl=s([B.ai,B.ex,B.hG],t.S)
B.i6=s([254,254,254,255,255,255,255,255,255,255,255],t.t)
B.et=s([B.bo,B.i6,B.r],t.S)
B.is=s([254,254,255,255,255,255,255,255,255,255,255],t.t)
B.ew=s([B.ap,B.is,B.a8],t.S)
B.bp=s([B.r,B.a8,B.r],t.S)
B.dg=s([B.eB,B.fl,B.et,B.ew,B.bp,B.T,B.T,B.T],t.o)
B.fa=s([248,255,255,255,255,255,255,255,255,255,255],t.t)
B.eJ=s([250,254,252,254,255,255,255,255,255,255,255],t.t)
B.eq=s([248,254,249,253,255,255,255,255,255,255,255],t.t)
B.fn=s([B.fa,B.eJ,B.eq],t.S)
B.dd=s([255,253,253,255,255,255,255,255,255,255,255],t.t)
B.iI=s([246,253,253,255,255,255,255,255,255,255,255],t.t)
B.eC=s([252,254,251,254,254,255,255,255,255,255,255],t.t)
B.iH=s([B.dd,B.iI,B.eC],t.S)
B.jr=s([255,254,252,255,255,255,255,255,255,255,255],t.t)
B.eo=s([248,254,253,255,255,255,255,255,255,255,255],t.t)
B.dI=s([253,255,254,254,255,255,255,255,255,255,255],t.t)
B.hq=s([B.jr,B.eo,B.dI],t.S)
B.jk=s([255,251,254,255,255,255,255,255,255,255,255],t.t)
B.h_=s([245,251,254,255,255,255,255,255,255,255,255],t.t)
B.h2=s([253,253,254,255,255,255,255,255,255,255,255],t.t)
B.e0=s([B.jk,B.h_,B.h2],t.S)
B.e1=s([255,251,253,255,255,255,255,255,255,255,255],t.t)
B.fh=s([252,253,254,255,255,255,255,255,255,255,255],t.t)
B.id=s([B.e1,B.fh,B.ap],t.S)
B.dE=s([255,252,255,255,255,255,255,255,255,255,255],t.t)
B.jh=s([249,255,254,255,255,255,255,255,255,255,255],t.t)
B.eO=s([255,255,254,255,255,255,255,255,255,255,255],t.t)
B.cM=s([B.dE,B.jh,B.eO],t.S)
B.jt=s([255,255,253,255,255,255,255,255,255,255,255],t.t)
B.eu=s([B.jt,B.b8,B.r],t.S)
B.dH=s([B.fn,B.iH,B.hq,B.e0,B.id,B.cM,B.eu,B.bp],t.o)
B.ix=s([B.eW,B.di,B.dg,B.dH],t._)
B.bP=new A.a9(1,"rle8")
B.bU=new A.a9(2,"rle4")
B.bV=new A.a9(4,"jpeg")
B.bW=new A.a9(5,"png")
B.bX=new A.a9(7,"reserved7")
B.bY=new A.a9(8,"reserved8")
B.bZ=new A.a9(9,"reserved9")
B.bQ=new A.a9(10,"reserved10")
B.bR=new A.a9(11,"cmyk")
B.bS=new A.a9(12,"cmykRle8")
B.bT=new A.a9(13,"cmykRle4")
B.bl=s([B.az,B.bP,B.bU,B.ad,B.bV,B.bW,B.ae,B.bX,B.bY,B.bZ,B.bQ,B.bR,B.bS,B.bT],A.S("p<a9>"))
B.an=s([0,128,192,224,240,248,252,254,255],t.t)
B.bm=s([137,80,78,71,13,10,26,10],t.t)
B.ao=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535,131071,262143,524287,1048575,2097151,4194303,8388607,16777215,33554431,67108863,134217727,268435455,536870911,1073741823,2147483647,4294967295],t.t)
B.iG=s([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],t.t)
B.iL=s([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],t.t)
B.bM=new A.cq(0,"predictor")
B.kp=new A.cq(1,"crossColor")
B.kq=new A.cq(2,"subtractGreen")
B.bN=new A.cq(3,"colorIndexing")
B.iT=s([B.bM,B.kp,B.kq,B.bN],A.S("p<cq>"))
B.t=s([0,17,34,51,68,85,102,119,136,153,170,187,204,221,238,255],t.t)
B.j3=s([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
B.j5=s([A.ut(),A.un(),A.uD(),A.uB(),A.uv(),A.uu(),A.uw()],t.A)
B.bq=s([0,4,8,12,128,132,136,140,256,260,264,268,384,388,392,396],t.t)
B.j7=s([null,A.uT(),A.uU(),A.uS()],A.S("p<~(h,h,h,h,h,aH)?>"))
B.a9=s([0,36,72,109,145,182,218,255],t.t)
B.w=s([0,8,16,24,32,41,49,57,65,74,82,90,98,106,115,123,131,139,148,156,164,172,180,189,197,205,213,222,230,238,246,255],t.t)
B.jf=s([8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8],t.t)
B.jF=new A.b5(0,"bitmap")
B.bC=new A.b5(1,"grayscale")
B.jG=new A.b5(2,"indexed")
B.bD=new A.b5(3,"rgb")
B.bE=new A.b5(4,"cmyk")
B.jH=new A.b5(5,"multiChannel")
B.jI=new A.b5(6,"duoTone")
B.bF=new A.b5(7,"lab")
B.jg=s([B.jF,B.bC,B.jG,B.bD,B.bE,B.jH,B.jI,B.bF],A.S("p<b5>"))
B.jn=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,0,0],t.t)
B.br=s([0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0],t.t)
B.d0=s([2,6,2,6],t.t)
B.dF=s([6,2,6,2],t.t)
B.cZ=s([2,2,6,6],t.t)
B.cS=s([1,3,3,9],t.t)
B.dj=s([4,0,12,0],t.t)
B.d7=s([3,1,9,3],t.t)
B.dY=s([8,8,0,0],t.t)
B.dk=s([4,12,0,0],t.t)
B.cP=s([16,0,0,0],t.t)
B.cL=s([12,4,0,0],t.t)
B.dG=s([6,6,2,2],t.t)
B.da=s([3,9,1,3],t.t)
B.cK=s([12,0,4,0],t.t)
B.e2=s([9,3,3,1],t.t)
B.o=s([B.aZ,B.d0,B.aj,B.dF,B.cZ,B.cS,B.dj,B.d7,B.dY,B.dk,B.cP,B.cL,B.dG,B.da,B.cK,B.e2],t.S)
B.U=s([0,-128,64,-64,32,-96,96,-32,16,-112,80,-48,48,-80,112,-16,8,-120,72,-56,40,-88,104,-24,24,-104,88,-40,56,-72,120,-8,4,-124,68,-60,36,-92,100,-28,20,-108,84,-44,52,-76,116,-12,12,-116,76,-52,44,-84,108,-20,28,-100,92,-36,60,-68,124,-4,2,-126,66,-62,34,-94,98,-30,18,-110,82,-46,50,-78,114,-14,10,-118,74,-54,42,-86,106,-22,26,-102,90,-38,58,-70,122,-6,6,-122,70,-58,38,-90,102,-26,22,-106,86,-42,54,-74,118,-10,14,-114,78,-50,46,-82,110,-18,30,-98,94,-34,62,-66,126,-2,1,-127,65,-63,33,-95,97,-31,17,-111,81,-47,49,-79,113,-15,9,-119,73,-55,41,-87,105,-23,25,-103,89,-39,57,-71,121,-7,5,-123,69,-59,37,-91,101,-27,21,-107,85,-43,53,-75,117,-11,13,-115,77,-51,45,-83,109,-19,29,-99,93,-35,61,-67,125,-3,3,-125,67,-61,35,-93,99,-29,19,-109,83,-45,51,-77,115,-13,11,-117,75,-53,43,-85,107,-21,27,-101,91,-37,59,-69,123,-5,7,-121,71,-57,39,-89,103,-25,23,-105,87,-41,55,-73,119,-9,15,-113,79,-49,47,-81,111,-17,31,-97,95,-33,63,-65,127,-1],t.t)
B.bs=new A.bW([34665,"exif",40965,"interop",34853,"gps"],A.S("bW<h,a7>"))
B.jy={}
B.jx=new A.dK(B.jy,[],A.S("dK<0&,0&>"))
B.bt=new A.bW([B.u,1,B.x,3,B.y,15,B.e,255,B.m,65535,B.L,4294967295,B.O,127,B.P,32767,B.Q,2147483647,B.z,1,B.C,1,B.K,1],A.S("bW<af,h>"))
B.Z=new A.bF(0,"invalid")
B.bz=new A.bF(1,"pbm")
B.bA=new A.bF(2,"pgm2")
B.aq=new A.bF(3,"pgm5")
B.bB=new A.bF(4,"ppm3")
B.ar=new A.bF(5,"ppm6")
B.jJ=new A.dS([B.z,B.C,B.K],A.S("dS<af>"))
B.as=new A.aS(0,"bilevel")
B.jS=new A.aS(1,"gray4bit")
B.jT=new A.aS(2,"gray")
B.jU=new A.aS(3,"grayAlpha")
B.jV=new A.aS(4,"palette")
B.bJ=new A.aS(5,"rgb")
B.jW=new A.aS(6,"rgba")
B.jX=new A.aS(7,"yCbCrSub")
B.a0=new A.aS(8,"generic")
B.jY=new A.aS(9,"invalid")
B.kb=A.aX("fg")
B.kc=A.aX("lI")
B.kd=A.aX("iD")
B.ke=A.aX("iE")
B.kf=A.aX("d0")
B.kg=A.aX("j2")
B.kh=A.aX("j3")
B.bL=A.aX("U")
B.ki=A.aX("n")
B.kj=A.aX("hz")
B.kk=A.aX("bs")
B.kl=A.aX("ke")
B.km=A.aX("aH")
B.kn=new A.hD(!1)
B.ko=new A.hD(!0)
B.a1=new A.dl(0,"undefined")
B.ax=new A.dl(1,"lossy")
B.ab=new A.dl(2,"lossless")
B.kr=new A.dl(3,"animated")
B.ay=new A.dt(0,"header")
B.ks=new A.dt(1,"blocks")
B.kt=new A.dt(2,"trailer")
B.bO=new A.dt(3,"done")
B.J=new A.f_("")})();(function staticFields(){$.kZ=null
$.cv=A.m([],A.S("p<n>"))
$.nI=null
$.n5=null
$.n4=null
$.oD=null
$.ou=null
$.oL=null
$.ln=null
$.lu=null
$.mH=null
$.dv=null
$.f4=null
$.f5=null
$.mx=!1
$.I=B.p
$.ot=null
$.mv=null
$.nV=!1
$.r8=A.m([A.mL(),A.uF(),A.uK(),A.uL(),A.uM(),A.uN(),A.uO(),A.uP(),A.uQ(),A.uR(),A.uG(),A.uH(),A.uI(),A.uJ(),A.mL(),A.mL()],A.S("p<h(h,bs,h)>"))
$.G=null
$.nd=A.rk()
$.pO=A.m([A.u2(),A.u3()],A.S("p<ax(n,ah)>"))})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal,r=hunkHelpers.lazy
s($,"uW","oR",()=>A.lp("_$dart_dartClosure"))
s($,"uV","mM",()=>A.lp("_$dart_dartClosure_dartJSInterop"))
s($,"vE","pb",()=>A.m([new J.fY()],A.S("p<ex>")))
s($,"v4","oV",()=>A.br(A.kd({
toString:function(){return"$receiver$"}})))
s($,"v5","oW",()=>A.br(A.kd({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"v6","oX",()=>A.br(A.kd(null)))
s($,"v7","oY",()=>A.br(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"va","p0",()=>A.br(A.kd(void 0)))
s($,"vb","p1",()=>A.br(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"v9","p_",()=>A.br(A.nR(null)))
s($,"v8","oZ",()=>A.br(function(){try{null.$method$}catch(q){return q.message}}()))
s($,"vd","p3",()=>A.br(A.nR(void 0)))
s($,"vc","p2",()=>A.br(function(){try{(void 0).$method$}catch(q){return q.message}}()))
s($,"vk","mR",()=>A.rg())
s($,"vn","p7",()=>A.en(4096))
s($,"vl","p5",()=>new A.la().$0())
s($,"vm","p6",()=>new A.l9().$0())
s($,"vC","id",()=>A.ia(B.ki))
s($,"uZ","oT",()=>A.lO(B.jf,!1))
s($,"uY","oS",()=>A.lO(B.hX,!1))
s($,"vG","mV",()=>{var q=null,p="ISOSpeed"
return A.c8([11,A.f("ProcessingSoftware",B.j,q),254,A.f("SubfileType",B.n,1),255,A.f("OldSubfileType",B.n,1),256,A.f("ImageWidth",B.n,1),257,A.f("ImageLength",B.n,1),258,A.f("BitsPerSample",B.h,1),259,A.f("Compression",B.h,1),262,A.f("PhotometricInterpretation",B.h,1),263,A.f("Thresholding",B.h,1),264,A.f("CellWidth",B.h,1),265,A.f("CellLength",B.h,1),266,A.f("FillOrder",B.h,1),269,A.f("DocumentName",B.j,q),270,A.f("ImageDescription",B.j,q),271,A.f("Make",B.j,q),272,A.f("Model",B.j,q),273,A.f("StripOffsets",B.n,q),274,A.f("Orientation",B.h,1),277,A.f("SamplesPerPixel",B.h,1),278,A.f("RowsPerStrip",B.n,1),279,A.f("StripByteCounts",B.n,1),280,A.f("MinSampleValue",B.h,1),281,A.f("MaxSampleValue",B.h,1),282,A.f("XResolution",B.q,1),283,A.f("YResolution",B.q,1),284,A.f("PlanarConfiguration",B.h,1),285,A.f("PageName",B.j,q),286,A.f("XPosition",B.q,1),287,A.f("YPosition",B.q,1),290,A.f("GrayResponseUnit",B.h,1),291,A.f("GrayResponseCurve",B.d,q),292,A.f("T4Options",B.d,q),293,A.f("T6Options",B.d,q),296,A.f("ResolutionUnit",B.h,1),297,A.f("PageNumber",B.h,2),300,A.f("ColorResponseUnit",B.d,q),301,A.f("TransferFunction",B.h,768),305,A.f("Software",B.j,q),306,A.f("DateTime",B.j,q),315,A.f("Artist",B.j,q),316,A.f("HostComputer",B.j,q),317,A.f("Predictor",B.h,1),318,A.f("WhitePoint",B.q,2),319,A.f("PrimaryChromaticities",B.q,6),320,A.f("ColorMap",B.h,q),321,A.f("HalftoneHints",B.h,2),322,A.f("TileWidth",B.n,1),323,A.f("TileLength",B.n,1),324,A.f("TileOffsets",B.n,q),325,A.f("TileByteCounts",B.d,q),326,A.f("BadFaxLines",B.d,q),327,A.f("CleanFaxData",B.d,q),328,A.f("ConsecutiveBadFaxLines",B.d,q),332,A.f("InkSet",B.d,q),333,A.f("InkNames",B.d,q),334,A.f("NumberofInks",B.d,q),336,A.f("DotRange",B.d,q),337,A.f("TargetPrinter",B.j,q),338,A.f("ExtraSamples",B.d,q),339,A.f("SampleFormat",B.h,1),340,A.f("SMinSampleValue",B.d,q),341,A.f("SMaxSampleValue",B.d,q),342,A.f("TransferRange",B.d,q),343,A.f("ClipPath",B.d,q),512,A.f("JPEGProc",B.d,q),513,A.f("JPEGInterchangeFormat",B.d,q),514,A.f("JPEGInterchangeFormatLength",B.d,q),529,A.f("YCbCrCoefficients",B.q,3),530,A.f("YCbCrSubSampling",B.h,1),531,A.f("YCbCrPositioning",B.h,1),532,A.f("ReferenceBlackWhite",B.q,6),700,A.f("ApplicationNotes",B.h,1),18246,A.f("Rating",B.h,1),33421,A.f("CFARepeatPatternDim",B.d,q),33422,A.f("CFAPattern",B.d,q),33423,A.f("BatteryLevel",B.d,q),33432,A.f("Copyright",B.j,q),33434,A.f("ExposureTime",B.q,1),33437,A.f("FNumber",B.q,q),33723,A.f("IPTC-NAA",B.n,1),34665,A.f("ExifOffset",B.d,q),34675,A.f("InterColorProfile",B.d,q),34850,A.f("ExposureProgram",B.h,1),34852,A.f("SpectralSensitivity",B.j,q),34853,A.f("GPSOffset",B.d,q),34855,A.f(p,B.n,1),34856,A.f("OECF",B.d,q),34864,A.f("SensitivityType",B.h,1),34866,A.f("RecommendedExposureIndex",B.n,1),34867,A.f(p,B.n,1),36864,A.f("ExifVersion",B.D,q),36867,A.f("DateTimeOriginal",B.j,q),36868,A.f("DateTimeDigitized",B.j,q),36880,A.f("OffsetTime",B.j,q),36881,A.f("OffsetTimeOriginal",B.j,q),36882,A.f("OffsetTimeDigitized",B.j,q),37121,A.f("ComponentsConfiguration",B.D,q),37122,A.f("CompressedBitsPerPixel",B.d,q),37377,A.f("ShutterSpeedValue",B.d,q),37378,A.f("ApertureValue",B.d,q),37379,A.f("BrightnessValue",B.d,q),37380,A.f("ExposureBiasValue",B.d,q),37381,A.f("MaxApertureValue",B.d,q),37382,A.f("SubjectDistance",B.d,q),37383,A.f("MeteringMode",B.d,q),37384,A.f("LightSource",B.d,q),37385,A.f("Flash",B.d,q),37386,A.f("FocalLength",B.d,q),37396,A.f("SubjectArea",B.d,q),37500,A.f("MakerNote",B.D,q),37510,A.f("UserComment",B.D,q),37520,A.f("SubSecTime",B.d,q),37521,A.f("SubSecTimeOriginal",B.d,q),37522,A.f("SubSecTimeDigitized",B.d,q),40091,A.f("XPTitle",B.d,q),40092,A.f("XPComment",B.d,q),40093,A.f("XPAuthor",B.d,q),40094,A.f("XPKeywords",B.d,q),40095,A.f("XPSubject",B.d,q),40960,A.f("FlashPixVersion",B.d,q),40961,A.f("ColorSpace",B.h,1),40962,A.f("ExifImageWidth",B.h,1),40963,A.f("ExifImageLength",B.h,1),40964,A.f("RelatedSoundFile",B.d,q),40965,A.f("InteroperabilityOffset",B.d,q),41483,A.f("FlashEnergy",B.d,q),41484,A.f("SpatialFrequencyResponse",B.d,q),41486,A.f("FocalPlaneXResolution",B.d,q),41487,A.f("FocalPlaneYResolution",B.d,q),41488,A.f("FocalPlaneResolutionUnit",B.d,q),41492,A.f("SubjectLocation",B.d,q),41493,A.f("ExposureIndex",B.d,q),41495,A.f("SensingMethod",B.d,q),41728,A.f("FileSource",B.d,q),41729,A.f("SceneType",B.d,q),41730,A.f("CVAPattern",B.d,q),41985,A.f("CustomRendered",B.d,q),41986,A.f("ExposureMode",B.d,q),41987,A.f("WhiteBalance",B.d,q),41988,A.f("DigitalZoomRatio",B.d,q),41989,A.f("FocalLengthIn35mmFilm",B.d,q),41990,A.f("SceneCaptureType",B.d,q),41991,A.f("GainControl",B.d,q),41992,A.f("Contrast",B.d,q),41993,A.f("Saturation",B.d,q),41994,A.f("Sharpness",B.d,q),41995,A.f("DeviceSettingDescription",B.d,q),41996,A.f("SubjectDistanceRange",B.d,q),42016,A.f("ImageUniqueID",B.d,q),42032,A.f("CameraOwnerName",B.j,q),42033,A.f("BodySerialNumber",B.j,q),42034,A.f("LensSpecification",B.d,q),42035,A.f("LensMake",B.j,q),42036,A.f("LensModel",B.j,q),42037,A.f("LensSerialNumber",B.j,q),42240,A.f("Gamma",B.q,1),50341,A.f("PrintIM",B.d,q),59932,A.f("Padding",B.d,q),59933,A.f("OffsetSchema",B.d,q),65e3,A.f("OwnerName",B.j,q),65001,A.f("SerialNumber",B.j,q)],t.p,A.S("fr"))})
s($,"vD","pa",()=>new A.fs(new WeakMap(),A.S("fs<hz>")))
s($,"vB","mU",()=>{var q,p=A.en(768),o=J.bB(256,t.p)
for(q=0;q<256;++q)o[q]=q
B.c.aI(p,256,512,o)
B.c.ao(p,512,768,255)
return p})
s($,"v_","ib",()=>A.q9(A.m([0,1,8,16,9,2,3,10,17,24,32,25,18,11,4,5,12,19,26,33,40,48,41,34,27,20,13,6,7,14,21,28,35,42,49,56,57,50,43,36,29,22,15,23,30,37,44,51,58,59,52,45,38,31,39,46,53,60,61,54,47,55,62,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63],t.t)))
r($,"ve","mN",()=>A.en(511))
r($,"vf","mO",()=>A.en(511))
r($,"vh","mP",()=>A.nE(2041))
r($,"vi","mQ",()=>A.nE(225))
r($,"vg","lB",()=>A.en(766))
s($,"vj","p4",()=>A.n8(0,0,0,0))
s($,"v1","oU",()=>A.nq(0,0,0))
s($,"vz","ak",()=>A.en(1))
s($,"vA","at",()=>A.pL(B.c.gA($.ak()),0,null))
s($,"vs","aj",()=>A.q5(1))
s($,"vt","as",()=>J.pd(B.A.gA($.aj()),0,null))
s($,"vu","O",()=>A.q7(1))
s($,"vw","a1",()=>J.pe(B.l.gA($.O()),0,null))
s($,"vv","bO",()=>A.pD(B.l.gA($.O())))
s($,"vq","ic",()=>A.q2(1))
s($,"vr","lC",()=>A.nS(B.G.gA($.ic()),0))
s($,"vo","mS",()=>A.q_(1))
s($,"vp","p8",()=>A.nS(B.M.gA($.mS()),0))
s($,"vx","mT",()=>A.qs(1))
s($,"vy","p9",()=>{var q=$.mT()
return A.pE(q.gA(q))})})();(function nativeSupport(){!function(){var s=function(a){var m={}
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
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.d7,SharedArrayBuffer:A.d7,ArrayBufferView:A.ej,DataView:A.h7,Float32Array:A.ed,Float64Array:A.ee,Int16Array:A.ef,Int32Array:A.eg,Int8Array:A.eh,Uint16Array:A.ek,Uint32Array:A.el,Uint8ClampedArray:A.em,CanvasPixelArray:A.em,Uint8Array:A.c9})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,SharedArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.d8.$nativeSuperclassTag="ArrayBufferView"
A.eU.$nativeSuperclassTag="ArrayBufferView"
A.eV.$nativeSuperclassTag="ArrayBufferView"
A.ei.$nativeSuperclassTag="ArrayBufferView"
A.eW.$nativeSuperclassTag="ArrayBufferView"
A.eX.$nativeSuperclassTag="ArrayBufferView"
A.aG.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$0=function(){return this()}
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$6=function(a,b,c,d,e,f){return this(a,b,c,d,e,f)}
Function.prototype.$5=function(a,b,c,d,e){return this(a,b,c,d,e)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$1$1=function(a){return this(a)}
Function.prototype.$2$1=function(a){return this(a)}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=A.u5
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=prepararFoto.js.map
