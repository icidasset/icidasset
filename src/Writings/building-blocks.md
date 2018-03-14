---
title: "Building Blocks"
category: "Code"
published: false
published_on: null
promote: false
---


_This is a more visual approach to the topic of purely-typed functional programming. What does it mean to have a "pure" programming language? What are types? What do you mean by "functional" programming? These are the questions we will answer here, with a focus on simplicity._



## The Case For Simplicity

![](/images/fp/simple.png)

Not intertwined.

![](/images/fp/complex.png)

Intertwined.

---

> Simplicity is a prerequisite for reliability.

— Edsger W. Dijkstra

> The benefits of simplicity are: ease of understanding, ease of change, ease of debugging, flexibility.

— Rich Hickey

---

[Simple Made Easy](https://www.infoq.com/presentations/Simple-Made-Easy) pretty much says it all.



## The Case For Purity

> Not mixed or adulterated with any other substance or material.

— Definition of the adjective __pure__

This is very close to the concept of _simplicity_.

Purity in programming means that we don't want any side effects, or at least manage them properly. Or to put it differently, we want a function to always have the same output given the same input. For example, say you have a function that makes an HTTP request, you can't guarantee that that request will always return the same thing, it's impure.

![](/images/fp/impure-function.png)

Having a pure function means that we have certain guarantees, we can use mathematics and category theory now. This is a pure function:

![](/images/fp/pure-function-1.png)

Given a function `f` which takes the argument `A` and returns `B`, and another function `g` which takes the argument `B` and returns `C`. Category theory says there must always be a function that takes the argument `A` and returns `C`, a composition of the functions `f` and `g`. We will call this function `h`:

![](/images/fp/pure-function-2.png)

> Composition is the essence of programming.

— [Bartosz Milewski](https://bartoszmilewski.com/2014/11/04/category-the-essence-of-composition/)

__To summarize, why is it useful that a function is pure:__
1. Same input equals to same output, always.
2. We have the benefits of simplicity.  
   <small>Ease of understanding, etc.</small>
3. Allows for function composition.  
   <small>Which in turn allows for other mathematical operations.</small>



## The Case For Types

Using types we can define a blueprint, a specification, for a function:

![](/images/fp/types.png)

Our compiler now knows what to expect from this function, and consequently, the compiler can tell us if something is wrong. We don't have to wait until the code is being executed at runtime. It's also easier for us to understand what the function does, the function signature already gives us a hint. Or sometimes, as in this example, it gives us the full picture.

And yes, types don't cover everything, we still need tests, especially for logic. Also varies on the programming language you are using.

_Here again mathematics comes into play, this time in the form of type theory and set theory. I won't go into it here, the only thing I will say is that it allows us again to make certain assumptions and guarantees about our code._



## The Case For Functional

The previous cases are all part of [pure-functional-programming languages](https://en.wikipedia.org/wiki/List_of_programming_languages_by_type#Pure). But there are still quite a few things that are interesting.


### Immutability

![](/images/fp/immutability.png)

Immutability goes hand-in-hand with purity,
we don't want anything changing from underneath us.


### Abstractions

In functional programming there's no abstraction of data mutation
and shared pointers (no objects like in object-oriented programming).
This allows us to easily do concurrent programming.
