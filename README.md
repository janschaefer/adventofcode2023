# Advent of Code 2023

These are my solutions for [Advent Of Code 2023](https://adventofcode.com/2023). My plan is to solve every puzzle with a different programming language, in alphabetical order. I make use of ChatGPT to help me with the programming language, however, I will not use it directly to help me solve the problem. In addition, I make use of the Replit AI code completion with the same intention.


| Puzzle | Programming Language | Status | Replit | ChatGPT | Experience |
| -------| ---------------------|--------|--------|---------|------------|
| [1](01/main.c) | [C](https://www.iso.org/standard/74528.html) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202301) | [ChatGPT](https://chat.openai.com/share/c485697a-da04-4e53-aa73-4d4d9220a598) | String manipulations with C are awful. It took me ages to just get a substring from a string and I most likely introduced a memory leak ;-) |
| [2](02/main.cpp) | [C++](https://isocpp.org/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202302) | - | Much better than C due to standard library functions |
| [3](03/main.cs) | [C#](https://learn.microsoft.com/en-us/dotnet/csharp/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202303) | [ChatGPT](https://chat.openai.com/share/3769f2d7-a019-43e6-9454-100d7ac5e75d)| I feel nearly at home, because it is like Java ;-). My solution could have been more elegant, but I solved this one much faster than the other two. |
| [4](04/main.clj) | [Clojure](https://clojure.org/)  | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202304) | [ChatGPT](https://chat.openai.com/share/22e255fd-13e4-44db-956a-b97fedf4d9d8) | Took me ages to deal with a cryptic EOF error and syntax is hard to read for my eyes, but otherwise it was quite fun to think in a functional style. This puzzle took me longer than any other one so-far, but the solution is the most elegant one ;-) |
| [5](05/main.dart) | [Dart](https://dart.dev/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202305) | [ChatGPT](https://chat.openai.com/share/fc28f96a-251b-4875-b53d-53703e52c835) | Dart feels a lot like Java, not sure why Dart exists at all, but maybe I had not really hit the interesting features of the language with the puzzle, like the concurrency model. I had no real issues with the language. My Replit ran out of AI credits ;-) |
| [6](06/main.exs) | [Elixir](https://elixir-lang.org/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202306) | [ChatGPT](https://chat.openai.com/share/f65534c0-6d1d-43e3-ae18-987eeb5bbcd1) | Beeing a purely functional language without loops I struggled a bit until I was able to create an iteration that stops at some point. Elixir has also a quite special syntax in some cases. |
| [7](07/main.erl) | [Erlang](https://www.erlang.org/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202307) | [ChatGPT](https://chat.openai.com/share/e4886a2a-52fe-4494-b3f5-705da823f46a) | Erlang was the hardest language for me so far. I struggled with the syntax, with the error messages, even with just printing strings to the console. I even had to read the documentation, because ChatGPT could not help me enough. Erlang is very different to common languages, just to name a few things: Variables have to be written with an upper case letter, counting starts at 1 and not at 0, you end functions with a dot. It feels like the language was developed by a person that wanted to do everything different. No wonder Elixir exists :-). |
| [8](08/main.fs) | [F#](https://fsharp.org/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202308) | [ChatGPT](https://chat.openai.com/share/5f3b2a75-a1fe-4415-9d52-45ce87efdf75) | F# itself is a quite nice functional language. Sometimes I struggled a bit with the syntax, but overall the language was not a big problem. What was more annoying was the second part of the puzzle itself, which was quite difficult to solve if you did not come up with the right idea. This puzzle took me way too much time to solve. |
| [9](09/main.go) | [Go](https://go.dev/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202309) | [ChatGPT](https://chat.openai.com/share/17a61954-9b3d-4d03-9cec-da0a7e805867) | Wow, Go has no map function? Seriously? Even ChatGPT was surprised :-). After all the functional languages before, I now needed to program imperatively again :-(. And the puzzle was suprisingly simple compared to the previous one, so that I was much faster done than in any other puzzle before. I was even sligthly disappointed that there was not big surprise in part 2 of the puzzle ;-) |
| [10](10/Main.hs) | [Haskell](https://www.haskell.org/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202310)| [ChatGPT](https://chat.openai.com/share/2e0d4a34-f98e-4c6d-b470-f0026426d1a0) | Haskell, the mother of all functional languages, is certainly one of the most interesting languages that exist, but also quite hard to learn. As I was already familiar with Haskell, it was not so difficult for me to use the language. I struggled more with the puzzle itself. Especially the second part was very hard if you don´t come up with the right idea. It took me way too long to solve and I needed help from ChatGPT to get to the idea. The resulting solution in Haskell is also very slow and takes over 10 minutes to finish. I am not sure why it is so slow, I assume the free Replit that I used, just has not enough RAM for Haskell. There is certainly also a more elegant solution than mine. |
| [11](11/Main.java) | [Java](https://openjdk.org/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202311) | [ChatGPT](https://chat.openai.com/share/1e1c9243-914a-4c2d-90bb-ce31aeda5698)| Nothing special to say from my side, as Java is the language I know best. However, Java is not the most elegant language for these kind of programming tasks. |
| 12 | [JavaScript](https://nodejs.org/) | ⭐ | | | Still working on part 2... |
| [13](13/main.kt) | [Kotlin](https://kotlinlang.org/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202313) | [ChatGPT](https://chat.openai.com/share/1d4b9019-54e0-4c72-9389-fc55ed5050e6) | I always wanted to try out Kotlin, but never did so far. As a Java developer it was a very pleasant experience, better than the Java experience :-). The Replit compiler was quite slow and it took about one minute for each run, which was annoying. |
| [14](14/main.lua) | [Lua](https://www.lua.org/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202314) | [ChatGPT](https://chat.openai.com/share/a4929234-62d8-45fc-8b49-22542464b63c) | Lua is a very minimalistic language, so it lacked some library functions that are typically available in other languages and it counts from 1 instead of 0. Otherwise it was quite easy to learn |
| [15](15/main.ml) | [OCaml](https://ocaml.org/) | ⭐⭐ | [Replit](https://replit.com/@janschaefer0/AdventOfCode202315) | [ChatGPT](https://chat.openai.com/share/8a45f3d5-938a-47b9-8a38-c79968e3eaaa) | OCaml is another language that I always wanted to try out. It is a nice functional programming language with a really powerful type system. I liked it. It is quite similar to F#. |
| 16 | Perl | | | | |
| 17 | PHP | | | | |
| 18 | Python | | | | |
| 19 | R | | | | |
| 20 | Ruby | | | | | 
| 21 | Rust | | | | |
| 22 | Scala | | | | |
| 23 | Swift | | | | | 
| 24 | TypeScript | | | | |
| 25 | VisualBasic | | | | |


