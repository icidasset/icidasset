---
title: "Building Blocks"
category: "Code"
published: false
published_on: null
promote: false
---


_This is a more visual approach to the topic of purely-typed functional programming. What does it mean to have a "functional" programming language? What are types? What makes a functional-programming language "pure"? These are the questions we will answer here, with a focus on simplicity._



## Simplicity

![](/images/fp/simple.png)

Not intertwined.

![](/images/fp/complex.png)

Intertwined.

---

> Simplicity is a prerequisite for reliability.

— Edsger W. Dijkstra

> The benefits of simplicity are: ease of understanding, ease of change, ease of debugging, flexibility.

— [Rich Hickey](https://www.infoq.com/presentations/Simple-Made-Easy)



## Functional

![](/images/fp/function.png)

When we say that we are going to do functional programming, we are basically saying that we are mainly going to use functions. That's all there is to it, __just plain functions__.



## Purity

> Not mixed or adulterated with any other substance or material.

— Definition of the adjective __pure__

This is very close to the concept of _simplicity_.

Purity in functional programming means that we don't want any side effects, or at least manage them properly. Or to put it differently, we want a function to always have the same output given the same input. For example, say you have a function that makes an HTTP request, you can't guarantee that that request will always return the same thing, it's impure.

![](/images/fp/impure-function.png)

Having a pure function means that we have certain guarantees, we can use mathematics (category theory) now. This is a pure function:

![](/images/fp/pure-function-1.png)

Given a function `f` which takes the argument `A` and returns `B`, and another function `g` which takes the argument `B` and returns `C`. Category theory says there must always be a function that takes the argument `A` and returns `C`, a composition of the functions `f` and `g`. We will call this function `h`:

![](/images/fp/pure-function-2.png)

> Composition is the essence of programming.

— [Bartosz Milewski](https://bartoszmilewski.com/2014/11/04/category-the-essence-of-composition/)

This goes hand in hand with immutability, another feature of pure-functional-programming languages. Because everything in these languages is immutable, everything is simple.

![](/images/fp/immutability.png)



## Types

> Types are how we group a set of values together that share something in common. Sometimes that commonality is abstract; sometimes it's a specific model of a particular concept or domain.

— Haskell Programming From First Principles (book)

Using types we can define blueprints for our functions:

![](/images/fp/types.png)

Our compiler now knows what to expect from this function, and consequently, the compiler can tell us if something is wrong. We don't have to wait until the code is being executed at runtime. It's also easier for us to understand what the function does, the function signature already gives us a hint. Or sometimes, as in this example, it gives us the full picture. That said, types don't cover everything, we still need tests, especially for logic.

_Here again mathematics comes into play, this time in the form of set theory and type theory. I won't go into it here, the only thing I will say is that it allows us again to make certain assumptions and guarantees about our code._

Every programming language has a set of predefined types, like `Integer` and `Bool`, but we can also make our own types, here's an example of a datatype:

![](/images/fp/union-types.png)

If a function takes an argument of the type `Stacks`, you can use any of these values. You can also make more abstract types:

![](/images/fp/option-type.png)

We could have __some blocks__ or __none__ at all. This is a better way to deal with none-existing values, as opposed to a `null` pointer.



## Conclusion

You may be wondering why am I using the phrase "building blocks", it's because, to me, this really feels like putting blocks together and sometimes dismantling them.

![](/images/fp/our-wall-type.png)

```haskell
dismantleAndGetBlockA :: OurWall -> BlockA
dismantleAndGetBlockA (Wall blockA blockB blockC) = blockA
```

I hope this shows some of basics and advantages of (pure) functional programming. The rabbit hole goes a lot deeper, but I think the basics alone are already super useful.

![](/images/fp/conclusion.png)
