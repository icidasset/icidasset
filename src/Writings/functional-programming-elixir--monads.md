---
title: "Functional Programming & Elixir – Pt. 2, Monads"
category: "Code"
published: false
promote: true
---

_**Note:** This article is still a work in progress, so feedback is welcome._

A monad is a design pattern that uses function composition.
Or in other words, it shows us how we can use function composition in a good way.

Benefits of this design pattern:

- Execute long sequences without running into problems
- Early return/exit from a sequence



## Example of a problem

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



## Applying the pattern

The monad pattern also defines a few other things:

- A type constructor, which is called 'the monadic type'
- A unit function
- A binding operation

Lets explain these one by one.

### Type constructor

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

### Unit function

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

### Binding operation

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

### New code

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
