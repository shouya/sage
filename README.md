# sage
Yet another lambda calculus interpreter

## Requirements
Tested with Ruby 2.0, but Ruby 1.8+ should also work.

You need to install the gem `treetop`.

## Run
The bundler way:
```
$ bundle install
$ bundle exec bin/sage
```

Or the normal way:
```
$ gem install treetop
$ bin/sage
```

## REPL Usage
Just simply input your &lambda; expression and *sage* will evaluate it.
```
sage> (\x.\y.y) x y
1: (\x.\y.y) x y
2: (\y.y) y
3: y
y
sage>
```

You can define value or combinators yourself using syntax:
```
sage> :let flip (\f.\x.\y.f y x)
sage> flip
\f.\x.\y.f y x
sage> flip (\x.\y.x) a b
b
```

They're also undefinable:
```
sage> :undef flip
sage> flip
flip
```


Test whether two &lambda; expressions are &alpha;-equivalent or &beta;-equivalent:
```
sage> :eqv (\x.\y.x) (\y.\x.y)
true
sage> :eqv (\x.\y.x) (\x.\y.y)
false
sage> :eqv (\x.\y.x) (flip (\x.\y.y))
true
```
Type `:q` or `:exit` to quit the program.

## Options
You can modify the options to change the behavior of the interpreter.

The options available now are:
```ruby
@options = {
  :reduce  => [:bool, true],
  :step    => [:bool, true],
  :onestep => [:bool, false],
  :limit   => [:int,  100],
  :textout => [:bool, true],
  :parseresult => [:bool, true]
}
```

- reduce: determine whether it hold the value or reduce it
- step: display reduction step
- onestep: only reduce once for the expressions
- limit: reduction step number limit. those over this limit will be
  interrupted
- textout: output text instead of ruby array as result
- parseresult: if the result has a matched predefined name, display it

You can input commands like:
```
sage> :set -step         # turn on step
sage> :set +onestep      # turn off onestep
sage> :set limit 30      # set limit to 30
```

And you can query the current options set:
```
sage> :options
name    type    value
reduce  bool    true
step    bool    true
onestep bool    false
limit   int     100
textout bool    true
parseresult     bool    true
```



## Pre-defined values and combinators
Sage has many built-in values and combinators:
```ruby
BUILTIN_COMBINATORS = {
  :Y     => '\f.(\x.f (x x)) (\x.f (x x))',
  :succ  => '\n.\f.\x.f (n f x)',
  :pred  => '\n.\f.\x.n (\g.\h.h (g f)) (\u.x) (\u.u)',

  :zero  => '\f.\x.x',
  :one   => '\f.\x.f x',
  :two   => 'succ one',
  :three => 'succ two',
  :four  => 'succ three',
  :five  => 'succ four',
  :six   => 'succ five',
  :seven => 'succ six',
  :eight => 'succ seven',
  :nine  => 'succ eight',
  :ten   => 'succ nine',

  :plus  => '\m.\n.\f.\x.m f (n f x)',
  :sub   => '\m.\n.(n pred) m',
  :mult  => '\m.\n.\f.m (n f)',
  :exp   => '\m.\n.n m',

  :true  => '\a.\b.a',
  :false => '\a.\b.b',

  :and   => '\m.\n.m n m',
  :or    => '\m.\n.m m n',
  :not   => '\m.\a.\b.m b a',
  :not1  => '\m.m (\a.\b.b) (\a.\b.a)',
  :if    => '\m.\a.\b.m a b',

  :cons  => '\x.\y.\f.f x y',
  :car   => '\c.c (\x.\y.x)',
  :cdr   => '\c.c (\x.\y.y)',
  :nil   => '\x.true',
  :isnil => '\p.p (\x.\y.false)',

  :iszero =>'\n.n (\x.false) true',
}
```

You're free to use them directly in the REPL:
```
sage> plus one two
<three>: \f.\x.f (f (f x))
```

## Acknowledgment
Specially thanks to Shengyi Wang and his great job
[lambda calculus for beginners](https://github.com/txyyss/Lambda-Calculus/),
with which I found the lambda world so spectacular.

And Yin Wang's slide
[Reinventing Y Combinator](http://www.slideshare.net/yinwang0/reinventing-the-ycombinator).

## License
MIT License, see `LICENSE` file for details.




