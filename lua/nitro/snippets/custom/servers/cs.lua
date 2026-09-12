local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("cs", {
  -- Console.WriteLine
  s("cwr", fmt([[Console.WriteLine({});]], { i(1) })),

  -- Class
  s(
    "class",
    fmt(
      [[
    public class {}
    {{
        {}
    }}
  ]],
      { i(1, "ClassName"), i(2, "// members") }
    )
  ),

  -- Main method
  s(
    "main",
    fmt(
      [[
    static void Main(string[] args)
    {{
        {}
    }}
  ]],
      { i(1, 'Console.WriteLine("Hello World");') }
    )
  ),

  -- For loop
  s(
    "for",
    fmt(
      [[
  for (int {} = 0; {} < {}; {}++)
  {{
      {}
  }}
]],
      { i(1, "i"), rep(1), i(2, "n"), rep(1), i(3, "// code") }
    )
  ),

  -- If statement
  s(
    "if",
    fmt(
      [[
    if ({})
    {{
        {}
    }}
  ]],
      { i(1, "condition"), i(2, "// code") }
    )
  ),

  -- Property
  s(
    "prop",
    fmt(
      [[
    public {} {} {{ get; set; }}
  ]],
      { i(1, "string"), i(2, "PropertyName") }
    )
  ),

  -- get/set
  s("get", t("{ get; set; }")),

  -- get/init
  s("geti", t("{ get; init; }")),

  -- Full Program Skeleton
  ls.add_snippets("cs", {
    s(
      "prog",
      fmt(
        [[
    using System;

    namespace {}
    {{
        class {}
        {{
            static void Main(string[] args)
            {{
                Console.WriteLine("Hello World");
            }}
        }}
    }}
  ]],
        { i(1, "MyNamespace"), i(2, "Program") }
      )
    ),
  }),
})
