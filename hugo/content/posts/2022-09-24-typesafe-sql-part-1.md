---
title: "Typesafe SQL - Part 1"
date: 2022-09-24
draft: false
tags: ["c#", ".net core", "programming"]
showToc: false
diagrams: true
---


SQL is like a universal skill you aquire once and can use anywhere you work with when storing data.
In whatever environment I'm in, whichever programming language I'm using, it is still the same.

There are plenty of libraries and frameworks out there to integrate it in your favorite language.
Also they follow usually one of two styles:
- Full abstraction in form of a full ORM
- Partial abstraction in form of a micro ORM
- Raw in form of hand written SQL

Each has their individual pros and cons in one form or another. 

Full ORMs come with an optionated approach you have to follow and are limited to but usually are enough for most of the CRUD apps out there.
But they can not provide the same functionality as raw SQL. In case you need more complex queries you usally resort to hand written SQL.
In .NET world the most common full ORM is Entity Framework. 

They include
 - Connection handling & database driver
 - Object mapping
 - Types safe querying and executions
 - Mitigating attack vectors (Prepare statement), e.g. Escpaing / SQL injection 
 - Optionated models
 - Additional overhead (performance decrease)
 - Database scheme migrations

For hand written SQL I as a programmer have to take care of a lot more details. The most basic ones are mapping the results of a query to a structure I can further use and making sure that no attacks from untrusted input are possible, mostly known as SQL injections and so on. Usually standard libraries are used for
 - Connection handling & database driver
 - Pure performance
 - Sometimes mitigating attack vectors (Prepare statement), e.g. Escpaing / SQL injection 

Micro ORMs aim for the sweet spot of both of those. They don't have an optionated view on how something is done, provide mapping of results to an structure which is useable and mitigates attack vectors.
 - Connection handling or utilizing default connection handling & database driver
 - Object mapping
 - Mitigating attack vectors (Prepare statement), e.g. Escpaing / SQL injection 

Personnally I like full ORMs when looking at for example Django. It's very powerful and usually easy to set up and works out of the box. Nonetheless I had issues with the setup of Entity Framework when there is already a database existing and integrating it to a existing project. Many hours spent to check for error messages which should not have appeared... I guess partly my fault for doing something wrong. But that is exactly the point - when I had used a micro ORM or hand written SQL I would have been definitly more productive because of my previous experiences.

Hand written SQL without sanity is dangerous. Sometimes I like dangerous but not in this context. Mitigating those dangers is definitly possible but I don't trust doing that myself. There are too much hurdles and corner cases I might miss. Usually there are helpers available in the form of "Prepared statements" for example. But using them requires definitly more lines of codes and are then again more abstract not standard SQL.

As you might have guessed I prefer micro ORMs. They provide me with sanity, are usually quick to setup and don't get in my way when I want to things my way because I feel thats in a given context the best solution. Also they only add very little overhead to each statement I throw at a database.
When talking about C# I prefer Dapper - it's perfect in doing what it does. It also has it's little quirks (e.g. query results of a couple of differenct classes/objects) but it's manageable and from a cost-benefit relation a good compromise.

Nonetheless I miss specifically one feature I want and like in compiled, typed languages: type checking.

That's why I will try to add this in an extra library which can be used. It's goals are:
 - **(Goal)** Native SQL experience (writing SQL statements)
 - **(Goal)** Type safe queries and executions
 - **(Goal)** Zero-cost abstractions
 - **(Goal)** No performance penalties
 - **(Goal)** Easy and transparent user experience
 - **(Goal)** Support most common databases (SQLite, PostgreSQL, MSSQL, Oracle, MySql, MariaDB)

Let's see what we can fulfill and where we have to draw the line to not create another full ORM.
Instead we aim for a sweet spot between micro ORMs and full ORMs.

Ideally we don't care about any of that ORM stuff mentioned before. What we care is that we are able craft valid and safe SQL statements.
Whatever libraries or frameworks you use - meaning you could even use it in full fledged ORMs when you need to resort to manual SQL statements again because of whatever reason (e.g. complexity).

Out of scope is definetly:
 - Connection handling & database driver
 - Database scheme migrations
We only care about SQL. There are enough and very good libraries out there - mostly from official sources. We don't want to touch that.

As you can imagin I was looking for something like this already on "the market". But to be honest I couldn't find anyting like it in .NET world, neither on Nuget nor on Github (totally possible I missed something).
But... I found something in Java world: [jOOQ](https://www.jooq.org).

This seemed exactly what I was looking for. You are able to write abstracted SQL with type safety and it's really easy to use. You need to take care of some stuff like Code Generation to make type checking possible but hey... somewhere the information for our compilers need to come from and it seems a reasonable approach.
What I did (and do) not like is the added performance overhead but jooq does querying and executing all by itself so there might not be too much overhead involved. To be honest I did not thoroughly check it as I am more of a .NET kid.

So the journey began to look for something similar in .NET. I found [cooq](https://sourceforge.net/projects/cooq/) but it seems abandoned and also not 100% what I'm looking for even so it was like 90% there.
Then there is also a reference to [Typed Query](https://github.com/EndsOfTheEarth/Typed-Query) - this is incredible! Exactly what I was looking for !
I thought... and realised it still does not fulfill my desire for full type checked SQL.
Let's not sound too pesimstic - I got to now lots of important and very good information. I can learn a lot and use it wisely.

In the end I decided to create such a library myself with the knowledge I got from jOOQ and Typed Query.
Use principles from Typed Query and jOOQ, meaning:
We need some kind of code generation and method chaining as we know it from functional programming and thus Linq.

I'm trying to make it work like this:
```C#
Select(Tbl_Cards.Id(), Tbl_Cards.Name(), Tbl_Cards.Form().As("colA"))
.From<Tbl_Cards>()
.Where(Tbl_Cards.Id().Greater(10))
.OrderBy(Tbl_Cards.Id())
.Limit(50)
```
To get a corresponding SQL string:
```SQL
SELECT id, name, form AS colA
FROM cards
WHERE id > @0
ORDER BY id
LIMIT @1
```

I still want to use Dapper as it does a fantastic job. We only need to provide input for Dapper or provide an additional abstraction layer.

One of our goals is also "zero-cost abstractions"... let's see if we can do this somehow with new source generation of .NET 5.
We might can get rid of method chaining and thus additional overhead by replacing the method chaining during compile time with a static string.
Then we would have the same behaviour as we would use Dapper only.

This might look then like this:



{{<mermaid title="Type safe SQL flow">}}
graph TD;
    
    C["Code generated database schema"] --> T["Type safe SQL writing in C#"]
    T --> G["Generate SQL string during compilation"]
    G --> R["Results in SQL and parameters"]
    R --> I["Input for and execution with Dapper"]
    I --> D["Dapper provided objects"]
    
{{</mermaid>}}

It might be possible in the future to do something similar as Typed Query and jOOQ to directly execute our "method chains" against a database.
But that's very far in the future and this is not something desirable - it's hard.
A better approach would be to use Dapper under the hood and just call it's extension methods with own extension methods.

{{<mermaid title="Future type safe SQL flow">}}
graph LR;
    
        T["Type safe SQL methods in C#"] --> D["Dapper provided objects"];
    
{{</mermaid>}}

But let's not get ahead of ourselves, one step at a time - first start with our foundation, meaning: SQL and parameters.


## SQL dialects
To make things more compliacted: there are multiple SQL dialects out there - perfect.
Ideally we want to support the most common SQL dialects out there and if there is a new one it should be easy to integrate it as well.
Isn't there a "standard" for it... ? Ah, yeah, right there is one.

Don't get me started on those standards.

So we will pick a database which we use to start of which also has a good documentation on it's syntax.
You might have guessed it: Either PostgreSQL or SQLite.
Not bad, we choose SQLite.

Why? Because it's easy to setup and I like it - most applications/websites do not need more than SQLite.
It also has great documentation and we do even get some nice flow diagrams of SQL with abstractions and hints for code reusage !
I'm still amazed what is possible with a file system and some well written code - unbelivable, really, I mean it.
 - **(Requirement)** Support as a first step SQLite

Next issue is data types... oh man. This is something I don't like about SQLite. Why not do it like others... even if you don't want to but please... at least Date and Time data types 👀🤔. Date and Time is hard to get right... so I would have really preferred defaults.
Well not something we can change now, let's make the best out of it and do it like other providers... with a bit of configurable magic. 

In the end we need to map types to what we have available in C#. Because we have less data types available in C# we need to do a 1:n mapping. In case of SQLite this should be fine but in for other SQL dialects such as PostgreSQL we might need to think about how to type check also for example floating points.
 - **(Requirement)** Create mapping from database data types to common C# data types


## Opinons and configuration
This section is more like a coding practice I follow (and nothing new at all)... I might make this a separate post...

You might have guessed it by reading until know - I'm not really a fan of optionated code. There is a fine line of bringing in enough opinions to make it work and to overdo it. Not everyone shares the same opinion on whatever topic - thats life. So keep them out where ever possible.
In code you can use optionated defaults but they should be configurable when possible. Obviously there are design decisions, etc. where it's simply not possible to do so.

Let's take an example of code generation. Obviously the way classes are generated needs to be fixed somehow, else your logic might not work anymore. But for example class names can be variable. When we are generating a class for a table it shouldn't and can't matter if it is called "Table_<classname>" or "Tbl_<classname>" or "<classname>" - with limiations that it cannot conflict with other class names in a given name space, key words, etc.
Why you ask? Because there are things like linters, code guidelines, etc. which vary a lot.

As a general thumb of rule:
 - Don't use magic in your code (fixed strings, numbers, etc.)
 - Make it configurable (and thus transparent)
 - Provide optionated defaults (best practice, etc.) for simplicity


## Performance
Even if we talk a lot about "move fast and break things" (I didn't and don't like this statement at all - it's against everything we should do as engineers full stop.) or just simply "shipping features" there is one thing which might not appear in a requirement catalog but is always present: Performance.
Not once in my entire life there was an application where performance was not important. There are different minimum and maximum requirements for everything but once it's breached, performance matters. It has always been like this and it will always be.

I don't care what managers of companies say - performance has direct impact on user experience.
It decides if something we built is pleasent to use. And that should be the ultimate goal.
You can give me a software where I only have to do 1 click to get my desired result in 10 seconds or a software where I have to click 3 times and get my result in 5 seconds. I will always choose 5 seconds over 10 seconds (maybe because we can automate those 3 clicks to 1 as well by ourselves 😂).
Those 5 seconds will feel and will be more productive than 10 seconds.

Because performance is based on multiple levels (we don't usually write machine code in C#, right) we need to take care on each level we add.
This should also be the case for what we will be doing.
Of course what we want is correctness (incorrectness may be worse than performance because you can't get something done) but we should always also look at performance. Rust is a perfect example for this in my book with their zero-cost abstractions - brilliant ideas made reality.

Obviously it might come at costs of added complexity but as always we need to find the sweet spot - that's life. Nothing is perfect and we always need to wage what is best in which situation. Rust took the approach to make their language more complex to reach their goals of correctness which in the end results in more productivity because of less errors in whatever level even if it costs us engineers more.

Anyway, our goal is the same as in Rust: "zero-cost abstractions". We will check for this with:
 - **(Requirement)** [Benchmarks](https://benchmarkdotnet.org) against hand written SQL (ideally it's the same because we also generate static strings)

 What we can't measure is how often someone rewrites their incorrect static SQL statements 😉


## Code generation
Somehow we need to represent a database scheme in a way our compiler can work with.

For this we are going to use code generation to create classes, methods, properties, etc. to create a correct representation. This will be the basis for the whole functionality we are going to provide. 

We need to make sure that code generation is easy to use and you **can't break** things easily.
 - **(Requirement)** Code generation has to be error prone and transparent in what it is doing. 

Wether it is 
 - reading a database scheme, 
 - creating classes,
 - removing classes or
 - throwing errors

Removing classes might also occur because of a removed table. We need to make sure that even this case is supported and we don't leave any artifacts behind which do not even exist anymore. Without considering this use case it can easily break one of our goals to provide type checking - when the type should not exist anymore.

Changes or extensions to database schemes are basically happening daily. So we need to consider that the code generation for the same database is also used daily. Code generation needs to work as only with updated classes the compiler recognizes that tables, types, etc. changed and we might need to adjust our codebase.
This is one of our goals. 

This also means that not only the results of code generation are usually part of some kind of source control but also the input should be part of it.
Else we might not be able to recreate code in the same manner as in an earlier point of time. This will result in an additional requirement:
 - **(Requirement)** Make input (configurations) for code generation available in a controlled way (e.g. configuration file)


## Dynamic SQL
Not everything we can do in SQL needs to be present in a database scheme. Still, we should try our best to also support those scenarios.
For example it is really easy with "VALUES" statements or "WITH" table expressions to create tables on the fly for one specific statement. We should definetly provide solutions for those scenarios as well.

In those scenarios code generation does not help at all. It might be necessary that in order to get type checking, hand written classes are necessary.
 - **(Requirement)** Allow usage of hand written classes when code generation is not possible


## Classes and method chaining
In order to provide type safe SQL we need classes and methods for easily creating SQL statements.
Basically for every key word there needs to exist a class and most likely multiple methods to provide method chaining.
Then we also need to consider different SQL dialects, some have additional specific key words which integrate to existing keywords.

This will result in a lot of classes and methods to be created possibly for each SQL dialect. Resulting in possibly times N the number of classes (where N = Number of supported SQL dialects) - doing so by hand is where most of the work is.

It might be worth looking into a kind of meta language which is then used for code generation for the type safe SQL library itself.
There should reside the logic which classes and which methods with which parameters to create.
This will make it easy to enter new keywords and define how the method chaining should look like.
There can then also different SQL dialects be supported easily.
Usually every SQL dialect has flow charts and documentation in which it is clearly visible what keywords are necessary and how they can be combined with each other.
 - **(Requirement)** Generate type safe SQL classes and methods with meta language



This is it for now... more to come in the next parts of the series.

<script async src="/assets/js/mermaid.min.js"></script>