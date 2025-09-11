--[[
    -- Type: Module
    -- Name: XML
    -- Use: Utility helpers for building XML documents
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local ops = {}

local meta = {}
function meta:__index(op)
        assert(ops[op], ("No such function %s on XML object"):format(op))
        return function(self, ...)
                self.ops[#self.ops+1] = {op=op, args={...}}
                return self
        end
end

-- XML:insert
local function append(self, xml)
	for _, op in ipairs(xml.ops) do
		self.ops[#self.ops+1] = op
	end
	return self
end

-- XML:serialize
--[[
    -- Type: Function
    -- Name: serialize
    -- Use: Converts queued operations into a formatted XML string
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function serialize(self)
        local state = setmetatable({
                indent = 0,
                elems  = {},
                out    = '<?xml version="1.0" encoding="UTF-8"?>\n\n'
        }, {__index=ops})
        for _, op in ipairs(self.ops) do
                ops[op.op](state, table.unpack(op.args))
        end
        return state.out
end

--[[
    -- Type: Function
    -- Name: XML
    -- Use: Factory for creating new XML builder objects
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function XML()
        return setmetatable({
                ops={},
                append=append,
                serialize=serialize
        }, meta)
end



-- Serialization
--[[
    -- Type: Function
    -- Name: line
    -- Use: Appends a raw line to the output buffer
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function ops:line(line)
        self.out = self.out..("  "):rep(self.indent)..line.."\n"
end

--[[
    -- Type: Function
    -- Name: comment
    -- Use: Adds an XML comment to the document
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function ops:comment(msg)
        self:line(("<!-- %s -->"):format(msg))
end

-- {value="0.03"} -> 'value="0.03"'
local function attributes(attrs)
        local out = ""
        for k,v in pairs(attrs or {}) do
                out = out..(' %s="%s"'):format(
                        tostring(k),
                        tostring(v):gsub([["]], [[\"]])
                )
        end
        return out
end

--[[
    -- Type: Function
    -- Name: void
    -- Use: Outputs a self-closing tag with attributes
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function ops:void(tag, attrs)
        self:line(("<%s%s />"):format(tag, attributes(attrs)))
end

--[[
    -- Type: Function
    -- Name: inline
    -- Use: Outputs a tag containing inline content
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function ops:inline(tag, content, attrs)
        self:line(("<%s%s>%s</%s>"):format(tag, attributes(attrs), content, tag))
end

--[[
    -- Type: Function
    -- Name: open
    -- Use: Opens a new tag and increases indentation
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function ops:open(tag, attrs)
        self:line(("<%s%s>"):format(tag, attributes(attrs)))
        table.insert(self.elems, tag)
        self.indent = self.indent + 1
end

--[[
    -- Type: Function
    -- Name: close
    -- Use: Closes the most recently opened tag
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function ops:close()
        self.indent = self.indent - 1
        local tag = table.remove(self.elems)
        self:line(("</%s>"):format(tag))
end

