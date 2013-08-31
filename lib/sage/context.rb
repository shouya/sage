

module Sage
  class Context < Hash
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

      :cons  => '\x.\y.\z.z x y',
      :car   => '\c.c (\x.\y.x)',
      :cdr   => '\c.c (\x.\y.y)',
      :nil   => 'pair true true',

      :ispair =>'car',
      :iszero =>'\n.n (\x.false) true',
    }

    def load_builtin_combinators(parser = SageParser.new)
      BUILTIN_COMBINATORS.each do |name, lamb|
        store(name,parser.parse(lamb).parse.reduce(self, 1000))
      end
    end
  end
end


