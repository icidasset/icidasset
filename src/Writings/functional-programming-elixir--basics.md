---
title: "Functional Programming & Elixir – Pt. 1, The Basics"
category: "Code"
published: true
promote: true
---

*It might be difficult to get into functional programming because of
the complexity and the terminology. The goal of these articles is to
explain the terminology in a simple manner, reduce the complexity and
at the same time, give code samples written in Elixir and
show how Elixir helps us with functional programming.  
__This first article is all about functions, variables and patterns.__*



## Functions

### First-class functions

This doesn't say much, but it basically just means that functions
can be stored in variables, that you can pass them to other functions
and invoke them there. In Elixir these are called __anonymous functions__.

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
```

*<small>`/0` is the amount of arguments the function accepts, ie. the arity</small>*

There's also another syntax which you'll see sometimes, for example:

```elixir
Enum.reduce(["hello", " ", "world"], &(&2 <> &1))
```

*<small>Returns "hello world"</small>*

So what is this `&(&2 <> &1)` thing?
It's a concise anonymous function, a so-called partially applied function.
Where `&1` is the first argument of the function and `&2` the second.

To fully explain the example, `<>` concats the two strings (ie. the two function arguments).
Check the [Elixir docs](http://elixir-lang.org/docs/v1.1/elixir/Enum.html#reduce/2)
for more info about the `Enum.reduce` function.


### Composing

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
multiply_by_four.(add_one.(1))             # returns '8'
multiply_by_four.(add_one.(add_one.(2)))   # returns '16'
```

Elixir provides a way to make it more clear what we're trying to do here.
This operator is called the pipe operator.

```elixir
# This is easier to read, especially for mathematical operations.
# ((2 + 1) + 1) * 4
2 |> add_one.() |> add_one.() |> multiply_by_four.()
```

*<small>This is the syntax for anonymous functions, which looks a bit odd, if I were using named functions I could omit the trailing `.()`</small>*


### Closures

A closure is a function which has the following properties:

- Is a first-class function.
- Remembers the values of all the variables in scope when the function was created.

```elixir
x = 2

f_x = fn ->
  y = :math.pow(x, 2)
  y
end

f_x.() # returns 4

x = 3

f_x.() # still returns 4
```

*<small>`:math` is a Erlang module, which in Elixir are represented by atoms. Elixir runs on top of the [Erlang VM](https://medium.com/r/?url=http%3A%2F%2Fwww.erlang-factory.com%2Fupload%2Fpresentations%2F708%2FHitchhikersTouroftheBEAM.pdf), which makes it possible to use Erlang code with Elixir</small>*


### Higher-order functions

A higher-order function (HoF) is a function which takes one or more functions as arguments
and/or a function that returns a new function, *which is a closure*.

#### Example

```elixir
in_p_tags = &("<p>" <> &1 <> "</p>")
in_nav_tags = &("<nav>" <> &1 <> "</nav>")
in_body_tags = &("<body>" <> &1 <> "</body>")

wrap = fn(wrapping_functions) ->
  fn(html) ->
    reducer = fn(function, acc) -> function.(acc) end
    Enum.reduce(wrapping_functions, html, reducer)
  end
end

wrap.([in_p_tags, in_body_tags]).("Text")

# result:
# <body><p>Text</p></body>

wrap.([in_nav_tags, in_body_tags]).("<a href=\"...\">Link</a>")

# result:
# <body><nav><a href="...">Link</a></nav></body>
```

This example sums it up, we have:

- First-class functions
- Function composition in the form of a reducer
- A closure, the function returned by the `wrap` function
- A higher-order function named `wrap`




## Pattern matching & Immutability

In Elixir the `=` operator doesn't only do assignment, but also pattern matching.
That's why it's called the __match__ operator. This also means that variables
aren't really places in memory that values are stored in, but rather
__labels for the values__. That is, Elixir/Erlang allocates memory for the
values, not the variables.

```elixir
# attached the value '1' to the label 'nr'
nr = 1

# rebind the 'nr' label to the value '2'
nr = 2

# let's see why this is called the match operator
# the following is a valid expression,
# because of the previous expression
2 = nr

# this is not, because 3 does not match 2,
# this will raise a MatchError
3 = nr
```

We can also do destructuring:

```elixir
# 1. destructure by using tuples
{ a, b } = { :ok, "Hi" }

do_something_with(a)

# this won't work,
# we need 3 variable names on the left side
{ a, b } = { :ok, "Hi", "extra-extra" }

# this will work
{ a, b, type } = { :ok, "Hi", "extra-extra" }
{ a, b, _ } = { :ok, "Hi", "extra-extra" }

# 2. destructure by using lists
[ a, b ] = [ "first", "second" ]
```

*<small>`_` is used to ignore a value</small>*

#### Why this is useful

Say you have a function that returns a tuple,  
but you don't want to do this all the time:

```elixir
result = some_function()
state = elem(result, 0)
message = elem(result, 1)
```

*<small>`elem` gets a specific item out of the tuple.</small>*

Wouldn't it be way easier if we could just write:

```elixir
{ state, message } = some_function()
```

Yes, it is.

### Immutability

With that in mind, in Elixir, all data types are immutable.

```elixir
tuple = { :number, 1 }

# if we would change the tuple, we would get a new one
# for example, change the second value in the tuple:
put_elem(tuple, 1, 1000)

# returns new tuple: { :number, 1000 }
# tuple variable still points to the tuple: { :number, 1 }
```

#### Why this is useful

Imagine if we didn't have immutable date types.

```elixir
state = %{ example: "Property" }

func_a = fn(s) ->
  # remove 'example' property from the state map
  Map.delete(s, :example)
end

func_b = fn(s) ->
  str = s.example <> ": example"
end

func_a.(state)
func_b.(state)
```

*<small>`%{}` is a key-value store, a
[map](http://elixir-lang.org/docs/stable/elixir/Map.html)</small>*

In this case `func_b` would break,
because it depends on the `example` property and
we deleted that property in `func_a`.

If we apply immutability,
for example, `Map.delete` produces an error,
or as in Elixir, `Map.delete` returns a new map
and doesn't touch the original map,
`func_b` will work fine.




## Conclusion

I think we have discussed all the basics of functional programming and Elixir.
Except for some basic Elixir types, but you can look those up easily. Elixir has
some pretty good
[getting-started guides](http://elixir-lang.org/getting-started/introduction.html).

__Next up in the functional programming category is what to do and what not do with
functions.__ Or to put in technical terms, limiting side-effects, data-first and
using map and reduce instead of a loop.

*<small>Credits: Thanks to [Brooklyn Zelenka](https://twitter.com/expede)
and [Izaak Schroeder](https://twitter.com/izaakschroeder)
for all the help!</small>*
