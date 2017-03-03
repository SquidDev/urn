---
title: lib/list
---
# lib/list
## `(all p xs)`
*Defined at lib/list.lisp:58:1*

Test if all elements of `XS` match the predicate `P`.

## `(any p xs)`
*Defined at lib/list.lisp:52:1*

Test for the existence of any element in `XS` matching the predicate `P`.

## `(append xs ys)`
*Defined at lib/list.lisp:116:1*

Concatenate `XS` and `YS`.

## `(car x)`
*Defined at lib/list.lisp:9:1*

Return the first element of the array X

## `(cdr x)`
*Defined at lib/list.lisp:14:1*

Drop the first element of the array `X`, and return the rest.

## `(elem? x xs)`
*Defined at lib/list.lisp:64:1*

Test if `X` is present in the list `XS`.

## `(filter p xs acc)`
*Defined at lib/list.lisp:41:1*

Filter the list `XS` using the predicate `P`. The parameter `ACC` is for internal use only.

## `(flatten xss)`
*Defined at lib/list.lisp:122:1*

Concatenate all the lists in `XSS`. `XSS` must not contain elements which are not lists.

## `(foldr f z xs)`
*Defined at lib/list.lisp:21:1*

Fold over the list `XS` using the binary operator `F` and the starting value `Z`.

## `(for-each var lst &body)`
*Macro defined at lib/list.lisp:108:1*

Perform the set of actions `BODY` for all values in `LST`, binding the current value to `VAR`.

## `(last xs)`
*Defined at lib/list.lisp:78:1*

Return the last element of the list `XS`. (Counterintutively, this function runs in constant time).

## `(map f xs acc)`
*Defined at lib/list.lisp:31:1*

Map over the list `XS` using the unary function `F`. The parameter `ACC`
is for internal use only.

## `(nth xs idx)`
*Defined at lib/list.lisp:83:1*

Get the `IDX` th element in the list `XS`. The first element is 1.

## `(pop-last! xs)`
*Defined at lib/list.lisp:95:1*

Mutate the list `XS`, removing and returning its last element.

## `(prune xs)`
*Defined at lib/list.lisp:69:1*

Remove values matching the predicate [`nil?`](lib.type.md#nil-x) from the list `XS`

## `(push-cdr! xs val)`
*Defined at lib/list.lisp:87:1*

Mutate the list `XS`, adding `VAL` to its end.

## `(range start end acc)`
*Defined at lib/list.lisp:126:1*

Build a list from `START` to `END`. This function is tail recursive, and uses the parameter `ACC` as an accumulator.

## `(remove-nth! li idx)`
*Defined at lib/list.lisp:102:1*

Mutate the list `LI`, removing the value at `IDX` and returning it.

## `(reverse xs acc)`
*Defined at lib/list.lisp:133:1*

Reverse the list `XS`, using the accumulator `ACC`.

## `(traverse xs f)`
*Defined at lib/list.lisp:74:1*

An alias for [`map`](lib.list.md#map-f-xs-acc) with the arguments `XS` and `F` flipped.

## Undocumented symbols
 - `(caaaar x)` *Defined at lib/list.lisp:155:1*
 - `(caaaars xs)` *Defined at lib/list.lisp:186:1*
 - `(caaadr x)` *Defined at lib/list.lisp:156:1*
 - `(caaadrs xs)` *Defined at lib/list.lisp:187:1*
 - `(caaar x)` *Defined at lib/list.lisp:147:1*
 - `(caaars xs)` *Defined at lib/list.lisp:178:1*
 - `(caadar x)` *Defined at lib/list.lisp:157:1*
 - `(caadars xs)` *Defined at lib/list.lisp:188:1*
 - `(caaddr x)` *Defined at lib/list.lisp:158:1*
 - `(caaddrs xs)` *Defined at lib/list.lisp:189:1*
 - `(caadr x)` *Defined at lib/list.lisp:148:1*
 - `(caadrs xs)` *Defined at lib/list.lisp:179:1*
 - `(caar x)` *Defined at lib/list.lisp:142:1*
 - `(caars xs)` *Defined at lib/list.lisp:174:1*
 - `(cadaar x)` *Defined at lib/list.lisp:159:1*
 - `(cadaars xs)` *Defined at lib/list.lisp:190:1*
 - `(cadadr x)` *Defined at lib/list.lisp:160:1*
 - `(cadadrs xs)` *Defined at lib/list.lisp:191:1*
 - `(cadar x)` *Defined at lib/list.lisp:149:1*
 - `(cadars xs)` *Defined at lib/list.lisp:180:1*
 - `(caddar x)` *Defined at lib/list.lisp:161:1*
 - `(caddars xs)` *Defined at lib/list.lisp:192:1*
 - `(cadddr x)` *Defined at lib/list.lisp:162:1*
 - `(cadddrs xs)` *Defined at lib/list.lisp:193:1*
 - `(caddr x)` *Defined at lib/list.lisp:150:1*
 - `(caddrs xs)` *Defined at lib/list.lisp:181:1*
 - `(cadr x)` *Defined at lib/list.lisp:143:1*
 - `(cadrs xs)` *Defined at lib/list.lisp:175:1*
 - `(cars xs)` *Defined at lib/list.lisp:172:1*
 - `(cdaaar x)` *Defined at lib/list.lisp:163:1*
 - `(cdaaars xs)` *Defined at lib/list.lisp:194:1*
 - `(cdaadr x)` *Defined at lib/list.lisp:164:1*
 - `(cdaadrs xs)` *Defined at lib/list.lisp:195:1*
 - `(cdaar x)` *Defined at lib/list.lisp:151:1*
 - `(cdaars xs)` *Defined at lib/list.lisp:182:1*
 - `(cdadar x)` *Defined at lib/list.lisp:165:1*
 - `(cdadars xs)` *Defined at lib/list.lisp:196:1*
 - `(cdaddr x)` *Defined at lib/list.lisp:166:1*
 - `(cdaddrs xs)` *Defined at lib/list.lisp:197:1*
 - `(cdadr x)` *Defined at lib/list.lisp:152:1*
 - `(cdadrs xs)` *Defined at lib/list.lisp:183:1*
 - `(cdar x)` *Defined at lib/list.lisp:144:1*
 - `(cdars xs)` *Defined at lib/list.lisp:176:1*
 - `(cddaar x)` *Defined at lib/list.lisp:167:1*
 - `(cddaars xs)` *Defined at lib/list.lisp:198:1*
 - `(cddadr x)` *Defined at lib/list.lisp:168:1*
 - `(cddadrs xs)` *Defined at lib/list.lisp:199:1*
 - `(cddar x)` *Defined at lib/list.lisp:153:1*
 - `(cddars xs)` *Defined at lib/list.lisp:184:1*
 - `(cdddar x)` *Defined at lib/list.lisp:169:1*
 - `(cdddars xs)` *Defined at lib/list.lisp:200:1*
 - `(cddddr x)` *Defined at lib/list.lisp:170:1*
 - `(cddddrs xs)` *Defined at lib/list.lisp:201:1*
 - `(cdddr x)` *Defined at lib/list.lisp:154:1*
 - `(cdddrs xs)` *Defined at lib/list.lisp:185:1*
 - `(cddr x)` *Defined at lib/list.lisp:145:1*
 - `(cddrs xs)` *Defined at lib/list.lisp:177:1*
 - `(cdrs xs)` *Defined at lib/list.lisp:173:1*
