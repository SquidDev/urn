# ![](https://i.imgur.com/XqKyCMC.png) Urn [![Travis Build Status](https://travis-ci.org/SquidDev/urn.svg?branch=master)](https://travis-ci.org/SquidDev/urn) [![Build status](https://gitlab.com/urn/urn/badges/master/build.svg)](https://gitlab.com/urn/urn/commits/master)

Urn is a new language developed by SquidDev, and demhydraz. Urn is a Lisp dialect with a focus on minimalism which compiles
to Lua.

## What?
 - A minimal¹ Lisp implementation, with full support for compile time code execution and macros.
 - Support for Lua 5.1, 5.2 and 5.3. Should also work with LuaJIT.
 - Lisp-1 scoping rules (functions and data share the same namespace).
 - Influenced by a whole range of Lisp implementations, including Common Lisp and Clojure.
 - Produces standalone, optimised Lua files: no dependencies on a standard library.

¹: Minimalism is an implementation detail.

## Features
### Pattern matching
<pre style="color:#ffffff;background-color:#2e3436;">
<span style="color:#8ae234;">&gt; </span>(case &#39;(&quot;x&quot; (foo 2 3))
<span style="color:#8ae234;">. </span>  [(string?  @ ?x) (.. &quot;Got a string &quot; x)]
<span style="color:#8ae234;">. </span>  [(&quot;x&quot; (foo . ?x)) (.. &quot;Got some remaining values &quot; (pretty x))])
out = <span style="color:#ff9d3a;">&quot;Got some remaining values (2 3)&quot;</span>
</pre>

### Various looping constructs
<pre style="color:#ffffff;background-color:#2e3436;">
<span style="color:#8ae234;">&gt; </span>(loop [(o &#39;())
<span style="color:#8ae234;">. </span>       (l &#39;(1 2 3))]
<span style="color:#8ae234;">. </span>  [(empty? l) o]
<span style="color:#8ae234;">. </span>  (recur (cons (car l) o) (cdr l)))
out = <span style="color:#ff9d3a;">(3 2 1)</span>
</pre>

### Powerful assertion and testing framework
<pre style="color:#ffffff;background-color:#2e3436;">
<span style="color:#8ae234;">&gt; </span>(import test ())
out = <span style="color:#ff9d3a;">nil</span>
<span style="color:#8ae234;">&gt; </span>(affirm (eq? &#39;(&quot;foo&quot; &quot;bar&quot; &quot;&quot;)
<span style="color:#8ae234;">. </span>             (string/split &quot;foo-bar&quot; &quot;-&quot;)))
<span style="color:#cc0000;">[ERROR] &lt;stdin&gt;:1 (compile#111{split,temp}:46): Assertion failed</span>
(eq? (quote (&quot;foo&quot; &quot;bar&quot; &quot;&quot;)) (string/split &quot;foo-bar&quot; &quot;-&quot;))
     |                        |
     |                        (&quot;foo&quot; &quot;bar&quot;)
     (&quot;foo&quot; &quot;bar&quot; &quot;&quot;)
</pre>

### First-class support for Lua tables
<pre style="color:#ffffff;background-color:#2e3436;">
<span style="color:#8ae234;">&gt; </span>{ :foo 1
<span style="color:#8ae234;">. </span>  :bar 2 }
out = <span style="color:#ff9d3a;">{&quot;bar&quot; 2 &quot;foo&quot; 1}</span>
</pre>

### Friendly error messages
<pre style="color:#ffffff;background-color:#2e3436;">
<span style="color:#8ae234;">&gt; </span>(]
<span style="color:#cc0000;">[ERROR] Expected &#39;)&#39;, got &#39;]&#39;</span>
<span style="color:#ff9d3a;">  =&gt; &lt;stdin&gt;:[1:2 .. 1:2] (&quot;]&quot;)</span>
<span style="color:#8ae234;"> 1 │</span> (]
<span style="color:#8ae234;">   │</span> ^... block opened with &#39;(&#39;
<span style="color:#8ae234;"> 1 │</span> (]
<span style="color:#8ae234;">   │</span>  ^ &#39;]&#39; used here
<span style="color:#8ae234;">&gt; </span>
</pre>

## Getting started
We have a [getting started guide](https://squiddev.github.io/urn/tutorial/01-introduction.html) to help you get set up. Or
you can [clone the repo](https://gitlab.com/urn/urn) and jump right in!

The website also contains [documentation for all functions and macros](https://squiddev.github.io/urn/docs/lib.prelude.html),
should you need to check how something works.

If you have any questions, would like to contribute or just feel like chatting, do join us in the `#urn` channel on FreeNode.
