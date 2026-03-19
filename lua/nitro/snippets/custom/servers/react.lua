local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local react_snippets = {
  -- useState
  s("us",
    fmt("const [{} , set{}] = useState({});",
      { i(1, "state"), rep(1), i(2, "null") })
  ),

  -- useEffect
  s("ue",
    fmt([[
React.useEffect(() => {{
  {}
}}, [{}]);
]], { i(1), i(2) })
  ),

  -- useRef
  s("ur",
    fmt("const {}Ref = useRef({});",
      { i(1, "ref"), i(2, "null") })
  ),

  -- Event handler
  s("handler",
    fmt([[
const handle{} = (e) => {{
  {}
}};
]], { i(1, "Click"), i(2) })
  ),

  -- Props destructuring
  s("des",
    fmt("const {{ {} }} = props;", { i(1, "prop") })
  ),

  -- useMemo
  s("um",
    fmt([[
const {} = useMemo(() => {{
  {}
}}, [{}]);
]], { i(1, "value"), i(2), i(3) })
  ),

  -- useCallback
  s("uc",
    fmt([[
const {} = React.useCallback(() => {{
  {}
}}, [{}]);
]], { i(1, "callback"), i(2), i(3) })
  ),

  -- Map render
  s("map",
    fmt([[
{{{}.map((item, index) => (
  <{} key={{index}}>
    {}
  </{}>
))}}
]], { i(1, "data"), i(2, "div"), i(3, "{item}"), rep(2) })
  ),

  -- Conditional render
  s("cond",
    fmt("{{ {} && ({}) }}", { i(1, "condition"), i(2, "<Component />") })
  ),

  -- Async fetch
  s("fetch",
    fmt([[
const fetchData = async () => {{
  try {{
    const res = await fetch({});
    const data = await res.json();
    {}
  }} catch (err) {{
    console.error(err);
  }}
}};
]], { i(1, "'/api'"), i(2) })
  ),

  -- React Fragment shortcut
  s("frag",
    t({ "<>", "  ", "</>" })
  ),
}

ls.add_snippets("typescriptreact", react_snippets)
ls.add_snippets("javascriptreact", react_snippets)
