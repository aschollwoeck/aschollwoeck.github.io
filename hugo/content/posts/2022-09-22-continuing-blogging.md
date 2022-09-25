---
title: "Continuing blogging"
date: 2022-09-22
draft: false
tags: ["blog"]
showToc: false
---



Hello dear readers,

as I have teasered in my post before we will have a talk about SQL.

- Example of sql with wrong types
- Example of sql with wrong types which could be catched by compiler
- Reference to jooq
- Code generation
- Source Code generator in .NET 5/6





I'm plan on doing a write up the next couple of days of a project of mine regarding C# and SQL. I favor wrting SQL myself but I want to have some verifications in my code. In C# I want the compiler to do the job for me. This way we pay a price up front and spending some micro or milliseconds of compute power for the compiler but we are sure to be type safe and we can get ride of a whole category of potential problems.

We won't get the same performance as writing static strings in our code but it's fine if we pay 1 additional millisecond per request. We might even be able to get rid of some of the introduced overhead when looking at the new code generation feature in .NET 6 - let's find out.