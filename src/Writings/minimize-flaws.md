---
title: "How do we use (typed) functional programming to minimize our flaws"
short_title: "Minimize Flaws Using Functional Programming"
category: "Code"
published: true
published_on: 26-06-2017
promote: false
---

_This is the written version of [a talk I did recently](http://flaws.icidasset.com/). How can we make our code more predictable and easier to reason about, and how can we use typed functional programming to do that._



## Elm & Haskell

For this article I chose [Elm](http://elm-lang.org/) and [Haskell](https://haskell-lang.org/), because I enjoy working with them and also Elm is really easy to learn. Haskell isn't, but the basic code in this article is pretty much the same. More on Haskell later.



## Predictability

Our applications get complicated no matter how awesome of a programmer we are. So how can we make our code less complex and more predictable?


### Immutability and pure functions

One way functional programming helps us with this is by using the concepts of immutability and pure functions.

```elm
myLittleFriend : String
myLittleFriend =
    "Tony"

sayHelloTo : String -> String
sayHelloTo name =
    String.join " " [ "Hello", name ]

sayHelloToTony : String
sayHelloToTony =
    sayHelloTo myLittleFriend
```

There's no way we can change <x-cl-6>myLittleFriend</x-cl-6> or <x-cl-6>sayHelloTo</x-cl-6> once they are defined, they are immutable. They also have no side effects, meaning that there are no calls to something outside our control. At all times we know what's going on, or at least the compiler does. So our <x-cl-6>sayHelloToTony</x-cl-6> function is **guaranteed to produce the same result every time**.

```elm
myLittleFriend : String
myLittleFriend =
    "Tony"

sayHelloToFrank : String
sayHelloToFrank =
    let
        myLittleFriend = "Frank"
    in
        sayHelloTo myLittleFriend
```

If we would write a new function called <x-cl-6>sayHelloToFrank</x-cl-6> where we bind the string `"Frank"` to `myLittleFriend`, but only in the context of this new function. This will not change our original top level binding of <x-cl-6>myLittleFriend</x-cl-6>, so in other words, our <x-cl-6>sayHelloToTony</x-cl-6> function will still return the same value.

Now, that sounds great and all, but didn't you say that Elm is used for web applications? It has to use the DOM and the browser environment right? Which is one big mess of code that's outside our control, that could change at any time without us knowing? Yup, exactly. Javascript is a giant ball of side effects. Gets messy real fast.

Elm took that ball of side effects away from us, so in our functions we can't talk to anything relating to our browser environment or the DOM. It gets around that problem by enforcing a specific structure to talk to the outside world. It's like making sure your cat goes to the litter box, instead of it, you know, taking a shit in your couch.

Anyway, our functions having no side effects means that every function is pure, or in other words, **every function's return value is only determined by its input values**. And so we have achieved predictability.

Also, because this code is predictable, we can do some other things like for example, function composition and recursion... Well, you can do recursion in other languages as well, but it's way more efficient in functional languages, because of pure functions, which allow for a more efficient implementation and the compiler optimizes such code.

> In reality, most FP languages actually help us minimize our side effects and thus reduce our code complexity.

— @krisajenkins



### Runtime exceptions

Runtime exceptions are something we all hate, they sneak up on you when you least expect it, most of the time you don't know why and you to go through your development-production cycle once again. A real time/mood killer. This is one of the biggest reasons I love functional programming, it tells me what's wrong at compile time, so most of the time we won't have any runtime errors. Predictability + 1.

There are some other reasons why there are almost no runtime errors though:
- There is no null type or any kind of null pointers.
- All the data structures need to be defined in detail.
  For example, JSON, which can be very unpredictable.
  <small>(I'll show some examples in a bit).</small>

And you know, Elm is actually amazingly great at this, "no runtime errors" is listed as one of its main features. Though, you might ask, how is it able to do that? TBH, it's a bold claim.

1. **Type inference**. Static typing helps a LOT. Plus, Elm and Haskell have awesome type systems.
2. **A bunch of really smart assertions**. For example, Elm detects if you have a recursive function that never terminates, an infinite loop. Or, another example, it even detects infinite types, which are really hard to find. All of these are found at compile time.



## What, not how

### Type systems and data modelling

In Elm and Haskell we have a great type system which we can use to make sure that our data stays in a specific format and that we can avoid impossible states.

```elm
module Wheels exposing (..)

type Longboard = Downhill | Cruise | Slide
type Skateboard = Hard | Soft
```

```elm
import Wheels

type Board
    = Longboard Wheels.Longboard
    | Skateboard Wheels.Skateboard

longboard : Board
longboard =
    Longboard Wheels.Cruise
```

For example, here we have some code that builds a board, which is either a skateboard or a longboard. The tricky part though, is that each type of board has some specific types of wheels. Like we have the bigger wheels for sliding, those only fit on a longboard, so we avoided that impossible state. **Meaning that, if I would try to make a skateboard with longboard types of wheels, it would just give me a compiler error.**

```elm
action : Board -> Action
action board =
    case board of
        Longboard Wheels.Cruise     -> ToTheCity
        Longboard Wheels.Downhill   -> IntoTheHills
        Longboard Wheels.Slide      -> IntoTheHills
        Skateboard Wheels.Hard      -> ToTheSkatePark
        Skateboard Wheels.Soft      -> ToTheCity
```

With these _Union types_ (or _sum types_) we have a great way to model our data. So it becomes more a question of “What data do I have and what exactly am I going to do with it” instead of “How do I manipulate my data to get what I want”. You can see that in this example. And if I would omit one of the possible cases or if I would add an impossible case, I would get a compiler error.

You could say that functional programming forces you to think about the problem you're dealing with, figuring out the path of least resistance, instead of going straight to keyboard smashing.

#### Pattern matching

Speaking about `case` statements. There's this thing called pattern matching. This is a neat feature we can use to make our code more predictable. Here's another example:

```elm
{- Create an action based on a list of actions. -}
reduceActions : List Action -> Action
reduceActions actions =
    case actions of
        [] -> DoNothing
        [a] -> a
        [a, b] -> multitask a b
        action::other -> doActionAndQueueOther action other
```

This function is a bit complex, but quite easy to follow because of the pattern matching `case` statement. What happens is we take a list of <x-cl-2>Action</x-cl-2>'s and reduce it to a single <x-cl-2>Action</x-cl-2>. The logic goes as follows:

- If we get an empty list, the action is <x-cl-2>DoNothing</x-cl-2>.
- If we get a list with a single action, do that action.
- If we get a list with two actions, make an action which is a multitasking action.
- If we get a list with more than two actions, make an action in which we first do the first action in the list and then sequentially do the other actions.

Really useful stuff 👌

#### Maybe

Probably the most common thing that we have to do when dealing with data in dynamic languages is handling `null`, which are the cause of so many runtime errors. In functional languages there is no null type, but instead you have the <x-cl-2>Maybe</x-cl-2> type or the <x-cl-2>Option</x-cl-2> type. These are also sometimes found in non-functional languages like, for example, Rust.

You can see by its definition that these types are really simple, but incredibly useful.

```elm
type Maybe a = Just a | Nothing
```

Maybe it's something of the type `a` or maybe it's nothing.  
Here's how you can use it:

```elm
case List.head interesting_things_to_watch_on_tv of
    Just tv_show -> ...
    Nothing -> ...
```

Maybe we get a tv show from the list or maybe we don't. **It forces you to explicitly define what to do when there's nothing left to watch, after all, there are only so much interesting things on tv.** The cool thing about this is that this leads to interesting design patterns, like in this example:

```elm
what_to_do : Action
what_to_do =
    interesting_things_to_watch_on_tv
    |> List.head
    |> Maybe.map WatchTv
    |> Maybe.withDefault GoOutside
```

This is saying that we're going to watch tv when something interesting is on, and otherwise we're going outside. Or we could take this a step further and introduce chains:

```elm
decide_binge_watch : Bool -> TvShow -> Maybe Action
decide_binge_watch got_snack_supply tv_show =
    if got_snack_supply == True then
        Just (Watch tv_show)
    else
        Nothing

what_to_do : Action
what_to_do =
    interesting_things_to_watch_on_tv
    |> List.head
    |> Maybe.andThen (decide_binge_watch True)
    |> Maybe.withDefault (GoOutside)
```

Now we decided to only watch tv if there is an interesting show **and** we can binge watch it. We are pretty lazy so the only requirement is to have enough snacks in the house 😁 That said, we only need to decide this if there is an interesting show to begin with.

This reasoning is reflected in the code, the `Maybe.andThen` function will only call our `decide_binge_watch` function if there is an interesting tv show, otherwise it just skips it.

#### More advanced

This mode of reasoning really shines in JSON encoding and decoding, because JSON data is full of maybes. Here's an example from the [Elm docs](http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode#maybe):

```elm
json = """{ "name": "tom", "age": 42 }"""

decodeString (maybe (field "age"    int  )) json == Ok (Just 42)
decodeString (maybe (field "name"   int  )) json == Ok Nothing
decodeString (maybe (field "height" float)) json == Ok Nothing

decodeString (field "age"    (maybe int  )) json == Ok (Just 42)
decodeString (field "name"   (maybe int  )) json == Ok Nothing
decodeString (field "height" (maybe float)) json == Err ...
```

Maybe we have a field called `height`, maybe we don't. Or another scenario, we do have a field called `height` and maybe the type of its value is a float.

In the first scenario, if we wouldn't have that field, the result would be `Ok Nothing`, or in other words, the parsing went fine but we didn't find a value. In the second scenario, if we wouldn't have that field, we would get an `Err`, because it tries to parse something that isn't there. **This goes to show how far you can go in predicting things.**

#### What about Haskell?

Like I said in the beginning, Elm is functional programming without the difficult terminology. But if you would like to get started with Haskell, it's useful to know about [functors, applicatives and monads](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html). Small hint, `Maybe` implements all of these. That said, pattern matching, union types, etc. all use pretty much the same syntax. The only difference is that sometimes different keywords are used (eg. in Elm you say `type A`, but in Haskell you'd say `data A`). Other than that, the libraries are somewhat different in Haskell. For example, `Data.List.head` in Haskell doesn't return a `Maybe`, but that's just a matter of reading documentation.

Anyhow, to go back to the functors and things. These things are abstractions, like a set of [algebraic laws](https://en.wikiversity.org/wiki/Basic_Laws_of_Algebra) and [abstract algebra](https://www.youtube.com/watch?v=IP7nW_hKB7I). In Haskell these abstractions take the form of type classes, a common set of laws that apply to types.

```haskell
class Monoid m where
    mempty :: m                 -- The identity.
    mappend :: m -> m -> m      -- An associative binary operation
                                -- which is closed.
```

In this example we have the type class `Monoid`. A monoid has an identity element and it has an associative binary operation which is closed. The **identity element** here is a function that returns the value itself. **Associative** means that the operator has two arguments and the order of the arguments doesn't matter. And **closed** means that the two arguments and the return value are all of the same type.


### Refactoring

We all need to do it though, the more the better.
So why not make it easy?

```elm
type alias Attributes =
    { refactoring : Bool
    , easy : Bool
    }

makeAttributes : Attributes
makeAttributes =
    { refactoring = True
    }
```

Functional code is also incredibly easy to refactor, this goes hand in hand with the prevention of runtime exceptions. It's easy to refactor because, take for example, records. **Whenever we add or change a field from a record, the compiler tells us where we still have to add or change that field.**

For this example, Elm will tell us that our <x-cl-6>makeAttributes</x-cl-6> function should return a record of the type <x-cl-2>Attributes</x-cl-2>, but that it currently is returning a record without the `easy` field. So if we then just add that `easy` field, <x-cl-6>makeAttributes</x-cl-6> will return something of the type <x-cl-2>Attributes</x-cl-2>. Problem solved!

> You just can't miss any spots to fill in or update, so you no longer need to think about those things. You can refactor without the additional stress. More time to focus on the important pieces of the puzzle

— Me



## Closing thoughts

I think functional programming and static typing helps our code a lot, so let's use it more. What are your thoughts on this subject? Or did I make a mistake somewhere in this article? Let me know via [Twitter](https://twitter.com/icidasset) or some other platform [where you can find me](http://icidasset.com) on.

> Treat your code like poetry and take it to the edge of the bare minimum.

— Ilyo


*<small>Credits: Thanks to [Brooklyn Zelenka](https://twitter.com/expede)
and [Kris Jenkins](https://twitter.com/krisajenkins)
for the inspiration!</small>*
