local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("css", {
  -- Display Flex Center
  s("dfc", fmt([[
display: flex;
justify-content: center;
align-items: center;
]], {})),

  -- Flex Row
  s("dfr", fmt([[
display: flex;
flex-direction: row;
]], {})),

  -- Flex Column
  s("dfcol", fmt([[
display: flex;
flex-direction: column;
]], {})),

  -- Space Between
  s("dfsb", fmt([[
display: flex;
justify-content: space-between;
align-items: center;
]], {})),

  -- Space Around
  s("dfsa", fmt([[
display: flex;
justify-content: space-around;
align-items: center;
]], {})),

  -- Grid Center
  s("dgc", fmt([[
display: grid;
place-items: center;
]], {})),

  -- Absolute Center
  s("ac", fmt([[
position: absolute;
top: 50%;
left: 50%;
transform: translate(-50%, -50%);
]], {})),

  -- Position Absolute
  s("pa", fmt([[
position: absolute;
]], {})),

  -- Position Relative
  s("pr", fmt([[
position: relative;
]], {})),

  -- Width Height
  s("wh", fmt([[
width: {};
height: {};
]], {
    i(1, "100%"),
    i(2, "100%"),
  })),

  -- Border Radius
  s("br", fmt([[
border-radius: {};
]], {
    i(1, "8px"),
  })),

  -- Transition
  s("tr", fmt([[
transition: all 0.3s ease;
]], {})),

  -- Box Shadow
  s("bs", fmt([[
box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
]], {})),

  -- Text Overflow Ellipsis
  s("toe", fmt([[
overflow: hidden;
text-overflow: ellipsis;
white-space: nowrap;
]], {})),

  -- Full Screen
  s("full", fmt([[
width: 100vw;
height: 100vh;
]], {})),

  -- Reset Margin Padding
  s("reset", fmt([[
margin: 0;
padding: 0;
box-sizing: border-box;
]], {})),

  -- Glassmorphism
  s("glass", fmt([[
background: rgba(255, 255, 255, 0.1);
backdrop-filter: blur(10px);
border-radius: 12px;
]], {})),

  -- Media Query
  s("mq", fmt([[
@media (max-width: {}px) {{
  {}
}}
]], {
    i(1, "768"),
    i(2),
  })),
})
