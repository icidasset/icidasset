---
title = "Functional Programming & Elixir"
category = "Code"
published = true
promote = true
---

It might be difficult to get into functional programming because of
the complexity and the terminology. The goal of this article is to
explain the terminology in a simple manner, reduce the complexity and
at the same time, give code samples written in Elixir and
show how Elixir helps us with functional programming.



## Some quick basics

### First-class functions

Basically just means that functions can be stored in variables,
that you can pass them to other functions and invoke them there.
In Elixir this is called __anonymous functions__.

```elixir
some_function = fn(arg) -> do_whatever end
```

You also have __named functions__.

```elixir
defmodule Do do
  def something do
    do_whatever
  end
end
```

These cannot be passed down to other functions.
But you can convert them to anonymous functions.

```elixir
some_function.( &Do.something/0 )
# /0 is the amount of arguments the function accepts, ie. the arity
```

There's also another syntax which you'll see sometimes, for example:

```elixir
Enum.reduce(["hello", " ", "world"], &(&2 <> &1))
# returns "hello world"
```

So what is this `&(&2 <> &1)` thing?
It's a concise anonymous function, a so-called partially applied function.
Where `&1` is the first argument of the function and `&2` the second.

To fully explain the example, `<>` concats the two strings (ie. the two function arguments).
Check the [Elixir docs](http://elixir-lang.org/docs/v1.1/elixir/Enum.html#reduce/2)
for more info about the `Enum.reduce` function.

### Closures

A closure is a function which has the following properties:

- Is a first-class function.
- Remembers the values of all the variables in scope when the function was created.

```elixir
x = 2

f_x = fn ->
  y = :math.pow(x, 2) # use the math module from Erlang
  y
end

f_x.() # returns 4

x = 3

f_x.() # still returns 4
```

### Higher-order functions

A higher-order function is a function which takes one or more functions as arguments
and returns a new function.



## Pattern matching & Immutability

In Elixir the `=` operator doesn't do an assignment, but rather pattern matching.
This also means that variables aren't really places in memory that values are stored in,
but rather labels for the values. That is, Elixir/Erlang allocates memory for the
values, not the variables.

```elixir
# the value '1' is attached to the label 'nr'
nr = 1

# now we'll rebind the 'nr' label to the value '2'
nr = 2
```

In Elixir, all data types are immutable.

```elixir
tuple = { :number, 1 }

# if we would change the tuple, we would get a new one
# for example, change the second value in the tuple:
put_elem(tuple, 1, 1000)

# returns new tuple: { :number, 1000 }
# tuple variable still points to the tuple: { :number, 1 }
```

[More about pattern matching](http://elixir-lang.org/getting-started/pattern-matching.html).


## Composing

Composing, *function composition*, is essentially executing a sequence of functions.
That is, the result of each function is passed as the argument of the next.

```elixir
add_one = fn(integer) ->
  integer + 1
end

multiply_by_four = fn(integer) ->
  integer * 4
end

# execute functions
multiply_by_four.(add_one.(1))            # returns '8'
multiply_by_four.(add_one.(add_one.(2)))   # returns '16'
```

Elixir provides a way to make it more clear what we're trying to do here.

```elixir
# This is easier to read, especially for mathematical operations.
# ((2 + 1) + 1) * 4
2 |> add_one |> add_one |> multiply_by_four
```


## Monads

A monad is a design pattern that uses function composition.
Or in other words, it shows us how we can use function composition in a good way.

Benefits of this design pattern:

- Execute long sequences without running into problems
- Early return/exit from a sequence


### Example of a problem

Lets continue with the previous example.

```elixir
divide_10_by = fn(integer) ->
  10 / integer
end
```

Ok so, this introduces a few problems if we would use this function
in combination with the other functions we defined.

1. The division operator `/` in Elixir always returns a float,
   while our functions expect integers.
2. If we divide by zero, it gives us an error.

How are we going to solve these problems?
By introducing a monad.


### Applying the pattern

The monad pattern also defines a few other things:

- A type constructor, which is called 'the monadic type'
- A unit function
- A binding operation

Lets explain these one by one.

#### Type constructor

The monadic type is the type of the value our bind function should return.
In our case this is the union of an 'integer' and a 'nil' value.
So, in other words, it's either an integer or nil.
Much like the optional types in [Rust](https://doc.rust-lang.org/std/option/)
and [Swift](http://swiftdoc.org/v2.1/type/Optional/).

```elixir
# one of these, an integer or nil:
value = 1
value = nil
```

#### Unit function

The unit function is responsible for the, initial, conversion
of a value of an unknown type into a type that our bind function can deal with.

```elixir
unit = fn(value) ->
  if is_integer(value) || is_float(value) do
    value
  else
    nil
  end
end
```

#### Binding operation

The binding function is, in general, responsible for:

- Taking the output of one of our functions relating to this monad
- Return the monadic type
- Executing the given function without producing an error

Also, relating to our specific problem:

- If the value equals zero, return nil
- Converting the float value, returned by our `divide_10_by` function, to an integer
- If the value is not an integer or a float, do not execute the given function

```elixir
bind = fn(value, function) ->
  cond do
    value == 0 -> nil
    is_float(value) -> function.(Float.round(value))
    is_integer(value) -> function.(value)
    true -> value
  end
end
```

#### New code

```elixir
run_composition = fn(value) ->
  bind.(bind.(bind.(unit.(x), divide_10_by), add_one), multiply_by_four)
end

run_composition.(2)  # returns '24'
```

The example will now still work if we try to divide by zero,
or if we would pass anything other than a integer, float or nil.

```elixir
run_composition.(0)              # returns nil
run_composition.(false)          # returns nil
run_composition.("still-works")  # returns nil
```

It also fails fast now, the functions `add_one` and `multiply_by_four` are never executed.
